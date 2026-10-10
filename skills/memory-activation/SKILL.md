---
name: memory-activation
description: Turns loaded task-specific skills into memory recall triggers so past lessons affect the current workflow. Use when a task-specific/action skill is loaded, when deciding whether a skill should trigger memory recall, or when recalled memory must be adopted, ignored, or deferred.
---

# Memory Activation

Skill loading is a task classifier. Use it as the trigger to retrieve same-scope lessons before acting.

## Quick Start

When an action skill is loaded for a user task:

```json
memory_lesson_recall {
  "query": "<skill-name> <task-type> <user-request> <project> <known-files-tools-resources>",
  "limit": 5,
  "minConfidence": 0.1
}
```

Then apply the result:

```text
Adopted: relevant workflow lesson -> add its constraint to the plan.
Ignored: unrelated same-domain lesson -> current task does not share that condition.
Plan changed: run the adopted constraint before the risky action.
```

## Why

Memory is ineffective when recall is optional. Task-specific skills are the stable activation surface: they identify the workflow early enough for lessons to change the plan.

## Workflow

1. Decide whether the loaded skill is task-specific/action-oriented: it performs work, makes a decision, modifies files, operates external systems, creates or reviews artifacts, or follows a workflow.
2. Skip reference-only, memory-management, and purely explanatory skills unless the current task will act on files, resources, or decisions.
3. Run `memory_lesson_recall` before acting. Build the query from the skill name, task type, user request, project, and known files/tools/resources.
4. If no result is clearly relevant, retry once with a broader or alternate query.
5. Also run `memory_smart_search` when files or external resources will change, project-specific history could matter, the user references prior work, or lesson recall remains weak after retry.
6. Apply recall before continuing: adopt relevant results into the plan, ignore irrelevant results with a reason, or defer explicitly.
7. For todo-managed work, adopted memory must change the todo or plan. For small tasks, it must change the next action.
8. Do not dump recall results. Mention memory only when it changes the plan, conflicts with current instructions, explains a skipped recall, or memory tools are unavailable.
9. If required recall fails, retry once with a changed query or narrower tool. If it still fails, continue only after stating memory was unavailable.

## Anti-patterns

WRONG: load a task-specific skill, skip same-scope lessons, and repeat a known workflow mistake.

RIGHT: use the loaded skill as the memory trigger, recall same-scope lessons, and turn relevant hits into constraints before acting.

## Checklist

- The loaded skill was classified as action/task-specific or explicitly skipped.
- The recall query included skill name, task type, user request, project, and known files/tools/resources where available.
- Weak or empty lesson recall was retried once with a changed query.
- Relevant results were adopted, ignored with reason, or deferred.
- Adopted memory changed the plan, todo, checklist, or next action.
- Memory results were not dumped unless they affected the task.

## See Also

- `memory-discipline`: session-level recall and save loop.
- `lesson`: saving user corrections as reusable behavior.
- `agent-information-architecture`: deciding whether a rule belongs in AGENTS.md or a skill.
