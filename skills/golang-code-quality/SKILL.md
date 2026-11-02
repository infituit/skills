---
name: golang-code-quality
description: Use when writing, refactoring, or reviewing Go implementations with mixed responsibilities, interleaved dependency reads and result assembly, lazy cache filling inside item loops, or unclear loop and I/O complexity. Not for formatting-only edits or library API lookup.
---

# Go Code Quality

## Purpose

Choose concrete Go implementations that make data dependencies, responsibilities, and costs easy to follow. Apply this while writing code, not only after a review finds a problem. Prefer predictable data flow over fewer lines or fewer loops.

Project rules, domain contracts, and approved implementation conventions take precedence. This skill does not authorize a new paradigm or a wider refactor.

## Implementation Workflow

1. **Read the real path.** Inspect callers, scoped rules, existing helpers, and comparable implementations. Identify inputs, outputs, dependency APIs, and the owning layer before proposing a structure.
2. **State the contract.** Establish ordering, tenant/auth boundaries, missing-data handling, cancellation, first-error behavior, partial progress, and read-after-write dependencies. Separate requirements from assumptions.
3. **Name the mixed responsibilities.** Locate dependency discovery, reads, cache maintenance, domain decisions, and output mutation. Explain a concrete maintenance problem, such as changing a release key in multiple conditional branches; do not call code bad merely because it has a loop.
4. **Compare the smallest alternatives.** Retain the current flow if it is already clear or required by the contract. For a bounded preparation batch with reusable reads, consult [Phased Dependency Preparation](references/phased-dependency-preparation.md) before implementing. Prefer existing batch APIs and domain helpers; do not introduce a generic pipeline, new API, cache, or concurrency just to obtain a flatter function.
5. **Implement at the owning layer.** Give each pass a coherent purpose. Use domain-named helpers only when they hide a meaningful responsibility. Keep validation and error propagation explicit; preserve established semantics unless a disclosed change has been approved.
6. **Verify the actual benefit.** Check outputs, dependency-key coverage, missing results, ordering, and side effects against concrete scenarios. Count calls and analyze space separately from CPU work. Measure before claiming lower latency. Run the relevant existing checks without unrelated cleanup.

## Quick Decisions

| Situation                                                            | Decision                                                                 |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Bounded items mix repeated reads, miss handling, and result mutation | Consider dependency-ordered preparation, then I/O-free assembly          |
| Clear per-item flow with little reuse                                | Keep the simpler loop; staging is not an end in itself                   |
| Unbounded stream or reads depend on previous writes                  | Preserve incremental processing and dependency order                     |
| Prefetch changes partial progress or first-error behavior            | Disclose the difference; do not silently adopt it                        |
| Several consecutive linear passes                                    | Sum their work; do not multiply loop lengths                             |
| Nested loops                                                         | Count actual iterations; nesting alone does not establish quadratic work |

## Delivery

Briefly state the chosen structure, the local baseline, semantic differences or approval needed, and verification performed. Explain costs using actual input and distinct-key counts; never infer a Cartesian product that the code or request does not contain. Avoid a full design report for a small change.

Use the project's error, conversion, and style skills where those contracts apply. This skill supplies implementation judgment, not replacements for them.

## Common Mistakes

- Moving queries into a helper but leaving lazy reads and cache filling inside final assembly.
- Equating fewer loops with lower complexity, or fewer helper calls with fewer HTTP requests.
- Prefetching everything without accounting for memory, freshness, batch limits, or partial failure.
- Turning a local improvement into a shared framework or an unrelated style migration.

## Evaluation

`evals/evals.json` covers bounded preparation, a concrete Go implementation, and two counterexamples: an unbounded read-after-write worker and an endpoint with observable partial progress. Compare with-skill and baseline answers, and compile the implementation output; passing these scenarios alone does not establish broad effectiveness.
