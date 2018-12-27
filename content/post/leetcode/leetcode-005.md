+++
title = "LeetCode 刷题笔记05"
authors = ['潘峰']

date = 2018-12-24T17:00:00 
# lastmod = 2018-12-24T00:00:00 

draft = false
mathjax = true

tags = ["LeetCode"]
categories = ["LeetCode"]
summary = "LeetCode 刷题之旅."
+++

链接：[leetcode](https://leetcode.com/problemset/all/)

# 5. Longest Palindromic Substring（取最长回文子串）

难度：:broken_heart::broken_heart::broken_heart:

Given a string s, find the longest palindromic substring in s. You may assume that the maximum length of s is 1000.

取最长回文子串

```
Example 1:

Input: "babad"
Output: "bab"
Note: "aba" is also a valid answer.
```

```
Example 2:

Input: "cbbd"
Output: "bb"
```


## 思路

Manacher算法（马拉车算法）

由于回文分为偶回文（比如 bccb ）和奇回文（比如 bcacb ），处理奇偶问题会比较繁琐，所以这里我们使用一个技巧

> 在字符间各插入一个字符（前提这个字符未出现在串里）

举个例子：
```
// 奇
s="aba"
s_new="#a#b#a#"
// 偶
s="abba"
s_new="#a#b#b#a#"
```
奇偶回文都变成了奇回文

辅助变量：

+ 当前回文串长度：max-len
+ 回文半径数组: $p[i]$，第i个位置上的回文半径
    + 可以推出`$p[i] - 1$ = max-len` （半径中每个占位符可以理解为对称的实际字符串：那么奇数会多一个外面的占位符，偶数会多一个中间的占位符，因此`带占位符的回文半径 = 原回文串长度 + 1 `），那么只要我们求出了RL数组，就能得到最长回文子串的长度
    + 于是问题变成了，怎样高效地求的RL数组。基本思路是利用回文串的对称性，扩展回文串。

```
char:    # a # b # a #
 pi :    1 2 1 4 1 2 1
pi-1:    0 1 0 3 0 1 0
  i :    0 1 2 3 4 5 6

char:    # a # b # b # a #
 pi :    1 2 1 2 5 2 1 2 1
pi-1:    0 1 0 1 4 1 0 1 0
  i :    0 1 2 3 4 5 6 7 8
```  
  
+ 最长边界的位置: maxRight（mx），表示当前访问到的所有回文子串所能触及的最右一个字符的位置。
+ `$mx = i + p[i]$`
+ mx对应的回文串对称轴所在位置：pos（对应大回文串中存在子回文串的情况，左边的回文子串已经计算过，那么右边的回文子串不需要再计算了）


[参考文档](https://segmentfault.com/a/1190000003914228)

## 代码
```
func longestPalindrome(s string) string {
    tmp := Init(s)
	dp := make([]int, len(tmp))
    
	pos, maxRight := 0, 0  // 最大回文串对应的位置
	center, maxLen := 0, 0
	for i := range dp {
		if i < maxRight {
			dp[i] = Min(dp[2*pos-i], maxRight-i) // 避开最大回文串中回文子串的重复计算
		} else {
			dp[i] = 1
		}
		for i-dp[i] >= 0 && i+dp[i] < len(tmp) && tmp[i-dp[i]] == tmp[i+dp[i]] {
			dp[i]++
		}
		if dp[i]+i-1 > maxRight {
			maxRight = dp[i] + i - 1
			pos = i
		}
		if maxLen < dp[i] -1 {
			maxLen = dp[i] -1 
			center = i
		}
	}
	res := make([]int32,0)
	for _,c:=range tmp[center-maxLen:center+maxLen]{
		if c != 0{
			res = append(res,c)
		}
	}
    
	return string(res)
}
func Init(s string) []int32 {
    tmp := make([]int32, 0) // 用byte类型
	tmp = append(tmp, 0) // 第一个位置
	for _, c := range s {
		tmp = append(tmp, c)
		tmp = append(tmp, 0)
	}
    return tmp
}
func Min(x, y int) int {
	if x < y {
		return x
	}
	return y
}
```
运行结果：
```
Runtime: 0 ms, faster than 100.00%
```

