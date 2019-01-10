+++
title = "go 排序"
authors = ['潘峰']

date = 2018-11-24T00:00:00 
lastmod = 2019-01-10T17:00:00 

draft = false
mathjax = true


tags = ["LeetCode","go"]
categories = ["LeetCode"]
summary = "Golang 实现排序算法."

toc= true
+++

链接：[leetcode排序题库(22)](https://leetcode.com/tag/sort/)

# 147. Insertion Sort List

难度: medium

单链表插入排序

## 思考点

+ 第一个节点直接插入
+ 已排序的部分和待排序的部分分开
+ 当前元素的操作

```go
func insertionSortList(head *ListNode) *ListNode {
    if head == nil {
        return head
    }
    new_head := &ListNode{}
    cur := head // 指向当前要处理的节点
    for cur != nil {
        new_node := cur // 待插入的节点
        cur = cur.Next  // 待排序的链表头
        tmp := new_head // 在新的链表中查找位置

        for tmp != nil {
            if tmp.Next == nil {
                // tmp 循环到尾，直接添加
                tmp.Next = new_node
                new_node.Next = nil // 断开连接
                break
            }

            if new_node.Val <= tmp.Next.Val {
                // tmp 找到插入位置
                p := tmp.Next
                tmp.Next = new_node
                new_node.Next = p
                break
            }
            tmp = tmp.Next
        }
    }
    return new_head.Next
}
```

# 148. Sort List

难度: medium

单链表排序，要求时间复杂度 O(n log n)，常量空间复杂度
