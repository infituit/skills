# GitHub Stack Operations

Use this reference for native GitHub stacks, conversion of existing PRs, and capability checks. It is not a replacement for the installed version's help.

## Model and Capability Gate

GitHub-native stacks use ordinary branches/PRs plus explicit stack membership/order. The bottom PR targets the agreed root branch; each higher PR targets its predecessor. A branch chain alone is not a registered native stack. No marker commits are required by the documented workflow.

Before using `gh stack`, inspect `gh --version`, `git --version`, installed extensions, `gh stack --help`, and help for the exact subcommand. Check the current official availability/host rules, repository permissions, same-repository restrictions, existing stack membership, queued/merged PRs, and all affected worktrees. Do not install an extension, enable repository features, or migrate an existing chain without confirmation.

The official pages have differed on minimum versions and push atomicity. Do not hard-code one minimum or promise all-or-nothing publishing; use installed capabilities and read back every affected ref/PR. If a required capability is unavailable, disclose the limitation and offer a confirmed ordinary PR-chain/parallel workflow or stop. Do not silently treat a fork chain as a native stack: native cross-fork stacks are not supported by the referenced workflow.

A fallback ordinary PR chain does not automatically inherit native stack behavior: verify each layer's effective branch protection and CI triggers, and do not promise automatic server-side descendant rebasing after merges. Include these differences in the fallback confirmation.

## Composition with PR Creation

Create ordinary PRs through `create-github-pr`, passing the explicit intended base. For dependent PRs, this means the parent branch, not the default branch. Confirm that the base branch exists in the target repository; a branch available only in a contributor's fork cannot silently become an upstream PR base.

After creation, `gh stack link <bottom-pr> <next-pr> ...` can register eligible open PRs in bottom-to-top order. Treat this as a separate remote write and inspect its current behavior first. Prefer explicit existing PR identifiers to avoid unintended branch pushes or PR creation. Do not register independent parallel changes as one stack.

## Side Effects and Constraints

| Command                 | Important behavior                                                                                                                                                               |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `view --json`           | Read state; use structured output to verify actual progress                                                                                                                      |
| `init`                  | Creates/adopts local tracking/branches, may checkout, and enables `rerere`; not read-only                                                                                        |
| `add`                   | Creates/checks out a layer; staging/commit flags can include untracked files                                                                                                     |
| `modify`                | Interactive TUI restructuring; saving can cascade rebases and rewrite history; no documented noninteractive reorder/removal interface                                            |
| `rebase`                | Fetches/replays layers locally; inspect descendants and recovery/continue/abort state; publishing is separate                                                                    |
| `push`                  | Writes remote branches using force-with-lease behavior; not merely a normal push, and does not create PRs                                                                        |
| `submit`                | Pushes and creates/updates PRs/stack; `--open` can mark existing PRs ready, not just new ones                                                                                    |
| `link`                  | Registers/extends remote membership; branch arguments can push/create PRs; mismatched PR bases can be changed; existing members are appended, not arbitrarily removed            |
| `sync`                  | Fetches/reconciles and may rebase, push, and update stack metadata; `--prune` can delete local branches; unresolved divergence can stop a noninteractive run with exit code zero |
| `unstack`               | Default changes remote association plus local tracking; `--local` limits it to local state; neither means closing PRs                                                            |
| `checkout --print-path` | Can still checkout when no matching worktree is already checked out; not categorically read-only                                                                                 |
| `merge`                 | Can merge the selected prefix, not only one layer; outside this skill                                                                                                            |

`modify` requires the documented eligible clean, linear history without unsupported merge/fork structure, queued PRs, or already merged layers. Do not invent flags or drive a TUI blindly in an agent session. Ask the user to perform a supported interactive step, or propose a separately approved ordinary Git reconstruction with verified native membership consequences. Do not silently unstack/relink to bypass a restriction.

Worktrees in the same clone share tracking and recovery state. Rebase/sync may update other affected clean worktrees; there is no automatic stash or worktree creation/deletion. Check the full affected set before authorization and execution.

The CLI does not provide a general automatic file/hunk splitter. Inserting an empty layer is not redistributing existing changes. Use the main skill's local reconstruction and equivalence checks.

## Sources

Re-read when capability or behavior matters:

- [About stacked PRs](https://docs.github.com/zh/pull-requests/get-started/about-stacked-prs)
- [Stacked PRs quickstart](https://docs.github.com/zh/pull-requests/get-started/stacked-prs-quickstart)
- [Stacked PRs CLI commands](https://docs.github.com/zh/pull-requests/reference/stacked-prs-cli-commands)
- [Other tools with stacked PRs](https://docs.github.com/en/pull-requests/reference/use-other-tools-with-stacked-pull-requests)
- [Official gh-stack guidance](https://github.com/github/gh-stack/blob/main/skills/gh-stack/SKILL.md)
- [gh-stack documentation and version notes](https://github.com/github/gh-stack)
- [Explicit base selection with gh pr create](https://cli.github.com/manual/gh_pr_create)
