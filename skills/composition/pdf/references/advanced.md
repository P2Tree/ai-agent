# 高级参考

pypdfium2、pdf-lib (JavaScript)、故障排查。

## pypdfium2

高性能 PDF 渲染，基于 PDFium（Chromium 内核）。

```python
import pypdfium2 as pdfium

pdf = pdfium.PdfDocument("input.pdf")
for i in range(len(pdf)):
    page = pdf[i]
    bitmap = page.render(scale=2)
    bitmap.to_pil().save(f"page_{i+1}.png")
```

## pdf-lib (JavaScript)

纯 JavaScript PDF 操作，无需系统依赖。适合 Node.js 环境。

```javascript
const { PDFDocument, rgb } = require('pdf-lib');

// 创建新 PDF
const doc = await PDFDocument.create();
const page = doc.addPage([595, 842]);
page.drawText('Hello World', { x: 50, y: 750, size: 24 });
const bytes = await doc.save();
fs.writeFileSync('output.pdf', bytes);

// 修改现有 PDF
const existing = await PDFDocument.load(fs.readFileSync('input.pdf'));
const pages = await existing.copyPages(existing, [0]);
existing.addPage(pages[0]);
```

## 常见问题

### 文本提取乱码
- 尝试 `pdftotext -layout` 保留布局
- 扫描件 PDF 需先 OCR

### 合并后文件过大
- 用 `qpdf --linearize` 优化 web 查看
- 压缩图片后再合并

### 加密 PDF 无法读取
- `qpdf --password=xxx --decrypt encrypted.pdf decrypted.pdf`
- pypdf: `reader = PdfReader("file.pdf", password="xxx")`

### 表格提取不完整
- pdfplumber 的 `extract_tables()` 对复杂表格可能漏行
- 尝试调整 `table_settings` 参数
- 复杂场景考虑用 camelot 或 tabula-py
