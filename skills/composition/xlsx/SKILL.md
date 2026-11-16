---
name: xlsx
description: Spreadsheet processing — read, create, edit, analyze .xlsx/.xlsm/.csv/.tsv files, including formulas and financial models. Use when user mentions spreadsheets, .xlsx, .csv, or needs any tabular data operations
disable-model-invocation: true
---

# XLSX 创建、编辑与分析

| 任务 | 方式 |
|------|------|
| 创建/编辑公式与格式 | `openpyxl`，见下方 gotchas |
| 批量数据进出 | `pandas`（`read_excel`、`to_excel`） |
| 快速查看工作表 | `markitdown file.xlsx`（每个 sheet 一个 `## SheetName`；无单元格坐标，不要据此规划编辑） |
| 读取模型（公式和值都要） | 两次 `load_workbook`，见 gotchas |

> `openpyxl`、`pandas`、`markitdown` 已预装，不要先 `pip install`；导入失败或命令缺失时才安装。脚本路径相对本 skill 目录。

## 每个输出都必须满足

- **专业字体**（Arial、Times New Roman）贯穿全表，除非用户另有要求。
- **零公式错误。** `recalc.py` 报 `errors_found` 时不得交付（唯一例外见 `not_computed`）。怀疑错误是原有的，就证明它：用 `data_only=True` 读原始文件看那个单元格。
- **用公式，不用硬编码结果。** 写 `sheet['B10'] = '=SUM(B2:B9)'`，不要写 Python 算好的值。
- **严格按用户规格。** 精确的 tab 名、表头、用户写出的公式。重新设计成别的计算方式，再优雅也算失败。
- **记录每个假设和硬编码数字**，放在读者看得到的地方：单元格批注或表格末尾相邻单元格。有真实来源就引用（`Source: Company 10-K, FY2024, Page 45, Revenue Note, [URL]`）；来自用户就明说。
- **给他人填写的模板**需要简短图例说明哪些单元格可编辑，并给一行真实格式的示例值。**编辑现有文件时绝不能加示例行。**
- **编辑现有文件必须匹配其既有约定**，这覆盖本文所有规则。先找指定输入单元格（靠字体颜色、填充、底纹识别），只写那里，保留所有既有公式。

## 重算（有公式就必须做）

openpyxl 只写公式字符串，没有缓存值。重算前，任何读缓存值的工具（`pandas`、`data_only=True`、多数预览器）看到的都是 `None`。

```bash
python scripts/recalc.py output.xlsx [timeout_seconds]   # 默认 30
```

LibreOffice 在副本上计算，只把值写回你的文件，返回 JSON：`status`（`success`/`errors_found`）、`total_formulas`、`total_errors`、`error_summary`（每种错误最多列 100 个单元格，`locations_truncated` 表示截掉了多少——以 `total_errors` 为准）。修复后重跑。

- **JSON 带 `error` 键而不是 `status`，表示完全没有重算**，只有这种情况退出码非零。`errors_found` 退出码为 0，所以**干净退出不等于干净工作簿**。
- **重算通过只证明公式能求值，不证明算得对。** 范围差一或引用错行会得到干净但错误的文件。先写 2–3 个公式并核对该拉到的值，再铺满网格。
- **`not_computed` 列出 LibreOffice 无法求值的公式**，即使 `success` 也可能有：它不支持的函数（`_xlfn.XLOOKUP`、`_xlfn.LET` 等）或外部工作簿链接（`='[1]Returns'!$B$2`）。这些单元格保留旧值；openpyxl 保存后、Excel 打开前为空。依赖它们的公式会报 `#NAME?`，用 `IFERROR` 的会走回退值，且值可能过期——保留公式并告知用户。改 sheet XML 后，删除对应公式的 `<v>`；保留旧值会列在 `not_computed` 而不是报错。

## 选择能通过验证的公式

LibreOffice 支持函数少于 Excel；它无法求值的公式在 Excel 打开前没有值。

- **优先 Excel 2007 时代函数**：`SUMIFS`、`INDEX`、`MATCH`、`IFERROR`、`SUMPRODUCT`，无需前缀。
- **六个 2007 后函数必须加 `_xlfn.` 前缀**（openpyxl 原样写入 XML，而 Excel 内部存的就是带前缀的名字）：`_xlfn.TEXTJOIN`、`_xlfn.CONCAT`、`_xlfn.IFS`、`_xlfn.SWITCH`、`_xlfn.MAXIFS`、`_xlfn.MINIFS`。裸写会得到 `#NAME?`。
- **禁用 `XLOOKUP`、`XMATCH`、`SORT`、`FILTER`、`UNIQUE`、`SEQUENCE`。** LibreOffice 无法求值；能求值的版本也只填左上角，因为 openpyxl 写出的文件没有 spill 元数据。查找用 `INDEX`/`MATCH`，排序/筛选/去重在 Python 里做完再写入。
- 缺 `)` 会报 `unbalanced brackets`；参数不足（`=ROUND(A1)`）不报，LibreOffice 返回值，Excel 可能提示修复。

## openpyxl gotchas

- **读模型要两次加载**：`data_only=True` 得到缓存值但公式消失；默认得到公式字符串但没有值。一次拿不到两者。
- **`data_only=True` 后保存是破坏性的**：公式全被替换成字面量，永久丢失。
- **刚被 openpyxl 写过的文件用 `data_only=True` 全是 `None`** —— 先跑 `recalc.py`。公式结果为 `""` 时也读回 `None`。
- **合并单元格只写左上锚点**；其余是只读的 `MergedCell`。
- **`.xlsm` 不加 `keep_vba=True` 会丢宏。**
- **含空格的 sheet 名跨表引用必须加引号**：`='Assumptions Inputs'!$B$5`；不加得到 `#VALUE!`。
- **保存上传文件会丢文本框、形状和 slicers。** 先查 `xl/drawings/` 中 `<xdr:sp `（带空格）和 `xl/slicers/`；有就告知用户或直接改 sheet XML。
- **畸形工作簿不可修复**：数字格式引号未闭合、defined name 以 `=` 开头、重复或空表头，都会原样保存，Excel 可能提示修复。
- **部分加粗/斜体文本会被压平**，除非 `load_workbook(rich_text=True)`；此时 `.value` 是 `CellRichText` 而非 `str`。
- **每个新公式都要单独设 `number_format`**（日期、百分比、货币）；没有东西会自动推断，日期显示成 `45337`，30% 显示成 `0.3`。
- **每个新图表都要设 `chart.roundedCorners = False`、legend 和 title 的 `.overlay = False`，有坐标轴的（非饼图/圆环图）设 `chart.x_axis.delete = False` 和 `chart.y_axis.delete = False`**，否则 Excel 可能把标题/图例画到绘图区上、圆角化边框或不画坐标轴。
- **用 `DateAxis` 时设 `chart.y_axis.crossAx = 500`**，否则 Excel 可能提示修复。

## 财务模型

除非用户另行指定，或现有文件已经不同。

**颜色**：蓝色文本（`0,0,255`）表示硬编码输入和情景杠杆；黑色表示公式；绿色（`0,128,0`）表示跨 sheet 链接；红色（`255,0,0`）表示跨文件链接；黄色填充（`255,255,0`）表示关键假设和待填单元格。

**数字**：货币 `$#,##0`，单位写在表头（`Revenue ($mm)`）；零显示为 `-`，百分数也如此（`$#,##0;($#,##0);-`）；负数用括号；百分比 `0.0%`，**存小数**（`0.15` 渲染 `15.0%`；存 `15` 渲染 `1500.0%`）；估值倍数 `0.0x`；年份用文本（`"2024"`，不要 `2,024`）。

**结构**：每个假设一个独立带标签单元格，公式引用它（`=B5*(1+$B$6)`，绝不 `=B5*1.05`）；公式在所有预测期保持一致，单个被改单元格是最常见的静默错误；分母可能为零时加保护。

## 依赖

`openpyxl`、`pandas`、`markitdown`（pip，预装）· LibreOffice (`soffice`)

## 参考

- [创建详解](references/creating.md) — openpyxl 完整用法
- [编辑详解](references/editing.md) — XML 编辑流程
- [财务模型](references/financial-models.md) — 配色、格式、公式规范
- `scripts/` 与 `LICENSE.txt` 来自 anthropics/skills（Apache-2.0）
