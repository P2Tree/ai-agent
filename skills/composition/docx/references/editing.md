# 编辑文档详解

编辑现有 `.docx`：解包 → 合并 run → 编辑 XML → 打包 → 校验。

## Step 1: 解包与清理

```bash
unzip -q document.docx -d unpacked/
find unpacked -type l -delete   # 外部 docx 不可信，删除符号链接
python scripts/merge_runs.py unpacked/
```

`merge_runs.py` 合并 `word/document.xml` 中相邻、同格式的 run，不改变内容或渲染。Word 会把可见文本拆成多个 `<w:r>`（revision id、拼写标记），不合并的话搜索不到连续短语。也接受 `.docx` 直连：`python scripts/merge_runs.py doc.docx -o merged.docx`。

## Step 2: 编辑 XML

直接编辑 `unpacked/word/` 下的文件。**用 Edit 工具直接替换，不要写 Python 脚本。不要重排或 pretty-print。**

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

规则：

- 替换整个 `<w:r>`，不在 run 内插入修订标签。
- 复制原 run 的 `<w:rPr>` 到修订 run 中保持格式。
- `<w:del>` 内用 `<w:delText>` 代替 `<w:t>`。
- 只标记变更部分，不标记未变内容。
- 校验：`validate.py out.docx --original doc.docx --author "Claude"` 会报告任何未被 `<w:ins>`/`<w:del>` 包住的改动——这类遗漏在"接受修订"视图里不可见。

### 删除整段

同时删除段落标记，否则接受修订后留空段：

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

`<w:del/>` 必须位于 rPr 其他子元素之前；schema 强制这个顺序。

### 接受全部修订

```bash
python scripts/accept_changes.py in.docx out.docx
```

被删段落标记应把该段与下一段合并，所以所有 run 都被删除的段落会消失。`accept_changes.py`（LibreOffice）通常正确，但被删段落后紧跟空占位段时不会；`pandoc --track-changes=accept` 从不合并段落。空项目符号是视图 artifact，不是文档缺陷——检查 XML 中的段落删除。

### 拒绝他人插入

```xml
<w:ins w:author="Jane" w:id="5">
  <w:del w:author="Claude" w:id="10">
    <w:r><w:delText>their text</w:delText></w:r>
  </w:del>
</w:ins>
```

### 恢复他人删除

```xml
<w:del w:author="Jane" w:id="5">
  <w:r><w:delText>deleted text</w:delText></w:r>
</w:del>
<w:ins w:author="Claude" w:id="10">
  <w:r><w:t>deleted text</w:t></w:r>
</w:ins>
```

### 注释

```bash
# 已解包目录（同时放标记时优先）
python scripts/comment.py unpacked/ "Comment text"
python scripts/comment.py unpacked/ "Reply text" --parent 0

# 直接处理 .docx
python scripts/comment.py contract.docx "Text" -o annotated.docx
```

脚本写六个交叉链接文件并自动分配 ID，然后打印要加入 `word/document.xml` 的标记。标记是 `<w:p>` 的直接子元素，不在 `<w:r>` 内：

```xml
<w:commentRangeStart w:id="0"/>
<w:r><w:t>text</w:t></w:r>
<w:commentRangeEnd w:id="0"/>
<w:r><w:rPr><w:rStyle w:val="CommentReference"/></w:rPr><w:commentReference w:id="0"/></w:r>
```

不放这些标记，注释存在但不可见。

### 图片

1. 图片文件放到 `word/media/`。
2. 在 `word/_rels/document.xml.rels` 加关系：`<Relationship Id="rId5" Type=".../image" Target="media/image1.png"/>`。
3. 在 `[Content_Types].xml` 加内容类型。
4. 在 `document.xml` 引用：

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

## Step 3: 打包与校验

```bash
(cd unpacked && rm -f ../output.docx && zip -XrD ../output.docx .)
python scripts/office/validate.py output.docx --original document.docx
```

`-X` 去掉额外属性，`-r` 递归，`-D` 不写目录条目（部分云协作服务会拒绝带目录条目的文件）。`--auto-repair` 修复常见问题；`--original` 用于对比原始文件；redlining 时再加 `--author`。

## XML 规范

| 规则 | 说明 |
|------|------|
| `<w:pPr>` 内元素顺序 | pStyle, numPr, spacing, ind, jc, rPr 最后 |
| 空白 | 含前后空格的 `<w:t>` 加 `xml:space="preserve"` |
| RSID | 必须是 8 位十六进制 |
| 修订标记顺序 | `<w:del/>` 位于 rPr 其他子元素之前 |
