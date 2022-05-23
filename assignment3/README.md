# 词法分析（上）

本次实验准备借助 `lex` 写一个 C 语言子集的词法分析程序

## lex 文件的写法

### 一个简单例子

先从例子入手吧，下面的例子用来统计文本行数：

```c
%{
#include <stdio.h>
int lines = 1;
%}
%%
\n    { lines++; }
.     ;
%%
int main(int argc, char** argv) {
  if (argc == 2) {
    if ((yyin = fopen(argv[1], "r")) == NULL)
      printf("cannot open %s\n", argv[1]);
  } else {
    printf("usage: %s <file>\n", argv[1]);
    return 0;
  }
  yylex();
  printf("lines: %d\n", lines);
  return 0;
}
```

先在命令行执行如下命令：

```bash
lex line_count.l
```

在当前目录生成了一个 `lex.yy.c` 的 C 语言程序，感兴趣可以读读看。接下来生成可执行程序：

```bash
gcc lex.yy.c -ll
```

生成了 `a.out` 程序，现在就可以通过 `./a.out <filepath>` 来统计一个文件的行数了

### 怎么写

在前面的例子中，通过 `lex` 产生的是一个 C 语言代码，这个代码就是根据我们的 `.l` 文件生成的

`.l` 文件有 3 个结构：

```c
%{
// 头部声明区
%}
// 预处理区
%%
// 正则匹配区
%%
// 自定义程序区
```

- 头部声明区：被 `%{` 和 `%}` 包围的区域
  - 这部分会放在生成代码的前面
  - 可以在这里定义函数声明，结构体，变量名等
- 预处理区：在 `%}` 和下面的 `%%` 之间的部分
  - 可以在这里声明多重入口
  - 可以定义一些类型宏的东西，详细见下文
- 正则匹配区：两个 `%%` 之间的区域
- 自定义程序区：在 `%%` 下面的部分

把上面的例子写的稍微复杂一点，这个程序统计程序中 `//` 和 `/**/` 样式的注释数量：

```c
%{
#include <stdio.h>
int lines    = 1;
int comments = 0;
%}
%x COMMENT C_COMMENT
NEW_LINE  \n
%%
.               ;
{NEW_LINE}      { lines++; }
"//"            { BEGIN COMMENT; }
"/*"            { BEGIN C_COMMENT; }
<COMMENT>.              ;
<COMMENT>{NEW_LINE}     { BEGIN 0; lines++; comments++; }
<C_COMMENT>.            ;
<C_COMMENT>{NEW_LINE}   { lines++; }
<C_COMMENT>"*/"         { BEGIN 0; comments++; }
<C_COMMENT><<EOF>>      { printf("comment error\n"); }
%%
int main(int argc, char** argv) {
  if (argc == 2) {
    if ((yyin = fopen(argv[1], "r")) == NULL)
      printf("cannot open %s\n", argv[1]);
  } else {
    printf("usage: %s <file>\n", argv[1]);
    return 0;
  }
  yylex();
  printf("lines: %d, comments: %d\n", lines, comments);
  return 0;
}
```

在预处理区多出了下面两项：

```c
%x COMMENT C_COMMENT
NEW_LINE  \n
```

- `%x` 这一行定义了两个入口分别为 `COMMENT` 和 `C_COMMENT`
- 第二行使用 `NEW_LINE` 表示 `\n`

正则匹配区的前面都是正则式，后面是对应的处理措施

```c
.               ;
{NEW_LINE}      { lines++; }
"//"            { BEGIN COMMENT; }
"/*"            { BEGIN C_COMMENT; }
<COMMENT>.              ;
<COMMENT>{NEW_LINE}     { BEGIN 0; lines++; comments++; }
<C_COMMENT>.            ;
<C_COMMENT>{NEW_LINE}   { lines++; }
<C_COMMENT>"*/"         { BEGIN 0; comments++; }
<C_COMMENT><<EOF>>      { printf("comment error\n"); }
```

我感觉这和 `switch` 的分支有点类似，只是 `case` 中变成了正则匹配式。有几点需要注意：

- 预处理区定义的 `NEW_LINE` 需要配合 `{}` 使用（注意不要带空格）
- 通过 `BEGIN` 跳到对应的分支进行处理，直到遇到 `BEGIN 0` 后退出

## C 语言词法分析器

接下来通过 lex 实现一个 C 语言的词法分析器，严格来说只能实现 C 语言的一个子集。实现目标是能够正确地将一个 C 语言程序的符号进行读取和分类，可以分辨出关键词、界符、数字、标识符等类别，同时能够排查简单非法字符的错误并进行处理。

### Token 设计

下面的正则表达式定义了几种可分辨的字符类型，当前面的类型都未匹配到时，就会走到 `ERROR` 类型

```lex
STRING        \".*\"
MACRO         ^#.*\n
ID            [a-zA-Z_]([0-9]|[a-zA-Z_])*
INTEGER       0|("+"|"-")?[1-9][0-9]*
KEYWORD       "break"|"main"|"continue"|"else"|"float"|"for"|"if"|"int"|"return"|"void"|"while"|"do"|"double"|"extern"|"FILE"|"char"|"const"|"fopen"
OPERATOR      "+"|"-"|"*"|"/"|"="|"=="|"<="|">="|"."
DELIMITERS    "("|")"|"{"|"}"|"["|"]"|";"|","
ERROR         .
```

下面是我定义的 Token 结构体，在正则匹配的过程时将匹配结果存到 `g_tokens` 中

```c
struct Token {
  int type;
  char data[32];
  int lineno;
};

struct Token g_tokens[1024];
int token_len = 0;
```

### 正则匹配

这一步做字符匹配及 Token 的生成，详细内容见[代码](./lexc.l)。在这里同样使用多重入口略过了注释，遇到 `ERROR` 时也会进入 `ERROR_OCCUR` 状态，直到当前错误字符串结束或者换行

当然我这个错误判断有点羸弱，只能处理单词第一个字符为非法字符的情况：

```c
  $abc // `$abc` error!
  a$bc // a accept, `$bc` error! 
```

### 效果展示

对一个简单的 `Hello World!` [程序](./test/right_test.c)进行分析：

<div align=center><img width=60% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220523085037.png"/></div>

分析一个有错误的[程序](./test/error_test.c)：

<div align=center><img width=60% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220523085204.png"/></div>