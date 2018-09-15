+++
title = "example - Mobile visual clothing search"
date = 2013-07-01T00:00:00
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ["GA Cushen", "MS Nixon"]

# Publication type.
# Legend: 说明
# 0 = Uncategorized  未分类
# 1 = Conference paper  会议文件
# 2 = Journal article  期刊文章
# 3 = Manuscript  手稿
# 4 = Report  报告
# 5 = Book  书
# 6 = Book section  书部分
publication_types = ["1"]

# 出版物名称和可选的缩写版本。
publication = "In *International Conference on Multimedia and Expo Workshops (ICMEW)*, IEEE."
publication_short = "In *ICMEW*"

# 摘要 & 缩短版本（可选）.
abstract = "We present a mobile visual clothing search system whereby a smart phone user can either choose a social networking photo or take a new photo of a person wearing clothing of interest and search for similar clothing in a retail database. From the query image, the person is detected, clothing is segmented, and clothing features are extracted and quantized. The information is sent from the phone client to a server, where the feature vector of the query image is used to retrieve similar clothing products from online databases. The phone's GPS location is used to re-rank results by retail store location. State of the art work focuses primarily on the recognition of a diverse range of clothing offline and pays little attention to practical applications. Evaluated on a challenging dataset, the system is relatively fast and achieves promising results."
abstract_short = "A mobile visual clothing search system is presented whereby a smart phone user can either choose a social networking image or capture a new photo of a person wearing clothing of interest and search for similar clothing in a large cloud-based ecommerce database. The phone's GPS location is used to re-rank results by retail store location, to inform the user of local stores where similar clothing items can be tried on."

# 指定图片缩略图（可选）
image_preview = ""

# 这是一个选定的出版物吗？ (true/false)  就是第一栏是否显示
selected = false

# Projects (可选).
#   将此出版物与一个或多个project相关联。
#   只需输入project的文件名，不带扩展名。
#   E.g. `projects = ["deep-learning"]` references `content/project/deep-learning.md`.
#   否则, 请设置 `projects = []`.

projects = ["example-external-project"]

# 标签 (可选).
#   Set `tags = []` for no tags, or use the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = []

# 链接 (可选).
url_pdf = "http://eprints.soton.ac.uk/352095/1/Cushen-IMV2013.pdf"
url_preprint = "http://eprints.soton.ac.uk/352095/1/Cushen-IMV2013.pdf"
url_code = ""
url_dataset = ""
url_project = ""
url_slides = ""
url_video = ""
url_poster = ""
url_source = ""

# 自定义链接 (可选).
#   Uncomment line below to enable. For multiple links, use the form `[{...}, {...}, {...}]`.
url_custom = [{name = "Custom Link", url = "http://example.org"}]

# 此页面是否包含LaTeX数学公式? (true/false)
math = true

# 此页面是否需要突出显示源代码? (true/false)
highlight = true

# 指定图片
# 图片放在 `static/img/` , 并在后面引用其文件名, e.g. `image = "example.jpg"`.
[header]
image = "headers/bubbles-wide.jpg"
caption = "My caption :smile:"

+++

More detail can easily be written here using *Markdown* and $\rm \LaTeX$ math code.
