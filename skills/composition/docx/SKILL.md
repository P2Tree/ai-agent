---
name: docx
description: Word 文档处理 — 创建、读取、编辑、格式化 .docx 文件。Use when 用户提到 Word 文档、.docx、报告、备忘录、信函模板，或需要对 .docx 做任何操作
disable-model-invocation: true
---

# DOCX 创建、编辑与分析

.docx 是 ZIP 包内含 XML 文件。创建用 docx-js (Node.js)，编辑现有文件用解包→改 XML→重新打包。

## 快速参考

| 任务 | 方式 |
|------|------|
| 读取/分析 | `pandoc` 或解包查看 XML |
| 创建新文档 | docx-js（见 [creating.md](references/creating.md)） |
| 编辑现有文档 | 解包→改 XML→打包（见 [editing.md](references/editing.md)） |

## 工作流

### 1. 确认任务类型

用 AskUserQuestion 确认用户要做什么：
- 读取/提取内容
- 创建新文档
- 编辑现有文档
- 格式转换

### 2. 读取内容

```bash
pandoc --track-changes=all document.docx -o output.md
python scripts/office/unpack.py document.docx unpacked/
```

### 3. 创建新文档

用 docx-js (`npm install -g docx`)，详见 [creating.md](references/creating.md)。

关键规则：
- **必须显式设置页面尺寸** — docx-js 默认 A4
- **不用 `\n`** — 用独立 Paragraph 元素
- **不用 Unicode 列表符号** — 用 `LevelFormat.BULLET`
- **PageBreak 必须在 Paragraph 内**
- **ImageRun 必须指定 `type`**
- **表格必须同时设 `columnWidths` 和单元格 `width`**
- **用 `ShadingType.CLEAR`**，不用 SOLID
- **不用表格做分隔线** — 用 Paragraph 的 border

### 4. 编辑现有文档

三步流程：解包 → 编辑 XML → 打包。详见 [editing.md](references/editing.md)。

```bash
# Step 1: 解包
python scripts/office/unpack.py document.docx unpacked/

# Step 2: 编辑 XML（用 Edit 工具直接替换，不要写 Python 脚本）

# Step 3: 打包
python scripts/office/pack.py unpacked/ output.docx --original document.docx
```

### 5. 验证

创建/编辑后验证：
```bash
python scripts/office/validate.py output.docx
```

## 关键约束

| 约束 | 说明 |
|------|------|
| 页面尺寸 | 显式设置 US Letter (12240×15840 DXA) 或 A4 |
| 表格宽度 | 只用 `WidthType.DXA`，不用 PERCENTAGE（Google Docs 不兼容） |
| 列表 | 用 `LevelFormat.BULLET` / `DECIMAL`，不用 Unicode 字符 |
| 上下标 | 用 `<sub>`/`<super>` 标签，不用 Unicode 上下标 |
| 智能引号 | XML 中用实体 `&#x2018;` `&#x2019;` `&#x201C;` `&#x201D;` |
| 修订追踪 | 用 "Claude" 作为 author |
| TOC | 只用 `HeadingLevel`，不用自定义样式 |

## 依赖

| 工具 | 用途 |
|------|------|
| docx (npm) | 创建新文档 |
| pandoc | 文本提取 |
| LibreOffice | PDF 转换 |

## 参考

- [创建文档详解](references/creating.md) — docx-js 完整代码模式
- [编辑文档详解](references/editing.md) — XML 编辑、修订追踪、注释
