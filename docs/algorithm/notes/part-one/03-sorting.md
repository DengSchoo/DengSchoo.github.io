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

> 每种排序算法都有其适用的场景。例如，对于小数据集，插入排序可能比快速排序更有效；而对于大数据集，快速排序或归并排序通常更优。理解每种排序算法的工作原理和性能特点对于选择合适的排序策略至关重要。

### 冒泡排序

**冒泡排序（Bubble Sort）**:

- **原理**: 重复遍历要排序的序列，比较相邻的元素，如果它们的顺序错误就交换它们。
- **特点**: 简单易懂，但效率不高，尤其是对于大数据集。最佳情况时间复杂度为 (O(n))，平均和最差情况时间复杂度为 (O(n^2))。

```c++
// Bubble Sort
void bubbleSort(vector<int>& arr) {
   int n = arr.size();
   for (int i = 0; i < n-1; i++)    
       for (int j = 0; j < n-i-1; j++)
           if (arr[j] > arr[j+1])
               swap(arr[j], arr[j+1]);
}
```



### 插入排序

**插入排序（Insertion Sort）**:

- **原理**: 逐个将元素插入到已排序的序列中的正确位置。

- **特点**: 对于小数据集或基本有序的数据效率较高。时间复杂度同冒泡排序。

```c++
void insertionSort(vector<int>& arr) {
   int n = arr.size();
   for (int i = 1; i < n; i++) {
       int key = arr[i];
       int j = i - 1;
       // 选择当前key适合的位置，向左遍历找到第一个元素不大于key的即key所属当前位置
       while (j >= 0 && arr[j] > key) {
           arr[j + 1] = arr[j];
           j = j - 1;
      }
       arr[j + 1] = key;
  }
}
```



### 选择排序

**选择排序（Selection Sort）**:

- **原理**: 每次从未排序的部分选择最小（或最大）的元素，放到已排序序列的末尾。

- **特点**: 不依赖于初始数据，时间复杂度始终为 (O(n^2))。

```c++
// Selection Sort
void selectionSort(vector<int>& arr) {
   int n = arr.size();
   for (int i = 0; i < n-1; i++) {
       // 选择最小的放到i位置
       int min_idx = i;
       for (int j = i+1; j < n; j++)
           if (arr[j] < arr[min_idx])
               min_idx = j;
       swap(arr[min_idx], arr[i]);
  }
}
```



### 归并排序

**归并排序（Merge Sort）**:

- **原理**: 采用分治法，将原始数组分成较小的数组，直到每个小数组只有一个元素，然后将小数组归并成较大的数组。

- **特点**: 非常有效，适用于大数据集。时间复杂度为 (O(n \log n))。但它需要与原数组一样多的额外存储空间。

```c++
// Merge Sort Helper Functions
void merge(vector<int>& arr, int l, int m, int r) {
   int n1 = m - l + 1;
   int n2 = r - m;

   vector<int> L(n1), R(n2);

    for (int i = 0; i < n1; i++)
       L[i] = arr[l + i];
    for (int j = 0; j < n2; j++)
       R[j] = arr[m + 1 + j];

    int i = 0, j = 0, k = l;
    while (i < n1 && j < n2) {
       if (L[i] <= R[j]) {
           arr[k] = L[i];
           i++;
      } else {
           arr[k] = R[j];
           j++;
      }
       k++;
    }

   while (i < n1) {
       arr[k] = L[i];
       i++;
       k++;
    }
    while (j < n2) {
       arr[k] = R[j];
       j++;
       k++;
    }
}
void mergeSort(vector<int>& arr, int l, int r) {
   if (l >= r)
       return;  
   int m = l + (r - l) / 2;
   mergeSort(arr, l, m);
   mergeSort(arr, m + 1, r);
   merge(arr, l, m, r);
}
```



### 快速排序

**快速排序（Quick Sort）**:

- **原理**: 也是分治法。选择一个“基准”，然后将数组分为两部分，一部分比基准小，另一部分比基准大，最后递归地对这两部分进行快速排序。

- **特点**: 平均情况下非常快，平均时间复杂度为 (O(n \log n))，但最坏情况下为 (O(n^2))。

```c++
// Quick Sort Helper Functions
int partition(vector<int>& arr, int low, int high) {
   int pivot = arr[high];
   int i = (low - 1);
   for (int j = low; j <= high - 1; j++) {
       if (arr[j] < pivot) {
           i++;
           swap(arr[i], arr[j]);
      }
  }
   swap(arr[i + 1], arr[high]);
   return (i + 1);
}
void quickSort(vector<int>& arr, int low, int high) {
   if (low < high) {
       int pi = partition(arr, low, high);
       quickSort(arr, low, pi - 1);
       quickSort(arr, pi + 1, high);
  }
}
```



### 堆排序

**堆排序（Heap Sort）**:

- **原理**: 利用堆这种数据结构，首先构建一个最大堆，然后将根节点（最大值）与最后一个节点交换并减小堆的大小，重复此过程直到堆的大小为 1。

- **特点**: 时间复杂度为 (O(n \log n))，无需额外的存储空间。

```c++
void heapify(vector<int>& arr, int n, int i) {
    //构建以i为初始节点的堆
    //n表示待排序元素个数
    
   int largest = i;
   int left = 2*i + 1;
   int right = 2*i + 2;

   if (left < n && arr[left] > arr[largest])
       largest = left;
   if (right < n && arr[right] > arr[largest])
       largest = right;

   if (largest != i) {
       // 如果当前i不是最大值那么递归构建最大值
       swap(arr[i], arr[largest]);
       heapify(arr, n, largest);
  }
}
void heapSort(vector<int>& arr) {
   int n = arr.size();
   for (int i = n / 2 - 1; i >= 0; i--)
       heapify(arr, n, i);
   for (int i = n - 1; i > 0; i--) {
       // 堆顶元素为下标为0的元素
       swap(arr[0], arr[i]);
       heapify(arr, i, 0);
  }
}
```

