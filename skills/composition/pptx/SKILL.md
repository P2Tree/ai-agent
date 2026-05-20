---
name: pptx
description: PPT 演示文稿处理 — 创建、读取、编辑、拆分、合并 .pptx 文件。Use when 用户提到演示文稿、slides、deck、.pptx，或需要对 PPT 做任何操作
disable-model-invocation: true
---

# PPTX 创建、编辑与分析

PPT 演示文稿处理：读取提取、从模板编辑、从零创建。包含设计指导和视觉 QA。

## 快速参考

| 任务 | 方式 |
|------|------|
| 读取/提取文本 | `python -m markitdown presentation.pptx` |
| 视觉概览 | `python scripts/thumbnail.py presentation.pptx` |
| 编辑现有文件 | 解包→改 XML→打包，见 [editing.md](references/editing.md) |
| 从零创建 | pptxgenjs (Node.js)，见 [creating.md](references/creating.md) |

## 工作流

### 1. 确认任务类型

用 AskUserQuestion 确认用户要做什么：
- 读取/提取内容
- 编辑现有演示文稿
- 从零创建新演示文稿
- 转换格式

### 2. 读取内容

```bash
# 文本提取
python -m markitdown presentation.pptx

# 视觉概览
python scripts/thumbnail.py presentation.pptx

# 原始 XML
python scripts/office/unpack.py presentation.pptx unpacked/
```

### 3. 设计决策（创建/编辑时）

创建或大幅编辑前，必须确定：

**配色** — 选取与主题匹配的调色板，一色主导（60-70%），1-2 辅助色，1 强调色。深浅交替（标题深色，内容浅色）。

**视觉主题** — 选一个重复性元素贯穿所有幻灯片：圆角图片框、彩色圆圈图标、粗单边框线。

**字体配对** — 标题用有性格的字体，正文用清晰的字体。

详细设计指导见 [design.md](references/design.md)。

### 4. 创建 / 编辑

- 从零创建：用 pptxgenjs，见 [creating.md](references/creating.md)
- 编辑模板：解包→改 XML→打包，见 [editing.md](references/editing.md)

### 5. QA 验证（必须）

**假设有问题。第一次渲染几乎总有缺陷。**

内容验证：
```bash
python -m markitdown output.pptx
# 检查缺失内容、错别字、顺序错误
# 检查残留占位符：
python -m markitdown output.pptx | grep -iE "xxxx|lorem|ipsum|this.*(page|slide).*layout"
```

视觉验证 — 用子代理检查（自己看代码会产生盲区）：
1. 转换为图片：`python scripts/office/soffice.py --headless --convert-to pdf output.pptx && pdftoppm -jpeg -r 150 output.pdf slide`
2. 让子代理逐张检查重叠、溢出、对齐、对比度问题

验证循环：生成→检查→修复→再验证，直到无新问题。

## 依赖

| 工具 | 用途 |
|------|------|
| markitdown | 文本提取 |
| pptxgenjs (npm) | 从零创建 |
| LibreOffice | PDF 转换 |
| Poppler (pdftoppm) | PDF 转图片 |

## 参考

- [创建详解](references/creating.md) — pptxgenjs 完整用法
- [编辑详解](references/editing.md) — XML 编辑流程
- [设计指导](references/design.md) — 配色、布局、字体、避坑
