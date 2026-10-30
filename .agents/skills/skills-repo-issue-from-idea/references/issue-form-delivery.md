# Issue Form Delivery

## Select and Reuse

Read the target repository's issue forms and chooser configuration. Use a matching bug, feature, or discussion form before a generic fallback. If no form fits and blank issues are disabled, ask for a template decision.

Search for an existing issue covering the same behavior before offering to create another. Show candidates and ask whether to reuse one; do not automatically bind a keyword match. Routine or long-lived tracking issues must not be treated as complete just because one PR contributes to them.

## Render a YAML Form as Markdown

`gh issue create --body-file` supplies a Markdown body, not form answers. Build that body from the selected form:

1. Keep the `title` prefix and proposed subject separate from PR title conventions.
2. Preserve input labels as headings and retain input order.
3. Use exact dropdown option text; include all selected values for multiple selection.
4. Include every required field. Resolve material gaps before presenting a submission-ready draft.
5. Mark checklist items only when supported by actual checks or explicit user confirmation.
6. Do not invent environment details, reproduction, logs, impact, or acceptance facts.
7. Keep sensitive logs and conversation excerpts redacted.
8. Verify default labels exist in the target repository. A label in YAML does not create that label; report a mismatch and confirm any substitution or creation.

## Confirmation and Readback

Show the repository, selected template, complete title/body, and labels before requesting creation authorization. An issue draft is not permission to create, edit, link, or close a remote resource.

Write confirmed multiline Markdown to a concrete temporary file, create with explicit `--repo` and `--body-file`, and read back the title, body, URL, and labels. If content differs, show the corrective edit and ask before applying it. If creation reports an ambiguous failure, query existing remote state before retrying.

Keep unresolved evidence questions and publication actions in the author-facing conversation, not in the final issue body. Return the real issue URL only after creation is verified.

## Review Checklist

- Selected form fits the request; unresolved design is not presented as a settled implementation.
- Duplicate search completed; any reuse was explicitly confirmed.
- Prefix, field order, dropdown values, required fields, and labels match repository facts.
- Scope, non-goals, and verifiable acceptance criteria appear within the appropriate form fields.
- Checklist claims and technical facts have evidence; sensitive content is redacted.
- Creation and corrective edits have separate authorization; readback matches the approved draft.
