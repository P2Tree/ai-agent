# CLAUDE.md — 本仓库开发规范

本文件指导 agent 在 ai-agent 仓库中的工作行为。

## 仓库概述

ai-agent 是一个开源的 AI 编码助手技能仓库。收集、融合、维护各类 agent skill 及相关配置。

## 语言

默认用**中文**回复，除非用户用英文提问。

## 工作流规则

1. **先读后改** — 不要修改你没读过的文件
2. **交互式确认** — 开始实现之前，先和用户进行多轮讨论，确认变更需求
3. **主动使用 skill** — 如果有 skill 和当前任务相关，先调用再响应
4. **严格遵循 skill 的 checklist** — 特别是刚性 skill（TDD、调试、流程步骤）
5. **验证后再说完成** — 运行编译、测试或验证命令后再确认
6. **不做时间预估** — 不要预测任务需要多久

## Skill 开发规范

- 新建 skill 先放 `skills/draft/`，通过质量审核后 mv 到正式桶
- skill 毕业时同时更新根 README、桶 README、所有注册表
- 所有 skill 不含敏感信息（如密钥、绝对路径、个人身份信息）
- skill 内容保持平台无关，平台映射放 `references/`
- SKILL.md 不超过 150 行，超出的内容拆到 `references/`
- description 必须含 `Use when` 触发条件
- 使用 `scripts/validate-skill.sh` 检查结构完整性（根据当前 shell 选择）
- 参考 `docs/skill-writing-guide.md` 了解写作规范

## 代码风格

- 提交信息格式使用 Conventional Commits
- 改动要小而精准 — 不做装饰性重排，不做推测性重构
- 不给没修改过的代码加注释或文档字符串
- 优先编辑现有文件，而非创建新文件

## 反模式

- 不要编造 URL、文件路径或 API 端点
- 不要生成占位性的 "TODO" 桩代码 — 要么完整实现，要么问用户
- 不要给不可能的代码路径加错误处理
- 不要过度抽象 — 三行相似代码 > 一个过早的辅助函数
- 不要创建 README 或 markdown 文档，除非用户明确要求
- 不要推送到远程或创建 commit，除非用户明确要求
- Shell 不要写 bash 特有语法，兼容 bash 和 zsh
- 不要将 `internal` 和 `personal` 目录下的 skills 添加到根目录 README 文件和 skill 索引文件中
