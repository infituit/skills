---
name: reviewer-friendly-pr-split
description: Use when the user explicitly asks to split a too-large PR, make a current diff reviewer-friendly, diagnose why a PR is hard to review, decide whether stacked PRs are needed, or produce a handoff contract for executing an approved PR split.
---

# Reviewer-Friendly PR Split

## Overview

Split for reviewer cognition, not for line count. A good target PR is the smallest unit a reviewer can independently understand, validate, and accept risk for while keeping the base branch usable.

Default mode is read-only planning for an existing large diff. Do not implement the split unless the user separately asks for execution.

## Trigger Boundary

Use this skill only when the user is explicitly asking about PR splitting or reviewability, for example:

- "这个 PR 太大了，帮我拆"
- "make this PR reviewer-friendly"
- "reviewer 看不动，怎么拆"
- "should this be stacked PRs?"
- "给另一个 agent 一个拆 PR handoff"

Do not silently use it for ordinary implementation, ordinary code review, release planning, or generic Git operations.

## Evidence Routine

Start from the current diff, not file-name guesses.

1. Read the user's stated concern and any pasted diff summary.
2. Inspect `git status`, base branch, changed-file summary, and relevant hunks when available.
3. If the base branch cannot be determined safely, ask for the base branch.
4. Read adjacent code or project boundaries only when intent, dependency, risk, or verification cannot be judged from the diff.
5. Do not modify files, branches, commits, or remotes in planning mode.

If the user provides only a hypothetical diff, state that the plan is provisional and list the missing evidence.

## Diagnosis Axes

Classify why the PR is hard to review:

| Axis                   | Smell                                                                                          |
| ---------------------- | ---------------------------------------------------------------------------------------------- |
| Intent mix             | refactor, feature, bugfix, permission, docs, tests, performance, cleanup mixed together        |
| Layer mix              | API, storage, service, UI, docs, generated files, infra changed together                       |
| Risk mix               | mechanical or generated noise hides behavior, security, permission, migration, or data changes |
| Mechanical mix         | rename, move, formatting, generated output, import rewrite mixed with logic                    |
| Dependency disorder    | changes are ordered by author workflow instead of real prerequisite graph                      |
| Verification ambiguity | no PR has a clear independent check                                                            |
| Rollback ambiguity     | revert boundary would undo unrelated behavior                                                  |

## Split Rules

Prefer these cuts, in order:

1. **Mechanical first**: rename, move, import rewrite, formatting, and generated output should be isolated when they create review noise.
2. **Refactor before behavior**: behavior-preserving structure changes go before behavior changes that depend on them.
3. **Prepare / use / migrate / cleanup**: introduce a seam or helper, use it, migrate callers in coherent batches, then remove the old path.
4. **Risk first**: permission, security, data migration, storage semantics, and external contract changes deserve their own reviewer focus.
5. **Contract first**: API/schema/proto/type contracts can be separate only if the base remains usable and the contract is meaningful without exposing broken behavior.
6. **Vertical thin slice**: when a feature is too broad, make the first user-verifiable slice end-to-end, then add scenarios or edges.

Use stacked PRs only for true dependencies. Independent changes should be parallel PRs, even if they were authored in the same branch.

## Do-Not-Split Is Valid

Recommend `Do not split` when splitting would increase reviewer work: one intent, one behavior, one verification path, low risk, no mechanical/generated noise, and a clean rollback boundary.

When not splitting, still make the PR reviewer-friendly:

- explain scope and non-scope
- mark mechanical/generated sections if any
- state verification
- state rollback expectation
- tell reviewer what to focus on

## Output Contract

Use these sections. Wording may be flexible, but do not omit the core fields.

```markdown
## Diagnosis

- Intent mix: yes/no - evidence
- Layer mix: yes/no - evidence
- Risk mix: yes/no - evidence
- Mechanical mix: yes/no - evidence
- Dependency disorder: yes/no - evidence
- Verification ambiguity: yes/no - evidence
- Rollback ambiguity: yes/no - evidence

## Recommendation

Split into N PRs | Do not split

[Reason, including stacked vs parallel decision]

## Split Plan

1. PR title
   - Purpose:
   - Includes:
   - Excludes:
   - Depends on:
   - Verification:
   - Reviewer focus:
   - Rollback note:
   - Risk level: low | medium | high

## Review Contracts

[Repeat one contract per target PR. Use concrete files, hunks, modules, or change groups when known.]

## Open Questions

- none | [only questions that materially change split boundaries]
```

For `Do not split`, replace `Split Plan` with a reviewer-friendly PR description draft and explain why forced splitting would be worse.

## Apply Handoff Contract

If the user approves a plan and asks another agent to execute it, hand off the plan as contracts, not vague advice. Each target PR must include:

- `Must Include`
- `Must Exclude`
- `Dependency`
- `Verification`
- `Reviewer Focus`
- `Rollback`
- `Risk level`

Do not invent target PRs during handoff. If the approved split plan is not present in the current context and cannot be recovered from the current diff evidence, stop and ask for the approved plan or the target PR list. A generic PR1/PR2/PR3 template is not a handoff.

The handoff may say to use safe Git/worktree practices, but this skill does not define permission policy for `rebase`, `reset`, `push`, `cherry-pick`, or branch creation. Those decisions belong to the execution layer and the user's explicit authorization.

## Self-Check Before Final Answer

Before returning, check the proposed split:

- Does any target PR still contain multiple intents?
- Can each target PR be independently verified?
- Does a reviewer need to understand a future PR to review the current PR?
- Are mechanical/generated changes separated from logic when they create noise?
- Is any high-risk permission, security, storage, migration, or public contract change hidden inside an ordinary feature PR?
- Is `stacked` used only where a real dependency exists?
- Would a forced split be worse than one PR?

If any answer fails, revise the split before responding.

## Common Mistakes

| Mistake                                               | Correction                                                                                          |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Splitting by file names or line counts                | Split by review question, dependency, risk, and verification boundary.                              |
| Forcing every large PR into stacked PRs               | Stack only true dependencies; unrelated work is parallel.                                           |
| Hiding generated or mechanical changes in logic PRs   | Isolate or clearly mark them so reviewers can skip noise safely.                                    |
| Separating tests from the only behavior they validate | Keep fix and direct regression tests together unless using an explicit failing-test PR workflow.    |
| Producing vague PR titles only                        | Provide includes, excludes, dependency, verification, reviewer focus, rollback, and risk level.     |
| Inventing a generic handoff without the approved plan | Stop and ask for the concrete split plan or recover it from diff evidence before writing contracts. |
| Jumping into Git operations during planning           | Stay read-only until execution is explicitly requested.                                             |
