---
name: algorithm-nudge
description: Use when the current engineering task involves dependency cycles, repeated grouping or lookups, interval conflicts, range statistics, repeated priority selection, or constrained choices with a concrete correctness, performance, or maintenance concern; also when the user asks whether an algorithm could help the current task. Not for routine edits without such a signal or a whole-repository algorithm audit.
---

# Algorithm Nudge

Notice useful algorithmic structure during engineering work, then offer a small hint rather than taking over the solution. Help the user think of an option they might otherwise miss; do not turn the task into an algorithm lesson.

## Decide Whether to Speak

Use the task context and code already being inspected. A proactive reminder needs both:

- A concrete structural signal, not just a keyword such as "task", "range", or "conflict".
- A current correctness, performance, or maintenance reason to consider a different approach. Small inputs can still need a correct model, such as cycle detection.

If either is missing, continue the original task without algorithm commentary, including announcements that no algorithm is needed. Do not scan unrelated code to find an opportunity. For an explicit request to assess applicability, a brief "the existing approach is enough" is useful feedback.

Prefer the existing simple implementation, standard library, database capability, or installed component when it already fits. A slow database query is not evidence that the application needs a custom data structure. Do not claim a measured speedup without measurements.

## Give One Nudge

Default to one or two short sentences in the conversation's language: a tentative direction, why it matches the observed operation, and a relevant limitation only when it matters. Give one main inclination, not an algorithm menu or a fixed report template.

If an unknown changes the model, retrieve the fact from available context first. If it is a user decision, ask at most one discriminating question instead of committing to an algorithm or starting an interview. Do not invent scale, constraints, or optimization goals.

A reminder is not permission to change the implementation. Keep working within the original task; do not adopt a new algorithm, dependency, or architecture merely because you suggested it. If the user declines or has already heard the same reminder, do not repeat it without new evidence.

## Recognition Cues

These are optional associations, not a checklist to run on every task. Choose only the relevant direction; the families are not an exhaustive catalog.

| Observed structure              | Possible direction and boundary                                                                                                                                                                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Dependencies and ordering       | Directed graph and cycle detection; topological ordering when an execution order is needed. Do not assume the dependencies are already acyclic.                                                                                                  |
| Membership and grouping         | Sets or hash maps for exact membership/grouping; union-find for repeatedly merging equivalence or connectivity groups, not arbitrary similarity or frequent splits.                                                                              |
| Intervals and events            | Sorting and a scan for batch overlap/merge problems. Endpoint semantics matter; continuous updates may change the fit.                                                                                                                           |
| Repeated queries and statistics | Binary search on ordered data or a monotone feasibility predicate; prefix sums for repeated static range sums; a heap for repeated extreme selection amid updates. Check database/index capabilities before moving work into application memory. |
| Resource-constrained choices    | Distinguish selecting a subset from arranging its execution in time. Knapsack-style DP needs a suitable bounded state space; a greedy optimality claim needs a safe-choice argument. "Scheduling" alone does not identify an algorithm.          |

## Expand Only on Interest

If the user asks to explore, explain the chosen model or give a small demo focused on the uncertain idea. State its simplifying assumptions; a working toy example does not prove suitability for the business workload. An explicit implementation request leaves reminder-only mode and follows the project's normal implementation rules.

Do not add teaching rituals, mandatory follow-up questions, proof reports, a knowledge base, or automatic memory/file updates as part of this skill.

## Examples

For repeated priority selection:

> 这里任务会持续加入，又要反复取出当前最高优先级的一项，可以考虑堆／优先队列；如果任务很少，直接排序可能更简单。

For an unresolved resource model:

> 这里可能是资源约束下的选择问题，但如果还要安排开始时间，模型会不同。这次只需要选出要执行的任务，还是也要排出时间表？

For an error-message-only change to an already adequate conflict check, make no algorithm suggestion; just handle the requested error message.
