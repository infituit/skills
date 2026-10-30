---
name: restructure-github-prs
description: Use when a user wants to execute a PR split, redistribute commits or hunks across PRs, change PR dependencies or order, or maintain dependent PRs after a lower layer changes or merges. Also use when an accepted split plan during PR creation is ready for execution. Not for ordinary review fixes, CI fixes, or merging PRs.
---

# Restructure GitHub PRs

Turn an agreed review boundary into verified branches and PRs. Preserve the combined change, keep each PR focused, and keep the user informed when the plan no longer fits reality.

## Composition and Scope

- **Required for an undecided split:** use `reviewer-friendly-pr-split` for read-only diagnosis and concrete review contracts. Accept `Do not split`; do not force a stack. A concrete approved plan does not need another full diagnosis.
- **Required when creating a PR:** use `create-github-pr` for repository conventions, confirmed issue association, drafts, push/create confirmations, and read-back verification. Pass each layer's explicit base and head; do not silently substitute trunk for its parent.
- During ordinary PR creation, `create-github-pr` owns the lightweight suggestion. A choice to plan goes to `reviewer-friendly-pr-split`; enter execution here only after the user requests it. Declining a suggestion means continuing the single-PR workflow, not repeated persuasion.
- This skill owns restructuring, not code review, severity classification, feature implementation, CI repair, or merge decisions. Consume confirmed review conclusions without inventing a review gate. Do not fold incidental fixes into the split.
- Read target-repository instructions, templates, and verification entrypoints. Do not hard-code a repository, default branch, language, or build command.

## 1. Establish Evidence and One Plan

Inspect status (including staged, unstaged, and untracked work), remotes, worktrees, commits, actual hunks, the fresh target base, and existing PR head/base/state. Use `gh` structured reads for PRs. Resolve ambiguous repository, base, or source scope before planning writes.

Record original source/base SHAs, affected local and remote branch tips, PR numbers, and the approved scope in a session checkpoint. Keep recovery refs for source commits before reconstructing history. Uncommitted work is excluded unless the user explicitly includes it; do not stash, discard, or copy it into target PRs automatically.

Use the existing split plan as the single execution contract. Add this mapping before execution:

| Target PR | Original commits / files / hunks | Includes / Excludes | Dependency and base | Existing PR to retain / new PR | Issue | Checks | History / remote effects |
| --------- | -------------------------------- | ------------------- | ------------------- | ------------------------------ | ----- | ------ | ------------------------ |

Carry forward `Must Include`, `Must Exclude`, `Dependency`, `Verification`, `Reviewer Focus`, `Rollback`, and `Risk level`; do not replace them with vague titles. One issue may serve multiple PRs after confirmation; do not create an issue per layer or infer closing intent.

Prefer keeping existing PR numbers and discussion where their intent still fits. Explain replacements and old-to-new mappings before requesting permission to close or replace a PR. Keeping a number cannot guarantee preservation of line comments or approvals after history changes.

Independent changes target the agreed root base in parallel. Only true dependencies target a parent branch. A traditional PR chain is not automatically a registered GitHub-native stack. Read [GitHub stack operations](references/github-stack.md) before choosing or operating the native path; disclose unsupported environments and confirm a fallback rather than silently migrating workflows.

## 2. Separate Plan Approval from Operation Authorization

| Operation                                                                                     | Permission boundary                                                                                                  |
| --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Status, diff, logs, PR reads, capability/help checks                                          | Read-only discovery; fetch the identified base as needed                                                             |
| Create isolated worktree/recovery refs; reconstruct local commits                             | Explicit approval to execute the bounded local plan                                                                  |
| Push; create PR/issue; edit PR base/title/body; register/unregister a stack; close/replace PR | Confirm the specific remote action and targets before each action; retain `create-github-pr` checkpoints             |
| Rewrite published history                                                                     | Separate explicit confirmation, including affected branches and descendants; use lease protection, never plain force |
| Merge PRs                                                                                     | Outside this skill; never merge a PR as part of restructuring                                                        |

Plan approval alone authorizes no writes. Local execution approval is not publishing approval. A bundled CLI command inherits every side effect it can perform, not just the effect suggested by its name.

## 3. Reconstruct in Isolation

Use an existing suitable isolated worktree or create one at a confirmed, unused location. Check existing worktrees and repository rules first; verify project-local worktree directories are ignored without silently editing or committing `.gitignore`. Prefer an external location when appropriate. Do not switch, clean, or reset the user's working tree.

Build new target branches in dependency order from the recorded base or completed parent. Reuse whole commits when their intent fits. For a mixed commit, reconstruct selected file/hunk changes in the isolated worktree and commit only the approved scope; same-file edits may require hunk-level separation. Preserve relevant attribution and repository signing rules. Do not disable signing to work around a failure.

Do not move existing source refs or branches checked out elsewhere merely to construct candidate results. Worktrees share refs, configuration, and native stack metadata: isolation is not permission to run clone-wide rewriting commands. Inspect the blast radius before any rebase/sync.

Resolve only conflicts whose intended result follows the approved mapping and unchanged semantics. When a dependency invalidates the plan, promptly tell the user:

1. What concrete change cannot fit its assigned PR, and why.
2. Which targets and checks are affected.
3. The smallest proposed boundary/order change and its consequences.
4. What is paused and what can proceed independently.

Update the same mapping and wait for approval of the revised scope. Do not silently combine PRs, add a helper, fix unrelated behavior, or defer this update until the final report. Preserve the worktree and checkpoint on failure; offer recovery steps rather than automatically deleting the evidence.

## 4. Verify Before Publishing

Check both the parts and the whole; a successful Git command or top-layer test is not sufficient.

- **Each target:** inspect its actual incremental diff against its intended base, including staged/new files and generated output where relevant. Confirm Includes / Excludes and absence of unrelated hunks. A dependent layer is verified on its parent, not directly on trunk.
- **Applicable checks:** run the target's agreed repository checks. Choose checks by scope and risk rather than blindly running the entire repository suite on every layer. Record failures and unrun checks honestly.
- **Combined result:** on the same recorded root base, compare the recomposed result with the original source snapshot. For one linear chain, tree equality at its tip is useful evidence. Parallel branches require temporary local integration of all targets; no single tip contains the whole change.
- **History versus behavior:** use `git range-diff` to explain rewritten commits, not as sole proof of equivalence after splitting. Exact tree equality verifies content, not every behavioral property. If a changed base or approved adaptation prevents equality, explain each difference and its verification; never claim automatic equivalence.
- **Original work:** re-check the original worktree's HEAD, index, tracked edits, and untracked files against the checkpoint. Ensure it was not changed or incorporated accidentally.

Do not publish a candidate that does not match the approved contract. Report the execution/verification mismatch and synchronize the next step with the user; this is not a new code-review severity framework.

## 5. Publish and Maintain

Re-read affected remote tips before publishing. If they moved since the checkpoint, pause and reconcile with the user; do not overwrite collaborator changes. Use a lease tied to the expected remote SHA when authorized to rewrite a branch. Do not refresh a lease to conceal unexpected movement.

Apply confirmed remote actions in dependency order. Reuse `create-github-pr` for new PRs with the exact per-layer comparison base, head, confirmed issue, and template-compliant draft. For existing PRs, confirm edits and preserve their context while updating stale scope, risks, verification notes, and dependency links.

For subsequent lower-layer changes or merges, inspect actual merge strategy and current refs before replaying descendants. Restack only affected branches in order; do not duplicate already merged changes, assume squash merge preserves commit identity, or rewrite unrelated parallel PRs. Re-run per-layer and combined checks and obtain fresh publishing/force-with-lease permissions.

Immediately read back actual PR state after each remote action: head/base, title/body, issue references, and applicable checks. For native stacks, verify membership/order too. A CLI exit code of zero is not proof that synchronization completed. Partial publication is partial completion: record successful actions before deciding whether any retry is safe.

## Delivery

Report the original-to-result mapping, actual branch/PR URLs and dependencies, retained/replacement PRs, checks and equivalence evidence, any remaining mismatches or unrun checks, and the recovery checkpoint/worktree. Distinguish local-only preparation from remote publication. Do not close old PRs, remove recovery refs/worktrees, create follow-up issues, or merge anything without explicit authorization.

## Example

A single commit contains helper extraction A, caller migration B, and unrelated README correction C. The approved contract retains old PR #90 for B and associates all targets with confirmed issue #42. Construct A from trunk, B from A, and C independently from trunk; split hunks if A/B touch the same file. Validate each diff, integrate B+C temporarily to compare with the original tree, then ask for the required publishing permissions. Do not stack C merely because it came from the same commit.

## Common Mistakes

| Mistake                                                      | Correction                                                        |
| ------------------------------------------------------------ | ----------------------------------------------------------------- |
| Preserve mixed commits at the expense of focused PRs         | Preserve meaning; split commits/hunks when necessary              |
| Re-run planning or recursively suggest splitting every layer | Reuse the approved mapping; revisit only material mismatches      |
| Verify only the top branch                                   | Verify each incremental layer and the combined result             |
| Treat worktrees as separate clones                           | Inspect shared refs/metadata and other checkouts before rewriting |
| Use `sync` as a read or assume `submit` only creates PRs     | Check the side-effect reference and installed command help        |
| Quietly change scope after discovering a dependency          | Explain immediately, revise the mapping, and wait for approval    |
