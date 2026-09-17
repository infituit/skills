# Artifact Responsibility

Use this reference to classify content before deciding where it belongs.

## Agent Rule Files

Examples include `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, or scoped equivalents.

Put content here when an agent must follow it while working in a scope:

- local commands and verification entrypoints
- required tools or retrieval habits
- scoped architecture, dependency, naming, or safety constraints
- where-to-look indexes for the subtree
- local anti-patterns that prevent recurring mistakes

Avoid:

- full conceptual explanations
- human onboarding prose
- reusable workflow tutorials that deserve a skill
- temporary status or task progress

## README Files

README files are stable human entrypoints.

Put content here when a human needs:

- purpose and scope
- quick start or usage path
- module overview
- stable examples
- links to deeper docs

Avoid:

- agent-only instructions such as “agent must load X first”
- temporary progress language such as “unfinished”, “in progress”, “later”, or “temporary”
- low-level implementation call chains when the reader needs behavior

## Docs

Docs own durable knowledge that is too long-lived or conceptual for agent rules and too detailed for README.

Put content here when it explains:

- domain concepts and terminology
- design decisions or architecture
- public API contracts and guides
- developer, operation, integration, third-party, or FAQ material
- decision trees and boundary semantics

Always choose a docs subarea by local taxonomy. Do not recommend only `docs/` when subdirectories exist.

## Skills

Skills own reusable agent workflows.

Promote content to a skill when it has:

- triggering situations
- a repeatable workflow or decision flow
- expected output shape
- validation gates or common mistakes
- enough reuse to justify discovery overhead

Avoid skills for:

- one-off task plans
- static project facts
- plain documentation that humans should read directly
- constraints that an agent must obey in every scoped operation; those belong in agent rule files

## Project How-To Skills

A project `*-how-to` skill is a routing or entrypoint pattern. It can show how a project combines local skills, generic skills, scoped rules, and source anchors.

Treat it as a reference when designing skill systems. Do not make it a mandatory synchronization target unless the current task changes routing semantics.
