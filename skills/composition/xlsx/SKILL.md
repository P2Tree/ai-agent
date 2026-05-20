---
name: xlsx
description: XLSX 电子表格处理 — 读取、创建、编辑、分析 .xlsx/.xlsm/.csv/.tsv 文件。Use when 用户提到电子表格、spreadsheet、.xlsx、.csv，或需要对表格数据做任何操作
disable-model-invocation: true
---

# XLSX 创建、编辑与分析

电子表格处理：读取分析、创建、编辑。包含财务模型规范和公式验证。

## 快速参考

| 任务 | 方式 |
|------|------|
| 数据分析 | pandas：`pd.read_excel()` → 分析 → `df.to_excel()` |
| 创建新文件 | openpyxl：`Workbook()` → 填数据/公式 → `wb.save()` |
| 编辑现有文件 | openpyxl：`load_workbook()` → 修改 → `wb.save()` |
| 编辑模板（XML 级） | 解包→改 XML→打包，见 [editing.md](references/editing.md) |
| 公式重算 | `python scripts/recalc.py output.xlsx` |

## 工作流

### 1. 选择工具

| 场景 | 工具 |
|------|------|
| 数据分析、批量操作、简单导出 | pandas |
| 公式、格式、Excel 特有功能 | openpyxl |
| 模板级修改（保留所有格式） | 解包→改 XML→打包 |

### 2. 创建 / 编辑

用 openpyxl 创建或编辑时：

**必须用公式而非硬编码值** — 所有计算用 Excel 公式（`=SUM(A1:A10)`），不要在 Python 中算好再写入。

```python
# 错误：硬编码
sheet['B10'] = 5000
# 正确：公式
sheet['B10'] = '=SUM(B2:B9)'
```

创建新文件见 [creating.md](references/creating.md)，财务模型规范见 [financial-models.md](references/financial-models.md)。

### 3. 公式重算（必须）

openpyxl 只保存公式字符串，不计算值。保存后必须重算：

```bash
python scripts/recalc.py output.xlsx
```

脚本自动配置 LibreOffice 宏、重算所有公式、扫描错误（#REF!、#DIV/0! 等），返回 JSON 结果。

### 4. 验证

- 重算脚本返回 `status: "success"` → 通过
- 返回 `errors_found` → 查看 `error_summary`，修复后重新重算
- 常见错误：#REF!（引用错误）、#DIV/0!（除零）、#VALUE!（类型错误）、#NAME?（公式名错误）

## 关键约束

| 规则 | 说明 |
|------|------|
| 用公式不要硬编码 | 所有计算用 Excel 公式，确保动态可更新 |
| 假设放在独立单元格 | 增长率、利润率等用单元格引用，不要写在公式里 |
| data_only=True 会丢失公式 | 读取时可用，保存时切勿使用 |
| 行号 1 起始 | openpyxl 行列从 1 开始，DataFrame 从 0 开始 |
| 重算后验证 | 每次保存后必须运行 recalc.py |

## 依赖

| 工具 | 用途 |
|------|------|
| openpyxl | 公式、格式、Excel 特有功能 |
| pandas | 数据分析、批量操作 |
| LibreOffice | 公式重算 |

## 参考

- [创建详解](references/creating.md) — openpyxl 完整用法
- [编辑详解](references/editing.md) — XML 编辑流程
- [财务模型](references/financial-models.md) — 配色、格式、公式规范
