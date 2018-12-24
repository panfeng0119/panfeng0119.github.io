+++
title = "LeetCode 刷题笔记04"
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

# 4. Median of Two Sorted Arrays

难度：:broken_heart::broken_heart::broken_heart::broken_heart::broken_heart:

There are two sorted arrays nums1 and nums2 of size m and n respectively.

Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)).

You may assume nums1 and nums2 cannot be both empty.

```
Example 1:

nums1 = [1, 3]
nums2 = [2]

The median is 2.0
```

```
Example 2:

nums1 = [1, 2]
nums2 = [3, 4]

The median is (2 + 3)/2 = 2.5
```


## 思路

要解决这个问题，我们需要了解“中位数有什么用”。在统计中，中位数用于：

> 将一组分成两个相等长度的子集，一个子集所有的值总是大于另一个子集的任意一个值。





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

