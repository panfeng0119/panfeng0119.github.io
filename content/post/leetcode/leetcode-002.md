+++
title = "LeetCode 刷题笔记02"
authors = ['潘峰']

date = 2018-12-24T13:00:00 
# lastmod = 2018-12-24T00:00:00 

draft = false
mathjax = true

tags = ["LeetCode"]
categories = ["LeetCode"]

description = "LeetCode 刷题之旅."

+++

链接：[leetcode](https://leetcode.com/problemset/all/)

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

```
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
	t := 0
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
