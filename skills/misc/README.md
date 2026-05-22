# Misc

不好归类的其他 skill。

## manage-skills `[手动]`

通用 skill 管理器，支持任何来源的 skill（不限于 ai-agent）。浏览已安装 skill 并按功能分类、安装新 skill（优先搜索 ai-agent，也支持通过 find-skills 搜索外部生态）、审计已安装 skill 的来源和状态、健康度检查、删除 skill。安装流程在 find-skills 可用时自动委托其搜索外部生态。

**什么时候用：** 查看已安装 skill、安装新 skill、审计 skill 健康状态、删除 skill 时。

**触发方式：** 需要你明确输入 `/manage-skills` 才会激活。

## find-skills `[自动]`

当本地 skill 无法覆盖用户需求时，搜索开源 skill 生态寻找匹配。通过 `npx skills find` 查询社区注册表，验证质量后推荐给用户，由用户决定是否安装。始终优先推荐本地已有的 skill。

**什么时候用：** 用户问"怎么做 X"、"有没有能做 X 的 skill"、或当前 skill 无法很好地解决问题时。

**触发方式：** agent 发现用户需求超出本地 skill 覆盖范围时自动激活。

**参考：** vercel-labs/skills:find-skills

## create-skill `[自动]`

从零创建 skill、改进现有 skill、给 skill 打分评估，全生命周期都管。包含草稿生成、子 agent 测试、打分、与基准对比、描述优化等环节。

**什么时候用：** 要新建或改进 skill 时。

**触发方式：** 当你说要创建 skill、改进 skill、或输入 `/create-skill` 时激活。

**参考：** mattpocock/write-a-skill + anthropics-agent-skills:skill-creator
