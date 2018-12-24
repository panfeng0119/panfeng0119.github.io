+++
title= "Hugo Mathjax 渲染问题"
subtitle= "Using Mathjax"
author = "Pan Feng"
date =  "2018-12-23"
lastmod = 2018-12-23T23:02:35+08:00

tags= ["Mathjax", "hugo"]
draft= false

keywords = ["hugo"]
categories = ["hugo"]

description =  "markdown 在 hugo 中默认是没有公式渲染的，需要引入 Mathjax 模块。"

mathjax = true
+++

[原文地址](http://note.qidong.name/2018/03/hugo-mathjax/)

markdown 在 hugo 中默认是没有公式渲染的，需要引入 Mathjax 模块。
### 方案

在 layouts/partials/ 目录下，把所有和公式有关的修改都写在一个文件中，然后在适当的位置调用

##### 步骤1

创建文件 `layouts/partials/mathjax.html`



```
<!-- layouts/partials/mathjax.html -->
<!-- 公式渲染 mathjax -->
<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

<!-- 区分行内普通的标记 -->
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        displayMath: [['$$','$$'], ['\[','\]']],
        processEscapes: true,
        processEnvironments: true,
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
        TeX: { equationNumbers: { autoNumber: "AMS" },
                extensions: ["AMSmath.js", "AMSsymbols.js"] }
    }
});
</script>
  
<script type="text/x-mathjax-config">
    // Fix <code> tags after MathJax finishes running. This is a
    // hack to overcome a shortcoming of Markdown. Discussion at
    // https://github.com/mojombo/jekyll/issues/199
    MathJax.Hub.Queue(() => {
    MathJax.Hub.getAllJax().map(v => v.SourceElement().parentNode.className += ' has-jax');
    });
</script> 

<style>
    code.has-jax {
        font: inherit;
        font-size: 100%;
        background: inherit;
        border: inherit;
        color: #515151;
    }
</style>
```
##### 步骤2
在文件 layout/footer.html (`<foot>` 或 `<head>`都可以)适当位置添加下面代码
```
{{ partial "mathjax.html" . }}
```


---
### 代码说明

第一块代码是渲染用的主要调用

```
<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
```

第二块是对行内代码进行优化

因为在 markdown 中，对一些特殊字符进行了转义，使MathJax对行内代码渲染无效，因此需要添加下面代码把普通的代码和MathJax代码分开

```
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [['$','$'], ['\\(','\\)']],
    displayMath: [['$$','$$'], ['\[','\]']],
    processEscapes: true,
    processEnvironments: true,
    skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
    TeX: { equationNumbers: { autoNumber: "AMS" },
          extensions: ["AMSmath.js", "AMSsymbols.js"] }
  }
});
</script>

<script type="text/x-mathjax-config">
  // Fix <code> tags after MathJax finishes running. This is a
  // hack to overcome a shortcoming of Markdown. Discussion at
  // https://github.com/mojombo/jekyll/issues/199
  MathJax.Hub.Queue(() => {
    MathJax.Hub.getAllJax().map(v => v.SourceElement().parentNode.className += ' has-jax');
  });
</script> 
```
第三块是对样式进行处理

在CSS中对这种特殊的MathJax进行样式处理，否则行内公式的显示会有些奇怪。(<font color=#FF0000>**亲测无效**</font>)

```
code.has-jax {
    font: inherit;
    font-size: 100%;
    background: inherit;
    border: inherit;
    color: #515151;
}
```

<!-- 默认情况下，(c)可转换为©，(r)可转换为®。 -->


但是，这样对行内公式仍然无法支持。 而除了支持行内公式，还有Markdown特殊字符的转义问题，如下划线_。 为了支持无需转义地写公式，行内公式推荐写成行内代码，用 \` \` 来包含，而区块公式则推荐用`<div></div>`来包含。

```
When `$a \ne 0$`, there are two solutions to `\(ax^2 + bx + c = 0\)` and they are:

<div>$$
x = {-b \pm \sqrt{b^2-4ac} \over 2a}
$$</div>
```