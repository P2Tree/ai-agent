# Deprecated

已废弃、已合并或已改名的 skill。这里的内容仅作历史参考，不再注册到根 README、插件清单或 skill 索引中。

| Skill | 状态 | 废弃原因 | 融入位置 / 替代 |
|-------|------|----------|-----------------|
| `caveman` | 删除 | 上游 mattpocock 已移除；重复的压缩通信能力不再维护 | 无 |
| `zoom-out` | 删除 | 上游 mattpocock 已移除；使用率低，导航需求可由直接读代码和 `improve-architecture` 覆盖 | 无 |
| `init-agent-environment` | 删除 | 按需初始化成本高于收益；多数仓库不需要生成 `docs/agents/` 配置文件。issue 操作改为由 `triage` 直接识别 GitHub/GitLab | `triage`（issue/label 逻辑）、`grill-me`（GLOSSARY/ADR 约定，见 `references/domain-model.md`） |
| `tdd` | 合并 | 与 `diagnose` 在 bug 修复阶段重叠；其测试驱动、seam、测试质量规则已拆入 feature 主流程和 bug 流程，不再单独维护 | `writing-plans`、`executing-plans`（feature 的测试优先与完成契约）、`diagnose`（回归测试与测试质量）、`code-review`（测试质量审查） |
| `finishing-branch` | 改名 | 原流程不包含 commit 和 issue 更新，不能覆盖真实收尾工作；改名为 `finish-work` 并扩展职责 | `skills/workflow/finish-work` |

## 并入上游 skill 的说明

`tdd` 的测试驱动思想来自 `mattpocock:tdd` 和 `superpowers:test-driven-development`。合并后：

- `writing-plans` 负责把任务写成红-绿顺序，并在计划阶段确认测试 seam；
- `executing-plans` 负责执行时强制先看测试失败、再实现、最后看测试通过；
- `diagnose` 负责 bug 修复时的回归测试和测试质量；
- `code-review` 负责审查测试是否验证行为、是否同义反复。

上游 `verification-before-completion`、`using-git-worktrees`、`domain-modeling`、`handoff` 未作为独立 skill 引入，其核心规则分别并入 `configs/project/CLAUDE.md`、执行/收尾流程、`grill-me` 和现有会话交接习惯，详见 `docs/system-evolution.md`。
