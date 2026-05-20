# 编辑详解

编辑现有 .xlsx 文件的两种方式：openpyxl API 和 XML 级编辑。

## 方式 A：openpyxl API

适合修改数据、公式、格式。

```python
from openpyxl import load_workbook

wb = load_workbook('existing.xlsx')
sheet = wb.active

# 修改单元格
sheet['A1'] = 'New Value'

# 插入/删除行列
sheet.insert_rows(2)
sheet.delete_cols(3)

# 添加工作表
new_sheet = wb.create_sheet('NewSheet')

wb.save('modified.xlsx')
```

**注意**：`data_only=True` 读取时返回计算值而非公式。如果用此模式保存，公式将永久丢失。

## 方式 B：XML 级编辑

适合需要保留所有格式和功能的模板编辑。

### Step 1: 解包

```bash
python scripts/office/unpack.py spreadsheet.xlsx unpacked/
```

### Step 2: 编辑 XML

XLSX 的 XML 结构位于 `unpacked/xl/` 下：

- `xl/worksheets/sheet1.xml`, `sheet2.xml` ... — 工作表内容
- `xl/workbook.xml` — 工作簿定义
- `xl/sharedStrings.xml` — 共享字符串表
- `xl/styles.xml` — 样式定义
- `xl/media/` — 嵌入媒体

在 sheet XML 中定位内容，用 Edit 工具直接替换。

### Step 3: 清理

```bash
python scripts/clean.py unpacked/
```

### Step 4: 打包

```bash
python scripts/office/pack.py unpacked/ output.xlsx --original spreadsheet.xlsx
```

## pandas 快速编辑

适合数据清洗和批量操作：

```python
import pandas as pd

df = pd.read_excel('file.xlsx')
# 修改数据
df['New'] = df['A'] * 2
df.to_excel('output.xlsx', index=False)
```

**注意**：pandas 读写会丢失公式、格式、图表。仅用于纯数据操作。
