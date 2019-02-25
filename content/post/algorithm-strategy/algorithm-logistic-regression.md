---
title: "每天进步一点点——逻辑回归"
date: 2019-01-08T11:09:53+08:00
lastmod: 2019-01-08T11:09:53+08:00
draft: false
keywords: []
description: ""
tags: ["Logistic Regression","machine learning"]
categories: ["algorithm"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: true
---

# 介绍

**逻辑回归假设数据服从伯努利分布, 通过极大化似然函数的方法, 运用梯度下降来求解参数,来达到将数据二分类的目的**

# 知识点

+ 1.逻辑回归的基本假设
+ 2.逻辑回归的损失函数
+ 3.逻辑回归的求解方法
+ 4.逻辑回归的目的
+ 5.逻辑回归如何分类

## 1.逻辑回归的基本假设

1)假设数据服从伯努利分布

$$p=h_\theta(x;\theta)$$

2)假设样本为正的概率

$$p=\dfrac{1}{1+e^{-\theta^Tx}}$$

### 什么是伯努利分布？

假如我们现在抛硬币，抛中为正面的概率是 $p$ , 抛中为负面的概率是 $1−p$，这个模型在逻辑回归中的假设就是

+ 样本为正的概率 `$h_\theta(x)$`
+ 样本为负的概率 `$1- h_\theta(x)$`

## 2.逻辑回归的损失函数

逻辑回归的损失函数是它的极大似然函数

<div>$$L_\theta(x)={\prod_{i=1}^m}h_\theta(x^i;\theta)^{yi}*(1- h_\theta(x^i;\theta))^{1-y^i}$$</div>

## 3.求解方法

无法直接求解，利用梯度下降来不断逼近最优解

梯度下降有哪些方式？

+ **随机梯度下降**。 优点:全局最优解；缺点:更新每个参数的时候需要遍历所有的数据，计算量大，冗余计算多，不适用大数据量
+ **批梯度下降**。优点:高方差频繁更新，容易获得局部最优解;缺点:收敛到局部最优解的过程复杂
+ **小批量梯度下降**。 优点:结合sgd和batch gd的优点，每次使用n个样本更新。减少了参数更新次数，达到更稳定的收敛结果

细节——学习率的选择？

+ 模型的学习率
+ 参数的学习率

我们知道模型刚开始可能离最优解比较远，为了快速逼近，会选择大一些的学习率来使模型更新的间隔大一些，而训练到接近最优解的时候如果还用大学习率的话容易使模型在最优解两次来回震荡，这个时候需要用小的学习率来逼近。

参数更新的时候，有的参数更新频繁，那么学习率适当小一些，有的参数更新缓慢，那么学习率就应该大一些

## 4.逻辑回归的目的

二分类，提高准确率

## 5.逻辑回归如何分类

逻辑回归作为一个回归(也就是y值是连续的)，如何应用到分类上去呢。y值确实是一个连续的变量。逻辑回归的做法是划定一个阈值，y值大于这个阈值的是一类，y值小于这个阈值的是另外一类。阈值具体如何调整根据实际情况选择。一般会选择0.5做为阈值来划分。

# 逻辑回归的优缺点总结

逻辑回归应用到工业界当中一些优点：

+ 形式简单，模型的可解释性非常好。从特征的权重可以看到不同的特征对最后结果的影响，某个特征的权重值比较高，那么这个特征最后对结果的影响会比较大。
+ 模型效果不错。在工程上是可以接受的（作为baseline)，如果特征工程做的好，效果不会太差，并且特征工程可以大家并行开发，大大加快开发的速度。

+ 训练速度较快。分类的时候，计算量仅仅只和特征的数目相关。并且逻辑回归的分布式优化sgd发展比较成熟，训练的速度可以通过堆机器进一步提高，这样我们可以在短时间内迭代好几个版本的模型。

+ 资源占用小,尤其是内存。因为只需要存储各个维度的特征值。

+ 方便输出结果调整。逻辑回归可以很方便的得到最后的分类结果，因为输出的是每个样本的概率分数，我们可以很容易的对这些概率分数进行cutoff，也就是划分阈值(大于某个阈值的是一类，小于某个阈值的是一类)。

缺点:

+ 准确率并不是很高。因为形式非常的简单(非常类似线性模型)，很难去拟合数据的真实分布。

+ 很难处理数据不平衡的问题。举个例子：如果我们对于一个正负样本非常不平衡的问题比如正负样本比 10000:1.我们把所有样本都预测为正也能使损失函数的值比较小。但是作为一个分类器，它对正负样本的区分能力不会很好。

+ 处理非线性数据较麻烦。逻辑回归在不引入其他方法的情况下，只能处理线性可分的数据，或者进一步说，处理二分类的问题 。
+ 逻辑回归本身无法筛选特征。有时候，我们会用gbdt来筛选特征，然后再上逻辑回归。

# 进一步思考

## 逻辑回归的损失函数为什么要使用极大似然函数作为损失函数？

## 逻辑回归在训练的过程当中，如果有很多的特征高度相关或者说有一个特征重复了100遍，会造成怎样的影响？

## 为什么我们还是会在训练的过程当中将高度相关的特征去掉？


# 参考文献

+ [逻辑回归的常见面试点总结](https://www.cnblogs.com/ModifyRong/p/7739955.html)