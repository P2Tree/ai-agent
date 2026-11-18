# Personal

个人专用 skill。脱敏后开源。

## update-skills `[手动]`

对比本地 skill 与第三方上游，但不止于 diff：先用决策测试判断该同步、合并、废弃、引入还是推荐上游，再按 ai-agent 规范改写。会同步更新根/桶 README、注册表、playbook、架构文档和演进记录；合并或删除会在 `deprecated/README.md` 说明原因和去向，并在目标桶补 `参考`。

**什么时候用：** 检查 skill 是否落后于上游、维护 skill 新鲜度、或上游发布新版本后同步更新时。

**触发方式：** 需要你明确输入 `/update-skills` 才会激活。
