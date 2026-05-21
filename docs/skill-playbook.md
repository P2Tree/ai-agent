# Skill 编队手册

> 不同工作场景下，如何将 skill 编组成队、协同作战。

## 使用说明

本指南按工作场景组织，每个场景给出：
- **流程** — skill 的调用顺序和触发时机
- **角色映射** — 每个 skill 在真实团队中扮演什么角色
- **配合机制** — skill 之间如何衔接、数据如何流转
- **变体** — 根据情况调整流程的提示

流程中的箭头 `→` 表示顺序执行，`+` 表示可并行或可按需穿插。

## 0. 初始化仓库

对于任何未运行过本系列 skills 的新仓库，无论是全新的仓库，还是已经在开发的仓库，都建议先执行一次 **init-agent-environment** 来初始化环境。

它会自动读取现有代码和配置（若存在），分析其中的主要流程和关键字，然后与你进行几个问题的讨论，最后生成一些参考资料和路径（领域词汇表、ADR 索引、issue tracker 配置等）。后续的 writing-plans、improve-architecture、decomposing-issues 等 skill 会参考这些文件来工作。

## 你的软件开发团队成员

| Skill | 扮演角色 | 一句话描述 |
|-------|---------|-----------|
| brainstorming | 需求分析师 | 引导澄清模糊想法，追问直到可设计 |
| writing-prd | 产品经理 | 将讨论结论综合为需求说明书 |
| writing-plans | 技术负责人 | 制定可执行的实施计划，拆到每步可验证 |
| decomposing-issues | 项目经理 | 将计划拆为可认领的任务卡片，排好依赖 |
| executing-plans | 工程师 | 按计划逐任务开发，带 review checkpoint |
| finishing-branch | 发布工程师 | 验证测试、选择合并策略、清理分支 |
| diagnose | 调试专家 | 系统化定位根因：复现→假设→插桩→修复 |
| tdd | 严守纪律的工程师 | 红-绿-重构，每次一个测试-实现对 |
| code-review | 资深审查者 | 四阶段审查，不确定的多问少断 |
| improve-architecture | 架构师 | 扫描架构摩擦，提出加深模块的重构建议 |
| prototype | 预研工程师 | 做 throwaway 验证，答案留下、代码扔掉 |
| frontend-design | UI 设计师 | 做有个性的前端界面，拒绝千篇一律的 AI 风格 |
| arch-doc | 架构文档工程师 | 从代码生成或对齐架构设计说明 |
| coauthoring | 写作搭档 | 协作撰写文章，保留用户声音而非代笔 |
| work-report | 行政助理 | 按模板生成结构化工作报告 |
| grill-me | 评审委员会 | 逐个问题逼问方案，走完决策树每个分支 |
| triage | 缺陷分流员 | 对新 issue 分类、标记、分配 |
| zoom-out | 导航员 | 上升一层给出模块地图和调用关系 |
| init-agent-environment | 项目接入负责人 | 配置项目环境，建立领域词汇和 ADR 索引 |

---

## 1. 需求不明确的想法落地

从模糊的想法到可执行的实现计划。

```
brainstorming → writing-prd → decomposing-issues → writing-plans → executing-plans → code-review → finishing-branch
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 探索 | **brainstorming** | 需求分析师 | 逐个问题澄清意图，提出 2-3 个方案及权衡 | `docs/specs/` 下的设计文档 |
| 定义 | **writing-prd** | 产品经理 | 将讨论结论综合为 PRD，不经再采访 | PRD 发布到 issue tracker |
| 分发 | **decomposing-issues** | 项目经理 | 将 PRD 拆为 tracer-bullet 垂直切片，发布到 issue tracker | 带依赖关系的 issue 列表 |
| 计划 | **writing-plans** | 技术负责人 | 对每个 issue 制定 bite-sized 实施步骤，每步可验证 | `docs/plans/` 下的实施计划 |
| 执行 | **executing-plans** | 工程师 | 逐任务执行，每个任务完成有 review checkpoint | 代码提交 |
| 审查 | **code-review** | 资深审查者 | 审查代码正确性、是否满足 PRD 要求 | Review 结论 |
| 收尾 | **finishing-branch** | 发布工程师 | 验证测试通过，选择合并/PR/保留 | 分支合并 |

**配合要点：**
- brainstorming 有硬门禁：设计不批准，不进 writing-prd
- brainstorming 的终端状态就是调用 writing-plans，但如果需要先出 PRD 给团队评审，先走 writing-prd
- decomposing-issues 先将 PRD 拆成可认领的垂直切片 issue，writing-plans 再对具体 issue 制定实施步骤——先定"做什么"，再定"怎么做"
- writing-plans 的产出是 executing-plans 的输入，计划文件头部明确标注了 `Use executing-plans to implement`
- executing-plans 有三种模式：inline（单人小计划）、subagent-driven（中等计划）、parallel（独立子系统的多任务）

**变体：**
- 想法已经清晰，不需要头脑风暴：直接从 writing-prd 开始
- 个人项目不需要 PRD 和 issue 拆分：brainstorming → writing-plans → executing-plans
- 需要先验证技术可行性：在 brainstorming 后插入 **prototype**（预研工程师介入）

---

## 2. 明确问题或 Bug 的排查

从已知问题到根因定位和修复。

```
diagnose → tdd（修复时）→ code-review → finishing-branch
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 定位 | **diagnose** | 调试专家 | 建立反馈环→复现→假设→插桩→修复→回归测试→清理 | 根因假设、插桩代码 |
| 修复 | **tdd** | 严守纪律的工程师 | 红-绿-重构循环写修复代码 | 通过的测试 + 修复代码 |
| 审查 | **code-review** | 资深审查者 | 审查修复是否正确、是否引入新问题 | Review 结论 |
| 收尾 | **finishing-branch** | 发布工程师 | 验证并合并 | 分支合并 |

**配合要点：**
- diagnose 的 Phase 5 就要求"有正确 seam 时先写测试再修复"，这与 tdd 天然衔接
- 如果 bug 简单明确，diagnose 可能在 Phase 4 就给出修复，不需要走完整 tdd 流程
- diagnose 的 Phase 6（Cleanup + post-mortem）可能发现架构改进机会，可衔接到 **improve-architecture**（架构师介入）

**变体：**
- 性能回退：同样走 diagnose，Phase 3 假设聚焦在性能层面
- bug 涉及安全漏洞：在 code-review 阶段重点关注安全审查
- 复现困难：diagnose Phase 1 重点用 HITL bash 脚本或最小复现代码建立反馈环

---

## 3. 新项目代码库熟悉

刚接触一个项目，快速建立心智模型。

```
zoom-out + improve-architecture
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 全景 | **zoom-out** | 导航员 | 上升一层抽象，给出模块地图和调用关系 | 模块全景图 |
| 深入 | **improve-architecture** | 架构师 | 识别架构摩擦点（浅模块、耦合、缺少局部性） | 架构改进候选列表 |

**配合要点：**
- zoom-out 和 improve-architecture 可并行使用：zoom-out 给出"是什么"，improve-architecture 给出"哪里有问题"
- zoom-out 使用项目领域词汇，这些词汇来自第 0 节初始化建立的 `CONTEXT.md`

**变体：**
- 只需要快速了解某个模块：单独用 zoom-out
- 需要了解项目某部分的实现细节：zoom-out 定位后，直接读代码
- 接手项目的同时要修 bug：zoom-out → diagnose

---

## 4. 完善测试用例与搭建测试环境

为已有代码补充测试覆盖或从零搭建测试基础设施。

```
tdd（新增测试时）+ prototype（环境搭建时）→ code-review
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 设计 | **tdd** | 严守纪律的工程师 | 规划接口变更和待测行为，识别深模块机会 | 测试计划 |
| 验证环境 | **prototype** | 预研工程师 | 如果测试基础设施不确定，先做个 throwaway 验证 | 技术选型结论 |
| 实现 | **tdd** | 严守纪律的工程师 | 红-绿-重构循环，每次一个测试-实现对 | 测试 + 代码 |
| 审查 | **code-review** | 资深审查者 | 审查测试质量：测的是行为还是实现细节 | Review 结论 |

**配合要点：**
- tdd 强调垂直切片（一次一个测试-实现对），不是水平切片（先写完所有测试再写实现）
- 如果测试环境涉及复杂基础设施（容器、mock 服务、CI pipeline），先用 prototype 验证可行性
- prototype 的原则是 throwaway——验证完毕后删除，结论记入 commit/ADR/issue

**变体：**
- 补充已有代码的测试：tdd，但先确认接口是否可测，必要时先重构
- 搭建全新测试框架：prototype 验证技术选型 → writing-plans 制定搭建计划 → executing-plans 执行
- 测试涉及 UI：prototype 可以快速验证 UI 测试方案

---

## 5. 重构现有项目

改善代码结构而不改变行为。

```
improve-architecture → writing-plans → tdd（每步重构时）→ executing-plans → code-review → finishing-branch
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 诊断 | **improve-architecture** | 架构师 | 扫描架构摩擦，识别"加深模块"机会 | 改进候选列表 |
| 计划 | **writing-plans** | 技术负责人 | 将重构拆为 bite-sized 步骤，每步可验证 | 实施计划 |
| 保护 | **tdd** | 严守纪律的工程师 | 重构前先写测试保护现有行为，然后用红-绿-重构循环 | 测试网 |
| 执行 | **executing-plans** | 工程师 | 逐任务执行重构 | 重构后的代码 |
| 审查 | **code-review** | 资深审查者 | 确认行为未变、结构改善 | Review 结论 |
| 收尾 | **finishing-branch** | 发布工程师 | 验证并合并 | 分支合并 |

**配合要点：**
- improve-architecture 的输出（改进候选列表）是 writing-plans 的输入
- tdd 在重构中的角色是"安全网"——先写测试确认行为，再重构，再确认测试通过
- 重构时 tdd 的 refactor 阶段是核心动作，不是写新功能
- code-review 重点审查：行为是否改变、重构是否达到预期效果

**变体：**
- 小范围重构：不需要 improve-architecture，直接 tdd 保护 + 手动重构
- 重构涉及跨模块接口变更：先 prototype（预研工程师）验证新接口设计
- 重构后需要更新文档：**arch-doc**（架构文档工程师）对齐架构说明

---

## 6. 新项目预研

探索技术方案，评估可行性。

```
brainstorming → prototype → writing-prd（如果可行）→ arch-doc
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 探索 | **brainstorming** | 需求分析师 | 澄清预研目标，提出候选方案 | 方案对比 |
| 验证 | **prototype** | 预研工程师 | 对候选方案做 throwaway 原型验证 | 可行性结论 |
| 定义 | **writing-prd** | 产品经理 | 如果验证通过，将结论整理为 PRD | PRD |
| 文档 | **arch-doc** | 架构文档工程师 | 生成架构设计文档 | 架构说明 |

**配合要点：**
- prototype 核心原则：throwaway from day one。答案记入 commit/ADR/issue 后删除原型
- prototype 根据问题类型选分支：逻辑/状态模型走终端交互原型，UI 走多方案切换原型
- 预研阶段不需要 executing-plans，因为还没有到实施阶段

**变体：**
- 预研只为了否决方案：prototype 验证不可行即可，不需要 writing-prd
- 预研结果需要给团队汇报：**coauthoring**（写作搭档）写技术分析文章，或 **pptx** 做演示
- 多个方案并行验证：每个方案一个 prototype，对比后决策

---

## 7. 编写技术文档

产出各类技术文档。

```
arch-doc（架构文档）| coauthoring（技术文章）| work-report（工作报告）| writing-prd（需求文档）| writing-plans（实施计划）
```

| 文档类型 | Skill | 角色 | 适用场景 |
|---------|-------|------|---------|
| 架构设计说明 | **arch-doc** | 架构文档工程师 | 新项目架构设计、现有架构对齐、架构变更更新 |
| 技术博客/文章 | **coauthoring** | 写作搭档 | 技术分享、方案阐述、经验总结 |
| 工作报告 | **work-report** | 行政助理 | 日报/周报/月报/季度报告/年度总结/转正/晋升 |
| PRD | **writing-prd** | 产品经理 | 产品需求文档 |
| 实施计划 | **writing-plans** | 技术负责人 | 详细的实施步骤文档 |

**配合要点：**
- arch-doc 有两种模式：新建模式（从代码生成文档）和对齐模式（现有文档与代码对照，最小改动更新）
- coauthoring 强调保留用户的声音和观点，AI 是协作者不是代笔者
- work-report 按报告类型自动选择模板和粒度，面向领导的报告偏宏观，面向团队的可偏技术

**变体：**
- 架构文档需要导出为 Word：arch-doc 生成后，**docx** 处理
- 技术文章需要配图：coauthoring + **pptx** 做示意图
- 周报需要数据支撑：**xlsx** 处理数据后填入 work-report 模板

---

## 8. 前端开发

构建有个性的前端界面。

```
brainstorming → prototype（视觉方向探索）→ frontend-design + tdd → code-review → finishing-branch
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 探索 | **brainstorming** | 需求分析师 | 澄清交互目标、用户场景、视觉偏好 | 设计文档 |
| 方向 | **prototype** | 预研工程师 | 生成多个视觉方向的原型，用 URL 参数切换对比 | 选定的视觉方向 |
| 实现 | **frontend-design** | UI 设计师 | 按选定方向实现生产级界面：大胆字体、有冲击力配色、意料之外的布局 | 前端代码 |
| 保障 | **tdd** | 严守纪律的工程师 | 为交互逻辑和状态管理写测试 | 测试代码 |
| 审查 | **code-review** | 资深审查者 | 审查代码质量、可访问性、响应式适配 | Review 结论 |
| 收尾 | **finishing-branch** | 发布工程师 | 验证并合并 | 分支合并 |

**配合要点：**
- frontend-design 的核心原则是"有个性，不要千篇一律的 AI 风格"——强调大胆视觉方向，拒绝 Inter/Roboto 字体、紫色渐变、可预测布局
- prototype 在前端开发中特别关键：快速生成 2-3 个视觉方向变体供对比选择，避免实现到一半才发现方向不对
- brainstorming 和 prototype 之间可能需要多轮迭代——选一个方向后觉得不满意，回退重新探索
- tdd 在前端中聚焦交互逻辑和状态管理，不测 CSS 细节

**变体：**
- 小改动（改个按钮/调整布局）：直接 frontend-design，不需要 brainstorming 和 prototype
- 已有设计稿，只需实现：跳过 brainstorming 和 prototype，直接 frontend-design
- 纯后端工程师不熟悉前端：prototype 先验证技术可行性（框架选型、组件库），再进入实现
- 前端 bug：diagnose（调试专家）定位 → frontend-design 修复

---

## 9. 代码审查

审查他人的代码变更。

```
code-review（+ grill-me 如果需要深入讨论）
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 审查 | **code-review** | 资深审查者 | 四阶段审查：上下文→高层→逐行→总结 | Review 结论 |
| 深入 | **grill-me** | 评审委员会 | 如果发现设计问题，与作者深入讨论 | 共识 |

**配合要点：**
- code-review 是主 skill，grill-me 是可选的后续——当审查发现需要深入讨论的设计决策时
- 如果审查发现架构问题 → 后续可接 **improve-architecture**（架构师介入）
- 如果审查发现 bug → 后续可接 **diagnose**（调试专家介入）

---

## 10. 技术方案评审与压力测试

对已有方案进行质询。

```
grill-me → prototype（如果需要验证）
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 质询 | **grill-me** | 评审委员会 | 逐个问题逼问方案，走完决策树每个分支 | 被检验过的方案 |
| 验证 | **prototype** | 预研工程师 | 对存疑的技术点做 throwaway 验证 | 验证结论 |

**配合要点：**
- grill-me 的问题如果能通过读代码回答，会自动去探索代码而非直接问用户
- grill-me 不只用于方案评审，也适用于面试准备、架构决策、迁移方案等任何需要"想清楚"的场景

---

## 11. Issue 管理与任务分发

管理项目任务流。

```
triage → decomposing-issues
```

| 阶段 | Skill | 角色 | 做什么 | 产出 |
|------|-------|------|--------|------|
| 分流 | **triage** | 缺陷分流员 | 对 unlabeled issue 分类、分配 | 标记好的 issue |
| 拆分 | **decomposing-issues** | 项目经理 | 将大 issue 拆为垂直切片 | 带依赖的子 issue |

**配合要点：**
- triage 是入口——所有新 issue 先分流再处理
- decomposing-issues 拆分时使用 tracer-bullet（垂直切片）而非水平分层
- triage 的 `ready-for-agent` 标签的 issue 可以交给其他流程（如 Bug 排查、想法落地）处理

---

## 全景速查表

| 工作场景 | 推荐流程 |
|---------|---------|
| 仓库初始化（前置） | init-agent-environment(项目接入负责人) |
| 模糊想法落地 | brainstorming(需求分析师) → writing-prd(产品经理) → decomposing-issues(项目经理) → writing-plans(技术负责人) → executing-plans(工程师) → code-review(资深审查者) → finishing-branch(发布工程师) |
| Bug 排查 | diagnose(调试专家) → tdd(工程师) → code-review(资深审查者) → finishing-branch(发布工程师) |
| 新项目熟悉 | zoom-out(导航员) + improve-architecture(架构师) |
| 补测试/搭环境 | prototype(预研工程师) + tdd(工程师) → code-review(资深审查者) |
| 项目重构 | improve-architecture(架构师) → writing-plans(技术负责人) → tdd(工程师) → executing-plans(工程师) → code-review(资深审查者) → finishing-branch(发布工程师) |
| 新项目预研 | brainstorming(需求分析师) → prototype(预研工程师) → writing-prd(产品经理) → arch-doc(架构文档工程师) |
| 前端开发 | brainstorming(需求分析师) → prototype(预研工程师) → frontend-design(UI 设计师) + tdd(工程师) → code-review(资深审查者) → finishing-branch(发布工程师) |
| 架构文档 | arch-doc(架构文档工程师) |
| 技术文章 | coauthoring(写作搭档) |
| 工作报告 | work-report(行政助理) |
| 代码审查 | code-review(资深审查者) + grill-me(评审委员会) |
| 方案评审 | grill-me(评审委员会) → prototype(预研工程师) |
| Issue 管理 | triage(缺陷分流员) → decomposing-issues(项目经理) |

## 贯穿性 Skill

以下 skill 不属于特定流程，但在任何场景中按需激活：

| Skill | 角色 | 何时用 |
|-------|------|--------|
| **frontend-design** | UI 设计师 | 任何需要构建前端界面的场景，确保产出不是千篇一律的 AI 风格 |
| **caveman** | 精简模式 | token 预算紧张时，压缩沟通节省 ~75% token |
| **grill-me** | 评审委员会 | 任何需要深入讨论或质询的决策点 |
| **prototype** | 预研工程师 | 任何需要快速验证技术假设的点 |
| **code-review** | 资深审查者 | 任何产出代码的流程的最终检查点 |
| **zoom-out** | 导航员 | 任何需要跳出现有视角看全局的时刻 |
