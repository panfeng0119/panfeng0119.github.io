+++
title = "LeetCode 刷题笔记01"
authors = ['潘峰']

date = 2018-09-14T00:00:00 
lastmod = 2018-09-16T00:00:00 

draft = false

tags = ["LeetCode"]
categories = ["LeetCode"]
summary = "LeetCode 刷题之旅."
+++

链接：[leetcode](https://leetcode.com/problemset/all/)

# 1. 查找指定和的两个数字（Two Sum）

难度：:broken_heart:

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

## 思路

考虑时间复杂度， 按正常思路遍历是 `O(n^2)`，而实际上我们可以用一个map 来减少一层循环

所以需要一个map来记录遍历过的值，key 用 `target - n` 来表示这个数需要匹配的数，value 记录这个位置

如果找到这个值，就直接返回他的value

即，我们有 `map[差值]该值位置`，如果当前位置值为7，我们需要找2，那么 map中存在 {2:0} 即可返回



## 代码

```
func twoSum(nums []int, target int) []int {
    m := make(map[int]int)
    for i, n := range nums {
        _, prs := m[n]
        if prs {
            return []int{m[n], i}
        } else {
            m[target-n] = i
        }
    }
    return nil;
}
```