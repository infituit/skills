# PR Delivery Safety

## Draft and Remote Actions

Preflight returns the exact title, analyzed scope, base/head, confirmed or unresolved issue relation, complete current-template body, predicted labels, and verification evidence. End with `No GitHub writes performed`. Do not push or create an issue merely to complete a draft.

Confirm each remote action separately: branch push, issue create/edit, PR create/edit, and metadata changes such as labels or reviewers. Text approval alone does not authorize these actions. Keep existing force-with-lease and split-execution confirmation requirements.

## Issue Relationships

- Use a verified issue number from the current request, or a candidate explicitly confirmed by the user. Do not attach a semantically similar issue automatically.
- When asked to find an existing tracking issue, show its scope and number for confirmation before linking. Do not create a duplicate once an applicable issue is confirmed.
- Use `refs #N`, `Related: #N`, or `related to #N` for routine, umbrella, long-lived, or partial delivery.
- A closing keyword requires full completion of the issue scope, a PR targeting the default branch, repository-rule compatibility, and explicit user confirmation.
- `Replaces #<old-pr>` identifies a replacement; it does not decide whether the associated issue should close.

## Verification Evidence

Build a small matrix from changed paths and actual behavior, not from file counts:

| Area                | Behavior or contract affected          | Check                            | Result and evidence                    |
| ------------------- | -------------------------------------- | -------------------------------- | -------------------------------------- |
| Actual changed area | What changed or was verified unchanged | Exact command or manual scenario | Passed, failed, or not run with reason |

Read applicable contribution rules, nearby tests, scripts, and evals to select checks. For skill changes, examine trigger boundaries, workflow steps, references, and relevant scenarios. For templates/configuration, validate syntax, required fields, referenced paths, and supported options. For other repositories, use their own checks rather than assuming a language or build system.

Only report a check as passed if it ran against the analyzed HEAD. If validation included uncommitted files, state that tested state rather than calling it a HEAD result. Historical PR/commit/CI results remain historical unless rerun. Suggested commands are not completed checks. Explain skipped checks and the remaining validation boundary.

Use the repository's current affected-area fields and include impact notes; labels do not replace impact analysis. Describe concrete compatibility or workflow risks and an executable rollback/revert path. Do not invent test, environment, risk, or acceptance facts.

## Update and Replacement

Read the existing PR's title, body, issue references, base/head, commits, labels, and verification context. Use its body as a source of facts, not as the new structure.

Migrate those facts into the current repository template. Preserve original head/commit context, issue links, test and risk notes, and `Replaces #<old-pr>` when applicable. Identify historical checks that were not rerun. Preserve an intentional `[WIP]` marker and report a title-rule conflict rather than silently removing it.

Show the exact proposed edit and confirm it. Updating a PR body does not authorize changing branches, closing the old PR, or modifying metadata. Use `gh pr edit <pr> --repo <owner/repo> --title "<title>" --body-file <confirmed-body-file>` for a confirmed title/body update, then read back.

## Submission, Readback, and Retry

- Write confirmed multiline Markdown to a concrete temporary file and use `--body-file` with `gh issue` / `gh pr` commands.
- For a raw API request, `-F body=@<file>` reads a file; do not use `-f body=@<file>`, which can send the literal path.
- Do not treat `gh pr create --dry-run` as a no-write guarantee; it may push a branch.
- After each successful write, read the issue/PR back and compare the title, body, issue relation, base/head, and requested metadata with the approved draft.
- If readback differs, pause and confirm the corrective edit before writing again.
- If a create command fails after possibly creating a resource, inspect remote state before retrying. Report any partial success; never blindly repeat a create request.

## Delivery Report

Report the mode, issue URL/number and relation, PR URL/title/base/head, changed scope, observed versus predicted labels, actual checks and skipped checks, risks/rollback, and actions performed or pending. Draft-only output has no fabricated URLs or success claims. Keep action authorization and publication notes outside the public PR body.
