# Engineering

软件开发相关的 skill。

## tdd `[自动]`

经典的 TDD 循环。写一个测试，写最少代码让它通过，然后重构。一次只切一个垂直切片，不做"先把所有测试写完再写代码"的水平切片。

**什么时候用：** 想用 TDD 方式开发功能或修 bug 时。

**触发方式：** 明确说要 TDD、test-first、或红绿重构，agent 时激活。

**参考：** mattpocock:tdd + superpowers:test-driven-development

## diagnose `[自动]`

系统化的调试方法：先建立可复现的反馈环，再逐步缩小范围——复现、假设、插桩、修复、清理，循环推进。不是靠猜，是靠排除法。

**什么时候用：** 遇到难调的 bug、性能回退、或行为不合预期时。

**触发方式：** 你报告 bug、说"有问题""挂了""报错""性能回退"时，agent 自动识别并激活。

**参考：** mattpocock/diagnose + superpowers:systematic-debugging

## code-review `[自动]`

做 code review 时的行为准则：不确定的地方多问少断，审查的是代码变更而不是作者，置信度和严重度要匹配——别用"肯定有问题"的语气说"可能"的事。包含四阶段审查流程、严重度标签体系和困难反馈模式。

**什么时候用：** 审查 PR 或代码变更时。

**触发方式：** 你要求审查代码、review PR、或看 diff 时，agent 自动激活。

**参考：** superpowers:requesting-code-review + superpowers:receiving-code-review + wshobson:code-review-excellence

## improve-architecture `[自动]`

扫描代码库里的架构问题，提出"加深模块"的重构建议。基于项目的领域语言和架构决策记录来分析，不是泛泛而谈。

**什么时候用：** 代码库变复杂了，想定期做架构健康检查时。

**触发方式：** 当你明确说要改善架构、找重构机会、或解耦模块，agent 就会激活。

**参考：** mattpocock:improve-codebase-architecture

## frontend-design `[自动]`

做有个性的前端界面，不要千篇一律的 AI 风格。强调大胆的视觉方向——独特的字体、有冲击力的配色、意料之外的布局。

**什么时候用：** 做 Web 组件、页面、仪表盘、React 组件、HTML/CSS 布局时。

**触发方式：** 你要求构建 Web 组件、页面、仪表盘等前端界面时，agent 自动激活。

**参考：** anthropic-agent-skills:frontend-design

