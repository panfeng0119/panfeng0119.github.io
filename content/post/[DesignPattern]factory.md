+++
title = "设计模式：工厂模式（Factory Pattern）"

date = 2018-09-26T00:00:00
lastmod = 2018-09-26T00:00:00
draft = false

authors = ['潘峰']

tags = ["design pattern"，"go"]
summary = "Go语言设计模式"
+++

工厂模式（Factory Pattern）

### 类型

创建型模式</br>
提供了一种创建对象的最佳方式

意图：定义一个接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

主要解决：主要解决接口选择的问题。

何时使用：我们明确地计划不同条件下创建不同实例时。

如何解决：让其子类实现工厂接口，返回的也是一个抽象的产品。

关键代码：创建过程在其子类执行。

应用实例： 1、您需要一辆汽车，可以直接从工厂里面提货，而不用去管这辆汽车是怎么做出来的，以及这个汽车里面的具体实现。 2、Hibernate 换数据库只需换方言和驱动就可以。



1\. 我们需要一个接口

```
type Shape interface {
	Draw()
}
```

2\. 这个接口下的实例

```
// 实例1
type Rectangle struct {
}

func (this Rectangle) Draw() {
	fmt.Println("Inside Rectangle::draw() method.")
}

// 实例2
type Square struct {
}

func (this Square) Draw() {
	fmt.Println("Inside Square ::draw() method.")
}

// 实例3
type Circle struct {
}

func (this Circle) Draw() {
	fmt.Println("Inside Circle  ::draw() method.")
}
```

3\. 创建一个工厂

```
type ShapeFactory struct {
}

//使用 getShape 方法获取形状类型的对象
func (this ShapeFactory) getShape(shapeType string) Shape {

	if shapeType == "" {
		return nil
	}
	if shapeType == "CIRCLE" {
		return Circle{}
	} else if shapeType == "RECTANGLE" {
		return Rectangle{}
	} else if shapeType == "SQUARE" {
		return Square{}
	}
	return nil
}
```

4\. 使用这个工厂

```
func main() {
	factory := ShapeFactory{}
	factory.getShape("CIRCLE").Draw()
	factory.getShape("RECTANGLE").Draw()
	factory.getShape("SQUARE").Draw()
}
```

结果

```
Inside Circle  ::draw() method.
Inside Rectangle::draw() method.
Inside Square ::draw() method.
```
