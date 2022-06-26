# Cool 语义分析的**部分**实现

这次实验只需要完成一部分 cool 语言的语义分析功能。我准备对 cool 语言中类的循环继承进行判断，顺便判断代码中有无主类 `Main` 和对应的 `main()` 函数

## 实现任务

- 判断类名的合法性（不允许定义 `IO`，`Str`，`Bool` 等基本类）
- 判断继承的合法性
  - 不允许继承 `Bool`，`Int`，`SELF_TYPE`，`Str` 等类
  - 循环继承判断
- 判断是否继承未定义的类
- 判断主类 `Main` 是否存在
  - 判断主类 `Main` 中是否有 `main()` 方法

:star: 所有需要修改的文件有 `semant.cc`，`semant.h` 和 `cool-tree.handcode.h`

## 效果

<div align=center><img width=70% src="https://raw.githubusercontent.com/MiaoHN/pictures/master/img/20220626155104.png"/></div>
