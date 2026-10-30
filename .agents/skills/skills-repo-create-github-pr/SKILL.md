---
name: skills-repo-create-github-pr
description: Prepares, creates, updates, or replaces pull requests for maintaining the infituit/skills repository using its own templates and verification rules. Use when contributing to this repository, including “准备 PR”, “提交 PR”, “更新 PR”, or “替代 PR”; not for installing or changing the distributed GitHub workflow skills.
---

# Skills Repository PR Workflow

## Quick Start

“为当前 skills 仓库的模板修改准备 PR，先只输出草稿。”

Read `.github/PULL_REQUEST_TEMPLATE.md`, inspect the current diff, and return the complete draft without pushing or writing GitHub resources.

## Why

This is a repository-local maintainer workflow. `skills/` contains distributed business skills; `.agents/skills/` contains this repository's own workflows. Do not implement contribution rules by modifying `skills/create-github-pr/` or adding local workflows to `skills.sh.json`.

## Workflow

1. **Choose the mode.** Use preflight for drafts or ambiguous intent, create for a new PR, update for a requested edit, and replacement for restoring an old PR. Splitting requires an approved plan; it does not authorize history rewrites or publication.
2. **Read current repository rules.** Inspect root `README.md`, applicable `AGENTS.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/`, and any contribution, title-lint, or labeler configuration that exists. Missing files are not invented requirements. Use repository-relative paths from the checkout root.
3. **Resolve scope and base.** Resolve `infituit/skills` from remote URLs and GitHub metadata, not remote names. Use the canonical default branch unless the user explicitly selects another target. Fetch it before comparison when allowed; report stale evidence if refresh is forbidden. Confirm the target if no matching remote exists. Capture base/head, merge base, commits, dirty state, pushed status, and Issue/PR references. Never include unrelated worktree changes.
4. **Resolve the Issue.** Require a verified Issue before PR creation, but allow unresolved identifiers in preflight. Use `.agents/skills/skills-repo-issue-from-idea/SKILL.md` when an Issue needs drafting. Show search candidates for confirmation instead of silently linking a similar Issue. Routine, umbrella, or partial work uses `Related: #N`; closing keywords require full completion, the default target branch, and explicit approval.
5. **Build a verification matrix.** Map actual changed areas to checks below. Only claim results from the analyzed version; disclose dirty tested state, historical results, skipped checks, and limitations. Use [PR Delivery Safety](references/pr-delivery-safety.md) for evidence, replacement handling, and retry rules.
6. **Draft from the current template.** Fill Summary, Test Results, Risks and Rollback, Related Issues, and Affected Areas in template order. Default body language is Chinese with the template's bilingual labels. Inspect current title rules; if none exist, use `<type>: <English description> --issue=#N`, consistent with this repository's recent history. Do not apply PR title rules to Issue titles.
7. **Handle updates and replacements.** Read the existing PR first. Preserve factual scope, Issue links, risks, original head/commit context, `Replaces #N`, and intentional `[WIP]` markers. Use the current template rather than an old body layout. Old test passes remain historical unless rerun.
8. **Confirm each remote action.** Show exact title/body, repository, base/head, Issue relation, labels, and verification results. Confirm Issue creation/edit, branch push, PR creation/edit, and metadata changes separately. Use the intended writable fork; never force-push without a separate explicit approval. A draft approval is not publication authorization.
9. **Write and read back.** Use a concrete body file with `gh issue` / `gh pr --body-file`. For raw API calls use `-F body=@<file>`, not `-f body=@<file>`. Do not use `gh pr create --dry-run` as a no-write guarantee. Read back title/body, base/head, Issue relation, and metadata after writing; confirm corrective edits. Inspect remote state before retrying ambiguous failures.

## Verification Matrix

| Changed area                           | Checks                                                                                                                          |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `skills/` business skills              | Trigger and scope, applicable skill references, relevant evals or scenarios; do not change them for repository-only maintenance |
| `.agents/skills/` maintainer workflows | Repository-only triggers, local template references, remote confirmation gates, separation from distributed skills              |
| `.github/` templates                   | YAML syntax, unique IDs, required fields, exact dropdown options, existing labels, chooser links, PR sections                   |
| `skills.sh.json`                       | JSON syntax, grouping names and paths; repository-local workflows must not be added as business skills                          |
| Documentation                          | Correct paths, intended audience, supported claims, valid links                                                                 |

`git diff <analyzed-base>...HEAD --check` supplements these checks; it does not execute agent scenarios or render GitHub forms. Do not assume a Go, frontend, or service build.

## Anti-patterns

WRONG: Enhance the distributed `create-github-pr` skill to configure this repository's own contribution process, or copy old test results into a new PR as current passes.

RIGHT: Use this local workflow and the repository's current templates; verify the actual changed version and report missing checks honestly.

## Checklist

- Business skills and maintainer workflows remain separate; no unrelated diff is included.
- Canonical comparison base matches the PR target; Issue association is verified and confirmed.
- Current template, affected areas, evidence, risks, and executable rollback are complete.
- Preflight performs no push or GitHub writes and ends with `No GitHub writes performed`.
- Every remote write has approval; readback matches the approved draft.

## See Also

- Repository-local Issue workflow: `.agents/skills/skills-repo-issue-from-idea/SKILL.md`.
- Authoritative templates: `.github/PULL_REQUEST_TEMPLATE.md` and `.github/ISSUE_TEMPLATE/`.
- [PR Delivery Safety](references/pr-delivery-safety.md): detailed evidence and submission rules.
- `evals/evals.json`: repository-maintainer scenario definitions, not proof of executed tests.
