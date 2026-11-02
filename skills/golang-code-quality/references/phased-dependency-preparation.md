# Phased Dependency Preparation

## Intent

For a bounded batch, concentrate reusable dependency reads in preparation phases, then assemble results from prepared data. Each phase answers one question: what is needed, what was loaded, what depends on it, or what should be written to each result.

This is an implementation structure, not database replica read/write splitting. It does not imply concurrency, a cross-request cache, or all-or-nothing persistence.

## Recognize the Opportunity

Consider this pattern when an item loop interleaves several responsibilities:

- Read a host and plugin.
- Resolve an omitted version.
- Fill default-version and release maps on cache misses.
- Derive compatibility and mutate the deployment item.

Lazy maps can already avoid duplicate calls, but readers must still track query conditions, partially populated maps, and output mutation together. Staging can make a concrete change cheaper: adding a release identity dimension belongs in key preparation, while changing result fields belongs in assembly. The tradeoff is more passes and retained data, not free performance.

Use staging only when inputs fit the memory budget, dependency reads can be reused safely, and the observable contract allows them to move earlier. Existing project conventions still apply; propose rather than silently adopt a departure.

## Build in Dependency Order

For a plugin-style preparation function, use this shape with the project's actual types and APIs:

1. **Collect requested identities.** Gather distinct host IDs and plugin names in stable first-seen order using existing helpers. Keep the tenant scope required by each API. Return immediately for an empty batch if an empty filter would otherwise mean "all resources."
2. **Read hosts and plugins.** Use existing batch APIs; respect their limits and pagination, and verify complete results. Index by the actual identity. Missing entries are errors or explicit domain absences, never silently accepted zero values.
3. **Prepare default versions.** Only items without an explicit version need default lookup. Derive distinct default keys from the loaded dependencies: typically tenant scope, package, generation, and platform. If only a single-key API exists, call it once per distinct key. Keep versions in local prepared data rather than mutating caller-owned items during reads.
4. **Prepare releases.** Resolve each effective version, preserving explicit versions, before forming complete release keys. Include every identity dimension required by the domain, such as package, generation, platform, version, and tenant scope. Load each distinct release using existing APIs. An outer tenant-scoped context can supply tenant identity; a map shared across tenants must not omit it.
5. **Assemble results.** Iterate the original item order and use prepared lookups to calculate each item's version and compatibility. This phase performs no dependency I/O, cache-miss fills, or new dependency discovery. Keep per-item decisions per item: sharing a release does not mean sharing mutable deployment results.

The sequence is a dependency graph, not a fixed number of functions. Merge trivial adjacent work where it remains clear. Extract a helper when it names and hides a real domain responsibility, not merely to make the caller shorter. Do not manufacture batch APIs or move service-specific decisions into a generic conversion package.

## Cost Model

Let:

- `N` be the number of input deployment items, not an assumed host/plugin cross-product.
- `H` and `P` be distinct host and plugin identities.
- `D` be distinct default-version keys for items without a version.
- `R` be distinct complete release keys.

Assuming average constant-time map operations, fixed-size keys and records, linear helpers, and complete results:

- A fixed number of consecutive passes costs `O(N + H + P + D + R)`, hence `O(N)` when those sets are derived from the `N` items. Several linear passes are added, not multiplied. Sorting or non-linear helper internals must be accounted for separately.
- Retained lookup data costs `O(H + P + D + R)` entries, plus `O(N)` if storing per-item prepared values. Count payload bytes as well when records vary substantially in size.
- With host/plugin batches of capacities `Bh` and `Bp`, preparation makes approximately `ceil(H/Bh) + ceil(P/Bp) + D + R` dependency API calls when defaults and releases are single-key APIs. If an API handles the full batch, its batch term is one. Actual paging and API contracts determine the count.
- A helper call may itself issue multiple database commands, hit a cache, retry, or share an in-flight request. Count these separately; the API-call formula is not a guarantee about HTTP traffic or database work.

If the original loop already memoizes all dependencies, staging may keep the same call count and Big-O while improving separation. If it performs per-item host reads, batching changes the call structure, not the need to process `N` outputs. Neither claim alone establishes a latency improvement.

## Preserve or Renegotiate Semantics

Before moving reads, compare:

| Contract                | What staging can change                                                                                                                       |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| First error             | Dependency-phase traversal can return a different failure than input-order processing; stable collection alone does not guarantee equivalence |
| Partial progress        | Prefetch may fail before earlier items are mutated or persisted; do not silently turn partial success into no progress                        |
| Freshness               | One reused read is a per-call snapshot of that dependency, not an atomic snapshot across resources                                            |
| Read-after-write        | Preloading can miss changes made by earlier items                                                                                             |
| Authorization           | Bulk queries must retain tenant scope, permission checks, and missing-resource behavior                                                       |
| Cancellation and limits | Larger reads change work done before failure; batch limits, pagination, and cancellation must remain effective                                |

If these changes are outside the approved contract, keep per-item sequencing and extract small responsibilities without moving effects. If a changed contract is desired, explain the difference and obtain approval first. Do not claim staged assembly is transactional unless an actual transaction guarantees it.

## When Not to Apply

- **Unbounded streams:** collecting all input can exhaust memory or never reach assembly. Process incrementally; bounded chunks are safe only when cross-item dependencies allow them.
- **Sequential state transitions:** charging the same account twice requires the second read to observe the first write. Retain that order rather than reuse a stale snapshot.
- **Observable partial writes:** if items 1 and 2 must remain committed when item 3 fails, whole-request prefetch is not a behavior-preserving cleanup.
- **Small, clear, non-reusing flows:** extra maps and passes may add more concepts than they remove. Keep the original structure.

## Verification Checklist

Use concrete existing acceptance scenarios; do not invent a broad test framework for this pattern.

- Explicit and default versions produce the same intended per-item results.
- Equal package names on different platforms, generations, versions, or tenant scopes cannot collide.
- Empty inputs, missing results, batch limits, pagination, cancellation, and duplicate input items remain handled.
- Actual call counts match distinct keys and batch boundaries; final assembly contains no hidden I/O.
- Error ordering, mutation timing, persistence, and freshness match the approved contract.
- Any speed claim has measurements; otherwise report only the verified structural or call-count change.
