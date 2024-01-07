# LC377th

## [100170. 对角线最长的矩形的面积](https://leetcode.cn/problems/maximum-area-of-longest-diagonal-rectangle/)

```c++
#define mu(x, y) (x*x + y*y)
class Solution {
public:
    
    int areaOfMaxDiagonal(vector<vector<int>>& dimensions) {
        int idx = 0;
        int n = dimensions.size();
        for(int i = 0; i < n; i++) {
            auto x = dimensions[i];
            auto y = dimensions[idx];
            if (mu(x[0], x[1]) == mu(y[0], y[1]) && x[0] * x[1] > y[0] * y[1]) {
                idx = i;
            } else if (mu(x[0], x[1]) > mu(y[0], y[1])) {
                idx = i;
            }
        }
        return dimensions[idx][0] * dimensions[idx][1];
    }
};
```





## [100187. 捕获黑皇后需要的最少移动次数](https://leetcode.cn/problems/minimum-moves-to-capture-the-queen/)

```c++
class Solution {
    bool ok(int l, int m, int r) {
        return m < min(l, r) || m > max(l, r);
    }

public:
    int minMovesToCaptureTheQueen(int a, int b, int c, int d, int e, int f) {
        if (a == e && (c != e || ok(b, d, f)) ||
            b == f && (d != f || ok(a, c, e)) ||
            c + d == e + f && (a + b != e + f || ok(c, a, e)) ||
            c - d == e - f && (a - b != e - f || ok(c, a, e))) {
            return 1;
        }
        return 2;
    }
};
```



## [100150. 移除后集合的最多元素数](https://leetcode.cn/problems/maximum-size-of-a-set-after-removals/)

> 贪心：先把重复的元素移除，如果不满足再将二者交集元素删除，否则删除独特的元素

```c++
class Solution {
public:
    int maximumSetSize(vector<int> &nums1, vector<int> &nums2) {
        unordered_set<int> set1(nums1.begin(), nums1.end());
        unordered_set<int> set2(nums2.begin(), nums2.end());
        // 记录相同的元素个数
        int common = 0;
        for (int x : set1) {
            common += set2.count(x);
        }
		
        // n1 表示num1的独特元素个数 ，n2也是
        int n1 = set1.size();
        int n2 = set2.size();
        // 集合论
        int ans = n1 + n2 - common;
		
        // 需要剩下的元素个数为m
        int m = nums1.size() / 2;
        if (n1 > m) {
            // 集合1不满足则删除独特元素个数
            int mn = min(n1 - m, common);
            ans -= n1 - mn - m;
            common -= mn;
        }

        if (n2 > m) {
            n2 -= min(n2 - m, common);
            ans -= n2 - m;
        }

        return ans;
    }
};

```

## [100154. 执行操作后的最大分割数量](https://leetcode.cn/problems/maximize-the-number-of-partitions-after-operations/)

> [暴力+随机可以擦边过](https://leetcode.cn/problems/maximize-the-number-of-partitions-after-operations/solutions/2594420/zui-po-su-de-bao-li-shi-cai-zui-gao-duan-w5mh)

```c++
const int N=10005;
int calc(const char *s,int n,int K,int *a){
    int ans=0;
    for (int i=0;i<n;++i)a[i]=1<<(s[i]-'a');
    const int B=1000;
    for (int i1=0;i1<min(B,n);++i1){
        int i=n>B?rand()%n:i1;
        int t=a[i];
        for (int j=0;j<26;++j){
            a[i]=1<<j;
            int cur=1;
            for (int k=0,v=0;k<n;++k){
                v|=a[k];
                if (__builtin_popcount(v)>K){
                    ++cur;
                    v=a[k];
                }
            }
            if (cur>ans)ans=cur;
        }
        a[i]=t;
    }
    return ans;
}
class Solution {
public:
    int maxPartitionsAfterOperations(string s, int k) {
        static int a[N];
        return calc(s.c_str(),s.size(),k,a);
    }
};

```

