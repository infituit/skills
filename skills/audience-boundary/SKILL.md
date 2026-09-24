---
name: audience-boundary
description: Use when writing or reviewing a deliverable with an intended reader, especially documentation being added to a project, release notes, API docs, READMEs, or public announcements. Separate reader-facing facts and decision-relevant risks from author-facing verification notes, draft status, evidence gaps, and publication checks. Trigger even when the user does not explicitly ask for an audience review.
---

# Audience Boundary

## Purpose

An artifact should contain information for its intended readers, not the author's working notes. An uncertainty can be important without belonging in the artifact: decide who needs it before deciding how to phrase it.

Use alongside the artifact's own writing skill and local format rules. This skill controls information placement, not the document's structure, style, or factual standards. Apply it when drafting, editing, or reviewing a deliverable with an intended reader. For project documentation, use it whenever writing to or reviewing the document in the project. Do not impose this workflow on ordinary conversation without a reader-facing artifact.

## Decide The Recipient

1. Identify the artifact's intended reader and the decision or task the artifact supports. Infer this from the request, existing documents, and destination. Ask who the reader is only if ambiguity would change what belongs in the artifact.
2. For each candidate statement, ask: Is this a supported fact, limitation, or risk that this reader needs to use the artifact or make a decision? If yes, include it in the reader's language and the artifact's normal format. Do not suppress a real user-facing risk just because it involves uncertainty.
3. Otherwise ask: Is this about the writer's evidence, confidence, unfinished checks, missing inputs, review status, or publication workflow? Give it to the author in the conversation or an explicitly requested work record, not in the reader-facing artifact. Do not launder it into a more polished sentence for the reader.
4. If a claim is unsupported, do not invent it or imply it has been verified. Omit nonessential claims. For essential claims, report the gap to the author and keep the artifact a draft until resolved.

The distinction is by **recipient and consequence**, not keywords. A reader may need to know "Kubernetes 1.35 is not supported" if that limitation is established and affects deployment. A release editor needs to know "check whether the target tag exists before publishing"; readers of the release notes do not. Neither `待确认` nor a warning icon can turn a writer's to-do into reader-facing content.

## Draft And Publication Boundary

- A draft may be useful even with unresolved facts. Deliver its body and a separate author-facing list of material gaps. Do not append the list to the body, including as a note, footnote, frontmatter, or a "to confirm" section.
- If a material gap prevents the artifact from being publishable, do not place that draft at the final publication path or claim it is ready to publish. Use conversation output or a separate draft location agreed with the user; do not create sidecar notes by default.
- If the user or publishing workflow explicitly requires a review or verification before publication, treat the unfinished check as a publication gate even when other statements in the draft are supported. Report its status to the author, not the reader.
- For publication-dependent references such as a future release tag or compare link, distinguish a planned link from an already verified live link. Validate it at the appropriate publication gate and tell the author what remains to check. Do not insert the gate status into the public document.
- Before delivering or publishing, read the artifact as its intended reader. Remove writer-facing provenance, review requests, and status commentary; retain supported reader-facing warnings and prerequisites. If an artifact-specific instruction demands writer notes in public content, surface the conflict to the author instead of silently mixing the audiences.

## Output Contract

When gaps exist, provide two separate outputs:

**Reader-facing draft:** Only content appropriate to the artifact's readers. Label it as a draft outside the artifact body if needed.

**For the author:** Material missing evidence, unresolved decisions, and checks required before publication. This belongs in the conversation or a work record the user explicitly requested.

If no gaps remain, deliver only the finished artifact and any brief handoff the author needs. Do not manufacture an uncertainty list.
