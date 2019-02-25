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
func qsort(arr []int, left, right int) {
    if left >= right {
        return
    }
    // 提取基准pivot, p为快排过程中空位，初始化为基准的位置
    p := left
    pivot := arr[p]
    i, j := left, right
    // 每一次调用qsort相当于把基准放到适当的位置上，使左边的值小于pivot、右边的值都大于pivot
    for i <= j {
        // 从右开始
        for p <= j && arr[j] >= pivot {
            j--
        }
        if j > p {
            arr[p] = arr[j] // 把位置j的值移动到位置p上
            p = j           // j这个位置就没用了
        }
        for p >= i && arr[i] <= pivot {
            i++
        }
        if i < p {
            arr[p] = arr[i]
            p = i
        }
    }

    arr[p] = pivot        // 放回基准
    qsort(arr, left, p-1) // p 已经找到指定位置，无需再计算
    qsort(arr, p+1, right)
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

于是我们使用了一个很简单的随机选取pivot的方式来处理这个问题。

```Go
    // 提取基准pivot, p为快排过程中空位，初始化为基准的位置
    p := left + rand.Intn(right-left+1)
    pivot := arr[p]
```

这步随机化让快速排序的时间期望成为了O(nlogn)，并且只有极低的概率退化为O(n^2)。关于这一点，背后的数学证明比较复杂，对背后的数学不感兴趣的同学，只要相信这个结论就好了。（不过随机数生成器也带有性能消耗。当数组存在大量的随机元素时，就是很长的无规则数组，需要执行多次）

现在，最大的开销还是随机数产生器选择pivot带来的开销，我们用随机数产生器来选择pivot，是希望pivot能尽量将数组划分得均匀一些，可以选择一个替代方案来替代随机数产生器来选择pivot，比如三数取中，通过对序列的first、middle和last做比较，选择三个数的中间大小的那一个做pivot，从概率上可以将比较次数下降到12/7 ln(n)

median-of-three对小数组来说有很大的概率选择到一个比较好的pivot，但是对于大数组来说就不足以保证能够选择出一个好的pivot，因此还有个办法是所谓median-of-nine

这个怎么做呢？它是先从数组中分三次取样，每次取三个数，三个样品各取出中数，然后从这三个中数当中再取出一个中数作为pivot，也就是median-of-medians。取样也不是乱来，分别是在左端点、中点和右端点取样。

什么时候采用median-of-nine去选择pivot，这里也有个数组大小的阀值，这个值也完全是经验值，设定在40，大小大于40的数组使用median-of-nine选择pivot，大小在7到40之间的数组使用median-of-three选择中数，大小等于7的数组直接选择中数，大小小于7的数组则直接使用插入排序

## 三路快排(*)

`*` 表示特殊情况

当序列中有大量的重复元素时，也退化成O(n^2)

于是衍生三路快排的思想：就是将数组分成三部分：小于v，等于v和大于v，之后递归的对小于v和大于v部分进行排序就好了。

简单言之，之前的快速排序算法将序列分成<=v和>v的两个部分（或者是<v和>=v），而三路快排将序列分成三个部分:<v、=v、>v

| | | |
|:-:|:-:|:-:|
|<v|==v|>v|

## 重复数组优化

那么对于大量重复数组，对比pivot会产生消耗

更进一步的优化是在划分算法上，使用两个索引i和j，分别从左右两端进行扫描，i扫描到大于等于pivot的元素就停止，j扫描到小于等于pivot的元素也停止，交换两个元素，持续这个过程直到两个索引相遇，此时的pivot的位置就落在了j，然后交换pivot和j的位置

```Go
// 待验证
func qs2(arr []int) {
    if len(arr) < 2 {
        return
    }
    qSort(arr, 0, len(arr)-1)
}

func qSort(arr []int, left, right int) {
    if left >= right {
        return
    }
    // 随机基准
    p := left + rand.Intn(right-left+1)
    arr[p], arr[left] = arr[left], arr[p]

    //fmt.Println(p, arr[p], arr[left])
    //fmt.Println(arr)
    pivot := arr[left] // 把这个位置上的基准提取出来
    i, j := left, right
    // 每一次调用相当于 把当前基准放到适当的位置上
    for i <= j {
        //fmt.Println("i,j:", i, j)
        for i <= j && arr[j] > pivot { // 大的都在右边
            //fmt.Println(j)
            j--
        }

        for i <= j && arr[i] <= pivot { // 小的都在左边
            //fmt.Println(i)
            i++
        }
        // 交换
        arr[i], arr[j] = arr[j], arr[i]
    }
    arr[j] = pivot        // 放回基准
    qSort(arr, left, p-1) // p 已经找到指定位置，无需再计算
    qSort(arr, p+1, right)
}
```

## 按经验优化

思路：插入排序在大致排序好的数组上面，最佳情况是O(n)

* 先用快排，数组小于阈值（7？）的时候直接用插入排序
* 小于阈值不做操作，快排结束后对整个数组进行插入排序（与上面本质上相同）

---

# 排序算法——堆排序

堆排序是利用堆这种数据结构而设计的一种排序算法，堆排序是一种选择排序，它的最坏，最好，平均时间复杂度均为O(nlogn)，它也是不稳定排序。首先简单了解下堆结构。

堆是完全二叉树，分为大顶堆和小顶堆。

* 大顶堆：每个结点的值都大于或等于其左右孩子结点的值；
* 小顶堆：每个结点的值都小于或等于其左右孩子结点的值；

用公式描述就是

* 大顶堆：arr[i] >= arr[2i+1] && arr[i] >= arr[2i+2]  
* 小顶堆：arr[i] <= arr[2i+1] && arr[i] <= arr[2i+2]

```go
func HeapSort(arr []int) {
    // 1. 初始化: 构建（初始状态不一定是大（小）顶堆，）
    for i := len(arr)/2 - 1; i >= 0; i-- {
        //从第一个非叶子结点从下至上，从右至左调整结构
        adjustHeap(arr, i, len(arr))
    }
    // 2. 调整堆顶并重新构建
    for j := len(arr) - 1; j >= 0; j-- {
        // 交换
        arr[0], arr[j] = arr[j], arr[0]
        // 调整
        adjustHeap(arr, 0, j)
    }

}

// 调整结构
// @param a 需要调整的数组左边界
// @param b 需要调整的数组右边界
func adjustHeap(arr []int, a, b int) {
    tmp := arr[a]
    // 从i的左孩子节点开始遍历，每次比较节点和左右孩子的大小
    for k := a*2 + 1; k < b; k = k*2 + 1 {
        // 左右孩子比较，如果右孩子大，则转向右孩子
        if k+1 < b && arr[k] < arr[k+1] {
            k++
        }
        if arr[k] > tmp {
            arr[a] = arr[k]
            a = k
        } else {
            break
        }
    }
    arr[a] = tmp
}

```

# 排序算法——插入排序

## 147. Insertion Sort List——单链表插入排序【难度: medium】

### 要求

* 第一个节点直接插入
* 已排序的部分和待排序的部分分开
* 当前元素的操作

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