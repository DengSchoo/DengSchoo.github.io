# Time Complexity｜时间复杂度

## Calculation Rules｜计算规则

> The time complexity of an algorithm is denoted O(···) where the three dots represent some function.Usually, the variable n denotes the input size. For example, if the input is an array of numbers, n will be the size of the array, and if the input is a string, n will be the length of the string.

### Loops｜循环

> If there are k nested loops, the time complexity is O(n^k^).

O(n):

```c++
for (int i = 1; i <= n; i++) {
    // code
}
```

O(n^2^):

```c++
 for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= n; j++) {
    	// code
    }
 }
```



### Order Of Magnitude｜数量级

时间复杂度只表示了数量级，不能表明具体的执行次数。所以对于 3n, n + 5 and ⌈n/2⌉，的算法时间复杂度都是O(n).

```c++
for (int i = 1; i <= 3*n; i++) {
    // code
}

for (int i = 1; i <= n + 5; i++) {
    // code
}

for (int i = 1; i <= n; i += 2) {
    // code
}
```

一个特殊情况，时间复杂度仍然是O(n^2^)

```c++
for (int i = 1; i <= n; i++) {
    for (int j = i+1; j <= n; j++) {
	// code
	} 
}
```



### Phases｜代码组合

如果一个算法包含了多种算法时间复杂度，整体的时间复杂度取最大的那个，因为最慢的算法经常是代码效率的瓶颈。

举个例子，下面是O(n),O(n^2^)和O(n)，所以整体的时间复杂度为O(n^2^2)

```c++
for (int i = 1; i <= n; i++) {
    // code
}
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= n; j++) {
       // code
	} 
}
for (int i = 1; i <= n; i++) {
    // code
}
```



### Several Variables｜多个变量

如果一个算法依赖多个变量，时间复杂度的公式就对应的有几个变量。

举例，下面是O(n*m)的时间复杂度：

```c++
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
    	// code
    } 
}
```



### Recursion｜递归

递归的时间复杂度取决于函数的调用次数以及单词调用的时间复杂度，整体的时间复杂度是这些时间复杂度的乘积。

例子：

```c++
void f(int n) {
        if (n == 1) return;
        f(n-1);
}

```

整体方法被调用了n次，所以时间复杂度为O(n)。

另外一个例子：

```c++
void g(int n) {
        if (n == 1) return;
        g(n-1);
        g(n-1);
}
```

| function call | number of calls |
| ------------- | --------------- |
| g(n)          | 1               |
| g(n - 1)      | 2               |
| g(n - 2)      | 4               |
| ...           | ...             |
| g(1)          | 2^n-1^          |

所以整体时间复杂度为这些调用求和：1+2+4+···+2^n−1^ =2^n^−1=O(2^n^).

## Complexity Classes｜复杂度类

- O(1) constant-time
- O(logn) logarithmic
- O(n^0.5^) square root algorithm
- O(n) linear
- O(nlogn) 
- O(n^2^) quadratic
- O(n^3^) cubic
- O(2^n^)
- O(n!)

如果一个算法时间复杂度最多是O(n^k^)，k是常量，那么它是多项式。这个k通常很小，所以通常来说多项式可以意味着这个算法是高效的。

NP-Hard（NP难问题）：目前为止问题的多项式解法。



## Estimating Efficiency｜估算效率

通过推算时间复杂度，就可以来检查自己的解法是否符合题目要求。目前为止一个标准是：评估你算法的机器一秒可以执行1e9的指令。

举个例子：如果算法输入是n=1e5，那么一个O(n^2^)对应的就是执行1e10个指令，大概10s的时间会超过题目限制。

通过题目给定的数据集大小也可以来推断应该用什么复杂度的算法来解决这个问题。

| input size | required time complexity |
| ---------- | ------------------------ |
| n <= 10    | O(n!)                    |
| n <= 20    | O(2^n^)                  |
| n <= 500   | O(n^3^)                  |
| n <= 5000  | O(n^2^)                  |
| n <= 10^6  | O(nlogn) or O(n)         |
| n is large | O(1) or O(logn)          |



## Maximum Subarray Sum｜最大子数组

>Given an array of n numbers, our task is to calculate the maximum subar- ray sum, i.e., the largest possible sum of a sequence of consecutive values in the array2. The problem is interesting when there may be negative values in the array. For example, in the array:-1, 2, 4, -3, 5, 2, -5, 2. the subarray[1...5] has the maximum sum 10.



### 算法1:O(n^3^)

```c++
int best = 0;
for (int a = 0; a < n; a++) {
    for (int b = a; b < n; b++) {
        int sum = 0;
        for (int k = a; k <= b; k++) {
            sum += array[k];
        }
        best = max(best,sum);
    }
}
cout << best << "\n";

```



### 算法2:O(n^2^)

```c++
int best = 0;
for (int a = 0; a < n; a++) {
    int sum = 0;
    for (int b = a; b < n; b++) {
        sum += array[b];
        best = max(best,sum);
    }
}
cout << best << "\n";

```



### 算法3:O(n)

```c++
int best = 0, sum = 0;
for (int k = 0; k < n; k++) {
    sum = max(array[k],sum+array[k]);
    best = max(best,sum);
}
cout << best << "\n";
```



## Efficiency Comparison｜效率对比

| Array size | Algo 1 | Algo 2 | Algo 3 |
| ---------- | ------ | ------ | ------ |
| 10^2^      | 0.0s   | 0.0s   | 0.0s   |
| 10^3^      | 0.0s   | 0.0s   | 0.0s   |
| 10^4^      | >10.0s | 0.1s   | 0.0s   |
| 10^5^      | >10.0s | 5.3s   | 0.0s   |
| 10^6^      | >10.0s | >0.0s  | 0.0s   |
| 10^7^      | >10.0s | >0.0s  | 0.0s   |
