+++
# 自定义小部件.
widget = "custom"
active = true
date = {{ .Date }}

# 主意: 通过用 `#` 来标记 `title` 和 `subtitle` , 可以开启 宽屏 格式（full width section）.
title = "{{ replace .TranslationBaseName "-" " " | title }}"
subtitle = ""

# 使用命令来控制显示宽度.
weight = 100
+++
