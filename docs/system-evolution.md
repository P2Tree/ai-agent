# Skill 系统演进记录

> 记录这套 skill 系统在迭代中形成的判断和取舍，供后续演进时参考。不是 changelog；changelog 看 git 和 README。实际执行时使用 `update-skills` skill，它内置本文的决策测试和维护流程。

## 背景：AI 加速的瀑布式开发

过去的瀑布式开发最大的问题是周期长、文档多、交付慢。AI 把写文档、评审、写代码的成本压下来之后，真正稀缺的不再是产出，而是**想清楚、做决策、审查**。

但这套系统的目标不是「让 agent 多写文档」，而是：

- 用**阶段门禁**逼出关键决策；
- 只保留**承载决策的最小文档集**；
- 让作者和审查者分离，避免自己确认自己；
- 让历史文档和 living docs 各归其位。

一句话：**文档不是交付物，决策才是；文档只是决策的载体。**

## 核心原则

### 1. 阶段门禁

1. 问题/方向清楚之前，不写 spec；
2. spec 批准之前，不写 plan；
3. plan 批准之前，不动代码；
4. 审查通过之前，不提交收尾。

每个门禁都要有一个明确的「通过」条件，而不是「差不多可以了」。

### 2. 最小决策文档集

每个 skill 或文档都必须能回答：**它承载了什么决策？**

- 如果删掉它，会改变「做什么」或「怎么验证」，保留；
- 如果只是复述代码、重复已有文档、或没人会读，删掉；
- 如果几句话就能说清，不要做成独立 skill。

### 3. 作者/审查者分离

- 写代码的 agent 不审查自己的代码；
- spec/plan 的审查尽量用 fresh agent 或独立会话；
- 审查者只拿 diff、brief/spec、约束，不拿实现者的辩解和思考过程。

同一个上下文意味着同一个盲区；独立上下文是审查价值的来源。

### 4. 历史记录 vs Living docs

- `docs/specs/*`、`docs/plans/*`：某一时刻的决策记录，带 `Status` 和 `Date`；过时后只作历史参考。
- README、CLAUDE.md/AGENTS.md、架构文档、用户指南：持续更新的 living docs；每次开发结束检查是否受影响。
- `GLOSSARY.md`、`docs/adr/*`：可选、懒创建；只在术语冲突或重要决策出现时维护。

### 5. 单 agent 负责任务，人负责跨任务并行

同一任务通常单 agent 串行；不同任务由人开多个会话并行。subagent 主要用于审查或需要 fresh context 的场景，不是默认编排。

## 关键决策记录

### 删除 `caveman`、`zoom-out`

上游已删除，本地使用率低，能力可由直接读代码和 `improve-architecture` 覆盖。保留会增加维护面。

### 删除 `init-agent-environment`

一次性生成 `docs/agents/` 配置的成本高于收益；多数仓库不需要这套间接层。issue/label 逻辑并入 `triage`，GLOSSARY/ADR 约定并入 `grill-me` 的 `references/domain-model.md`。

### 合并 `tdd` 到 `writing-plans` / `executing-plans` / `diagnose` / `code-review`

`tdd` 与 `diagnose` 在 bug 修复阶段重叠；`tdd` 的独立价值主要是 feature 开发的测试优先、seam 确认和测试质量规则。这些规则分别落到：

- `writing-plans`：计划阶段确认 seam、红-绿任务、测试质量；
- `executing-plans`：执行时强制先看失败、再实现、再看通过；
- `diagnose`：bug 修复的回归测试和测试质量；
- `code-review`：审查测试是否验证行为、是否同义反复。

### `finishing-branch` 改名 `finish-work`

原流程不包含 commit 和 issue 更新，无法覆盖真实收尾。`finish-work` 增加：干净状态测试、PR body 风格摘要、按仓库风格 commit、可选 PR（先建 PR 再更新 issue）、issue 评论/关联/关闭。

### 移除内置 `pdf`、`docx`、`pptx`、`xlsx`

这四个是 anthropics/skills 的官方文档 skill，更新频繁、体积大，本地定制很薄。继续内置意味着持续同步中文结构和 vendored 脚本，收益低于维护成本。改为：

- 根 README 和 `docs/external-skills.md` 给出上游安装方式；
- `composition` 桶 README 只保留指引；
- `manage-skills` 增加「安装推荐上游 skill」多选入口，用户可勾选后安装到本地。

### 未单独引入的上游 skill

| 上游 skill | 处理 | 原因 |
|-----------|------|------|
| `verification-before-completion` | 并入 `configs/project/CLAUDE.md`、`executing-plans`、`finish-work` | 是一条律令/习惯，不是多步流程；放在全局配置更可靠 |
| `using-git-worktrees` | 不引入 | agent 本身会处理；执行流程改为默认功能分支，已有 worktree 则留在其中 |
| `domain-modeling` | 并入 `grill-me` 的 `references/domain-model.md` | 一半是文件约定，一半是几个习惯；独立 skill 触发条件太宽 |
| `handoff` | 不引入 | agent 自带压缩/交接能力；spec/plan/issue 已是持久交接物 |
| `grilling` | 并入 `grill-me` | 本地只有 grill-me 一个使用者；将来需要复用时再抽出 |

### 引入 `codebase-design`、`research`、`retro`

- `codebase-design`：深模块词汇和 seam 判断的唯一来源，`tdd` 和 `improve-architecture` 的重复参考文件被删除。
- `research`：后台查一手资料，补上「事实调查」这一环。
- `retro`：复盘 agent 环境，补上「流程改进」这一环。

### `writing-prd`、`decomposing-issues`、`triage` 保留但降级为条件使用

- `writing-prd`：有第二读者/正式交接时才需要；
- `decomposing-issues`：跨会话/多人/并行时才需要，单 agent 串行不需要；
- `triage`：只管理 GitHub/GitLab issue 和外部 PR，不再支持仓库内私有 issue 文件。

## 当前默认流程

```
issue intake（GitHub/GitLab/讨论和灵感）
  → triage（可选：issue 整理和更新）
  → grill-me（前期讨论和探索）
  → brainstorming（主要问题拟定与写 spec）
  → writing-prd（可选：交付第二人）
  → decomposing-issues（可选：大任务拆分和更新 issue）
  → writing-plans（拟定 plan）
  → grill-me（可选：复杂 plan 讨论）
  → executing-plans（执行 plan）
  → code-review（审查 code）
  → finish-work（收尾）
```

Bug 流程（GitHub/GitLab/问题收集）

```
triage（可选：issue 整理和更新）→ diagnose → code-review → finish-work
```
