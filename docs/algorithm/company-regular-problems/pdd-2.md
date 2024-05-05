# PDD常见面试题

## [23. 合并K个排序链表](https://leetcode.cn/problems/merge-k-sorted-lists)

```c++
class Solution {
public:
    ListNode* mergeTwoLists(ListNode *a, ListNode *b) {
        if ((!a) || (!b)) return a ? a : b;
        ListNode head, *tail = &head, *aPtr = a, *bPtr = b;
        while (aPtr && bPtr) {
            if (aPtr->val < bPtr->val) {
                tail->next = aPtr; aPtr = aPtr->next;
            } else {
                tail->next = bPtr; bPtr = bPtr->next;
            }
            tail = tail->next;
        }
        tail->next = (aPtr ? aPtr : bPtr);
        return head.next;
    }

    ListNode* mergeKLists(vector<ListNode*>& lists) {
        ListNode *ans = nullptr;
        for (size_t i = 0; i < lists.size(); ++i) {
            ans = mergeTwoLists(ans, lists[i]);
        }
        return ans;
    }
};
```



## [426. 将二叉搜索树转化为排序的双向链表](https://leetcode.cn/problems/convert-binary-search-tree-to-sorted-doubly-linked-list/)

```c++
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* left;
    Node* right;

    Node() {}

    Node(int _val) {
        val = _val;
        left = NULL;
        right = NULL;
    }

    Node(int _val, Node* _left, Node* _right) {
        val = _val;
        left = _left;
        right = _right;
    }
};
*/

class Solution {
public:
Node *lastV, *firstV;

    void toDoublyList(Node* root) {
        if (!root) return ;
        auto left = root -> left, right = root -> right;
        treeToDoublyList(left);
        if (!firstV) firstV = root;
        if (lastV) {
            root -> left = lastV;
            lastV -> right = root;
        }
        lastV = root;
        treeToDoublyList(right);
    }
    Node* treeToDoublyList(Node* root) {
        if (!root) return root;
        toDoublyList(root);
        lastV -> right = firstV;
        firstV -> left = lastV;
        return firstV;
    }
};
```



## [70. 爬楼梯](https://leetcode.cn/problems/climbing-stairs)

```c++
class Solution {
public:
    int climbStairs(int n) {
        int p = 0, q = 0, r = 1;
        for (int i = 1; i <= n; ++i) {
            p = q; 
            q = r; 
            r = p + q;
        }
        return r;
    }
};
```



## [594. 最长和谐子序列](https://leetcode.cn/problems/longest-harmonious-subsequence)



```c++
class Solution {
public:
    int findLHS(vector<int>& nums) {
        unordered_map<int, int> cnt;
        int res = 0;
        for (int num : nums) {
            cnt[num]++;
        }
        for (auto [key, val] : cnt) {
            if (cnt.count(key + 1)) {
                res = max(res, val + cnt[key + 1]);
            }
        }
        return res;
    }
};
```



## [236. 二叉树的最近公共祖先](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree)



```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if(root == NULL)
            return NULL;
        if(root == p || root == q) 
            // 剪枝如果找到当前值 后续值不需要再深入
            return root;
            
        TreeNode* left =  lowestCommonAncestor(root->left, p, q);
        TreeNode* right = lowestCommonAncestor(root->right, p, q);
       
        if (!left || !right) {
            // 如果其中一侧存在空值，说明当前在同一侧，则返回不为空的为公共祖先
            return left == NULL ? right : left;
        }
             
        if(left && right) // p和q在两侧
            return root;
        
        return NULL; // 必须有返回值
    }
};
```



## [补充题4. 手撕快速排序](https://leetcode.cn/problems/sort-an-array)



```c++
class Solution {
public:

    void quickSort(vector<int> &nums, int l, int r) {
        if (l == r) return;
        
        int mid = (l + r) / 2;
        int par = nums[mid];
        int i = l - 1, j = r + 1;
        while(i < j) {
            do i++; while(nums[i] < par);
            do j--; while(nums[j] > par);
            if (i < j) swap(nums[i], nums[j]);
        }
        quickSort(nums, l, j);
        quickSort(nums, j + 1, r);
    }

    vector<int> sortArray(vector<int>& nums) {
        quickSort(nums, 0, nums.size() - 1);
        return nums;
    }
};
```



## [394. 字符串解码](https://leetcode.cn/problems/decode-string)



```c++
class Solution {
public:
    string decodeString(string s) {
    stack<int> counts;   // 用于保存重复次数的栈
    stack<string> strs;  // 用于保存当前处理的字符串的栈
    int num = 0;         // 用于累积读取完整数字
    string curr = "";    // 用于累积当前解码的字符串

    for (int i = 0; i < s.length(); i++) {
        if (isdigit(s[i])) {  
            // 当遇到数字时，继续读取整个数字
            num = num * 10 + (s[i] - '0');
        } else if (s[i] == '[') {
            // 当遇到左括号，表示一个新的编码字符串开始
            counts.push(num);    // 将累积的数字压栈
            strs.push(curr);     // 将当前字符串压栈
            num = 0;             // 重置数字和字符串，以便处理新的编码字符串
            curr = "";
        } else if (s[i] == ']') {
            // 当遇到右括号，表示当前编码字符串结束
            int count = counts.top();  // 获取当前编码字符串的重复次数
            counts.pop();
            string prev = strs.top();  // 获取之前的字符串部分
            strs.pop();
            for (int j = 0; j < count; j++) {
                prev += curr;  // 重复当前字符串指定次数并连接到之前的字符串部分
            }
            curr = prev;      // 更新当前字符串为解码后的结果
        } else {
            // 当遇到字母时，直接添加到当前字符串中
            curr += s[i];
        }
    }

    // 返回最终的解码结果
    return curr;
}
};
```



## [77. 组合](https://leetcode.cn/problems/combinations)

```c++
class Solution {
public:
    void dfs(vector<vector<int>> &ans, vector<int> &cur, int st, int n, int k) {
        if (cur.size() == k) {
            ans.emplace_back(cur);
            return;
        }
        for(int i = st; i <= n; i++) {
            cur.emplace_back(i);
            dfs(ans, cur, i + 1, n, k);
            cur.pop_back();
        }
    }
    vector<vector<int>> combine(int n, int k) {
        vector<vector<int>> ans;
        vector<int> tmp;
        dfs(ans, tmp, 1, n, k);
        return ans;
    }
};
```





## [454. 四数相加 II](https://leetcode.cn/problems/4sum-ii)

```c++
class Solution {
public:
    int fourSumCount(vector<int>& A, vector<int>& B, vector<int>& C, vector<int>& D) {
        unordered_map<int, int> countAB;
        for (int u: A) {
            for (int v: B) {
                ++countAB[u + v];
            }
        }
        int ans = 0;
        for (int u: C) {
            for (int v: D) {
                if (countAB.count(-u - v)) {
                    ans += countAB[-u - v];
                }
            }
        }
        return ans;
    }
};
```



## [380. O(1) 时间插入、删除和获取随机元素](https://leetcode.cn/problems/insert-delete-getrandom-o1/)

```c++
class RandomizedSet {
private:
    unordered_map<int,int> hash;    //哈希表储存元素值和对应下标，为了remove时实现O（1）
    vector<int> dyArray;        //vector可以作为动态数组，实现getRandom和insert的常数时间操作

public:
    /** Initialize your data structure here. */
    RandomizedSet() {

    }
    
    /** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
    bool insert(int val) {
        auto it = hash.find(val);
        if(it != hash.end()) return false;  //如果集合中已经存在val，返回false，节省时间
        dyArray.push_back(val);
        hash[val] = dyArray.size() - 1;
        return true;
    }
    
    /** Removes a value from the set. Returns true if the set contained the specified element. */
    bool remove(int val) {
        auto it = hash.find(val);
        if(it == hash.end()) return false;  //删除时，如果集合中不存在val，返回false

        int lastPos = dyArray.size() - 1;   //将被删除值和数组最后一位进行交换
        int valPos = hash[val];
        dyArray[valPos] = dyArray[lastPos];
        dyArray.pop_back();                 //vector数组删除val
        hash[dyArray[valPos]] = valPos;     //被交换的值下标发生变化，需要更新
        hash.erase(val);                    //哈希表中删除val的项
        return true;
    }
    
    /** Get a random element from the set. */
    int getRandom() {
        int size = dyArray.size();
        int pos = rand()%size;  //对下标产生随机数
        return dyArray[pos];
    }
};

/**
 * Your RandomizedSet object will be instantiated and called as such:
 * RandomizedSet* obj = new RandomizedSet();
 * bool param_1 = obj->insert(val);
 * bool param_2 = obj->remove(val);
 * int param_3 = obj->getRandom();
 */
```



## [59. 螺旋矩阵 II](https://leetcode.cn/problems/spiral-matrix-ii)

```c++
class Solution {
public:
    vector<vector<int>> generateMatrix(int n) {
        vector<vector<int>> ans(n, vector<int>(n, 0));
        int curNum = 1;
        int u = 0, d = n - 1, l = 0, r = n - 1;
        while(1) {
            for(int i = l; i <= r; i++) ans[u][i] = curNum, curNum ++;
            if (++u > d) break;
            for(int i = u; i <= d; i++) ans[i][r] = curNum, curNum++;
            if (--r < l) break;
            for(int i = r; i >= l; i--) ans[d][i] = curNum, curNum ++;
            if(--d < u) break;
            for(int i = d; i >= u; i--) ans[i][l] = curNum, curNum++;
            if (++l > r) break;
        }
        return ans;
    }
};
```



## [LCR 161. 连续天数的最高销售额](https://leetcode.cn/problems/lian-xu-zi-shu-zu-de-zui-da-he-lcof/)

```c++
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        if (nums.size() == 0) return 0;
        vector<int> dp(nums.size(), 0); // dp[i]表示包括i之前的最大连续子序列和
        dp[0] = nums[0];
        int result = dp[0];
        for (int i = 1; i < nums.size(); i++) {
            dp[i] = max(dp[i - 1] + nums[i], nums[i]); // 状态转移公式
            if (dp[i] > result) result = dp[i]; // result 保存dp[i]的最大值
        }
        return result;
    }
};
```





## [20. 有效的括号](https://leetcode.cn/problems/valid-parentheses)



```c++
class Solution {
public:
    bool isValid(string s) {
        if (s.size() == 0) return true;
        if (s[0] == ')' || s[0] == '}' || s[0] == ']') return false;
        stack<int> stk;
        stk.push(s[0]);
        for(int i = 1; i < s.size(); i++) {
            if (s[i] == '(' || s[i] == '{' || s[i] == '[')  {
                stk.push(s[i]);
                continue;
            }
            if(stk.empty()) return false;
            if (s[i] == '}') {
                if (stk.top() != '{') return false;
                stk.pop();
            } else if (s[i] == ')') {
                if (stk.top() != '(') return false;
                stk.pop();
            } else if (s[i] == ']') {
                if (stk.top() != '[') return false;
                stk.pop();
            }
        }
        return stk.empty();
    }
};
```



## [460. LFU缓存](https://leetcode.cn/problems/lfu-cache)



```c++

struct Node {
    int key, value;
    int cnt, time;
    bool operator<(const Node& rhs) const {
        // 先按照次数降序 然后按照最新时间
        return cnt == rhs.cnt ? time < rhs.time : cnt < rhs.cnt;
    }
};
class LFUCache {
private:
    unordered_map<int, Node> lfu;
    set<Node> s;
    int size;
    int time;

public:
    LFUCache(int capacity) {
        time = 0;
        size = capacity;
        lfu.clear();
        s.clear();
    }

    int get(int key) {
        if (!lfu.count(key)) {
            // 不存在直接返回-1
            return -1;
        } else {
            // 存在找到对应节点
            Node t = lfu[key];
            // 因为需要重新排序
            lfu.erase(key);
            s.erase(t);
            t.cnt = t.cnt + 1;
            t.time = ++time;
            lfu[key] = t;
            s.insert(t);
            return t.value;
        }
    }

    void put(int key, int value) {
        if (lfu.count(key)) {
            Node t = lfu[key];
            // 存在的话刷新次数和对应时间再插入排序
            lfu.erase(key);
            s.erase(t);
            t.cnt = t.cnt + 1;
            t.value = value;
            t.time = ++time;
            lfu[key] = t;
            s.insert(t);
        } else {
            // 不存在新建节点
            Node temp;
            temp.value = value;
            temp.key = key;
            temp.time = ++time;
            temp.cnt = 1;
            lfu[key] = temp;
            if (s.size() == size) {
                // 如果溢出 则用set红黑树取顶部最小指
                int k = s.begin()->key;
                lfu.erase(k);
                s.erase(s.begin());
            }
            s.insert(temp);
        }
    }
};
```



## [1004. 最大连续1的个数 III](https://leetcode.cn/problems/max-consecutive-ones-iii)

```c++
class Solution {
public:
    int longestOnes(vector<int>& A, int K) {
        int l = 0, r = 0;
        while (r < A.size()) {
            K -= 1 - A[r++]; // 1 表示不用消耗k
            if (K < 0)  // 移动窗口
                K += 1 - A[l++];
        }
        return r - l;        
    }
};

```





## [679. 24 点游戏](https://leetcode.cn/problems/24-game)



```java
class Solution {
    private static final double TARGET = 24;
    private static final double EPISLON = 1e-6;
    
    public boolean judgePoint24(int[] cards) {
        return helper(new double[]{ cards[0], cards[1], cards[2], cards[3] });
    }
    
    
    private boolean helper(double[] nums) {
        // 不断合并结果，每次计算两个数值 然后合并为一个结果 所以大小每次都会-1
        if (nums.length == 1) return Math.abs(nums[0] - TARGET) < EPISLON;
        // 每次选择两个不同的数进行回溯
        for (int i = 0; i < nums.length; i++) {
            for (int j = i + 1; j < nums.length; j++) {
                // 将选择出来的两个数的计算结果和原数组剩下的数加入 next 数组
                double[] next = new double[nums.length - 1];
                for (int k = 0, pos = 0; k < nums.length; k++) if (k != i && k != j) next[pos++] = nums[k];
                for (double num : calculate(nums[i], nums[j])) {
                    // 将i和j产生的结果放在最后
                    next[next.length - 1] = num;
                    if (helper(next)) return true;
                }
            }
        }
        return false;
    }
    
    private List<Double> calculate(double a, double b) {
        List<Double> list = new ArrayList<>();
        list.add(a + b);
        list.add(a - b);
        list.add(b - a);
        list.add(a * b);
        if (!(Math.abs(b) < EPISLON)) list.add(a / b);
        if (!(Math.abs(a) < EPISLON)) list.add(b / a);
        return list;
    }
}
```



## [695. 岛屿的最大面积](https://leetcode.cn/problems/max-area-of-island)

```c++
class Solution {
public:
    int di[4] = {0, 0, 1, -1};
    int dj[4] = {1, -1, 0, 0};
    int maxAreaOfIsland(vector<vector<int>>& grid) {
        int ans = 0;
        for (int i = 0; i != grid.size(); ++i) {
            for (int j = 0; j != grid[0].size(); ++j) {
                if (grid[i][j] == 0) continue;
                int cur = 0;
                stack<int> stacki;
                stack<int> stackj;
                stacki.push(i);
                stackj.push(j);
                while (!stacki.empty()) {
                    int cur_i = stacki.top(), cur_j = stackj.top();
                    stacki.pop();
                    stackj.pop();
                    if (cur_i < 0 || cur_j < 0 || cur_i == grid.size() || cur_j == grid[0].size() || grid[cur_i][cur_j] != 1) {
                        // 边界判断
                        continue;
                    }
                    ++cur;
                    grid[cur_i][cur_j] = 0;
                    for (int index = 0; index != 4; ++index) {
                        int next_i = cur_i + di[index], next_j = cur_j + dj[index];
                        stacki.push(next_i);
                        stackj.push(next_j);
                    }
                }
                ans = max(ans, cur);
            }
        }
        return ans;
    }
};
```





## [22. 括号生成](https://leetcode.cn/problems/generate-parentheses)

```c++
class Solution {
public:
    void backtrace(vector<string> &ans, string &cur, int open, int close, int n) {
        if (cur.size() == n * 2) ans.emplace_back(cur);
        if (open < n) {
            cur += '(';
            backtrace(ans, cur, open + 1, close, n);
            cur.pop_back();
        }
        if (close < open) {
            cur += ')';
            backtrace(ans, cur, open, close + 1, n);
            cur.pop_back();
        }
    }
    vector<string> generateParenthesis(int n) {
        vector<string> ans;
        string cur;
        backtrace(ans, cur, 0, 0, n);
        return ans;
    }
};
```



## [2. 两数相加](https://leetcode.cn/problems/add-two-numbers)

```c++
class Solution {
public:
    // l1 和 l2 为当前遍历的节点，carry 为进位
    ListNode *addTwoNumbers(ListNode *l1, ListNode *l2, int carry = 0) {
        if (l1 == nullptr && l2 == nullptr) // 递归边界：l1 和 l2 都是空节点
            return carry ? new ListNode(carry) : nullptr; // 如果进位了，就额外创建一个节点
        if (l1 == nullptr) // 如果 l1 是空的，那么此时 l2 一定不是空节点
            swap(l1, l2); // 交换 l1 与 l2，保证 l1 非空，从而简化代码
        carry += l1->val + (l2 ? l2->val : 0); // 节点值和进位加在一起
        l1->val = carry % 10; // 每个节点保存一个数位
        l1->next = addTwoNumbers(l1->next, (l2 ? l2->next : nullptr), carry / 10); // 进位
        return l1;
    }
};
```



## [252. 会议室](https://leetcode.cn/problems/meeting-rooms)

```c++
class Solution {
public:
    bool canAttendMeetings(vector<vector<int>>& intervals) {
        if (intervals.size() == 0) return true;
        sort(intervals.begin(), intervals.end());
        int n = intervals.size();
        int lastEnd = intervals[0][1];
        for(int i = 1; i < n; i++) {
            int stTime = intervals[i][0];
            if (stTime < lastEnd) {
                return false;
            }
            lastEnd = intervals[i][1];
        }
        return true;
    }
};
```





## [198. 打家劫舍](https://leetcode.cn/problems/house-robber)

```c++
class Solution {
public:
    int rob(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) return 0;
        //vector<int> dp(n + 1, 0); // dp[i]表示偷前i个房子的最大金额
        //dp[1] = nums[0];
        int cur = nums[0], pre = 0;
        for (int i = 2; i <= n; i++) {
            int temp = cur;
            cur = max(cur, pre + nums[i - 1]);
            pre = temp;
            //dp[i] = max(dp[i - 1], dp[i - 2] + nums[i - 1]);
        }
        return cur;
    }
};
```





## [16. 最接近的三数之和](https://leetcode.cn/problems/3sum-closest)



```c++
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int ans = nums[0] + nums[1] + nums[2];
        for(int i=0;i<nums.length;i++) {
            int start = i+1, end = nums.length - 1;
            while(start < end) {
                int sum = nums[start] + nums[end] + nums[i];
                if(Math.abs(target - sum) < Math.abs(target - ans))
                    ans = sum;
                if(sum > target)
                    end--;
                else if(sum < target)
                    start++;
                else
                    return ans;
            }
        }
        return ans;
    }
}

```



## [986. 区间列表的交集](https://leetcode.cn/problems/interval-list-intersections)



```c++
class Solution {
public:
    vector<vector<int>> intervalIntersection(vector<vector<int>>& firstList, vector<vector<int>>& secondList) {
        sort(firstList.begin(), firstList.end());
        sort(secondList.begin(),secondList.end());
        int x = 0, y = 0;
        vector<vector<int>> ans;
        while(x < firstList.size() && y < secondList.size()) {
            auto f = firstList[x];
            auto s = secondList[y];
            int left = max(s[0], f[0]);
            int right = min(s[1], f[1]);
            if (left <= right) {
                ans.push_back({left, right});
            }
            if(f[1] > s[1]) {
                y ++;
            } else {
                x ++;
            }
        }

        return ans;
    }
};
```



## [611. 有效三角形的个数](https://leetcode.cn/problems/valid-triangle-number)



```c++
class Solution {
public:
    int triangleNumber(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int left = j + 1, right = n - 1, k = j;
                while (left <= right) {
                    int mid = (left + right) / 2;
                    if (nums[mid] < nums[i] + nums[j]) {
                        k = mid;
                        left = mid + 1;
                    }
                    else {
                        right = mid - 1;
                    }
                }
                ans += k - j;
            }
        }
        return ans;
    }
};
```



## [237. 删除链表中的节点](https://leetcode.cn/problems/delete-node-in-a-linked-list)



```c++
class Solution {
public:
    void deleteNode(ListNode* node) {
        node->val = node->next->val;
        node->next = node->next->next;
    }
};
```



## [91. 解码方法](https://leetcode.cn/problems/decode-ways)

```c++
class Solution {
public:
    int numDecodings(string s) {
        int n = s.size();
        vector<int> f(n + 1);
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            if (s[i - 1] != '0') {
                f[i] += f[i - 1];
            }
            if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
                f[i] += f[i - 2];
            }
        }
        return f[n];
    }
};
```





## [547. 省份数量（原朋友圈）](https://leetcode.cn/problems/number-of-provinces)



```c++
class Solution {
    public int findCircleNum(int[][] isConnected) {
        int n = isConnected.length;
        // 初始化并查集
        UnionFind uf = new UnionFind(n);
        // 遍历每个顶点，将当前顶点与其邻接点进行合并
        // 无向图所以只遍历上半部分
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (isConnected[i][j] == 1) {
                    uf.union(i, j);
                }
            }
        }
        // 返回最终合并后的集合的数量
        return uf.size;
    }
}

// 并查集
class UnionFind {
    int[] roots;
    int size; // 集合数量
    
    public UnionFind(int n) {
        roots = new int[n];
        for (int i = 0; i < n; i++) {
            roots[i] = i;
        }
        size = n;
    }

    public int find(int i) {
       if (i == roots[i]) {
           return i;
       }
       return roots[i] = find(roots[i]);
    }

    public void union(int p, int q) {
        int pRoot = find(p);
        int qRoot = find(q);
        if (pRoot != qRoot) {
            roots[pRoot] = qRoot;
            size--;
        }
    }
}
```



## [1027. 最长等差数列](https://leetcode.cn/problems/longest-arithmetic-subsequence)

```c++
class Solution {
public:
    int longestArithSeqLength(vector<int>& nums) {
        int n = nums.size();
        int f[n][1001];
        memset(f, 0, sizeof(f));
        int ans = 0;
        for (int i = 1; i < n; ++i) {
            for (int k = 0; k < i; ++k) {
                int j = nums[i] - nums[k] + 500;
                f[i][j] = max(f[i][j], f[k][j] + 1);
                ans = max(ans, f[i][j]);
            }
        }
        return ans + 1;
    }
};
```



## [1019. 链表中的下一个更大节点](https://leetcode.cn/problems/next-greater-node-in-linked-list)

```c++
class Solution {
public:
    vector<int> nextLargerNodes(ListNode *head) {
        vector<int> ans;
        stack<pair<int, int>> st; // 单调栈（节点值，节点下标）
        for (auto cur = head; cur; cur = cur->next) {
            while (!st.empty() && st.top().first < cur->val) {
                ans[st.top().second] = cur->val; // 用当前节点值更新答案
                st.pop();
            }
            // 当前 ans 的长度就是当前节点的下标
            st.emplace(cur->val, ans.size());
            ans.push_back(0); // 占位
        }
        return ans;
    }
};
```



## [334. 递增的三元子序列](https://leetcode.cn/problems/increasing-triplet-subsequence)

```c++
class Solution {
public:
  bool increasingTriplet(vector<int>& nums) {
    int len = nums.size();
    if (len < 3) return false;
    int small = INT_MAX, mid = INT_MAX;
    for (auto num : nums) {
      if (num <= small) {
        small = num;
      } else if (num <= mid) {
        mid = num;
      } 
      else if (num > mid) {
        return true;
      }
    }
    return false;    
  }
};
```



## [145. 二叉树的后序遍历](https://leetcode.cn/problems/binary-tree-postorder-traversal)

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    void dfs(vector<int> &ans, TreeNode* root) {
        if (root == nullptr) return;
        dfs(ans, root -> left);
        dfs(ans, root -> right);
        ans.push_back(root -> val);
    }
    vector<int> postorderTraversal(TreeNode* root) {
        vector<int> ans;
        dfs(ans, root);
        return ans;
    }
};
```

```c++
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        stack<TreeNode*> st;
        vector<int> result;
        if (root == NULL) return result;
        st.push(root);
        while (!st.empty()) {
            TreeNode* node = st.top();
            st.pop();
            result.push_back(node->val);
            if (node->left) st.push(node->left); // 相对于前序遍历，这更改一下入栈顺序 （空节点不入栈）
            if (node->right) st.push(node->right); // 空节点不入栈
        }
        reverse(result.begin(), result.end()); // 将结果反转之后就是左右中的顺序了
        return result;
    }
};
```



中序遍历:

```c++
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> result;
        stack<TreeNode*> st;
        TreeNode* cur = root;
        while (cur != NULL || !st.empty()) {
            if (cur != NULL) { // 指针来访问节点，访问到最底层
                st.push(cur); // 将访问的节点放进栈
                cur = cur->left;                // 左
            } else {
                cur = st.top(); // 从栈里弹出的数据，就是要处理的数据（放进result数组里的数据）
                st.pop();
                result.push_back(cur->val);     // 中
                cur = cur->right;               // 右
            }
        }
        return result;
    }
};
```



## [1200. 最小绝对差](https://leetcode.cn/problems/minimum-absolute-difference)

```c++
class Solution {
public:
    vector<vector<int>> minimumAbsDifference(vector<int>& arr) {
        int minD = INT_MAX;
        int n = arr.size();
        sort(arr.begin(), arr.end());
        vector<vector<int>> ans;
        for(int i = 0; i + 1 < n; i++) {
            int d = abs(arr[i] - arr[i + 1]);
            if (d == minD) {
                ans.push_back({arr[i], arr[i + 1]});
                continue;
            }
            if (d < minD) {
                ans.clear();
                ans.push_back({arr[i], arr[i + 1]});
                minD = d;
            }
        }
        return ans;
    }
};
```



## [141. 环形链表](https://leetcode.cn/problems/linked-list-cycle)

```c++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    bool hasCycle(ListNode *head) {
        if (!head || !(head -> next)) return false;
        ListNode* slow = head, *fast = head -> next -> next;
        while(slow && fast) {
            if(slow == fast) {
                return true;
            }
            slow = slow -> next;
            if (fast -> next) {
                fast = fast -> next -> next;
            } else {
                return false;
            }
        }
        return false;
    }
};
```





## [69. x 的平方根](https://leetcode.cn/problems/sqrtx)



```c++
class Solution {
public:
    int mySqrt(int x) {
        if (x == 0) {
            return 0;
        }
        int ans = exp(0.5 * log(x));
        return ((long long)(ans + 1) * (ans + 1) <= x ? ans + 1 : ans);
    }
};
```



```c++
class Solution {
public:
    int mySqrt(int x) {
        int l = 0, r = x, ans = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if ((long long)mid * mid <= x) {
                ans = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return ans;
    }
};
```



## [1325. 删除给定值的叶子节点](https://leetcode.cn/problems/delete-leaves-with-a-given-value)

```c++
class Solution {
public:
    TreeNode* removeLeafNodes(TreeNode* root, int target) {
        if (!root) {
            return nullptr;
        }
        root->left = removeLeafNodes(root->left, target);
        root->right = removeLeafNodes(root->right, target);
        if (!root->left && !root->right && root->val == target) {
            return nullptr;
        }
        return root;
    }
};
```





## [1444. 切披萨的方案数](https://leetcode.cn/problems/number-of-ways-of-cutting-a-pizza)

```c++
class Solution {
public:
    int ways(vector<string> &pizza, int k) {
        const int MOD = 1e9 + 7;
        int m = pizza.size(), n = pizza[0].length();
        vector<vector<int>> sum(m + 1, vector<int>(n + 1)); // 二维后缀和
        vector<vector<int>> f(m + 1, vector<int>(n + 1));
        for (int i = m - 1; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                sum[i][j] = sum[i][j + 1] + sum[i + 1][j] - sum[i + 1][j + 1] + (pizza[i][j] & 1);
                if (sum[i][j]) f[i][j] = 1; // 初始值
            }
        }

        while (--k) {
            vector<int> col_s(n); // colS[j] 表示 f 第 j 列的后缀和
            for (int i = m - 1; i >= 0; i--) {
                int row_s = 0; // f[i] 的后缀和
                for (int j = n - 1; j >= 0; j--) {
                    int tmp = f[i][j];
                    if (sum[i][j] == sum[i][j + 1]) // 左边界没有苹果
                        f[i][j] = f[i][j + 1];
                    else if (sum[i][j] == sum[i + 1][j]) // 上边界没有苹果
                        f[i][j] = f[i + 1][j];
                    else // 左边界上边界都有苹果，那么无论怎么切都有苹果
                        f[i][j] = (row_s + col_s[j]) % MOD;
                    row_s = (row_s + tmp) % MOD;
                    col_s[j] = (col_s[j] + tmp) % MOD;
                }
            }
        }
        return f[0][0];
    }
};
```



## [42. 接雨水](https://leetcode.cn/problems/trapping-rain-water)

```c++
class Solution {
public:
    int trap(vector<int>& height) {
        // 单调递减栈
        stack<int> st;
        st.push(0);
        int sum = 0;
        for (int i = 1; i < height.size(); i++) {
            // 右侧值大于当前值 说明可以构成凹形
            while (!st.empty() && height[i] > height[st.top()]) {
                int mid = st.top();
                st.pop();
                if (!st.empty()) {
                    // 高度=左右两侧值-中间值
                    int h = min(height[st.top()], height[i]) - height[mid];
                    // 宽度值等于下标值
                    int w = i - st.top() - 1;
                    // 面积 = 高乘宽
                    sum += h * w;
                }
            }
            st.push(i);
        }
        return sum;
    }
};
```



## [19. 删除链表的倒数第N个节点](https://leetcode.cn/problems/remove-nth-node-from-end-of-list)

```c++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    ListNode* removeNthFromEnd(ListNode* head, int n) {
        if (head == nullptr || head -> next == nullptr) {
            return nullptr;
        }
        ListNode *pre = new ListNode(-1);
        pre -> next = head;
        ListNode *sub = head;
        while(sub && n --) {
            sub = sub -> next;
        }
        while(sub != nullptr) {
            sub = sub -> next;
            pre = pre -> next;
        }
        auto tmp = pre -> next;
        pre -> next = tmp -> next;
        return head == tmp ? head -> next : head;
    }
};
```



## [97. 交错字符串](https://leetcode.cn/problems/interleaving-string)



```c++
class Solution {
public:
    bool isInterleave(string s1, string s2, string s3) {
        int n1 = s1.size();
        int n2 = s2.size();
        if(s3.size() != n1 + n2)return false;
        vector<vector<bool>> dp(n1 + 1, vector<bool>(n2 + 1));  // dp[i][j]表示s1[0:i)和s2[0:j)是否能够构成s3[0:i+j)
        // 边界处理
        dp[0][0] = true;    
        for(int j = 1; j <= n2; j++){
            dp[0][j] = dp[0][j-1] && (s2[j-1] == s3[j-1]);  // 首行数据，i=0时s1[0:0)为空字符串；判断由仅由s2[0:j)是否可构s3[0:j)
        }
        for(int i = 1; i <= n1; i++){
            dp[i][0] = dp[i-1][0] && (s1[i-1] == s3[i-1]);  // 首列数据，j=0时s2[0:0)为空字符串；判断由仅由s1[0:i)是否可构s3[0:i)
        }
        // 状态转移：dp[i][j] = (dp[i-1][j] && s1[i-1] == s3[i+j-1]) || (dp[i][j - 1] && s2[j-1] == s3[i+j-1])
        for(int i = 1; i <= n1; i++){
            for(int j = 1; j <= n2; j++){
                // dp[i][j]状态转移，看新的字符s3[i+j-1]是否能够与s1或s2对应的字符匹配
                // 如果s1提供这个新字符s1[i-1]，就要看dp[i-1][j]示s1[0:i-1)和s2[0:j)是否能够构成s3[0:i+j-1)
                // 如果s2提供这个新字符s2[j-1]，就要看dp[i][j-1]示s1[0:i)和s2[0:j-1)是否能够构成s3[0:i+j-1)
                int p = i + j - 1;
                dp[i][j] = (dp[i-1][j] && s1[i-1] == s3[p]) || (dp[i][j - 1] && s2[j-1] == s3[p]);
            }
        }
        return dp[n1][n2];
    }
};

```

