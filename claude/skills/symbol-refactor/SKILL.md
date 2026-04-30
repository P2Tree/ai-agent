---
name: symbol-refactor
description: >
  当需要对 Rust 代码中的任何符号（struct、trait、enum、function、variable、module、constant、type alias 等）进行重命名、删除或修改时触发。触发场景包括但不限于：rename X to Y, delete unused struct, remove the enum, rename function, extract method, inline variable, add a new field to struct, split struct into two, extract module, merge enums, delete dead code, remove unused import, add parameter to function, change return type, rename type, promote to a separate module, 删除 trait, 删除 unused struct, 重命名枚举, 提取函数, 删除 dead code。
  确保对代码、测试和文档的完整覆盖——编辑之前必先扫描。
---

# Symbol Refactor

当重命名、删除或修改某个符号时，最常见的失败模式是**引用覆盖不完整**——代码编译通过但测试或文档静默出错。这个 skill 强制执行 scan-first, sync-always 工作流。

## 核心原则

> **先扫描，再编辑，始终同步。**

适用于所有类型的符号变更：
- 重命名 struct/enum/type/function
- 删除无用的 function/variable/field
- 提取代码为新的 function/module
- 内联 variable 或 function
- 添加/删除/重命名 function 参数
- 修改类型签名
- 删除 import
- 拆分或合并类型

## Step 1: 扫描 — 找到所有引用

在修改任何内容之前，枚举符号的所有出现形式：

### 对于类型（struct, enum, trait, type alias）

```bash
# 精确匹配
grep -rn "SymbolName" src/ tests/ docs/ --include="*.rs"

# trait 对象
grep -rn "dyn SymbolName" src/
grep -rn "Box<dyn SymbolName>" src/

# 引用
grep -rn "&SymbolName\|&mut SymbolName" src/

# trait 实现
grep -rn "impl SymbolName" src/

# 工厂函数
grep -rn "select_\|create_\|new_" src/ | grep -i SymbolName
```

### 对于函数

```bash
grep -rn "fn_name\|symbol_name" src/ tests/ --include="*.rs"
grep -rn "symbol_name\s*(" src/ tests/ --include="*.rs"
```

### 对于变量/字段

```bash
grep -rn "field_name\|var_name" src/ tests/ --include="*.rs"
```

### 记录影响范围

扫描完成后，记录：
- 哪些文件引用了这个符号？
- 哪些引用在代码中、测试中还是文档中？
- 变更的范围是局部还是广泛？

确认扫描完整后再开始编辑。

## Step 2: 编辑 — 执行变更

### 重命名

替换所有出现。用 `replace_all` 处理相同模式。手动修复近似匹配（如 `backend` vs `Backend`）。

### 删除

1. 删除定义
2. 修复每个引用点——删除引用或替换
3. 删除 struct/enum 字段时：检查所有 `match`、struct literal 和解构点

### 添加 / 修改

1. 添加或修改符号
2. 更新所有调用点
3. 添加新字段/参数时：更新所有构造点

### 提取

1. 创建新符号（function, struct, module）
2. 用对新符号的调用替换原代码
3. 移动相关测试

## Step 3: 验证编译

```bash
cargo check
```

重复直到干净。遗漏的引用会在这里暴露——如果 Step 1 跳过了某些文件，现在会发现。

## Step 4: 同步测试

测试按名称引用符号。变更后检查：

- 重命名与旧符号名匹配的测试函数
- 更新引用旧名称或旧值的测试断言
- 为新行为添加测试
- 删除为已删除行为保留的测试

```bash
cargo test
```

如果测试引用了你重命名或删除的符号，它会失败。这正是重点——修复它。

## Step 5: 同步文档

文档是变更的一部分，不是可选的。

### 检查所有文档文件

```bash
grep -rn "OldName" docs/ --include="*.md"
```

更新：
- 代码示例中的类型名
- 提及符号的章节标题
- 模块描述
- README 文件
- 架构文档

## Step 6: 最终验证

```bash
# 确认旧名称已从代码中消失
grep -rn "OldName" src/ tests/ docs/

# 确认构建干净
cargo build

# 确认测试通过
cargo test
```

旧名称零匹配，构建干净，测试全部通过。

## 常见陷阱

| 陷阱 | 预防 |
|------|------|
| 遗漏 `Box<dyn T>` 或 `&dyn T` | 始终 grep `dyn ` 和 `Box<` |
| 忘记测试名称 | 测试函数名常与符号名匹配 |
| 文档不同步 | 文档与代码在同一个 PR 中更新，不延迟 |
| 重复定义 | 编辑后检查 `impl TypeName` 或 `fn name` 是否出现多次 |
| 近似匹配遗漏 | `replace_all` 会遗漏相似但不同的字符串——手动检查 |
| 遗漏跨文件引用 | 始终扫描 `tests/` 和 `docs/`，不只是 `src/` |

## 禁止事项

- 编辑前不扫描所有引用。扫描不是可选的。
- 不跳过 `cargo check`——编译错误告诉你遗漏了什么。
- 不跳过测试——测试捕获命名不匹配和损坏的断言。
- 不推迟文档更新——过时的文档等同于损坏的文档。
- 不假设一次 grep 就够。用多种模式。检查每种文件类型。
