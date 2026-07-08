---
name: skills-sh-registration
description: Guides agents through preparing a public skill repository for skills.sh listing, including skills.sh.json grouping, GitHub publishing, CLI telemetry trigger, page verification, and badge setup. Use when the user wants to register, publish, list, add, or verify a skill repository on skills.sh.
---

# skills.sh Registration

## Core Rule

Treat skills.sh listing as an automatic discovery and telemetry flow, not a manual submission form. A repository must be public and installable; `npx skills add <owner>/<repo>` from a telemetry-enabled environment is the practical trigger for skills.sh to notice it.

## Use When

Use this when the user asks to register, publish, list, add, submit, or verify a skill repository on skills.sh, or when they ask how to make a GitHub skill repo appear on skills.sh.

Do not use this for ordinary skill authoring unless the goal includes skills.sh visibility.

## Quick Start

For `https://github.com/infituit/skills`:

```bash
npx skills add infituit/skills --list
npx skills add infituit/skills
```

Expected page and badge:

```md
https://skills.sh/infituit/skills
[![skills.sh](https://skills.sh/b/infituit/skills)](https://skills.sh/infituit/skills)
```

## Workflow

1. Confirm the repository is public on GitHub and contains skills under `skills/<skill-name>/SKILL.md`.
2. Check each `SKILL.md` has valid frontmatter with `name` and a trigger-rich `description` containing `Use when...`.
3. If the repo uses a root `skills.sh.json`, validate that it is display-only grouping metadata, not installation logic.
4. Keep `skills.sh.json` valid JSON with optional `$schema`, optional `notGrouped`, and `groupings` entries containing `title`, optional `description`, and `skills` slugs.
5. Push the repository to GitHub before trying to trigger listing.
6. Run `npx skills add <owner>/<repo> --list` to confirm the CLI can discover the repository's skills.
7. Run `npx skills add <owner>/<repo>` from a normal environment where telemetry is not disabled.
8. Check `https://skills.sh/<owner>/<repo>` and the badge URL after indexing/cache delay.

## skills.sh.json Pattern

Use skill slugs that match the skills.sh URL slug when possible. Matching is case-insensitive and treats spaces or underscores like hyphens; first group wins for duplicates. Skills that are not grouped appear under `Other skills`.

```json
{
  "$schema": "https://skills.sh/schemas/skills.sh.schema.json",
  "notGrouped": "bottom",
  "groupings": [
    {
      "title": "Skill Maintenance",
      "description": "Skills for reviewing, improving, and preserving agent skill guidance.",
      "skills": ["skill-retrospective", "skills-sh-registration"]
    }
  ]
}
```

## Troubleshooting

- If the repo does not appear, confirm it is public and installable with `npx skills add <owner>/<repo> --list`.
- If telemetry is disabled, skills.sh may not see the install. Check `DISABLE_TELEMETRY`, `DO_NOT_TRACK`, CI defaults, and shell environment.
- If `skills.sh.json` changes do not appear, validate JSON and wait for cache/indexing delay.
- Do not claim there is a manual submission button or a fixed install threshold unless current docs prove it.
- Do not treat `skills.sh.json` as required for listing; it customizes an existing repo page's grouping.

## Output Template

When reporting to the user, include:

- Repository: `https://github.com/<owner>/<repo>`
- Discovery check: `npx skills add <owner>/<repo> --list`
- Listing trigger: `npx skills add <owner>/<repo>`
- Page: `https://skills.sh/<owner>/<repo>`
- Badge markdown: `[![skills.sh](https://skills.sh/b/<owner>/<repo>)](https://skills.sh/<owner>/<repo>)`
- Caveat: listing and grouping updates can lag because skills.sh aggregates telemetry and caches pages.
