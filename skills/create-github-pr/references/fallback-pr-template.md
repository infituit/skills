# Fallback PR Template

Use this template only when the target repository has no PR or merge template. Fill only supported facts; keep authorization and pending publication actions outside the public body.

```markdown
## 变更摘要 / Summary

- [做了什么、为什么，以及 reviewer 应关注的行为]

## 测试结果 / Test Results

- [实际执行的命令或场景、测试版本及结果]
- [未执行的检查、原因与剩余验证范围；不把建议命令写成已通过]

## 风险与回滚 / Risks and Rollback

- 风险 / Risks: [兼容性、工作流或用户影响]
- 回滚方案 / Rollback plan: [可执行的回滚或降级步骤]

## 关联 Issue / Related Issues

Related: #<issue-number>

## 涉及范围 / Affected Areas

- [实际受影响的组件、接口、配置、文档或 agent 行为]
- [影响链路及已确认不变的边界；不适用则写 N/A]
```
