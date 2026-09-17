# Project How-To Pattern

Many repositories define a project-specific `*-how-to` skill as a local routing reference.

## Purpose

A project how-to skill helps future agents answer:

- Which project skill should I load first?
- Which generic companion skills are useful only after the project surface is identified?
- Which source anchors must be checked before treating a task as generic?
- Which scoped rules or docs are part of the local workflow?

## Discovery

Search existing skill directories for `*-how-to/SKILL.md`.

Common locations include:

- `.agents/skills/*-how-to/SKILL.md`
- `.claude/skills/*-how-to/SKILL.md`
- `skills/*-how-to/SKILL.md`
- configured custom skill paths

Do not hard-code one path. The local project decides where skills live.

## How to Use as Reference

When present, learn from:

- how it describes project-specific vs generic skills
- how it organizes routing tables
- what it treats as source anchors
- how it handles cross-references and validation prompts

Use it as evidence for style and routing conventions. It is not automatically a hard dependency.

## When to Propose Updating It

Propose a router update only when the task changes:

- project skill discovery expectations
- the entrypoint's intended scope
- routing decisions for a task class
- cross-reference expectations for existing skills

Do not propose a router update only because a new skill exists.

## Incubation Pattern

For reusable skills that are not yet stable across projects, incubate in a project-local skill directory first, keep project-specific examples in references, and migrate or copy to a cross-project skill location after repeated use proves the core pattern.
