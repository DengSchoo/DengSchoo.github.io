## STL用法

### 数据结构

#### string｜字符串

1. **length() / size()**

    - 功能：返回字符串的长度。

    - 示例： `stringstr="Hello";cout<<str.length();// 输出 5`

2. **substr(pos, len)**

    - 功能：从字符串中提取子字符串，从位置 `pos` 开始，长度为 `len`。

    - 示例： `stringstr="Hello";cout<<str.substr(1,3);// 输出 "ell"`

3. **find(sub, pos)**

    - 功能：从位置 `pos` 开始查找子字符串 `sub`，返回第一次出现的位置。

    - 示例： `stringstr="Hello";cout<<str.find("ll");// 输出 2`

4. **erase(pos, len)**
    - 功能：删除从位置 `pos` 开始，长度为 `len` 的子字符串。
    - 示例： `stringstr="Hello";str.erase(1,3);cout<<str;// 输出 "Ho"`

5. **append(str) / operator+=**
    - 功能：将字符串 `str` 添加到当前字符串的末尾。
    - 示例： `stringstr="Hell";str.append("o");// 或 str += "o"; 输出 "Hello"`

6. **replace(pos, len, str)**

    - 功能：将从位置 `pos` 开始，长度为 `len` 的子字符串替换为 `str`。

    - 示例： `stringstr="Hello";str.replace(1,3,"a");cout<<str;// 输出 "Hao"`

7. **insert(pos, str)**

    - 功能：在位置 `pos` 插入字符串 `str`。

    - 示例： `stringstr="Hlo";str.insert(1,"el");cout<<str;// 输出 "Hello"`

8. **compare(str)**

    - 功能：比较两个字符串。

    - 示例： `stringstr1="Hello";stringstr2="World";cout<<str1.compare(str2);// 输出负数`

9. **operator[]**

    - 功能：访问字符串中的特定字符。

    - 示例： `stringstr="Hello";cout<<str[1];// 输出 'e'`

10. **c_str()**

    - 功能：将 `string` 转换为 C 风格的字符串（ `constchar*` 类型）。

    - 示例： `stringstr="Hello";cout<<str.c_str();// 输出 "Hello"`

#### vector｜向量

> vector是一个顺序表，其内存空间是连续的，支持自动扩容，自动内存管理。

初始化：

```c++
vector<T> v;//声明一个空的，内部元素类型为T的vector
vector<int> v_int;

int n = 5;
vector<int> v_int2(n);//声明一个大小为n的vector，默认初值为0
//v_int2 = [0, 0, 0, 0, 0]

int x = 3;
vector<int> v_int3(n, x);//声明一个大小为n，初值为x的vector
//v_int3 = [3, 3, 3, 3, 3]
```

操作：

| 方法            | 作用                                             |
| --------------- | ------------------------------------------------ |
| push_back(x)    | 将元素x插入到vector的末尾                        |
| operator[idx]   | 返回下标idx所指的元素                            |
| front()         | 返回vector中的第一个元素，即下标为0的元素        |
| back()          | 返回vector中的最后一个元素                       |
| size()          | 返回vector中元素个数                             |
| empty()         | 判断vector是否为空                               |
| resize(n)       | 将vector的大小调整为n，多删少补                  |
| clear()         | 将vector清空                                     |
| erase(it)       | 删除迭代器it所指的元素                           |
| insert(it, val) | 在迭代器it前面插入val（复杂度太高，一般不用）    |
| begin()         | 返回指向vector中的第一个元素的迭代器             |
| end()           | 返回指向vector中最后一个元素的下一个位置的迭代器 |



#### stack｜栈

> 栈是一种线性结构，可以把它看作是一种**“弱化版”的数组**，它只能在栈顶进行数据的操作，而栈内部的元素都是不能被访问的。但正是由于它只能在栈顶进行数据操作，使得它具有一些优秀的特性，DFS中节点遍历的顺序实际上就和栈的结构相关。

初始化：

```c++
stack<T> stk;//T为数据类型
stack<int> stk_int;//声明一个内部元素为int的栈
```

操作：

> 1. 没有clear方法，可以使用循环清除
> 2. 使用top需要保证栈不为空

| 方法    | 作用                                             |
| ------- | ------------------------------------------------ |
| push(x) | 将元素x推入栈顶                                  |
| pop()   | 弹出栈顶元素，但不会返回该元素                   |
| top()   | 返回栈顶元素，但不会弹出该元素（需要保证有元素） |
| size()  | 返回栈中元素个数                                 |
| empty() | 判断栈是否为空                                   |

#### queue｜队列

> 队列是一种**FIFO（First In First Out）**，即先进先出的数据结构，它提供了两个接口来操作内部的元素，以及一些方法来获取队头、队尾的元素、队列的大小以及判断队列是否为空。

使用：

```c++
queue<T> q;//T为数据类型
queue<int> qint;//声明一个内部元素为int的队列
```

操作：

| 方法    | 作用                                              |
| ------- | ------------------------------------------------- |
| push(x) | 将元素x从队尾推入                                 |
| pop()   | 将队头元素弹出，但不返回该元素                    |
| size()  | 返回队列的大小，即队列中元素个数                  |
| empty() | 返回队列是否为空，若为空则返回true，反之返回false |
| front() | 返回队头元素，但不会删除该元素                    |
| back()  | 返回队尾元素                                      |

#### map｜映射

> **map**是一种基于红黑树（我们无需理解红黑树的原理）的关联容器，支持快速的插入、查找和删除操作，并且保持了内部元素的有序性，其中的每个元素都由一个键和与之关联的值组成。
>
> 你可以将他理解为一个箱子，你给他一个东西（变量），它就对应的给你一个东西（变量）。
>
> 我们无需理解map的底层结构，只需要知道它该如何使用以及相关的时间复杂度就够了。

```c++
map<T_key, T_value> mp;//T_key, T_value为数据类型
map<int, int> mp_int;//声明一个内部键值对为<int, int>的map
struct Node{
    int x, y;//map内部需要进行比较，如果不重载小于号将会报错
    bool operator < (const Node &u) const{return x == u.x ? y < u.y : x < u.x;}
};
map<Node, int> mp_Node_int;
```

操作：

| 方法                 | 作用                                        |
| -------------------- | ------------------------------------------- |
| insert({key, value}) | 向map中插入一个键值对<key, value>           |
| erase(key)           | 删除map中指定的键值对                       |
| find(key)            | 查找map中指定键对应的键值对的迭代器         |
| operator[key]        | 查找map中指定键对应的值                     |
| count(key)           | 查找map中键的数量，由于键唯一，故只返回0或1 |
| size()               | 返回map中键值对的数量                       |
| clear()              | 清空map中的所有键值对                       |
| empty()              | 判断map是否为空                             |
| begin()              | 返回map中第一个键值对的迭代器               |
| end()                | 返回map中最后一个键值对的下一个迭代器       |

#### priority_queue｜优先队列

> **priority_queue**是一种特殊的队列，可以用来存储具有优先级的元素，队头的元素都是当前队列中优先级最高（或最低）的元素。
>
> STL中的**priority_queue**默认为最大堆实现，即优先级最高的元素（值最大的元素）最先出队。

初始化：

```c++
与queue类似
```

操作：

| 方法    | 作用                                                     |
| ------- | -------------------------------------------------------- |
| push(x) | 将元素x推入队列中                                        |
| pop()   | 移除队列中优先级最高的元素，这个函数不会返回被删除的元素 |
| top()   | 返回队列中优先级最高的元素，但不删除该元素               |
| size()  | 返回队列中元素个数                                       |
| empty() | 判断队列是否为空，若为空返回true，反之返回false          |

> 值得注意的是，**priority_queue**不像前面讲的几种线性结构一样有迭代器（iterator），你不能用类似**begin()、end()**这样的函数来遍历整个队列，当然**for auto**的形式也不行。同时你也不能直接修改队列中的元素。
>
> 大多数情况下，**top()**后会紧跟**pop()**，同时在使用**pop()**前需要保证优先队列非空。



### 算法

#### sort

```c++
// 使用方法一：
sort(points.begin(), points.end(), [](const auto& a, const auto& b) {
            return a[0] < b[0];
 });
// 方法二：
auto compare = [](int a, int b) { return a > b; };
int main() {
    vector<int> v = {3, 2, 5, 1, 6, 4};
    sort(v.begin(), v.end(), compare);
    for(int num : v) cout << num << " "; // 输出：6 5 4 3 2 1
    return 0;
}
```

#### lower_bound和upper_bound

> 使用前提：数组已经有序

```c++
#include<bits/stdc++.h>
using namespace std;

int main() {
    vector<int> v = {1, 3, 5, 7, 9};
    int val = 5;
    auto it = lower_bound(v.begin(), v.end(), val);
    if (it != v.end()) cout << "Found at index: " << it - v.begin();
    else cout << "Not found";
    return 0;
```

```c++
#include<bits/stdc++.h>
using namespace std;

int main() {
    vector<int> v = {1, 3, 5, 7, 9};
    int val = 5;
    auto it = upper_bound(v.begin(), v.end(), val);
    if (it != v.end()) cout << "First element greater than " << val << " is at index: " << it - v.begin();
    else cout << "No elements are greater than " << val;
    return 0;
}
```

对比：

| 特性                   | `lower_bound`                    | `upper_bound`                        |
| ---------------------- | -------------------------------- | ------------------------------------ |
| 功能                   | 查找第一个大于等于给定值的元素   | 查找第一个大于给定值的元素           |
| 返回值                 | 迭代器                           | 迭代器                               |
| 条件要求               | 输入序列必须是有序的             | 输入序列必须是有序的                 |
| 时间复杂度             | O(log n)                         | O(log n)                             |
| 返回元素条件           | 大于等于给定值的第一个元素       | 大于给定值的第一个元素               |
| 返回值为 `end()`的条件 | 元素不存在或所有元素都小于给定值 | 元素不存在或所有元素都小于等于给定值 |



#### reverse

> 反转函数支持vector、string

```c++
#include<bits/stdc++.h>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 4, 5};
    reverse(v.begin(), v.end());
    for(int i : v) cout << i << " "; // 输出：5 4 3 2 1 
    return 0;
}
```

#### swap

> 交换两者值

```c++
#include<bits/stdc++.h>
using namespace std;

int main() {
    int a = 5, b = 10;
    swap(a, b);
    cout << "a = " << a << ", b = " << b; // 输出：a = 10, b = 5
    return 0;
}
```

#### next_permutation和prev_permutation

> 1. 常用于需要全排列的算法中
> 2. 需要元素有序

next_permutation:它的作用是生成给定排列的下一个排列

prev_permutation:它的作用是生成给定排列的上一个排列

```c++
while (prev_permutation(sequence.begin(), sequence.end())) {
    // 在这里可以处理每个生成的排列
}
```



## 数学

### GCD && LCM

GCD（Greatest Common Divisor）｜最大公约数：两个或多个整数共有约数中最大的一个

LCM（Least Common Multiple）｜最小公倍数：两个或多个整数的最小公倍数。它是能够被每个整数整除的最小正整数。

> 库函数自带：引入头文件`<numeric>`
>
> - gcd和__gcd
> - lcm

```c++
#include <iostream>
using namespace std;

// 计算GCD
int gcd(int a, int b) {
   return b == 0 ? a : gcd(b, a % b);
}

// 计算LCM
int lcm(int a, int b) {
   return a / gcd(a, b) * b;
}

int main() {
   int a = 8, b = 12;
   cout << "GCD of " << a << " and " << b << " is " << gcd(a, b) << endl;
   cout << "LCM of " << a << " and " << b << " is " << lcm(a, b) << endl;
   return 0;
}
```



### 快速幂

> 直接计算 (a^n) 会导致巨大的数值，可能导致整数溢出，且计算效率低下。
>
> 快速幂算法通过分解指数 (n) 的二进制表示，逐步构建幂的值，并在每一步中都进行模 (m) 运算，有效避免了这些问题。

```c++

long long fastPower(long long base, long long exponent, long long mod) {
    long long result = 1;
    base %= mod;
    while(exponent > 0) {
        if (exponent % 2 == 1) {
            result = (result * base) % mod;
        }
        base = (base * base) % mod;
        exponent >>= 1;
    }
    return result;
    
}
```

### 矩阵快速幂

```c++
#include <vector>
using namespace std;

typedef vector<vector<long long>> matrix;

matrix mutiply(matrix &a, matrix b) {
    int n = a.size();
    matrix result(n, vector<long long>(n, 0));
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            for(int k = 0; k < n; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return result;
}

matrix matrixPower(matrix base, int exponent) {
    int n = base.size();
    matrix result(n, vector<long long>(n, 0));
    for(int i = 0; i < n; i++) {
        result[i][i] = 1;
    }
    while(exponent > 0) {
        if (exponent % 2 == 1) {
            result = mutiply(result, base<#matrix b#>);
        }
        base = mutiply(base, base <#matrix b#>);
        exponent /= 2;
    }
    return result;
}
```



### 素数筛-埃拉托斯特尼筛法原理

1. 创建一个布尔数组，用于标记每个数是否为素数。
2. 将 2 到 (√n) 的每个数，如果它是素数，则将其所有倍数标记为非素数。
3. 数组中未被标记为非素数的数字即为素数。

```c++
#include <vector>
using namespace std;

typedef vector<vector<long long>> matrix;

vector<int> sieveOfEratosthenes(int n) {
    vector<bool> prime(n + 1, true);
    vector<int> primes;
    prime[0] = prime[1] = false;
    
    for(int p = 2; p * p <= n; p++) {
        if (prime[p]) {
            // 将p的倍数都设置为是否是素数
            for(int i = p * p; i <= n; i += p) {
                prime[i] = false;
            }
        }
    }
    for(int p = 2; p <= n; p++) {
        if(prime[p]) {
            primes.push_back(p);
        }
    }
    return primes;
}
```

> - 空间复杂度为 (O(n))，对于非常大的 (n)，空间需求可能成为问题。
> - 时间复杂度为 (O(n \log \log n))，适用于处理大范围的素数筛选。

### 素数筛-欧拉筛法

1. 维护一个素数列表，用于存放已经筛选出的素数。
2. 遍历每个数，对于每个数：

- 如果它不被前面的素数整除，那么它是素数，加入素数列表。
- 如果它被某个素数整除，那么更新其状态为非素数，并且不再对其进行后续的筛选操作。

```c++
vector<int> eulerSieve(int n) {
    vector<bool> isPrime(n + 1, true);
    vector<int> primes;
    
    for(int i = 2; i <= n; i++) {
        if (isPrime[i]) {
            primes.push_back(i);
        }
        for(int j = 0; j < primes.size() && i * primes[j] <= n; j++) {
            // 倍数都为false
            isPrime[i * primes[j]] = false;
            // 判断是否能被某个素数整除
            if (i % primes[j] == 0) break;
        }
    }
    return primes;
}
```

> - 欧拉筛法的时间复杂度是 (O(n))，比埃拉托斯特尼筛法更高效。
> - 对于非常大的范围，欧拉筛法更能节省时间。
> - 适用于需要快速生成大量素数的情况。
