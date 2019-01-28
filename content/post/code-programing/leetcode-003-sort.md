+++
title = "LeetCode 排序问题"
authors = ['潘峰']

date = 2018-11-24T17:00:00 
# lastmod = 2018-12-24T00:00:00 

draft = false
mathjax = true

tags = ["LeetCode"]
categories = ["LeetCode"]
summary = "LeetCode 刷题之旅."
+++

链接：[leetcode](https://leetcode.com/problemset/all/)

链接：[leetcode排序题库(22)](https://leetcode.com/tag/sort/)

---

对常用的排序算法进行实现，并刷了一下leetcode中的排序题库，整理出来一些

# 排序算法——快速排序

快速排序算法的思路是每次选择一个基准点（pivot），将整个数组的所有元素分为小于这个元素和大于这个元素两部分，之后再递归地对左右两部分分别进行这个过程，直至整个数组有序。

## 普通方法

```go
// 需要指定头尾指针
func quickSort(values []int, left, right int) {
    // 基准
    pivot := values[left]
    p := left  // 基准的位置
    i, j := left, right  // 左右指针

    for i <= j {
        for j >= p && values[j] >= pivot {
            j--
        }
        if j >= p {
            values[p] = values[j]
            p = j
        }

        for values[i] <= pivot && i <= p {
            i++
        }
        if i <= p {
            values[p] = values[i]
            p = i
        }
    }
    values[p] = pivot
    if p-left > 1 {
        quickSort(values, left, p-1)
    }
    if right-p > 1 {
        quickSort(values, p+1, right)
    }
}

func QuickSort(values []int) {
    if len(values) <= 1 {
        return
    }
    quickSort(values, 0, len(values)-1)
}
```

## 简洁方法

执行并不快，迭代多

```go
func Quick2Sort(values []int) {
    if len(values) <= 1 {
        return
    }
    pivot, i := values[0], 1
    head, tail := 0, len(values)-1
    for head < tail {
        if values[i] > pivot {
            values[i], values[tail] = values[tail], values[i]
            tail--
        } else {
            values[i], values[head] = values[head], values[i]
            head++
            i++
        }
    }
    values[head] = pivot
    Quick2Sort(values[:head])
    Quick2Sort(values[head+1:])
}
```

## 随机pivot

在面临有序或者近乎有序的数组时，会退化成为一个O(n^2)的算法

于是我们使用了一个很简单的随机选取pivot的方式来处理这个问题。这步随机化让快速排序的时间期望成为了O(nlogn)，并且只有极低的概率退化为O(n^2)。关于这一点，背后的数学证明比较复杂，对背后的数学不感兴趣的同学，只要相信这个结论就好了。

## 三路快排

当序列中有大量的重复元素时，快排有可能退化成O(n^2)级别

于是衍生三路快排的思想：就是将数组分成三部分：小于v，等于v和大于v，之后递归的对小于v和大于v部分进行排序就好了。

简单言之，之前的快速排序算法将序列分成<=v和>v的两个部分（或者是<v和>=v），而三路快排将序列分成三个部分:<v、=v、>v

| | | |
|:-:|:-:|:-:|
|<v|==v|>v|

---

# 排序算法——插入排序

## 147. Insertion Sort List——单链表插入排序【难度: medium】

### 要求

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

# 排序算法——归并排序

## 148. Sort List——单链表排序（归并排序）【难度: medium】

### 要求

+ 时间复杂度 O(nlogn)，空间复杂度O(1)，选用归并排序

```go
func sortList(head *ListNode) *ListNode {
    return mergeSort(head) 
}
// 快慢指针查找终点
func getMiddle(head *ListNode) *ListNode {
    slow, fast := head, head
    for fast.Next != nil && fast.Next.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
    }
    return slow
}

// 两个链表排序
func merge(a, b *ListNode) *ListNode {
    new_head := new(ListNode)
    cur := new_head
    for a != nil && b != nil {
        if a.Val <= b.Val {
            cur.Next = a
            a = a.Next
        } else {
            cur.Next = b
            b = b.Next
        }
        cur = cur.Next
    }
    if a != nil {
        cur.Next = a
    }
    if b != nil {
        cur.Next = b
    }
    return new_head.Next
    }

    // 拆分
    func mergeSort(head *ListNode) *ListNode {
    if head == nil || head.Next == nil {
        return head
    }
    // 中间截断
    mid := getMiddle(head)
    head2 := mid.Next
    mid.Next = nil
    return merge(mergeSort(head), mergeSort(head2))
}
```

# 排序算法——桶排序

## 164. Maximum Gap 【难度： hard】

### 要求

+ 给定未排序的数组，找到其排序形式中的连续元素之间的最大差异
+ 最好在线性时间、线性空间复杂度内完成
+ 如果数组包含少于2个元素，则返回0
+ 可以假设数组中的所有元素均为非负整数，并且在32位带符号整数的范围以内

### 思路

此题目使用桶排序

1. 如果 `len(nums)<2`, 返回0
2. 计算最小值mn和最大值mx
   + 如果数字相同，`mx - mn = 0`，直接返回 0
3. 计算 `平均间隔 = (mx-mn)/n + 1`
   + n 个数有 n-1 个间隔差，因此计算式为 `(mx-mn)/(n-1)`, 为了避开0的情况，修改为 `(mx-mn)/n + 1`
4. 计算 `桶数 = (mx-mn)/平均间隔`
   + 在一个桶内的最大差值gap一定小于 `平均间隔` ，否则会被放到两个桶
   + maxgap一定大于等于 `平均间隔`（一组数的平均值要小于等于最大值）
5. 分桶（假如我们只记录桶内最大值和最小值）
6. 所以，`maxgap = buckets[cur][0] - buckets[pre][1]` 
   + 如果存在两个数a、b，最大间隔为gap，那么a和b一定会被放到两个连续的桶
   + a是t1桶的嘴后一个值（最大值），b是t2桶的第一个值（最小值）

### 代码

```go
func maximumGap(nums []int) int {
    if len(nums) < 2 {
        return 0
    }
    // 找出最大值、最小值
    var (
        mx = nums[0]
        mn = nums[0]
    )
    for _, num := range nums {
        mx = max(mx, num)
        mn = min(mn, num)
    }

    // 数字相同，直接返回
    if mx == mn {
        return 0
    }

    // 确定桶的大小 （ +1 向上取整）
    bucketField := (mx-mn)/len(nums) + 1
    // 确定桶的个数
    bucketLen := (mx-mn)/bucketField + 1

    // 创建
    buckets := make(map[int][]int)
    // 导入桶
    for _, num := range nums {
        index := (num - mn) / bucketField
        if _, ok := buckets[index]; ok {
            buckets[index] = insertSort(buckets[index], num)
        } else {
            buckets[index] = []int{num}
        }
    }

    gap := 0
    prev := 0
    // 查找最大值
    for i := 0; i < bucketLen; i ++ {
        if _, ok := buckets[i]; !ok {
            continue
        }

        gap = max(gap, buckets[i][0]-buckets[prev][len(buckets[prev])-1])
        //fmt.Println(i,buckets[i][0]-buckets[prev][len(buckets[prev])-1])
        //fmt.Println(buckets[i])
        prev = i

    }
    return gap
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
func min(a, b int) int {
    if a < b {
        return a
    }
return b
}

func insertSort(arr []int, new int) []int {
    var res []int
    for i, num := range arr {
        if new > num {
            continue
        }
        res = append(res, arr[:i]...)
        res = append(res, new)
        res = append(res, arr[i:]...)
        return res
    }
    res = append(arr, new)

    return []int{res[0], res[len(res)-1]}
}
```

# 数组有序合并

## 4. Median of Two Sorted Arrays 

难度：hard

There are two sorted arrays nums1 and nums2 of size m and n respectively.

Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)).

You may assume nums1 and nums2 cannot be both empty.

```text
// Example 1:
nums1 = [1, 3]
nums2 = [2]
// The median is 2.0

// Example 2:
nums1 = [1, 2]
nums2 = [3, 4]
// The median is (2 + 3)/2 = 2.5
```

### 思路

什么是“中位数”，找到一个数使一个数组分为两个部分，left 和 right，

> 1. $len(left)=len(right)$
> 2. $\max(\text{left}) \leq \min(\text{right}))$

不要想太多，将两个数组合并然后找中位数就可以

### 代码

```Go
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

```结果
32 ms, faster than 33.90%
```