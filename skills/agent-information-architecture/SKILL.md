---
name: agent-information-architecture
description: Use when deciding where project knowledge should live across agent rule files, README files, docs, and skills; especially when organizing reusable agent workflows, scoped instructions, human-facing documentation, docs taxonomy, project how-to routers, or resolving conflicts between information artifacts.
---

# Agent Information Architecture

## Overview

Use this skill to decide where project knowledge belongs before editing documentation or agent guidance. It treats `AGENTS.md`, project-specific agent rule files, `README.md`, `docs/**`, and skills as separate information artifacts with different reasons to change.

The goal is not to force one repository layout. The goal is to discover the local layout, classify the content by ownership, and make a placement decision that future agents and humans can predict.

## When to Use

Use this skill when the user asks where to put or how to organize:

- agent instructions, scoped rules, commands, guardrails, or anti-patterns
- project or module README content
- long-lived concept, architecture, integration, operation, FAQ, or API docs
- a repeated agent workflow that might become a skill
- a project-level `*-how-to` routing/entrypoint skill
- conflicting information across rules, README, docs, and skills

Do not use it for ordinary copyediting when the target file is already clear.

## Core Workflow

1. Discover local information architecture before deciding placement.
2. Identify the artifact ownership and reason-to-change.
3. If the target is docs, discover the project's docs taxonomy before choosing a subdirectory.
4. If the target is a skill, decide whether it is project-local, project-router, or cross-project.
5. Resolve conflicts by artifact responsibility, not by file recency or length.
6. Output a `Placement Decision` before editing files, unless the user already gave an exact path and asked for a mechanical edit.

## Discovery Checklist

Search only as much as needed for the decision:

- Agent rule files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, or local equivalents.
- Scoped rule files: nested agent instruction files under the target subtree.
- Skill directories: `.agents/skills`, `.claude/skills`, `skills`, or configured custom skill paths.
- Project how-to routers: `*-how-to/SKILL.md` in local skill directories.
- Human entry docs: root `README.md` and module README files.
- Docs taxonomy: `docs/README.md`, `docs/AGENTS.md`, nested docs indexes, and representative sibling docs.

Finding a pattern does not make it a hard rule. Use it as evidence, then state the placement rationale.

## Artifact Responsibility

Use `references/artifact-responsibility.md` as the detailed matrix. Default responsibilities:

| Artifact             | Owns                                                                                    | Does Not Own                                                       |
| -------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| Agent rule file      | agent behavior constraints, scoped commands, boundaries, anti-patterns, where-to-look   | long conceptual explanations, human onboarding, workflow tutorials |
| README               | stable human entry, purpose, quick start, usage, public module overview                 | agent-only instructions, transient status, process notes           |
| docs                 | long-lived concepts, design semantics, API/integration/operation/developer/FAQ material | agent execution rules, temporary plans                             |
| skill                | reusable agent workflow with trigger, steps, output contract, verification              | one-off facts, static project background, broad docs dump          |
| project how-to skill | project skill routing pattern and examples                                              | mandatory sync target for every new skill                          |

## Placement Rules

Classify by reason-to-change:

| Reason-to-change                                                     | Preferred placement                                                          |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Agent must follow this while working in a scope                      | agent rule file, often scoped                                                |
| Human needs a stable entrypoint or usage overview                    | README                                                                       |
| The content explains durable concepts, policies, or system behavior  | docs                                                                         |
| The content is a repeated agent workflow                             | skill                                                                        |
| The content decides which project skills to load                     | project `*-how-to` skill or local routing reference                          |
| The content is a temporary plan, progress note, or unfinished status | task tracker, issue, plan, or conversation, not README/docs as durable truth |

## Docs Taxonomy Discovery

Do not treat `docs/` as one bucket. Read the local docs index and choose the subdomain by audience and purpose.

Use `references/docs-taxonomy-discovery.md` when docs placement matters. The final recommendation should name the docs subarea, not only `docs/`.

## Skill Placement

Use `references/project-how-to-pattern.md` when placing or designing skills.

General rule:

- Project-local skills live in the project's local skill directory, discovered from the repository.
- Cross-project skills live in the repository or workspace location intended for reusable skills.
- A project `*-how-to` skill is a local routing reference, not automatically a mandatory update target.

If the intended portability is unclear, ask whether to incubate locally first or publish directly as cross-project guidance.

## Conflict Resolution

Resolve by responsibility:

1. Agent behavior constraints belong to agent rule files.
2. Reusable agent procedures belong to skills.
3. Long-lived semantics and decisions belong to docs.
4. Human entry language belongs to README.

Stop and ask when the conflict changes a public contract, data model, trust boundary, permission model, long-lived architecture, or project-wide routing convention.

## Output Contract

Use this format unless the user asks for a different artifact:

```text
Placement Decision
Recommended artifact: [agent rule file | scoped agent rule file | README | docs/<subarea> | project-local skill | project how-to skill | cross-project skill | task/issue/plan]
Reason-to-change: [why this content will change]
Evidence:
- [local files/patterns checked]
Put there:
- [content that belongs in the recommended artifact]
Do not put in:
- [nearby artifact and why not]
If docs:
- Target docs area: [local taxonomy choice]
- Not chosen: [adjacent docs areas rejected]
If skill:
- Skill scope: [project-local | project-router | cross-project | incubate-local-first]
- Existing how-to reference: [none | path and how it was used]
Sync needed:
- [related docs/rules/skills to update, or none]
Risk: low | medium | high
Blocking question: none | [one precise question]
Apply edits? yes/no
```

## Common Mistakes

| Mistake                                            | Better move                                                                              |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Choosing placement by file length                  | Choose by reason-to-change and ownership                                                 |
| Treating the current project's layout as universal | Extract the transferable pattern and do not ship local-only paths as required references |
| Putting agent-only instructions in README          | Put them in an agent rule file or skill                                                  |
| Putting durable concepts in `AGENTS.md`            | Put them in docs and link from rules if needed                                           |
| Making every repeated note a skill                 | Require trigger, workflow, output contract, and verification                             |
| Forcing every new skill to update `*-how-to`       | Update routing only when routing semantics actually change                               |
| Treating `docs/` as a dumping ground               | Discover and use the project's docs taxonomy                                             |

## References

- `references/artifact-responsibility.md`: responsibility matrix and placement heuristics.
- `references/docs-taxonomy-discovery.md`: how to learn a project's docs categories.
- `references/project-how-to-pattern.md`: project `*-how-to` router pattern.

## Validation Prompts

First-version prompts live in `evals/evals.json`. They cover README boundaries, docs taxonomy, scoped agent rules, project-local vs cross-project skill placement, and project how-to router handling.
