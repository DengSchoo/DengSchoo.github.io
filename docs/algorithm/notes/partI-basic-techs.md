# Part I: Basic techniques

## Introduction|简介

### Programming Language

> At the moment, the most popular programming languages used in contests are C++, Python and Java. For example, in Google Code Jam 2017, among the best 3,000 participants, 79 % used C++, 16 % used Python and 8 % used Java [29]. Some participants also used several languages.

目前有很多语言可以选择：

- python：很多内置函数，支持搞定度运算
- java：Collection库以及Util库刷题也不错
- c++(11+)：因为带有STL支持各种数据结构以及附带算法，比较适合做算法题。本文以cpp 11版本书写代码。

### C++ Code Template

A typical C++ code template:

```c++
#include <bits/stdc++.h>
using namespace std;
int main() {
    // solution comes here
    cout << "Hello World!" << endl;
}

```

- `#include` is a feture of g++ compiler that allows up to import libs.
- `bits/stdc++.h`是万能库包含常用的库文件
- `using namespace std;`表示类和函数可以直接在代码中使用，如果除去这一句，举个例子你的输出写法前面就要加上`std::cout`
- 运行code：`g++ -std=c++11 -O2 -Wall test.cpp -o test`
  - `-std=c++11`：表示使用cpp11语法标准
  - `-O2`：优化代码
  - `-Wall`：展示警告和可能的错误

### Input And Output

- Input : cin

  - 可以忽略中间空格以及换行

    ```c++
    int a, b;
    string x;
    cin >> a >> b >> x;
    ```

- Output : cout stream

  - 输出流：

    ```c++
    int a = 123, b = 456;
        string x = "monkey";
        cout << a << " " << b << " " << x << "\n";
    ```

- 优化输入输出速度：

  ```c++
  ios::sync_with_stdio(0);
  cin.tie(0);
  ```

- endl:换行并刷新缓冲区

- printf与scanf要比cin和cout快

- 读取一整行：

  ```c++
  string s;
      getline(cin, s);
  ```

- 读取未知多行数据，一直读取到数据末尾EOF

  ```c++
  while (cin >> x) {
          // code
  }
  ```

- 读取文件和输出到文件

  ```c++
  freopen("input.txt", "r", stdin);
  freopen("output.txt", "w", stdout);
  ```

### Working With Numbers

#### Integers

- 数据范围
  - 32bit(int)：−2^31^...2^31^−1，大概-2 * 10^9^~2 * 10 ^9^
  - 64bit(long long): 2^63^...2^63^−1，大概−9·10^18^ ...9·10^18^
- LL标识long long类型：`long long x = 123456789123456789LL;`
- 两个int*int结果还是int
- g++ compiler支持128bit数据`__int128_t`，大概数据范围在-10^38^~10^38^(大多数竞赛都不允许此类型)



#### Modular Arithmetic

在某些答案特别大的情况下，为了照顾各语言的差异，所以都会对结果进行取模操作，常用的mod数为`1e9 + 7`，这样可以照顾到int和long数据类型。

模运算等式：

![image-20231224222140117](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242221288.png)

负数的模运算为0或者负数。



#### Floating Point Numbers

常用的是64bit的double类型，同时g++支持80bit的long double，大多数场景下64就够了，80的更为准确。

`printf("%.9f\n", x);`打印保留九位小数

rounding errors：

```c++
double x = 0.3*3+0.1;
    printf("%.20f\n", x); // 0.99999999999999988898
```

因为存在舍入误差所以对于浮点数的比较要用：

```c++
if (abs(a-b) < 1e-9) {
        // a and b are equal
}

```



### Shortening Code

> 简化代码

#### Type Names

用`typedef`来给出一个简短的类型名称.

```c++
typedef long long ll;
long long a = 123456789;
    long long b = 987654321;
    cout << a*b << "\n";
```

```c++
typedef vector<int> vi;
    typedef pair<int,int> pi;
```

#### Macros

> A macro means that certain strings in the code will be changed before the compilation.In C++, macros are defined using the #define keyword.

```c++
#define F first
    #define S second
    #define PB push_back
    #define MP make_pair
```

code:

```c++
v.push_back(make_pair(y1,x1));
    v.push_back(make_pair(y2,x2));
    int d = v[i].first+v[i].second;
```

Shortend:

```c++
v.PB(MP(y1,x1));
    v.PB(MP(y2,x2));
    int d = v[i].F+v[i].S;
```

Macro param:

```c++
#define REP(i,a,b) for (int i = a; i <= b; i++)

for (int i = 1; i <= n; i++) {
        search(i);
}

// to 
REP(i,1,n) {
        search(i);
}
```





### Mathematics

#### Sum Formulas

给出一些常用求和公式：

![image-20231224223515706](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242235744.png)



**arithmetic progression｜等差数列**

如果各数之间差值相同，存在一个计算公式：

exp：`3, 7, 11, 15`

公式为：![image-20231224223640210](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242236253.png)

**geometric progression｜等比数列**

> A geometric progression is a sequence of numbers where the ratio between any two consecutive numbers is constant. For example,3,6,12,24

![image-20231224223858981](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242238022.png)

**harmonic sum｜谐波和**

![image-20231224223951624](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242239756.png)



### Set Theory｜集合论

> A set is a collection of elements. For example, the set, X = {2, 4, 7}

- |S|表示S的size
- 如果S中包含一个x，写做x ∈ S，否者 x ∉ S
- 集合操作
  - The intersection A ∩ B｜取交集
  - The union A ∪ B｜取并集
  - The complement A ̄｜取反
  - The difference A \ B = A ∩ B ̄｜将B的元素从A中移除
- subset：A中元素都存在于S，写做A ⊂ S，一个集合的子集格数为2^|S|^，包含空集
- 字符表示
  - N (natural numbers), 
  - Z (integers), 
  - Q (rational numbers)
  - R (real numbers)
- 表示一个集合：`{f(n):n∈S},`
  - f(n)表示函数
  - n表示参数，并且范围在S中

### Logic

> The value of a logical expression is either true (1) or false (0). 
>
> The most impor- tant logical operators are ¬ (negation), ∧ (conjunction), ∨ (disjunction), ⇒ (implication) and ⇔ (equivalence).

- A predicate：一个基于参数为最后结果为true或者false的表达式
- A quantifier：connects a logical expression to the elements of a set. The most important quantifiers are ∀ (for all) and ∃ (there is). For example,

∀x(∃y(y<x))：表示所有x都有一个y小于x，当集合为所有整数时为true，为自然数的时候是false因为x存在最小值。

> Using the notation described above, we can express many kinds of logical propositions. For example,

∀x((x>1∧¬P(x))⇒(∃a(∃b(a>1∧b>1∧x=ab))))：表示如果一个数字x比1大并且不是素数，那么存在a和b，他们都都大于1并且乘积为x。当集合是整数时这个假设成立。



### Functions



- ceil and floor:The function ⌊x⌋ rounds the number x down to an integer, and the function ⌈x⌉ rounds the number x up to an integer. For example,⌊3/2⌋ = 1 and ⌈3/2⌉ = 2.

- max and min:The functions min(x1,x2,...,xn) and max(x1,x2,...,xn) give the smallest and largest of values x1,x2,...,xn. For example,min(1,2,3) = 1 and max(1,2,3) = 3.

- The factorial n! can be defined

  ![image-20231224225721572](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242257658.png)

- Fibonacci numbers｜斐波那契数列:

  ![image-20231224225750219](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242257254.png)

  - Binet’s formula｜比奈公式:

    ![image-20231224225821628](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242258710.png)

### Logarithms｜对数

> The logarithm of a number x is denoted logk(x), where k is the base of the logarithm. According to the definition, logk(x) = a exactly when k^a^ = x.

![image-20231224230057079](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312242300116.png)

The natural logarithm ln(x) of a number x is a logarithm whose base is e ≈ 2.71828. Another property of logarithms is that the number of digits of an integer x in base b is ⌊logb(x)+1⌋. For example, the representation of 123 in base 2 is 1111011 and ⌊log2(123) + 1⌋ = 7.

## Time Complexity|时间复杂度



## Sorting|排序





## Data Structures|数据结构



## Complete Search|穷举搜索





## Greedy Algorithms|贪心算法





## Dynamic Programming|动态规划



## Amortized Analusis|平摊分析



## Range Queries|范围查询



## Bit Manipulation|位操作
