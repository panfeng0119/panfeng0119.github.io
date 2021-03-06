+++
title = "Hugo 02 | Hugo 模板介绍"

date = 2018-09-28T23:59:00 

authors = ['潘峰']

tags = ["hugo"]
categories = ["hugo"]

summary = ""

draft = false
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

可以用到的关键字：`if`, `else`, `with`, `or`, `and`, `range`

作为 false 的值可以是：

* false (boolean)
* 0 (integer)
* 任何 zero-length array, slice, map, 或者 string

### Example 1: with

功能：如果变量存在，则...

```
// 如果变量不存在，或判定为 false 则跳过
{{ with .Params.title }}
    <h4>{{ . }}</h4>
{{ end }}
```
### Example 2: with .. else
如果设置了参数 `“description”` 的值，执行`.`命令

否则使用`.Summary`的变量值
```
{{ with .Param "description" }}
    {{ . }}
{{ else }}
    {{ .Summary }}
{{ end }}
```
### Example 3: if 

一种更长（冗余）的写法是用if，下面给出Example1重写的代码
```
{{ if isset .Params "title" }}
    <h4>{{ index .Params "title" }}</h4>
{{ end }}
```
### Example 4: if .. else 

Below example is “Example 2” rewritten using if .. else, and using isset function + .Params variable (different from the .Param function) instead:
```
{{ if (isset .Params "description") }}
    {{ index .Params "description" }}
{{ else }}
    {{ .Summary }}
{{ end }}
```

Example 5: if .. else if .. else
Unlike with, if can contain else if clauses too.
```
{{ if (isset .Params "description") }}
    {{ index .Params "description" }}
{{ else if (isset .Params "summary") }}
    {{ index .Params "summary" }}
{{ else }}
    {{ .Summary }}
{{ end }}
```

### Example 6: and & or 
```
{{ if (and (or (isset .Params "title") (isset .Params "caption")) (isset .Params "attr")) }}

```


未完待续
## **管道符号（Pipes）**

概念：每个管道（pipe）的输出都成为后续管道的输入

限制：只能使用一个值作为传递参数

### Example 1: shuffle 
```
//两条语句功能一样
{{ shuffle (seq 1 5) }}
{{ (seq 1 5) | shuffle }}
```
### Example 2: index 
以下访问名为“disqus_url”的页面参数并转义HTML。此示例还使用index函数，(内置在 Go Templates中)：
```
{{ index .Params "disqus_url" | html }}
```

### Example 3: or with isset 
```
{{ if or (or (isset .Params "title") (isset .Params "caption")) (isset .Params "attr") }}
Stuff Here
{{ end }}
```
改写为
```
{{ if isset .Params "caption" | or isset .Params "title" | or isset .Params "attr" }}
Stuff Here
{{ end }}
```

### Example 4: Internet Explorer Conditional Comments 

Go Templates 默认会删除HTML注释

这有不幸的副作用是删除Internet Explorer条件注释。作为解决办法：
```
{{ "<!--[if lt IE 9]>" | safeHTML }}
  <script src="html5shiv.js"></script>
{{ "<![endif]-->" | safeHTML }}

```
或者使用反勾号（`）来引用IE条件注释，避免转义内部每个双引号（"）的繁琐任务
```
{{ `<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->` | safeHTML }}
```
---
## **Context (aka “the dot”)**

在最顶层，这是可用的数据集合
在迭代循环内，它具有当前值（.在循环内不会引用整个页面的数据）
如果需要访问页面数据，有以下方法

### 1.定义一个变量
下面展示了如何定义变量
```
//tags-range-with-page-variable.html

{{ $title := .Site.Title }}
<ul>
{{ range .Params.tags }}
    <li>
        <a href="/tags/{{ . | urlize }}">{{ . }}</a>
        - {{ $title }}
    </li>
{{ end }}
</ul>
```
注意: 一旦我们进入循环（如 range），值{{.}}已更改。
由于已经在循环外部定义了一个变量（{{$title}}），并分配了一个值，因此我们也可以从循环内部访问该值。

### 2.使用全局变量参数 $. 
$.可以从任何地方访问全局上下文。

使用$从全局上下文中获取.Site.Title：

```
//range-through-tags-w-global.html

<ul>
{{ range .Params.tags }}
  <li>
    <a href="/tags/{{ . | urlize }}">{{ . }}</a>
            - {{ $.Site.Title }}
  </li>
{{ end }}
</ul>
```
如果重定义`$`, `{{$：=.Site}}`, 那么内置的`$`将停止工作。您可以通过使用`{{$: =.}}` 来将`$`重置为其默认值。

## **空白（Whitespace）**

使用连字符（hyphen, "-"）可以去掉空白（类似 trim），如`{{- XXXX -}}`

可以去掉的有：
- 空格 （space）
- 当前行的Tab（horizontal tab）
- 回车（carriage return）
- 换行符 （newline）

```
<div>
  {{ .Title }}
</div>
<div>
  {{- .Title -}}
</div>
```
输出:
```
<div>
  Hello, World!
</div>
<div>Hello, World!</div>
```



## **注释（Comments）**

### Go Templates 的注释
注释块用 `{{/*` 和 `*/}}` 

### HTML 注释
注释用 `<!--xxx -->`
如果需要构造 html 注释块，可以用管道符导入到safeHTML

```
{{ printf "<!-- Our website is named: %s -->" .Site.Title | safeHTML }}
```

### 包含Go模板的HTML注释
不要用 HTML 注释来注释 GO 模板
引擎默认先编译 Go 模板代码，如果HTML注释中代码出错，编译就会失败。

```
<!-- {{ $author := "Emma Goldman" }} was a great woman. -->
{{ $author }}
```

## **Hugo Parameters**

网页范围的参数配置，通过特定的内容片断来指定一些特定的渲染（如当前网站不需要用到的）传递到模板中


You can define any values of any type and use them however you want in your templates, as long as the values are supported by the front matter format specified via metaDataFormat in your configuration file.



您可以定义任何类型的值，并在模板中根据需要使用它们，只要这些值由配置文件中通过metaDataFormat指定的前置事项格式支持。

### 使用Content (Page) 参数 

全局都使用变量 notoc ，但有时我们不需要内容表。此时，我们在文件头设置为true，它将阻止内容表呈现。

Here is the example front matter (YAML):
```
---
title: Roadmap
lastmod: 2017-03-05
date: 2013-11-18
notoc: true
---
```
对应的模板中要加上处理的代码
```
//layouts/partials/toc.html

{{ if not .Params.notoc }}
<aside>
  <header>
    <a href="#{{.Title | urlize}}">
    <h3>{{.Title}}</h3>
    </a>
  </header>
  {{.TableOfContents}}
</aside>
<a href="#" id="toc-toggle"></a>
{{ end }}

```
We want the default behavior to be for pages to include a TOC unless otherwise specified. This template checks to make sure that the notoc: field in this page’s front matter is not true.
我们希望页面的默认行为包括TOC，除非另有指定。此模板检查以确保此页’s前端中的notoc:字段不正确。

### 使用 全局参数 来判断代码块是否执行
这些参数在模板中是全局可用的。

如：版权copyrighthtml这个内容，需要在全局使用

```
[params]
  copyrighthtml = "Copyright &#xA9; 2017 John Doe. All Rights Reserved."
  sidebarrecentlimit = 5
  twitteruser = "spf13"
```
然后，在页脚中声明一个`<footer>`，只有当提供了copyrightml参数时才会呈现它。

```
{{ if .Site.Params.copyrighthtml }}
    <footer>
        <div class="text-center">{{.Site.Params.CopyrightHTML | safeHTML}}</div>
    </footer>
{{ end }}
```
或者用 `with` 来替换 `if`

```
// layouts/partials/twitter.html

{{ with .Site.Params.twitteruser }}
    <div>
        <a href="https://twitter.com/{{.}}" rel="author">
        <img src="/images/twitter.png" width="48" height="48" title="Twitter: {{.}}" alt="Twitter"></a>
    </div>
{{ end }}
```

layout 中可以使用“magic constants”

```
<nav>
  <h1>Recent Posts</h1>
  <ul>
  {{- range first .Site.Params.SidebarRecentLimit .Site.Pages -}}
      <li><a href="{{.RelPermalink}}">{{.Title}}</a></li>
  {{- end -}}
  </ul>
</nav>
```

### Example: Show Only Upcoming Events 只显示即将发生的事件 
Go allows you to do more than what’s shown here. Using Hugo’s `where function` and Go built-ins, we can list only the items from content/events/ whose date (set in a content file’s front matter) is in the future. The following is an example partial template:

```
layouts/partials/upcoming-events.html

<h4>Upcoming Events</h4>
<ul class="upcoming-events">
{{ range where .Pages.ByDate "Section" "events" }}
    {{ if ge .Date.Unix now.Unix }}
        <li>
        <!-- add span for event type -->
          <span>{{ .Type | title }} —</span>
          {{ .Title }} on
        <!-- add span for event date -->
          <span>{{ .Date.Format "2 January at 3:04pm" }}</span>
          at {{ .Params.place }}
        </li>
    {{ end }}
{{ end }}
</ul>
```
**https://gohugo.io/templates/introduction/#basic-syntax**



