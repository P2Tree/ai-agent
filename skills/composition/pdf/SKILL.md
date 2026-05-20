---
name: pdf
description: PDF 文件处理 — 读取、提取、合并、拆分、旋转、水印、加密、OCR、表单填写。Use when 用户提到 .pdf 文件或需要对 PDF 执行任何操作
disable-model-invocation: true
---

# PDF Processing

PDF 文件处理全流程：读取提取、合并拆分、创建生成、加密水印、OCR 扫描件。

## 快速参考

| 任务 | 推荐工具 | 入口 |
|------|----------|------|
| 读取/提取文本 | pdfplumber | `page.extract_text()` |
| 提取表格 | pdfplumber | `page.extract_tables()` |
| 合并 PDF | pypdf | `writer.add_page(page)` |
| 拆分 PDF | pypdf | 逐页写出 |
| 创建 PDF | reportlab | Canvas / Platypus |
| 加密/解密 | pypdf / qpdf | `writer.encrypt()` |
| 水印 | pypdf | `page.merge_page()` |
| OCR 扫描件 | pytesseract + pdf2image | 先转图片再 OCR |
| 表单填写 | pdf-lib (JS) / pypdf | 见 [forms.md](references/forms.md) |
| 命令行操作 | qpdf / pdftotext | 合并、拆分、旋转 |

## 工作流

### 1. 确认任务类型

用 AskUserQuestion 确认用户要做什么：
- 读取/提取内容
- 合并/拆分/旋转
- 创建新 PDF
- 加密/水印/表单
- OCR 扫描件

### 2. 读取 PDF

```python
from pypdf import PdfReader
reader = PdfReader("document.pdf")
print(f"Pages: {len(reader.pages)}")
```

文本提取用 pdfplumber（保留布局、支持表格）：

```python
import pdfplumber
with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        tables = page.extract_tables()
```

命令行提取：`pdftotext -layout input.pdf output.txt`

### 3. 合并与拆分

合并：遍历源文件，逐页 add_page 到 PdfWriter，写出到新文件。

拆分：逐页创建新 PdfWriter，每页一个文件。

命令行：`qpdf --empty --pages file1.pdf file2.pdf -- merged.pdf`

### 4. 创建 PDF

reportlab 两种模式：
- **Canvas**：底层绘图，精确控制位置
- **Platypus**：高级排版，自动分页、段落、表格

关键注意：
- 不使用 Unicode 上下标字符（渲染为黑块），用 `<sub>`/`<super>` XML 标签
- 不使用 `\n` 换行，用独立 Paragraph 元素

详细代码见 [creating.md](references/creating.md)。

### 5. 水印、加密、OCR

水印：读取水印 PDF 页，对每页 `merge_page()` 后写出。

加密：`writer.encrypt(user_pwd, owner_pwd)`。

OCR：`pdf2image` 转图片 → `pytesseract.image_to_string()`。

### 6. 验证

生成 PDF 后，用 `PdfReader` 验证页数和可提取文本，确认内容完整。

## 依赖

| 库 | 用途 |
|----|------|
| pypdf | 读写、合并、拆分、加密 |
| pdfplumber | 文本和表格提取 |
| reportlab | 创建 PDF |
| pytesseract + pdf2image | OCR 扫描件 |
| qpdf / poppler-utils | 命令行工具 |

## 参考

- [创建 PDF 详解](references/creating.md) — reportlab 完整代码示例
- [高级参考](references/advanced.md) — pypdfium2、pdf-lib (JS)、故障排查
- [表单填写](references/forms.md) — PDF 表单填写流程
