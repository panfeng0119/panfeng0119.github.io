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

什么是“中位数”，找到一个数使一个数组分为两个部分，left 和 right，

> 1. $len(left)=len(right)$
> 2. $\max(\text{left}) \leq \min(\text{right}))$

不要想太多，将两个数组合并然后找中位数就可以



## 代码
```
func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
    nums1 = append(nums1, nums2...)
    sort.Ints(nums1)
    
    var median float64
    
    if len(nums1) % 2 == 1 {
        median = float64(nums1[len(nums1) / 2])
    } else {
        median = float64((nums1[len(nums1) / 2] + nums1[(len(nums1) / 2) - 1]))
        median = median / 2
    }
    
    return median
}
```

```
32 ms, faster than 33.90%
```

