+++
title = "LeetCode 刷题笔记03"
authors = ['潘峰']

date = 2018-12-24T16:00:00 
# lastmod = 2018-12-24T00:00:00 

draft = false
mathjax = true

tags = ["LeetCode"]
categories = ["LeetCode"]
summary = "LeetCode 刷题之旅."
+++

链接：[leetcode](https://leetcode.com/problemset/all/)

# 3. 最大非重复子串（Longest Substring Without Repeating Characters）

难度：:broken_heart::broken_heart::broken_heart:

Given a string, find the length of the longest substring without repeating characters.

```
Example 1:

Input: "abcabcbb"
Output: 3 
Explanation: The answer is "abc", with the length of 3
```

```
Example 2:

Input: "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

```
Example 3:

Input: "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
             Note that the answer must be a substring, "pwke" is a subsequence and not a substring.
```

## 思路

思路一定是：逐个检查所有子字符串，看它是否没有重复的字符。

优化方式1：不要直接用子串，尽量用底层存放的地址、或byte值来判断

判断重复时，最好使用map，将子串的每个元素导入map，值为位置

再次检查时只需检查key是否存在，如果存在，映射该值到当前位置的长度，即为本次循环的最大子串

优化方式2：去重复无效的判断

本次循环后，下一次循环只需要在重复元素的下一个元素进行判断即可

优化方式3：能减少计算就不要计算

`len(s$[i:j]$)` 就可以实现  $ret = j - i + 1$

## 代码

```
func lengthOfLongestSubstring(s string) int {
    var i,j,ret int
    m := make(map[byte]int)
    for j < len(s) {
        if v, ok := m[s[j]]; ok {
            ret = max(ret, len(s[i:j]))
            i = max(i, v+1)
        }
        m[s[j]] = j
        j += 1
    }
    return max(ret, len(s[i:j]))
} 

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

