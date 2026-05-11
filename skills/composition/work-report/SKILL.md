---
name: work-report
description: Generate structured work reports following Chinese corporate conventions. Use when writing daily, weekly, monthly, quarterly, or annual reports, probation reviews, or promotion summaries. Triggers on 日报, 周报, 月报, 季度报告, 年度总结, 述职, 转正, 晋升, work report, or status update.
---

# 中文企业工作汇报

生成符合国内企业汇报规范的结构化报告，覆盖从日报到晋升述职的全场景。

## 触发条件

- 提到写报告：日报、周报、月报、季度报告、年度总结
- 提到述职：转正述职、晋升述职
- 提到状态更新：work report、status update
- 用户似乎在准备一份工作汇报

## 报告类型光谱

| 类型 | 频率 | 核心章节 | 模板 |
|------|------|---------|------|
| 日报 | 每日 | 今日完成/明日计划/需要支持 | [例行报告](examples/routine-reports.md) |
| 周报 | 每周 | 进展+环比/风险点/计划+闭环 | [例行报告](examples/routine-reports.md) |
| 月报 | 每月 | 进展+目标达成/风险/计划+闭环 | [例行报告](examples/routine-reports.md) |
| 季度报告 | 每季 | 核心成果/目标全景/战略重点/资源需求+闭环 | [战略报告](examples/strategic-reports.md) |
| 年度总结 | 每年 | 核心成果/里程碑/反思/来年方向+闭环 | [战略报告](examples/strategic-reports.md) |
| 转正述职 | 一次 | 核心成果/能力成长/不足改进/未来计划 | [职业报告](examples/career-reports.md) |
| 晋升述职 | 一次 | 核心贡献/影响力/能力对标/未来规划 | [职业报告](examples/career-reports.md) |

→ 各类型结构详解见 [report-types.md](references/report-types.md)

## 核心流程

1. **确定报告类型和受众** — 问清写什么类型的报告、汇报给谁看
   - 受众决定粒度：直属上级看细节，团队负责人看聚合，高层看结论
   - → 详见 [audience-granularity.md](references/audience-granularity.md)
2. **收集数据** — 分两条路径
   - 有工具接入（飞书/钉钉等）→ 自动拉取
   - 无工具接入（默认）→ 引导用户按清单输入
   - → 详见 [data-source-strategy.md](references/data-source-strategy.md)
3. **撰写报告** — 按对应类型的模板和风格规则生成
   - 加载对应的 examples/ 模板
   - 应用风格规则和受众调整
   - → 详见 [style-rules.md](references/style-rules.md)
4. **自检** — 用下方自检清单逐项检查

## 风格要点摘要

- **无 emoji** — 任何位置不用 emoji，状态用文字标记
- **数据必须，带对比** — 每个结论有数据，数据带环比/达成率/行业对比
- **表格优先** — 指标、进度、对比用表格，段落只用于分析和说明
- **问题委婉** — "风险点/待协调事项/需要支持的方向"，附带影响范围+方案
- **计划闭环** — 责任人+截止日期，上期承诺逐条闭环
- **语言简洁** — 无修辞、无程度副词、量化替代形容词

→ 完整规则见 [style-rules.md](references/style-rules.md)

## 受众维度摘要

| 受众 | 关注点 | 数据深度 | 篇幅 |
|------|-------|---------|------|
| 直属上级 | 执行细节、阻塞项 | 任务级 | 中等 |
| 团队负责人 | 跨团队依赖、整体进度 | 聚合级 | 中等偏短 |
| 高层 | 战略对齐、风险暴露 | 核心指标+红绿灯 | 简短 |

→ 完整调整策略见 [audience-granularity.md](references/audience-granularity.md)

## 数据要求

什么算数据：带数字的指标，不是定性描述。

对比基准三维度（至少选一）：
- **vs 上期**（环比）— 展示趋势
- **vs 目标**（达成率）— 展示执行质量
- **vs 行业**（竞争位）— 展示外部定位

孤立数字无意义，"用户数 12.3 万"需补充"环比 +8.2%，目标达成率 103%"。

## 自检清单

交付前逐项检查：

- [ ] 每个结论有数据支撑？
- [ ] 数据带对比基准（环比/达成率/行业）？
- [ ] 上期承诺逐条闭环？
- [ ] 问题表述为"风险点/待协调/需要支持"且附方案？
- [ ] 计划有责任人+截止日期？
- [ ] 无 emoji？
- [ ] 数据密集部分用表格？

## 参考文件

- [report-types.md](references/report-types.md) — 7 种报告类型结构详解
- [style-rules.md](references/style-rules.md) — 中文企业汇报风格规则
- [audience-granularity.md](references/audience-granularity.md) — 受众维度调整策略
- [data-source-strategy.md](references/data-source-strategy.md) — 数据源双路径策略
- [routine-reports.md](examples/routine-reports.md) — 日报/周报/月报模板
- [strategic-reports.md](examples/strategic-reports.md) — 季度报告/年度总结模板
- [career-reports.md](examples/career-reports.md) — 转正述职/晋升述职模板

## 注意事项

- **混合受众**：主体按最高决策者粒度，附录供直属上级查阅细节
- **数据缺失**：标注"待补充"+获取路径，不留空，不编造
- **跨部门报告**：每个部门独立成表，汇总行放最前
