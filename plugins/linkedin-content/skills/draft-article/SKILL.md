---
name: draft-article
description: Write a complete publish-ready long-form article (1500-2500 words) from the article plan, with inline code snippets and direct repo links.
disable-model-invocation: true
argument-hint: "[tone, audience, or focus override, optional]"
---

# draft-article

Generate a complete long-form article (1500–2500 words) based on the article plan. The article includes inline code snippets, direct links to repository files, and is grounded in verified claims. Output is publish-ready markdown.

## When to use

Run after `/linkedin-content:article-plan`. This produces the actual article — the previous skill only produced the outline.

## User input

```text
$ARGUMENTS
```

Treat user input (if any) as additional tone, audience, or focus overrides.

## Prerequisites

Verify these files exist:

1. `content/article-plan.md`
2. `content/claims.md`

If `article-plan.md` is missing, output and STOP:

```
ERROR: Missing prerequisite.
- Article plan not found at content/article-plan.md
- Run /linkedin-content:article-plan first to generate it.
```

If `claims.md` is missing, output and STOP:

```
ERROR: Missing prerequisite.
- Claims not found at content/claims.md
- Run /linkedin-content:proof-pack first to generate it.
```

## Process

### Step 1: Load context

1. Read `content/article-plan.md` — extract title, subtitle, metadata, and every section's plan (key points, target word count, claims, repo links, code snippet indicators).
2. Read `content/claims.md` — load all claims for inline referencing.
3. Read every source file referenced by "Code snippet" entries — extract the verbatim excerpts to embed.

### Step 2: Optional config override

If `content/.config.md` exists, read it. It may override defaults like:

- **Forbidden phrases** — additional banned phrases beyond the defaults below
- **Hashtag set** — required/preferred hashtags
- **Tone** — voice instructions (e.g., "warm and conversational", "terse and technical")

If absent, use defaults.

### Step 3: Write the article

Follow the plan's section order and headings. The article MUST:

- Be **1500–2500 words** total (count carefully)
- Hit each section's **target word count** (±20%)
- Include **every key point** listed in the plan for each section
- Embed **inline code snippets** where the plan indicates — fenced code blocks with language tags (e.g., ` ```python`, ` ```typescript`, ` ```bash`, ` ```apex`)
- Include **direct repo links** using full URLs from the plan
- Reference **verified claims** — do not invent capabilities or stats not in `claims.md`
- Use **no forbidden phrases**: "AI is changing everything", "the future of", "game-changer", "revolutionary", "next-generation" — plus any additional phrases from `.config.md`
- Maintain a **technical-but-accessible tone** — precise enough for developers, clear enough for technical managers
- Include a **TL;DR** block at the top (3–4 bullet points summarizing the article)

#### Writing style guidelines

- **Lead with specifics, not abstractions** — "12 lines of code" not "minimal boilerplate"
- **Show, don't just tell** — use code snippets as evidence
- **Link generously** — every mentioned file, class, or document should link to its repo URL
- **Use subheadings** within long sections for scannability
- **One idea per paragraph** — keep paragraphs to 3–5 sentences max

### Step 4: Generate hashtags

Use the hashtag set from `article-plan.md` (or `.config.md` override). Total: 5–7 hashtags as a single copy-paste line.

### Step 5: Validate

1. **Word count** is 1500–2500
2. **All plan sections** are present with correct headings
3. **At least 3 code snippets** are embedded
4. **At least 5 repo links** are included
5. **No unsourced claims** — every factual statement traces to `claims.md`
6. **No forbidden phrases** present
7. **TL;DR block** is present at the top

### Step 6: Write output

Write 2 files.

**File 1**: `content/article/draft.md`

```markdown
# [Article Title]

*[Subtitle]*

**Word count**: [N]
**Claims referenced**: [C-XXX, C-YYY, ...]
**Repo**: [repo URL]

---

## TL;DR

- [bullet 1]
- [bullet 2]
- [bullet 3]
- [bullet 4]

---

[Full article text with sections, code snippets, and links]

---

**Hashtags**: [copy-paste line]
```

**File 2**: `content/article/hashtags.md`

```markdown
# Hashtags: Article

## Copy-paste block

[single line of 5–7 hashtags]

## Breakdown

- **Domain**: [hashtags grounded in language/platform/runtime, with rationale]
- **Topic-specific**: [hashtags grounded in this article's specific angle, with rationale]
```

## Tip: paste with formatting

To paste the article into a rich-text editor (LinkedIn, Google Docs, Notion) with formatting preserved, render the markdown to HTML and pipe through the bundled helper:

```bash
pandoc content/article/draft.md -t html | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-html.swift"
```

For plain text with correct UTF-8 (handles bold/italic Unicode characters that macOS `pbcopy` mangles):

```bash
cat content/article/draft.md | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-text.swift"
```

## Error handling

| Condition | Response |
|---|---|
| Missing prerequisites | HARD BLOCK — see Prerequisites |
| Article plan has fewer than 6 sections | WARNING: proceed but note deviation |
| Code snippet source file unreadable | Skip snippet, add `<!-- TODO: add code snippet from [file] -->` placeholder |
| Word count outside 1500–2500 after drafting | Adjust: trim verbose sections or expand thin ones before final output |
