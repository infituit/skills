---
name: defuddle
description: >-
  Use when extracting clean readable article content or metadata from a standard web page, URL, local HTML file, or piped HTML with the Defuddle CLI. Trigger for defuddle, clean Markdown from URL, extract article metadata, remove page clutter, readability extraction, or parse HTML to Markdown. Do not use for direct .md URLs, authenticated/session pages, JS-rendered browser workflows, screenshots, or click-based scraping.
---

# Defuddle

Use Defuddle as a CLI-first readability extractor for standard pages. It removes navigation, sidebars, comments, headers, footers, and other clutter, then returns cleaned HTML, Markdown, JSON metadata, or one response property.

## Core Rules

- Prefer `defuddle parse` for URL, local HTML file, and stdin extraction.
- Use Markdown for human reading and token-saving summaries: `defuddle parse <url> --md`.
- Use JSON when an agent needs stable fields or metadata: `defuddle parse <url> --json`.
- Use `--json --md` when you need both metadata and Markdown content; the CLI can include `contentMarkdown` when present.
- Use `--property <name>` only for one scalar field such as `title`, `description`, `domain`, `author`, `published`, or `wordCount`.
- Do not run global installs automatically. Use an existing `defuddle` binary, or ask before using one-off package execution such as `npx --yes defuddle@0.19.2`.
- Do not use Defuddle for direct `.md` URLs; fetch those as Markdown with WebFetch or an equivalent plain fetch tool.
- Do not use Defuddle for authenticated, cookie/session-dependent, strongly JS-rendered, screenshot, click, or browser-state workflows; use browser or Playwright tooling instead.

## Availability

Check the CLI before relying on exact flags:

```bash
defuddle --version
defuddle parse --help
```

This reference is based on verified `defuddle@0.19.2` behavior. If a different version is installed, treat `--help` and the package source as the source of truth for version-sensitive syntax.

If Defuddle is not on `PATH`, do not install it globally without explicit user approval. For a one-off command where package download is acceptable, pin the version:

```bash
npx --yes defuddle@0.19.2 parse https://example.com/article --md
```

## Inputs

Use the input form that matches the actual source:

```bash
defuddle parse https://example.com/article --md
defuddle parse ./page.html --md
cat ./page.html | defuddle parse - --md
curl -L https://example.com/article | defuddle parse - --md
```

Rules:

- A `http://` or `https://` source makes Defuddle fetch the page.
- A filesystem source is resolved from the current working directory and read as UTF-8.
- `-` means stdin.
- Omitting the source also means stdin, but a TTY stdin fails fast instead of prompting. Do not run a bare `defuddle parse` unless HTML is actually piped in.
- Prefer a URL source over `curl | defuddle parse -` when URL-derived metadata, relative URL resolution, or domain fields matter.
- For URL fetches, `--user-agent <string>` can override the HTTP user agent and `--lang <code>` can set the preferred language.

## Output Modes

Default output is cleaned HTML:

```bash
defuddle parse ./page.html
```

Markdown output is the normal agent default for reading and summarization:

```bash
defuddle parse https://example.com/article --md
defuddle parse ./page.html --markdown
```

JSON output is for metadata and machine parsing:

```bash
defuddle parse https://example.com/article --json
defuddle parse https://example.com/article --json --md
```

The CLI JSON output explicitly selects fields such as:

- `content`
- `title`
- `description`
- `domain`
- `favicon`
- `image`
- `language`
- `metaTags`
- `parseTime`
- `published`
- `author`
- `site`
- `schemaOrgData`
- `wordCount`
- `contentMarkdown` when present
- `variables` when present

Do not assume every API response field is emitted by CLI JSON; the CLI does not blindly stringify the full response object.

## Properties

Use `--property` for a single response property when a pipeline needs one value:

```bash
defuddle parse https://example.com/article --property title
defuddle parse https://example.com/article --property domain
```

If the property exists but is empty, Defuddle prints an empty string. If the property is not part of the response, it fails with an error like `Property "<name>" not found in response`.

Avoid `--property` for nested objects or arrays when the next step needs structured data. Use `--json` and parse the relevant field instead.

## File Output

`--output` writes the result to a file and overwrites the target path without prompting:

```bash
defuddle parse ./page.html --md --output article.md
```

Before using `--output`:

- Require an explicit target path from the user or the task contract.
- Check whether the file already exists.
- Confirm overwrite when the target exists and the user has not already authorized replacement.
- Remember stdout becomes a success message such as `Output written to ...`, not the extracted content.

Use stdout redirection only when shell behavior is acceptable for the task and overwrite/truncation has been considered:

```bash
defuddle parse ./page.html --md > article.md
```

## Frontmatter

Use `--frontmatter` when the user wants Markdown-like archival output with metadata prepended by the CLI:

```bash
defuddle parse https://example.com/article --md --frontmatter
```

Do not reconstruct Defuddle frontmatter rules by hand. If exact quoting, date, or empty-value behavior matters, inspect the actual CLI output for the current version.

## Debugging

Use `--debug` only for diagnostics when extraction quality is poor:

```bash
defuddle parse ./page.html --json --debug
```

Debug mode can include extraction internals such as the chosen `contentSelector` and removed element snippets. Avoid debug on private, sensitive, authenticated, or internal pages unless the user explicitly accepts that extra page text and metadata may appear in output or logs.

If extraction returns empty or low-quality content:

- Try the same source with `--json --md` and inspect `title`, `wordCount`, `content`, and `contentMarkdown`.
- Try `--debug` on non-sensitive input.
- If the page needs cookies, clicks, client-side rendering, or session state, stop using Defuddle and route to browser tooling.

## Node Fallback

Use `defuddle/node` only when the CLI is not enough:

- You already have a DOM `Document` in a script.
- You need API-only options such as `contentSelector`, `useAsync: false`, `includeReplies`, a custom `fetch`, or profiling.
- You are embedding Defuddle inside a batch processor and need structured control over parsing.

Recommended Node shape:

```javascript
import { parseHTML } from 'linkedom';
import { Defuddle } from 'defuddle/node';

const { document } = parseHTML(html);
const result = await Defuddle(document, 'https://example.com/article', {
  markdown: true,
  useAsync: false,
});

console.log(result.content);
```

Notes:

- `defuddle/node` uses ESM import style; projects commonly need `"type": "module"`.
- Prefer passing a `Document`. Do not recommend deprecated string or whole JSDOM-instance inputs as the default path.
- The Node API is not a browser automation substitute. It does not click, log in, preserve a session, or take screenshots.

## Common Patterns

Clean a standard article for reading:

```bash
defuddle parse https://example.com/article --md
```

Get title and domain quickly:

```bash
defuddle parse https://example.com/article --property title
defuddle parse https://example.com/article --property domain
```

Extract metadata and Markdown for an agent pipeline:

```bash
defuddle parse https://example.com/article --json --md
```

Parse local HTML from another command:

```bash
curl -L https://example.com/article | defuddle parse - --json --md
```

Wrong tool examples:

```bash
# Direct Markdown is already clean enough for a fetch tool.
defuddle parse https://example.com/README.md --md

# This will not provide authenticated browser session state.
defuddle parse https://example.com/account --md

# This may overwrite article.md without asking.
defuddle parse ./page.html --md --output article.md
```

## Verification

Before reporting Defuddle-based results, verify the relevant surface:

- The command exited successfully.
- The output is non-empty and matches the requested format.
- For JSON, parse it with a JSON parser before trusting fields.
- For Markdown extraction, inspect enough output to confirm it is the article body, not navigation or an error page.
- For file output, confirm the expected file path was written and no unapproved overwrite occurred.
- For version-sensitive behavior, re-check `defuddle parse --help` or the package source.
