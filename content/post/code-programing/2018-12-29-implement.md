+++
title = "排序算法——功能"
authors = ['潘峰']

date = 2018-12-29T16:06:00 
# lastmod = 2018-12-24T00:00:00 

draft = false
mathjax = true

tags = ["LeetCode"]
categories = ["LeetCode"]
summary = "LeetCode 刷题之旅之面试题top."
+++

链接：[leetcode](https://leetcode.com/problemset/all/)

# 7. Reverse Integer ()

难度: Easy

描述: 给定 32bit的int类型，将数字倒过来  `123` => `321`

> 注意两点
>
> 1. 负数  `-123` => `-321`
> 2. 别越界，math.Pow(2,32) = 2147483647, math.Pow(2,-32) = -2147483648

代码:

```Go
func reverse(x int) int {
    tmp := x
    var i int
    var res int
    for i = 1;;i++{
        res = res *10 + tmp%10
        if res > math.MaxInt32 || res < math.MinInt32 {
            return 0
        }
        if tmp / 10 == 0 {
            break
        }
        tmp = tmp / 10
    }
    return res
}
```

# 8. String to Integer (atoi)

难度: Medium

描述: 实现aoti

+ 要求int32的范围
+ 忽视空格
+ 如果超过范围则返回边界 `$\mathrm{INT_{MAX}} (2^{31} − 1)$` or `$\mathrm{INT_{MIN}} (−2^{31})$`
+ 如果无法识别则返回 `0`

