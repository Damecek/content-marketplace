---
name: copy-post-html
description: Copy a finished LinkedIn post draft to the macOS clipboard with formatting preserved (HTML via pandoc + pbcopy-html.swift). Use AFTER draft-post N when the user wants to paste the post into the LinkedIn editor with bold/italic intact. Requires pandoc.
argument-hint: "<post-number> [variant]"
---

# copy-post-html

Pipe a post draft through `pandoc -t html` into `scripts/pbcopy-html.swift` so it lands on the macOS pasteboard as rich text. Pasting into LinkedIn / Google Docs / Notion preserves bold, italics, headings, and lists.

## When to use

Run after `/linkedin-content:draft-post N` — when the user is ready to paste the post into LinkedIn.

## User input

```text
$ARGUMENTS
```

`$ARGUMENTS` is `<post-number> [variant]`:

- `<post-number>` — required, integer 1–5.
- `[variant]` — optional, one of `technical`, `business`, `founder`. Defaults to `business`.

## Argument parsing

- **No argument**: Output `"ERROR: Post number required. Usage: /linkedin-content:copy-post-html N [variant]"` and STOP.
- **Post number not 1–5**: Output `"ERROR: Invalid post number '<n>'. Must be 1–5."` and STOP.
- **Variant not in {technical, business, founder}**: Output `"ERROR: Invalid variant '<v>'. Must be technical, business, or founder."` and STOP.

## Prerequisites

1. The draft file `content/posts/post-N/draft-<variant>.md` must exist. If missing, output and STOP:

   ```
   ERROR: Draft not found at content/posts/post-N/draft-<variant>.md
   - Run /linkedin-content:draft-post N first to generate it.
   ```

2. `pandoc` must be on PATH. If `command -v pandoc` returns nothing, output and STOP:

   ```
   ERROR: pandoc not found on PATH.
   - Install with: brew install pandoc
   - Or use /linkedin-content:copy-post-text for plain-text copy without pandoc.
   ```

## Process

Run this single Bash command, substituting `N` and `<variant>`:

```bash
pandoc content/posts/post-N/draft-<variant>.md -t html | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-html.swift"
```

On success, output:

```
Copied post N (<variant>) to clipboard as HTML. Paste into LinkedIn with Cmd-V — formatting preserved.
```

If the pipeline exits non-zero, surface the stderr verbatim and STOP.

## Error handling

| Condition | Response |
|---|---|
| Missing draft file | HARD BLOCK — see Prerequisites |
| `pandoc` not installed | HARD BLOCK with install hint |
| Invalid post number / variant | ERROR with usage |
| Script exits non-zero | Surface stderr, STOP |
