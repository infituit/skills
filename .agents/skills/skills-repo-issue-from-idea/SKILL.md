---
name: skills-repo-issue-from-idea
description: Drafts and submits maintenance Issues for infituit/skills using this repository's Bug, Feature, and Discussion forms. Use when turning a concrete repository change into an Issue, including “写 issue”, “整理需求”, or “维护模板”; not for enhancing the distributed issue-from-idea skill or creating Issues in arbitrary repositories.
---

# Skills Repository Issue Workflow

## Quick Start

“把本仓库 GitHub 模板维护需求整理成 Issue，先不要提交。”

Read `.github/ISSUE_TEMPLATE/`, inspect the affected files, and return a form-aligned draft plus only the questions needed to complete it.

## Why

This skill supports maintainers of this repository. `skills/` is distributed business content; `.agents/skills/` is repository-local workflow. A request to improve this repository's contribution process does not authorize changing `skills/issue-from-idea/` or `skills.sh.json`.

## Workflow

1. **Read repository context.** Inspect root `README.md`, applicable `AGENTS.md`, `.github/ISSUE_TEMPLATE/config.yml`, and the selected form. Resolve canonical `infituit/skills` through remotes and GitHub metadata; do not assume `origin` is canonical. Confirm ambiguous targets.
2. **Ground the request.** Read affected skills, templates, grouping configuration, references, or docs before asking questions. Establish whether the change belongs to distributed business skills, repository-local workflows, or GitHub configuration. Fill only facts supported by the repository or user.
3. **Check duplicates.** Search concrete behavior and affected areas. Show candidate scope and number, then confirm reuse. Similarity is not permission to link, edit, or close an existing Issue. Do not duplicate a confirmed tracking Issue.
4. **Choose the form.** Use `bug_report.yml` for incorrect existing behavior, `feature_request.yml` for concrete new capability, and `discussion.yml` for unresolved design or direction. Use the exact current title prefix, labels, fields, and dropdown text. If routine maintenance does not fit and blank Issues are disabled, ask which form to use rather than forcing a feature or bypassing the chooser.
5. **Render the form.** Follow [Issue Form Delivery](references/issue-form-delivery.md). Convert input labels into Markdown headings in order; YAML is not the submission body. Include required fields and exact selected options. Check boxes only from evidence or explicit user confirmation. Never invent reproduction, versions, logs, documentation-read claims, or stable reproducibility.
6. **Resolve material gaps.** Ask focused questions tied to the selected form and changed files: scope/non-scope, behavior, category, failure semantics, and verifiable acceptance. Put missing-evidence questions in the conversation, not in a supposedly complete public Issue. Keep scope and acceptance inside the form's appropriate fields.
7. **Draft only by default.** Show canonical repository, template, exact title/body, language, labels, and confirmed facts. Use Chinese unless requested otherwise, preserving bilingual field labels. Redact secrets and sensitive conversation/log content. Check current remote label existence; a template label does not create a label.
8. **Submit only after confirmation.** Confirm the exact Issue creation or edit separately from text review, push, PR creation, or metadata changes. Use `gh issue create --repo infituit/skills --title "<confirmed-title>" --body-file <confirmed-file>` with only confirmed labels. For edits, read the current Issue before proposing the exact change. Never create or substitute missing labels without approval.
9. **Read back.** Use `gh issue view <number> --repo infituit/skills --json title,body,url,labels,state`. Compare to the approved draft, confirm specific corrective edits, and verify again. On ambiguous create failures, inspect remote state before retrying. Hand PR association to the local PR workflow; routine, umbrella, or partial delivery stays non-closing.

## Anti-patterns

WRONG: Edit the distributed `issue-from-idea` skill to introduce this repository's own form policy, invent checklist answers, or create an Issue just because a draft is requested.

RIGHT: Use the local workflow and current forms, ask only fact-specific questions, and obtain explicit submission approval.

## Checklist

- The change is classified as business skill, repository-local workflow, or repository configuration.
- Form, title prefix, dropdown selections, label existence, and required fields match current files.
- Duplicate candidates and reuse are confirmed rather than guessed.
- Scope, non-goals, and verifiable acceptance are grounded; unsupported checkboxes remain unchecked.
- Drafting performs no remote writes; submission and corrective edits have separate approval and readback.

## See Also

- PR workflow: `.agents/skills/skills-repo-create-github-pr/SKILL.md`.
- Authoritative forms: `.github/ISSUE_TEMPLATE/`.
- [Issue Form Delivery](references/issue-form-delivery.md): rendering and submission details.
- `evals/evals.json`: repository-maintainer scenario definitions, not executed-test results.
