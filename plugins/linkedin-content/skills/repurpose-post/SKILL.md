---
name: repurpose-post
description: Transform a finished LinkedIn post into 4 derivative formats (short post, carousel script, comment version, DM explanation) for multi-channel distribution. Use this AFTER draft-post N when the user wants to spread the same message across other channels or formats.
argument-hint: "<post-number 1-5>"
---

# repurpose-post

Transform a completed LinkedIn post draft into 4 derivative formats for multi-channel distribution: a short post, a carousel script, a comment version, and a DM explanation.

## When to use

Run after `/linkedin-content:draft-post N` for the same post number — once the original LinkedIn post is finalized and you want to spread the message across other formats and surfaces.

## User input

```text
$ARGUMENTS
```

`$ARGUMENTS` must be a single integer 1–5 (the post number).

## Argument parsing

- **No argument**: Output `"ERROR: Post number required. Usage: /linkedin-content:repurpose-post N where N is 1–5."` and STOP.
- **Not 1–5**: Output `"ERROR: Invalid post number '$ARGUMENTS'. Must be 1–5."` and STOP.

## Prerequisites

Check for draft files at `content/posts/post-N/draft-*.md`.

If no drafts exist, output and STOP:

```
ERROR: Missing prerequisite.
- No drafts found for post [N] at content/posts/post-N/
- Run /linkedin-content:draft-post [N] first to generate them.
```

## Process

### Step 1: Load source draft

1. Read all available draft variants for post N (`draft-technical.md`, `draft-business.md`, `draft-founder.md`).
2. Select the source for repurposing. Preference order:
   - If multiple variants exist, use the **business** variant (most accessible for derivative formats)
   - If only one variant exists, use that one
3. Note the source variant, its core message, and the key repo fact for preservation validation.

### Step 2: Generate 4 derivative formats

#### 1. Short Post (under 100 words)

Condense the full post into a punchy version under 100 words. MUST preserve:

- The **core message** from the original
- At least **1 key repo fact** from the original

#### 2. Carousel Script (5–8 slides)

Create a carousel-style script. Each slide has:

- **Headline**: Bold, attention-grabbing (5–10 words)
- **Body**: Supporting text (1–3 sentences)

The carousel should tell a complete story from slide 1 to the final slide. The last slide should include a CTA. MUST preserve:

- The **core message**
- At least **1 key repo fact**

#### 3. Comment Version (2–3 sentences)

A standalone comment that could be posted under someone else's related LinkedIn post. Must:

- Be **2–3 sentences** only
- Be self-contained and conversational
- Reference the project naturally without being promotional
- Preserve the **core message** in condensed form

#### 4. DM Explanation (3–5 sentences)

An informal, direct-message-style explanation. Must:

- Be **3–5 sentences**
- Use **informal, conversational tone** (as if explaining to a colleague over chat)
- Preserve the **core message** and at least **1 repo fact**
- Not sound like marketing copy

### Step 3: Validate

1. **Short post** is under 100 words
2. **Carousel** has 5–8 slides, each with headline + body
3. **Comment version** is 2–3 sentences
4. **DM explanation** is 3–5 sentences
5. **Core message preserved** in all 4 derivatives
6. **Key repo fact preserved** in short post, carousel, and DM explanation

### Step 4: Write output

Write to `content/posts/post-N/derivatives.md`.

Format:

```markdown
# Derivatives: Post N — [Topic Title]

**Source variant**: [technical/business/founder]
**Generated**: [YYYY-MM-DD]

## Short Post

**Word count**: [N] (max: 100)

[Short post text]

## Carousel Script

**Slides**: [N] (target: 5–8)

### Slide 1: [Headline]
[Body text]

### Slide 2: [Headline]
[Body text]

### Slide 3: [Headline]
[Body text]

...

### Slide [N]: [Headline — CTA]
[Body text with call-to-action]

## Comment Version

**Sentences**: [N] (target: 2–3)

[Comment text]

## DM Explanation

**Sentences**: [N] (target: 3–5)

[DM text]

---

## Validation

- Short post word count: [N] (max: 100)
- Carousel slides: [N] (target: 5–8)
- Comment sentences: [N] (target: 2–3)
- DM sentences: [N] (target: 3–5)
- Core message preserved: [YES/NO]
- Key repo fact preserved: [YES/NO]
```

## Error handling

| Condition | Response |
|---|---|
| Missing prerequisites | HARD BLOCK — see Prerequisites |
| Post number not 1–5 | ERROR with usage instructions |
| No `$ARGUMENTS` provided | ERROR with usage instructions |
