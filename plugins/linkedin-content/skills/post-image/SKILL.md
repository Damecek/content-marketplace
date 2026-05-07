---
name: post-image
description: Generate a detailed Gemini image prompt (1200x627 LinkedIn infographic) from a post draft. Picks one of 6 visual concepts based on the post content.
disable-model-invocation: true
argument-hint: "<post-number>"
---

# post-image

Read a completed LinkedIn post draft and generate a detailed image generation prompt optimized for Gemini (e.g., via the nanobanana MCP). Output is a ready-to-use prompt file plus alt text.

## When to use

Run after `/linkedin-content:draft-post N` for the same post number.

## User input

```text
$ARGUMENTS
```

`$ARGUMENTS` must be a positive integer (the post number).

## Argument parsing

- **No argument**: Output `"ERROR: Post number required. Usage: /linkedin-content:post-image N"` and STOP.
- **Not a valid integer**: Output `"ERROR: Invalid post number '$ARGUMENTS'."` and STOP.

## Prerequisites

Verify draft files exist for post N. Check for at least one file matching `content/posts/post-N/draft-*.md`.

If no drafts exist, output and STOP:

```
ERROR: Missing prerequisite.
- No drafts found for post [N] at content/posts/post-N/
- Run /linkedin-content:draft-post [N] first to generate them.
```

## Process

### Step 1: Load post context

1. Read draft variants for post N in preference order:
   - `draft-technical.md` (preferred — most concept-rich for visual representation)
   - `draft-business.md`
   - `draft-founder.md`
2. Read `content/posts/post-N/hooks.md` if it exists — hooks often contain the most visually evocative framings.
3. Extract:
   - **Core message** (1 sentence)
   - **Key visual concepts** — technical terms, metaphors, or contrasts that can be visualized
   - **Target audience** — infer from the chosen variant (developer, business, community)

### Step 2: Optional brand override

If `content/.config.md` exists, read brand styling overrides such as:

- **Accent color** — hex code (default: tech-neutral blue `#2563EB`)
- **Background** — default: dark navy / charcoal
- **Logo policy** — default: no logos (most logos are trademarked)
- **Style notes** — additional brand guidance

### Step 3: Choose visual concept

Pick ONE concept from this priority list — the first that fits the post's core message:

1. **Before/After Split** — when the post contrasts an old approach vs. a new one
2. **Architecture Diagram** — when the post explains how components connect
3. **Mapping/Translation** — when the post draws parallels between two systems
4. **Layered Stack** — when the post describes layers of a system
5. **Flow/Sequence** — when the post describes a process from start to end
6. **Stats/Metrics Highlight** — when the post has specific numbers (e.g., "0 dependencies, 12 lines")

### Step 4: Generate the image prompt

Build a Gemini prompt that includes:

1. **Format**: `LinkedIn infographic, 1200x627px landscape format, high resolution`
2. **Style direction**: Clean, modern, professional. Dark background (navy or charcoal) with the accent color from Step 2 (default `#2563EB`), white text, subtle gradients. No stock-photo look. Technical but accessible.
3. **Layout description**: Precise placement — left, center, right, top, bottom.
4. **Content elements**: Exact text labels, icons, or symbols. Keep text minimal — max 6–8 short labels.
5. **Visual metaphor**: The core concept translated into a visual.
6. **Exclusions**: No photos of people, no generic tech imagery, no clipart, no code screenshots, no third-party logos (trademarks).

#### Prompt structure template

```
Create a LinkedIn infographic (1200x627px, landscape).

**Visual concept**: [1-2 sentences describing the core visual metaphor]

**Layout**:
- [Left/Top section]: [what goes here]
- [Center]: [what goes here]
- [Right/Bottom section]: [what goes here]

**Style**: [color palette, typography direction, mood]

**Text labels** (exact text to include):
- [Label 1]
- [Label 2]
- ...

**Do NOT include**: [exclusions]
```

### Step 5: Write output

Write to `content/posts/post-N/image-prompt.md`.

Format:

```markdown
# Image Prompt: Post N — [Topic Title]

**Post**: N
**Source variant**: [technical/business/founder]
**Visual concept**: [chosen concept type from Step 3]
**Generated**: [YYYY-MM-DD]

## Core Message (for visual)

[1 sentence — the single idea the image must communicate]

## Gemini Prompt

[Full prompt text, ready to copy-paste into Gemini / nanobanana]

## Alt Text (for LinkedIn)

[1-2 sentence accessible description of the generated image — for the LinkedIn alt-text field]

## Usage Notes

- **LinkedIn image specs**: 1200x627px recommended for feed posts
- **Fallback**: If generation fails, use the alt text as a text-only post header
- **Regeneration**: Adjust the prompt and re-run if the visual doesn't match the post's tone
```

### Step 6: Output confirmation

After writing the file, output:

```
Image prompt written to content/posts/post-N/image-prompt.md
Copy the "Gemini Prompt" section into Gemini / nanobanana to generate the infographic.
```

## Error handling

| Condition | Response |
|---|---|
| Missing prerequisites | HARD BLOCK — see Prerequisites |
| Post number invalid | ERROR with usage instructions |
| No `$ARGUMENTS` provided | ERROR with usage instructions |
| Image generation tool unavailable | Write prompt file, output INFO message with manual instructions |
| Image generation fails | Keep prompt file, output WARNING with the error, suggest manual generation |
