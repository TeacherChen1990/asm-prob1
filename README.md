
* asm | acc | neum | mc | tick | struct | trap | mem | cstr | prob1 | spi

## asm编程设计
* 指令本身不区分大小写，但是符号声明除外。例如 ld #1 等于 LD #1
* 第一个函数是_start，即输入.
* 指令按顺序执行。指令操作释义如下：

  - `ld 参数` -- 加载。它的作用是将一个数据从内存中加载到寄存器中

  - `st 参数` -- 卸载。将值从寄存器卸载到内存

  - `add 参数` -- 将指定的值添加到寄存器中

  - `sub 参数` -- 从寄存器中去掉指定的值

  - `mul 参数` -- 将寄存器乘以指定的值

  - `div 参数` -- 将寄存器除以指定的

  - `cmp 参数` -- 将寄存器值与指定值进行比较并设置状态值

  - `jmp 参数` -- 无条件转移到指令所指示的目标地址，并从该地址开始执行。目标地址可以从指令中直接得到，也可以从指令中给定的寄存器或存储器中得到。

  - `jz 参数` -- 简单条件转移指令--相等转移

  - `js 参数` -- 单条件转移指令--前次操作结果为负数转移 

  - `jnz 参数` -- 简单条件转移指令--不相等转移（同JNE）
  
  - `hlt` -- 指令使处理器处于暂停状态
  
  - `push` -- 进栈。把寄存器，段寄存器中的一个字数据压入堆栈
  
  - `pop` --  出栈。将栈顶元素弹出送至某一寄存器
  
  - `call  参数` -- 程序调用
  
  - `ret` -- 返回
  
  - `inv` -- 获取寄存器数的倒数
  
* 出现在分号之后的内容将被视为注释

* 支持符号编码。符号以数字形式存储在内存中:

```

' ':0, 'a':1, 'b':2, 'c':3, 'd':4, 'e':5, 'f':6, 'g':7, 'h':8, 'i':9, 'j':10,
'k':11, 'l':12, 'm':13, 'n':14, 'o':15, 'p':16, 'q':17, 'r':18, 's':19, 't':20, 
'u':21,'v':22, 'w':23, 'x':24, 'y':25, 'z':26, 'A':27, 'B':28, 'C':29, 'D':30, 
'E':31, 'F':32,'G':33, 'H':34, 'I':35, 'J':36, 'K':37, 'L':38, 'M':39, 'N':40, 
'O':41, 'P':42, 'Q':43,'R':44, 'S':45, 'T':46, 'U':47, 'V':48, 'W':49, 'X':50, 
'Y':51, 'Z':52, '':53, '0':54,'1':55, '2':56, '3':57, '4':58, '5':59, '6':60, 
'7':61, '8':62, '9':63, '!':64, ',':65,'.':66, '-':67, '*':68, '?':69, '+':70, 
'/':71, '@':72, '\0':73, '\n':74

```

* 控件标签:

 - 'section .data' - 表示数据区域开始的标签。之后，您可以声明变量，但不能编写代码。
 - 'section .text' - 表示代码开始的标签

* 函数&标签:

  * 函数定义如下： '<函数名称>''
  * 让我们将标签定义如下：'.<命名标签>：'
  * 函数与标签的不同之处在于标签以"."开头。当我们想跳转到某个标签时，我们需要通过以下方式使用： jmp .label_name

* 地址寻找（参数格式）:

  * 纯数字：如果参数数字，则将其视为地址。也就是说，ld 29 - 表示将第30个单元格的值加载到累加器中 
  * 只是一个值：如果参数有一个“#”并且后跟一个数字，则该参数被视为一个值。即ld #29就是将29加载到电池中
  * 变量：如果参数是在数据部分中定义的变量，则它将地址视为变量。
  * 符号：根据符号表编码成数字。例如，ld 'A' = ld #27

* NZVC定义:

  * N = 1
  * Z = 2
  * V = 4
  * C = 8

* 变量定义：
  * 定义如下：“<Name： Value>'。 该值可以是数字或字符串。 如果它是一个字符串，它将具有与字符数一样多的单元格。

## 内存

命令和数据存储器。
内存是由单元格组成的列表。单元格由Cell类实现。

* 或一个数字 - 即数据。机器位 - 32位。**一个单元格仅保存一个字符。根据 ISA 中定义的字符表，该符号也采用数字形式**
* 或者表示为类的指令 - Instruction。**在类对象中，instruction 存储指令类型和参数**

堆栈设计。

最后一个 **1/4** 部分是 IO 端口，它仅用于 IO。

### 指挥系统

* 机器位 -- 32位。
* 寄存器：

  * IP计数器
    * 交流-
      * 寄存器
      * 用堆栈借用
      * 保留任何函数的结果
      * 保存任何数学运算的结果
    * BR - 作为临时存储数据的缓冲区。例如，它用于将函数的结果存储在 ret 指令中。
    * AR 是它们交互的单元的指定地址，即寄存器。还表示？堆栈的“地址”。
    * PS - 条件码。
    * SP - 堆栈指针。

## 指令编码

机器码以CSV格式存储

整个程序分为4个部分。以指定标签区分,

- 第一部分指令，FUNCTION标签之前为指令集。指令内容每行以" "分割为三列：
  - 第一列是指令索引
  - 第二列是指令
  - 第三列参数（如果有）
- 第二部分是函数，FUNCTION之后、LABEL之前的内容是执行的函数。函数内容功能每行以":"分割为两列：
  - 第一列是名称
  - 第二列是指令索引
- 第三部分是标签，LABEL之后、VARIABLE之前的内容是标签。标签内容每行以":"分割为三列：
  - 第一列是函数的名称
  - 第二列是标签的名称
  - 第三列是指令索引
- 第四部分是变量，VARIABLE标签之后的内容为变量。变量以":"分割为三列：
  - 第一列是变量的名称
  - 第二列是值
  - 第三列是行的长度（如果有）

例:

```
0 LD 'H' 
1 ST OUTPUT 
2 LD 'e' 
3 ST OUTPUT 
4 LD 'l' 
5 ST OUTPUT 
6 LD 'l' 
7 ST OUTPUT 
8 LD 'o' 
9 ST OUTPUT 
10 LD ',' 
11 ST OUTPUT 
12 LD 'w' 
13 ST OUTPUT 
14 LD 'o' 
15 ST OUTPUT 
16 LD 'r' 
17 ST OUTPUT 
18 LD 'l' 
19 ST OUTPUT 
20 LD 'd' 
21 ST OUTPUT 
22 HLT 
FUNCTION
_START:0
LABEL
_START:.LOOP:0
VARIABLE

```


## 翻译器

执行命令: `translator.py <input_file> <target_file>"`

支持基本的错误判定:

* 不能定义两个同名的变量
* 不要使用“Input”或“Output”作为变量名称
* 检查用户是否正确定义了参数。例如，您可以为没有参数的指令定义参数。
* 检查变量的格式。
* 错误信息将指示错误的位置。

翻译器功能：

1. 检查部分标签。数据
2. 读取变量并将它们保存到 
3. 检查部分标签
4. 读取代码
   * 如果字符串是标签，则保留其位置，包括其在斯拉夫语label_in_fun中的功能和命名。
   * 如果字符串是一个函数，则它在function_point中保留其位置和命名
   * 如果字符串是指令，则将其位置、类型和参数存储在结果字符串中
5. 当它读取一行时，它会自动忽略注释
6. 在对 1-4 进行任何处理之前，指令将转换为大写。
7. 根据结果，变量，label_in_fun和function_point生成输出文件。

## 计算机模拟

执行命令: `machine.py <target_file> <inputfile>".`

处理器：

* 对同一对象的操作不是在一次刻度中执行的。
* 在同一周期内对不同对象执行操作。

## 算法实现:
* prob1： /asm/prob1.asm
* cat     : /asm/cat.asm
* hello   : /asm/hello.asm

## 手动测试:

* 机器测试：test_machine.py
* 翻译测试：test_translator.py

## CI自动测试：
  GIT地址：https://github.com/TeacherChen1990/asm-prob1
  提交代码(master分支)之后，会自动触发Python application检测，自动执行执行test_machine.py、test_translator.py，检测通过


