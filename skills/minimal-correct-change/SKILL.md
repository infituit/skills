---
name: minimal-correct-change
description: Use when implementing, fixing, or refactoring code where over-engineering is a risk, especially when a change may introduce unnecessary abstractions, new dependencies, new configuration, broad rewrites, speculative scaffolding, or call-site patches instead of root-cause fixes. Also use when the user asks for minimal, YAGNI, simpler, less code, or avoiding overengineering.
---

# Minimal Correct Change

## Overview

Minimal correct change prevents fake simplicity. Minimize the implementation and design surface only after you understand the real problem. Do not minimize investigation, security, error handling, accessibility, public contracts, or verification.

The best change is the smallest change that is still at the right layer, covers the full requested behavior, and can be verified.

## When to Use

Use this skill for implementation, bugfix, and refactor work when the prompt or emerging plan smells like over-engineering:

- new abstraction, interface, factory, strategy, adapter, or framework for one current case
- new dependency, configuration option, feature flag, plugin point, or extension hook
- broad rewrite, modernization, cleanup, or scaffolding for later
- a narrow request expanding into many files without a contract-driven reason
- bugfix pressure to patch the visible caller instead of the shared root cause
- explicit words like minimal, YAGNI, simpler, less code, avoid overengineering, 别复杂化, or 尽量少改

Do not use this skill as the primary frame for pure explanation, documentation, release work, security review, compliance review, or architecture reports unless the user explicitly asks for a minimal path. For those tasks, use the domain-specific workflow first.

## Core Rule

First understand, then reduce.

A small diff in the wrong place is not minimal. Skipping caller analysis, validation, error handling, or tests is not minimal. Adding future-proof structure before the future exists is not careful; it is inventory.

## The Ladder

Walk this ladder in order and stop at the first option that is correct for the current request.

1. **Understand first.** Read the relevant code, callers, analogous implementations, scoped instructions, contracts, and real data flow. Minimalism never excuses shallow discovery.
2. **Ask whether the change is needed at all.** If deletion, existing behavior, configuration, documentation, or a workflow change already solves it, propose that path before adding code.
3. **Reuse local code first.** Prefer existing helpers, domain types, service paths, converters, error semantics, logging patterns, and tests over parallel implementations.
4. **Use standard or platform capability.** Prefer the language standard library, framework primitives, database/query features, browser/platform APIs, or deployment platform features before custom code.
5. **Use installed dependencies before adding one.** A new dependency needs current, concrete value that existing project tools cannot provide cleanly.
6. **Write the smallest complete change.** Avoid single-implementation interfaces, one-product factories, speculative options, feature flags, generic packages, scaffolding, and parallel paths.
7. **For bugfixes, find the root cause.** Inspect callers and shared paths. Prefer one fix at the cause over local fallbacks at each symptom site.
8. **Verify actual behavior.** Run the diagnostics, tests, build, or manual checks appropriate to the change. Verification is part of correctness, not optional polish.

## Authority and Boundaries

If a smaller equally correct plan exists, take it. Briefly say what was skipped and why.

If the smaller plan would materially change user-visible behavior, requested scope, public API, persistence format, security boundary, or compatibility promise, ask one precise confirmation question before changing direction.

Never use this skill to remove or weaken:

- trust-boundary input validation
- authentication, authorization, privacy, or security review depth
- error handling that prevents data loss, corruption, or silent failure
- accessibility requirements
- observability required to operate the system
- public contracts, migrations, generated-code boundaries, or stable interfaces
- user-explicit requirements
- verification needed to prove the behavior works

## Red Flags

Pause and re-run the ladder when you notice any of these rationalizations:

| Rationalization | Better move |
| --- | --- |
| "We'll add an interface now because more implementations may come later." | Add it when the second real implementation arrives. |
| "This should be configurable in case requirements change." | Keep the current value local unless variation exists now. |
| "A small handler fallback is safer than touching shared code." | Trace the shared path first; fix the cause once when possible. |
| "A rewrite will make it modern." | Name the concrete pain and make a behavior-preserving local refactor. |
| "Skipping tests keeps the change small." | Run the narrowest meaningful verification instead. |
| "The user said don't touch much, so avoid investigation." | Investigate enough to know the right layer; then touch little. |

## Output Style

When this skill changes the plan, be concise:

```text
Minimal path: [what you will do]
Skipped: [abstraction/dependency/config/rewrite not needed now]
Verify: [specific check that will prove behavior]
```

For reviews, lead with the over-engineering risk and the smaller correct alternative. For implementation, apply the ladder before editing and keep the final summary focused on the chosen minimal path and verification.

## Lightweight Eval Prompts

The pressure prompts live in `evals/evals.json`. Use them to compare baseline behavior against behavior with this skill before declaring the skill reliable.
