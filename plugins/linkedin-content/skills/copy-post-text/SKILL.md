---
name: copy-post-text
description: Copy a finished LinkedIn post draft to the macOS clipboard as plain UTF-8 text (via pbcopy-text.swift). Use AFTER draft-post N when the user wants the raw markdown on the clipboard with Mathematical Bold/Italic Unicode (U+1D400–U+1D7FF) intact. Use this instead of macOS pbcopy, which mangles 4-byte UTF-8 sequences.
argument-hint: "<post-number> [variant]"
---

# copy-post-text

Pipe a post draft into `scripts/pbcopy-text.swift` so it lands on the macOS pasteboard as correctly-encoded UTF-8. Unlike system `pbcopy`, this preserves Mathematical Bold/Italic characters used as a LinkedIn formatting hack.

## When to use

Run after `/linkedin-content:draft-post N` — when the user wants the raw markdown text on the clipboard, especially if the draft uses Mathematical Bold (𝗕𝗼𝗹𝗱) or Italic (𝘐𝘵𝘢𝘭𝘪𝘤) Unicode characters that macOS `pbcopy` corrupts.

## User input

```text
$ARGUMENTS
```

`$ARGUMENTS` is `<post-number> [variant]`:

- `<post-number>` — required, integer 1–5.
- `[variant]` — optional, one of `technical`, `business`, `founder`. Defaults to `business`.

## Argument parsing

- **No argument**: Output `"ERROR: Post number required. Usage: /linkedin-content:copy-post-text N [variant]"` and STOP.
- **Post number not 1–5**: Output `"ERROR: Invalid post number '<n>'. Must be 1–5."` and STOP.
- **Variant not in {technical, business, founder}**: Output `"ERROR: Invalid variant '<v>'. Must be technical, business, or founder."` and STOP.

## Prerequisites

The draft file `content/posts/post-N/draft-<variant>.md` must exist. If missing, output and STOP:

```
ERROR: Draft not found at content/posts/post-N/draft-<variant>.md
- Run /linkedin-content:draft-post N first to generate it.
```

## Process

Run this single Bash command, substituting `N` and `<variant>`:

```bash
cat content/posts/post-N/draft-<variant>.md | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-text.swift"
```

On success, output:

```
Copied post N (<variant>) to clipboard as plain UTF-8. Paste anywhere with Cmd-V.
```

If the pipeline exits non-zero, surface the stderr verbatim and STOP.

## Error handling

| Condition | Response |
|---|---|
| Missing draft file | HARD BLOCK — see Prerequisites |
| Invalid post number / variant | ERROR with usage |
| Script exits non-zero | Surface stderr, STOP |
