# LC.376th

## [100149. 找出缺失和重复的数字](https://leetcode.cn/problems/find-missing-and-repeated-values/)

```c++
class Solution {
public:
    vector<int> findMissingAndRepeatedValues(vector<vector<int>>& grid) {
        int a , b;
        map<int, int> cnt;
        for(auto x : grid) {
            for(auto y : x) {
                if (cnt[y] != 0) {
                    a = y;
                }
                cnt[y]++;
            }
        }
        for(int i = 1; i <= grid.size() * grid.size(); i++) {
            if (cnt[i] == 0) {
                b = i;
                break;
            }
        }
        
        return {a, b};
    }
};
```



## [100161. 划分数组并满足最大差限制](https://leetcode.cn/problems/divide-array-into-arrays-with-max-difference/)

```c++
class Solution {
public:
    vector<vector<int>> divideArray(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        vector<vector<int>> ans;
        int n = nums.size();
        int cnt = 0;
        for(int i = 0, j = 0; i < n && j < n; ) {
            j = i;
            int curMax = nums[i], curMin = nums[j];
            vector<int> cur;
            while(j < n && curMax - curMin <= k) {
                cur.push_back(nums[j]);
                j++;
                if (cur.size() == 3) {
                    break;
                }
                if (j >= n) continue;
                curMax = max(curMax, nums[j]);
                curMin = min(curMin, nums[j]);
            }
            i = j;
            if (cur.size() < 3) {
                return {};
            }
            if (cur.size() != 0) {
                ans.push_back(cur);
            }
        }
        if (ans.size() == n / 3) {
            return ans;
        }
        return {};
    }
};
```

## [100151. 使数组成为等数数组的最小代价](https://leetcode.cn/problems/minimum-cost-to-make-array-equalindromic/)

> 1. 如何打表生成所有回文数字
> 2. 快速选择库函数，获得第M大元素：`nth_element(nums.begin(), nums.begin() + m, nums.end());`
> 3. 如何初始化函数：`auto init = [] {函数体}();`
> 4. 定义函数引用：`auto cost = [&](int i, int j) -> long long {};`
> 5. 二分查找获得对应下标：`lower_bound(pal.begin(), pal.end(), mid) - pal.begin();`

```c++
vector<int> pal;

auto init = [] {
    pal.push_back(0); // 哨兵，防止下面代码中的 i 下标越界
    // 严格按顺序从小到大生成所有回文数（不用字符串转换）
    for (int base = 1; base <= 10000; base *= 10) {
        // 生成奇数长度回文数
        for (int i = base; i < base * 10; i++) {
            int x = i;
            for (int t = i / 10; t; t /= 10) {
                x = x * 10 + t % 10;
            }
            pal.push_back(x);
        }
        // 生成偶数长度回文数
        if (base <= 1000) {
            for (int i = base; i < base * 10; i++) {
                int x = i;
                for (int t = i; t; t /= 10) {
                    x = x * 10 + t % 10;
                }
                pal.push_back(x);
            }
        }
    }
    pal.push_back(1'000'000'001); // 哨兵，防止下面代码中的 i 下标越界
    return 0;
}();

class Solution {
public:
    long long minimumCost(vector<int> &nums) {
        int m = (nums.size() - 1) / 2;
        nth_element(nums.begin(), nums.begin() + m, nums.end());
        int mid = nums[m]; // 中位数

        // 返回 nums 中的所有数变成 pal[i] 的总代价
        auto cost = [&](int i) -> long long {
            int target = pal[i];
            long long sum = 0;
            for (int x: nums) {
                sum += abs(x - target);
            }
            return sum;
        };

        // 二分找中位数右侧最近的回文数
        int i = lower_bound(pal.begin(), pal.end(), mid) - pal.begin();

        // 枚举离中位数最近的两个回文数 pal[i-1] 和 pal[i]
        return min(cost(i - 1), cost(i));
    }
};
```



## [100123. 执行操作使频率分数最大](https://leetcode.cn/problems/apply-operations-to-maximize-frequency-score/)

> 1. 前缀和+滑动窗口

```c++
class Solution {
public:
    int maxFrequencyScore(vector<int> &nums, long long k) {
        sort(nums.begin(), nums.end());

        int n = nums.size();
        vector<long long> s(n + 1, 0);
        for (int i = 0; i < n; i++) {
            s[i + 1] = s[i] + nums[i];
        }

        // 把 nums[l] 到 nums[r] 都变成 nums[i]
        auto distance_sum = [&](int l, int i, int r) -> long long {
            long long left = (long long) nums[i] * (i - l) - (s[i] - s[l]);
            long long right = s[r + 1] - s[i + 1] - (long long) nums[i] * (r - i);
            return left + right;
        };

        int ans = 0, left = 0;
        for (int i = 0; i < n; i++) {
            while (distance_sum(left, (left + i) / 2, i) > k) {
                left++;
            }
            ans = max(ans, i - left + 1);
        }
        return ans;
    }
};
```

