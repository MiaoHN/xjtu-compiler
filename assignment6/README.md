# Cool 语法分析器的实现

本次作业通过 cool 的语法树实现 cool 语言的语法分析程序

## 语法树

下图可以从 `cool-manual.pdf` 中找到

<div align=center><img width=70% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/image-20220625102325791.png"/></div>

原始文件中已经提供了 `program` 和 `class` 的基本内容，我们需要实现的内容主要有 `feature`，`formal` 和 `expression`

[cool-tree.h](./include/cool-tree.h) 文件中包含了在语法分析中用到的所有函数

## tips

- 处理 `expr + expr` 时要使用 `plus` 这个函数，但是这个名字与 C++ 自带库的结构体重名，所以在用到该函数时要写成 `::plus` 才不会报错