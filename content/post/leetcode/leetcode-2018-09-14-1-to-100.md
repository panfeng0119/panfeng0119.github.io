+++
title = "LeetCode 刷题笔记"

date = 2018-09-14T00:00:00 
lastmod = 2018-09-16T00:00:00 
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ['潘峰']

tags = ["LeetCode"]
summary = "Create a beautifully simple website or blog in under 10 minutes."
+++
[CONTENT MANAGEMENT](https://gohugo.io/categories/content-management)

# 1. Two Sum

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

## 思路

考虑时间复杂度， 按正常思路遍历是 `O(n^2)`

所以需要一个map来记录遍历过的值，key 用 `target - n` 来表示这个数需要匹配的数，value 记录这个位置

如果找到这个值，就直接返回他的value

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


# 2. Two Sum

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

## 思路

考虑时间复杂度， 按正常思路遍历是 `O(n^2)`

所以需要一个map来记录遍历过的值，key 用 `target - n` 来表示这个数需要匹配的数，value 记录这个位置

如果找到这个值，就直接返回他的value

## 代码