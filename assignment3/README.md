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