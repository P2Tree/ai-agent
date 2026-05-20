# 表单填写

PDF 表单填写流程，区分可填写表单和不可填写表单。

## 可填写表单

### 1. 检查是否有可填写字段

```bash
python scripts/check_fillable_fields.py file.pdf
```

### 2. 提取字段信息

```bash
python scripts/extract_form_field_info.py input.pdf field_info.json
```

输出 JSON 格式：

```json
[
  {
    "field_id": "last_name",
    "page": 1,
    "rect": [left, bottom, right, top],
    "type": "text"
  },
  {
    "field_id": "Checkbox12",
    "page": 1,
    "type": "checkbox",
    "checked_value": "/On",
    "unchecked_value": "/Off"
  },
  {
    "field_id": "gender",
    "page": 1,
    "type": "radio_group",
    "radio_options": [
      { "value": "/M", "rect": [...] },
      { "value": "/F", "rect": [...] }
    ]
  },
  {
    "field_id": "country",
    "page": 1,
    "type": "choice",
    "choice_options": [
      { "value": "US", "text": "United States" },
      { "value": "CN", "text": "China" }
    ]
  }
]
```

### 3. 分析表单

将 PDF 转为图片确定每个字段用途：

```bash
python scripts/convert_pdf_to_images.py file.pdf images/
```

### 4. 创建字段值文件

```json
[
  { "field_id": "last_name", "description": "姓氏", "page": 1, "value": "Zhang" },
  { "field_id": "Checkbox12", "description": "是否成年", "page": 1, "value": "/On" }
]
```

### 5. 填写

```bash
python scripts/fill_fillable_fields.py input.pdf field_values.json output.pdf
```

脚本会验证字段 ID 和值的有效性。

## 不可填写表单

### 方法 A：结构提取（优先）

提取文本标签、线条、复选框及其精确坐标：

```bash
python scripts/extract_form_structure.py input.pdf form_structure.json
```

根据提取的标签位置计算填写坐标，创建 fields.json：

```json
{
  "pages": [{ "page_number": 1, "pdf_width": 612, "pdf_height": 792 }],
  "form_fields": [
    {
      "page_number": 1,
      "description": "姓氏",
      "field_label": "Last Name",
      "label_bounding_box": [43, 63, 87, 73],
      "entry_bounding_box": [92, 63, 260, 79],
      "entry_text": { "text": "Zhang", "font_size": 10 }
    }
  ]
}
```

验证边界框：`python scripts/check_bounding_boxes.py fields.json`

### 方法 B：视觉估算（扫描件）

1. 转为图片：`python scripts/convert_pdf_to_images.py input.pdf images/`
2. 查看图片估算字段位置
3. 用 ImageMagick 裁剪放大精确定位：
   ```bash
   magick images/page_1.png -crop 300x80+50+120 +repage crops/name.png
   ```
4. 创建 fields.json（用 `image_width`/`image_height` 标记图片坐标系）

### 混合方法

结构提取覆盖大部分字段，视觉估算补充遗漏的（圆形复选框等）。需将图片坐标转换为 PDF 坐标：

```
pdf_x = image_x * (pdf_width / image_width)
pdf_y = image_y * (pdf_height / image_height)
```

### 填写

```bash
python scripts/fill_pdf_form_with_annotations.py input.pdf fields.json output.pdf
```

脚本自动检测坐标系并处理转换。

### 验证

```bash
python scripts/convert_pdf_to_images.py output.pdf verify/
# 检查文本位置是否正确
```
