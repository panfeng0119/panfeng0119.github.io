+++
title = "LeetCode 两数求和"
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

```text
Example:

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

```Go
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

---

# 2. 结构体数字求和（Add Two Numbers）

难度：:broken_heart::broken_heart::broken_heart:

You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.


Example:
```
Input: (2 -> 4 -> 3) + (5 -> 6 -> 4)
Output: 7 -> 0 -> 8
Explanation: 342 + 465 = 807.
```

## 思路

这是一个用结构体来实现一个加法，从最低位开始相加，有进位则下一个位置多加1

进位取值在`0`或`1`，因为当前位置最大值为 $9 + 9 + 1 = 19$

需要考虑特殊情况

<!-- | $l1=[0,1 ]$, $l2=[0,1,2]$ | 长短不一

| $l1=[]$, $l2=[0,1]$ | 存在空值

| $l1=[9,9]$, $l2=[1]$ | 一直进位 -->

<table border="1" align="center">
    <tr>
        <td align="center" colspan="2">情况</td>
        <td align="center" rowspan="2">备注</td>
    </tr>
    <tr>
        <td align="center">$l_1$</td>
        <td align="center">$l_2$</td>
    </tr>
    <tr>
        <td align="center">$[0,1 ]$</td>
        <td align="center">$[0,1,2]$</td>
        <td align="center">长短不一</td>
    </tr>
    <tr>
        <td align="center">$[]$</td>
        <td align="center">$[0,1]$</td>
        <td align="center">存在空值</td>
    </tr>
    <tr>
        <td align="center">$[9,9]$</td>
        <td align="center">$[1]$</td>
        <td align="center">一直进位</td>
    </tr>
</table>

使用变量跟踪进位并从列表头部开始模拟逐位数字，其中包含最低有效数字。


## 代码

```Go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
    r := &ListNode{}
    rt := r
    h1, h2 := l1, l2
    t := 0  // 进位符号取值 {0,1}
    for h1 != nil {
        a := h1.Val + t
        if h2 != nil {
            a += h2.Val
            h2 = h2.Next
        }
        t = a / 10
        r.Next = &ListNode{Val: a % 10,}
        r = r.Next
        h1 = h1.Next
    }
    for h2 != nil {
        a := h2.Val + t
        t = a / 10
        r.Next = &ListNode{Val: a % 10,}
        h2 = h2.Next
        r = r.Next
    }
    if t != 0 {
        r.Next = &ListNode{Val: t,}
    }
    return rt.Next
}
```

## 伪代码 (同时遍历)

The pseudocode is as following:

+ Initialize current node to dummy head of the returning list.
+ Initialize carry to 0.
+ Initialize p and q to head of l1 and l2 respectively.
+ Loop through lists l1 and l2 until you reach both ends.
  + Set x to node p's value. If p has reached the end of l1, set to 0.
  + Set y to node q's value. If q has reached the end of l2, set to 0.
  + Set $sum = x + y + carry$.
  + Update $carry = sum / 10$.
  + Create a new node with the digit value of (sum mod 10) and set it to current node's next, then advance current node to next.
  + Advance both p and q.
+ Check if carry = 1, if so append a new node with digit 1 to the returning list.
+ Return dummy head's next node.
