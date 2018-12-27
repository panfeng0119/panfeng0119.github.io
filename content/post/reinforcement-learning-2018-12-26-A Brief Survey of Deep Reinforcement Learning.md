---
title: "[深度强化学习概述]A Brief Survey of Deep Reinforcement Learning"
date: 2018-12-26T15:35:02+08:00
lastmod: 2018-12-26T15:35:02+08:00

description: ""
tags: ["reinforcement learning"]
categories: ["reinforcement learning"]
author: "Pan Feng"

mathjax: false

draft: false

---


# [深度强化学习概述] A Brief Survey of Deep Reinforcement Learning

原文参考: arXiv:1708.05866v2 [cs.LG] 28 Sep 2017

## 摘要

本文主要内容有：

1. 研究深度强化学习的核心算法

    + deep Q-network (深度Q网络)
    + trust region policy optimisation (置信区间策略优化)
    + asynchronous advantage actor-critic (异步优势 actor-critic算法)

2. 介绍深度神经网络的优势，主要关注通过强化学习来进行视觉理解

3. 介绍一些当前几个领域内的研究

## INTRODUCTION

人工智能领域主要目标之一就是生产出完全自主的agents，这种自主包括

+ 与环境互动，从中学习最佳行为
+ 随时间的推移，通过`尝试`和`错误`来自我升级

也就是说，这是一种以经验驱动的自主学习


**强化学习（reinforcement learning, RL）**就是这种基于原则的数学框架

但是它存在以下问题：

+ 缺乏可扩展性
+ 受限于低维度的问题

原因是 RL 与其他算法共享复杂度：存储器复杂性，计算复杂性，以及在这种情况下的机器学习算法，样本复杂性（sample complexity）

DL 最重要的特性是能够自动地找到紧凑的低维表示特征来表示高维的数据（e.g., images, text and audio）。近些年 DL 的兴起，也是因为函数逼近（powerful function approximation ）和表示学习属性（representation learning properties ）的开始强大起来

Deep learning has similarly accelerated progress in RL, with the use of deep learning algorithms within RL defining the field of “deep reinforcement learning” (DRL).

本文目标是整理开创性和最新的 DRL , 整理出哪种神经网络更能用于自主agents（autonomous ）

有关近期更全面的 DRL 调查，包括DRL在自然语言处理等领域的应用[106,5]，我们向读者推荐Li [78]

### 开创先河的

[84]开发一种算法能够玩一系列的 Atari 2600 视频游戏，并且在 superhuman 难度下进行。它为 RL 在函数逼近技术上不稳定问题提供了一种解决方案。这项工作首次证明了 RL agents 能够仅仅通过奖励信号就可以在原始高维的观测数据上学习


