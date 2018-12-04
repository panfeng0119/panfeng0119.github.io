+++
title = "Hugo 02 | Hugo 模板介绍"

date = 2018-09-28T23:59:00 

draft = false

authors = ['潘峰']

tags = ["Hugo"]
summary = ""
+++

Hugo 使用Go的 html/template 和 text/template. 详情请看[Go docs](http://golang.org/pkg/html/template/).

---


## **基本语法 Basic Syntax**

模板主要由 `variables` 和 `functions`组成，在 `{{ }}` 内中使用

访问变量

```
// 可以是当前作用域中已存在的变量
{{ .Title }}

// 或者自定义变量
{{ $address }}
```

函数参数用空格分割
```
{{ FUNCTION ARG1 ARG2 .. }}

// 例如
{{ add 1 2 }}
```
方法调用
```
// 方法和字段用"."来访问
{{ .Params.bar }}
```
用括号组织
```
{{ if or (isset .Params "alt") (isset .Params "caption") }} Caption {{ end }}
```

## **变量**

每个Go Template都会获取一个data对象。而在Hugo中，每个Template都传递一个Page

`.Title` 就是 [`Page`](https://gohugo.io/variables/page/) 变量中可访问的元素之一，通过 "." 访问：

```
<title>{{ .Title }}</title>
```

变量赋值

```
{{ $address := "123 Main St." }}
{{ $address }}
```

*下面的示例仅适用于 Hugov0.48 或更新的版本*

在主页上打印“Var is Hugo Home”，在所有其他页面上打印“Var is Hugo Page”：

```
{{ $var := "Hugo Page" }}
{{ if .IsHome }}
    {{ $var = "Hugo Home" }}
{{ end }}
Var is {{ $var }}
```

## **函数**

Hugo Template 的[自带函数](https://gohugo.io/functions/)

新的函数需要编译后才能使用


Example 1: Adding Numbers 
```
{{ add 1 2 }}
<!-- prints 3 -->
```
Example 2: Comparing Numbers 
```
{{ lt 1 2 }}
<!-- prints true (i.e., since 1 is less than 2) -->
```

这两个示例都使用了 [math functions](https://gohugo.io/functions/math/)

## **Includes**
模板的位置从 `layouts/` 目录开始

## **Partial 函数**

用来调用 partial templates

```
// 使用方法
{{ partial "<PATH>/<PARTIAL>.<EXTENSION>" . }}

// 例如:  调用 layouts/partials/header.html partial
{{ partial "header.html" . }}
```

## **Template 函数**
仅用于调用 [internal templates](https://gohugo.io/templates/internal/)

可用模板在[这里](https://github.com/gohugoio/hugo/tree/master/tpl/tplimpl/embedded/templates)找

```
// 语法为
{{template“_internal / <TEMPLATE>.<EXTENSION>”. }}

// 例如： 调用 internal opengraph.html template:
{{ template "_internal/opengraph.html" . }}
```

## **逻辑**

```
// Example 1: Using Context (.) 
{{ range $array }}
    {{ . }} <!--  . 表示 $array 中的一个元素 -->
{{ end }}

// Example 2: 给元素声明一个变量名
{{ range $elem_val := $array }}
    {{ $elem_val }}
{{ end }}

// Example 3: array 和 slice 的索引和变量
{{ range $elem_index, $elem_val := $array }}
   {{ $elem_index }} -- {{ $elem_val }}
{{ end }}
// Example 4: map 的 key 和 value
{{ range $elem_key, $elem_val := $map }}
   {{ $elem_key }} -- {{ $elem_val }}
{{ end }}
```

## **条件语句**

每个语句用 `{{ end }}` 结束

作为 false 的值可以是：

* false (boolean)
* 0 (integer)
* 任何 zero-length array, slice, map, 或者 string

```
// Example 1: with 
// 如果变量不存在，或判定为 false 则跳过
{{ with .Params.title }}
    <h4>{{ . }}</h4>
{{ end }}

// Example 2: with .. else

```

未完待续
## **管道**
## **Context (aka “the dot”)**
## **Whitespace**
## **Comments**
## **Hugo Parameters**
**https://gohugo.io/templates/introduction/#basic-syntax**



