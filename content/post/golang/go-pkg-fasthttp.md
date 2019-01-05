---
title: "Go 服务包 fasthttp"
date: 2019-01-04T09:35:02+08:00
lastmod: 2019-01-04T09:35:02+08:00

description: ""
tags: ["go"]
categories: ["go"]
author: "Pan Feng"

mathjax: false

draft: false

---

fasthttp 是 Go 的一款不同于标准库 net/http 的 HTTP 实现。fasthttp 的性能可以达到标准库的 10 倍，说明他魔性的实现方式。主要的点在于四个方面：

+ net/http 的实现是一个连接新建一个 goroutine；fasthttp 是利用一个 worker 复用 goroutine，减轻 runtime 调度 goroutine 的压力
+ net/http 解析的请求数据很多放在 map[string]string(http.Header) 或 map[string][]string(http.Request.Form)，有不必要的 []byte 到 string 的转换，是可以规避的
+ net/http 解析 HTTP 请求每次生成新的 *http.Request 和 http.ResponseWriter; fasthttp 解析 HTTP 数据到 *fasthttp.RequestCtx，然后使用 sync.Pool 复用结构实例，减少对象的数量
+ fasthttp 会延迟解析 HTTP 请求中的数据，尤其是 Body 部分。这样节省了很多不直接操作 Body 的情况的消耗

但是因为 fasthttp 的实现与标准库差距较大，所以 API 的设计完全不同。使用时既需要理解 HTTP 的处理过程，又需要注意和标准库的差别。

[原文地址](https://zhuanlan.zhihu.com/p/52644362)

go虽然在后台开发上没什么问题，但是要和AI联系起来就有点麻烦了，首先go没有pmml这方面的解析库，其次如果将python模型转pmml也有性能损失啊，肯定没有原生语言好。

之所以用go是因为，go比java简单，比python要快，网络并发稍微调优一下性能杠杠的，综合来说是个不错的选择。

这里贴个demo，记录下怎么用fasthttp创建web服务器，包括：

+ web服务器创建
+ 路由
+ 请求参数获取

基本上实现上面的功能后，就可以基于此做更多的web服务器操作了，毕竟拿到了请求的参数，知道client想干什么，剩下的就是把事情做完把结果返回就好了。说来也有趣，fasthttp的返回不是用return的方式将字符串返回，而是用fmt.Fprint(ctx, string_data)的形式将返回的数据输出到ctx管道。

```go
package main

import (
    "fmt"
    "github.com/buaazp/fasthttprouter"
    "github.com/valyala/fasthttp"
    "log"
)

// index 页
func Index(ctx *fasthttp.RequestCtx) {
    fmt.Fprint(ctx, "Welcome")
}

// 简单路由页
func Hello(ctx *fasthttp.RequestCtx) {
    fmt.Fprintf(ctx, "hello")
}

// 获取GET请求json数据
// 使用 ctx.QueryArgs() 方法
// Peek类似与python中dict的pop方法，取某个键对应的值
func TestGet(ctx *fasthttp.RequestCtx) {
    values := ctx.QueryArgs()
    fmt.Fprint(ctx, string(values.Peek("abc"))) // 不加string返回的byte数组

}

// 获取post的请求json数据
// 这里就有点坑是，查了很多网页说可以用 ctx.PostArgs() 取post的参数，返现不行，返回空
// 后来用 ctx.FormValue() 取表单数据就好了，难道是版本升级的问题？
// ctx.PostBody() 在上传文件的时候比较有用
func TestPost(ctx *fasthttp.RequestCtx) {
    //postValues := ctx.PostArgs()
    //fmt.Fprint(ctx, string(postValues))

    // 获取表单数据
    fmt.Fprint(ctx, string(ctx.FormValue("abc")))

    // 这两行可以获取PostBody数据，在上传数据文件的时候有用
    postBody := ctx.PostBody()
    fmt.Fprint(ctx, string(postBody))
}

func main() {

    // 创建路由
    router := fasthttprouter.New()

    // 不同的路由执行不同的处理函数
    router.GET("/", Index)

    router.GET("/hello", Hello)

    router.GET("/get", TestGet)

    // post方法
    router.POST("/post", TestPost)

    // 启动web服务器，监听 0.0.0.0:12345
    log.Fatal(fasthttp.ListenAndServe(":12345", router.Handler))
}
```

如果要实现模型服务呢，怎么做？可以用goscore，在python中将模型导出为pmml，然后用goscore读取并提供服务，也挺简单的。

但是对于很多自定义模型结构，pmml就不适用了，真是让人头大，难道要用scala写模型，用java提供服务？

原文参考

+ [fasthttp手册文档-中文版](http://link.zhihu.com/?target=https%3A//github.com/DavidCai1993/my-blog/issues/35)
+ [高性能web之fasthttp](http://link.zhihu.com/?target=https%3A//blog.yumaojun.net/2017/01/25/fasthttp/)
+ [Go开发HTTP的另一个选择 fasthttp](http://link.zhihu.com/?target=http%3A//fuxiaohei.me/2016/9/24/go-and-fasthttp-server.html)
+ [goscore](http://link.zhihu.com/?target=https%3A//github.com/asafschers/goscore)