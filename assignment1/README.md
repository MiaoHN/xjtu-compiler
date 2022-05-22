# 初始 Cool 语言

> Cool, an acronym for Classroom Object Oriented Language, is a computer programming language designed by Alexander Aiken for use in an undergraduate compiler course project. While small enough for a one term project, Cool still has many of the features of modern programming languages, including objects, automatic memory management, strong static typing and simple reflection.

## 实验准备

### Linux 环境

编译实验要在 linux 环境下进行，我们可以使用虚拟机，或者重装 linux 系统。不过为了方便，我使用 wsl 作为我的 linux 环境，其优点有：

1. 可以方便的通过 vscode 连接 wsl 写代码
2. wsl 的文件系统可以直接从 Windows 的文件管理器打开
   - 也就是说文件可以互通
3. ~~挂代理非常方便~~
4. 和 Windows 共用端口

安装教程跟着[官方](https://docs.microsoft.com/zh-cn/windows/wsl/install)走应该没啥问题。wsl 默认的安装位置是 C 盘，你可能需要通过这个[教程](https://www.cnblogs.com/konghuanxi/p/14731846.html)将位置移动到其他地方

:star: 在 wsl 中新建用户名的时候根据需要进行设置，比如我需要有截图标识，我就将用户名改成了自己的姓名拼音缩写

### 修改命令行标志

修改命令行是为了截图的时候有个独特标识。我们可以在 `.bashrc` 中使用 `export PS1='xxx'` 修改命令行提示符，也可以安装 `zsh` 的 `oh-my-zsh` 插件选择一个主题显示自己的用户名

我使用的主题是 `ys`，效果如下：

<div align=center><img width=80% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220522112329.png"/></div>

oh-my-zsh 官网在[这里](https://ohmyz.sh/)

## Cool 语法初探

就是简单写下 cool 的基本语法，详细内容还是得看参考手册

### 临时变量

使用 `let` 声明一个临时变量，其作用域在括号里面

```cool
 (let n : Int <- 1 in {
   -- balabala
 })
```

### 分支语句

分支语句只有 `if`

```cool
  if a < 3 then {
    -- balabala
  } else {
    -- balabala
  }
  fi
```

### 循环语句

循环语句只有 while

```cool
  while i < 10 loop
    i <- i + 1
  pool
```

### 关于分号

刚开始看 cool 的时候老是搞不懂分号怎么用，简单来说，分号就是在一个 `<expr>` 中分段的标识符。就举一个例子，比如上面的循环语句也可以写成

```cool
  while {i < 10;} loop {
    i <- i + 1;
  }
  pool
```

`<expr>` 可以直接写成 `i < 10`，也可以写成 `{ i < 10; }`。如果写成后面这种，`<expr>` 的返回值就是 `{}` 里面最后一句

## Makefile 怎么写

写一个能用的 Makefile 还是挺简单的，手动编译运行 cool 程序需要如下两条命令（ `coolc` 和 `trap.handler` 需要写清楚路径）

```bash
coolc <file> -o <target>
spim -trap_file trap.handler -file <target>
```

在 Makefile 中就可以写成

```Makefile
CLASSDIR = ..

FILES = $(wildcard *.cl)
TARGET = helloworld.s

all: source test

source: ${FILES}
	${CLASSDIR}/bin/coolc ${FILES} -o ${TARGET}

test: ${TARGET}
	${CLASSDIR}/bin/spim -trap_file ${CLASSDIR}/lib/trap.handler -file ${TARGET}

clean:
	rm ${TARGET}
```

上面的 `wildcard` 获取了当前目录所有后缀为 `.cl` 的文件名