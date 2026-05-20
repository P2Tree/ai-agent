# 创建详解

pptxgenjs (Node.js) 从零创建 PPT 演示文稿。

## 安装

```bash
npm install -g pptxgenjs
```

## 基本结构

```javascript
const pptxgen = require("pptxgenjs");
const pres = new pptxgen();

// 设置默认布局
pres.layout = "LAYOUT_WIDE"; // 13.33" x 7.5" (16:9)

const slide = pres.addSlide();
slide.addText("Hello World", { x: 1, y: 1, fontSize: 36, bold: true });

pres.writeFile({ fileName: "output.pptx" });
```

## 常用布局尺寸

| 布局 | 尺寸 | 常量 |
|------|------|------|
| 宽屏 16:9 | 13.33" × 7.5" | `LAYOUT_WIDE` |
| 标准 4:3 | 10" × 7.5" | `LAYOUT_4x3` |
| 自定义 | 任意 | `pres.defineLayout({ name, width, height })` |

## 文本

```javascript
// 简单文本
slide.addText("Title", { x: 0.5, y: 0.3, fontSize: 36, bold: true, color: "1E2761" });

// 多段文本
slide.addText([
  { text: "Heading", options: { fontSize: 24, bold: true } },
  { text: "Body text here", options: { fontSize: 14, breakType: "paragraph" } }
], { x: 0.5, y: 1.5, w: 5, h: 3 });

// 项目符号
slide.addText([
  { text: "Item 1", options: { bullet: true } },
  { text: "Item 2", options: { bullet: true } },
], { x: 0.5, y: 1.5, w: 5, h: 3 });
```

## 形状

```javascript
// 矩形
slide.addShape(pres.ShapeType.rect, { x: 0.5, y: 1, w: 3, h: 2, fill: { color: "1E2761" } });

// 圆形
slide.addShape(pres.ShapeType.ellipse, { x: 1, y: 1, w: 2, h: 2, fill: { color: "CADCFC" } });

// 线条
slide.addShape(pres.ShapeType.line, { x: 0.5, y: 3, w: 9, h: 0, line: { color: "CCCCCC", width: 1 } });
```

## 图片

```javascript
slide.addImage({ path: "image.png", x: 5, y: 1, w: 4, h: 3 });

// 从 URL
slide.addImage({ path: "https://example.com/img.png", x: 5, y: 1, w: 4, h: 3 });

// Base64
slide.addImage({ data: "image/png;base64,...", x: 5, y: 1, w: 4, h: 3 });
```

## 表格

```javascript
const rows = [
  [{ text: "Header 1", options: { bold: true, fill: { color: "1E2761" }, color: "FFFFFF" } }, { text: "Header 2", options: { bold: true, fill: { color: "1E2761" }, color: "FFFFFF" } }],
  ["Cell 1", "Cell 2"],
  ["Cell 3", "Cell 4"],
];

slide.addTable(rows, {
  x: 0.5, y: 1, w: 9,
  border: { type: "solid", pt: 1, color: "CCCCCC" },
  colW: [4.5, 4.5],
  rowH: [0.5, 0.4, 0.4],
  margin: [5, 10, 5, 10],
});
```

## 图表

```javascript
const chartData = [
  { name: "Q1", labels: ["A", "B", "C"], values: [10, 20, 30] },
  { name: "Q2", labels: ["A", "B", "C"], values: [15, 25, 35] },
];

slide.addChart(pres.ChartType.bar, chartData, {
  x: 1, y: 1, w: 8, h: 5,
  showValue: true,
  chartColors: ["1E2761", "CADCFC"],
});
```

## 幻灯片母版与布局

```javascript
// 定义母版
pres.defineSlideMaster({
  title: "CUSTOM_MASTER",
  background: { fill: "1E2761" },
  objects: [
    { text: { text: "Company Name", options: { x: 0.5, y: 7, fontSize: 10, color: "FFFFFF" } } },
  ],
});

// 使用母版
const slide = pres.addSlide({ masterName: "CUSTOM_MASTER" });
```

## 动画

```javascript
// 进入动画
slide.addText("Animated", { x: 1, y: 1 });
// 注意：pptxgenjs 对动画支持有限，复杂动画需编辑 XML
```

## 大数字展示

```javascript
// 用大字号数字 + 小字号标签
slide.addText([
  { text: "95%", options: { fontSize: 60, bold: true, color: "1E2761" } },
  { text: "\nUptime", options: { fontSize: 14, color: "666666" } }
], { x: 1, y: 2, w: 3, h: 3, align: "center", valign: "middle" });
```

## 常见错误

| 错误 | 正确做法 |
|------|----------|
| 尺寸单位混淆 | pptxgenjs 用英寸，不是 DXA |
| 标题下划线 | 不要用，这是 AI 生成的标志；用空白或背景色 |
| 所有幻灯片同布局 | 变换列、卡片、标注布局 |
| 居中正文 | 正文左对齐，仅标题居中 |
| 低对比度 | 文字和图标都要高对比度 |
| 文本框太窄 | 留足宽度避免过多换行 |
| 忘记 text box padding | 对齐形状时设 `margin: 0` 或偏移补偿 |
