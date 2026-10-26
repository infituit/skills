---
name: opencode-plugin-how-to
description: Routes OpenCode V2 plugin development work to the right extension surface and supporting skills without duplicating their detailed guidance. Use when creating, changing, reviewing, debugging, testing, packaging, or documenting an OpenCode plugin or a plugin-related client, CLI, TUI, RPC, or SDK integration.
user-invocable: false
---

# OpenCode Plugin How-To

Use this as the entrypoint for OpenCode plugin work. It is a lightweight orchestrator, not a replacement for a focused plugin skill.

## Quick start

For a request to add a plugin tool:

1. Keep this skill active as the task router.
2. Load the matching focused skill if one is available.
3. If the focused skill leaves an OpenCode V2 fact unresolved, load `opencode-plugin-doc-finder`.
4. Continue the task with the loaded skills; they are complementary, not mutually exclusive.

## Why

OpenCode plugin tasks cross server runtime, CLI/TUI, HTTP API, RPC, and embedded SDK boundaries. Choose the extension surface before choosing an API. Prefer project-specific and focused skills for implementation; use the documentation finder only for uncovered or version-sensitive official facts.

## Workflow

1. Preserve confirmed task scope. Do not restart questions already answered.
2. Read applicable `AGENTS.md` files and inspect the current project before making a recommendation.
3. Classify the request with [REFERENCE.md](REFERENCE.md): server plugin, CLI/TUI plugin, RPC, client, SDK, configuration, troubleshooting, or packaging.
4. Search available skills for a focused match. Load that skill in addition to this one when it applies.
5. If no focused skill covers a required OpenCode V2 fact, load `opencode-plugin-doc-finder` and use its route.
6. Keep the work on the selected branch. Do not introduce a second plugin path, a V1 compatibility layer, or an unrelated refactor.
7. Let the focused skill own detailed implementation and verification guidance. This skill only keeps routing and scope coherent.

## Routing output

When routing matters, state only:

- selected OpenCode extension surface;
- focused skills loaded or absent;
- whether official documentation lookup is needed;
- the next concrete discovery or implementation step.

Do not stop merely because another skill was loaded. Do not invent a handoff report when the task can continue directly.

## Anti-patterns

**Wrong:** choose a hook because the request mentions a plugin, then search arbitrary examples.

**Right:** classify the runtime surface and mechanism first, load the focused skill, and use `opencode-plugin-doc-finder` only for an uncovered V2 fact.

## Checklist

- [ ] OpenCode V2 only; no V1 API or migration assumptions.
- [ ] Server and CLI/TUI responsibilities are not conflated.
- [ ] Transform, hook, tool, command, RPC, client, and SDK choices are distinguished.
- [ ] Focused skills were considered before the documentation fallback.
- [ ] Local project rules and source anchors were checked.
- [ ] The task remains within the user's requested scope.

## See also

- [REFERENCE.md](REFERENCE.md)
- `opencode-plugin-doc-finder`
