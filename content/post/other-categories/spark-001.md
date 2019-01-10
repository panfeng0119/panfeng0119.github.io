---
title: "Spark vs Hadoop"
date: 2018-11-23T23:06:02+08:00
lastmod: 2018-11-23T23:06:02+08:00

description: "Spark为什么比Hadoop块"
tags: ["spark"]
categories: ["other"]
author: "Pan Feng"

mathjax: false

draft: false

---

Spark使用了一种缓存机制的技术（不是提出了新的基于内存的技术）, 允许我们利用缓存技术和LRU算法缓存数据的

Spark并不支持数据持久化至内存中，而是RDD数据缓存至内存，但并没有实现持久化。

# 什么是内存计算技术？

我们说的内存计算技术是指将数据持久化至内存RAM中进行加工处理的技术。

# Spark主要快在哪？

Spark最引以为豪的就是官网介绍的经典案例

这个案例是逻辑回归机器学习算法，主要对同一份数据的反复迭代运算。Spark是内存缓存，所以数据只加载一次，Hadoop则需要反复加载

实际情况下，Spark通常比Hadoop快十倍以内是合理的。关键还是在于Spark本身快。

Spark比Hadoop快的主要原因有：

## 1.消除了冗余的HDFS读写

Hadoop每次shuffle操作后，必须写到磁盘，而Spark在shuffle后不一定落盘，可以cache到内存中，以便迭代时使用。如果操作复杂，很多的shufle操作，那么Hadoop的读写IO时间会大大增加。

## 2.消除了冗余的MapReduce阶段

Hadoop的shuffle操作一定连着完整的MapReduce操作，冗余繁琐。而Spark基于RDD提供了丰富的算子操作，且reduce操作产生shuffle数据，可以缓存在内存中。

## 3.JVM的优化

Spark Task的启动时间快。Spark采用fork线程的方式，Spark每次MapReduce操作是基于线程的，只在启动。而Hadoop采用创建新的进程的方式，启动一个Task便会启动一次JVM。

Spark的Executor是启动一次JVM，内存的Task操作是在线程池内线程复用的。

每次启动JVM的时间可能就需要几秒甚至十几秒，那么当Task多了，这个时间Hadoop不知道比Spark慢了多少。

考虑一种极端查询：

```SQL
Select month_id,sum(sales) from T group by month_id;
```

这个查询只有一次shuffle操作，此时，也许Hive HQL的运行时间也许比Spark还快。

# 结论

Spark快不是绝对的，但是绝大多数，Spark都比Hadoop计算要快。这主要得益于其对mapreduce操作的优化以及对JVM使用的优化。

所以，整体而言，Spark比Hadoop的MR程序性能要高，正常在三到四倍左右，而并不是官网所说的高几百倍。

参考：
1.https://blog.csdn.net/Stefan_xiepj/article/details/80347720
2.https://www.jianshu.com/p/6ca1421b3c47


# 参考文献

[【Spark系列】：Spark为什么比Hadoop快](https://blog.csdn.net/hxcaifly/article/details/85557594)
