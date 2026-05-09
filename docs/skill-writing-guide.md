# Skill 写作指南

本文档说明如何写一个好的 agent skill。

## 基本结构

每个 skill 是一个目录，包含：

```
skill-name/
├── SKILL.md           ← 必需
├── references/        ← 可选，详细参考
├── scripts/           ← 可选，确定性脚本
└── examples/          ← 可选，示例
```

## SKILL.md 写法

### Frontmatter

```yaml
---
name: skill-name
description: 一句话说做什么。Use when [触发条件]。
---
```

`description` 是 agent 决定是否加载这个 skill 的唯一依据。格式：
- 第一句：做什么
- 第二句：`Use when` + 什么时候触发
- 不超过 1024 字符

好的例子：`Extract text and tables from PDF files. Use when working with PDF files.`
坏的例子：`Helps with documents.`

### 正文结构

```markdown
# 技能标题

## 要做什么
简洁的指令，agent 照着执行。

## 流程
（如果有步骤，用 checklist 列出）

## 注意事项
（坑、反模式、边界情况）

## 参考
（详细内容拆到 references/，这里链接过去）
```

### 约束

- SKILL.md 不超过 150 行；超出的内容拆到 `references/`
- 不含敏感信息（密钥、绝对路径、个人身份信息）
- 术语一致，不自造黑话
- 平台无关——不包含特定 agent 的工具名或指令

## 渐进披露

SKILL.md 保持精简，agent 按需加载 `references/` 中的详细内容。适用场景：

- skill 流程有大量细节步骤
- 包含平台映射表
- 包含详细示例或模板

拆到 references/ 的内容在 SKILL.md 中用链接引用：`详见 [参考文档](references/detail.md)`

## 何时用 scripts

当操作满足以下条件时写成脚本：

- 确定性操作（格式化、校验、模板生成）
- 每次生成的代码都一样
- 需要明确的错误处理

脚本省 token 且结果更可靠。

## 质量检查清单

### 结构完整性
- [ ] SKILL.md 存在且 frontmatter 格式正确
- [ ] description 含 `Use when` 触发条件
- [ ] description 不超过 1024 字符
- [ ] SKILL.md 不超过 150 行
- [ ] 无敏感信息

### 内容质量
- [ ] 指令明确，agent 可以直接照做
- [ ] 流程类技能有步骤 checklist
- [ ] 包含注意事项或反模式
- [ ] 术语一致
- [ ] 无废话

### 实际验证
- [ ] 至少手动跑过一次完整流程
- [ ] 在目标平台上能正确触发
- [ ] scripts/ 下的脚本可执行且幂等

可用 `scripts/validate-skill.{sh,zsh,fish} <skill-dir>` 自动检查结构完整性（根据当前 shell 选择）。
