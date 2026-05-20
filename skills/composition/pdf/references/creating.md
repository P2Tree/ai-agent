# 创建 PDF 详解

reportlab 两种创建模式的完整代码示例。

## Canvas 模式（底层绘图）

```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

c = canvas.Canvas("hello.pdf", pagesize=letter)
width, height = letter
c.drawString(100, height - 100, "Hello World!")
c.line(100, height - 140, 400, height - 140)
c.save()
```

## Platypus 模式（高级排版）

```python
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet

doc = SimpleDocTemplate("report.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = []

title = Paragraph("Report Title", styles['Title'])
story.append(title)
story.append(Spacer(1, 12))

body = Paragraph("Body content. " * 20, styles['Normal'])
story.append(body)
story.append(PageBreak())

story.append(Paragraph("Page 2", styles['Heading1']))
story.append(Paragraph("Content for page 2", styles['Normal']))

doc.build(story)
```

## 上下标

不使用 Unicode 上下标字符（₀₁₂₃₄₅₆₇₈₉ 等），内置字体不含这些字形，会渲染为黑块。

用 ReportLab 的 XML 标记：

```python
from reportlab.platypus import Paragraph
from reportlab.lib.styles import getSampleStyleSheet
styles = getSampleStyleSheet()

# 下标
chemical = Paragraph("H<sub>2</sub>O", styles['Normal'])
# 上标
squared = Paragraph("x<super>2</super> + y<super>2</super>", styles['Normal'])
```

Canvas 绘制文本时，手动调整字号和位置代替上下标。
