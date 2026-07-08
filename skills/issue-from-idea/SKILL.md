---
name: issue-from-idea
description: Use when a user has a mature idea, concrete feature request, bug report, design change, or implementation goal and wants to turn it into an accurate GitHub Issue for the current repository, especially when the repository has issue templates or project-specific conventions.
---

# Issue From Idea

## Overview

Turn a user's relatively mature idea into a repository-accurate GitHub Issue. The core principle is: **do not interview in the abstract**. First understand the current repository's issue templates, labels, conventions, and relevant project details, then ask only the questions needed to make the issue precise.

Default output is an issue draft. Creating the GitHub Issue is an external side effect and requires explicit user authorization such as "创建吧", "create it", or "submit the issue".

## When To Use

Use this skill when the user already has a direction or goal and needs help making it issue-ready.

Good triggers:
- "帮我构建一个 issue"
- "把这个需求落成 GitHub issue"
- "这个 feature 帮我写成 issue"
- "根据刚才讨论创建 issue 草稿"
- "整理成 bug report / feature request"
- "用项目模板来写 issue"

Do not use this skill for:
- Early brainstorming where the user does not yet know the goal
- Implementation work after an issue already exists
- PR creation or branch/commit workflows
- Generic requirement analysis that is not intended for GitHub Issue output

## Operating Rules

1. Read repository context before drafting.
   - Inspect `.github/ISSUE_TEMPLATE/**` and `.github/ISSUE_TEMPLATE/config.yml` when present.
   - If templates are YAML issue forms, extract required fields, labels, title prefixes, dropdown options, and placeholder intent.
   - If no template exists, use a concise generic GitHub Issue structure, but say that no repo template was found.

2. Understand project details before asking questions.
   - Read relevant files, directories, docs, routes, services, configs, or previous discussion context.
   - Search for analogous implementations, naming, labels, terminology, and module boundaries.
   - Do not conduct a detached product interview while ignoring the codebase.

3. Ask only template-driven and project-driven questions.
   - Fill what can be inferred from repository facts.
   - Ask about gaps that materially affect issue accuracy:
     - scope and non-scope
     - affected modules/files/services/platforms
     - expected behavior
     - failure semantics
     - user-visible impact
     - acceptance criteria
     - labels/category/template choice
   - Prefer one focused question batch over a long generic questionnaire.

4. Default to draft only.
   - Produce the issue title and body in the repository's template format.
   - Include labels only if the template or repo conventions support them.
   - Do not create the issue unless the user explicitly authorizes creation after reviewing the draft.

5. If explicitly authorized to create:
   - Verify `gh auth status`.
   - Verify the target repository with `gh repo view` or `git remote -v`.
   - Use `gh issue create` with the drafted title/body/labels.
   - After creation, run `gh issue view <id> --json title,body,url,labels` to verify the created issue matches the draft.
   - If shell escaping corrupts Markdown or paths, write the confirmed body to a concrete temporary file, repair with `gh issue edit <id> --body-file <path>`, and verify again. Do not rely on stdin shorthand for body repair commands.

## Workflow

### 1. Classify the Issue Type

Choose the repository template that best matches the user's intent:
- feature request: new capability, behavior enhancement, workflow improvement
- bug report: existing behavior is wrong or broken
- task/chore: maintenance, refactor, docs, infra, release work
- question/discussion: unclear ask, needs design decision before implementation

If multiple templates could apply, explain the tradeoff and ask the user to choose.

### 2. Extract Template Contract

For the selected template, capture:
- required title prefix
- default labels
- required checkboxes
- field names and order
- category dropdown values
- expected language or tone
- mandatory sections

Keep the final issue aligned to this contract. Do not invent sections that fight the template unless the template has no place for important information.

### 3. Ground in Project Facts

Before writing the draft, gather enough repository facts to avoid hallucinated issue content.

Look for:
- affected modules and paths
- existing implementations or similar behavior
- platform-specific splits
- naming conventions
- configuration or command entrypoints
- relevant docs
- existing labels or issue conventions when visible

Convert findings into precise issue language:
- "affects `tools/internal/installer/node/nodeinstaller`" is better than "installer code"
- "exclude `precheck`, `stop`, `uninstall`, `checkdeploy`" is better than "not all flows"
- "Windows uses `agent.exe -v`" is better than "also support Windows"

### 4. Grill Only the Missing Pieces

Ask questions only after repository grounding.

Good questions:
- "Template has a feature category dropdown. Should this be `Installation & Deployment` or `Backend`?"
- "I found install/start/restart flows. Should upgrade be included too?"
- "If the diagnostic command fails, should the operation fail or only warn?"
- "Should this issue request parsing/storing the result, or only logging raw output?"

Bad questions:
- "What is the background?"
- "What is the goal?"
- "What are the acceptance criteria?"
- "Any risks?"

These are too generic unless tied to concrete template fields or code facts.

### 5. Draft the Issue

Use this structure when the repository template does not dictate another one:

```markdown
## Problem

[Current gap, user pain, and project context.]

## Expected Solution

[Precise requested behavior.]

## Scope

- Include: [...]
- Exclude: [...]

## Acceptance Criteria

- [ ] ...
- [ ] ...
- [ ] ...

## Implementation Notes

[Optional: grounded suggestions, affected files, existing patterns.]

## Additional Context

[Links, related issues, prior decisions.]
```

For repository issue forms, follow the exact form sections instead.

### 6. Review Before Creation

Before offering creation, check:
- Title follows repo prefix/category conventions.
- Body fills every required template field.
- Scope and non-scope are explicit.
- Acceptance criteria are verifiable.
- Project paths and commands are correct.
- Assumptions are either confirmed or clearly marked.
- No implementation is promised beyond the user's intent.
- No external side effect has happened yet.

Then ask for confirmation if creation is desired.

### 7. Create Only After Authorization

If the user says to create it:

```bash
gh auth status
gh repo view --json nameWithOwner
gh issue create --title "<title>" --body-file <body-file> --label "<label-1>" --label "<label-2>"
gh issue view <issue-number> --json title,body,url,labels
```

Return:
- issue URL
- title
- labels
- any post-create correction performed

## Quality Bar

A good issue produced by this skill:
- matches the repository's actual issue template
- reflects real project structure, not generic assumptions
- contains enough context for a maintainer to understand why it matters
- contains enough scope for an implementer to avoid doing too much
- contains verifiable acceptance criteria
- separates confirmed facts from assumptions
- does not create anything without explicit authorization

## Common Mistakes

| Mistake | Correction |
| --- | --- |
| Writing a generic issue without reading `.github/ISSUE_TEMPLATE` | Always inspect templates first when available. |
| Asking broad product questions before reading the repo | Ground in project files and ask only missing pieces. |
| Treating "build an issue" as permission to create one | Default to draft; creation needs explicit authorization. |
| Ignoring labels/title prefixes from issue forms | Extract and follow template metadata. |
| Over-implementing in the issue | Keep implementation notes optional and scoped. |
| Losing user corrections | Update scope, non-scope, and acceptance criteria immediately. |
| Forgetting post-create verification | Always view the created issue and compare with the draft. |

## Example

User intent:
"现在 Agent 要区分 inner 和 ce，但是当前没有好方式拿到这个信息。我们想在安装工具里固定打一下 `agent -v`，只打日志不解析。precheck 不用。帮我落成 issue。"

Repository facts found:
- Feature template uses title prefix `[FEATURE]: ` and label `kind/features`.
- Affected area is `tools/internal`.
- Fixed flows are install, upgrade, start, restart.
- Excluded flows are precheck, stop, uninstall, checkdeploy.
- Unix command is `./agent -v`; Windows command is `agent.exe -v`.
- Existing installer logs use info/error patterns.

Good title:
`[FEATURE]: tools 安装部署流程增加 agent -v 版本诊断日志`

Good acceptance criteria:
- [ ] install、upgrade、start、restart 固定流程会执行平台对应的 `agent -v` 诊断命令。
- [ ] 诊断输出以 info 级别写入现有 installer 日志。
- [ ] stdout/stderr 原始输出保留，不解析、不归一化、不持久化 `inner` / `ce`。
- [ ] 命令执行失败、非 0 退出或输出采集失败时，当前 operation failed。
- [ ] precheck、stop、uninstall、checkdeploy 不触发该诊断。
- [ ] Linux/Unix 与 Windows 均覆盖。
