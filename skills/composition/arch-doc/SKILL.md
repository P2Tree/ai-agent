---
name: arch-doc
description: "Use when the user asks to document, create, update, or align architecture design documentation for a software project. 当用户提到'编写架构说明文档'、'架构设计说明书'、'补充架构文档'、'对齐架构文档'、'更新架构说明'、'写一份架构设计'、'生成架构文档'时触发。"
---

# 架构设计说明书编写 Skill

指导如何系统性地为一个代码仓库编写、更新或补充架构设计说明书（Markdown 格式），确保文档准确反映代码实际状态，结构完整，信息有据。

## 核心原则

1. **代码即真相** — 文档中的每一个事实性陈述必须源于对源代码的阅读，而非猜测或记忆。对关键声明（类名、函数签名、数据结构布局），在文档中给出源文件路径以便溯源。无法从代码中确认的信息，标注"待确认"而不是猜测。
2. **先全量阅读，后结构化输出** — 必须先完成对代码库的全量探索，再开始编写文档。不要边读边写，避免信息碎片化。
3. **文档要活** — 架构文档不是一次性产物。文档结构与代码模块结构应保持对齐，并标注关键信息的源文件路径。
4. **具体优于笼统** — 适配方案要明确"用什么替换什么"，差异分析用对比表格，性能/精度目标填实际数值，不留空占位符。

## 输入确认

在开始前，确认以下输入信息（缺失项向用户确认或自行推断并标注）：

| # | 输入 | 是否必需 | 说明 |
|---|------|---------|------|
| 1 | **代码库路径** | 必需 | 本地代码路径，默认为当前工作目录 |
| 2 | **PRD / 需求文档** | 可选 | 产品需求文档，明确功能范围和验收条件 |
| 3 | **SPFS / 功能规格** | 可选 | 软件产品功能规格，列出各特性支持要求和优先级（P0/P1/P2） |
| 4 | **已有架构文档** | 可选 | 如项目中已有架构文档，阅读并标注差异 |
| 5 | **外部知识库** | 可选 | Confluence / Wiki / 内部文档等，用于交叉验证和补充 |

**PRD 与 SPFS 冲突时**：以 SPFS 为准，冲突条目用脚注标注。若均未提供，基于代码分析推断功能范围和优先级，并标注"推断来源，请确认"。

---

## 工作流程

```
Task Progress:
- [ ] Step 1: Explore the codebase (read-only)
- [ ] Step 2: Parse PRD/SPFS and external documents
- [ ] Step 3: Load template
- [ ] Step 4: Generate the architecture design document
- [ ] Step 5: Cross-validate and supplement
- [ ] Step 6: Review and output
```

### Step 1: Explore the codebase (read-only)

**必须先完成全部探索，再进入 Step 4 开始编写。**

→ 详见 [references/step1-explore.md](references/step1-explore.md)

### Step 2: Parse PRD/SPFS and external documents

→ 详见 [references/step2-parse-inputs.md](references/step2-parse-inputs.md)

### Step 3: Load template

→ 详见 [references/step3-template.md](references/step3-template.md)

### Step 4: Generate the architecture design document

严格按照 template.md 的章节顺序和格式生成文档。

→ 必选章节列表、可选章节和编写规范详见 [references/step4-generate.md](references/step4-generate.md)

### Step 5: Cross-validate and supplement

1. **与现有文档对比**：已有 README、设计文档、Confluence 页面等，逐一对比——补充缺失、以代码为准修正矛盾、吸收独有上下文。
2. **完整性自查**：核心模块、外部依赖、关键数据结构、CLI/API、术语表缩写是否都覆盖。
3. **一致性自查**：命名一致、数据流图与文字吻合、章节编号连续。

### Step 6: Review and output

输出完整 Markdown 文档，并在结尾给出简短的**风险摘要**（3 条以内最需要关注的风险点或待确认项）。

---

## 对齐模式（更新已有架构文档）

当用户要求"对齐架构文档"或"根据代码更新架构文档"时，使用以下流程替代 Step 4-6：

1. **先读文档，再读代码**：阅读现有架构文档，列出每个章节中涉及的关键声明（类名、函数签名、配置项、数据结构等）。
2. **逐一验证**：对每个声明，在代码中搜索验证。标注三类差异：
   - **过时**：文档描述的功能在代码中已不存在或已变更
   - **缺失**：代码中有但文档未记录的新功能/模块/接口
   - **矛盾**：文档与代码对同一事物的描述不一致
3. **精准更新**：仅修改有差异的部分，不要重写整个文档。使用 Edit 工具做最小化修改。
4. **新增内容对齐**：如果代码新增了模块或功能，参照文档现有风格补充对应章节。
5. **输出差异报告**：列出所有修改点的摘要，包括章节、修改类型（过时/缺失/矛盾）、具体变更。

---

## 质量检查清单

完成文档后，逐项检查：

- [ ] 每个模块章节都标注了源文件路径
- [ ] 架构图在等宽字体下可读
- [ ] 所有表格格式正确、列对齐
- [ ] 术语表覆盖了文档中所有缩写
- [ ] 代码中公开的 CLI 参数 / API / 环境变量在文档中完整列出
- [ ] 不支持的功能和已知限制已记录
- [ ] 无空话填充，每个章节有实质内容
- [ ] 性能/精度目标填有实际数值，无空占位符
- [ ] 同类系统对比使用表格，非纯文字描述
- [ ] 修订历史表格已填写
