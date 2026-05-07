---
name: draft-post
description: Draft the actual copy for a specific LinkedIn post (1 of 5 in the series) — produces 3 style variants (technical, business, founder), 5 opening hooks, and hashtags. Use this AFTER series-plan when the user wants to write the real text of post N. Requires the series plan from series-plan.
argument-hint: "<post-number 1-5>"
---

# draft-post

For a specified post number (1–5) in the LinkedIn series, generate 3 distinct style variants (technical, business, founder), 5 opening hooks, and a hashtag set.

## When to use

Run after `/linkedin-content:series-plan`. Run once per post in the series — you typically run this 5 times for a 5-post campaign.

## User input

```text
$ARGUMENTS
```

`$ARGUMENTS` must be a single integer 1–5 (the post number).

## Argument parsing

- **No argument**: Output `"ERROR: Post number required. Usage: /linkedin-content:draft-post N where N is 1–5."` and STOP.
- **Not 1–5**: Output `"ERROR: Invalid post number '$ARGUMENTS'. Must be 1–5."` and STOP.

## Prerequisites

Verify these files exist:

1. `content/series-plan.md`
2. `content/claims.md`

If `series-plan.md` is missing, output and STOP:

```
ERROR: Missing prerequisite.
- Series plan not found at content/series-plan.md
- Run /linkedin-content:series-plan first to generate it.
```

If `claims.md` is missing, output and STOP:

```
ERROR: Missing prerequisite.
- Claims not found at content/claims.md
- Run /linkedin-content:proof-pack first to generate it.
```

## Process

### Step 1: Load context

1. Read `content/series-plan.md` — extract Topic N's structure (title, core message, CTA angle, contrarian hook, supporting claims, repo artifacts).
2. Read `content/claims.md` — locate the claims that ground this topic. Require at least 2 supporting claims; if fewer, emit a WARNING but proceed.
3. If `content/.config.md` exists, read it for forbidden-phrase or tone overrides.

### Step 2: Generate 3 post variants

Each variant MUST:

- Be **150–300 words** (count carefully)
- Include at least **1 specific repo fact** (real file, class, or design decision)
- Include at least **1 business outcome** (concrete benefit in business terms)
- Open with a **strong first line** that creates curiosity and clarity
- Close with a **soft CTA** aligned with the topic's CTA angle
- Contain **NO forbidden phrases**: "AI is changing everything", "the future of", "game-changer", "revolutionary", "next-generation" (plus any from `.config.md`)
- Reference at least 1 claim from `claims.md`

#### Variant styles

1. **Technical** (`draft-technical.md`): Architecture-focused. Leads with how the system works. Precise technical language. Appeals to developers and architects.
2. **Business** (`draft-business.md`): Problem-solution, outcome-focused. Leads with the business problem this solves. Business language with just enough technical detail to be credible. Appeals to engineering managers and decision-makers.
3. **Founder** (`draft-founder.md`): Story-driven, community-focused. Leads with the journey or motivation behind the project. Authentic, personal voice. Appeals to open-source enthusiasts and the developer community.

### Step 3: Generate 5 opening hooks

Each hook is **2–3 lines** long, technically accurate, no superlatives, distinct framing:

1. **Pain-first** — start with a frustration the audience recognizes
2. **Misconception-first** — challenge a belief the audience holds
3. **Architecture-first** — lead with a technical decision that surprises
4. **Business-first** — lead with a concrete business outcome
5. **Curiosity-first** — pose a question that demands an answer

### Step 4: Generate hashtag set

Total **5–7 hashtags** (LinkedIn sweet spot). Mix:

- **Domain hashtags** (2–3): grounded in the project's language/platform (e.g., `#TypeScript`, `#Salesforce`, `#Python`, `#OpenSource`)
- **Topic-specific** (2–4): grounded in the post's specific angle (e.g., `#APIDesign`, `#OAuth`, `#DeveloperExperience`, `#AIAgents`)

Format as a single copy-paste line.

### Step 5: Write output

Write 5 files for post N. Replace `N` with the actual number.

**File 1**: `content/posts/post-N/draft-technical.md`

```markdown
# Post N — Technical: [Topic Title]

**Topic**: [N] — [Title]
**Variant**: Technical
**Word count**: [N]
**Claims referenced**: [C-XXX, C-YYY]

---

[Full post text]
```

**File 2**: `content/posts/post-N/draft-business.md`

```markdown
# Post N — Business: [Topic Title]

**Topic**: [N] — [Title]
**Variant**: Business
**Word count**: [N]
**Claims referenced**: [C-XXX, C-YYY]

---

[Full post text]
```

**File 3**: `content/posts/post-N/draft-founder.md`

```markdown
# Post N — Founder: [Topic Title]

**Topic**: [N] — [Title]
**Variant**: Founder
**Word count**: [N]
**Claims referenced**: [C-XXX, C-YYY]

---

[Full post text]
```

**File 4**: `content/posts/post-N/hooks.md`

```markdown
# Hooks: Post N — [Topic Title]

**Topic**: [N] — [Title]

## 1. Pain-First

[2–3 lines]

## 2. Misconception-First

[2–3 lines]

## 3. Architecture-First

[2–3 lines]

## 4. Business-First

[2–3 lines]

## 5. Curiosity-First

[2–3 lines]
```

**File 5**: `content/posts/post-N/hashtags.md`

```markdown
# Hashtags: Post N — [Topic Title]

**Topic**: [N] — [Title]

## Copy-paste block

[single line of 5–7 hashtags]

## Breakdown

- **Domain**: [hashtags + rationale]
- **Topic-specific**: [hashtags + rationale]
```

## Tip: paste with formatting

To paste a draft into LinkedIn with bold/italic preserved:

```bash
pandoc content/posts/post-N/draft-business.md -t html | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-html.swift"
```

## Error handling

| Condition | Response |
|---|---|
| Missing prerequisites | HARD BLOCK — see Prerequisites |
| Post number not 1–5 | ERROR with usage instructions |
| No `$ARGUMENTS` provided | ERROR with usage instructions |
| Topic has fewer than 2 supporting claims | WARNING: "Topic [N] has only [X] supporting claims. Consider re-running /linkedin-content:proof-pack to expand coverage." Proceed with available claims. |
