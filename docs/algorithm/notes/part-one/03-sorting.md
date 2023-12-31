# Sorting｜排序

> Sorting is a fundamental algorithm design problem. Many efficient algorithms use sorting as a subroutine, because it is often easier to process data if the elements are in a sorted order.



## Sorting Theory



### n^2^ algo

> 这类排序算法大多数都很简短，比较暴力，通常包含两层循环。比较有名的算法是冒泡排序。

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312302037684.png" alt="image-20231230203705583" style="zoom:33%;" />

```c++
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n-1; j++) {
        if (array[j] > array[j+1]) {
            swap(array[j],array[j+1]);
        } 
    }
}
```

### Inversions｜逆序对

>  Inversion: a pair of array elements (array[a], array[b]) such that a < b and array[a] > array[b], i.e.,

逆序对这个概念常用于分析排序算法，有多少逆序数代表着排序这个数组的工作量。

当不存在逆序对的时候说明这个数组已经排好序了。同时如果一个数组是完全逆序的，那么就会有<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312302043764.png" alt="image-20231230204329709" style="zoom:25%;" />

冒牌排序就是交换两个相邻的逆序对，但是这个算法是n^2^的因为每次都要比较相邻的两个元素。

### nlong(n) algo

> 有些算法不需要交换相邻的元素，比如归并排序。

归并排序一个子数组arrayp[a...b]的过程：

1. 如果a==b说明为单个元素的子数组则不需要排序
2. 计算a和b的中间值
3. 递归排序array[a...k]
4. 递归排序array[k + 1 .... b]
5. 合并两个排序后的数组(array[a...k]和array[k + 1 .... b]到array[a....b])

这个算法递归层数：log(n)，合并两个排序数组:O(n)，所以总的时间复杂度为O(n*log(n))



### Sorting Lower Bound｜排序的更低边界

是否可以让时间复杂度降到比O(nlog(n))更低？如果继续使用对比元素的方法的话是无法实现更低的复杂度的。

对比排序的过程可以处理为一颗树：

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312302053731.png" alt="image-20231230205337684" style="zoom: 33%;" />

所有的对比处理过程都可以通过上面树来表示，假设答案在其中的一条路径上，总体有`n!`方法，所以这颗树的高度最小为log2(n!)=log2(1)+log2(2)+...+log2(n)。

用最少n/2元素以及整体元素值为log2(n/2)可以推算出：

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312302058623.png" alt="image-20231230205823562" style="zoom: 50%;" />

所以最优解可能的操作步骤最小值为(n/2)log2(n/2)即:(n)log2(n)



### Counting Sort

> 有些排序不需要对比元素：比如计数排序，在O(n)时间复杂度内排序，并假设元素都在0~n内，n为最大值，0为最小值。
>
> 算法思想：使用数组值对于下标来排序，比如当前值为3，那么这个数值就应该处于下标为3的计数数组中，最后顺序遍历这个数组得到排序后的结果。

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312302104107.png" alt="image-20231230210436063" style="zoom:33%;" />

整体时间复杂度为O(n)，并且条件也比较苛刻，c要求足够小才能用数组来做bookkeeping



## Sorting In C++｜C++中的排序

> sort函数包含多种算法的实现，不只是快速排序，自己内部会选择最优算法，所以一般直接用库函数即可。

```c++
vector<int> v = {4,2,5,3,5,8,3};
sort(v.begin(),v.end()); // 升序


sort(v.rbegin(),v.rend()); // 降序


int n = 7; // array size
int a[] = {4,2,5,3,5,8,3};
sort(a,a+n);

string s = "monkey";
sort(s.begin(), s.end()); //  s = ekmnoy
```

### Comparison Operator｜对比操作符

> The function sort requires that a comparison operator is defined for the data type of the elements to be sorted.
>
> Most C++ data types have a built-in comparison operator, and elements of those types can be sorted automatically.

```c++
vector<pair<int,int>> v; // 先排序first 然后second
    v.push_back({1,5});
    v.push_back({2,3});
    v.push_back({1,2});
    sort(v.begin(), v.end());

 vector<tuple<int,int,int>> v; // 先排序first、second、third...
    v.push_back({2,1,4});
    v.push_back({1,5,3});
    v.push_back({2,1,3});
    sort(v.begin(), v.end());
```



### User-defined Structs｜用户自定义结构排序

> 用户自己实现的没有重载<运算符，所以得自己实现。

```c++
struct P {
    int x, y;
    bool operator<(const P &p) {
        if (x != p.x) return x < p.x;
        else return y < p.y;
} };

```



### Comparison Functions｜对比方法

> 使用自定义的一个对比方法传入到sort函数中来排序

```c++
bool comp(string a, string b) {
    if (a.size() != b.size()) return a.size() < b.size();
    return a < b;
}

sort(v.begin(), v.end(), comp);
```



## Binary Search｜二分查找

> 通常查找一个元素的时间复杂度为O(n)，使用二分查找可以将复杂度降到O(logn)，原理就是借助自身的一些信息来实现，在这里就是自身数组的有序性，不断的以二分的方式逼近正确答案。

### Method 1｜实现方法1

```c++
int a = 0, b = n-1;
while (a <= b) {
    int k = (a+b)/2;
    if (array[k] == x) {
        // x found at index k
    }
    if (array[k] > x) b = k-1;
    else a = k+1;
}

```





### Method 2｜实现方法2

```c++
int k = 0;
for (int b = n/2; b >= 1; b /= 2) {
    while (k+b < n && array[k+b] <= x) k += b;
}
if (array[k] == x) {
    // x found at index k
}
```



## C++ Functions｜C++库函数

- lower_bound：返回第一个不小于x的元素
- upper_bound：返回第一个大于x的元素
- equal_ranger：返回上面两个函数的返回值指针

```c++
auto k = lower_bound(array,array+n,x)-array; // k为对应下标，如果元素不存在这个值为n即数组下标的不可能元素
    if (k < n && array[k] == x) {
        // x found at index k
}
```

```c++
auto a = lower_bound(array, array+n, x); // 第一个不小于x的元素
auto b = upper_bound(array, array+n, x); // 第一个大于x的元素
cout << b-a << "\n";
```

```c++
auto r = equal_range(array, array+n, x);
cout << r.second-r.first << "\n";
```



## 常见排序算法实现

### 插入排序

#### 直接插入排序



#### 折半插入排序





### 交换排序

#### 冒泡排序



#### 快速排序



### 选择排序



#### 简单选择排序



#### 堆排序



### 归并排序



### 基数排序



### 总结和比较
