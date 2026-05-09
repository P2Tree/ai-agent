# Misc

不好归类的其他 skill。

## install-skills `[手动]`

交互式安装器，把仓库里的 skill 通过软链接装到你指定的 agent 平台目录。逐个展示名称和描述，你确认才装。遇到同名冲突会问你要替换还是保留。装完后提供清单，还可以分析 skill 设计合理性——检测重复、建议合并、做健康度检查。

**什么时候用：** 在新机器上配置 skill、更新已安装的 skill、或管理 skill 安装时。

**触发方式：** 需要你明确输入 `/install-skills` 才会激活。

## update-skills `[手动]`

对比本地 skill 和它们参考的第三方上游源，找出上游有但本地没有的新内容或修改。报告差异并让用户选择要更新哪些 skill。更新时会按 ai-agent 规范重写（去平台特化、保 150 行限制、保渐进披露）。

**什么时候用：** 检查 skill 是否落后于上游、维护 skill 新鲜度、或上游发布新版本后同步更新时。

**触发方式：** 需要你明确输入 `/update-skills` 才会激活。

## create-skill `[自动]`

从零创建 skill、改进现有 skill、给 skill 打分评估，全生命周期都管。包含草稿生成、子 agent 测试、打分、与基准对比、描述优化等环节。

**什么时候用：** 要新建或改进 skill 时。

**触发方式：** 当你说要创建 skill、改进 skill、或输入 `/create-skill` 时激活。

**参考：** mattpocock/write-a-skill + anthropics-agent-skills:skill-creator
