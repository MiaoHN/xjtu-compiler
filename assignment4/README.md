# Cool 词法分析器的实现

本次实验需要完成 `Cool` 的词法分析器

## 关键文件

- `include/cool-parse.h` 中记录了实验中需要的所有符号
- `include/stringtab.h` 中记录了语法树的节点类型和符号表
- `lex/cool.l` 是我们需要修改的部分
- `test/test.cl` 提供的测试文件
- `../bin/reference-lexer` 正确的词法分析程序，本次实验拿来参考

:star: **本次实验只需要修改 `cool.l` 和 `test.cl` 即可**

## 实验流程

修改 `cool.l` 和 `test.cl` 这两个文件，然后将词法分析结果与标准的 `reference-lexer` 的输出结果进行比较。直到分析结果与标准完全相同。

其中 `test.cl` 要尽可能多的包含各种错误情况便于分析

### 执行测试

使用 `make test` 可以一键编译并对 `test.cl` 进行词法分析：

<div align=center><img width=80% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220530130035.png"/></div>

### 与标准比较测试

为了方便检测结果，我在 `Makefile` 添加了 `check` 选项，可以将自己的结果和标准结果进行对比。比如直接检查原始的 `test.cl` 时，输出结果如下：

<div align=center><img width=80% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220529110747.png"/></div>

可以看到有两行不一样

:o: 如果半天没输出，那应该是因为进入死循环了
