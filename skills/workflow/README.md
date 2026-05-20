# Workflow

工作流操作相关的 skill。

## writing-plans `[自动]`

把需求拆成一步步可执行的计划，每步都带完整代码和验证命令。遵循 DRY、YAGNI、TDD 原则，勤提交。不要留 TBD、TODO 之类的占位符。

**什么时候用：** 有多步任务要实施，动手写代码之前。

**触发方式：** 你描述了一个多步骤任务的需求或 spec 时，agent 自动激活。

**参考：** superpowers:writing-plans

## executing-plans `[自动]`

三种模式：内联逐步执行、subagent 驱动（逐任务派发+两轮审查）、并行派发（独立问题同时处理）。卡住了就停下来问人，不瞎猜。验证和审查步骤不能跳过。

**什么时候用：** 有实施计划要执行、需要 subagent 逐任务审查、或多个独立问题想并行处理时。

**触发方式：** 当前会话中存在实施计划，或面临多个独立任务时，agent 自动激活。

**参考：** superpowers:executing-plans + superpowers:subagent-driven-development + superpowers:dispatching-parallel-agents

## finishing-branch `[自动]`

开发完了怎么办：先验证测试，然后给你四个选择——本地合并、创建 PR、保留现状、或者丢弃。选完自动清理 worktree。

**什么时候用：** 开发完成、测试通过，要决定怎么收尾时。

**触发方式：** 实现完成、测试通过后，agent 自动激活。

**参考：** superpowers:finishing-a-development-branch

## writing-prd `[自动]`

把当前对话里讨论的内容整理成正式的 PRD 文档——问题陈述、方案、用户故事、实现决策、测试决策，写好后发布到 issue tracker。

**什么时候用：** 需求对齐了，需要输出正式 PRD 时。

**触发方式：** 当你明确说要创建 PRD、或输入 `/writing-prd` 时会激活。

**参考：** mattpocock:to-prd

## decomposing-issues `[自动]`

把计划或 PRD 拆成一个个可独立认领、独立执行的 issue，每个是一条完整的垂直切片。

**什么时候用：** PRD 写好了，要拆成可执行的任务时。

**触发方式：** 当你明确说要把计划拆成 issue、或输入 `/decomposing-issues` 时会激活。

**来源：** mattpocock:to-issues

## triage `[自动]`

用状态机管理 issue 的分诊流程：先分 bug 还是 enhancement，再走五个状态（待分诊 → 需补充信息 / 可交给 agent / 需人工处理 / 不修）。包含复现确认、追问细节、写 agent brief 等步骤。

**什么时候用：** 需要创建、审查、管理 issue 时。

**触发方式：** 你创建、查看或管理 issue 时，agent 自动激活。

**参考：** mattpocock:triage

## init-agent-environment `[手动]`

新仓库第一次用 agent 时的初始化：配置 issue tracker、设置 triage 标签、搭好领域文档的目录结构。

**什么时候用：** 新仓库首次接入 agent skill 时。

**触发方式：** 需要你明确要求初始化 agent 环境时才会激活。属于一次性设置——初始化完成后不需要再次触发。

**参考：** mattpocock:setup-matt-pocock-skills
