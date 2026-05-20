# 创建文档详解

docx-js (Node.js) 创建 .docx 文件的完整代码模式。

## 基本结构

```javascript
const { Document, Packer, Paragraph, TextRun } = require('docx');

const doc = new Document({
  sections: [{ children: [/* content */] }]
});

Packer.toBuffer(doc).then(buffer => fs.writeFileSync("doc.docx", buffer));
```

## 页面尺寸

docx-js 默认 A4，必须显式设置：

```javascript
sections: [{
  properties: {
    page: {
      size: { width: 12240, height: 15840 }, // US Letter (DXA: 1440 = 1 inch)
      margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
    }
  },
  children: [/* content */]
}]
```

| 纸张 | Width | Height | 内容宽度 (1" 边距) |
|------|-------|--------|---------------------|
| US Letter | 12,240 | 15,840 | 9,360 |
| A4 | 11,906 | 16,838 | 9,026 |

横版：传竖版尺寸 + `orientation: PageOrientation.LANDSCAPE`，docx-js 内部交换。

## 样式

用 Arial 作为默认字体，覆盖内置标题样式：

```javascript
const doc = new Document({
  styles: {
    default: { document: { run: { font: "Arial", size: 24 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 32, bold: true, font: "Arial" },
        paragraph: { spacing: { before: 240, after: 240 }, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 28, bold: true, font: "Arial" },
        paragraph: { spacing: { before: 180, after: 180 }, outlineLevel: 1 } },
    ]
  },
  sections: [{ children: [
    new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("Title")] }),
  ]}]
});
```

## 列表

不用 Unicode 符号，用 numbering config：

```javascript
numbering: {
  config: [
    { reference: "bullets",
      levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } } }] },
    { reference: "numbers",
      levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } } }] },
  ]
}
// 同 reference 续编号，不同 reference 重新开始
```

## 表格

必须同时设 `columnWidths` 和单元格 `width`：

```javascript
const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };

new Table({
  width: { size: 9360, type: WidthType.DXA },
  columnWidths: [4680, 4680],
  rows: [new TableRow({
    children: [new TableCell({
      borders,
      width: { size: 4680, type: WidthType.DXA },
      shading: { fill: "D5E8F0", type: ShadingType.CLEAR },
      margins: { top: 80, bottom: 80, left: 120, right: 120 },
      children: [new Paragraph({ children: [new TextRun("Cell")] })]
    })]
  })]
})
```

只用 `WidthType.DXA`，不用 PERCENTAGE（Google Docs 不兼容）。表格宽度 = 列宽之和。

## 图片

```javascript
new Paragraph({
  children: [new ImageRun({
    type: "png", // 必须指定
    data: fs.readFileSync("image.png"),
    transformation: { width: 200, height: 150 },
    altText: { title: "Title", description: "Desc", name: "Name" }
  })]
})
```

## 页眉页脚

```javascript
sections: [{
  headers: {
    default: new Header({ children: [new Paragraph({ children: [new TextRun("Header")] })] })
  },
  footers: {
    default: new Footer({ children: [new Paragraph({
      children: [new TextRun("Page "), new TextRun({ children: [PageNumber.CURRENT] })]
    })] })
  },
  children: [/* content */]
}]
```

## 目录

```javascript
new TableOfContents("Table of Contents", { hyperlink: true, headingStyleRange: "1-3" })
```

标题必须用 `HeadingLevel`，不能用自定义样式。`outlineLevel` 必须设置（0=H1, 1=H2）。

## 超链接与脚注

```javascript
// 外部链接
new ExternalHyperlink({ children: [new TextRun({ text: "Link", style: "Hyperlink" })], link: "https://example.com" })

// 书签
new Bookmark({ id: "chapter1", children: [new TextRun("Chapter 1")] })
new InternalHyperlink({ children: [new TextRun({ text: "See Ch1", style: "Hyperlink" })], anchor: "chapter1" })

// 脚注
const doc = new Document({
  footnotes: { 1: { children: [new Paragraph("Source: Annual Report")] } },
  sections: [{ children: [new Paragraph({
    children: [new TextRun("Text"), new FootnoteReferenceRun(1)]
  })] }]
});
```

## 多栏布局

```javascript
sections: [{
  properties: {
    column: { count: 2, space: 720, equalWidth: true, separate: true }
  },
  children: [/* 内容自动跨栏 */]
}]
```

## Tab 停位

```javascript
// 右对齐（标题左、日期右）
new Paragraph({
  children: [new TextRun("Company"), new TextRun("\tJanuary 2025")],
  tabStops: [{ type: TabStopType.RIGHT, position: TabStopPosition.MAX }],
})
```

## 常见错误

| 错误 | 正确做法 |
|------|----------|
| `\n` 换行 | 用独立 Paragraph |
| Unicode 列表符号 | 用 LevelFormat.BULLET |
| PageBreak 独立使用 | 放在 Paragraph 内 |
| ImageRun 缺 type | 必须指定 png/jpg/etc |
| WidthType.PERCENTAGE | 用 DXA |
| ShadingType.SOLID | 用 CLEAR |
| 用表格做分隔线 | 用 Paragraph border |
