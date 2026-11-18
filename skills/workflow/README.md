# Workflow

工作流操作相关的 skill。

## writing-plans `[自动]`

把需求拆成一步步可执行的计划，每步都有可检查的完成判据。包含任务规模界定、Global Constraints、Review Focus、Interfaces 块和 Execution Handoff；不留 TBD、TODO 之类的占位符。

**什么时候用：** 有多步任务要实施，动手写代码之前。

**触发方式：** 你描述了一个多步骤任务的需求或 spec 时，agent 自动激活。

**参考：** superpowers:writing-plans + mattpocock:tdd + superpowers:test-driven-development

## executing-plans `[自动]`

三种模式：内联逐步执行、subagent 驱动（逐任务派发+审查）、并行派发（独立问题同时处理）。用 ledger 跨压缩恢复进度，冲突和歧义自行裁决并记录 ruling；只有不可逆操作、安全敏感操作、当前分支/项目外副作用和计划彻底坏掉时才停。完成契约和最终审查不能跳过。

**什么时候用：** 有实施计划要执行、需要 subagent 逐任务审查、或多个独立问题想并行处理时。

**触发方式：** 当前会话中存在实施计划，或面临多个独立任务时，agent 自动激活。

**参考：** superpowers:executing-plans + superpowers:subagent-driven-development + superpowers:dispatching-parallel-agents + mattpocock:tdd + superpowers:test-driven-development

## finish-work `[自动]`

开发完成后的一站式收尾：在干净状态运行项目测试、生成 PR body 风格的摘要、按仓库风格生成 commit message 并等你批准后提交、按需创建 PR（先建 PR 再更新 issue，便于关联）、更新 issue 的评论/标签/关闭状态。普通 repo 跳过 worktree 步骤；每一步都可以由你接手。

**什么时候用：** 实现和审查完成，需要提交、开 PR、关闭 issue 时。

**触发方式：** 实现完成、测试通过后，agent 自动激活。

**参考：** superpowers:finishing-a-development-branch（已扩展 commit、PR、issue 更新）

## writing-prd `[自动]`

把当前对话里讨论的内容整理成正式的 PRD 文档——问题陈述、方案、用户故事、实现决策、测试决策，写好后发布到 issue tracker。写测试决策前先确定测试 seam：优先复用已有 seam，尽量少、尽量高。

**什么时候用：** 需求对齐了，需要输出正式 PRD 时。

**触发方式：** 当你明确说要创建 PRD、或输入 `/writing-prd` 时会激活。

**参考：** mattpocock:to-prd

## decomposing-issues `[自动]`

把计划或 PRD 拆成一个个可独立认领、独立执行的 issue，每个是一条完整的垂直切片。

**什么时候用：** PRD 写好了，要拆成可执行的任务时。

**触发方式：** 当你明确说要把计划拆成 issue、或输入 `/decomposing-issues` 时会激活。

**参考：** mattpocock:to-issues

## triage `[自动]`

只管理 GitHub/GitLab issue 和外部 PR 的分诊流程：先分 bug 还是 enhancement，再走五个状态（待分诊 → 需补充信息 / 可交给 agent / 需人工处理 / 不修）。label 优先复用 tracker 已有字符串，否则用默认五角色并先确认。包含冗余实现检查、历史拒绝检查、claim 验证、追问细节、写 agent brief、out-of-scope 知识库和恢复既有会话。

**什么时候用：** 需要创建、审查、管理 issue 时。

**触发方式：** 你创建、查看或管理 issue 时，agent 自动激活。

**参考：** mattpocock:triage

## retro `[手动]`

对一次编码会话做复盘，但复盘对象是 **agent 的工作环境**，不是这次的产品代码。按严重程度列出改进项：导航指针、自动检查（lint/typecheck/test/CI）、编码规范、AGENTS.md/CLAUDE.md 体量、工具调用经济性、无效指令、信息获取渠道。

**什么时候用：** 一次不顺利的会话之后，或每月一次；典型信号是同类错误反复出现、agent 反复找文件、工具调用异常昂贵、review 抓到本可由自动检查抓住的问题、CLAUDE.md/AGENTS.md 膨胀、或信息不足导致任务中断。

**触发方式：** 需要你明确说要复盘（如 `/retro`）才会激活。

**参考：** mattpocock:retro

