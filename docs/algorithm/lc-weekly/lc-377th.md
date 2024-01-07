# LC377th

## [100148. 最小数字游戏](https://leetcode.cn/problems/minimum-number-game/)

```c++
class Solution {
public:
    vector<int> numberGame(vector<int>& nums) {
        priority_queue<int> tmp;
        for(auto x : nums) {
            tmp.push(-x);
        }
        vector<int> ans;
        while(!tmp.empty()) {
            int a = -tmp.top();tmp.pop();
            int b = -tmp.top();tmp.pop();
            ans.push_back(b);
            ans.push_back(a);
        }
        return ans;
    }
};
```





## [100169. 移除栅栏得到的正方形田地的最大面积](https://leetcode.cn/problems/maximum-square-area-by-removing-fences-from-a-field/)

```c++
class Solution {
    unordered_set<int> f(vector<int> &a, int mx) {
        a.push_back(1);
        a.push_back(mx);
        sort(a.begin(), a.end());
        unordered_set<int> set;
        for (int i = 0; i < a.size(); i++) {
            for (int j = i + 1; j < a.size(); j++) {
                set.insert(a[j] - a[i]);
            }
        }
        return set;
    }

public:
    int maximizeSquareArea(int m, int n, vector<int> &hFences, vector<int> &vFences) {
        auto h = f(hFences, m);
        auto v = f(vFences, n);
        if (h.size() > v.size()) {
            swap(h, v);
        }
        int ans = 0;
        for (int x: h) {
            if (v.contains(x)) {
                ans = max(ans, x);
            }
        }
        return ans ? (long long) ans * ans % 1'000'000'007 : -1;
    }
};
```





## [100156. 转换字符串的最小成本 I](https://leetcode.cn/problems/minimum-cost-to-convert-string-i/)

```c++
class Solution {
public:
    long long minimumCost(string source, string target, vector<char> &original, vector<char> &changed, vector<int> &cost) {
        int dis[26][26];
        memset(dis, 0x3f, sizeof(dis));
        for (int i = 0; i < 26; i++) {
            dis[i][i] = 0;
        }
        for (int i = 0; i < cost.size(); i++) {
            int x = original[i] - 'a';
            int y = changed[i] - 'a';
            dis[x][y] = min(dis[x][y], cost[i]);
        }
        for (int k = 0; k < 26; k++) {
            for (int i = 0; i < 26; i++) {
                for (int j = 0; j < 26; j++) {
                    dis[i][j] = min(dis[i][j], dis[i][k] + dis[k][j]);
                }
            }
        }

        long long ans = 0;
        for (int i = 0; i < source.length(); i++) {
            int d = dis[source[i] - 'a'][target[i] - 'a'];
            if (d == 0x3f3f3f3f) {
                return -1;
            }
            ans += d;
        }
        return ans;
    }
};
```



## [100158. 转换字符串的最小成本 II](https://leetcode.cn/problems/minimum-cost-to-convert-string-ii/)

```c++
struct Node {
    Node *son[26]{};
    int sid = -1; // 字符串的编号
};

class Solution {
public:
    long long minimumCost(string source, string target, vector<string> &original, vector<string> &changed, vector<int> &cost) {
        Node *root = new Node();
        int sid = 0;
        auto put = [&](string &s) -> int {
            Node *o = root;
            for (char b: s) {
                int i = b - 'a';
                if (o->son[i] == nullptr) {
                    o->son[i] = new Node();
                }
                o = o->son[i];
            }
            if (o->sid < 0) {
                o->sid = sid++;
            }
            return o->sid;
        };

        // 初始化距离矩阵
        int m = cost.size();
        vector<vector<int>> dis(m * 2, vector<int>(m * 2, INT_MAX / 2));
        for (int i = 0; i < m * 2; i++) {
            dis[i][i] = 0;
        }
        for (int i = 0; i < m; i++) {
            int x = put(original[i]);
            int y = put(changed[i]);
            dis[x][y] = min(dis[x][y], cost[i]);
        }

        // Floyd 求任意两点最短路
        for (int k = 0; k < sid; k++) {
            for (int i = 0; i < sid; i++) {
                if (dis[i][k] == INT_MAX / 2) { // 加上这句话，巨大优化！
                    continue;
                }
                for (int j = 0; j < sid; j++) {
                    dis[i][j] = min(dis[i][j], dis[i][k] + dis[k][j]);
                }
            }
        }

        int n = source.size();
        vector<long long> memo(n, -1);
        function<long long(int)> dfs = [&](int i) -> long long {
            if (i >= n) {
                return 0;
            }
            auto &res = memo[i];
            if (res != -1) {
                return res;
            }
            res = LONG_LONG_MAX / 2;
            if (source[i] == target[i]) {
                res = dfs(i + 1); // 不修改 source[i]
            }
            Node *p = root, *q = root;
            for (int j = i; j < n; j++) {
                p = p->son[source[j] - 'a'];
                q = q->son[target[j] - 'a'];
                if (p == nullptr || q == nullptr) {
                    break;
                }
                if (p->sid < 0 || q->sid < 0) {
                    continue;
                }
                // 修改从 i 到 j 的这一段
                int d = dis[p->sid][q->sid];
                if (d < INT_MAX / 2) {
                    res = min(res, dis[p->sid][q->sid] + dfs(j + 1));
                }
            }
            return res;
        };
        long long ans = dfs(0);
        return ans < LONG_LONG_MAX / 2 ? ans : -1;
    }
};
```

