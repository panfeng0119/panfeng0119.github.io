---
title: "每天进步一点点——一致性哈希散列"

date: 2019-01-08T14:11:34+08:00
lastmod: 2019-01-08T14:11:34+08:00
draft: false
keywords: []
description: ""
tags: []
categories: ["algorithm"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: false
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
---

[原文链接](https://blog.csdn.net/cywosp/article/details/23397179)
[携程reids容器化](https://infoq.cn/article/cS_Pp9r8Gjd9bpGpjTTv)

# 背景

携程大部分应用是基于 CRedis 客户端通过集群来访问到实际的 Redis 的实例，集群是访问 Redis 的基本单位，多个集群对应一个 Pool，一个 Pool 对应一个 Group，每个 Group 对应一个或多个实例，Key 是通过一致性 hash 散列到每个 Group 上，集群拓扑图如截图所示。