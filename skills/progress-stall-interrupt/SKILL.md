---
name: progress-stall-interrupt
description: Use when an agent repeats the same class of action, retry, wait, sleep, poll, formatting fix, parser/schema repair, tool-call adjustment, or side investigation without new evidence, especially when stalled progress or a minor issue starts consuming the main objective.
---

# Progress Stall Interrupt

## Overview

Progress Stall Interrupt protects the active main objective when agent activity stops producing new evidence. It is a checkpoint supervisor, not a loop ban. Productive debugging, polling, formatting, test-fix, and verification loops may continue while each iteration changes the evidence, hypothesis, input, verification method, or externally observed state.

Core invariant:

```text
Do not repeat the same class of action without new evidence.
```

First principle:

```text
Protect the main objective. A side issue must not become the task unless the user explicitly promotes it.
```

## When to Use

Use this skill when you detect a possible no-progress loop:

- formatting feedback loop, formatter-agent oscillation, or lint/prettier churn
- schema/parser retry loop or structured-output repair loop
- repeated tool-call parameter adjustment after the same invocation error
- repeated test/build/debug attempt with the same failure and no new diagnostic clue
- repeated sleep, wait, or poll where status remains unchanged
- background task wait where completion, failure, or progress is not observable
- a minor warning, style issue, optional check, or citation problem starts consuming the main task
- same-action retry rationalized as patience, thoroughness, or one more attempt

Do not use this skill to interrupt productive iterative work. A loop is productive when every iteration produces an evidence delta that justifies the next action.

## Progress Budget

On first sign of a possible loop, set a small progress budget. The budget is internal by default.

Default rule:

```text
After 2 same-class attempts or waits without new evidence, checkpoint before the 3rd.
```

Make the budget explicit to the user when the loop involves external/background waiting, visible repeated failure, a side issue blocking the main flow, significant time/token/money/external-resource cost, or possible scope change.

Waiting is not progress. Only state change is progress.

Counts as waiting progress:

- `queued -> running`, `running -> completed`, `running -> failed`, or another material state transition
- new log lines, progress percentages, artifacts, status codes, errors, or ETA
- a changed process/task/tool state that changes the next action

Does not count as waiting progress:

- `still running`, `no output yet`, same status as before, elapsed time alone, or "maybe not done"
- another sleep with no new check target
- assuming the backend is still working when no observable state changed

## What Counts as Evidence

New evidence must change the current hypothesis, blocker understanding, next action, or confidence.

Counts as new evidence:

- new error text, log output, stack trace, diagnostic, or tool status
- newly inspected source, config, schema, parser rule, formatter rule, docs, or authoritative contract
- new user input or clarified acceptance criteria
- changed environment state, artifact, process state, or background-task result
- a changed input, changed hypothesis, or changed verification method

Does not count as new evidence:

- rephrasing the same error
- trying the same edit again
- changing only formatting while the parser reports the same violation
- another guessed tool-call shape without reading the tool contract
- another sleep or poll with unchanged status
- agent preference, perfectionism, or "this might matter" speculation

## Mainline Blocker vs Side Issue

A problem is a mainline blocker only if it prevents the user-requested outcome from being completed or verified. Otherwise, treat it as a side issue.

Mainline blockers may continue only with new evidence or a changed strategy:

- requested test still fails
- requested build still fails
- requested parser/schema-valid output is still rejected
- requested deployment or background result is unknown, failed, or unverifiable
- requested bugfix cannot be verified because the same failure remains

Side issues must not be promoted by the agent:

- unrelated lint warnings or pre-existing test failures
- non-blocking formatting or style differences
- optional optimizations, elegance concerns, or speculative cleanup
- noisy tool output that does not affect the requested result
- citation, documentation, or example gaps that do not block the main deliverable
- non-critical background waits when the main work can continue

When a side issue exhausts the progress budget, ask the user. Do not autonomously continue, ignore, bypass, defer, or deep-dive under this skill.

## Checkpoint Routine

Before the next same-class action after budget exhaustion:

1. Restate the main objective in one line.
2. Name the stalled issue and the repeated action class.
3. Classify it as mainline blocker or side issue.
4. List what was tried and why it produced no evidence delta.
5. State the cost of continuing and the risk of not continuing.
6. Give one short recommendation.
7. Wait for the user when the issue is side-path, scope-changing, or cost-sensitive.

Ask decisions, not facts you can inspect yourself. Read logs, statuses, schemas, configs, source, and tool contracts before asking.

## User Checkpoint Format

For side issues, use this shape and stop:

```text
I hit a side issue that is starting to block the main flow.

Main objective: ...
Side issue: ...
Why it may not be a mainline blocker: ...
Tried: ...
No-progress signal: ...
Cost of continuing: ...
Risk if not pursued now: ...
Recommendation: ...

Choose:
A. Continue the main task and ignore this side issue
B. Work around it now and revisit later
C. Promote it: pause the main task and solve this first
D. Provide more context before deciding
```

For mainline blockers, use this shape when no evidence-producing next step remains:

```text
The main blocker is stalled.

Main objective: ...
Blocker: ...
Tried: ...
Evidence status: ...
Budget status: ...
Available strategies: ...
Recommendation: ...

Choose:
A. Continue with the recommended new strategy
B. Try a different strategy
C. Stop and report current state
D. Provide more context before deciding
```

## Forbidden Behavior

Do not:

- repeat the same class of action without new evidence
- sleep, wait, or poll a third time with unchanged status
- treat elapsed time as progress
- let a minor issue consume the main task
- autonomously ignore, bypass, defer, or deep-dive a side issue after checkpoint trigger
- ask the user a question without the fact packet needed to decide
- ask for facts that logs, source, configs, schemas, docs, or tool status can answer
- relabel agent preference, style, or perfectionism as a blocker
- let formatter/parser/schema compliance override the original user goal

## Interaction With Other Workflows

This skill does not replace domain workflows. It supervises them.

Priority order:

1. Safety and irreversible-operation rules
2. Explicit user instruction
3. Domain workflow or skill
4. Progress-stall checkpointing
5. Agent preference or perfectionism

Examples:

- Debugging may continue while hypotheses change and observations accumulate.
- Test/build fix loops may continue while failures change or diagnostics deepen.
- Formatter/parser repair may continue after reading the exact rule being violated.
- Background waiting may continue while status changes or logs advance.
- Any of these must checkpoint when the next step is just another same-class attempt without evidence.

## Self-Check Scenarios

```text
Scenario: Parser rejects JSON twice with the same missing-field error. The agent wants to regenerate guessed JSON again.
Expected: Interrupt before the third attempt unless the agent first reads the schema or exact parser contract.
```

```text
Scenario: A background task is polled twice and remains "running" with no new logs or artifacts.
Expected: Check task/process/log status through a different source or checkpoint before another wait.
```

```text
Scenario: A requested failing test now fails with a different assertion after a fix.
Expected: Continue; the changed assertion is new evidence.
```

```text
Scenario: An unrelated lint warning appears while the requested bugfix is verified. The agent spends two attempts trying to clean it up.
Expected: Ask the user with a side-issue checkpoint. Do not silently continue cleanup.
```

```text
Scenario: Formatter rewrites the agent's preferred line shape twice, but tests and lint pass.
Expected: Treat the formatter output as authoritative unless the user goal required a different format. Do not fight the formatter.
```

## Compact Rule

```text
Loop is allowed. No-progress loop is not.
Set a small budget early.
Two no-progress same-class actions exhaust the default budget.
Before the third, checkpoint.
Mainline blockers can continue only with new evidence or changed strategy.
Side issues must ask the user.
Protect the main objective.
```
