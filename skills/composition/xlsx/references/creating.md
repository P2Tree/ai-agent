# 创建详解

openpyxl 从零创建 XLSX 电子表格。`openpyxl` 已预装，不要先 `pip install`。

## 关键 gotchas

- **读模型要两次加载**：`data_only=True` 有值无公式，默认有公式无值；`data_only=True` 后保存会把公式永久替换成字面量。
- **刚写出的文件用 `data_only=True` 全是 `None`**，先跑 `recalc.py`。
- **合并单元格只写左上锚点**；其余是只读 `MergedCell`。
- **`.xlsm` 加 `keep_vba=True`**，否则丢宏。
- **含空格的 sheet 名跨表引用要加引号**：`='Assumptions Inputs'!$B$5`。
- **每个新公式单独设 `number_format`**，否则日期显示成 `45337`、30% 显示成 `0.3`。
- **部分加粗/斜体需要 `load_workbook(rich_text=True)`**，此时 `.value` 是 `CellRichText`。
- **新图表**：`roundedCorners=False`；legend/title 的 `.overlay=False`；有坐标轴时 `x_axis.delete=False`、`y_axis.delete=False`；`DateAxis` 设 `y_axis.crossAx=500`。
- **公式兼容性**：优先 2007 时代函数；`TEXTJOIN`/`CONCAT`/`IFS`/`SWITCH`/`MAXIFS`/`MINIFS` 必须加 `_xlfn.` 前缀；禁用 `XLOOKUP`/`XMATCH`/`SORT`/`FILTER`/`UNIQUE`/`SEQUENCE`。

## 基本结构

```python
from openpyxl import Workbook

wb = Workbook()
sheet = wb.active
sheet.title = "Sheet1"

sheet['A1'] = 'Hello'
sheet['B1'] = 'World'
sheet.append(['Row', 'of', 'data'])

wb.save('output.xlsx')
```

## 数据写入

```python
# 单元格赋值
sheet['A1'] = 'Label'
sheet['B1'] = 42

# 追加行
sheet.append(['Col1', 'Col2', 'Col3'])

# 批量写入
for row in data:
    sheet.append(row)
```

## 公式

```python
sheet['B10'] = '=SUM(B2:B9)'
sheet['C5'] = '=(C4-C2)/C2'
sheet['D20'] = '=AVERAGE(D2:D19)'

# 跨工作表引用
sheet['A1'] = "=Sheet2!B5"

# 常用函数
'=IF(A1>0, "Yes", "No")'
'=VLOOKUP(A1, Sheet2!A:B, 2, FALSE)'
'=COUNTIF(A1:A100, ">0")'
```

## 格式化

```python
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side, numbers

# 字体
sheet['A1'].font = Font(bold=True, size=14, color='FF0000')

# 填充
sheet['A1'].fill = PatternFill('solid', fgColor='FFFF00')

# 对齐
sheet['A1'].alignment = Alignment(horizontal='center', vertical='center', wrap_text=True)

# 边框
thin = Side(style='thin')
sheet['A1'].border = Border(left=thin, right=thin, top=thin, bottom=thin)

# 数字格式
sheet['B1'].number_format = '$#,##0'
sheet['C1'].number_format = '0.0%'
sheet['D1'].number_format = '0.0x'
sheet['E1'].number_format = '$#,##0;($#,##0);"-"'

# 列宽 / 行高
sheet.column_dimensions['A'].width = 20
sheet.row_dimensions[1].height = 30
```

## 合并单元格

```python
sheet.merge_cells('A1:D1')
sheet['A1'] = 'Merged Header'
sheet['A1'].alignment = Alignment(horizontal='center')
```

## 工作表操作

```python
# 新建
ws = wb.create_sheet('NewSheet')

# 复制
ws = wb.copy_worksheet(wb['Sheet1'])

# 删除
del wb['Sheet1']

# 重命名
sheet.title = 'Revenue'
```

## 条件格式

```python
from openpyxl.formatting.rule import CellIsRule

sheet.conditional_formatting.add('B2:B100',
    CellIsRule(operator='greaterThan', formula=['100'],
              fill=PatternFill('solid', fgColor='FF0000')))
```

## 常见错误

| 错误 | 正确做法 |
|------|----------|
| 硬编码计算结果 | 用 Excel 公式 |
| data_only=True 保存 | 读取时可用，保存时会丢失公式 |
| 行列从 0 开始 | openpyxl 从 1 开始 |
| 忘记调列宽 | 设置 `column_dimensions` |
| NaN 写入 Excel | 用 `pd.notna()` 过滤 |
