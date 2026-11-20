# Skill 编队手册

> 不同工作场景下，如何把 skill 编组成队、协同作战。

## 使用说明

- `→` 表示顺序执行，`+` 表示可按需穿插或并行。
- **默认主流程**覆盖大多数 feature 开发；其他场景是在主流程上插入或替换某几步。
- 每个 skill 条目都写清「什么时候用」和「什么时候不用」，避免为了走流程而走流程。
- **作者与审查者必须分离**：写代码的 agent 不审查自己的代码；审查方式（fresh subagent / 单独会话 / inline 自查）由用户选择，inline 自查必须标注为 self-review。

## 0. 核心原则

### AI 加速的瀑布式

AI 把「写代码」的成本压低了，瓶颈转移到**想清楚、做决策、审查**。瀑布式开发值得拿回来的不是更多文档，而是**阶段门禁**：

1. 问题/方向清楚之前，不写 spec；
2. spec 批准之前，不写 plan；
3. plan 批准之前，不动代码；
4. 审查通过之前，不提交收尾。

每个门禁只要求**承载决策的最小文档**。不为不可能的场景写文档，不为没人读的流程生产 artifact。

### 文档生命周期

| 类型 | 例子 | 定位 |
|------|------|------|
| 历史决策记录 | `docs/specs/*`、`docs/plans/*` | 写清 `Status` 和 `Date`；只作历史参考，不是实时真相 |
| Living docs | README、CLAUDE.md/AGENTS.md、架构文档、用户指南 | 持续更新；每次开发结束检查是否受影响 |
| 可选领域文档 | `GLOSSARY.md`、`docs/adr/*` | 懒创建；只在术语冲突或重要决策出现时维护 |

### 单 agent 负责任务，人负责跨任务并行

同一任务通常由一个 agent 串行负责；不同任务可以由你并行开多个会话。`executing-plans` 的 subagent 模式用于任务内部需要 fresh context 或逐任务 review 的情况，不是默认编排方式。

### Subagent 使用

- 派发前先问；如果已经选择了 subagent 模式，视为已授权。
- 给清目标、必需输入、建议切入点/参考材料；**不限制** subagent 探索仓库的范围，也不限制输出条数。
- 输出要求证据（file:line）、未验证项和“没检查的部分”。
- 设软超时；到点提醒用户已运行多久，由用户决定继续等还是终止回退；**不要自动终止**。
- 异步等待时主 agent 做本地工作；同步阻塞时明确告诉用户正在等。
- 默认不嵌套 subagent；同一工作区不并行派多个 implementer。

### 可选，不等于无用

`GLOSSARY.md`、ADR、`writing-prd`、`decomposing-issues`、`improve-architecture`、`prototype` 都有明确价值，但只在对应条件出现时使用。条件不成立时跳过，不算欠债。

---

## 1. 默认主流程（90% 的 feature 开发）

```
issue intake（GitHub/GitLab）
  → triage（可选：整理队列）
  → brainstorming（探索：意图、方案、约束）
  → grill-me（压测决策和边界）
  → brainstorming（写 spec）
  → writing-prd（可选：需要正式需求文档时）
  → decomposing-issues（可选：跨会话/多人/并行时）
  → writing-plans（写实施计划）
  → grill-me（可选：复杂 plan 再压测一次，fresh agent）
  → executing-plans（单 agent 串行实现）
  → code-review（fresh agent 审查）
  → finish-work（测试、commit、PR、更新 issue）
```

| 阶段 | Skill | 做什么 | 产出 |
|------|-------|--------|------|
| 收集 | **triage**（可选） | 整理 GitHub/GitLab issue，分类、验证、写 agent brief | 可执行的 issue |
| 探索 | **brainstorming** | 理解意图、提 2–3 个方案、确认约束；此时不写 spec | 方向与取舍 |
| 压测 | **grill-me** | 按 frontier 分轮质询，挖边界、依赖、失败模式 | 已解决的决策 |
| 记录 | **brainstorming** | 把已定决策写成 spec，标 `Status`/`Date` | `docs/specs/` 下的 spec |
| 对齐 | **writing-prd**（可选） | 有第二读者/正式交接时，把需求整理成 PRD 并发布 | PRD |
| 拆分 | **decomposing-issues**（可选） | 跨会话/多人时，把 spec/PRD 拆成带依赖的 issue | tracker 中的 ticket |
| 计划 | **writing-plans** | 确认测试 seam，把工作写成红-绿任务、验证命令和提交边界 | `docs/plans/` 下的 plan |
| 再压测 | **grill-me**（可选） | 复杂 plan 用 fresh agent 再质询一次 | 修正后的 plan |
| 实现 | **executing-plans** | 单 agent 串行执行，先看测试失败再实现，ledger 记录进度 | 代码提交 |
| 审查 | **code-review** | fresh agent 只读审查 diff、spec、约束 | Review 结论 |
| 收尾 | **finish-work** | 跑测试、写摘要、commit、可选 PR、更新 issue | 已提交的变更 + PR/issue 更新 |

**配合要点：**

- spec 必须在 `grill-me` 的 frontier 清空之后再写；如果写的过程中冒出新的开放问题，停下来继续 grill，不要自己编答案。
- 涉及接口或 seam 时，在写 plan 的 Interfaces 块之前调用 `codebase-design`；`writing-plans` 和 `executing-plans` 都有对应的自检门禁。
- `writing-plans` 负责把 tdd 的精华落到计划里：预先确认 seam、红-绿顺序、测试质量规则（测行为、禁止同义反复、垂直切片）、重构留给 review。
- `executing-plans` 负责执行时强制这些规则：先看测试失败、再实现、再看测试通过；最后跑完整测试套件。
- `code-review` 必须由一个没有参与实现的 fresh agent 执行；实现者自查不算审查。
- `finish-work` 先建 PR 再更新 issue，这样 issue 评论可以带 PR 链接。

**变体：**

- 只想讨论，不想产出 spec：`brainstorming（探索）` 后停止，或直接用 `grill-me`。
- 想法已经比较成形：可以从 `grill-me` 开始，再进入 `brainstorming（写 spec）`。
- 小改动：`brainstorming` 可以直接给出短设计，跳过 `writing-prd` 和 `decomposing-issues`。
- 需要正式需求文档：在 spec 之前插入 `writing-prd`；如果 PRD 已包含实现决策，技术 spec 只保留测试和接口细节。
- 需要跨会话追踪：在 spec 之后插入 `decomposing-issues`；单 agent 串行时不需要。
- 计划很长或任务独立：`executing-plans` 考虑 subagent-driven；否则 inline 即可。

---

## 2. Bug 排查

```
triage（可选）
  → diagnose
  → code-review（fresh agent）
  → finish-work
```

| 阶段 | Skill | 做什么 | 产出 |
|------|-------|--------|------|
| 分流 | **triage**（可选） | 确认 bug、复现步骤、优先级 | 可排查的 issue |
| 定位 | **diagnose** | 建立能变红的反馈环 → 复现+最小化 → 假设 → 插桩 → 根因 | 根因 + 回归测试 |
| 审查 | **code-review** | fresh agent 审查修复和测试质量 | Review 结论 |
| 收尾 | **finish-work** | 测试、commit、PR、更新/关闭 issue | 已提交的修复 |

**配合要点：**

- 即使原因看起来明显，也先复现、确认假设；`diagnose` 的价值就在这里。
- 修复阶段就在 `diagnose` 内完成：先写回归测试、看它失败、再修、再看它通过。不需要再调用独立的 tdd skill。
- agent 不能直接跑命令时，用 HITL 模式：agent 准备命令和预期输出，你执行并贴回结果。
- 复杂修复涉及多个新行为/多个 seam 时，转用 `writing-plans` / `executing-plans` 的测试优先流程。

**变体：**

- 原因非常明确且只改一行：仍建议走 `diagnose` 的复现+回归测试；如果确实太小，可直接修复 + `code-review`。
- 性能回退：`diagnose` 的假设聚焦在性能，先建 benchmark 再修。
- 修复后发现架构缺口：可接 `improve-architecture`，但放在修复之后。

---

## 3. 重构

```
improve-architecture（可选：还没有明确目标时）
  → brainstorming（spec）
  → writing-plans
  → executing-plans
  → code-review
  → finish-work
```

| 阶段 | Skill | 做什么 | 产出 |
|------|-------|--------|------|
| 发现 | **improve-architecture**（可选） | 扫描代码库，给出带优先级的 deepening 候选 | 重构候选列表 |
| 定义 | **brainstorming** | 把选中的候选变成 spec，确认边界和测试 seam | spec |
| 计划 | **writing-plans** | 拆分红-绿任务，保护现有行为 | plan |
| 执行 | **executing-plans** | 按计划重构；测试先行 | 重构后的代码 |
| 审查 | **code-review** | 确认行为未变、结构改善 | Review 结论 |
| 收尾 | **finish-work** | 测试、commit、PR、更新 issue | 已提交的重构 |

**配合要点：**

- 如果你已经知道要重构哪里，跳过 `improve-architecture`，直接走 `brainstorming`。
- `improve-architecture` 适合定期做架构健康检查，或接手不熟悉的代码库时找候选；不是每次重构的必经步骤。
- 深模块的词汇和 seam 判断用 `codebase-design`；命名候选前先调用它，选中候选后用它的 design-it-twice。

**变体：**

- 小范围重构：直接 `writing-plans` + `executing-plans`。
- 跨模块接口变更：先用 `prototype` 验证新接口，再写 spec。
- 重构后文档漂移：用 `arch-doc` 对齐架构文档。

---

## 4. 原型与技术不确定性

```
brainstorming（探索）
  → prototype（当讨论无法收敛时）
  → grill-me
  → brainstorming（spec）
  → ...
```

**什么时候用 prototype：**

- 状态机/数据模型在纸上说不清，需要一个可操作的逻辑原型；
- UI 方向有多个候选，需要看而不是读；
- 某个库/API 的实际行为不确定；
- 性能或交互假设需要跑一下才知道。

**什么时候不用：**

- 读代码、查文档、讨论就能回答；
- 已经有明确实现方向，只是缺工作量；
- 没有可丢弃的空间，或者原型会被误当成生产代码。

原型是 throwaway：答案记入 issue/commit/ADR，原型本身放 throwaway branch 作为一手证据，主分支只保留验证后的决策。

---

## 5. 技术调研

```
research
  → brainstorming / grill-me（把结论转成方案）
  → writing-plans
```

**什么时候用：** 结论需要留存/引用；阅读量大，适合交给后台 agent；需要并行调研。
**什么时候不用：** 一次搜索或读一个文件就能回答；事实已经在仓库/对话里；问题其实是产品决策而不是事实调查。

`research` 的产物是一份带引用的 Markdown，优先放仓库已有 notes 目录；没有就用 `docs/research/YYYY-MM-DD-<topic>.md`。不要把它当 spec，决策仍要经过 `grill-me` 和 `brainstorming`。

---

## 6. 前端开发

```
brainstorming（探索：产品、受众、目标）
  → frontend-design（设计计划 + 对照 brief 自审）
  → ui-ux-pro-max（可选：设计系统 / UX 规则 / 技术栈建议）
  → impeccable（可选：critique / audit / polish）
  → prototype（可选：视觉方向对比）
  → grill-me（UX、a11y、交互边界）
  → brainstorming（spec）
  → writing-plans
  → executing-plans
  → code-review（Web UI checklist；可选 web-design-guidelines）
  → finish-work
```

**三个设计 skill 的分工：**

| Skill | 定位 | 什么时候用 |
|-------|------|-----------|
| `frontend-design`（内置） | 艺术指导 | 日常设计计划、主题立意、避免生成式默认套路 |
| `ui-ux-pro-max`（推荐上游） | 设计知识库 | 需要 80 种风格、产品配色、字体配对、UX 规则、技术栈建议时 |
| `impeccable`（推荐上游） | 设计导演 / 审查打磨 | 需要 critique、audit、polish、redesign 或 AI-slop 检测时 |

**配合要点：**

- `frontend-design` 先定方向和设计计划；`ui-ux-pro-max` 只提供知识和约束，不覆盖 brief 的具体选择。
- 不要默认三个一起上：日常用 `frontend-design`；需要设计系统用 `ui-ux-pro-max`；需要高阶审查/打磨用 `impeccable`。
- 视觉方向不确定时，用 `prototype` 做多个变体；方向确定后写进 spec。
- `code-review` 对 Web UI 变更执行本地 [Web UI checklist](../skills/engineering/code-review/references/web-ui-review.md)；如果安装了 `web-design-guidelines`，再跑它作为最新规则增强。
- 前端测试聚焦交互逻辑和状态管理，不测 CSS 细节。

---

## 7. 文档产出

| 文档类型 | Skill | 什么时候用 |
|----------|-------|-----------|
| 架构设计说明 | **arch-doc** | 第一版，或需要系统性对齐文档与代码时 |
| 技术文章/博客 | **coauthoring** | 需要保留作者声音的 prose |
| 工作报告 | **work-report** | 日报/周报/月报/年度/述职 |
| PRD | **writing-prd** | 有第二读者、需要正式需求文档时 |
| 实施计划 | **writing-plans** | 多步开发之前 |
| PDF/Office 文档 | 上游 `pdf` / `docx` / `pptx` / `xlsx` | 从 `anthropics/skills` 安装；不内置，见 `docs/external-skills.md` |

**arch-doc 的边界：** 第一版用它保证章节完整；后续小改可以直接让 agent 更新文档。文档明显漂移、架构大改、或需要定期审计时，再用它的对齐模式。

---

## 8. Issue 管理

```
triage
  → decomposing-issues（可选：需要拆成多个可认领任务时）
  → 对应开发流程
```

- `triage` 只管理 GitHub/GitLab issue 和 PR，不支持仓库内私有 issue 文件。
- label 策略：先查 tracker 现有 label，能语义复用就复用；没有则用默认五角色，但在新建 label 前确认。
- `decomposing-issues` 产出的是工作分解，不是 plan；小工作允许只生成一个 issue。
- 单 agent 串行开发不需要把 spec 拆成多个 issue；跨会话/多人/并行时才用。

---

## 9. 多会话与多人协作

```
issue（共享队列）
  → spec / plan（共享决策记录）
  → 每个会话一个任务
  → code-review（fresh agent 或独立会话）
  → finish-work（统一提交/PR/issue 更新）
```

- 同一任务仍由单 agent 负责；并行发生在任务之间。
- spec/plan 是跨会话的共享真相；旧的要标 `Status` 和日期，不能当实时事实。
- 审查用独立会话或 fresh subagent；作者和审查者不共享上下文。
- `finish-work` 负责把每个任务的 commit、PR、issue 状态收拢。

---

## 10. 会话复盘

```
retro
```

当一次会话出现重复摸索、返工、昂贵工具调用、审查漏网时，用 `retro` 复盘 **agent 环境**：导航、自动检查、编码规范、CLAUDE.md/AGENTS.md 体量、工具经济性、无效指令、信息获取。不是每次会话都要做；适合在一次不顺利的会话之后，或每月一次。

产出后按类型落地：能自动化的加 lint/typecheck/test/CI；导航问题加 pointer；判断类规范写进 reviewer checklist；无效指令从 CLAUDE.md/AGENTS.md 删除；信息不足就补日志或只读访问。

---

## 团队角色表

| Skill | 角色 | 一句话描述 |
|-------|------|-----------|
| brainstorming | 需求分析师 | 探索意图、方案和约束，最后记录 spec |
| grill-me | 评审委员会 | 按 frontier 分轮质询，挖边界和失败模式 |
| writing-prd | 产品经理 | 有第二读者时，整理正式需求文档 |
| decomposing-issues | 项目经理 | 把 spec/PRD 拆成带依赖的可认领 issue |
| writing-plans | 技术负责人 | 写红-绿任务、验证命令和提交边界 |
| executing-plans | 工程师 | 单 agent 执行计划，遵守 test-first 和完成契约 |
| code-review | 资深审查者 | fresh agent 只读审查，校准置信度和严重度 |
| finish-work | 发布工程师 | 测试、摘要、commit、PR、更新 issue |
| diagnose | 调试专家 | 反馈环 → 复现+最小化 → 假设 → 插桩 → 修复 |
| improve-architecture | 架构师 | 扫描 deepening 候选（可选、周期性） |
| codebase-design | 架构词汇顾问 | 提供深模块、接口、seam 的共享词汇 |
| prototype | 预研工程师 | 用 throwaway 原型回答一个具体问题 |
| research | 调研员 | 后台查一手资料，写带引用的结论 |
| frontend-design | UI 设计师 | 主题立意、避免 AI 默认套路的实现规范 |
| arch-doc | 架构文档工程师 | 第一版架构文档或系统性对齐 |
| triage | 缺陷分流员 | 管理 GitHub/GitLab issue 和外部 PR |
| retro | 流程改进顾问 | 复盘 agent 环境，减少下次返工 |
| coauthoring | 写作搭档 | 协作撰写保留作者声音的 prose |
| work-report | 行政助理 | 结构化工作报告 |

---

## 全景速查表

| 工作场景 | 推荐流程 |
|---------|---------|
| Feature 开发（默认） | brainstorming(探索) → grill-me → brainstorming(spec) → writing-plans → executing-plans → code-review → finish-work |
| 有第二读者的需求 | 默认流程 + writing-prd（spec 前） |
| 跨会话/多人拆分 | 默认流程 + decomposing-issues（spec 后） |
| Bug 排查 | triage(可选) → diagnose → code-review → finish-work |
| 重构（目标未知） | improve-architecture → brainstorming → writing-plans → executing-plans → code-review → finish-work |
| 重构（目标已知） | brainstorming → writing-plans → executing-plans → code-review → finish-work |
| 技术不确定性 | brainstorming(探索) → prototype → grill-me → brainstorming(spec) → … |
| 技术调研 | research → brainstorming/grill-me → writing-plans |
| 前端开发 | brainstorming → frontend-design → ui-ux-pro-max(可选) → impeccable(可选) → prototype(可选) → grill-me → spec → writing-plans → executing-plans → code-review（含 Web UI checklist）→ finish-work |
| 架构文档 | arch-doc（第一版或对齐） |
| 技术文章 | coauthoring |
| 工作报告 | work-report |
| Issue 管理 | triage → decomposing-issues(可选) |
| 会话复盘 | retro |

## 条件、可选与已废弃

**条件使用：**

- `writing-prd`：有第二读者、正式交接、合规/融资等需要需求文档时。
- `decomposing-issues`：跨会话、多人、并行认领时；单 agent 串行不需要。
- `improve-architecture`：没有明确重构目标，或需要定期架构健康检查时。
- `prototype`：讨论/读代码无法回答，需要可操作或可看的证据时。
- `arch-doc`：第一版或需要系统性对齐时；小改直接更新文档。
- `retro`：出现重复返工/昂贵调用/流程问题时，不是每次会话都做。
- `triage`：issue 队列需要整理时；没有 issue 可跳过。
- `ui-ux-pro-max`：需要设计系统、产品配色/字体/UX 规则或技术栈建议时；不内置。
- `impeccable`：需要 critique/audit/polish/redesign 时；不内置。
- `web-design-guidelines`：Web UI 变更的审查增强；不内置，未安装时用本地 checklist。

**已废弃/已合并：**

- `tdd`：测试优先、seam、测试质量规则并入 `writing-plans`、`executing-plans`、`diagnose`、`code-review`。
- `init-agent-environment`：删除；issue/label 逻辑并入 `triage`，GLOSSARY/ADR 约定并入 `grill-me`。
- `finishing-branch`：改名为 `finish-work`，并增加 commit、PR、issue 更新。
- `caveman`、`zoom-out`：上游删除，本地不再维护。

## 每个 skill 的“什么时候不用”

| Skill | 不要用它来… |
|-------|-------------|
| brainstorming | 处理已经明确的小改动；或在 grill 之前急着写 spec |
| grill-me | 替代生成方案（想法空白时先 brainstorming 探索） |
| writing-prd | 个人项目、没有第二读者时 |
| decomposing-issues | 单 agent 串行、工作不需要跨会话时 |
| writing-plans | 一步就能完成的琐碎改动 |
| executing-plans | 没有计划、或任务小到不需要完成契约时 |
| code-review | 审查自己写的代码 |
| finish-work | 替代人工判断 commit 内容；它只负责流程和检查 |
| diagnose | feature 开发；原因未知的 bug 才用它 |
| improve-architecture | 已经知道重构目标时；直接走 brainstorming |
| prototype | 问题可以通过读代码/查文档/讨论回答时 |
| research | 事实已经在仓库或对话里时 |
| arch-doc | 日常小文档更新；直接改文档即可 |
| retro | 每次会话都做；只在出现流程问题时做 |
