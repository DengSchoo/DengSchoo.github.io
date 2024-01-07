# [LC.344th](https://leetcode.cn/contest/weekly-contest-344/)

## [6416. 找出不同元素数目差数组](https://leetcode.cn/problems/find-the-distinct-difference-array/)

> 给你一个下标从 0 开始的数组 nums ，数组长度为 n 。
>
> nums 的 不同元素数目差 数组可以用一个长度为 n 的数组 diff 表示，其中 diff[i] 等于前缀 nums[0, ..., i] 中不同元素的数目 减去 后缀 nums[i + 1, ..., n - 1] 中不同元素的数目。
>
> 返回 nums 的 不同元素数目差 数组。
>
> 注意 nums[i, ..., j] 表示 nums 的一个从下标 i 开始到下标 j 结束的子数组（包含下标 i 和 j 对应元素）。特别需要说明的是，如果 i > j ，则 nums[i, ..., j] 表示一个空子数组。

**示例 1：**

> 输入：nums = [1,2,3,4,5]
> 输出：[-3,-1,1,3,5]
> 解释：
> 对于 i = 0，前缀中有 1 个不同的元素，而在后缀中有 4 个不同的元素。因此，diff[0] = 1 - 4 = -3 。
> 对于 i = 1，前缀中有 2 个不同的元素，而在后缀中有 3 个不同的元素。因此，diff[1] = 2 - 3 = -1 。
> 对于 i = 2，前缀中有 3 个不同的元素，而在后缀中有 2 个不同的元素。因此，diff[2] = 3 - 2 = 1 。
> 对于 i = 3，前缀中有 4 个不同的元素，而在后缀中有 1 个不同的元素。因此，diff[3] = 4 - 1 = 3 。
> 对于 i = 4，前缀中有 5 个不同的元素，而在后缀中有 0 个不同的元素。因此，diff[4] = 5 - 0 = 5 。

**示例 2：**

> 输入：nums = [3,2,3,4,2]
> 输出：[-2,-1,0,2,3]
> 解释：
> 对于 i = 0，前缀中有 1 个不同的元素，而在后缀中有 3 个不同的元素。因此，diff[0] = 1 - 3 = -2 。
> 对于 i = 1，前缀中有 2 个不同的元素，而在后缀中有 3 个不同的元素。因此，diff[1] = 2 - 3 = -1 。
> 对于 i = 2，前缀中有 2 个不同的元素，而在后缀中有 2 个不同的元素。因此，diff[2] = 2 - 2 = 0 。
> 对于 i = 3，前缀中有 3 个不同的元素，而在后缀中有 1 个不同的元素。因此，diff[3] = 3 - 1 = 2 。
> 对于 i = 4，前缀中有 3 个不同的元素，而在后缀中有 0 个不同的元素。因此，diff[4] = 3 - 0 = 3 。 



简单题目模拟即可：两个set最后减去大小

```c++
class Solution {
public:
    vector<int> distinctDifferenceArray(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n, 0);
        for (int i = 0; i < n; i++) {
            unordered_set<int> set1;
            for (int j = 0; j <= i; j++) {
                set1.insert(nums[j]);
            }
            unordered_set<int> set2;
            for (int j = i + 1; j < n; j++) {
                set2.insert(nums[j]);
            }
            ans[i] = set1.size() - set2.size();
        }
        
        return ans;
    }
};
```



## [6417. 频率跟踪器](https://leetcode.cn/problems/frequency-tracker/)

> 请你设计并实现一个能够对其中的值进行跟踪的数据结构，并支持对频率相关查询进行应答。
>
> 实现 FrequencyTracker 类：
>
> - FrequencyTracker()：使用一个空数组初始化 FrequencyTracker 对象。
> - void add(int number)：添加一个 number 到数据结构中。
> - void deleteOne(int number)：从数据结构中删除一个 number 。数据结构 可能不包含 number ，在这种情况下不删除任何内容。
> - bool hasFrequency(int frequency): 如果数据结构中存在出现 frequency 次的数字，则返回 true，否则返回 false。

示例 1：

> 输入
> ["FrequencyTracker", "add", "add", "hasFrequency"]
> [[], [3], [3], [2]]
> 输出
> [null, null, null, true]
>
> 解释
> FrequencyTracker frequencyTracker = new FrequencyTracker();
> frequencyTracker.add(3); // 数据结构现在包含 [3]
> frequencyTracker.add(3); // 数据结构现在包含 [3, 3]
> frequencyTracker.hasFrequency(2); // 返回 true ，因为 3 出现 2 次



模拟数据结构，用两个map维护数据：

```c++
class FrequencyTracker {
public:
    unordered_map<int, int> mp;
    unordered_map<int, int> curSet;
    FrequencyTracker() {
        
    }
    
    void add(int number) {
        if (curSet[mp[number]] != 0)
            curSet[mp[number]] --;
        mp[number] ++;
        curSet[mp[number]] ++;
    }
    
    void deleteOne(int number) {
        if (mp.find(number) == mp.end() || mp[number] == 0) {
            return ;
        }
        curSet[mp[number]] --;
        mp[number] --;
        curSet[mp[number]] ++;
    }
    
    bool hasFrequency(int frequency) {
        return curSet[frequency] != 0;
    }
};

/**
 * Your FrequencyTracker object will be instantiated and called as such:
 * FrequencyTracker* obj = new FrequencyTracker();
 * obj->add(number);
 * obj->deleteOne(number);
 * bool param_3 = obj->hasFrequency(frequency);
 */
```



## [6418. 有相同颜色的相邻元素数目](https://leetcode.cn/problems/number-of-adjacent-elements-with-the-same-color/)

> 给你一个下标从 0 开始、长度为 n 的数组 nums 。一开始，所有元素都是 未染色 （值为 0 ）的。
>
> 给你一个二维整数数组 queries ，其中 queries[i] = [indexi, colori] 。
>
> 对于每个操作，你需要将数组 nums 中下标为 indexi 的格子染色为 colori 。
>
> 请你返回一个长度与 queries 相等的数组 answer ，其中 answer[i]是前 i 个操作 之后 ，相邻元素颜色相同的数目。
>
> 更正式的，answer[i] 是执行完前 i 个操作后，0 <= j < n - 1 的下标 j 中，满足 nums[j] == nums[j + 1] 且 nums[j] != 0 的数目。

**示例 1：**

> 输入：n = 4, queries = [[0,2],[1,2],[3,1],[1,1],[2,1]]
> 输出：[0,1,1,0,2]
> 解释：一开始数组 nums = [0,0,0,0] ，0 表示数组中还没染色的元素。
> - 第 1 个操作后，nums = [2,0,0,0] 。相邻元素颜色相同的数目为 0 。
> - 第 2 个操作后，nums = [2,2,0,0] 。相邻元素颜色相同的数目为 1 。
> - 第 3 个操作后，nums = [2,2,0,1] 。相邻元素颜色相同的数目为 1 。
> - 第 4 个操作后，nums = [2,1,0,1] 。相邻元素颜色相同的数目为 0 。
> - 第 5 个操作后，nums = [2,1,1,1] 。相邻元素颜色相同的数目为 2 。
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode.cn/problems/number-of-adjacent-elements-with-the-same-color
> 著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。



超时做法：

```c++
class Solution {
public:
    vector<int> colorTheArray(int n, vector<vector<int>>& queries) {
        vector<int> ans(queries.size(), 0);
        unordered_map<int, unordered_set<int>> mp;
        vector<int> nums(n, 0);
        int size = queries.size();
        int tmp = 0;
        for (int i = 0; i < size; i++) {
            int idx = queries[i][0];
            int col = queries[i][1];
            int oldColr = nums[idx];
            
            tmp -= check(mp[oldColr]);
            mp[oldColr].erase(idx);
            tmp += check(mp[oldColr]);
            
            tmp -= check(mp[col]);
            mp[col].insert(idx);
            tmp += check(mp[col]);
            nums[idx] = col;
            ans[i] = tmp;
        }
        return ans;
    }

    int check(unordered_set<int> &tmp) {
        if(tmp.size() <= 1) {
            return 0;
        }
        vector<int> cur;
        int ans = 0;
        cur.assign(tmp.begin(), tmp.end());
        sort(cur.begin(), cur.end());
        for (int i = 0; i + 1 < cur.size(); i++) {
            if (cur[i] + 1 == cur[i + 1]) {
                ans ++;
            }
        }
        return ans;
    }
};
```

正确做法：只关注每次更改两边元素是否联通，复用上一次结果。

```c++
class Solution {
public:
    vector<int> colorTheArray(int n, vector<vector<int>> &queries) {
        int q = queries.size(), cnt = 0;
        vector<int> ans(q), a(n + 2); // 避免讨论下标出界的情况
        for (int qi = 0; qi < q; qi++) {
            int i = queries[qi][0] + 1, c = queries[qi][1]; // 下标改成从 1 开始
            // 如果当前有颜色，则需要判断两边是否一致，如果一致则对应 + 1
            if (a[i]) cnt -= (a[i] == a[i - 1]) + (a[i] == a[i + 1]);
            // 将i设置为当前颜色
            a[i] = c;
            // 需要判断两边是否一致，如果一致则对应 + 1
            cnt += (a[i] == a[i - 1]) + (a[i] == a[i + 1]);
            ans[qi] = cnt;
        }
        return ans;
    }
};


```

## [6419. 使二叉树所有路径值相等的最小代价](https://leetcode.cn/problems/make-costs-of-paths-equal-in-a-binary-tree/)

> 给你一个整数 n 表示一棵 满二叉树 里面节点的数目，节点编号从 1 到 n 。根节点编号为 1 ，树中每个非叶子节点 i 都有两个孩子，分别是左孩子 2 * i 和右孩子 2 * i + 1 。
>
> 树中每个节点都有一个值，用下标从 0 开始、长度为 n 的整数数组 cost 表示，其中 cost[i] 是第 i + 1 个节点的值。每次操作，你可以将树中 任意 节点的值 增加 1 。你可以执行操作 任意 次。
>
> 你的目标是让根到每一个 叶子结点 的路径值相等。请你返回 最少 需要执行增加操作多少次。
>
> 注意：
>
> 满二叉树 指的是一棵树，它满足树中除了叶子节点外每个节点都恰好有 2 个节点，且所有叶子节点距离根节点距离相同。
> 路径值 指的是路径上所有节点的值之和

![image-20230507205802618](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20230507205802618.png)

解法一，贪心思路：从下到上模拟，从最后非叶子结点开始，比较结点下面的路径和，计算ans

```c++
class Solution {
public:
    int minIncrements(int n, vector<int> &cost) {
        int ans = 0;
        for (int i = n / 2; i; i--) { // 从最后一个非叶节点开始算
            ans += abs(cost[i * 2 - 1] - cost[i * 2]); // 两个子节点变成一样的
            cost[i - 1] += max(cost[i * 2 - 1], cost[i * 2]); // 累加路径和
        }
        return ans;
    }
};

```

解法儿，DSF：

```c++
class Solution {
public:
    int minIncrements(int n, vector<int>& cost) {
        int ans = 0;

        function<int(int)> dfs = [&](int i) -> int {
            if (i >= n) {
                return 0;
            }
            int sum = cost[i];
            int l = dfs(2 * i + 1); /* 求左子树的和 */
            int r = dfs(2 * i + 2); /* 求右子树的和 */
            sum += max(l, r);  /* 当前路径的和 */
            ans += abs(l - r); /* 需要平衡左右子树的操作数 */
            return sum;
        };

        dfs(0);
        return ans;
    }
};
```

