# Docs Taxonomy Discovery

Use this reference when the placement decision points to `docs/**`.

## Discovery Steps

1. Read the top-level docs index if present, usually `docs/README.md`.
2. Read docs-local agent rules if present, such as `docs/AGENTS.md`.
3. List first-level docs subdirectories.
4. Read representative nested README files for likely target categories.
5. Choose by audience, purpose, and reason-to-change.

## Common Docs Categories

Projects use different names, but these categories often appear:

| Category        | Typical audience                         | Content                                                |
| --------------- | ---------------------------------------- | ------------------------------------------------------ |
| API             | API developers and consumers             | endpoint contracts, Swagger/OpenAPI, protocol workflow |
| Concepts        | maintainers and integrators              | domain concepts, terminology, model boundaries         |
| Developer       | contributors                             | local setup, build, code workflow, extension guides    |
| Operation       | operators                                | installation, deployment, runtime behavior, runbooks   |
| Troubleshooting | operators and maintainers                | symptoms, root cause, confirmation, recovery           |
| FAQ             | users and support                        | common questions and focused explanations              |
| Integration     | external or adjacent platform developers | public behavior, API-first flows, observable effects   |
| Third-party     | maintainers integrating external systems | upstream requirements, local mapping, verified gaps    |
| Assets          | docs authors                             | images and static resources                            |

Do not impose these names if the project uses different categories. Map to the local taxonomy.

## Decision Heuristics

- If it defines vocabulary used across code, API, and docs, prefer the concept or glossary area.
- If it tells a third-party caller how to use the project, prefer integration docs.
- If it records how the project integrates with an upstream external system, prefer third-party reference docs.
- If it describes how contributors build or extend the project, prefer developer docs.
- If it describes how to deploy, operate, or recover the system, prefer operation or troubleshooting docs.
- If it is a narrow repeated support question, prefer FAQ.
- If it describes endpoint contracts or API development flow, prefer API docs.

## Output Requirement

When recommending docs, include:

- selected docs area
- adjacent docs areas rejected
- local evidence that supports the selection
