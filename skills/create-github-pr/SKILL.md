---
name: create-github-pr
description: >-
  Use when preparing, creating, updating, or replacing a GitHub pull request for the current branch. Handles the complete workflow: resolve the canonical upstream and fresh base branch, analyze changes, require an associated issue, create an issue when no explicit issue number is available, read repository PR conventions, push the branch to an appropriate writable remote with confirmation, and create a PR that follows project standards. Trigger when the user says "create PR", "submit pull request", "open a pull request", "准备合并", "提交 PR", or mentions merging the current branch.
---

# Create GitHub PR

Prepare or create a GitHub pull request for the current branch while respecting repository conventions and requiring human confirmation before remote-changing actions.

## Operating Modes

- **Preflight**: for “准备 PR”, “draft”, or ambiguous intent, read local and remote metadata and return a complete draft without pushing or changing GitHub resources.
- **Create**: draft first, then confirm issue creation, branch push, and PR creation separately.
- **Update or replacement**: when explicitly requested, read the existing PR and use `references/pr-delivery-safety.md` to migrate its facts into the current template and confirm each edit. This does not authorize rewriting branches or closing the old PR.
- **Split**: use the existing split workflow only when requested or accepted; planning is not execution approval.

Draft approval does not authorize label, assignee, reviewer, or milestone changes. Use `references/pr-delivery-safety.md` for verification evidence, issue relations, readback, and retry safety.

## Core Rules

- A PR must be associated with at least one GitHub issue.
- Prefer explicit issue numbers only. Do not semantically guess a related issue from keywords.
- If the user gives an issue number in the current request, verify it and use it.
- If an issue number is found only in branch names, commit messages, or existing PR metadata, show it to the user and ask before using it.
- If there is no confirmed issue number, draft a new issue. Preflight may return both drafts with an unresolved issue placeholder; create mode must create or confirm an issue before creating the PR.
- Do not hard-code repository names, default branches, owners, forks, labels, title formats, or languages except as fallback behavior documented below.
- The PR comparison base and PR target base must be the same freshly fetched canonical upstream branch.
- Default issue and PR body language is Chinese unless the user or repository conventions clearly require another language.
- PR titles must follow repository rules even when the body language is Chinese.
- Prefer repository PR or merge templates over the skill fallback PR body. Use the fallback PR body only when no repository PR template exists.

## When to Use

Use this skill when the user wants to create, open, submit, prepare, update, or replace a pull request for the current branch.

Common prompts:

- "Create a PR for this branch"
- "Submit a pull request"
- "Open a pull request"
- "准备合并到主分支"
- "提交 PR"
- "帮我发起合并请求"

Do not use this skill for code review only, commit creation only, or issue creation that is not part of a PR workflow.

## Confirmation Policy

Run read-only discovery automatically. Ask before every remote-changing or potentially wrong-linking action.

Automatic:

- Read git status, remotes, branches, commits, diffs, templates, workflows, and label rules.
- Fetch the canonical upstream base branch.
- Verify issue existence and repository metadata.
- Draft issue and PR content.

In preflight, stop at drafts even if the issue or head branch is not published. A fetch may update local remote-tracking refs; if the user forbids local changes or network refresh, use the existing ref and explicitly report that its freshness is unverified.

Must confirm:

- Using issue numbers inferred from git context rather than the user's current request.
- Creating a new issue.
- Pushing a branch to any remote.
- Any `--force-with-lease` push. Never force push without a separate explicit confirmation.
- Creating or editing the PR, and each issue edit or metadata change requested separately.

## Workflow

1. Resolve repository, canonical upstream, and base branch.
2. Analyze the current branch against the freshly fetched base.
3. Resolve the required issue association.
4. Draft a new issue when no confirmed issue exists; create it only after the create-mode confirmation.
5. Read PR conventions and draft the PR; finish here in preflight mode.
6. Ensure the branch is pushed to an appropriate writable head remote.
7. Create the PR after confirmation.
8. Verify and report the created issue and PR.

## Step 1: Resolve Repository and Base

Resolve the real upstream before diffing. Do not trust a stale tracking branch or a fork default branch as the base.

Gather:

```bash
git remote -v
git branch -vv
```

Base resolution rules:

1. If the user explicitly specifies a base branch or commit range, use it exactly.
2. Otherwise, identify the canonical upstream repository:
   - If the current repository is a fork, use its parent as canonical upstream.
   - Otherwise, use the repository itself.
   - Match the canonical owner/name to a local remote URL, regardless of whether the remote is named `origin`, `upstream`, or something else.
3. Determine the canonical default branch with `gh repo view --json defaultBranchRef` or `git remote show <canonical-remote>`.
4. Fetch the canonical base before analysis:

```bash
git fetch --prune <canonical-remote> <base-branch>
```

5. Ignore tracking branches marked `[gone]` when choosing the diff base.
6. If no canonical remote exists locally, ask which remote and branch should be used as the PR base before drafting issue or PR content.

After fetch, compute the merge base and analyze the branch:

```bash
git status
git log --oneline -10
git merge-base HEAD <canonical-remote>/<base-branch>
git diff $(git merge-base HEAD <canonical-remote>/<base-branch>)..HEAD --stat
git diff $(git merge-base HEAD <canonical-remote>/<base-branch>)..HEAD
```

Extract:

- Current branch name.
- Tracking remote and whether it is valid, stale, or gone.
- Canonical upstream remote and freshly fetched base branch.
- Commit messages in scope.
- Files changed with line counts.
- Actual code changes and motivation inferred from commits and diff.

Summarize the changes in 2-3 sentences focused on what changed and why.

## Step 2: Resolve Required Issue Association

The PR must link at least one issue. Only explicit issue numbers count.

Explicit issue sources:

- The user's current request, such as `#123`, `issue #123`, `GH-123`, `--issue=#123`.
- Branch names, such as `fix/issue-123-login-timeout`.
- Commit messages, such as `fix: resolve timeout --issue=#123`.
- Existing local PR metadata, if any.

Rules:

1. If the user provided issue numbers in the current request, verify them and use them without an extra issue-selection checkpoint.
2. If issue numbers are inferred from git context, show the numbers and source snippets, then ask whether to use them.
3. If multiple issue numbers are found, ask which one or more should be linked.
4. If no issue number is confirmed, draft a new issue; create it only in create mode after confirmation.
5. Do not run semantic issue search or bind an issue only because its title or labels look related. If the user asks to find an existing or long-lived tracking issue, show candidates and confirm the selected number before linking; discovery alone is not association approval.

Verify issue numbers:

```bash
gh issue view <issue-number> --repo <canonical-owner>/<repo> --json number,title,state,labels,url
```

If the issue does not exist or is not usable, explain the problem and ask for another number or draft a new issue. Preflight never creates it; create mode still requires confirmation.

## Step 3: Create Issue When Needed

Read issue templates before drafting:

```bash
ls .github/ISSUE_TEMPLATE/
```

Also inspect `.github/ISSUE_TEMPLATE/config.yml` when present.

Template rules:

1. Prefer repository templates over a generic body.
2. Preserve template `title`, `labels`, and field order.
3. If exactly one template clearly matches the change type, use it.
4. If multiple templates may match, recommend one in the confirmation checkpoint and let the user change it.
5. Use the fallback issue structure only when no applicable template exists and the repository allows it; blank issues being enabled does not override a matching template.
6. If blank issues are disabled and no template can be reliably selected, ask the user to choose a template.
7. For YAML forms, render input labels as Markdown headings in field order, retain dropdown values and required fields, and never invent checklist confirmations, reproduction, environment, or logs. Verify labels exist; do not create missing labels without authorization.

Default issue language is Chinese unless repository templates or user instructions require another language. Keep code identifiers, package names, labels, and technical keywords in English where natural.

Fallback issue body:

```markdown
## 背景

[为什么需要这次变更]

## 目标

[这次 PR 要解决或交付什么]

## 变更范围

- [主要变更 1]
- [主要变更 2]

## 验收标准

- [可验证结果 1]
- [可验证结果 2]
```

### Issue Confirmation

In preflight, return the issue draft without creating it. In create mode, before creating the issue, present:

```text
I'll create an issue with:
- Repository: <owner/repo>
- Template: <template name or fallback>
- Title: <title>
- Language: <language>
- Labels: <labels>

Body:
<full body>

Should I proceed? (yes/no, or suggest changes)
```

After confirmation, create it:

```bash
gh issue create \
  --repo <owner/repo> \
  --title "<title>" \
  --body-file <confirmed-body-file> \
  --label "<label1>" \
  --label "<label2>"
```

Immediately verify it:

```bash
gh issue view <issue-number> --repo <owner/repo> --json number,title,body,labels,state,url
```

If created content differs from the confirmed draft, pause, show the difference, and confirm the specific edit before correcting and verifying again.

## Step 4: Read PR Conventions

Read repository PR conventions before drafting. Treat repository PR or merge templates as the authoritative body structure; the skill fallback PR body is only for repositories without a PR template.

Check for PR templates in all supported locations:

- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE/`
- `docs/PULL_REQUEST_TEMPLATE.md`
- `PULL_REQUEST_TEMPLATE.md`

Check workflows and labelers:

```bash
ls .github/workflows/
rg -n "title-regex|semantic|pull_request|pull_request_target|labeler|actions/labeler|--issue|closes|fixes" .github
```

Check labeler configuration when present:

```bash
ls .github/labeler.yml .github/labeler.yaml
```

Parse:

- Required PR title format.
- Required issue reference syntax.
- Allowed PR types, such as `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.
- Target branch restrictions.
- Auto-label rules based on changed files.
- PR body template fields and required checklists.

If PR target branch rules differ from the base used for diff analysis, re-run analysis against the intended PR base before drafting.

## Step 5: Draft PR

Title rules:

1. Follow repository title lint exactly when present.
2. If no title rule is found, use a concise conventional title:

```text
<type>: <english description> --issue=#<issue-number>
```

3. Keep PR title in English when repository rules require English-compatible characters.
4. Do not apply PR title format to issue titles.

Body rules:

1. If a repository PR or merge template exists, use it as the body structure and fill its fields.
2. Link the confirmed issue by default without implying merge-time closure, for example `Related: #<issue-number>`.
3. Use a closing keyword such as `closes #<issue-number>` only when the PR base is the default branch and the user explicitly confirms they want the issue closed when the PR merges.
4. If the template has an issue-closing field but auto-close is not confirmed, fill it with a non-closing issue reference instead of `closes` or `fixes`.
5. If no repository PR template exists, use the skill fallback PR body in `references/fallback-pr-template.md`.
6. Apply `references/pr-delivery-safety.md`: map affected areas to actual checks, separate current-HEAD results from historical evidence, and include risks and executable rollback. For update/replacement work, preserve old context but use the current template.
7. Long-lived, umbrella, or partial-delivery issues stay non-closing even when another issue is fully completed. Repository issue-closing rules and explicit confirmation must both be satisfied.

Fallback PR body: `references/fallback-pr-template.md`

Predict labels from labeler rules and changed files when possible. Present them as predicted labels, not as guaranteed labels.

### PR Confirmation

Before creating the PR, present:

```text
I'll create a PR with:

Repository: <canonical-owner/repo>
Title: <title>
Base: <base-branch>
Head: <head-owner>:<branch-name>
Issue: #<issue-number> <issue-title>

Body:
<full body>

Predicted auto-labels: <labels or none detected>

Should I proceed? (yes/no, or suggest changes)
```

Wait for explicit confirmation. If the user suggests changes, revise and confirm again.

## Step 6: Push Head Branch

The base branch belongs to canonical upstream. The head branch should belong to a remote the user can write to.

Before pushing:

```bash
git branch -vv
git remote -v
git status
```

Rules:

1. If the current branch is already pushed and the remote contains `HEAD`, use it as PR head.
2. If the current branch has a valid tracking remote and it is writable, ask before a normal push to that remote.
3. If tracking is `[gone]`, missing, or points somewhere unusable, identify a writable fork/user remote and ask before pushing there.
4. If the only possible push requires `--force-with-lease`, explain why and ask for separate explicit confirmation.
5. Never use plain `--force`.
6. Never push to the canonical upstream when the repository workflow expects fork-based PRs unless the user explicitly confirms they have direct-push workflow rights.

Normal push:

```bash
git push -u <head-remote> <branch-name>
```

Force-with-lease only after separate confirmation:

```bash
git push --force-with-lease <head-remote> <branch-name>
```

## Step 7: Create PR

Prefer `gh pr create` when the head repository can be represented directly.

Same repository or already selected remote:

```bash
gh pr create \
  --repo <canonical-owner/repo> \
  --base <base-branch> \
  --head <head-owner>:<branch-name> \
  --title "<title>" \
  --body-file <confirmed-body-file>
```

If `gh pr create` cannot express the fork workflow reliably, use the GitHub API:

```bash
gh api repos/<canonical-owner>/<repo>/pulls --method POST \
  -f title="<title>" \
  -f head="<head-owner>:<branch-name>" \
  -f base="<base-branch>" \
  -F body=@<confirmed-body-file> \
  --jq '.html_url'
```

Capture the PR URL.

Immediately verify:

```bash
gh pr view <pr-url-or-number> --repo <canonical-owner/repo> --json title,body,baseRefName,headRefName,headRepositoryOwner,url,closingIssuesReferences,labels
```

Confirm:

- The title matches repository rules.
- Base matches the analyzed base.
- Head matches the pushed branch.
- The PR body links or closes the confirmed issue.
- Expected labels are either applied or described as auto-labeler predictions.

## Error Handling

### No confirmed issue

Stop before PR creation. Either create an issue through Step 3 or ask the user for an explicit issue number.

### Issue not found

Show the attempted issue number and repository, then ask for another issue number or proceed to new issue creation.

### Title format validation failed

Show:

- The repository's title rule or regex.
- The attempted title.
- The exact mismatch if known.
- A corrected title.

Ask for confirmation before retrying.

### Branch not pushed or head SHA blank

Check `git branch -vv` and remote configuration. Push to the confirmed writable head remote, then retry PR creation.

### Wrong base detected late

Stop PR drafting, fetch the intended base, re-run diff analysis, and regenerate issue/PR summaries if the change scope differs.

### Missing templates

Use the fallback PR body only when no repository PR template exists. Use the fallback issue body only when no applicable issue template exists and repository rules allow it; blank issues being enabled does not override a matching template.

## Final Report

For preflight or update/replacement work, use the mode-specific delivery report in `references/pr-delivery-safety.md`; never claim a draft was created on GitHub. After successful PR creation, report:

```text
PR created successfully.

Issue: <issue-url>
PR: <pr-url>
Base: <base-branch>
Head: <head-owner>:<branch-name>
Predicted/applied labels: <labels>
Title rule: <rule followed or fallback used>
```

Mention any verification that could not be completed and why.
