---
name: opencode-plugin-doc-finder
description: Finds the relevant official OpenCode V2 documentation for plugin development questions that focused skills do not cover. Use when an OpenCode plugin task needs a verified official page for a CLI, build, API, troubleshooting, plugin, client, SDK, configuration, or runtime detail.
user-invocable: false
---

# OpenCode Plugin Documentation Finder

Use this as a narrow fallback for locating official OpenCode V2 information. It is a navigation aid, not an implementation workflow.

## Quick start

For an unresolved RPC question, start with:

1. `https://opencode.ai/v2/docs/build/plugins/rpc`
2. `https://opencode.ai/v2/docs/api`
3. Read the relevant current page before relying on a signature or behavior.

## Why

OpenCode plugin behavior spans several documentation sections. A stable route map prevents searching unrelated pages or accidentally using V1 material. Keep facts current by reading the official V2 source at task time instead of copying API details into this skill.

## Workflow

1. State the narrow fact to find, such as plugin loading, a hook timing, an RPC contract, or an API schema.
2. Match it to the route table in [REFERENCE.md](REFERENCE.md).
3. Fetch the candidate official V2 page and follow only task-relevant links.
4. Use `https://opencode.ai/v2/openapi.json` when the question is about an HTTP operation, request, response, or schema.
5. Return the relevant URL and a short pointer to the section to inspect, then let the calling `opencode-plugin-how-to` or focused skill continue.
6. If official V2 material does not establish the fact, say that it is an official-documentation gap. Do not silently replace it with V1 or an unverified third-party source.

## Source boundary

Use only:

- `https://opencode.ai/v2/docs/` and pages below it;
- `https://opencode.ai/v2/openapi.json`;
- official V2 pages directly linked from those sources.

Do not use `/docs/` V1 pages, search-result snippets, blogs, or unverified examples as the basis for an OpenCode V2 contract. Treat experimental pages and APIs as version-sensitive and re-read them when used.

## Output

Keep the result small:

- the fact being looked up;
- the official V2 URL or URLs;
- the relevant section, operation, or schema name;
- any explicit uncertainty or experimental status.

Do not produce a full implementation plan, project-specific patch, lifecycle report, or mandatory handoff format.

## Anti-patterns

**Wrong:** search the web for a familiar OpenCode API name and copy the first example.

**Right:** route through the V2 map, read the official page, use OpenAPI for HTTP contracts, and report an evidence gap when the official source is insufficient.

## Checklist

- [ ] The question is narrow enough to search.
- [ ] The source is under the official OpenCode V2 documentation origin.
- [ ] V1 URLs and unverified third-party material were excluded.
- [ ] Exact API details were re-read from the current source.
- [ ] The result stays a lookup, not a duplicate implementation skill.

## See also

- [REFERENCE.md](REFERENCE.md)
- `opencode-plugin-how-to`
