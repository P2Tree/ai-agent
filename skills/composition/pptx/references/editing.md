# 编辑详解

编辑现有 .pptx 文件的流程：解包→改 XML→清理→打包。

## Step 1: 分析模板

```bash
# 视觉概览
python scripts/thumbnail.py presentation.pptx

# 文本提取
python -m markitdown presentation.pptx

# 解包
python scripts/office/unpack.py presentation.pptx unpacked/
```

## Step 2: 编辑幻灯片

PPTX 的 XML 结构位于 `unpacked/ppt/` 下：

- `ppt/slides/slide1.xml`, `slide2.xml` ... — 幻灯片内容
- `ppt/slideLayouts/` — 布局定义
- `ppt/slideMasters/` — 母版
- `ppt/media/` — 媒体文件
- `ppt/_rels/` — 关系文件

### 添加幻灯片

```bash
python scripts/add_slide.py unpacked/ --layout "Title and Content" --position 3
```

从现有幻灯片复制：
```bash
python scripts/add_slide.py unpacked/ --copy 2 --position 3
```

### 修改文本

在 slide XML 中定位文本，用 Edit 工具直接替换。

### 修改图片

1. 替换 `ppt/media/` 中的图片文件（保持文件名不变）
2. 如需新增图片，添加到 `ppt/media/` 并更新关系文件

## Step 3: 清理

```bash
python scripts/clean.py unpacked/
```

移除孤立幻灯片、未引用媒体、废弃关系。

## Step 4: 打包

```bash
python scripts/office/pack.py unpacked/ output.pptx --original presentation.pptx
```

## QA

见 SKILL.md 中的 QA 验证流程。必须转换图片后检查。

## 转换为图片

```bash
python scripts/office/soffice.py --headless --convert-to pdf output.pptx
pdftoppm -jpeg -r 150 output.pdf slide
```

重渲特定幻灯片：
```bash
pdftoppm -jpeg -r 150 -f N -l N output.pdf slide-fixed
```
