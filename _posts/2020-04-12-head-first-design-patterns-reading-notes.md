---
layout: post
title: 《Head First Design Patterns》阅读笔记
date: 2020-04-12 13:15:00 +08:00
categories: coding
tags: coding
---

<!-- 抑制 markdownlint 对没有大标题的警告 -->
<!-- markdownlint-disable MD002 -->
<!-- markdownlint-disable MD041 -->

自己一个人磕盐写项目，写着写着感觉自己代码架构混乱不忍直视。
想起来自己在读CS的时候同学推荐过《Head First设计模式》这本书。
于是从图书馆借来读，收获颇丰。这里记录了读书时的一些笔记。

设计模式领域有两本非常有名的书：
* Head First Design Patterns  Eric Freeman, Elisabeth Freeman, Kathy Sierra, Bert Bates
* Design Patterns Eric Gamma, Richard Helm, Ralph Johnson, JHohn Vlissides

我现在只读了第一本，之后便尝试将自己所学应用到代码中去，有机会我会读第二本。


## OO Basics - 基础

* 抽象 Abstraction
* 封装 Encapsulation
* 多态 Polymorphism
* 继承 Inheritance



## OO Principles - 原则
```
* 封装变化                                 Encapsulate what varies.
* 多用组合，少用继承                       Favor composition over inheritence.
* 针对接口编程，不针对实现编程             Program to interfaces, not to implementations.
* 为交互对象之间的松耦合设计而努力         Strive for loosely coupled designs between objects that interact
* 类应该对扩展开放，对修改关闭             Classes should be open for extension but closed for modification.
* 依赖抽象，不要依赖具体类                 Depend on abstractions. Do not depend on concrete classes.
* 只和朋友交谈                             Only talk to your friends.
* 超类主控一切，需要的时候自然会调用子类   Don't call us, we call you.
* 类只能有一个改变的理由(利用代理控制访问) A class should have only one resason to change.
```

## OO Patterns - 模式

| Patterns        | Description                   |
| --------------- | :---------------------------- |
| 策略模式        | Strategy - defines a family of algorithms, encapsulates each one, and makes them interchangeable, Stragy lets the algorithm vary independently from clients that use it.     |
| 观察者模式      |  Observer - defines a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically   |
| 装饰者模式      | Decorator - Attach additional responsibilities to an object dynamically. Decorators porvide a flexible alternative to subclassing for extending functionality.  |
| 工厂模式        | Abstract Factory - Provide an interface for creating families of related or depedent objects without specifying their concrete classes.     <br> Factory Method - Define an interface for creating an object, but let subclass decide which class to instantiate. Factory Method lets a class defer instantiation to the subclass.       |
| 单件模式        | Singleton - Ensure a class only has one instance and provide a global point of access to it.                                                |
| 命令模式        | Command - Encapsulates a request as an object, thereby letting you parameterize clients with different request, queue or log requests, and support undoable operations.        |
| 适配器模式 <br> 外观模式   | Adapter - Converts the interface of a class into another interface clients expect. Let classes work together that couldn't othervise because of incompatible interfaces.   <br> Facade - Provides a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes the subsystem easier to use.     |
| 模版方法模式    | Template Method - Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing the algorithm's structure.  |
| 迭代器与组合模式 | Iterator - Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.   <br> Composite - Compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual ovjects and compositions of objects uniformly           |
| 状态模式        | State -Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.             |
| 代理模式        | Proxy - Provide a surrogate or placeholder for another object to control access to it.                                                |
| 复合模式        | Compoud Patterns - A Compound Pattern combines two or more patterns into a solution that solves a recurring or general problem.       |

## 杂记

delegation（委派）的几种类型归纳:
    * Use (A use B)
    * Composition/aggregation (A owns B)
    * Association (A has B)

下图是一个书中的例子：

![example](/assets/2020-04/hfdp-page22.png)

