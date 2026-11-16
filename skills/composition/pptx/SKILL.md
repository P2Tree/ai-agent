---
name: pptx
description: PowerPoint presentation processing — create, read, edit, split, merge .pptx and .potx files, including templates, layouts, and speaker notes. Use when user mentions presentations, slides, deck, .pptx, or needs any PPT operations
disable-model-invocation: true
---

# PPTX 创建、编辑与分析

`.pptx` 是 ZIP 包内含 XML 文件。按任务选择路径：

| 任务 | 方式 |
|------|------|
| 创建新 deck | 写 `pptxgenjs` 脚本；除非用户要快速草稿，否则按 **Structured decks** 构建 |
| 编辑现有 deck / 模板 | unzip → 改 `ppt/slides/slideN.xml` → zip |
| 读取内容 | `python scripts/slide_text.py deck.pptx`；视觉网格 `python scripts/thumbnail.py deck.pptx <prefix>` |

## Scripts

路径相对本 skill 目录。

| Script | 用途 |
|--------|------|
| `slide_text.py deck.pptx` | 每页标题、文本、表格、图表数据、图片 alt、备注，输出 markdown |
| `thumbnail.py deck.pptx [prefix]` | 所有页的标注网格；**必须传 prefix**（默认 `thumbnails` 会覆盖其他 deck 的图） |
| `add_slide.py unpacked/ slide2.xml [--after slideN.xml]` | 复制 slide/layout 及全部包注册；对 `.pptx` 用 `-o out.pptx` |
| `clean.py unpacked/` | 删除不再引用的 slide/media/rels；**在 `<p:sldIdLst>` 定稿后**运行 |
| `apply_theme.js` | 写入 structured deck 的 theme 颜色与名称 |
| `office/validate.py deck.pptx [--original src.pptx]` | schema、关系、content-type、chart、slide 检查 |
| `office/soffice.py --headless --convert-to pdf` | LibreOffice 包装器 |

## 创建：pptxgenjs 关键 gotchas

`pptxgenjs` 已预装；直接 `require('pptxgenjs')`，require 失败才安装。完整清单见 [creating.md](references/creating.md)。

- **先设 `pres.layout` 再加页。** 默认 `LAYOUT_16x9` = 10" × 5.625"，不是 13.3"；越界坐标不会裁剪，只是不上屏。
- **十六进制颜色不带 `#`、不用 8 位 alpha。** `"FF0000"` 正确；`"#FF0000"` 或 `"00000020"` 会损坏文件。透明度用 `transparency: 0-100`，阴影透明度用 `opacity`。
- **pptxgenjs 会就地修改 options 对象**，不要跨 `add*` 调用复用同一个 `shadow`/options 对象。
- **shadow `offset` 必须 ≥ 0**；要向上投影用 `angle: 270`。
- **`letterSpacing` 被静默忽略**，实际选项是 `charSpacing`。
- **列表**：每项 `bullet: true`，不要字面 `•`；除最后一项外设 `breakLine: true`；段间距用 `paraSpaceAfter`。
- **一个输出文件一个 `new pptxgen()` 实例。**
- **`rectRadius` 只对 `ROUNDED_RECTANGLE` 有效。**
- **不支持渐变填充**，用渐变图片作背景。
- **无 placeholder 的 `addText` 必须设 `isTextBox: true`**，否则读屏软件报 "graphic"。
- **文本框有内置 padding**；文字要与形状/线/图标对齐时设 `margin: 0`。
- **演讲者备注用 `slide.addNotes("...")`**，不要放页面文本框。
- **图表尽量原生**：用 `addChart()`；组合图传数组。仅 Sankey/network/chord 等无原生形式的图用图片。
- **默认图表很裸**：设 `showTitle` + `title`、`showValue` + `dataLabelPosition`、`chartColors`，并调暗坐标轴/网格线。
- **堆叠柱状图的 `dataLabelPosition` 只能是 `ctr`/`inEnd`/`inBase`**；`outEnd` 损坏文件。
- **双轴组合图必须同时给 `valAxes` 和 `catAxes`**，各两项；只给 `valAxes` 会被 PowerPoint 丢弃图表。
- **`writeFile()` 后跑 `validate.py`**；在生成器里修，不要手改打包后的 XML。
- **不要重排 `<p:presentation>` 子元素**；`<p:notesMasterIdLst>` 位置错了文件打不开。
- **`pres.company` 和 `defineSlideMaster()` 的 `title` 不做 XML 转义**，`&` 要写成 `&amp;`。
- **`defineSlideMaster()` 创建的是 slide layout，不是 master**，对用户也称 layout。

### Structured decks

新 deck 默认按主题/版式/占位符/章节构建，除非用户要快速草稿。完整 7 步见 [creating.md](references/creating.md)。

1. 先定义 `THEME`（字体 + 颜色），`pres.theme` 只接收两种字体。
2. 所有颜色用 `pres.SchemeColor`（`C.text1`、`C.background1` 等），但 `valGridLine.color` 等纯 hex 选项除外。
3. 每个章节用 `pres.addSection({ title })`，每页 `addSlide({ sectionTitle })`。
4. 每种页面框架一个 layout（title、section divider、title only、chart+commentary、table），页脚/logo/页码放 layout。
5. 通过 placeholder 名称填充，不传位置/尺寸/颜色；拼错的 `placeholder`/`masterName` 会静默失败。
6. Layout 只是框架；卡片、图标、统计标注仍在页面上逐页组合，并设 `objectName`。
7. `await pres.writeFile()` 后必须 `await applyTheme("deck.pptx", THEME)`；否则 scheme 颜色回落到 Office 默认色。

## 编辑现有 deck 和模板

完整流程与 gotchas 见 [editing.md](references/editing.md)。

```bash
python3 -c "import sys,zipfile; zipfile.ZipFile(sys.argv[1]).extractall('unpacked')" deck.pptx
python scripts/add_slide.py unpacked/ slide2.xml --after slide2.xml
# 增删/重排页：改 ppt/presentation.xml 的 <p:sldIdLst>
python scripts/clean.py unpacked/
# 编辑 ppt/slides/slideN.xml
(cd unpacked && rm -f ../out.pptx && zip -XrD ../out.pptx .)
python scripts/office/validate.py out.pptx --original deck.pptx
```

关键规则：

- **所有结构性操作（增删重排）先于内容编辑。** `add_slide.py` 原样复制文件；`clean.py` 会删掉不在 `sldIdLst` 里的页。
- **不要手工复制 slide 文件**；复制后的 slide 仍引用源 slide 的 chart/SmartArt 部件，改一个会影响另一个。
- 旧 `.ppt` 先转 `.pptx`；`.potx` 打包后保留 `.potx` 扩展名。
- 脚本化 XML 转换用 `defusedxml.minidom`；`xml.etree.ElementTree` 会重写命名空间前缀并损坏 deck。
- **模板槽位 ≠ 源条目**：模板有 4 个成员而实际只有 3 个时，删掉第 4 个的整组元素，不只删文字。
- 一个列表项一个 `<a:p>`；复制兄弟 `<a:pPr>` 保留间距；标题/内联标签的 `<a:rPr>` 设 `b="1"`。
- 项目符号从 layout 继承，只用 `<a:buChar>`/`<a:buAutoNum>`/`<a:buNone>` 覆盖，不要字面 `•`。
- 前后有空格文本的 `<a:t>` 加 `xml:space="preserve"`。

## 内容与结构

完整指导见 [design.md](references/design.md)。要点：每页一个信息；常用金字塔结构（主旨 → 摘要 → 分节 → 结论/下一步）；按 deck 规模和用途定结构；现场演讲约 1.5–2 分钟/页。字体优先 Arial/Calibri/Cambria/Times New Roman/Courier New/Bookman/Century Schoolbook；避免 Aptos；Georgia/Trebuchet MS/Impact 等 QA 预览不可靠。

## QA（必须）

**假设第一版有问题。** 内容、文件、视觉三项都过：

```bash
# Content QA
python scripts/slide_text.py output.pptx
python scripts/slide_text.py output.pptx | grep -iE "\bx{3,}\b|lorem|ipsum|\bTODO|\[insert|this.*(page|slide).*layout"

# File QA
python scripts/office/validate.py output.pptx                      # 从零创建
python scripts/office/validate.py output.pptx --original src.pptx  # 基于模板，必须加 --original

# Visual QA
python scripts/office/soffice.py --headless --convert-to pdf output.pptx
rm -f slide-*.jpg
pdftoppm -jpeg -r 150 output.pdf slide
ls -1 "$PWD"/slide-*.jpg   # 把绝对路径交给看图工具/子代理
```

视觉检查重点：文字溢出/截断（最常见）、元素重叠、页脚与内容碰撞、间距 <0.3"、边距 <0.5"、对齐不一致、低对比度、模板装饰错位、同一类型页面标题高度/图表标签不一致、单词或数字跨行、残留占位符。

**validate 通过 ≠ 文件有效**：删除带动画的形状时同时删 `<p:timing>`；重复 chart 元素可能漏检。修复后必须重跑全部四条转换命令。

## 依赖

`pptxgenjs` (npm, 预装) · `python-pptx`、`Pillow`、`defusedxml`、`lxml` · LibreOffice (`soffice`) · `pdftoppm` (Poppler)

## 参考

- [创建详解](references/creating.md) — pptxgenjs 完整 gotchas + structured decks
- [编辑详解](references/editing.md) — 模板编辑、脚本与 XML 规则
- [设计指导](references/design.md) — 配色、布局、字体、内容结构、避坑
- `scripts/` 与 `LICENSE.txt` 来自 anthropics/skills（Apache-2.0）
