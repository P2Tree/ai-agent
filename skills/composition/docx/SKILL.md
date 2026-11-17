---
name: docx
description: Word document processing — create, read, edit, format .docx and .dotx files, including tracked changes and comments. Use when user mentions Word docs, .docx, reports, memos, letter templates, or needs any .docx operations
disable-model-invocation: true
---

# DOCX 创建、编辑与分析

`.docx` 是 ZIP 包内含 XML 文件。按任务选择路径：

| 任务 | 方式 |
|------|------|
| 创建新文档 | 写 docx-js (npm) 脚本，见下方 gotchas |
| 编辑现有文档 | `unzip` → 改 `word/document.xml` → `zip`（docx-js 不能打开现有文件） |
| 读取内容 | `pandoc -t markdown file.docx` |

> 下文脚本路径相对本 skill 目录。

## 创建：docx-js gotchas

`docx` 已预装，不要先 `npm install`；直接 `require('docx')`。只有 require 失败时才安装。

- **页面尺寸默认 A4。** US Letter 显式设 `page: { size: { width: 12240, height: 15840 } }`（DXA，1440 = 1 英寸）。
- **横向**：传纵向尺寸并设 `orientation: PageOrientation.LANDSCAPE`，docx-js 会交换宽高。
- **表格双宽度**：表格设 `columnWidths`，每个单元格再设 `width`，都用 `WidthType.DXA`（PERCENTAGE 在 Google Docs 会坏）。列宽之和等于表宽。
- **表格底纹**：用 `ShadingType.CLEAR`，永远不用 `SOLID`（会渲染成黑色）。
- **列表**：不要插入字面量 `•`；用 `numbering` 配置 + `LevelFormat.BULLET`。
- **`ImageRun` 必须指定 `type`**（`"png"`、`"jpg"` 等）。
- **`PageBreak` 必须放在 `Paragraph` 内。**
- **不要用 `\n`**，用独立 `Paragraph` 元素。
- **标题**：每个用到的层级都要在 `styles.default` 单独配置，如 `heading1: { run: { font: "Arial", size: 32, bold: true }, paragraph: { spacing: { before: 240, after: 120 }, keepNext: true } }`。即使有文档默认值，每级也要自己的 font、`before`/`after`（即使为 0）和 `keepNext`；内置样式这些全为空。
- **TOC**：标题必须用内置 `HeadingLevel.*`；自定义样式需设 `outlineLevel`，否则不进目录。
- **不要用表格画分隔线**，用 Paragraph 的 bottom border。
- **点线引导/同行右对齐**：用 `TextRun` 内的 `PositionalTab`（`alignment: PositionalTabAlignment.RIGHT`，`leader: PositionalTabLeader.DOT`），不要用字面点或空格填充。

## 验证输出

写完后渲染出来看：

```bash
zip -d output.docx '*/' >/dev/null || true   # 删除 ZIP 目录条目；部分云协作服务会拒绝带目录条目的文件
python scripts/office/soffice.py --headless --convert-to pdf output.docx
pdftoppm -jpeg -r 100 output.pdf page
ls page-*.jpg   # 然后 Read 图片
```

`pdftoppm` 会按页数补零（`page-01.jpg`…`page-12.jpg`）。

## 编辑现有文档

旧版 `.doc` 先转换：`python scripts/office/soffice.py --headless --convert-to docx file.doc`。

```bash
unzip -q doc.docx -d unpacked/
find unpacked -type l -delete   # 去掉符号链接条目：外部 docx 不可信
python scripts/merge_runs.py unpacked/   # 合并碎片 run，让文本可查找
# 直接编辑 unpacked/word/document.xml，不要重排或 pretty-print
(cd unpacked && rm -f ../out.docx && zip -XrD ../out.docx .)
python scripts/office/validate.py out.docx --original doc.docx   # XSD 检查；--auto-repair 修复常见问题
# 修订模式：加 --author "<修订作者名>" 检查每处改动都被追踪
```

Word 会把文本拆成许多 `<w:r>` run（revision id、拼写标记），所以文档里看得见的短语在 XML 里往往不是连续字符串。`merge_runs.py` 合并相邻同格式 run，不改变内容或渲染；也接受 `.docx` 直连：`python scripts/merge_runs.py doc.docx -o merged.docx`。

### 修订追踪

用 `--author "<name>"` 加 `--original` 校验；它会报告任何没有 `<w:ins>`/`<w:del>` 包住的文本改动，这类遗漏在"接受修订"视图里看不见。

- 插入：`<w:ins w:id="1" w:author="..." w:date="...">` 包住 run。
- 删除：`<w:del>` 内用 `<w:delText>`，不是 `<w:t>`。
- 删除整段：还要删除段落标记 `<w:pPr><w:rPr><w:del .../></w:rPr></w:pPr>`，否则接受修订后留下空段。`<w:del/>` 必须在 rPr 其他子元素之前（schema 强制）。
- 生成接受全部修订的干净副本：`python scripts/accept_changes.py in.docx out.docx`。

`accept_changes.py`（LibreOffice）通常能正确合并被删段落，但被删段落后紧跟空占位段时除外；`pandoc --track-changes=accept` 从不合并。空项目符号是视图 artifact，不是文档缺陷——回到 XML 检查段落删除。

## 注释

注释需要六个互相链接的文件。优先用 helper，目录模式在还要编辑 `document.xml` 时省一次解包/打包，`.docx` 直连模式用于其他情况：

```bash
# 已解包目录（同时放标记时优先）
python scripts/comment.py unpacked/ "Fees & expenses cap is too low"
python scripts/comment.py unpacked/ "Agreed" --parent 0

# 直接处理 .docx
python scripts/comment.py contract.docx "This cap is too low" -o annotated.docx
```

脚本会写 `comments.xml`、`commentsExtended.xml`、`commentsIds.xml`、`commentsExtensible.xml`、关系和 content-type override，ID 自动分配。它随后打印要加入 `word/document.xml` 的 `<w:commentRangeStart>`/`<w:commentRangeEnd>`/`<w:commentReference>` 片段——不放这些标记，注释存在但不可见。

## 依赖

`docx` (npm，预装) · `pandoc` · LibreOffice (`soffice`) · `pdftoppm` (Poppler)

## 参考

- [创建文档详解](references/creating.md) — docx-js 完整代码模式
- [编辑文档详解](references/editing.md) — XML 编辑、修订、注释、图片
- `scripts/` 与 `LICENSE.txt` 来自 anthropics/skills（Apache-2.0）
