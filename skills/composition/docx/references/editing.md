# 编辑文档详解

编辑现有 .docx 文件的三步流程：解包 → 编辑 XML → 打包。

## Step 1: 解包

```bash
python scripts/office/unpack.py document.docx unpacked/
```

解包会：提取 XML、格式化输出、合并相邻 run、将智能引号转为 XML 实体。

用 `--merge-runs false` 跳过 run 合并。

## Step 2: 编辑 XML

编辑 `unpacked/word/` 下的文件。**用 Edit 工具直接替换，不要写 Python 脚本。**

### 智能引号

新内容中的引号和撇号用 XML 实体：

| 实体 | 字符 |
|------|------|
| `&#x2018;` | ' (左单引号) |
| `&#x2019;` | ' (右单引号/撇号) |
| `&#x201C;` | " (左双引号) |
| `&#x201D;` | " (右双引号) |

### 修订追踪

插入：
```xml
<w:ins w:id="1" w:author="Claude" w:date="2025-01-01T00:00:00Z">
  <w:r><w:t>inserted text</w:t></w:r>
</w:ins>
```

删除：
```xml
<w:del w:id="2" w:author="Claude" w:date="2025-01-01T00:00:00Z">
  <w:r><w:delText>deleted text</w:delText></w:r>
</w:del>
```

关键规则：
- 替换整个 `<w:r>` 元素，不在 run 内插入修订标签
- 复制原 run 的 `<w:rPr>` 到修订 run 中保持格式
- `<w:del>` 内用 `<w:delText>` 代替 `<w:t>`
- 只标记变更部分，不标记未变内容

### 删除整段

同时标记段落标记为删除（否则接受修订后留空段）：

```xml
<w:p>
  <w:pPr>
    <w:rPr>
      <w:del w:id="1" w:author="Claude" w:date="..."/>
    </w:rPr>
  </w:pPr>
  <w:del w:id="2" w:author="Claude" w:date="...">
    <w:r><w:delText>Entire paragraph...</w:delText></w:r>
  </w:del>
</w:p>
```

### 拒绝他人插入

嵌套删除在他人插入内：
```xml
<w:ins w:author="Jane" w:id="5">
  <w:del w:author="Claude" w:id="10">
    <w:r><w:delText>their text</w:delText></w:r>
  </w:del>
</w:ins>
```

### 恢复他人删除

在删除后添加插入：
```xml
<w:del w:author="Jane" w:id="5">
  <w:r><w:delText>deleted text</w:delText></w:r>
</w:del>
<w:ins w:author="Claude" w:id="10">
  <w:r><w:t>deleted text</w:t></w:r>
</w:ins>
```

### 注释

用 `comment.py` 处理跨文件样板代码：

```bash
python scripts/comment.py unpacked/ 0 "Comment text"
python scripts/comment.py unpacked/ 1 "Reply text" --parent 0
python scripts/comment.py unpacked/ 0 "Text" --author "Custom Author"
```

然后在 document.xml 添加标记。标记是 `<w:p>` 的直接子元素，不在 `<w:r>` 内：

```xml
<w:commentRangeStart w:id="0"/>
<w:r><w:t>text</w:t></w:r>
<w:commentRangeEnd w:id="0"/>
<w:r><w:rPr><w:rStyle w:val="CommentReference"/></w:rPr><w:commentReference w:id="0"/></w:r>
```

### 图片

1. 放图片文件到 `word/media/`
2. 添加关系到 `word/_rels/document.xml.rels`：`<Relationship Id="rId5" Type=".../image" Target="media/image1.png"/>`
3. 添加内容类型到 `[Content_Types].xml`
4. 在 document.xml 引用：

```xml
<w:drawing>
  <wp:inline>
    <wp:extent cx="914400" cy="914400"/>  <!-- EMU: 914400 = 1 inch -->
    <a:graphic>
      <a:graphicData uri=".../picture">
        <pic:pic>
          <pic:blipFill><a:blip r:embed="rId5"/></a:blipFill>
        </pic:pic>
      </a:graphicData>
    </a:graphic>
  </wp:inline>
</w:drawing>
```

## Step 3: 打包

```bash
python scripts/office/pack.py unpacked/ output.docx --original document.docx
```

自动修复：
- `durableId` >= 0x7FFFFFFF（重新生成有效 ID）
- `<w:t>` 缺少 `xml:space="preserve"`

不修复：
- 格式错误的 XML、无效嵌套、缺失关系

用 `--validate false` 跳过验证。

## XML 规范

| 规则 | 说明 |
|------|------|
| `<w:pPr>` 内元素顺序 | pStyle, numPr, spacing, ind, jc, rPr 最后 |
| 空白 | 含前后空格的 `<w:t>` 加 `xml:space="preserve"` |
| RSID | 必须是 8 位十六进制 |
