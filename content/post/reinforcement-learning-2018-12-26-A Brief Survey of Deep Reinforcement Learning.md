---
title: "[深度强化学习概述]A Brief Survey of Deep Reinforcement Learning"
date: 2018-12-26T15:35:02+08:00
lastmod: 2018-12-26T15:35:02+08:00

description: ""
tags: ["reinforcement learning"]
categories: ["reinforcement learning"]
author: "Pan Feng"

mathjax: true

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

## 1.INTRODUCTION

### 1.1.什么是经验驱动的自主学习？

人工智能领域主要目标之一就是生产出完全自主的agents，这种自主包括

+ 与环境互动，从中学习最佳行为
+ 随时间的推移，通过`尝试`和`错误`来自我升级

也就是说，这是一种以经验驱动的自主学习

### 1.2.强化学习优缺点？

**强化学习（reinforcement learning, RL）**就是这种基于原则的数学框架

但是它存在以下问题：

+ 缺乏可扩展性
+ 受限于低维度的问题

原因是 RL 与其他算法共享复杂度：存储器复杂性，计算复杂性，以及在这种情况下的机器学习算法，样本复杂性（sample complexity）

### 1.3.为什么用深度学习？

近些年，深度学习提高了对象检测、语音识别和语言翻译等任务的最新技术水平

DL 最重要的特性是能够自动地找到紧凑的低维表示特征来表示高维的数据（e.g., images, text and audio）

深度学习具有强大的函数逼近（powerful function approximation ）和表示学习属性（representation learning properties ），是克服上面这些问题的实用的方法

深度学习可以加速RL的进步，在RL中使用深度学习算法定义了“深度强化学习”（DRL）领域

### 1.4.本文的目标是什么？

本文目标是整理开创性和最新的 DRL, 整理出哪种神经网络更能用于自主agents（autonomous ）

有关近期更全面的 DRL 调查，包括DRL在自然语言处理等领域的应用[106,5]，我们向读者推荐Li [78]

### 1.5.DRL 最近研究介绍

在最近DRL领域的工作中，有两个杰出的成功案例。

#### （1）开创先河的

[84]开发一种算法能够玩一系列的 Atari 2600 视频游戏，并且能在**超人（superhuman）**难度下进行。它为 RL 在函数逼近技术上不稳定问题提供了一种解决方案。首次证明了 RL agents 能仅仅通过奖励信号就可以在原始高维的观测数据上学习

#### （2）混合DRL的系统 AlphaGo

AlphaGo[128]击败人类世界冠军，与二十年前国际象棋中IBM的Deep Blue[19]以及IBM的Watson DeepQA系统（击败了最牛逼的Jeopardy！玩家）[31]的历史性成就相媲美

AlphaGo是由经过监督和强化学习训练的神经网络组成，并结合传统的启发式搜索算法

现在的机器人控制策略可以直接从现实世界的摄像机输入学习[74,75]，后续的调节器（controllers）用手工设计或从状态的低维特征中学习。

进一步的，DRL已被用于元学习（“学习如何学习”）[29,156]，使之通用到以前从未见过的复杂视觉环境[29]。在图1中，我们展示了DRL应用的一些领域，从玩视频游戏[84]到室内导航[167]。

DRL背后的驱动力之一是创建能够学习如何适应现实世界的系统。 从管理功耗[142]到挑选并放入物体[75]，DRL可以增加可以通过学习自动化的物理任务量。然而，DRL并不止于此，因为RL是通过反复试验来解决优化问题的一般方法。 从设计最先进的机器翻译模型[168]到构建新的优化功能[76]，DRL已经被用于处理各种机器学习任务。

## II. REWARD-DRIVEN BEHAVIOUR

### 2.1.RL的一般介绍

RL 的本质是通过互动进行学习，一个 RL agent 与它所在的环境进行互动。并在观察其行为序列的基础上，可以学习改变其自身的行为来所获得的奖励。这种学习 trial 和 error 的范式（paradigm）源自于行为主义心理学（behaviourist psychology），这也是 RL 的主要基础之一[135]

RL 另一个关键影响是优化控制，它提供了支撑该领域的数学形式（最值得注意的是动态编程[13]）

在RL的set-up过程中，由机器学习算法控制的自主 *agent* 从环境中观察它所处的时间 timestep *t* 下的状态 *state* `$s_{t}$`

*agent* 与环境交互方式为在 `$s_{t}$` 下执行一个 *action* `$a_{t}$`

当 *agent* 执行 `$a_{t}$` 后，环境和agent会转换到 `$s_{t+1}$` 的新状态

状态是对环境的一个充分的统计，因此它包括aget执行最佳action的所有必要信息，它可以包含部分的agent，如执行器和传感器的位置信息

在优化控制方面的文献中，状态和活动经常被表示为 $x_t$ 和 $u_t$

### 2.2.最佳行动顺序由环境提供的奖励决定

每次环境转换到新状态时，会向agent提供相应的奖励 $r_{t + 1}$ 作为反馈。而agent的目标是学习一种政策 $π$ ，使这种预期收益（累积，折现奖励）最大化。

在这方面，RL旨在解决与最优控制相同的问题。

然而，RL中的挑战是agent需要通过反复试验来了解环境中行为的后果，而优化控制的动态转换状态模型对agent不可用。 与环境的每次交互都会产生信息，代理会使用这些信息来更新其知识。 这种感知 - 动作 - 学习循环。

#### *A. Markov Decision Processes*

Formally, RL can be described as a Markov decision process (MDP), which consists of:

+ A set of states S, plus a distribution of starting states p(s 0 ).
+ A set of actions A.
+ Transition dynamics T (s t+1 |s t , a t ) that map a state- action pair at time t onto a distribution of states at time t + 1.
+ An immediate/instantaneous reward function R(s t , a t , s t+1 ).
+ A discount factor γ ∈ [0, 1], where lower values place more emphasis on immediate rewards.


