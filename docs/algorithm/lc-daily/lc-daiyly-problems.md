# 算法学习：

> 靡不有初系列

```python 
def sayhi():
    return "hi,Python全栈开发" # (1)
```



# LC Daily Problem

## [1078. Bigram 分词](https://leetcode-cn.com/problems/occurrences-after-bigram/)

> C++简单分词
>
> - find函数返回下标
> - erase函数移除从pos开始的n个字符

```c++
class Solution {
public:
    vector<string> findOcurrences(string text, string first, string second) {
        vector<string> ans;

        string delimiter = " ";
        text += " ";

        int pos = 0;
        string word;
        vector<string> words;
        while ((pos = text.find(delimiter)) != string::npos) { // 这里下标刚好是单词的长度
            word = text.substr(0, pos); 
            words.push_back(word);
            text.erase(0, pos + delimiter.length()); // 移除该单词以及背后的空格
        }

        for (int i = 0; i < words.size() - 2; i++) {
            if (words[i]==first && words[i+1]==second) {
                ans.push_back(words[i+2]);
            }
        }

        return ans;
    }
};


```



## [1705. 吃苹果的最大数目](https://leetcode-cn.com/problems/maximum-number-of-eaten-apples/)

> 当前n天有苹果时，将其加入优先队列(腐烂日期 -- 数量)，如果当前日期day是苹果的腐烂日期，就将其出队，否则开始吃苹果，如果当前天的苹果数大于0，开吃，如果吃完发现当前天苹果数为0，将其出队，同时累加吃到的苹果数，最终作为结果返回。

```c++
class Solution {
	public int eatenApples(int[] apples, int[] days) {
		PriorityQueue<Integer> queue = new PriorityQueue<>((a, b) -> a + days[a] - b - days[b]);
		int day = 0, ret = 0, n = apples.length;
		while (day < n || !queue.isEmpty()) {
			if (day < n && apples[day] != 0) {
				queue.offer(day);
			}

			while (!queue.isEmpty() && queue.peek() + days[queue.peek()] <= day) {
				queue.poll();
			}

			if (!queue.isEmpty()) {
				apples[queue.peek()]--;
				ret++;
				if (apples[queue.peek()] == 0) {
					queue.poll();
				}
			}
			day++;
		}
		return ret;
	}
}

```

```c++
class Solution {
public:
    int eatenApples(vector<int>& apples, vector<int>& days) {
        int ans = 0;
        int d = 0;

        map<int, int> m; // (expire, cnt)

        while (d < days.size() || !m.empty()) {
            if (d < days.size()) m[days[d]+d-1] += apples[d];
            
            // 尝试从map中取出一个最接近过期但是没有过期的苹果
            while(!m.empty()) {
                if (m.begin()->first < d || m.begin()->second == 0) m.erase(m.begin()->first);
                else {
                    // 如果找到了 我们就吃掉它
                    ans++;
                    // 苹果数要减1
                    m.begin()->second--;
                    break;
                }
            }
            d++;
        }

        return ans;
    }
};
```



## [1154. 一年中的第几天](https://leetcode-cn.com/problems/day-of-the-year/)

![image-20211221111801710](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211221111801710.png)

```c++
class Solution {
public:
    int month_day[13] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int dayOfYear(string date) {
        int year = stoi(date.substr(0, 4));
        int month = stoi(date.substr(5, 2));
        int day = stoi(date.substr(8, 2));

        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0))
            ++month_day[2];

        int ans = 0;
        for (int i = 1; i < month; i++)
            ans += month_day[i];
        return ans + day;
    }
};

```



## [475. 供暖器](https://leetcode-cn.com/problems/heaters/)

![image-20211220090248684](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211220090248684.png)

```c++
class Solution {
public:
    int findRadius(vector<int> &houses, vector<int> &heaters) {
        int ans = 0;
        sort(heaters.begin(), heaters.end());
        for (int house: houses) {
            // 找第一个大于house的 heaters[j]
            int j = upper_bound(heaters.begin(), heaters.end(), house) - heaters.begin();
            // j - 1即为下标最大的小于house
            // j - 1 <= house < j
            // ans = max(house - j + 1, j - house)
            int i = j - 1;
            int rightDistance = j >= heaters.size() ? INT_MAX : heaters[j] - house;
            int leftDistance = i < 0 ? INT_MAX : house - heaters[i];
            int curDistance = min(leftDistance, rightDistance);
            ans = max(ans, curDistance);
        }
        return ans;
    }
};
```



## [397. 整数替换](https://leetcode-cn.com/problems/integer-replacement/)

![image-20211119105902695](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211119105902695.png)

> 1. 递归
>
> ![image-20211119110012107](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211119110012107.png)

```c++
class Solution {
public:
    int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return 1 + integerReplacement(n / 2);
        }
        return 2 + min(integerReplacement(n / 2), integerReplacement(n / 2 + 1));
    }
};
```

> 2. 记忆化搜索(在1的基础上做优化) 优化在每层最多计算两次

```c++
class Solution {
private:
    unordered_map<int, int> memo;

public:
    int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (memo.count(n)) {
            return memo[n];
        }
        if (n % 2 == 0) {
            return memo[n] = 1 + integerReplacement(n / 2);
        }
        return memo[n] = 2 + min(integerReplacement(n / 2), integerReplacement(n / 2 + 1));
    }
};

```

> 3.贪心
>
> - n为偶数 首先`n/2`
> - n为奇数 看 `n%4`
>     - = 1，`(n - 1) / 2`
>     - = 3, `(n + 1) / 2`,需要特殊处理`n==3`的情况。
>
> ![image-20211119110754868](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211119110754868.png)



## [563. 二叉树的坡度](https://leetcode-cn.com/problems/binary-tree-tilt/)

![image-20211118103608021](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211118103608021.png)

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
    int ans = 0;
    int dfs(TreeNode* root) {
        if (root == nullptr) return 0;
        int left = dfs(root -> left);
        int right = dfs(root -> right);
        ans += abs(left - right);
        return left + right + root -> val; // cal函数返回值定义为返回包含root值节点得坡度 但是不影响left - right
    }
    int findTilt(TreeNode* root) {
        cal(root);
        return ans;
    }
};
```



## 

## [318. 最大单词长度乘积](https://leetcode-cn.com/problems/maximum-product-of-word-lengths/)

![image-20211117075852670](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211117075852670.png)

> 先按照长度降序排序 遍历统计 如何合适直接break即可

```c++
class Solution {
public:
    static bool cmp(string a, string b) {
        return a.length() > b.length();
    }
    int maxProduct(vector<string>& words) {
        int len = words.size();
        int ans = 0;
        sort(words.begin(), words.end(), cmp);
        for (int i = 0; i < len; i++) {
            //cout << words[i] << endl;
            vector<int> c(26, 0);
            for (int j = 0; j < words[i].length();j++) {
                c[words[i][j] - 'a']++;
            }
            for (int j = i + 1; j < len; j++) {
                int flag = 0;
                for(int k = 0; k < words[j].length(); k++) {
                    if (c[words[j][k] - 'a'] != 0) {
                        flag = 1;
                        break;
                    }
                }
                if (!flag) {
                    ans = max(ans, (int)words[i].length() * (int)words[j].length());
                    break;
                }
                
            }
        }
        return ans;
    }
};
```

> 官方题解：用32位整数来统计 通过位运算来判断两个集合存在相交的地方。

```c++
class Solution {
public:
    int maxProduct(vector<string>& words) {
        int length = words.size();
        vector<int> masks(length);
        for (int i = 0; i < length; i++) {
            string word = words[i];
            int wordLength = word.size();
            for (int j = 0; j < wordLength; j++) {
                masks[i] |= 1 << (word[j] - 'a'); // 32位表示
            }
        }
        int maxProd = 0;
        for (int i = 0; i < length; i++) {
            for (int j = i + 1; j < length; j++) {
                if ((masks[i] & masks[j]) == 0) { // 位运算统计
                    maxProd = max(maxProd, int(words[i].size() * words[j].size()));
                }
            }
        }
        return maxProd;
    }
};
```

> 1. 官方题解
> 2. 我的优化过后的算法
> 3. 没有优化的直接遍历

![image-20211117080303906](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211117080303906.png)

## [495. 提莫攻击](https://leetcode-cn.com/problems/teemo-attacking/)



![image-20211110224904444](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211110224904444.png)

```c++
class Solution {
public:
    int findPoisonedDuration(vector<int>& timeSeries, int duration) {
        int ans = duration;
        for (int i = 0; i < timeSeries.size() - 1; i++) {
            if (timeSeries[i] + duration >= timeSeries[i + 1]) ans += timeSeries[i + 1] - timeSeries[i];
            else ans += duration;
        }
        return ans;
    }
};
```



## [299. 猜数字游戏](https://leetcode-cn.com/problems/bulls-and-cows/)

![image-20211108143918068](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211108143918068.png)

> 字符串模拟

```c++
// 我的题解 差不都的思路
class Solution {
public:
    string getHint(string secret, string guess) {
        string ans = "";
        int bit[10], bit2[10];
        memset(bit, 0, sizeof bit);
        memset(bit2, 0, sizeof bit2);
        int cnt1 = 0, cnt2 = 0;
        for (int i = 0; i < secret.size(); i++) {
            if (secret[i] == guess[i]) cnt1++;
            bit[secret[i] - '0'] ++;
        }
        ans += to_string(cnt1) + "A";
        for (int i = 0; i < guess.size(); i++) {
            if (secret[i] == guess[i]) {
                bit[secret[i] - '0'] --;
                continue;
            }
            bit2[guess[i] - '0']++;
        }
        for (int i = 0; i < 10; i++) {
            cnt2 += min(bit2[i], bit[i]);
        }
        ans += to_string(cnt2) + "B";
        return ans;
    }
};
```

```c++
// 官方题解 更加简单明了
class Solution {
public:
    string getHint(string secret, string guess) {
        int bulls = 0;
        vector<int> cntS(10), cntG(10);
        for (int i = 0; i < secret.length(); ++i) {
            if (secret[i] == guess[i]) {
                ++bulls;
            } else {
                ++cntS[secret[i] - '0'];
                ++cntG[guess[i] - '0'];
            }
        }
        int cows = 0;
        for (int i = 0; i < 10; ++i) {
            cows += min(cntS[i], cntG[i]);
        }
        return to_string(bulls) + "A" + to_string(cows) + "B";
    }
};
```





## [1218. 最长定差子序列](https://leetcode-cn.com/problems/longest-arithmetic-subsequence-of-given-difference/)

![image-20211105162912743](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211105162912743.png)

> 线性DP：
>
> dp[arr[i]]表示以arr[i]结尾的子序列的最大长度
>
> 那么转移方程为：`dp[arr[i]] = dp[arr[i] - d] + 1`

```c++
class Solution {
public:
    unordered_map<int, int> dp;
    int longestSubsequence(vector<int>& arr, int difference) {
        int ans = 0;
        for (auto &it : arr) {
            dp[it] = dp[it - difference] + 1;
            ans = max(ans, dp[it]);
        }
        return ans;
    }
};
```







## [869. 重新排序得到 2 的幂](https://leetcode-cn.com/problems/reordered-power-of-2/)（2021/10/28）

![image-20211028141610834](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211028141610834.png)

> `string cnt(10, 0);`
>
> `c++ 的lamda表达式`

```c++
string countDigits(int n) {
    string cnt(10, 0);
    while (n) {
        ++cnt[n % 10];
        n /= 10;
    }
    return cnt;
}

unordered_set<string> powerOf2Digits;

int init = []() {
    for (int n = 1; n <= 1e9; n <<= 1) {
        powerOf2Digits.insert(countDigits(n));
    }
    return 0;
}();

class Solution {
public:
    bool reorderedPowerOf2(int n) {
        return powerOf2Digits.count(countDigits(n));
    }
};

```



## [496. 下一个更大元素 I](https://leetcode-cn.com/problems/next-greater-element-i/)（2021/10/26）

![image-20211026203228478](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211026203228478.png)

> 单调栈：从后往前按照底到顶递减的顺序存放

```c++
class Solution {
public:
    vector<int> nextGreaterElement(vector<int>& nums1, vector<int>& nums2) {
        unordered_map<int,int> hashmap;
        stack<int> st;
        for (int i = nums2.size() - 1; i >= 0; --i) {
            int num = nums2[i];
            while (!st.empty() && num >= st.top()) {
                st.pop();
            }
            hashmap[num] = st.empty() ? -1 : st.top();
            st.push(num);
        }
        vector<int> res(nums1.size());
        for (int i = 0; i < nums1.size(); ++i) {
            res[i] = hashmap[nums1[i]];
        }
        return res;
    }
};
```



## [240. 搜索二维矩阵 II](https://leetcode-cn.com/problems/search-a-2d-matrix-ii/)(2021/10/25)

![image-20211025112722610](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211025112722610.png)

```c++
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int m = matrix.size(), n = matrix[0].size();
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            if (matrix[x][y] > target) {
                --y; // 列数左移动 因为当前列的值都比target大
            }
            else {
                ++x; // 行数下一 因为当前行都比target小
            }
        }
        return false;
    }
};


```



## [5908. 统计最高分的节点数目](https://leetcode-cn.com/problems/count-nodes-with-the-highest-score/)

![image-20211024191404049](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211024191404049.png)

```c++
class Solution {
public:
	vector<vector<int>> child;
    vector<int> childTreeNums;
	long long ans = INT_MIN;
	int len, sum, ret = 0;
    int countHighestScoreNodes(vector<int>& parents) {
    	len = parents.size();
    	child = vector<vector<int>>(len);
    	childTreeNums = vector<int>(len,0);
        //保存孩子节点
    	for(int i = 0; i < len; ++i) 
            if(parents[i] != -1) 
                child[parents[i]].push_back(i);
    	dfs(0);
        //节点总数
    	sum = childTreeNums[0];
        //获得等于最大值的最大数目
    	for(int i = 0; i < len; i++) {
    		long long temp = getScore(i);
    		if(temp > ans){
    			ret = 1;
    			ans = temp;
    		}else if(temp == ans) ret++;
    	} 
    	return ret;
    }

    //获得所有子树的值
   	int dfs(int root){
   		if(not child[root].size()) return (childTreeNums[root] = 1);
   		for(int i = 0; i < child[root].size(); i++)	childTreeNums[root] += dfs(child[root][i]);
   		return ++childTreeNums[root];
   	}
       
    //得出删去item节点的分数，注意要开Long long
    long long getScore(int item){
    	long long score = 1;
    	score = childTreeNums[0] - childTreeNums[item] == 0 ? 1 : childTreeNums[0] - childTreeNums[item];
    	for(int i = 0; i < child[item].size(); i++)	score *= childTreeNums[child[item][i]];
    	return score;
    }
};

```



## [638. 大礼包](https://leetcode-cn.com/problems/shopping-offers/)

![image-20211024104720750](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211024104720750.png)

```c++
class Solution {
public:
    vector<int> needs_;
    vector<int> price_;
    vector<vector<int> > special_;
    int n;
    map<vector<int>, int> dp;
    int shoppingOffers(vector<int>& price, vector<vector<int>>& special, vector<int>& needs) {
        price_ = price;
        special_ = special;
        n = needs.size();
        return dfs(needs);
    }

    // 记忆化搜索 函数
    int dfs(vector<int> needs) {
        if (dp.count(needs) != 0)
            return dp[needs];

        int Min = 0;
        for (int i = 0; i < needs.size(); i++)
            Min += needs[i] * price_[i]; // 计算不用大礼包的价钱

        for (int i = 0; i < special_.size(); i++) {
            vector<int> nextNeeds = needs; // 此处不用引用 因为有循环 要深搜
            bool flag = true; // 是否超出数量
            // 计算第i个大礼包
            for (int j = 0; j < n; j++) {
                if (special_[i][j] > nextNeeds[j])
                    flag = false;
                nextNeeds[j] -= special_[i][j];
            }
            if (!flag)
                continue; // continue表示不计算本次大礼包 
            
            Min = min(Min, dfs(nextNeeds) + special_[i][n]);
        }
        return dp[needs] = Min; // 等价于return dp[needs]
    }
};

```



## [492. 构造矩形](https://leetcode-cn.com/problems/construct-the-rectangle/)

![image-20211023114741817](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211023114741817.png)

```c++
class Solution {
public:
    vector<int> constructRectangle(int area) {
        int w = sqrt(1.0 * area);
        while (area % w) {
            --w;
        }
        return {area / w, w};
    }
};
```



## [229. 求众数 II](https://leetcode-cn.com/problems/majority-element-ii/)

![image-20211022111120209](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211022111120209.png)

> 摩尔投票：解决的问题是如何在任意多的候选人中，选出票数超过一半的那个人。注意，是超出一半票数的那个人。
>
> [两幅动画演示摩尔投票法，最直观的理解方式 - 求众数 II - 力扣（LeetCode） (leetcode-cn.com)](https://leetcode-cn.com/problems/majority-element-ii/solution/liang-fu-dong-hua-yan-shi-mo-er-tou-piao-fa-zui-zh/)

```java
class Solution {
    public List<Integer> majorityElement(int[] nums) {
        // 创建返回值
        List<Integer> res = new ArrayList<>();
        if (nums == null || nums.length == 0) return res;
        // 初始化两个候选人candidate，和他们的计票
        int cand1 = nums[0], count1 = 0;
        int cand2 = nums[0], count2 = 0;

        // 摩尔投票法，分为两个阶段：配对阶段和计数阶段
        // 配对阶段
        for (int num : nums) {
            // 投票
            if (cand1 == num) {
                count1++;
                continue;
            }
            if (cand2 == num) {
                count2++;
                continue;
            }

            // 第1个候选人配对
            if (count1 == 0) {
                cand1 = num;
                count1++;
                continue;
            }
            // 第2个候选人配对
            if (count2 == 0) {
                cand2 = num;
                count2++;
                continue;
            }

            count1--;
            count2--;
        }

        // 计数阶段
        // 找到了两个候选人之后，需要确定票数是否满足大于 N/3
        count1 = 0;
        count2 = 0;
        for (int num : nums) {
            if (cand1 == num) count1++;
            else if (cand2 == num) count2++;
        }

        if (count1 > nums.length / 3) res.add(cand1);
        if (count2 > nums.length / 3) res.add(cand2);

        return res;
    }
}
```



## [66. 加一](https://leetcode-cn.com/problems/plus-one/)

![image-20211021183946597](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211021183946597.png)

> 找到第一个非9的数字

```c++
class Solution {
public:
    vector<int> plusOne(vector<int>& digits) {
        //vector<int> ans;
        int len = digits.size();
        if (len == 1 && digits[0] == 9) return{1, 0};
        if (digits[len - 1] + 1 == 10) {
            int i = len - 1;
            digits[len - 1] += 1;
            while (i >= 1 && digits[i] == 10) {
                digits[i] = 0;
                digits[i - 1] += 1;
                i--;
            }
            if (i == 0 && digits[0] == 10) {
                digits[0] = 0;
                digits.insert(digits.begin(), 1);
            }
        } else {
            digits[len - 1] += 1;
            
        }
        return digits;
    }
};
```

```c++
class Solution {
public:
    vector<int> plusOne(vector<int>& digits) {
        for (int i = digits.size() - 1; i >= 0; i--) {
            digits[i]++;
            if (digits[i] <= 9) return digits;
            digits[i] = 0;
        }
        
        digits.insert(digits.begin(), 1);
        return digits;
    }
};

```



## [453. 最小操作次数使数组元素相等](https://leetcode-cn.com/problems/minimum-moves-to-equal-array-elements/)

![image-20211020163053051](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211020163053051.png)

> 对 n - 1做加一操作 相当于对某个数做-1操作，所以问题转化为求将其它数转为最小值的次数

```c++
class Solution {
public:
    int minMoves(vector<int>& nums) {
        int minNum = *min_element(nums.begin(),nums.end());
        int res = 0;
        for (int num : nums) {
            res += num - minNum;
        }
        return res;
    }
};
```



## [211. 添加与搜索单词 - 数据结构设计](https://leetcode-cn.com/problems/design-add-and-search-words-data-structure/)

![image-20211020162938835](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211020162938835.png)

> 桶的思想：将长度相同的word存放起来。

```c++
class WordDictionary {
public:
    unordered_map<int, vector<string> > bucket;
    unordered_set<string> data;
    WordDictionary() {

    }
    
    void addWord(string word) {
        data.insert(word);
        bucket[word.size()].push_back(word);
    }

    bool cmp(string word, string target) {
        if (word.size() != target.size()) return false;

        for (int i = 0; i < word.size(); i++) {
            if (word[i] == target[i] || word[i] == '.') {

            } else {
                return false;
            }
        }
        return true;
    }
    
    bool search(string word) {
        if (data.find(word) != data.end()) {
            return true;
        } else {
            int len = word.size();
            vector<string> &tmp = bucket[len];

            for (int i = 0; i < tmp.size(); i++) {
                if (cmp(word, tmp[i])) return true;
            }
        }
        return false;
    }
};

/**
 * Your WordDictionary object will be instantiated and called as such:
 * WordDictionary* obj = new WordDictionary();
 * obj->addWord(word);
 * bool param_2 = obj->search(word);
 */
```





## [476. 数字的补数](https://leetcode-cn.com/problems/number-complement/)

![image-20211018182035405](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211018182035405.png)

> 101 + 010 = 111

```c++
class Solution {
public:
    int findComplement(int num) {
        long sum = 2;
        for (int i = 31; i >= 0; i--) {
            if ((num >> i) & 1) {
                sum = (sum << i) - 1;
                break;
            }
        }
        return sum - num;
    }
};
```



## [230. 二叉搜索树中第K小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)

![image-20211017094736049](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211017094736049.png)

> 方法一：前序遍历+小顶堆
>
> 方法二：中序遍历得到有序序列 返回nums[k-1]即可

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
    priority_queue<int, vector<int>, greater<int>> min_heap;
    void pre(TreeNode *root , int k) {
        if (!root) return;
        int val = - root -> val; // 因为是求第k小 所以取反 求第K大即可
        if (min_heap.size() < k) {
            min_heap.push(val);
        } else {
            if (min_heap.top() < val) { // 栈顶元素 比当前堆中最小值大 所以插入
                min_heap.pop();
                min_heap.push(val);
            }
        }
        pre(root -> left, k);
        pre(root -> right, k);
    }
    int kthSmallest(TreeNode* root, int k) {

        pre(root, k);
        return -min_heap.top();
    }
};
```



```c++
class Solution {
public:
    vector<int> num;
    int kthSmallest(TreeNode* root, int k) {
        dfs(root);
        return num[k - 1];
    }
    void dfs(TreeNode *node) {
        if (node->left != NULL) 
            dfs(node->left);
      	
        num.push_back(node->val);
      	
        if (node->right != NULL) 
            dfs(node->right);
        
    }
};
```



## [38. 外观数列](https://leetcode-cn.com/problems/count-and-say/)

![image-20211015102206907](https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/image-20211015102206907.png)

> 方法一：遍历生成 每次统计上一个字符串的连续数字个数`(3)1(2)2(1)3(3)4(1)5(3)6`=`312213341536`
>
> 方法二：打表，因为数字范围只有30个

```c++
class Solution {
public:
    string countAndSay(int n) {
        string prev = "1";
        for (int i = 2; i <= n; ++i) {
            string curr = "";
            int start = 0;
            int pos = 0;

            while (pos < prev.size()) {
                while (pos < prev.size() && prev[pos] == prev[start]) {
                    pos++;
                }
                curr += to_string(pos - start) + prev[start];
                start = pos;
            }
            prev = curr;
        }
        
        return prev;
    }
};
```

```c++
class Solution {
public:
    string countAndSay(int n) {
        vector<string> arr = 
        {
            "","1","11","21","1211","111221","312211","13112221","1113213211","31131211131221","13211311123113112211","11131221133112132113212221","3113112221232112111312211312113211","1321132132111213122112311311222113111221131221","11131221131211131231121113112221121321132132211331222113112211","311311222113111231131112132112311321322112111312211312111322212311322113212221","132113213221133112132113311211131221121321131211132221123113112221131112311332111213211322211312113211","11131221131211132221232112111312212321123113112221121113122113111231133221121321132132211331121321231231121113122113322113111221131221","31131122211311123113321112131221123113112211121312211213211321322112311311222113311213212322211211131221131211132221232112111312111213111213211231131122212322211331222113112211","1321132132211331121321231231121113112221121321132122311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213122112311311123112111331121113122112132113213211121332212311322113212221","11131221131211132221232112111312111213111213211231132132211211131221131211221321123113213221123113112221131112311332211211131221131211132211121312211231131112311211232221121321132132211331121321231231121113112221121321133112132112312321123113112221121113122113121113123112112322111213211322211312113211","311311222113111231133211121312211231131112311211133112111312211213211312111322211231131122211311122122111312211213211312111322211213211321322113311213212322211231131122211311123113223112111311222112132113311213211221121332211211131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221131112311311121321122112132231121113122113322113111221131221","132113213221133112132123123112111311222112132113311213211231232112311311222112111312211311123113322112132113213221133122112231131122211211131221131112311332211211131221131211132221232112111312111213322112132113213221133112132113221321123113213221121113122123211211131221222112112322211231131122211311123113321112131221123113111231121113311211131221121321131211132221123113112211121312211231131122211211133112111311222112111312211312111322211213211321322113311213211331121113122122211211132213211231131122212322211331222113112211","111312211312111322212321121113121112131112132112311321322112111312212321121113122112131112131221121321132132211231131122211331121321232221121113122113121113222123112221221321132132211231131122211331121321232221123113112221131112311332111213122112311311123112112322211211131221131211132221232112111312211322111312211213211312111322211231131122111213122112311311221132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322212321121113122123211231131122113221123113221113122112132113213211121332212311322113212221","3113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213213211221113122113121113222112132113213221232112111312111213322112132113213221133112132123123112111311222112132113311213211221121332211231131122211311123113321112131221123113112221132231131122211211131221131112311332211213211321223112111311222112132113212221132221222112112322211211131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211132221121311121312211213211312111322211213211321322113311213212322211231131122211311123113321112131221123113112211121312211213211321222113222112132113223113112221121113122113121113123112112322111213211322211312113211","132113213221133112132123123112111311222112132113311213211231232112311311222112111312211311123113322112132113212231121113112221121321132132211231232112311321322112311311222113111231133221121113122113121113221112131221123113111231121123222112132113213221133112132123123112111312111312212231131122211311123113322112111312211312111322111213122112311311123112112322211211131221131211132221232112111312111213111213211231132132211211131221232112111312212221121123222112132113213221133112132123123112111311222112132113213221132213211321322112311311222113311213212322211211131221131211221321123113213221121113122113121132211332113221122112133221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112212211131221121321131211132221123113112221131112311332211211133112111311222112111312211311123113322112111312211312111322212321121113121112133221121321132132211331121321231231121113112221121321132122311211131122211211131221131211322113322112111312211322132113213221123113112221131112311311121321122112132231121113122113322113111221131221","1113122113121113222123211211131211121311121321123113213221121113122123211211131221121311121312211213211321322112311311222113311213212322211211131221131211221321123113213221121113122113121113222112131112131221121321131211132221121321132132211331121321232221123113112221131112311322311211131122211213211331121321122112133221121113122113121113222123211211131211121311121321123113111231131122112213211321322113311213212322211231131122211311123113223112111311222112132113311213211221121332211231131122211311123113321112131221123113111231121113311211131221121321131211132221123113112211121312211231131122113221122112133221121113122113121113222123211211131211121311121321123113213221121113122113121113222113221113122113121113222112132113213221232112111312111213322112311311222113111221221113122112132113121113222112311311222113111221132221231221132221222112112322211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322111213122112311311123112112322211213211321322113312211223113112221121113122113111231133221121321132132211331121321232221123123211231132132211231131122211331121321232221123113112221131112311332111213122112311311123112112322211211131221131211132221232112111312111213111213211231132132211211131221131211221321123113213221123113112221131112211322212322211231131122211322111312211312111322211213211321322113311213211331121113122122211211132213211231131122212322211331222113112211","31131122211311123113321112131221123113111231121113311211131221121321131211132221123113112211121312211231131122211211133112111311222112111312211312111322211213211321322123211211131211121332211231131122211311122122111312211213211312111322211231131122211311123113322112111331121113112221121113122113111231133221121113122113121113222123211211131211121332211213211321322113311213211322132112311321322112111312212321121113122122211211232221123113112221131112311332111213122112311311123112111331121113122112132113311213211321222122111312211312111322212321121113121112133221121321132132211331121321132213211231132132211211131221232112111312212221121123222112132113213221133112132123123112111311222112132113311213211231232112311311222112111312211311123113322112132113212231121113112221121321132122211322212221121123222112311311222113111231133211121312211231131112311211133112111312211213211312111322211231131122211311123113322113223113112221131112311332211211131221131211132211121312211231131112311211232221121321132132211331221122311311222112111312211311123113322112132113213221133122211332111213112221133211322112211213322112111312211312111322212321121113121112131112132112311321322112111312212321121113122112131112131221121321132132211231131122211331121321232221121113122113121122132112311321322112111312211312111322211213111213122112132113121113222112132113213221133112132123222112311311222113111231132231121113112221121321133112132112211213322112111312211312111322212311222122132113213221123113112221133112132123222112111312211312111322212321121113121112133221121311121312211213211312111322211213211321322123211211131211121332211213211321322113311213212312311211131122211213211331121321122112133221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311222113111221221113122112132113121113222112132113213221133122211332111213322112132113213221132231131122211311123113322112111312211312111322212321121113122123211231131122113221123113221113122112132113213211121332212311322113212221","13211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322111213122112311311123112112322211213211321322113312211223113112221121113122113111231133221121321132132211331121321232221123123211231132132211231131122211331121321232221123113112221131112311332111213122112311311123112112322211211131221131211132221232112111312211322111312211213211312111322211231131122111213122112311311221132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221232112111312211312113211223113112221131112311332111213122112311311123112112322211211131221131211132221232112111312211322111312211213211312111322211231131122111213122112311311221132211221121332211211131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211322113321132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321322113311213212322211322132113213221133112132123222112311311222113111231132231121113112221121321133112132112211213322112111312211312111322212311222122132113213221123113112221133112132123222112111312211312111322212311322123123112111321322123122113222122211211232221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112212211131221121321131211132221123113112221131112311332211211133112111311222112111312211311123113322112111312211312111322212321121113121112133221121321132132211331121321132213211231132132211211131221232112111312212221121123222112311311222113111231133211121321321122111312211312111322211213211321322123211211131211121332211231131122211311123113321112131221123113111231121123222112111331121113112221121113122113111231133221121113122113121113221112131221123113111231121123222112111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321133112132112312321123113112221121113122113111231133221121321132132211331221122311311222112111312211311123113322112111312211312111322212311322123123112112322211211131221131211132221132213211321322113311213212322211231131122211311123113321112131221123113112211121312211213211321222113222112132113223113112221121113122113121113123112112322111213211322211312113211","11131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211132221121311121312211213211312111322211213211321322113311213212322211231131122211311123113223112111311222112132113311213211221121332211211131221131211132221231122212213211321322112311311222113311213212322211211131221131211132221232112111312111213322112131112131221121321131211132221121321132132212321121113121112133221121321132132211331121321231231121113112221121321133112132112211213322112311311222113111231133211121312211231131122211322311311222112111312211311123113322112132113212231121113112221121321132122211322212221121123222112111312211312111322212321121113121112131112132112311321322112111312212321121113122112131112131221121321132132211231131122111213122112311311222113111221131221221321132132211331121321231231121113112221121321133112132112211213322112311311222113111231133211121312211231131122211322311311222112111312211311123113322112132113212231121113112221121321132122211322212221121123222112311311222113111231133211121312211231131112311211133112111312211213211312111322211231131122111213122112311311222112111331121113112221121113122113121113222112132113213221232112111312111213322112311311222113111221221113122112132113121113222112311311222113111221132221231221132221222112112322211211131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221133112132123222112111312211312111322212321121113121112133221132211131221131211132221232112111312111213322112132113213221133112132113221321123113213221121113122123211211131221222112112322211231131122211311123113321112132132112211131221131211132221121321132132212321121113121112133221123113112221131112311332111213211322111213111213211231131211132211121311222113321132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322111213122112311311123112112322211213211321322113312211223113112221121113122113111231133221121321132132211331121321232221123123211231132132211231131122211331121321232221123113112221131112311332111213122112311311123112112322211211131221131211132221232112111312211322111312211213211312111322211231131122111213122112311311221132211221121332211213211321322113311213212312311211131211131221223113112221131112311332211211131221131211132211121312211231131112311211232221121321132132211331121321231231121113112221121321133112132112211213322112312321123113213221123113112221133112132123222112311311222113111231132231121113112221121321133112132112211213322112311311222113111231133211121312211231131112311211133112111312211213211312111322211231131122111213122112311311221132211221121332211211131221131211132221232112111312111213111213211231132132211211131221232112111312211213111213122112132113213221123113112221133112132123222112111312211312111322212311222122132113213221123113112221133112132123222112311311222113111231133211121321132211121311121321122112133221123113112221131112311332211322111312211312111322212321121113121112133221121321132132211331121321231231121113112221121321132122311211131122211211131221131211322113322112111312211322132113213221123113112221131112311311121321122112132231121113122113322113111221131221","3113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112212211131221121321131211132221123113112221131112311332211211133112111311222112111312211311123113322112111312211312111322212321121113121112133221121321132132211331121321132213211231132132211211131221232112111312212221121123222112311311222113111231133211121321321122111312211312111322211213211321322123211211131211121332211231131122211311123113321112131221123113111231121123222112111331121113112221121113122113111231133221121113122113121113221112131221123113111231121123222112111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321132132211322132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211322113321132211221121332211231131122211311123113321112131221123113111231121113311211131221121321131211132221123113112211121312211231131122211211133112111311222112111312211312111322211213211321223112111311222112132113213221133122211311221122111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321132132211322132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211322113321132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322111213122112311311123112112322211213211321322113312211223113112221121113122113111231133221121321132132211331222113321112131122211332113221122112133221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213122112311311123112112322211322311311222113111231133211121312211231131112311211232221121113122113121113222123211211131221132211131221121321131211132221123113112211121312211231131122113221122112133221121321132132211331121321231231121113121113122122311311222113111231133221121113122113121113221112131221123113111231121123222112132113213221133112132123123112111312211322311211133112111312211213211311123113223112111321322123122113222122211211232221121113122113121113222123211211131211121311121321123113213221121113122123211211131221121311121312211213211321322112311311222113311213212322211211131221131211221321123113213221121113122113121113222112131112131221121321131211132221121321132132211331121321232221123113112221131112311322311211131122211213211331121321122112133221121113122113121113222123112221221321132132211231131122211331121321232221121113122113121113222123211211131211121332211213111213122112132113121113222112132113213221232112111312111213322112132113213221133112132123123112111311222112132113311213211221121332211231131122211311123113321112131221123113112221132231131122211211131221131112311332211213211321223112111311222112132113212221132221222112112322211211131221131211132221232112111312111213111213211231131112311311221122132113213221133112132123222112311311222113111231132231121113112221121321133112132112211213322112111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121311121312211213211312111322211213211321322123211211131211121332211213211321322113311213211322132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321133112132112312321123113112221121113122113111231133221121321132122311211131122211213211321222113222122211211232221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213213211221113122113121113222112132113213221232112111312111213322112132113213221133112132123123112111312211322311211133112111312212221121123222112132113213221133112132123222113223113112221131112311332111213122112311311123112112322211211131221131211132221232112111312111213111213211231132132211211131221131211221321123113213221123113112221131112211322212322211231131122211322111312211312111322211213211321322113311213211331121113122122211211132213211231131122212322211331222113112211"
        };
        return arr[n];        
    }
};

```

```c++
class Solution {
public:
    string countAndSay(int n) {
        if (n == 1) {
            return "1";
        }
        string before = countAndSay(n - 1);
        string res;
        char cur = before[0];
        int count = 1;
        for (int i = 1; i < before.size(); ++i) {
            if (before[i] != cur) {
                res += to_string(count) + cur;
                cur = before[i];
                count = 0;
            }
            count ++;
        }
        res += to_string(count) + cur;
        return res;
    }
};
```



## [剑指 Offer II 069. 山峰数组的顶部](https://leetcode-cn.com/problems/B1IidL/)

![image-20211014105220369](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211014105220369.png)

> 二分处理

```c++
class Solution {
public:
    int peakIndexInMountainArray(vector<int>& arr) {
        if (arr.size() == 3)
            return 1;

        int l = 1, r = arr.size() - 2;
        while(l < r) {
            int mid = (l + r) / 2;
            if (arr[mid] > arr[mid - 1] && arr[mid] > arr[mid + 1]) // 已经是顶峰
                return mid;
            if (arr[mid] < arr[mid + 1] && arr[mid] > arr[mid - 1]) // 在上升阶段 需要将左端点缩小
                l = mid + 1;
            if (arr[mid] > arr[mid + 1] && arr[mid] < arr[mid - 1]) // 在下降阶段 缩小右端点
                r = mid - 1;
        }
        return l;
    }
};
```



## [29. 两数相除](https://leetcode-cn.com/problems/divide-two-integers/)

![image-20211013112341810](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211013112341810.png)

> 60 / 8 = (60 - 32) / 8 + 4 = (60 - 32 -16) / 8 + 4 + 2 = (60 - 32 -16 -8) + 4 + 2 + 1 = 7

```c++
class Solution {
public:
    int divide(int dividend, int divisor) {
        if(dividend == 0) return 0;
        if(divisor == 1) return dividend;
        if(divisor == -1){
            if(dividend>INT_MIN) return -dividend;// 只要不是最小的那个整数，都是直接返回相反数就好啦
            return INT_MAX;// 是最小的那个，那就返回最大的整数啦
        }
        long a = dividend;
        long b = divisor;
        int sign = 1; 
        if((a>0&&b<0) || (a<0&&b>0)){
            sign = -1;
        }
        a = a>0?a:-a;
        b = b>0?b:-b;
        long res = div(a,b);
        if(sign>0)return res>INT_MAX?INT_MAX:res;
        return -res;
    }
    int div(long a, long b){  // 似乎精髓和难点就在于下面这几句
        if(a<b) return 0;
        long count = 1;
        long tb = b; // 在后面的代码中不更新b
        while((tb+tb)<=a){
            count = count + count; // 最小解翻倍
            tb = tb+tb; // 当前测试的值也翻倍
        }
        return count + div(a-tb,b);
    }
};

```





## [412. Fizz Buzz](https://leetcode-cn.com/problems/fizz-buzz/)

![image-20211013102311784](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211013102311784.png)

> 模拟：`emplace_back()`在末尾添加元素，C++11添加 相比push_back()没有移动复制过程，直接在末尾创建该元素，效率更高。

```c++
class Solution {
public:
    vector<string> fizzBuzz(int n) {
        vector<string> answer;
        for (int i = 1; i <= n; i++) {
            string curr;
            if (i % 3 == 0) {
                curr　+= "Fizz";
            }
            if (i % 5 == 0) {
                curr += "Buzz";
            }
            if (curr.size() == 0) {
                curr += to_string(i);
            }            
            answer.emplace_back(curr);
        }
        return answer;
    }
};
```



## [273. 整数转换英文表示](https://leetcode-cn.com/problems/integer-to-english-words/)

![image-20211011102254505](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211011102254505.png)

> 非负整数num的最大值为2^31 - 1，因此最多有10位数，将整数按照3位一组划分，将每一组的英文表示拼接之后即可得到整数num的英文表示。
>
> 每一组最多3位数，可以使用递归的方式得到每一组的英文表示，根据数字所在范围，具体做法如下：
>
> - 小于20可以直接知道其英文表示
> - 大于20且小于100的数首先将十位转换位英文表示，对个位进行递归
> - 大于等于100的数首先将百位转换位英文表示，然后对其余部分递归转换成英文表示。

```c++
class Solution {
public:
    vector<string> singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    vector<string> teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    vector<string> tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    vector<string> thousands = {"", "Thousand", "Million", "Billion"};

    string numberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        string sb;
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                string curr;
                recursion(curr, curNum);
                curr = curr + thousands[i] + " ";
                sb = sb + curr;
            }
        }
        while (sb.back() == ' ') {
            sb.pop_back();
        }
        return sb;
    }

    void recursion(string & curr, int num) {
        if (num == 0) {
            return;
        } else if (num < 10) {
            curr = curr + singles[num] + " ";
        } else if (num < 20) {
            curr = curr + teens[num - 10] + " ";
        } else if (num < 100) {
            curr = curr + tens[num / 10] + " ";
            recursion(curr, num % 10);
        } else {
            curr = curr + singles[num / 100] + " Hundred ";
            recursion(curr, num % 100);
        }
    }
};

```



## [441. 排列硬币](https://leetcode-cn.com/problems/arranging-coins/)

![image-20211010094320650](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211010094320650.png)

> 数学推导k的范围

```c++
class Solution {
public:
    int arrangeCoins(int n) {
        // k (k + 1)  >= 2n
        // k^2 + k >= 2n
        // k2 + k + 1/4 >= 2n + 1/4
        // (2k + 1)^2 >= (8n + 1)
        //k >= (√(8n + 1) - 1) / 2

        return (sqrt(8 * (long)n + 1) - 1) / 2;

    }
};
```



## [187. 重复的DNA序列](https://leetcode-cn.com/problems/repeated-dna-sequences/)

![image-20211008092755429](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211008092755429.png)

> 1. Hash表O(NL)
> 2. 位运算O(N),四个核苷酸，对应0,1,2,3
>     1. 滑动窗口左移 `x = x << 2`
>     2. 新的ch进入窗口`x = x | bin[ch]`
>     3. 窗口左边的字符离开窗口`x = x & ((1 << 20) - 1)`,只保留低20位，其余位置零。
>     4. 以上三步合并可以用O(1)的时间计算出下一个子串的整数表示`x= ((x << 2) | bin[ch] & ((1 << 20) - 1)`

```c++
class Solution {
    const int L = 10;
public:
    vector<string> findRepeatedDnaSequences(string s) {
        vector<string> ans;
        unordered_map<string, int> cnt;
        int n = s.length();
        for (int i = 0; i <= n - L; ++i) {
            string sub = s.substr(i, L);
            if (++cnt[sub] == 2) {
                ans.push_back(sub);
            }
        }
        return ans;
    }
};
```

```c++
class Solution {
    const int L = 10;
    unordered_map<char, int> bin = {{'A', 0}, {'C', 1}, {'G', 2}, {'T', 3}};
public:
    vector<string> findRepeatedDnaSequences(string s) {
        vector<string> ans;
        int n = s.length();
        if (n <= L) {
            return ans;
        }
        int x = 0;
        for (int i = 0; i < L - 1; ++i) {
            x = (x << 2) | bin[s[i]];
        }
        unordered_map<int, int> cnt;
        for (int i = 0; i <= n - L; ++i) {
            x = ((x << 2) | bin[s[i + L - 1]]) & ((1 << (L * 2)) - 1);
            if (++cnt[x] == 2) {
                ans.push_back(s.substr(i, L));
            }
        }
        return ans;
    }
};

```





## [434. 字符串中的单词数](https://leetcode-cn.com/problems/number-of-segments-in-a-string/)

![image-20211007162819370](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211007162819370.png)

> 简单模拟

```c++
class Solution {
public:
    int countSegments(string s) {
        int cur = 0;
        int len = s.length();
        while (cur  < len && s[cur] == ' ') cur++;
        int ans = 0;
        while (cur < len) {
            while (cur < len && s[cur] != ' ') cur++;
            while (cur < len && s[cur] == ' ') cur++;
            ans++;
        }
        return ans;
    }
};
```



## [414. 第三大的数](https://leetcode-cn.com/problems/third-maximum-number/)

![image-20211006101926639](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211006101926639.png)

> 1. 排序取第三大数
> 2. 借助有序集合
> 3. 维护三个数

```c++
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        sort(nums.begin(), nums.end(), greater<>());
        for (int i = 1, diff = 1; i < nums.size(); ++i) {
            if (nums[i] != nums[i - 1] && ++diff == 3) { // 此时 nums[i] 就是第三大的数
                return nums[i];
            }
        }
        return nums[0];
    }
};


```

> set自排序

```c++
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        set<int> s;
        for (int num : nums) {
            s.insert(num);
            if (s.size() > 3) {
                s.erase(s.begin());
            }
        }
        return s.size() == 3 ? *s.begin() : *s.rbegin();
    }
};
```

> 维护三个数, 借助指针可以不用考虑数字范围，用空表示无穷小

```c++
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        long a = LONG_MIN, b = LONG_MIN, c = LONG_MIN;
        for (long num : nums) {
            if (num > a) {
                c = b;
                b = a;
                a = num;
            } else if (a > num && num > b) {
                c = b;
                b = num;
            } else if (b > num && num > c) {
                c = num;
            }
        }
        return c == LONG_MIN ? a : c;
    }
};

```

```c++
class Solution {
public:
    int thirdMax(vector<int> &nums) {
        int *a = nullptr, *b = nullptr, *c = nullptr;
        for (int &num : nums) {
            if (a == nullptr || num > *a) {
                c = b;
                b = a;
                a = &num;
            } else if (*a > num && (b == nullptr || num > *b)) {
                c = b;
                b = &num;
            } else if (b != nullptr && *b > num && (c == nullptr || num > *c)) {
                c = &num;
            }
        }
        return c == nullptr ? *a : *c;
    }
};

```

> 借助库函数: unique返回去重后的最后一个位置, 但只是逻辑删除，vector大小并没有变化。

```c++
class Solution {
public:
    int thirdMax(vector<int>& nums) {
        sort(nums.begin(), nums.end(), greater<int>());
        nums.erase(unique(nums.begin(), nums.end()), nums.end());

        return nums.size() < 3 ? nums[0] : nums[2];
    }
};
```



## [482. 密钥格式化](https://leetcode-cn.com/problems/license-key-formatting/)

![image-20211004103030691](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211004103030691.png)

> 字符串模拟

```c++
class Solution {
public:
    string licenseKeyFormatting(string s, int k) {
        int cnt = 0;
        string str = "";
        for (int i = 0; i < s.length(); i++) {
            if (s[i] != '-') cnt++, str += s[i];
            
        }
        int g = cnt / k;
        int r = cnt % k;
        string ans = "";
        for (int i = 0; i < r; i++) {
            ans += toupper(str[i]);
        }
        if (r && cnt > 1)
            ans += "-";
        for (int i = 0; i < g; i++) {
            for (int j = 0; j  < k; j++) {
                ans += toupper(str[i *k + j + r]);
            }
            if (i != g - 1)
                ans += "-";
        }
        return ans;
    }
};
```



## [166. 分数到小数](https://leetcode-cn.com/problems/fraction-to-recurring-decimal/)

![image-20211003104418099](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211003104418099.png)

> 用map存一下当前被除数对应在结果小数index，如果不为空说明有循环节，那么就做字符串做裁剪。
>
> 1、数字正负处理：都转为正数
>
> 2、得到小数前的整数
>
> 3、取余得到后面小数

```c++
class Solution {
    using ll = long long;
public:
    string fractionToDecimal(int numerator, int denominator) {
        ll n = numerator, d = denominator;
        string ret;
        // 计算整数部分
        // 判断负数
        if(n * d < 0) ret += "-";


        ll a = n / d;
        if(a < 0) a *= -1;
        ret += to_string(a);

        if(n < 0) n*= -1;
        if(d < 0) d*= -1;

        // 计算小数部分
        n %= d;
        if(n == 0) {
            // 无小数
            return ret;
        }
        ret += ".";
        // 连除
        // 哈希表记录是否有数组第二次出现
        unordered_map<int, int> st;
        string t;
        int index = 0;
        while(n && !st.count(n)) {
            st[n] = index++;
            n *= 10;
            t.push_back((char)(n / d + '0'));
            n %= d;
        }
        if(n != 0) {
            // 说明出现了循环，此时对循环部分 [st[n], index] 加括号
            ret += t.substr(0, st[n]) + "(" + t.substr(st[n]) + ")";
        } else {
            ret += t;
        }
        return ret;
    }
};

```





## [405. 数字转换为十六进制数](https://leetcode-cn.com/problems/convert-a-number-to-hexadecimal/)

![image-20211002101423155](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211002101423155.png)

> 四位一位做运算

```c++
class Solution {
public:
    string toHex(int num) {
        if (num == 0) {
            return "0";
        }
        string sb;
        for (int i = 7; i >= 0; i --) {
            int val = (num >> (4 * i)) & 0xf;// 1111
            if (sb.length() > 0 || val > 0) {
                char digit = val < 10 ? (char) ('0' + val) : (char) ('a' + val - 10);
                sb.push_back(digit);
            }
        }
        return sb;
    }
};
```



## [223. 矩形面积](https://leetcode-cn.com/problems/rectangle-area/)



![image-20211002100958493](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211002100958493.png)

> 容斥原理 + x，y方向投影算面积

```c++
class Solution {
public:
    int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
        int area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
        int overlapWidth = min(ax2, bx2) - max(ax1, bx1), overlapHeight = min(ay2, by2) - max(ay1, by1);
        int overlapArea = max(overlapWidth, 0) * max(overlapHeight, 0);
        return area1 + area2 - overlapArea;
    }
};
```



## [326. 3的幂](https://leetcode-cn.com/problems/power-of-three/)

![image-20210923101748080](https://gitee.com/DengSchoo374/img/raw/master/img/image-20210923101748080.png)

> 试除法

```c++
class Solution {
public:
    bool isPowerOfThree(int n) {
        while (n && n % 3 == 0) {
            n /= 3;
        }
        return n == 1;
    }
};
```



> 在32位整数中 3的幂的最大为3^19 = 1162261467， 只要证明n是该值的约数即可

```c++
class Solution {
public:
    bool isPowerOfThree(int n) {
        return n > 0 && 1162261467 % n == 0;
    }
};
```



## [58. 最后一个单词的长度](https://leetcode-cn.com/problems/length-of-last-word/)

![image-20210922200204865](https://gitee.com/DengSchoo374/img/raw/master/img/image-20210922200204865.png)

```C++
class Solution {
public:
    int lengthOfLastWord(string s) {
        int len = s.size() - 1;
        int ans = 0;
        while (len >= 0 && s[len] == ' ') len--;
        while (len >= 0 && s[len] != ' ') ans++, len--;
        return ans;
    }
};
```



## [725. 分隔链表](https://leetcode-cn.com/problems/split-linked-list-in-parts/)

![image-20210922195950390](https://gitee.com/DengSchoo374/img/raw/master/img/image-20210922195950390.png)

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
    vector<ListNode*> splitListToParts(ListNode* head, int k) {
        int len = 0;
        ListNode* tmp = head;
        vector<ListNode*>  ans;
        while (tmp) {
            len ++;
            tmp = tmp -> next;
        }
        int remain = len % k;
        int size = len / k;
        ListNode * start = head, *end = head;
        for (int i = 0; i < k; i++) {
            for (int j = 0; j < size - 1; j++) {
                end = end -> next;
            }
            if (remain) {
                remain--;
                if (end != nullptr && end != start)
                    end = end -> next;
                else if (end != nullptr && size == 1)
                    end = end -> next;
            }
            ans.push_back(start);
            if (end != nullptr) {
                start = end -> next;
                end -> next = nullptr;
                end = start;
            }

        }
        return ans;
    }
};
```



## [524. 通过删除字母匹配到字典里最长单词](https://leetcode-cn.com/problems/longest-word-in-dictionary-through-deleting/)

![image-20210914130247376](C:\Users\联想\AppData\Roaming\Typora\typora-user-images\image-20210914130247376.png)

```c++
class Solution {
public:

    bool check(string &tar, string &tmp) {
        int j = 0;
        if (tar.length() < tmp.length()) return false;
        for (int i = 0; i < tmp.length(); i++) {
            while (j < tar.length() && tar[j] != tmp[i]) j++;
            
            if (j == tar.length()) return false;
            else j++;
        }
        return true;
    }
    static bool cmp(string a, string b) {
        if (a.length() == b.length()){
            return a < b;
        }
        return a.length() > b.length();
    }
    string findLongestWord(string s, vector<string>& dictionary) {
        int len = dictionary.size();
        string ans = "";
        for (int i = 0; i < len; i++) {
            string str = dictionary[i];
            if (check(s, str)) {
                //candidater.push_back(str);
                if (ans.length() < str.length()) {
                    ans = str;
                } else if (ans.length() == str.length() && str < ans)
                    ans = str;
            }
        }
        return ans;
    }
};
```

```c++
class Solution {
public:
    bool isSubsequence(string s, string t) {
        // 判断 t 是否是 s 的子序列

        int n = s.size(), m = t.size();
        
        // 如果 t 长度大于 s，一定不是子序列
        if(m > n) return false;

        // 记录当前 s 中匹配到了哪个位置
        int i = 0;
        for(char ch : t) {
            while(i < n && s[i] != ch) i++;
            if(i >= n) return false;

            // 此时 s[i] = ch，下次要从 s[i + 1] 开始匹配
            i++;
        }

        return true;
    }

    string findLongestWord(string s, vector<string>& dictionary) {
        // 更长的、字典序更小的排在前面，这样一旦找到，就是结果
        sort(dictionary.begin(), dictionary.end(), [&](string &a, string &b) {
            if(a.size() == b.size()) return a < b;
            return a.size() > b.size();
        });

        for(string &t : dictionary) {
            if(isSubsequence(s, t)) return t;
        }

        // 如果没找到
        return "";
    }
};

```





## [678. 有效的括号字符串](https://leetcode-cn.com/problems/valid-parenthesis-string/)

![image-20210912093902698](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210912093902698.png)

> 双向扫描：
>
> - 从左向右如果存在`)`就需要将左括号的数量减一，否则其它情况+1
> - 从右向左如果存在`(`就需要将右括号的数量减一，否则其它情况+1
> - 如果左右扫描都没有问题的话就说明是一个有效的字符串

```c++
class Solution {
public:
    bool checkValidString(string s) {
        int left = 0, right = 0, size = s.size();
        for(int i = 0; i < size; ++i)
        {
            left  += s[i] == ')' ? -1 : 1;              //从左向右
            right += s[size-1-i] == '(' ? -1 : 1;       //从右向左
            if(left < 0 || right < 0)    return false;  //无效
        }
        return true;
    }
};
```



## [600. 不含连续1的非负整数](https://leetcode-cn.com/problems/non-negative-integers-without-consecutive-ones/)

![image-20210912093459920](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210912093459920.png)

> 暴力会超时
>
> 可以去构造这样的一个非负整数
>
> - 如果前一位是0则下一位可以是0也可以是1 
>
> - 如果前一位是1则下一位只能是0

```c++
class Solution {
public:
    int ans = 0;
    int g_n;
    set<int> st;
    int findIntegers(int n) {
        g_n = n;
        ans = 1;
        dfs(1);
        return ans;
    }

    void dfs(int cur){
        if(cur > g_n) return;
        ans++;
        if((cur & 1)){
            dfs(cur << 1);
        } 
        else{
            dfs(cur << 1);
            dfs((cur << 1)+1);
        }
        return;
    }
};

```

```c++
class Solution {
public:
    int nums[32];
    int cnt = 0;
    const int MAX = 1e9;
    void init() {
        int cur = 3;
        while (cur <= MAX) {
            nums[cnt] = cur;
            cnt ++;
            cur <<= 1;
        }
    }
    bool check(int x) {
        for (int i = 0; i <cnt ;i++) {
            if ((x & nums[i]) == nums[i]) {
                return false;
            }
        }
        return true;
    }
    int findIntegers(int n) {
        init();
        int ans = 0;
        for (int i = 0; i <= n; i++) {
            if (check(i)) ans++;
        }
        return ans;
    }
};
```





## [1221. 分割平衡字符串](https://leetcode-cn.com/problems/split-a-string-in-balanced-strings/)

![image-20210907160830104](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210907160830104.png)

> 对任一平衡字符串中的最短平衡前缀做切分 切分后的得到两个平衡前缀。

```c++
class Solution {
public:
    int balancedStringSplit(string s) {
        int ans = 0, d = 0;
        for (char ch : s) {
            ch == 'L' ? ++d : --d;
            if (d == 0) {
                ++ans;
            }
        }
        return ans;
    }
};

```



## [704. 二分查找](https://leetcode-cn.com/problems/binary-search/)

![image-20210906093051647](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210906093051647.png)

```c++
class Solution {
public:
    int search(vector<int>& nums, int target) {
        int l = 0, r = nums.size();
        int mid = (l + r) / 2;
        while (l <= r) {
            mid = (l + r) / 2;
            if (nums[mid] == target) {
                return mid;
            } else if (nums[mid] > target) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return -1;
    }
};
```





## [470. 用 Rand7() 实现 Rand10()](https://leetcode-cn.com/problems/implement-rand10-using-rand7/)

![image-20210905093555464](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210905093555464.png)

> rand10 = rand5  * 2 + (rand2) * ( -1)

```c++
// The rand7() API is already defined for you.
// int rand7();
// @return a random integer in the range 1 to 7

class Solution {
public:
    int rand10() {
        int a = rand5(); 
        int b = rand2(); 
        return 2 * a + (b - 1);
    }
    // [1- 5]
    int rand5() {
        int ans = rand7();
        while (ans > 5) ans = rand7();
        return ans;
    }
    // [0 , 1]
    int rand2() {
        int ans = rand7();
        while (ans == 7) ans = rand7();
        return ans % 2;
    }
};
```



## [剑指 Offer 22. 链表中倒数第k个节点](https://leetcode-cn.com/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof/)

![image-20210902203038435](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210902203038435.png)

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
    ListNode* getKthFromEnd(ListNode* head, int k) {
        ListNode *new_head = head, *ans = head;
        for (int i = 0; i < k; i++) {
            if (new_head)
                new_head = new_head -> next;
        }

        while (new_head) {
            ans = ans -> next;
            new_head = new_head ->next;
        }
        return ans;
    }
};
```



## [1109. 航班预订统计](https://leetcode-cn.com/problems/corporate-flight-bookings/)

![image-20210901215522032](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210901215522032.png)

> 差分：差分数组对应的概念是前缀和数组，对于数组 [1,2,2,4][1,2,2,4]，其差分数组为 [1,1,0,2][1,1,0,2]，差分数组的第 ii 个数即为原数组的第 i-1i−1 个元素和第 ii 个元素的差值，也就是说我们对差分数组求前缀和即可得到原数组。
>
> 差分数组的性质是，当我们希望对原数组的某一个区间` [l,r][l,r] `施加一个增量`inc` 时，差分数组 d 对应的改变是：`d[l][l] `增加 `inc`，`d[r+1][r+1]` 减少 `inc`
>
> 换一种思路理解题意，将问题转换为：某公交车共有 n 站，第 i 条记录 bookings[i] = [i, j, k] 表示在 i 站上车 k 人，乘坐到 j 站，在 j+1 站下车，需要按照车站顺序返回每一站车上的人数
>
> 根据 1 的思路，定义 counter[] 数组记录每站的人数变化，counter[i] 表示第 i+1 站。遍历 bookings[]：bookings[i] = [i, j, k] 表示在 i 站增加 k 人即 counters[i-1] += k，在 j+1 站减少 k 人即 counters[j] -= k
>
> 遍历（整理）counter[] 数组，得到每站总人数： 每站的人数为前一站人数加上当前人数变化 counters[i] += counters[i - 1]

## [165. 比较版本号](https://leetcode-cn.com/problems/compare-version-numbers/)

![image-20210901214647025](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210901214647025.png)

> 切分字符串 --- java版本
>
> 按照.切分然后比较每一节的字符串的int值

```java
class Solution {
    public int compareVersion(String version1, String version2) {
        String[] v1 = version1.split("\\.");
        String[] v2 = version2.split("\\.");
        for (int i = 0; i < v1.length || i < v2.length; ++i) {
            int x = 0, y = 0;
            if (i < v1.length) {
                x = Integer.parseInt(v1[i]);
            }
            if (i < v2.length) {
                y = Integer.parseInt(v2[i]);
            }
            if (x > y) {
                return 1;
            }
            if (x < y) {
                return -1;
            }
        }
        return 0;
    }
}
```

> 双指针C++:题目中提到每一节的版本号都可以存下来

```c++
class Solution {
public:
    int compareVersion(string version1, string version2) {
        int n = version1.length(), m = version2.length();
        int i = 0, j = 0;
        while (i < n || j < m) {
            int x = 0;
            for (; i < n && version1[i] != '.'; ++i) {
                x = x * 10 + version1[i] - '0';
            }
            ++i; // 跳过点号
            int y = 0;
            for (; j < m && version2[j] != '.'; ++j) {
                y = y * 10 + version2[j] - '0';
            }
            ++j; // 跳过点号
            if (x != y) {
                return x > y ? 1 : -1;
            }
        }
        return 0;
    }
};

```



## [1646. 获取生成数组中的最大值](https://leetcode-cn.com/problems/get-maximum-in-generated-array/)

![image-20210823090236406](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210823090236406.png)

> 简单模拟
>
> `max_element(v.begin(), v.end())`

```c++
class Solution {
public:
    int getMaximumGenerated(int n) {
        if (n == 0) {
            return 0;
        }
        vector<int> nums(n + 1);
        nums[1] = 1;
        for (int i = 2; i <= n; ++i) {
            nums[i] = nums[i / 2] + i % 2 * nums[i / 2 + 1];
        }
        return *max_element(nums.begin(), nums.end());
    }
};

```



## [576. 出界的路径数](https://leetcode-cn.com/problems/out-of-boundary-paths/)

![image-20210815154054540](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210815154054540.png)

> 深搜一定会超时，超时的原因是因为重复计算了 所以需要保留状态：坐标+剩下的步数即可唯一确定是相同状态。

```c++
class Solution {
public:
    int findPaths(int m, int n, int maxMove, int startRow, int startColumn) {
        this->m = m;
        this->n = n;
        memset(dp, -1, sizeof(dp));
        return DFS(startRow, startColumn, maxMove); //搜索从这个点开始有多少路径出界
    }
private:
    const int M  = 1e9 + 7;
    int m, n;
    int dp[51][51][51];     //记忆数组
    long DFS(int i, int j, int d){
        if(i < 0 || i >= m || j < 0 || j >= n) return 1;  //出界了
        if(d == 0) return 0;  //已经没有步数了
        if(dp[i][j][d] != -1) return dp[i][j][d];  //如果之前来过
        return dp[i][j][d] = (DFS(i + 1, j, d - 1) + DFS(i - 1, j, d - 1) + DFS(i, j + 1, d - 1) + DFS(i, j - 1, d - 1)) % M;   //如果之前没来过
    }
};
\
```



## [1583. 统计不开心的朋友](https://leetcode-cn.com/problems/count-unhappy-friends/)

![image-20210814102901975](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210814102901975.png)

> map预处理 + set去重

```c++
class Solution {
public:
    set<int> s;
    bool func(int x, int y, int u, int v,  map<pair<int, int>, int> &m) {
        if (s.find(x) == s.end() && m[{x, u}] > m[{x, y}] && m[{u, x}] > m[{u, v}]) {
            s.insert(x);
            return  1;
        }
        return 0;
    }
    map<pair<int, int>, int> init(vector<vector<int>>& p) {
        map<pair<int, int>, int> ret;
        int n = p.size();
        for (int i = 0; i < n ;i++) {
            for (int j = 0; j < n - 1; j++) {
                ret[{i, p[i][j]}] = n - 1 - j;
            }
        }
        return ret;
    }
    int unhappyFriends(int n, vector<vector<int>>& p, vector<vector<int>>& pairs) {
        int ans = 0;
        map<pair<int, int>, int> m = init(p);
        int np = pairs.size();
        for (int i = 0; i < np; i++) {
            int x = pairs[i][0], y = pairs[i][1];
            for (int j = 0; j < np; j++) {
                int u = pairs[j][0], v = pairs[j][1];
                ans += func(x, y, u, v , m);
                ans += func(y, x, u, v, m);
                ans += func(x, y, v, u, m);
                ans += func(y, x, v, u, m);
            }
        }

        return ans;
    }
};
```



## [1337. 矩阵中战斗力最弱的 K 行](https://leetcode-cn.com/problems/the-k-weakest-rows-in-a-matrix/)

![image-20210801173004417](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210801173004417.png)

```c++
class Solution {
public:
    vector<int> kWeakestRows(vector<vector<int>>& mat, int k) {
        vector<pair<int, int> > vp;
        vector<int> ans(k, 0);
        for (int i = 0; i < mat.size(); i++) {
            int cnt = 0;
            for (int j = 0; j < mat[i].size(); j++) {
                if (mat[i][j] == 0) {
                    break;
                } else {
                    cnt++;
                }
            }
            pair<int, int> a = {cnt, i};
            vp.push_back(a);
        }
        sort(vp.begin(), vp.end());
        for (int i = 0; i < k; i++) {
            ans[i] = vp[i].second;
        }
        return ans;
    }
};
```

> pair用法：`pair<int, int> p(V1, V2)`

## [374. 猜数字大小](https://leetcode-cn.com/problems/guess-number-higher-or-lower/)

![image-20210614182933339](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210614182933339.png)

> 二分查找

```c++
/** 
 * Forward declaration of guess API.
 * @param  num   your guess
 * @return 	     -1 if num is lower than the guess number
 *			      1 if num is higher than the guess number
 *               otherwise return 0
 * int guess(int num);
 */

class Solution {
public:
    int guessNumber(int n) {
        long left = 0;
        long right = n;
        long mid = right / 2;
        while (guess(mid) != 0) {
            if (guess(mid) == -1) {
                right = mid;
            } else {
                left = mid + 1;
            }
            mid = (left + right) / 2;
        }
        return mid;
    }
};
```



## [203. 移除链表元素](https://leetcode-cn.com/problems/remove-linked-list-elements/)

![image-20210605091458247](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210605091458247.png)

> 双指针 预处理头部

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
    ListNode* removeElements(ListNode* head, int val) {
        
        ListNode * last = head;
        // 特殊处理头部 找到第一个不是val 可以作为前驱结点的值
        while (last && last -> val == val) {
            last = last -> next;
        }
        // 记录前驱结点
        ListNode * pre = last;
        head = pre;  // 记录头节点
        // 将last指针后移
        if (last) last = last -> next;
        while (last != nullptr) {
            
            if (last -> val == val)  
                pre -> next = last -> next; // pre跳过last结点 将last结点删除
            else 
                pre = last; // 当last不为val 时才移动pre
            
            
            // last 每次都要移动
            last = last -> next;
        }
        return head;
    }
};
```



## [160. 相交链表](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)

![image-20210604091537470](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210604091537470.png)

> 哈希集合存放一条链路完整路径，检查第二条链路是否有重复结点
>
> 双指针：思想如果两个链表长度不同，而指针的步调是一致的，那么在一次交换遍历后，就会相遇。
>
> ![image-20210604091604685](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210604091604685.png)
>
> 证明：A的长度为`lena`， B的长度为`lenb`。假设在第一次遍历之后A首先达到`nullptr`,后从B开始继续遍历，当B结束之后，A在B链路上多走的步数为lenb - lena为1(上图为1)，此时二者同步位置，即从此时开始二者后续遍历的元素个数就相同了，故再按照相同的步调走的话，如果存在A = B，就说明有相交的交点。

```c++
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        if (headA == nullptr || headB == nullptr) {
            return nullptr;
        }
        ListNode *pA = headA, *pB = headB;
        while (pA != pB) {
            pA = pA == nullptr ? headB : pA->next;
            pB = pB == nullptr ? headA : pB->next;
        }
        return pA;
    }
};
```

```c++
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        unordered_set<ListNode *> record;
        while (headA != nullptr) {
            record.insert(headA);
            headA = headA -> next;
        }
        while (headB != nullptr) {
            if (record.count(headB)) {
                return headB;
            }
            headB = headB -> next;
        }
        return nullptr;

    }
};
```



## [525. 连续数组](https://leetcode-cn.com/problems/contiguous-array/)、

> 前缀和+哈希+数学推导
>
> ![image-20210603075345587](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210603075345587.png)

```c++
class Solution {
public:
    int findMaxLength(vector<int>& nums) {
        int n = nums.size();
        if(n <= 1) return 0;
        //[j, i]
        //2(pre[i+1] - pre[j]) = i+1 -j
        //2pre[i+1] - (i+1) = 2pre[j] - j;
        unordered_map<int, int> mp;
        int pre = 0, res = 0;
        mp[0] = 0;
        for(int i=0; i<n; ++i) {
            pre += nums[i];
            int now = 2*pre - (i+1);
            if(mp.count(now)) {
                res = max(res, i+1-mp[now]);
            } else {
                mp[now] = i+1;
            }
        }
        return res;
    }
};


```

> 官方题解

```c++
class Solution {
public:
    int findMaxLength(vector<int>& nums) {
        int maxLength = 0;
        unordered_map<int, int> mp;
        int counter = 0;
        mp[counter] = -1;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            int num = nums[i];
            if (num == 1) {
                counter++;
            } else {
                counter--;
            }
            if (mp.count(counter)) {
                int prevIndex = mp[counter];
                maxLength = max(maxLength, i - prevIndex);
            } else {
                mp[counter] = i;
            }
        }
        return maxLength;
    }
};

```



## [523. 连续的子数组和](https://leetcode-cn.com/problems/continuous-subarray-sum/)

> 数学题：
>
> 同余定理：如果A%k == 0, B % k == 0,那么(A - B)% k == 0
>
> 优化题：
>
> 剪枝

```java
class Solution {
    public boolean checkSubarraySum(int[] nums, int k) {
        // 当出现两个连续的0时，直接返回true，因为 0 % k = 0 
        for (int i = 0; i < nums.length - 1; i++) {
            if (nums[i] == 0 && nums[i + 1] == 0) {
                return true;
            }
        }

        // 其中i为左端点，j为右端点，遍历每种情况
        for (int i = 0; i < nums.length; i++) {
            int sum = nums[i];
            for (int j = i + 1; j < nums.length; j++) {
                sum += nums[j];
                if (sum % k == 0) {
                    return true;
                }
            }
            // 加到一起之后发现都没k大，后面的也不会再比k大了，跳过
            if (sum < k) {
                break;
            }
        }
        return false;
    }
}

```



## [342. 4的幂](https://leetcode-cn.com/problems/power-of-four/)

> 位运算
>
> 数学题
>
> 下标从0位开始，偶数位为4的幂，1010 = a
>
> ![image-20210531211812809](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210531211812809.png)

```golang
func isPowerOfFour(n int) bool {
    return n > 0 && n&(n-1) == 0 && n&0xaaaaaaaa == 0
}

```



## [461. 汉明距离](https://leetcode-cn.com/problems/hamming-distance/)

> 内置函数
>
> 位运算

![image-20210527080618332](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210527080618332.png)

> go

```go
func hammingDistance(x, y int) int {
    return bits.OnesCount(uint(x ^ y))
}
```

> c++

```c++
class Solution {
public:
    int hammingDistance(int x, int y) {
        return __builtin_popcount(x ^ y);
    }
};
```

```c++
class Solution {
public:
    int hammingDistance(int x, int y) {
        int s = x ^ y, ret = 0;
        while (s) {
            s &= s - 1; // 消除最低位的1
            ret++;
        }
        return ret;
    }
};

```



## [1190. 反转每对括号间的子串](https://leetcode-cn.com/problems/reverse-substrings-between-each-pair-of-parentheses/)

> 栈进行模拟

![image-20210526080735421](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210526080735421.png)

```c++
class Solution {
public:
    string reverseParentheses(string s) {
        stack<string> stk;
        string str;
        for (auto &ch : s) {
            if (ch == '(') { // 左括号表示进入新一层 需要将之前的str保留 再与下一层作叠加
                stk.push(str);
                str = "";
            } else if (ch == ')') { // 已经到最里层 将最里层的字符串翻转 返回给上一层
                reverse(str.begin(), str.end());
                str = stk.top() + str;
                stk.pop();
            } else {
                str.push_back(ch);
            }
        }
        return str;
    }
};

```



## [664. 奇怪的打印机](https://leetcode-cn.com/problems/strange-printer/)

> C++区间dp
>
> ![image-20210524084531147](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210524084531147.png)

```c++
class Solution {
public:
    int strangePrinter(string s) {
        int n = s.size();
        // vector<vector<int>> dp(n, vector<int>(n, 0x3f3f3f3f));
        int dp[n][n];
        memset(dp, 0x3f3f3f3f, sizeof(dp));

        for(int i = 0; i < n; i++)
            dp[i][i] = 1;
        
        for(int len = 2; len <= n; len++) {
            for(int i = 0, j = len-1; j < n; i++, j++) {
                if(s[i] == s[j])
                    dp[i][j] = min(dp[i+1][j], dp[i][j-1]);
                else {
                    for(int k = i; k < j; k++)
                        dp[i][j] = min(dp[i][j], dp[i][k]+dp[k+1][j]);
                }
            }  
        }
        return dp[0][n-1];
    }
};

```



## [1707. 与数组中元素的最大异或值](https://leetcode-cn.com/problems/maximum-xor-with-an-element-from-array/)

![image-20210523092437245](C:\Users\联想\AppData\Roaming\Typora\typora-user-images\image-20210523092437245.png)

> 超时做法：暴力+剪枝

```c++
class Solution {
public:
    vector<int> maximizeXor(vector<int>& nums, vector<vector<int>>& queries) {
        int n = nums.size();
        int m = queries.size();
        vector<int> ans(m);
        sort(nums.begin(), nums.end(), greater<int>());
        for (int i = 0; i < m; i++) {
            int MAX = 0;
            int x = queries[i][0], y = queries[i][1];
            int pos = lower_bound(nums.begin(),nums.end(), y, greater<int>()) - nums.begin();
            //cout << pos << endl;
            if (pos == n) {
                ans[i] = -1;
                continue;
            }
            for (int j = pos; j < n ; j++) {
                //if (y < nums[i]) break;

                if (nums[j] + x >= MAX) {
                    MAX = max(MAX, nums[j] ^ x);
                } else {
                    //cout << j << endl;
                    break;
                }
            }
            ans[i] = MAX;
        }

        return ans;
    }
};
```



> 字典树



## [810. 黑板异或游戏](https://leetcode-cn.com/problems/chalkboard-xor-game/)

> 数学题
>
> 如果数组长度为偶数，那么怎么拿，Alice都赢
> 但如果长度是奇数呢？奇数就输了吗？不一定，如果数组本来异或结果就为0，那么Alice还是赢

```c++
class Solution {
public:
    bool xorGame(vector<int>& nums) {
        if (nums.size() % 2 == 0) {
            return true;
        }
        int xorsum = 0;
        for (int num : nums) {
            xorsum ^= num;
        }
        return xorsum == 0;
    }
};

```



## [1035. 不相交的线](https://leetcode-cn.com/problems/uncrossed-lines/)

![image-20210521083529102](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210521083529102.png)

> lcs最长公共子序列

```c++
class Solution {
public:
    int maxUncrossedLines(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size(), m = nums2.size();
        vector<vector<int>> dp(n + 1, vector<int>(m + 1));
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= m; ++j) {
                if (nums1[i - 1] == nums2[j - 1]) {
                    dp[i][j] = max(dp[i][j], dp[i - 1][j - 1] + 1);
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[n][m];
    }
};
```



## [692. 前K个高频单词](https://leetcode-cn.com/problems/top-k-frequent-words/)

> map考察自定义比较函数

```c++
class Solution {
public:
    typedef struct node {
        string s;
        int cnt;
    }node;
    static bool cmp(node a, node b) {
        if (a.cnt == b.cnt) {
            return a.s < b.s;
        }
        return a.cnt > b.cnt;
    }
    vector<string> topKFrequent(vector<string>& words, int k) {
        vector<string> ans(k);
        map<string, int> m_si;
        vector<node> vn;
        for (auto word : words) {
            m_si[word]++;
        }
        for (auto x : m_si) {
            vn.push_back({x.first, x.second});
        }

        sort(vn.begin(), vn.end(), cmp);
        for (int i = 0; i < k; i++) {
            ans[i] = vn[i].s;
        }
        return ans;
    }
};
```



## [1738. 找出第 K 大的异或坐标值](https://leetcode-cn.com/problems/find-kth-largest-xor-coordinate-value/)

> 二维前缀和

```c++
class Solution {
public:
    int kthLargestValue(vector<vector<int>>& matrix, int k) {
        int m = matrix.size(), n = matrix[0].size();
        vector<vector<int>> pre(m + 1, vector<int>(n + 1));
        vector<int> results;
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                pre[i][j] = pre[i - 1][j] ^ pre[i][j - 1] ^ pre[i - 1][j - 1] ^ matrix[i - 1][j - 1];
                results.push_back(pre[i][j]);
            }
        }

        sort(results.begin(), results.end(), greater<int>());
        return results[k - 1];
    }
};

```



## [1442. 形成两个异或相等数组的三元组数目](https://leetcode-cn.com/problems/count-triplets-that-can-form-two-arrays-of-equal-xor/)

![image-20210518221543980](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210518221543980.png)

> n ^ 3做法：暴力枚举三个点，前缀和

```c++
class Solution {
public:
    int countTriplets(vector<int>& arr) {
        int n = arr.size();
        vector<int> sum(n, 0);
        sum[0] = arr[0];
        for (int i = 1; i < arr.size(); i++) {
            sum[i] = sum[i - 1] ^ arr[i];
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                for (int k = j; k < n; k++) {
                    int a = sum[i] ^ sum[j - 1] ^ arr[i];
                    int b = sum[k] ^ sum[j] ^ arr[j];
                    if (a == b) {
                        //cout << i << j << k << endl;
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
};
```

> n^2做法：前缀和+问题转换
>
> ![image-20210518222339213](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210518222339213.png)

```c++
class Solution {
public:
    int countTriplets(vector<int>& arr) {
        // 类似前缀和
        int n = arr.size();
        int* pre_ = new int[n + 1]();
        int sum = 0;
        pre_[0] = 0;
        for (int i = 1; i <= n; i++)
        {
            sum ^= arr[i - 1];
            pre_[i] = sum;         
        }
        int count = 0;
        for (int i = 0; i < n; i++)
        {
            for (int j = i + 1; j <= n; j++)
            {
                if (pre_[j] == pre_[i])
                {
                    count += j - i - 1;
                }
            }
        }
        return count;
    }
};
```

![image-20210518222445318](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210518222445318.png)

## 993.二叉树的堂兄弟结点

> BFS。
>
> 如果两个结点在每一层，那么在每一层for循环向队列添加元素的时候，就必然会在同一个for循环中被添加到队列中。

![image-20210517074445863](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210517074445863.png)

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
    using PTT = pair<TreeNode*, TreeNode*>;
    bool isCousins(TreeNode* root, int x, int y) {
        // 使用队列q来进行bfs
        // 其中pair中，p.first 记录当前结点的指针，p.second 记录当前结点的父结点的指针
        queue<PTT> q;
        q.push({root, nullptr});
        while(!q.empty()) {
            int n = q.size();
            vector<TreeNode*> rec_parent; // 存放结点
            for(int i = 0; i < n; i++) {
                auto [cur, parent] = q.front(); q.pop();
                if(cur->val == x || cur->val == y)
                    rec_parent.push_back(parent);
                if(cur->left) q.push({cur->left, cur}); // 存放该当前结点子节点以及当前结点（父节点）
                if(cur->right) q.push({cur->right, cur});
            }
            // `x` 和 `y` 都没出现
            if(rec_parent.size() == 0)
                continue;
            // `x` 和 `y` 只出现一个
            else if(rec_parent.size() == 1)
                return false;
            // `x` 和 `y` 都出现了
            else if(rec_parent.size() == 2)
                // `x` 和 `y` 父节点 相同/不相同 ？
                return rec_parent[0] != rec_parent[1];
        }
        return false;
    }
};

```



## 421.数组中两个数最大异或值

> - Trie树
> - 暴力+剪枝
>     - 如果i + j小于当前已知的ii ^ jj那么 i ^ j的值一定小于 ii ^ jj的值
>     - 因为进位如果还小的话，明显不需要了

```c++
class Solution {
public:
    int findMaximumXOR(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int n = nums.size();
        long long maxValue = 0;
        for (int i = n -1; i >= 1; i--) {
            for (int j = i -1; j >= 0; j--) {
                if ((long long)(nums[i]) + nums[j] < maxValue) {
                    break;
                }
                maxValue = max(maxValue, (long long)(nums[i] ^ nums[j]));
            }
        }
        return maxValue;

    }
};

```



## 13. 罗马数字转整数

> 对于一个罗马数字字符串可以
>
> - 对于每一个字符 str[i]
> - 检查str[i - 1]str[i]组成的字符串是否在map映射中出现，如果出现则优先采用该双字符的，如果没有出现则采用单字符的
> - 因为是从后往前推，所有对于IX中的I会计算两次，即需要将IX9映射为8

![image-20210515091540971](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210515091540971.png)

```c++
class Solution {
public:
    int romanToInt(string s) {
        unordered_map<string, int> m = {{"I", 1}, {"IV", 3}, {"IX", 8}, {"V", 5}, {"X", 10}, {"XL", 30}, {"XC", 80}, {"L", 50}, {"C", 100}, {"CD", 300}, {"CM", 800}, {"D", 500}, {"M", 1000}};
        int r = m[s.substr(0, 1)];
        for(int i=1; i<s.size(); ++i){
            string two = s.substr(i-1, 2);
            string one = s.substr(i, 1);
            r += m[two] ? m[two] : m[one];
        }
        return r;
    }
};
```



## 12. 罗马数字转整数

> 建立映射关系，然后按对应数字从大到小依次处理字符串和减去对应的值。

![image-20210514090043335](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210514090043335.png)

```c++
class Solution {
public:
    string intToRoman(int num) {
        string strs[]= {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
        int nums[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
        string ans;
        for (int i = 0; num > 0 && i < 13; i++) {
            while (nums[i] <= num) {
                ans += strs[i];
                num -= nums[i];
            }
        }
        return ans;
    }
};
```



## 1310.子数组异或查询

> 前缀和

```c++
class Solution {
public:
    vector<int> xorQueries(vector<int>& arr, vector<vector<int>>& queries) {
        int n = arr.size();
        vector<int> sum(n);
        int len = queries.size();
        sum[0] = arr[0];
        for (int i = 1; i < n; i++) {
            sum[i] = sum[i - 1] ^ arr[i];
        }
        vector<int> ans(len);
        int cnt = 0;
        for (auto q : queries) {
            ans[cnt++] = sum[q[0]] ^ sum[q[1]] ^ arr[q[0]];
        }
        return ans;
    }
};
```



## 1734.解码异或后的排列

![image-20210511151045068](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210511151045068.png)

> 数学思维

```c++
class Solution {
public:
    vector<int> decode(vector<int>& encoded) {
        int n = encoded.size() + 1;
        int total = 0;
        for (int i = 1; i <= n; i++) {
            total ^= i;
        }
        int odd = 0;
        // encoded[i] = perm[i] ^ perm[i + 1]
        // 步长为2, perm[0] ^ encoded[i] ^ encode[i + 2] ... = perm[0] ^ encoded[1] ... encoded[n - 1]
        for (int i = 1; i < n - 1; i += 2) {
            odd ^= encoded[i];
        }
        vector<int> perm(n);
        perm[0] = total ^ odd; // 所以perm[0]就可以求出来了
        for (int i = 0; i < n - 1; i++) {
            // 有了perm[0], encoded[i] ^ perm[i] = perm[i + 1]
            perm[i + 1] = perm[i] ^ encoded[i];
        }
        return perm;
    }
};

```



## 叶子相似的树

> 深度前序遍历记录叶子结点

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
    void preSearch(TreeNode* root1, vector<int> &seq) {
        if (root1 == nullptr) return;
        if (!root1 -> left & !root1 -> right) {
            seq.push_back(root1 -> val);
            return ;
        }
        
        preSearch(root1 -> left, seq);
        preSearch(root1 -> right, seq);
    }
    bool leafSimilar(TreeNode* root1, TreeNode* root2) {
        vector<int> seq1, seq2;
        preSearch(root1, seq1);
        preSearch(root2, seq2);
        return seq1 == seq2;
    }
};
```



## 1482. 制作m束花所需的最少天数

> 二分+贪心

![image-20210509083648388](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210509083648388.png)

```c++
class Solution {
public:
    bool check(vector<int>& bloomDay, int m, int k, int limit) {
        int total = 0;
        int cur_cnt = 0;
        // 枚举在limit天 花盛开的情况
        for(auto day : bloomDay) {
            // 花开的天数 如果大于 当前天数limit说明还没有开放 将cur_cnt 重置 断开
            if(day > limit)
                cur_cnt = 0;
            else // 小于且连续 就++
                cur_cnt++;
            // 判断是否满足一束花
            if(cur_cnt >= k) {
                total++;
                cur_cnt = 0;
            }
        }
        return total >= m;
    }
    int minDays(vector<int>& bloomDay, int m, int k) {
        int n = bloomDay.size();
        if(m * k > n) return -1; // 不存在的情况是 花数 < 需要的花束
        // 优化 枚举范围在 min - max ele
        int left = *min_element(bloomDay.begin(), bloomDay.end());
        int right = *max_element(bloomDay.begin(), bloomDay.end());
        // 二分枚举天数 能缩小就缩小 不能缩小就扩大
        while(left <= right) {
            int mid = (left + right) / 2;
            if(check(bloomDay, m, k, mid))
                right = mid-1; // 缩小区间
            else
                left = mid+1; // 扩大区间
        }
        return right + 1;
    }
};

```



## 1723. 完成所有工作的最短时间

> 二分、回溯、剪枝

```c++
class Solution {
public:
    bool backtrack(vector<int>& jobs, vector<int>& workloads, int idx, int limit) {
        if (idx >= jobs.size()) {
            return true;
        }
        int cur = jobs[idx];
        for (auto& workload : workloads) {
            if (workload + cur <= limit) {
                workload += cur; // 选择当前的进行分配
                if (backtrack(jobs, workloads, idx + 1, limit)) {
                    return true;
                }
                workload -= cur; // 不选择当前的进行分配
            }
            // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
            // 或者当前工作恰能使该工人的工作量达到了上限
            // 这两种情况下我们无需尝试继续分配工作
            if (workload == 0 || workload + cur == limit) { // 因为是整个for循环 每个都要尝试 这里剪枝
                break;
            }
        }
        return false;
    }

    bool check(vector<int>& jobs, int k, int limit) {
        vector<int> workloads(k, 0);
        return backtrack(jobs, workloads, 0, limit);
    }

    int minimumTimeRequired(vector<int>& jobs, int k) {
        sort(jobs.begin(), jobs.end(), greater<int>()); // 从大到小排列
        int l = jobs[0], r = accumulate(jobs.begin(), jobs.end(), 0); // limit -> [min, max]工作量
        while (l < r) { // 二分枚举limit
            int mid = (l + r) >> 1;
            if (check(jobs, k, mid)) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }
};

```



## 1486.  数组异或操作

> 简答模拟

![image-20210507085330656](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210507085330656.png)

```c++
class Solution {
public:
    int xorOperation(int n, int start) {
        int num = start;
        for (int i = 1; i < n; i++) {
            num ^= (start + 2 * i);
        }
        return num;
    }
};
```



## 1720. 解码异或后的数组

> 简单数论

![image-20210506195533573](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210506195533573.png)

```c++
class Solution {
public:
    vector<int> decode(vector<int>& encoded, int first) {
        int n = encoded.size();
        vector<int> ans(n + 1, first);
        for (int i = 0; i < n; i++) {
            ans[i + 1] = ans[i] ^ encoded[i];
        }
        return ans;
    }
};
```



## 740. 删除并获得点数

![image-20210505100653314](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210505100653314.png)

> 动态规划

```c++
class Solution {
public:
    int deleteAndEarn(vector<int>& nums) {
        if(nums.size() < 1) return 0;
        int maxn = 0;
        for(int it : nums)
            maxn = max(maxn, it);
        vector<int> cnt(maxn+1), dp(maxn+1);
        for(int it : nums)
            cnt[it]++;
        dp[1] = cnt[1];
        for(int i = 2; i <= maxn; i++)
            dp[i] = max(dp[i-1], dp[i-2] + cnt[i] * i);
        return dp[maxn];
    }
};
```



## 554. 砖墙

> 贪心 思维题
>
> 对于每一条垂线，穿过的砖块和穿过的间隙相加结果都是总高度 是个定值
>
> 所以只需要找出最多的间隙那个 就找到了高度减最多的间隙就找到了穿过的最少砖数。





![image-20210502082716828](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210502082716828.png)

```c++
class Solution {
public:
    int leastBricks(vector<vector<int>>& wall) {
        unordered_map<int, int> cnt;
        for (auto& widths : wall) {
            int n = widths.size();
            int sum = 0;
            for (int i = 0; i < n - 1; i++) {
                sum += widths[i];
                cnt[sum]++;
            }
        }
        int maxCnt = 0;
        for (auto& [_, c] : cnt) {
            maxCnt = max(maxCnt, c);
        }
        return wall.size() - maxCnt;
    }
};

```



## 690. 员工的重要性

![image-20210502083118041](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210502083118041.png)

> bfs

```c++
/*
// Definition for Employee.
class Employee {
public:
    int id;
    int importance;
    vector<int> subordinates;
};
*/

class Solution {
public:
    int getImportance(vector<Employee*> employees, int id) {
        int ans = 0;
        //if (employees.size() == 0) return 0;
        unordered_set<int> emp_record;
        unordered_map<int, int> m;

        for (int i = 0; i < employees.size(); i++) {
            m[employees[i] -> id] = i;
        }

        queue<Employee> que_emp;
        que_emp.push(*employees[m[id]]);

        while (que_emp.size()) {
            Employee temp = que_emp.front();
            que_emp.pop();
            ans += temp.importance;
            for (auto num : temp.subordinates) {
                if (emp_record.count(num) == 0) {
                    emp_record.insert(num);
                    que_emp.push(*employees[m[num]]);
                }
            }
            
        }
        return ans;
    }
};
```



## 403. 青蛙过河

> 解法1：
>
> DFS + 记忆化（记忆化搜索）

![image-20210502083209208](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210502083209208.png)

```c++
class Solution {
public:
    using PII = pair<int, int>;
    unordered_map<int, unordered_set<int>> visited;
    unordered_set<int> stone_pos;
    int done;
    bool dfs(int prv_pos, int speed) {
        int cur_pos = prv_pos + speed;

        if(speed < 0 || !stone_pos.count(cur_pos)) // 不能向后跳 并且当前位置有石头存在 
            return false;
        if(visited[prv_pos].count(speed)) // 防止重复计算 以同一个速度到达同一个位置 代表是同一个状态
            return false;
        visited[prv_pos].insert(speed);//将当前新状态插入到数组中

        if(cur_pos == done) // 达到最后一个
            return true;
        
        // 进行递归搜索
        return dfs(cur_pos, speed-1) || 
            dfs(cur_pos, speed) || dfs(cur_pos, speed+1);   
    }
    bool canCross(vector<int>& stones) {
        int n = stones.size();
        // 保存石头位置
        stone_pos = unordered_set<int>(stones.begin(), stones.end());
        // 目标为最后一个位置
        done = stones.back();
		// 从0开始向跳一个
        return dfs(0, 1);
    }
};

```

> 动态规划
>
> - `d[i][speed]`表示以speed能否跳到第i个石头
> - 初始化：`d[0][0] = 1`
> - `dp[i][speed] = dp[j][speed - 1] or dp[j][spped] or dp[j][speed + 1]`

```c++
class Solution {
public:
    bool canCross(vector<int>& stones) {
        int n = stones.size();
        // dp[i][speed]：表示能否以speed的速度，到达第i个石头
        vector<vector<int>> dp(n, vector<int>(n, 0));
        dp[0][0] = 1;
        for(int i = 1; i < n; i++) {
            for(int j = 0; j < i; j++) {
                int speed = stones[i] - stones[j]; // 需要speed的距离才能从j到i
                if(speed <= 0 || speed > j+1) // 从j开始跳的距离最大为 j + 1, 距离超过 j + 1，说明不能一次跳跃到达
                    continue;
                    
                dp[i][speed] = dp[j][speed-1] || 
                    dp[j][speed] || dp[j][speed+1];
            }
        }
        for (int i = 0; i < n; i++) {
            if (dp[n - 1][i]) return true;
        }
        return false;
    }
};
```



## 633. 平方数之和

> 暴力

```c++
class Solution {
public:
    bool judgeSquareSum(int c) {
        for (long a = 0; a * a <= c; a++) {
            double b = sqrt(c - a * a);
            if (b == (int)b) {
                return true;
            }
        }
        return false;
    }
};

```

> Go版本

```go
func judgeSquareSum(c int) bool {
    for a := 0; a*a <= c; a++ {
        rt := math.Sqrt(float64(c - a*a))
        if rt == math.Floor(rt) {
            return true
        }
    }
    return false
}
```

> 双指针
>
> - left = 0, right = sqrt(c)
> - if (乘积大于目标 ) right --
> - if (成绩小于) left++
>
> - 终结条件(left > right), right == left 可能是8 = 2^2 + 2^2

```go
func judgeSquareSum(c int) bool {
    left, right := 0, int(math.Sqrt(float64(c)))
    for left <= right {
        sum := left*left + right*right
        if sum == c {
            return true
        } else if sum > c {
            right--
        } else {
            left++
        }
    }
    return false
}

```

## 938.二叉搜索树的范围和

> 中序遍历

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
    void midSearch(TreeNode *root, vector<TreeNode *> &v) {
        if (!root)  return ;
        midSearch(root -> left, v);
        v.push_back(root);
        midSearch(root -> right, v);
    }
    int rangeSumBST(TreeNode* root, int low, int high) {
        vector<TreeNode *> v;
        int ans = 0;
        midSearch(root, v);
        int i = 0;
        for (i = 0; i < v.size(); i++) {
            if (v[i] -> val >= low) break;
        }
        for (int j = i; j < v.size(); j++) {
            if (v[j]->val <= high) ans += v[j]->val;
            else break;
        }
        return ans;
    }
};
```

> 官方题解

```c++
class Solution {
public:
    int rangeSumBST(TreeNode *root, int low, int high) {
        if (root == nullptr) {
            return 0;
        }
        // 当前值不在 [low, high]范围内
        if (root->val > high) { 
            return rangeSumBST(root->left, low, high);
        }
        if (root->val < low) {
            return rangeSumBST(root->right, low, high);
        }
        // 当前值 + 左孩子的值 + 右孩子的值
        return root->val + rangeSumBST(root->left, low, high) + rangeSumBST(root->right, low, high);
    }
};

```



## 1011. 在D天内送达包裹的能力

> 二分查找
>
> 二分枚举船的limit 然后检查该limit是否满足

```c++
class Solution {
public:
    bool check(vector<int> &weights, int D, int limit) {
        int cnt = 1, cur = 0;
        for(auto &weight : weights) {
            if(limit < weight) return false;
            if(cur + weight > limit) {
                cnt++;
                cur = 0;
            }
            cur += weight;
        }
        return cnt <= D; // <= D说明可以在D天之内运输完毕
    }
    int shipWithinDays(vector<int>& weights, int D) {
        int left = 1, right = 500*50000; // limit [1, 500 * 50000]
        int ans = right; // ans保存limit
        while(left <= right) {
            int mid = (left + right) / 2;
            if(check(weights, D, mid)) { // 可以满足 试图减少limit 因为要求最小值
                right = mid - 1;
                ans = mid;
            }
            else // 不能满足 增加limit
                left = mid + 1;
        }
        return ans;
    }
};


```



## 897. 递增搜索树

> 中序遍历存树的结点指针 然后重建树

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
    void midSearch(TreeNode *root, vector<TreeNode *> &nodes) {
        if (root == nullptr) return;
        midSearch(root -> left, nodes);
        nodes.push_back(root);
        midSearch(root -> right, nodes);
    }
    TreeNode* increasingBST(TreeNode* root) {
        vector<TreeNode *> nodes;
        if (root == nullptr) return nullptr;
        midSearch(root, nodes);
        nodes.push_back(nullptr);
        TreeNode *ans = nodes[0], *temp = nodes[0];
        for (int i = 0; i < nodes.size() - 1; i++) {
            nodes[i] -> left = nullptr;
            nodes[i] -> right = nodes[i + 1];
            
        }
        return ans;
    }
};
```



## 377.组合总数IV

> DP
>
> `dp[i][j]`表示长度为i的 构成总和为j的方案数
>
> `dp[0][0] = 1`
>
> 
>
> 

![image-20210424135158154](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210424135158154.png)

```c++
using ULL =  unsigned long long;
class Solution {
public:
    int combinationSum4(vector<int>& nums, int target) {
        int len = target;
        vector<vector<ULL>> f(len + 1,vector<ULL>(target + 1,0));
        f[0][0] = 1; // 数组长度为i 构成长度为j
        int ans = 0;
        for(int i = 1; i <= len; i++){
            for(int j = 0; j <= target; j++){
                for(auto x : nums){
                    if(j >= x) f[i][j] += f[i - 1][j - x];
                    // 从 i - 1状态转移过来 可能是数组任意一个数转移过来 
                }
            }
            // 将每一个长度 1 - target(全1) 的长度的方案书相加
            ans += f[i][target];
        }
        return ans;
    }
};
```

```c++
class Solution {
public:
    int combinationSum4(vector<int>& nums, int target) {
        vector<int> f(target + 1,0); // or vector<unsigned long long> f(target + 1,0); 就不用做取模的操作了
        f[0] = 1;
        for(int i = 1; i <= target; i++){
            for(auto x : nums){
                //c++计算的中间结果会溢出，但因为最终结果是int
                //因此每次计算完都对INT_MAX取模，0LL是将计算结果提升到long long类型
                if(i >= x) f[i] =(0LL + f[i] + f[i - x]) % INT_MAX;
            }
        }
        return f[target];
    }
};
```



## 368. 最大整除子集

> DP
>
> dp[i] 表示以nums[i]为末尾元素的整除子集的个数
>
> 初始状态：dp[i] = 1
>
> 第一遍找到每个以nums[i]结尾的整除子集大小。并记录最大值和最大子集长度dp[i] =max(dp[i], dp[j] + 1);
>
> 第二步：从后往前遍历先找到满足最大值和最大子集长度的元素，然后每选一个元素就减去一个最大子集长度，如maxSize = 5，一直递减直到1为止。判断元素是否符合的条件就是当前dp[i] == maxSize, 且maxVlaue % nums[i] == 0

```c++
class Solution {
public:
    vector<int> largestDivisibleSubset(vector<int>& nums) {
        int len = nums.size();
        sort(nums.begin(), nums.end());

        // 第 1 步：动态规划找出最大子集的个数、最大子集中的最大整数
        vector<int> dp(len, 1);
        int maxSize = 1;
        int maxVal = dp[0];
        for (int i = 1; i < len; i++) {
            for (int j = 0; j < i; j++) {
                // 题目中说「没有重复元素」很重要
                if (nums[i] % nums[j] == 0) {
                    dp[i] = max(dp[i], dp[j] + 1);
                }
            }

            if (dp[i] > maxSize) {
                maxSize = dp[i];
                maxVal = nums[i];
            }
        }

        // 第 2 步：倒推获得最大子集
        vector<int> res;
        if (maxSize == 1) {
            res.push_back(nums[0]);
            return res;
        }

        
        for (int i = len - 1; i >= 0 && maxSize > 0; i--) {
            if (dp[i] == maxSize && maxVal % nums[i] == 0) {
                res.push_back(nums[i]);
                maxVal = nums[i];
                maxSize--;
            }
        }
        return res;
    }
};

```



## 27. 移除元素

> 原地删除无序数组的特定项

![image-20210419084355052](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210419084355052.png)

```c++
class Solution {
public:
    int removeElement(vector<int>& nums, int val) {
        int cur = 0;
        for (auto num : nums ){
            if (val != num) {
                nums[cur++] = num;
            }
        }
        return cur;
    }
};
```



## 26. 删除有序数组的重复项

> 原地删除有序数组的重复项

```c++
class Solution {
    public int removeDuplicates(int[] nums) {
    if (nums.length == 0) return 0;
    int i = 0;
    for (int j = 1; j < nums.length; j++) {
        if (nums[j] != nums[i]) {
            i++;
            nums[i] = nums[j];
        }
    }
    return i + 1;
    }

}
```



## 220. 存在重复元素

> 滑动窗口 + set维护窗口内的状态

![image-20210417094515733](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210417094515733.png)

```c++
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        set<long> s;
        for (int i = 0; i < nums.size(); ++i) {
            // 指针定位比 long(nums[i])-t 大的数的位置
            auto pos = s.lower_bound(long(nums[i]) - t);
            // 如果存在且该数字也比 long(nums[i]) + t 小，说明存在我们想要的结果
            if (pos!=s.end() && *pos <= long(nums[i]) + t) return true;
            s.insert(nums[i]);
            if (s.size() > k) s.erase(nums[i-k]); // 维护滑动窗口
        }
        return false;
    }
};
```



## 213. 打家劫舍

> 参考198 做两次打家劫舍 分为：
>
> 1. 打劫第一家
> 2. 不打劫第一家

![image-20210417094551127](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210417094551127.png)

```c++
class Solution {
public:
    int rob0(vector<int>& nums, int st, int end) {
        int n = nums.size();
        if (n == 0) return 0;
        //vector<int> dp(n + 1, 0); // dp[i]表示偷前i个房子的最大金额
        //dp[1] = nums[0];
        int cur = nums[st], pre = 0;
        for (int i = st + 2; i <= end; i++) {
            int temp = cur;
            cur = max(cur, pre + nums[i - 1]);
            pre = temp;
            //dp[i] = max(dp[i - 1], dp[i - 2] + nums[i - 1]);
        }
        return cur;
    }
    int rob(vector<int>& nums) {
        int n = nums.size();
        if (n == 1) return nums[0];
        //return rob0(nums, 0, n);
        return max(rob0(nums, 0, n - 1), rob0(nums, 1, n));
    }
};
```



## 208.Trie树

```c++
class Trie {
private:
    bool isEnd;
    Trie* next[26]; // 每一个结点都可能有26个字母的分支
public:
    Trie() {
        isEnd = false;
        memset(next, 0, sizeof(next));
    }
    
    void insert(string word) {
        Trie* node = this;
        // 存在就一直找到底 不存在就创建新的结点
        for (char c : word) {
            if (node->next[c-'a'] == NULL) {
                node->next[c-'a'] = new Trie();
            }
            node = node->next[c-'a'];
        }
        node->isEnd = true; // 标记为存在
    }
    
    bool search(string word) {
        Trie* node = this;
        for (char c : word) {
            node = node->next[c - 'a'];
            if (node == NULL) { // 当前字字母还没有被建立过 肯定不存在
                return false;
            }
        }
        // 在Trie树中找到了对应的字符串 并且已经移动了该字符串的最后一个位置
        return node->isEnd;
    }
    
    // 只要树中能找到对应的prefix的字符串就可 不管是否结尾
    bool startsWith(string prefix) {
        Trie* node = this;
        for (char c : prefix) {
            node = node->next[c-'a'];
            if (node == NULL) {
                return false;
            }
        }
        return true;
    }
};

```



## 783.二叉树节点的最小距离

![image-20210413190558084](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210413190558084.png)

> 二叉树中序遍历得到有序数组 最小的距离为相邻的两个值的差值最小

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
    vector<int> nums;
    void dfs(TreeNode*root) {
        if (root == nullptr) return ;
        dfs(root -> left);
        nums.push_back(root -> val);
        dfs(root -> right);
    }
    int minDiffInBST(TreeNode* root) {
        dfs(root);
        int len = nums.size();
        int ans = INT_MAX;
        for (int i = 1; i < len; i++) {
            ans = min(ans, nums[i] - nums[i - 1]);
        }
        return ans;
    }
};
```



## 264. 丑数II

> 小顶堆: 堆顶为x , 下一个点就是 2x, 3x, 5x

![image-20210411084001360](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411084001360.png)

```C++
class Solution {
public:
    int nthUglyNumber(int n) {
        vector<int> factors = {2, 3, 5};
        unordered_set<long> seen;
        priority_queue<long, vector<long>, greater<long>> heap;
        seen.insert(1L);
        heap.push(1L);
        int ugly = 0;
        for (int i = 0; i < n; i++) {
            long curr = heap.top();
            heap.pop();
            ugly = (int)curr;
            for (int factor : factors) {
                long next = curr * factor;
                if (!seen.count(next)) {
                    seen.insert(next);
                    heap.push(next);
                }
            }
        }
        return ugly;
    }
};

```



## 263. 丑数

![image-20210410142416824](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210410142416824.png)

```c++
class Solution {
public:
    bool isUgly(int n) {
        if (n <= 0) {
            return false;
        }
        vector<int> factors = {2, 3, 5};
        for (int factor : factors) {
            while (n % factor == 0) {
                n /= factor;
            }
        }
        return n == 1;
    }
};
```



## 33. 搜索旋转排序数组

> 二分搜索

```c++
class Solution {
public:
    int search(vector<int>& nums, int target) {
        int lo = 0, hi = nums.size() - 1;
        while (lo < hi) {
            int mid = (lo + hi) / 2;
            if ((nums[0] > target) ^ (nums[0] > nums[mid]) ^ (target > nums[mid]))
                lo = mid + 1;
            else
                hi = mid;
        }
        return lo == hi && nums[lo] == target ? lo : -1;
    }
};

```

> 二分模板

```c++
class Solution {
public:
    int search(vector<int>& nums, int target) {
        int lo = 0, hi = nums.size() - 1;
        while (lo < hi) {
            int mid = (lo + hi) / 2;
            if (check[nums[mid]])
                lo = mid + 1; // target -> [mid + 1, r]
            else
                hi = mid;// target -> [lo, mid]
        }
        return l;//最后是l == r
    }
};
```



## 80. 删除有序数组中的重复项II

> 双指针（快慢指针），cur表示当前遍历到的指针，fill表示需要填的指针，最后数组的长度就是填入了多少个数。

![image-20210406083010537](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210406083010537.png)

```c++
class Solution {
public:
    int removeDuplicates(vector<int>& nums) {
        int n = nums.size();
        int cnt = 1;
        int fill = 1;
        // 这里直接从1开始避免后面条件判断
        for (int cur = 1; cur < n; ++cur) {
            if (nums[cur] != nums[cur-1])  
                cnt = 1;
            else 
                ++cnt;
            
            if (cnt <= 2){
                nums[fill] = nums[cur];
                ++fill;
            }
        }
        return fill;
    }
};

```



## 88.合并两个有序数组

> 2021-04-05

![image-20210405081919970](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405081919970.png)

```c++
class Solution {
public:
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
         int idx = m + n - 1;
         int i = m - 1, j = n - 1;
        while (i >= 0 || j >= 0) {
            if (i >= 0 && j >= 0) {
                if (nums1[i] > nums2[j]) {
                    nums1[idx--] = nums1[i];
                    i--;
                } else {
                    nums1[idx--] = nums2[j];
                    j--;
                }
            } else {
                if (i == -1) {
                    nums1[idx--] = nums2[j];
                    j--;
                }else {
                    nums1[idx--] = nums1[i];
                    i--;
                }
            }
            
        }
    }
};
```

![image-20210405081948299](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405081948299.png)

## 781. 森林里面的兔子

> 2021-04-04

![image-20210404085712859](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210404085712859.png)

```c++
class Solution {
public:
    int numRabbits(vector<int> &answers) {
        unordered_map<int, int> count;
        for (int y : answers) {
            ++count[y];
        }
        int ans = 0;
        for (auto &[y, x] : count) {
            ans += (x + y) / (y + 1) * (y + 1);
        }
        return ans;
    }
};

```

两只相同颜色的兔子看到的其他同色兔子数必然是相同的。反之，若两只兔子看到的其他同色兔子数不同，那么这两只兔子颜色也不同。

因此，将 \textit{answers}answers 中值相同的元素分为一组，对于每一组，计算出兔子的最少数量，然后将所有组的计算结果累加，就是最终的答案。

例如，现在有 13 只兔子回答 5。假设其中有一只红色的兔子，那么森林中必然有 6 只红兔子。再假设其中还有一只蓝色的兔子，同样的道理森林中必然有 66 只蓝兔子。为了最小化可能的兔子数量，我们假设这 12 只兔子都在这 13 只兔子中。那么还有一只额外的兔子回答 5，这只兔子只能是其他的颜色，这一颜色的兔子也有 6 只。因此这种情况下最少会有 18 只兔子。

一般地，如果有 x 只兔子都回答y，则至少有 ==x / (y + 1)== 种不同的颜色，且每种颜色有 ==y+1== 只兔子，因此兔子数至少为

![image-20210404090415325](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210404090415325.png)

我们可以用哈希表统计 answers 中各个元素的出现次数，对每个元素套用上述公式计算，并将计算结果累加，即为最终答案。

> 向上取整： (x + y) / (y + 1)

***

## 1143.最长上升公共子序列

> 2021-04-05
>
> https://leetcode-cn.com/problems/longest-common-subsequence/

![image-20210405082645234](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405082645234.png)

```c++
class Solution {
public:
    int longestCommonSubsequence(string text1, string text2) {
        const int M = text1.size();
        const int N = text2.size();
        vector<vector<int>> dp(M + 1, vector<int>(N + 1, 0));
        for (int i = 1; i <= M; ++i) {
            for (int j = 1; j <= N; ++j) {
                if (text1[i - 1] == text2[j - 1]) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[M][N];
    }
};
```

***

![image-20210405083518341](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405083518341.png)

```c++
class Solution {
public:
    int longestCommonSubsequence(string s1, string s2) {
    	int n = s1.size(), m = s2.size();
    	s1 = " " + s1, s2 = " " + s2;
    	int f[n+1][m+1];
    	memset(f, 0, sizeof(f));

    	for(int i = 0; i <= n; i++) f[i][0] = 1;
    	for(int j = 0; j <= m; j++) f[0][j] = 1;

    	for(int i = 1; i <= n; i++) {
    		for(int j = 1; j <= m; j++) {
    			if(s1[i] == s2[j])
    				f[i][j] = f[i-1][j-1] + 1;
    			else
    				f[i][j] = max(f[i-1][j], f[i][j-1]);
    		}
    	}

    	return f[n][m] - 1;
    }
};

```

## 面试题17.21 直方图的水量

![image-20210405154710081](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405154710081.png)

> 算法思想：总体积减去柱子的体积就是雨水的体积

```c++
class Solution {
public:
    int trap(vector<int>& height) {
        int Sum = accumulate(height.begin(), height.end(), 0); // 得到柱子的体积
        int volume = 0; // 总体积和高度初始化
        int high = 1;
        int size = height.size();
        int left = 0; // 双指针初始化
        int right = size - 1;
        while (left <= right) {
            // 在左边找到第一个高度 >= height的
            while (left <= right && height[left] < high) {
                left++;
            }
            // 在右边找到第一个高度 >= height的
            while (left <= right && height[right] < high) {
                right--;
            }
            // 二者差值+ 1就是这一层的体积
            volume += right - left + 1; // 每一层的容量都加起来
            high++; // 高度加一
        }
        return volume - Sum; // 总体积减去柱子体积，即雨水总量
    }
};
```



## 74.搜索二维矩阵

> 二分搜索。



![image-20210405190726509](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210405190726509.png)

```c++
class Solution {
public:
    bool searchMatrix(vector<vector<int>> matrix, int target) {
        auto row = upper_bound(matrix.begin(), matrix.end(), target, [](const int b, const vector<int> &a) {
            return b < a[0];
        });
        if (row == matrix.begin()) {
            return false;
        }
        --row;
        return binary_search(row->begin(), row->end(), target);
    }
};

```

==lower_bound( begin,end,num)==：从数组的begin位置到end-1位置二分查找第一个大于或等于num的数字，找到返回该数字的地址，不存在则返回end。通过返回的地址减去起始地址begin,得到找到数字在数组中的下标。

==upper_bound( begin,end,num)==：从数组的begin位置到end-1位置二分查找第一个大于num的数字，找到返回该数字的地址，不存在则返回end。通过返回的地址减去起始地址begin,得到找到数字在数组中的下标。

在从大到小的排序数组中，重载lower_bound()和upper_bound()

==lower_bound( begin,end,num,greater<type>() )==:从数组的begin位置到end-1位置二分查找第一个小于或等于num的数字，找到返回该数字的地址，不存在则返回end。通过返回的地址减去起始地址begin,得到找到数字在数组中的下标。

==upper_bound( begin,end,num,greater<type>() )==:从数组的begin位置到end-1位置二分查找第一个小于num的数字，找到返回该数字的地址，不存在则返回end。通过返回的地址减去起始地址begin,得到找到数字在数组中的下标。

```c++
#include<bits/stdc++.h>
using namespace std;
int main() {
  int a[] = {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4};
 
  cout << (lower_bound(a, a + 12, 4) - a) << endl; //输出 9
  cout << (upper_bound(a, a + 12, 4) - a) << endl; //输出 12
  cout << (lower_bound(a, a + 12, 1) - a) << endl; //输出 0
  cout << (upper_bound(a, a + 12, 1) - a) << endl; //输出 3
  cout << (lower_bound(a, a + 12, 3) - a) << endl; //输出 6
  cout << (upper_bound(a, a + 12, 3) - a) << endl; //输出 9
  cout << (lower_bound(a, a + 12, 5) - a) << endl; //输出 12
  cout << (upper_bound(a, a + 12, 5) - a) << endl; //输出 12
  cout << (lower_bound(a, a + 12, 0) - a) << endl; //输出 0
  cout << (upper_bound(a, a + 12, 0) - a) << endl; //输出 0
 
  return 0;
}
```

> 转变为一维二分

```c++
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int m = matrix.size(), n = matrix[0].size();
        int low = 0, high = m * n - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            int x = matrix[mid / n][mid % n];
            if (x < target) {
                low = mid + 1;
            } else if (x > target) {
                high = mid - 1;
            } else {
                return true;
            }
        }
        return false;
    }
};


```

## 1006. 笨阶乘

> 2021-04-01

![image-20210406185129755](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210406185129755.png)

```c++
class Solution {
public:
    int clumsy(int N) {
        stack<int> stk;
        stk.push(N);
        N--;

        int index = 0; // 用于控制乘、除、加、减
        while (N > 0) {
            if (index % 4 == 0) {
                stk.top() *= N;
            } else if (index % 4 == 1) {
                stk.top() /= N;
            } else if (index % 4 == 2) {
                stk.push(N);
            } else {
                stk.push(-N);
            }
            index++;
            N--;
        }

        // 把栈中所有的数字依次弹出求和
        int sum = 0;
        while (!stk.empty()) {
            sum += stk.top();
            stk.pop();
        }
        return sum;
    }
};
```

```c++
// 还有这种用法
stk.top() *= N; 
// 小技巧 面对要减去的数可以变为+(-N)
stk.push(-N);
// 相同的还有 堆默认大顶堆 如果要构建小顶堆 就把-element插入push进堆之中
```



# Acwing每日一题

## 3725. 卖罐头 : 数学(2021/10/26)

![image-20211026202634969](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211026202634969.png)

> 区间最大长度为`l`即`[l, l*2 - 1]`
>
> ![image-20211026202929798](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211026202929798.png)

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

int main()
{
    int T;
    cin >> T;
    while (T--) {
        int l, r;
        cin >> l >> r;
        if (r >= 2 * l) cout << "NO" << endl;
        else cout << "YES" << endl;
    }
    return 0;
}
```



## 3705. 子集mex值 : 数学(2021/10/26)

![image-20211026201147089](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211026201147089.png)

> 统计从0到100的数字个数

```c++
#include <bits/stdc++.h>

using namespace std;

int main() {
    int T;
    cin >> T;
    while (T --) {
            int n;
            cin >> n;
            unordered_map<int, int> m;

            for (int i = 0; i < n; i++) {
                    int tmp;
                    cin >> tmp;
                    m[tmp]++;
            }
            int mexa, mexb;
            for (int i = 0; i < 101; i++) {
                    if (m.find(i) != m.end()) {
                            m[i]--;
                            continue;
                    } else {
                            mexa = i;
                            break;
                    }
            }

            for (int i = 0; i < 101; i++) {
                    if (m.find(i) != m.end() && m[i] != 0) {
                            m[i]--;
                            continue;
                    } else {
                            mexb = i;
                            break;
                    }
            }
            cout << mexa + mexb << endl;
    }
    return 0;
}
```

## 3732. 矩阵复原 ：构造思维题(2021/10/25)

![image-20211025203112044](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211025203112044.png)

> 根据列首tar值确定他在某行中的列位置 然后填充该列。

```c++
#include <bits/stdc++.h>
const int N = 505;

int a[N][N], b[N][N], c[N][N];

using namespace std;

int main()
{
    int T;
    cin >> T;
    while (T --) {
        int n , m;
        cin >> n >> m;
        unordered_map<int, int > idx;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                cin >> a[i][j];
                idx[a[i][j]] = j;
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                cin >> b[i][j];
            }
        }
        
        for (int i = 0; i < m; i++) {
            int tar = b[i][0];
            int col = idx[tar];
            for (int j = 0; j < n; j++) {
                c[j][col] = b[i][j];
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j ++ ) {
                cout << c[i][j] << (j == m-1?"":" ");
            }
            cout << endl;
        }
    }
    return 0;
}
```



## 3731. 序列凑零 ： 思维题(2021/10/25)

![image-20211025201028084](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211025201028084.png)

> 两两一组 在同一组中和为0

```c++
#include <bits/stdc++.h>

using namespace std;
int a[105];
int b[105];

int main()
{
    int T;
    cin >> T;
    while (T -- ) {
        int n;
        cin >> n;
        for (int i = 0; i < n; i ++ ) {
            cin >> a[i];
            if (i % 2 == 1) {
                b[i - 1] = -a[i];
                b[i] = a[i - 1];
            }
        }
        for (int i = 0; i < n; i ++ ) {
            cout << b[i] << (i==n-1?"":" ");
        }
        cout << endl;
    }
    return 0;
}
```



## 3730. 寻找序列(2021/10/25)

![image-20211025195656310](https://gitee.com/DengSchoo374/img/raw/master/img/image-20211025195656310.png)

> 构造：对于i保证与i-1不同即可 最后兜底检查n - 1与0是否也满足

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 110;

int n;
int a[4][N];

int main()
{
    int T;
    cin >> T;
    while (T -- )
    {
        cin >> n;
        for (int i = 0; i < 3; i ++ )
            for (int j = 0; j < n; j ++ )
                cin >> a[i][j];
        a[3][0] = a[0][0];
        for (int i = 1; i < n - 1; i ++ )
            for (int j = 0; j < 3; j ++ )
                if (a[3][i - 1] != a[j][i])
                {
                    a[3][i] = a[j][i];
                    break;
                }

        for (int i = 0; i < 3; i ++ )
            if (a[i][n - 1] != a[3][0] && a[i][n - 1] != a[3][n - 2])
            {
                a[3][n - 1] = a[i][n - 1];
                break;
            }
        for (int i = 0; i < n; i ++ ) cout << a[3][i] << ' ';
        cout << endl;
    }

    return 0;
}

```



## 3824.在校时间

![image-20210907184830385](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210907184830385.png)

> 简单模拟

```c++
#include <bits/stdc++.h>


using namespace std;

int a[110];



int main() {
    int T;
    int n;
    cin >> T;
    while(T--) {
       cin >> n;
       for (int i = 0; i < n; i++) {
           cin >> a[i];
       }
       
       int cur = 0, ans = 0;
       int flag = 0;
       while (cur < n) {
           if (a[cur] == 1) {
               ans ++, cur ++;
               flag = 1;
           } else if (flag && cur + 1 < n && a[cur + 1] != 0) { //如果不是00说明在校 0 1
               ans ++, cur ++;
           } else { // 00情况
               while (cur < n && a[cur] == 0) { // 00
                   cur++;
               }
           }
       }
       cout << ans << endl;
    }
}
```



## 3781.乘车问题

![image-20210726193409245](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210726193409245.png)

```c++
#include <bits/stdc++.h>
using namespace std;

int a[35];

int main () {
    int T;
    cin >>T;
    while (T--) {
        int n, m;
        cin >> n >> m;
        int ans  = 0;
        for (int i = 0; i <n; i++) {
            cin >> a[i];
        }
        for(int i = 0; i < n; i++) {
            ans++;
            int sum = a[i];
            while ((i + 1) < n && a[i + 1] + sum <= m) {
                sum += a[i + 1];
                i++;
                
            }
            //cout << sum << endl;
        }
        cout << ans << endl;
    }
    return 0;
}
```



## 3729. 改变数组元素

![image-20210625194312729](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210625194312729.png)

> 区间差分：这个不题目不能直接用，需要维护该区间的次数。
>
> 算法原理：维护数据`b[1 - n]`, 每次操作即将`b[l - r]`区间做+k操作：
>
> `b[l]++,b[r + 1]-- `。
>
> 再使用前缀和便可以得到目标数组

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 200010;

int n;
int b[N];

int main()
{
    int T;
    scanf("%d", &T);
    while (T -- )
    {
        scanf("%d", &n);
        memset(b, 0, (n + 1) * 4);
        for (int i = 1; i <= n; i ++ )
        {
            int a;
            scanf("%d", &a);
            int l = max(1, i - a + 1), r = i;
            b[l] ++, b[r + 1] -- ;
        }
        for (int i = 1; i <= n; i ++ )
        {
            b[i] += b[i - 1];
            printf("%d ", !!b[i]);
        }
        puts("");
    }
    return 0;
}

```





## AcWing 3720. 数组重排

![image-20210623191545445](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210623191545445.png)

```
4
3 4
1 2 3
1 1 2

2 6
1 4
2 5

4 4
1 2 3 4
1 2 3 4

1 5
5
5
```

```
Yes
Yes
No
No
```

```c++
#include <iostream>
#include <bits/stdc++.h>

using namespace std;
const int N = 505;

int a[N], b[N];
int main() {
    int T;
    cin >>T;
    while (T--) {
        int x, y;
        cin >> x >> y;
        for (int i = 0; i < x; i++) {
            cin >> a[i];
        }
        for (int j = 0; j < x; j++) {
            cin >> b[j];
        }
        sort(a, a + x);
        sort(b, b + x, greater<int>());
        int flag = 1;
        for (int i = 0; i < x; i++) {
            if (a[i] + b[i] > y) {
                cout << "No" << endl;
                flag = 0;
                break;
            }
        }
        if (flag) cout << "Yes" << endl;
    }
    return 0;
}
```



## 3686. 移动序列

![image-20210616190827568](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210616190827568.png)

> 统计最左端1得到`index`为`l`和最右端1得到`index`为`r`，最后统计`[l, r]`之间的0即可。

```c++
#include <bits/stdc++.h>
using namespace std;


int a[55];

int main() {
    int T;
    cin >> T;
    int n = 0;
    while (T--) {
        cin >> n;
        for (int i = 0; i < n; i++) {
            cin >> a[i];
        }
        int l = 0;
        for (int i = 0; i < n; i++) {
            if (a[i] == 1) {
                l = i;break;
            }
        }
        int r = 0;
        for (int i = n - 1; i >= 0; i--) {
            if (a[i] == 1) {
                r = i;break;
            }
        }
        int cnt = 0;
        for (int i = l; i < r; i++) {
            if (a[i] == 0) {
                cnt++;
            }
        }
        cout << cnt << endl;
    }
    return 0;
}
```



## 3646. 分水果

![image-20210608195437512](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210608195437512.png)

> 贪心算法：三种可能组合 

```c++
#include <bits/stdc++.h>
using namespace std;

void resort(int &a, int &b, int &c) {
    int arr[3] = {a, b, c};
    sort(arr, arr + 3, greater<int>());
    a = arr[0], b = arr[1], c = arr[2];
}

int work(int a, int b, int c){
    int ans = 0;
    if (a > 0) a--, ans++;
    if (b > 0) b--, ans++;
    if (c > 0) c--, ans++;
    resort(a, b, c);
    if (a > 0 && b > 0) a--, b--, ans++;
    if (a > 0 && c > 0) a--, c--, ans++;
    if (b > 0 && c > 0) c--, b--, ans++;

    
    if (a > 0 && b > 0 && c > 0) a--, b--, c--, ans++;

    return ans;    
}
int main() {
    int n;
    cin >> n;
    while (n --) {
        int a, b ,c;
        cin >> a >> b >> c;
        cout << work(a, b, c) << endl;
    }
    
    return 0;
}

```





## 3629. 同心圆涂色

![image-20210605091651268](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210605091651268.png)

> 简单题目：不过要注意精度问题
>
> `#definePI acos(-1) `

```c++
#include <bits/stdc++.h>
using namespace std;
const int N = 105;
#define PI acos(-1)

long long  a[N];



int main() {
    int n;
    cin >> n;
    for (int i = 0; i < n; i++) {
        cin >> a[i];
    }
    sort(a, a + n, greater<int>());
    double ans = 0;
    long long temp = 0;
    for (int i = 0; i < n; i += 2) {
        temp += a[i] * a[i];
    }
    for (int i = 1; i < n; i += 2) {
        temp -= a[i] * a[i];
    }
    ans = PI * temp;


    printf("%.6lf\n", ans);
    return 0;
}
```





## 3624. 三值字符串

![image-20210603195257269](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210603195257269.png)

> 双指针
>
> 采用三个变量维护状态 左指针移动的情况是当前区间内的个数大于1

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 200010;

int n;
char s[N];
int cnt[3];

int main()
{
    int T;
    scanf("%d", &T);
    while (T -- )
    {
        scanf("%s", s);
        n = strlen(s);

        memset(cnt, 0, sizeof cnt);
        int res = n + 1;
        for (int i = 0, j = 0; i < n; i ++ )
        {
            cnt[s[i] - '1'] ++ ;
            while (cnt[s[j] - '1'] > 1) cnt[s[j ++ ] - '1'] -- ;
            if (cnt[0] && cnt[1] && cnt[2])
                res = min(res, i - j + 1);
        }

        if (res == n + 1) res = 0;
        printf("%d\n", res);
    }

    return 0;
}
```



## 3617. 子矩形计数

![image-20210602194457714](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210602194457714.png)

> 思维题
>
> 将k分成两个数相乘的形式（假设为k = a * b）
>
> 在row[]中找出有多少个a个连续的1；
> 在col[]中找出有多少个b个连续的1；
>
> 将两者相乘再累加；

![image-20210602193453372](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210602193453372.png)

```c++
#include <iostream>
#include <algorithm>
#include <cstring>

using namespace std;

typedef long long LL;

const int N = 40010;

int n, m, k;
bool row[N], col[N];

LL count(int x, bool arr[], int len)
{
    int res = 0, cnt = 0;
    for(int i = 1;i <= len;i ++)
        if(arr[i]) cnt ++;
        else
        {
            if(cnt >= x) res += cnt - x + 1;
            cnt = 0;
        }
    if(cnt >= x) res += cnt - x + 1;

    return res;
}

int main()
{
    cin >> n >> m >> k;
    for(int i = 1;i <= n;i ++) cin >> row[i];
    for(int i = 1;i <= m;i ++) cin >> col[i];

    LL res = 0;
    for(int i = 1;i <= k && i <= 40010;i ++)
        if(k % i == 0)
        {
            int a = i, b = k / i;
            LL cnta = count(a, row, n), cntb = count(b, col, m);
            res += cnta * cntb;
        }

    cout << res << endl;

    return 0;
}

```



## 3583.整数分组

> dp
>
> `dp[i][j]`表示前i个数分成j组的最大方案数
>
> 转移方程`dp[i][j] = max(dp[i - 1][j], dp[k - 1][j - 1] + (i - k + 1))`表示将第i个字符划分到第j组中 且第j组是从k开始的 是当前组中最小的



```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 5010;

int n, m;
int w[N];
int f[N][N];

int main()
{
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i ++ ) scanf("%d", &w[i]);
    sort(w + 1, w + n + 1);

    for (int i = 1, k = 1; i <= n; i ++ )
    {
        while (w[i] - w[k] > 5) k ++ ;
        for (int j = 1; j <= m; j ++ )
            f[i][j] = max(f[i - 1][j], f[k - 1][j - 1] + (i - k + 1));
    }

    printf("%d\n", f[n][m]);
    return 0;
}

```



## 3580.整数配对

> 简单思维
>
> 1.先预处理 把成对的处理完毕
>
> 2.再对新数组做排序
>
> 3.最优解是低位与最近高位做配对

```c++
#include <bits/stdc++.h>

using namespace std;
const int N = 1e5;
int a[N];
int main() {
    int n;
    cin>> n;
    unordered_map<int, int> um;
    for (int i = 0; i < n; i++) {
        cin >> a[i];
        um[a[i]]++;
    }
    vector<int> temp;
    for (auto x : um) {
        if (x.second % 2) {
            temp.push_back(x.first);
        }
    }
    n = temp.size();
    sort(temp.begin(), temp.end());
    
    int ans = 0;
    for (int i = 1; i < n; i += 2) {
        ans += abs(temp[i - 1] - temp[i]);
    }
    cout << ans << endl;
    return 0;
}
```



## 3333.K-优字符串

> 思维题目

![image-20210521202455496](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210521202455496.png)

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 200010;

int n, k;
char str[N];

int main()
{
    int T;
    scanf("%d", &T);
    for (int C = 1; C <= T; C ++ )
    {
        printf("Case #%d: ", C);
        scanf("%d%d%s", &n, &k, str);
        int cnt = 0;
        for (int i = 0, j = n - 1; i < j; i ++, j -- )
            if (str[i] != str[j])
                cnt ++ ;
        printf("%d\n", abs(cnt - k));
    }

    return 0;
}

```



## 3483.2的慕次方

> 递归

```c++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

string dfs(int n)
{
    string res;
    for (int i = 14; i >= 0; i -- )
        if (n >> i & 1)
        {
            // 不是第一个的话需要相加
            if (res.size()) res += '+';
            // i为0
            if (!i) res += "2(0)";
            // i为1
            else if (i == 1) res += "2";
            // i >= 2
            else res += "2(" + dfs(i) + ")";
        }
    return res;
}

int main()
{
    int n;
    while (cin >> n)
        cout << dfs(n) << endl;
    return 0;
}

```



## 3404.谁是你的潜在朋友

> 简单统计

![image-20210518191828793](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210518191828793.png)

```c++
#include <bits/stdc++.h>

using namespace std;
int a[202];
int main() {
    int n, m;
    cin >> n >> m;
    unordered_map<int, int> his;
    int x;
    for (int i = 0; i < n; i++) {
        cin >> x;
        a[i] = x;
        his[x] ++;
    }
    
    for (int i = 0; i < n; i++) {
        if (his[a[i]] - 1) {
            cout << his[a[i]] - 1 << endl;
        } else {
            cout << "BeiJu" << endl;
        }
    }
    return 0;
}
```



## 3481.阶乘的和

![image-20210516200856928](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210516200856928.png)

> 启发式剪枝，二进制枚举，爆搜

```c++
#include <iostream>
#include <cstring>
#include <algorithm>
#include <unordered_set>

using namespace std;

int f[10];
unordered_set<int> S;

int main()
{
    for (int i = 0; i < 10; i ++ )
    {
        f[i] = 1;
        for (int j = i; j; j -- )
            f[i] *= j;
    }

    // 总共有10个数字 所有就有2^10个状态
    for (int i = 1; i < 1 << 10; i ++ )
    {
        int s = 0;
        // 对当前i状态检查 每一位的值
        for (int j = 0; j < 10; j ++ )
            if (i >> j & 1)
                s += f[j];
       // 插入到集合中
        S.insert(s);
    }

    int n;
    while (cin >> n, n >= 0)
        if (S.count(n))
            puts("YES");
        else
            puts("NO");
    return 0;
}

```

```c++
#include <iostream>
#include <cstring>
#include <algorithm>
#include <unordered_set>

using namespace std;

int f[10];
unordered_set<int> S;

void init() {
    f[0] = f[1] = 1;
    for (int i = 2; i < 10; i++) {
        f[i] = f[i - 1] * i;
        //cout << f[i] << endl;
    }
}
bool flag;
void dfs(int cur, int sum, int &target) {
    if (sum == target) {
        flag = 1; 
        return ;
    }
    if (sum > target) {
        return ;
    }
    for (int i = cur + 1; i < 10; i++) {
        dfs(i, sum + f[i], target);
    }
}


int main()
{
    int target;
    init();
    while (cin >> target) {
        if (target < 0) return 0;
        if (target == 0) {
            cout << "NO" <<endl;
            continue;
        }
        for (int i = 0; i < 10; i++) {
            dfs(i,  f[i], target);
            if (flag) {
                break;
            }
        }
        if (flag) {
            flag = 0;
            cout << "YES"  << endl;
            continue;
        } 
        cout << "NO" << endl;
    }
    return 0;
}



```



## 3502.不同路径数

> 迷宫模板题目

![image-20210513193607496](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210513193607496.png)

```c++
#include <bits/stdc++.h>
using namespace std;
const int N = 7;
int n, m, k;
int a[N][N];

int dir[][2] = {
    {-1, 0},
    {1, 0},
    {0, 1},
    {0 , -1}
};
int v[N][N];

bool check(int x, int y ) {
    if (x >= 0 && y >= 0 && x < n && y < m) {
        return true;
    }
    return false;
}
set<string> strs;
void getNum(int i, int j, string s, int cnt) {
    if (k + 1 == cnt) {
        strs.insert(s);
        return;
    }
    
    for (int x = 0; x < 4; x++) {
        int dx = i + dir[x][0], dy = j + dir[x][1];
        if (check(dx, dy) && !v[dx][dy]) {
            //v[dx][dy] = 1;
            getNum(dx, dy, s + to_string(a[dx][dy]), cnt + 1);
            //v[dx][dy] = 0;
        }
    }
}

int main() {
    cin >> n >> m >> k;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            cin >> a[i][j];
        }
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            //string temp = "";
            //v[i][j] = 1;
            getNum(i, j, to_string(a[i][j]), 1);
            //v[i][j] = 0;
        }
    }
    // for (auto x : strs) {
    //     cout << x << endl;
    // }
    cout << strs.size() << endl;
    return 0;
}
```



## 3493.最大的和

> 思维 + 滑动窗口 + 前缀和
>
> 可以选择的数是确定的。因为数>1，所有可以枚举每一个k区间长度内得不可直接选择的总和。然后相加。

```c++
#include <bits/stdc++.h>
using namespace std;

const int N = 1e5+5;
int a[N];
bool v[N];
long long sum[N];
int main() {
    int n, k;
    cin >> n >> k;
    
    for (int i = 0; i < n; i++) {
        cin >> a[i];
    }
    long long ans = 0;

    for (int i = 0; i < n; i++) {
        cin >> v[i];
        if (v[i]) {
            ans += a[i];
        }
    }
    sum[0] = !v[0]?0:a[0];
    for (int i = 1; i< n; i++) {
        sum[i] = sum[i - 1] + (!v[i]) * a[i];
    }

    long long temp = 0;
    
    for (int j = 0; j <= n - k; j++) {
        long long xx = sum[j + k - 1] - sum[j] + (!v[j]) * a[j];
        temp = max(temp, xx);
    }
    
    cout << temp + ans << endl;
    return 0;
}
```



## 3485.最大异或和(MT笔试)

![image-20210510220806981](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210510220806981.png)

> 分析：
>
> 对于==20%==的数据显然可以使用n^3的算法。枚举起始下标和结束下标。然后再计算该区间的值。
>
> 对于==50%==的数据可以采用n^2的算法，使用前缀和快速求取。
>
> 对于==100%==的数据，可以先求出异或前缀和数组，然后问题就等价于从一堆数中选出两个数，他们两个的异或和最大。
>
> 即：`si = a1^a2^..^ai` , `sj = a1^a2^..^aj`, `si ^ aj = a^i+1...aj`

```c++
#include <bits/stdc++.h>
using namespace std;
const int N = 100010 * 31, M = 100010; // 元素数100010，trie树高31

int n, m; // n元素个数 m区间最大值

int s[M]; // s用于记录每次读取的值

int son[N][2], cnt[N], idx; // son是trim数

void insert(int x, int v) { // 将一个数字加入到trie树中
    int p = 0; // 初始在头结点
    for (int i = 30; i >= 0; i--) { // 一次判断31位数字
        int u = x >> i & 1;
        if (!son[p][u]) son[p][u] = ++idx; //如果还没有创建就创建该结点
        p = son[p][u]; // 移动到左子树或者右子树
        cnt[p] += v;// v = 1 新增加 , v = -1删除
    }
}

int query(int x) {
    int res = 0, p = 0;
    for (int i = 30; i >= 0; i--) {
        int u = x >> i & 1;
        // 每次选择不一样的子树 因为是异或，两者不同必然异或为1
        if (cnt[son[p][!u]]) p =son[p][!u] , res = res * 2 + 1; 
        
        else p = son[p][u] , res = res * 2;
    }
    return res;
}


int main() {

    cin >> n >> m;
    
    for (int i = 1; i<= n; i++) {
        int x;
        cin >> x;
        s[i] = s[i - 1] ^ x;
    }
    int res = 0;
    
    insert(s[0], 1);
    
    for (int i = 1; i <= n; i++) {
        if (i > m) insert(s[i - m - 1], -1); // 区间大于m就删除
        res = max(res, query(s[i]));
        insert(s[i], 1);
    }
    cout << res << endl;
    
    return 0;
}
```

## 3489.星期几--模拟

```c++
#include <iostream>
#include <cstring>
#include <algorithm>
#include <unordered_map>

using namespace std;

// 1-12月 正常日期
int months[13] = {
    0, 31, 28, 31, 30, 31, 30, 31, 31,
    30, 31, 30, 31
};

//建立map映射
unordered_map<string, int> month_name = {
    {"January", 1},
    {"February", 2},
    {"March", 3},
    {"April", 4},
    {"May", 5},
    {"June", 6},
    {"July", 7},
    {"August", 8},
    {"September", 9},
    {"October", 10},
    {"November", 11},
    {"December", 12},
};

// 星期几名字映射
string week_name[7] = {
    "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday",
    "Sunday"
};

// 判断是否是leap年
int is_leap(int year)
{
    return year % 4 == 0 && year % 100 || year % 400 == 0;
}

// 获取该年中某年某月的天数
int get_days(int year, int month)
{
    int s = months[month];
    if (month == 2) return s + is_leap(year);
    return s;
}

int main()
{
    int d, m, y;
    string str;
    while (cin >> d >> str >> y)
    {
        m = month_name[str];
        int i = 1, j = 1, k = 1; // i = year, j = month, k = days (1 - 30)
        int days = 0;
        while (i < y || j < m || k < d) // 目标日期还没有达到
        {
            k ++, days ++ ; // 本月天数++, 总天数++
            if (k > get_days(i, j)) // 如果本月天数 > 该月天数 即进入下一个月
            {
                k = 1; // 第一天
                j ++ ; // 月份++
                if (j > 12) // 如果月份大于 12 说明进入下一年
                {
                    j = 1; // 重新回到1月
                    i ++ ; // year++
                }
            }
        }
		//结果 = 总天数%7
        cout << week_name[days % 7] << endl;
    }

    return 0;
}
```



# LC WeekContest

## 239场周赛

#### [5746. 到目标元素的最小距离](https://leetcode-cn.com/problems/minimum-distance-to-the-target-element/)

![image-20210503103928330](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210503103928330.png)

```c++
class Solution {
public:
    int getMinDistance(vector<int>& nums, int target, int start) {
        int ans = INT_MAX;
        for (int i = 0; i < nums.size(); i++) {
            if (nums[i] == target) {
                ans = min(ans, abs(i - start));
            }
        }
        return ans;
    }
};
```

#### [5747. 将字符串拆分为递减的连续值](https://leetcode-cn.com/problems/splitting-a-string-into-descending-consecutive-values/)

![image-20210503104038591](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210503104038591.png)

> 二进制枚举

```c++
class Solution {
public:
    bool splitString(string s) {
        int n = s.size();
        for (int i = 1; i < 1 << (n - 1); i++) {
            bool flag = true;
            unsigned long long last = -1, x = s[0] - '0';
            for (int j = 0; j < n - 1; j++) {
                if (i >> j & 1) { // 当前位需要分割
                    // 检查合法性
                    if (last != -1 && x != last - 1) {
                        flag = false;
                        break;
                    }
                    // 记录上一个的数值
                    last = x;
                    // 新值为 j + 1
                    x = s[j + 1] - '0';
                } else { // 不分割 继续相加
                    x = x * 10 + s[j + 1] - '0';
                }
                
                
            }
            if (x != last - 1) flag = false;
            if (flag) return true;

        }
        return false;
    }
};
```



#### [5749. 邻位交换的最小次数](https://leetcode-cn.com/problems/minimum-adjacent-swaps-to-reach-the-kth-smallest-number/)

![image-20210503105657066](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210503105657066.png)

> 求当前全排列的下k个排列
>
> `next_permutation(b.begin(), b.end())`
>
> 先找到第k个数，再逆序对交换。等价求解逆数对
>
> C存A的元素在B中的下标位置和次数，

![image-20210503110017347](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210503110017347.png)

```c++
class Solution {
public:
    int getMinSwaps(string a, int k) {
		string b = a;
        while (k--) next_permutation(b.begin(), b.end());
        
        int n = a.size();
        vector<int> c(n);
        int cnt[10] = {0};
        for (int i = 0; i < n; i++) {
            int x = a[i] - '0';
            cnt[x]++;
            int y = cnt[x];
            for (int j = 0; j < n; j++) {
                if (b[j] - '0' == x && --y == 0) {
                    c[i] = j;
                    break;
                }

            }

        }
        int res = 0;
        for (int i = 0; i < n; i++) {
            for (int j  = i + 1; j < n; j++) {
                if (c[i] > c[j]) 
                    res++;
            }
        }
        return res;
    }
};
```





## 236场周赛

### 数组元素积的符号

> 签到

![image-20210411142048820](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411142048820.png)

### 5727找出游戏的获胜者

> 约瑟夫环 
>
> 循环链表模拟
>
> 递推

![image-20210411142135411](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411142135411.png)

```c++
class Solution {
public:
    typedef struct node {
        int val;
        node * next;
    }node;
    
    int findTheWinner(int n, int k) {
        if (n == 1) return 1;
        if (k == 1) return n;
        node *head = new node();
        head -> val = 1, head -> next = new node();
        node *temp = head;
        temp = temp -> next;
        for (int i = 2;i <= n; i++) {
            temp -> val = i;
            if (i != n)
                temp ->  next = new node();
            else 
                temp -> next = head;
            temp = temp -> next;
        }
        int remain = n;
        // for (int i = 0; i <= n; i++) {
        //     cout << head -> val << endl;
        //     head = head -> next;
        // }
        node * cur = head;
        while (remain != 1) {
            for (int i = 1; i < k - 1; i++) {
                cur = cur -> next;  
            }
            //cout << cur -> val << endl;
            //cout << cur -> next -> val  << endl;
            cur -> next = cur -> next -> next;
            cur = cur -> next;
            remain--;
        }
        return cur -> val;
    }
};
```

```c++
class Solution {
    public:
    int f(int n, int k) {
        if (n == 1) return 0;
        return (f(n - 1, k) + k) %n;
    }
    int findTheWinner(int n, int k) {
        return f(n, k) + 1;
    }
}
```



### 最少侧跳数

![image-20210411142221079](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411142221079.png)

```c++
const int N = 500010, INF = 1e8;

int f[N][3];

class Solution {
public:
    int minSideJumps(vector<int>& b) {
        // 中间跑道 跳到其它跑道都需要1
        f[0][1] = 0, f[0][0] = f[0][2] = 1;

        int n = b.size() - 1;
        for (int i = 1; i <= n; i ++ ) // 第i层
            for (int j = 0; j < 3; j ++ ) { // 第i层的 三个点
                f[i][j] = INF; // 初始状态为INF
                if (b[i] == j + 1) continue;// 当前要求的该点位障碍物 跳过
                for (int k = 0; k < 3; k ++ ) { // 枚举i - 1层的所有状态
                    if (b[i] == k + 1) continue; // 不能由i - 1层通过到达
                    int cost = 0; // 在同一个水平线上 cost = 0
                    if (k != j) cost = 1; // 说明不在同一个水平线上
                    f[i][j] = min(f[i][j], f[i - 1][k] + cost);
                }
            }
        return min(f[n][0], min(f[n][1], f[n][2]));
    }
};

```





# 前200道题目

## 1 两数之和

```c++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        vector<int> ans(2);
        int len = nums.size();
        for (int i = 0; i < len; i++) {
            for (int j = i + 1; j < len; j++) {
                if (nums[i] + nums[j] == target) {
                    ans[0] = i, ans[1] = j;
                    return ans;
                }
            }
        }
        return nums;
    }
};
```

## 2. 两数相加

```c++
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode head = new ListNode(l1.val + l2.val);
        ListNode cur = head;
        while(l1.next != null || l2.next != null){
            l1 = l1.next != null ? l1.next : new ListNode();
            l2 = l2.next != null ? l2.next : new ListNode();
            cur.next = new ListNode(l1.val + l2.val + cur.val / 10);
            cur.val %= 10;
            cur = cur.next;
        }
        if(cur.val >= 10){
            cur.next = new ListNode(cur.val / 10);
            cur.val %= 10;
        }
        return head;
    }
}

```

## 3. 无重复的最长子串

```c++
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        if(s.size() == 0) return 0;
        unordered_set<char> lookup;
        int maxStr = 0;
        int left = 0;
        for(int i = 0; i < s.size(); i++){

            // 查找到了s[i] 删除左边
            while (lookup.find(s[i]) != lookup.end()){
                lookup.erase(s[left]);
                left ++;
            }

            maxStr = max(maxStr,i-left+1);
            lookup.insert(s[i]);
    }
        return maxStr;
        
    }
};
```

## 4. 寻找两个正序数组中的中位数

```c++
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int len1 = nums1.size(), len2 = nums2.size();
        int n = len1 + len2;
        for (auto num : nums2) {
            nums1.push_back(num);
        }
        sort(nums1.begin(), nums1.end());
        if (n % 2 == 1) return nums1[n / 2];
        else {
            int mid = n / 2 - 1;
            double a = nums1[mid], b = nums1[mid + 1];
            
            return (a + b) / 2;
        }
        
    }
};
```



## 5. 最长回文串

```c++
class Solution {
public:
    string longestPalindrome(string s) {
        int n = s.size();
        vector<vector<int>> dp(n, vector<int>(n));
        string ans;
        for (int l = 0; l < n; ++l) {
            for (int i = 0; i + l < n; ++i) {
                int j = i + l;
                if (l == 0) {
                    dp[i][j] = 1;
                } else if (l == 1) {
                    dp[i][j] = (s[i] == s[j]);
                } else {
                    dp[i][j] = (s[i] == s[j] && dp[i + 1][j - 1]);
                }
                if (dp[i][j] && l + 1 > ans.size()) {
                    ans = s.substr(i, l + 1);
                }
            }
        }
        return ans;
    }
};

```

## 6. Z字形变换

```c++
class Solution {
public:
    string convert(string s, int numRows) {

        if (numRows == 1) return s;

        vector<string> rows(min(numRows, int(s.size())));
        int curRow = 0;
        bool goingDown = false;

        for (char c : s) {
            rows[curRow] += c;
            if (curRow == 0 || curRow == numRows - 1) goingDown = !goingDown;
            curRow += goingDown ? 1 : -1;
        }

        string ret;
        for (string row : rows) ret += row;
        return ret;
    }
};


```

## 7. 整数翻转

```c++
class Solution {
public:
    int reverse(int x) {
        string MAX = to_string(0x7fffffff); 
        int MIN_ = 0x80000000;
        string MIN = to_string(MIN_);

        bool sign = 0; // 0 positive
        if (x == MIN_) return 0;
        if (x < 0) x = -x, sign = 1;
        string old = to_string(x);
        std::reverse(old.begin(), old.end()); // 321
        if (sign) { // 负数
            old = '-' + old;
            if (MIN.length() <= old.length()) {
                if (old > MIN) return 0;
            }

        } else {
            if (MAX.length() <= old.length()) {
                if (MAX < old) return 0;
            }
        }
       //cout << old << endl;
        return atoi(old.c_str());

    }
};
```



## 8. 字符串转换整数

```c++
class Solution {
public:
    int myAtoi(string s) {
        int sign = 1, tmp = 0, i = 0;

        while(s[i] == ' ')  ++i;    //1.忽略前导空格

        if(s[i] == '+' || s[i] == '-')    //2.确定正负号
            sign = (s[i++] == '-') ? -1 : 1;   //s[i]为+的话sign依旧为1，为-的话sign为-1

        while(s[i] >= '0' && s[i] <= '9')   //3.检查输入是否合法
        {
            if(tmp > INT_MAX / 10 || (tmp == INT_MAX / 10 && s[i] - '0' > 7))    //4.是否溢出
                return sign == 1 ? INT_MAX : INT_MIN;
            tmp = tmp * 10 + (s[i++] - '0');    //5.不加括号有溢出风险
        }
        return tmp * sign;
    }
};


```

## 9. 判断是否为回文字符串

```c++
class Solution {
public:
    bool isPalindrome(int x) {
        string posiX = to_string(x);
        string temp = posiX;
        reverse(posiX.begin(), posiX.end());
        return temp == posiX;
    }
};
```

```c++
class Solution {
public:
    bool isPalindrome(int x) {
        if (x < 0) return false;
        long temp = 0;
        int r = x;
        while (r != 0) {
            if (temp > x) return false;
            temp = temp * 10 + r % 10;
            r /= 10;
        }
        return temp == x;
    }
};
```

## 10.正则表达式匹配



## 11.盛水最多的容器

```java
class Solution {
    public int maxArea(int[] height) {
        int i = 0, j = height.length - 1, res = 0;
        while(i < j){
            res = height[i] < height[j] ? 
                Math.max(res, (j - i) * height[i++]): 
                Math.max(res, (j - i) * height[j--]); 
        }
        return res;
    }
}

```

## 12. 整数转罗马数字

> 13 个数字 从大到小 依次减到不能减

![image-20210411171146513](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411171146513.png)

```c++
class Solution {
public:
    string intToRoman(int num) {
        string strs[]= {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
        int nums[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
        string ans;
        for (int i = 0; num > 0 && i < 13; i++) {
            while (nums[i] <= num) {
                ans += strs[i];
                num -= nums[i];
            }
        }
        return ans;
    }
};
```

## 13. 罗马数字转整数

> 建立映射函数 对于每一个字符 计算它和它之前的 对于I, IV 扫描到V会查看前一个 即IV得到3 因为前一个I已经计算过为1。结合编码格式，因为VIV是不存在的。

```c++
class Solution {
public:
    int romanToInt(string s) {
        unordered_map<string, int> m = {{"I", 1}, {"IV", 3}, {"IX", 8}, {"V", 5}, {"X", 10}, {"XL", 30}, {"XC", 80}, {"L", 50}, {"C", 100}, {"CD", 300}, {"CM", 800}, {"D", 500}, {"M", 1000}};
        int r = m[s.substr(0, 1)];
        for(int i=1; i<s.size(); ++i){
            string two = s.substr(i-1, 2);
            string one = s.substr(i, 1);
            r += m[two] ? m[two] : m[one];
        }
        return r;
    }
};
```

## 14. 最长公共前缀

> 维护cnt指针 指向公共下标

![image-20210411183533416](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210411183533416.png)

```c++
class Solution {
public:
    string longestCommonPrefix(vector<string>& strs) {
        string ans = "";
        
        int len = strs.size();
        if (len == 0) return "";
        int cnt = 0;
        while(1) {
            for (int i = 0; i < len; i++) {
                if (strs[i].length() == 0) return "";
                if (cnt < strs[i].length() && cnt < strs[0].length() && strs[i][cnt] == strs[0][cnt]) {
                    continue;
                } else {
                    return ans;
                }
            }
            ans += strs[0][cnt++];
        }
        return ans;
    }
};
```

## 15. 三数之和

> 排序 + 三指针

```c++
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        vector<vector<int>> res;

        int n = nums.size();
        if (n < 3) return res;

        sort(nums.begin(), nums.end());

        for (int i = 0; i < n; i ++ ) {
            //1. 开始预处理
            if (nums[i] > 0) return res;                    //若第一个数大于0，后面怎么加都不会等于0了
            if (i > 0 && nums[i] == nums[i - 1]) continue;  //跳过重复数字
            // i是第一个数 l 三元组中第二小 r 最大的
            int l = i + 1, r = n - 1;
            while (l < r) {
                if (nums[i] + nums[l] + nums[r] == 0) {

                    res.push_back({nums[i], nums[l], nums[r]});         //加入一个正确方案
                    while (l < r && nums[l] == nums[l + 1]) l ++ ;      //跳过重复数字
                    while (l < r && nums[r] == nums[r - 1]) r -- ;
                    l ++ ;                                              //左指针前进
                    r -- ;                                              //右指针后退
                }
                else if (nums[i] + nums[l] + nums[r] > 0) {
                    r -- ;      //和大于0，要减少总和之值，即右指针后退 因为左指针不能再后退了
                }
                else {
                    l ++ ;      //和小于0，要增加总和之值，即左指针前进, 因为右指针不能再前进了
                }
            }
        }

        return res;
    }
};
```

## 17. 电话号码的字符组合

> 回溯法

![image-20210413192426018](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210413192426018.png)

```c++
class Solution {
public:
    vector<string> letterCombinations(string digits) {
        vector<string> combinations;
        if (digits.empty()) {
            return combinations;
        }
        unordered_map<char, string> phoneMap{
            {'2', "abc"},
            {'3', "def"},
            {'4', "ghi"},
            {'5', "jkl"},
            {'6', "mno"},
            {'7', "pqrs"},
            {'8', "tuv"},
            {'9', "wxyz"}
        };
        string combination;
        backtrack(combinations,combination, phoneMap, digits, 0 );
        return combinations;
    }

    void backtrack(vector<string>& combinations, string& combination,const unordered_map<char, string>& phoneMap, const string& digits, int index) {
        if (index == digits.length()) { // 当前达到字符组合长度
            combinations.push_back(combination);
        } else {
            char digit = digits[index];
            const string& letters = phoneMap.at(digit); // 找到对应的letters 
            for (const char& letter: letters) {
                combination.push_back(letter);
                backtrack(combinations,combination,phoneMap, digits, index + 1);
                combination.pop_back();
            }
        }
    }
};
```

## 19. 删除链表的第N个结点

> 先遍历一遍得到整个链表的长度 然后从head走 len - n - 1次，到需要删除的结点的前一个结点，然后通过该结点删除目标结点，返回head
>
> 边界条件：当len - n == 0 即需要删除头结点 head = head -> next就可了

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
        ListNode *temp = head;
        int len = 0;
        while (temp) {
            len++;
            temp = temp -> next;
        }
        temp = head;
        len = len - n;
        if (len == 0) {
            head = head -> next;
            return head;
        }
        for (int i =0; i < len - 1; i++) {
            temp = temp -> next;
        }
        temp -> next = temp -> next -> next;
        return head;
    }
};
```

## 20. 有效的括号

> 用栈来模拟 对于左括号压栈 右括号要检查栈状态

```c++
class Solution {
public:
    bool isValid(string s) {
        stack<char> stk;
        for (auto c: s) {
            if (c == ')' || c == '}' || c == ']') {
                if (stk.size() == 0) return false;
                char top = stk.top();
                if (top == ')' || top == '}' || top == ']') return false;
                switch (c) {
                    case ')':
                        if (top != '(') return false;
                        break;
                    case '}':
                        if (top != '{') return false;
                        break;
                    case ']':
                        if (top != '[') return false;
                        break;
                }
                stk.pop();
            } else {
                stk.push(c);
            }
        }
        return stk.empty();
    }
};
```

## 21.合并两个有序链表

> 递归 每次递归都意味着一次分割

![image-20210414181026316](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210414181026316.png)

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
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
        // 如果为空 意味着有一个到达了尽头 将这个剩下的接到前一个后面即可
        if (l1 == NULL) {
            return l2;
        }
        if (l2 == NULL) {
            return l1;
        }
        // l1 结点小于l2结点
        if (l1->val <= l2->val) {
            l1->next = mergeTwoLists(l1->next, l2);
            return l1;
        }
        // l1结点小于等于l2结点
        l2->next = mergeTwoLists(l1, l2->next);
        return l2;
    }
};
```

## 22. 括号生成

> 递归方法(类似深搜)

![image-20210414181806624](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210414181806624.png)

```c++
class Solution {
    // 检查括号是否有效的一种方式
    bool valid(const string& str) {
        int balance = 0;
        for (char c : str) {
            if (c == '(') {
                ++balance;
            } else {
                --balance;
            }
            if (balance < 0) {
                return false;
            }
        }
        return balance == 0;
    }

    void generate_all(string& current, int n, vector<string>& result) {
        // n是左右括号的个数为2 * n
        if (n == current.size()) {
			// 判断此次迭代的是否符合规则
            if (valid(current)) {
                result.push_back(current);
            }
            return;
        }
        // 此处两种方案 ： 当前填'(' or 当前填 ')'
        current += '(';
        generate_all(current, n, result);
        current.pop_back();
        
        current += ')';
        generate_all(current, n, result);
        current.pop_back();
    }
public:
    vector<string> generateParenthesis(int n) {
        vector<string> result;
        string current;
        generate_all(current, n * 2, result);
        return result;
    }
};
```

> 回溯方法
>
> 优化：跟踪判断当前括号序列是否有效 -- 根据左括号和右括号个数来判断

```c++
class Solution {
    void backtrack(vector<string>& ans, string& cur, int open, int close, int n) {
        if (cur.size() == n * 2) {
            ans.push_back(cur);
            return;
        }
        // 左括号小于n
        if (open < n) {
            cur.push_back('(');
            backtrack(ans, cur, open + 1, close, n);
            cur.pop_back();
        }
        // 右括号小于左括号
        if (close < open) {
            cur.push_back(')');
            backtrack(ans, cur, open, close + 1, n);
            cur.pop_back();
        }
    }
public:
    vector<string> generateParenthesis(int n) {
        vector<string> result;
        string current;
        backtrack(result, current, 0, 0, n);
        return result;
    }
};

```

## 23. 合并K个排序链表

> K次合并 两个有序的链表

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

## 24. 两两交换链表中的节点

> 递归

```c++
class Solution {
public:
    ListNode* swapPairs(ListNode* head) {
        if (head == nullptr || head->next == nullptr) {
            return head;
        }
        ListNode* newHead = head->next; // newHead表示第二个节点
        head->next = swapPairs(newHead->next);// 第一个节点指向下一个递归
        newHead->next = head;// 将第二个节点的next 指向第一个
        return newHead;
    }
};
```

## 26. 删除有序数组中的重复项

> 双指针 一次循环
>
> i指向当前下标 j指向循环

```java
class Solution {
    public int removeDuplicates(int[] nums) {
    if (nums.length == 0) return 0;
    int i = 0;
    for (int j = 1; j < nums.length; j++) {
        if (nums[j] != nums[i]) {
            i++;
            nums[i] = nums[j];
        }
    }
    return i + 1;
}

}
```

## 31. 下一个排列

> 一个很秒的思路

```c++
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        int i = nums.size() - 2, j = nums.size() - 1;
        while(i >= 0 && nums[i] >= nums[i+1])   --i;    //寻找比后面那个数小的nums[i]
        if(i >= 0)   
        {
            while(j >= 0 && nums[j] <= nums[i]) --j;    //寻找比nums[i]大的第一个数
            swap(nums[i], nums[j]);
        }
        sort(nums.begin() + i + 1, nums.end());     //如果不存在下一个排列，i为-1
    }
};
```



## 198. 打家劫舍

> 简单dp
>
> dp[i]表示偷前i家能得到的最大值
>
> `dp[i] = max(dp[i - 1], dp[i - 2] + nums[i - 1])`

```c++
class Solution {
public:
    int rob(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) return 0;
        vector<int> dp(n + 1, 0); // dp[i]表示偷前i个房子的最大金额
        dp[1] = nums[0];
        for (int i = 2; i <= n; i++) {
            dp[i] = max(dp[i - 1], dp[i - 2] + nums[i - 1]);
        }
        return dp[n];
    }
};
```

> 进一步对空间进行压缩

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

# 常见面试题

## 自建链表

![image-20210518224004648](https://gitee.com/DengSchoo374/img/raw/master/images/image-20210518224004648.png)

```c++
#include <iostream>
using namespace std;
struct node{
	int data;
	node *next;
	node(int data,node *next=NULL){
		this->data = data;
		this->next = next;
	}
};
 
node *createlist(const int num){
	node *head = NULL;
    for (int i = 0; i < num; i++) {
        head = new node(i, head);
    }
	return head;
}
 
void displaylist(node *head){
	cout<<"list node -> ";
	while(head!=NULL){
		cout<<head->data<<" ";
		head = head->next;
	}
	cout<<endl;
}
 
int main(){
	node *head = createlist(5);
	displaylist(head);
	return 0;
}
```



## 反转链表

```c++
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        while (curr) {
            ListNode* next = curr->next;
            curr->next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }
};

```

```c++
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (!head || !head->next) {
            return head;
        }
        ListNode* newHead = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        return newHead;
    }
};
```

## 环形链表

> 哈希表存放走过的记录

```c++
class Solution {
public:
    bool hasCycle(ListNode *head) {
        unordered_set<ListNode*> seen;
        while (head != nullptr) {
            if (seen.count(head)) {
                return true;
            }
            seen.insert(head);
            head = head->next;
        }
        return false;
    }
};
```

> 快慢指针

```c++
class Solution {
public:
    bool hasCycle(ListNode* head) {
        if (head == nullptr || head->next == nullptr) {
            return false;
        }
        ListNode* slow = head;
        ListNode* fast = head->next;
        while (slow != fast) {
            if (fast == nullptr || fast->next == nullptr) {
                return false;
            }
            slow = slow->next;
            fast = fast->next->next;
        }
        return true;
    }
};
```

## 合并两个有序链表

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
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
        // 如果为空 意味着有一个到达了尽头 将这个剩下的接到前一个后面即可
        if (l1 == NULL) {
            return l2;
        }
        if (l2 == NULL) {
            return l1;
        }
        // l1 结点小于l2结点
        if (l1->val <= l2->val) {
            l1->next = mergeTwoLists(l1->next, l2);
            return l1;
        }
        // l1结点小于等于l2结点
        l2->next = mergeTwoLists(l1, l2->next);
        return l2;
    }
};
```

## 求开方

> 二分查找

```c++
int mySqrt(int a) {
    if (a == 0) return a;
    int l = 1, r = a, mid, sqrt;
    while (l <= r) {
        mid = l + (r - 1) / 2;
        sqrt = a / mid;
        if (sqrt == mid) {
            return mid;
        } else if (mid > sqrt){
            r = mid - 1;
        } else if {
            l = mid + 1;
        }
        return r;
    }
}
```

> 牛顿迭代法:为了防止平方越界

```c++
int mySqrt(int a) {
    long x = a;
    while (x * x > a) {
        x = (x + a / x) / 2;
    }
    return x;
}
```

## 快速排序

```c++
void quick_sort(vector<int> &nums, int l, int r) {
    if (l + 1 >= r) return;
    int first = l, last = r - 1, key = nums[first];
    while (first < last) {
        while (first < last && nums[last] >= key) last--;
        nums[first] = nums[last]; // 找到小于key的
        while (first < last && nums[first] <= key) first++;
        nums[last] = nums[first];
    }
    nums[first] = key;
    quick_sort(nums, l, first);
    quick_sort(nums, first + 1, r);
}
```

## 第K大数

```c++
int findKthLarget(vector<int> &nums, int k) {
    int l = 0, r = nums.size(), target = num.size() - k;
    while (l < r) {
        int mid = quickSelection(nums, l, r);
        if (mid == target) {
            return nums[mid];
        }
        if (mid < target) {
            l = mid + 1;
        } else {
             r = mid - 1;
        }
    }
    return nums[l];
}

int quicSelection(vector<int> &nums, int l, int r) {
    int i = l + 1, j = r;
    while (true) {
        while (i < r && nums[i] <= nums[j]) ++i;
        while (l < j && nums[j] >= nums[l]) --j;
        if (i >= j) break;
        swap(nums[i], nums[j]);
    }
    swap(nums[l], nums[j]);
    return j;
}
```

## 矩阵中最大的正方形

```c++
int maxmalSqare(vector<vector=>>)
```

 