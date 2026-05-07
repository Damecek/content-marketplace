# linkedin-content

A Claude Code plugin with skills for creating LinkedIn content (long-form articles, post series, image prompts, multi-channel repurpose). All outputs are grounded in facts extracted from the target repository.

## Workflow

```
proof-pack ──▶ series-plan ──▶ draft-post N ──┬──▶ post-image N
     │                                         └──▶ repurpose-post N
     └──────▶ article-plan ──▶ draft-article
```

1. **`/linkedin-content:proof-pack`** — Extract 15+ verifiable claims from the current repo into `content/claims.md`. Run this first.
2. **`/linkedin-content:series-plan`** — Generate a 5-topic editorial roadmap → `content/series-plan.md`.
3. **`/linkedin-content:article-plan`** — Outline a 1500–2500-word article → `content/article-plan.md`.
4. **`/linkedin-content:draft-article`** — Write the full article + hashtags → `content/article/draft.md`, `content/article/hashtags.md`.
5. **`/linkedin-content:draft-post N`** (N=1–5) — Per series post: 3 style variants (technical/business/founder) + 5 hooks + hashtags → `content/posts/post-N/`.
6. **`/linkedin-content:post-image N`** — Gemini image prompt for post N → `content/posts/post-N/image-prompt.md`.
7. **`/linkedin-content:repurpose-post N`** — 4 derivative formats (short post, carousel, comment, DM) → `content/posts/post-N/derivatives.md`.

## Output layout

All outputs land under `content/` in the target repo (the cwd where you invoke the skills):

```
content/
├── claims.md
├── series-plan.md
├── article-plan.md
├── article/
│   ├── draft.md
│   └── hashtags.md
└── posts/
    └── post-1/
        ├── draft-technical.md
        ├── draft-business.md
        ├── draft-founder.md
        ├── hooks.md
        ├── hashtags.md
        ├── image-prompt.md
        └── derivatives.md
```

## Configuration overrides (optional)

Create `content/.config.md` in the target repo to override defaults. Recognized keys:

- **Forbidden phrases** — additional banned phrases (defaults: "AI is changing everything", "the future of", "game-changer", "revolutionary", "next-generation")
- **Hashtag set** — required/preferred hashtags
- **Tone** — voice instructions
- **Brand accent color** — hex code for image prompts (default `#2563EB`)

If absent, defaults apply.

## Helper scripts

`scripts/pbcopy-html.swift` and `scripts/pbcopy-text.swift` copy rich-text HTML or correctly-encoded UTF-8 to the macOS pasteboard, useful for pasting drafts into LinkedIn / Google Docs / Notion with formatting preserved.

```bash
# Paste with formatting (requires pandoc):
pandoc content/article/draft.md -t html | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-html.swift"

# Paste plain text with correct UTF-8 (handles bold/italic Unicode):
cat content/article/draft.md | "${CLAUDE_PLUGIN_ROOT}/scripts/pbcopy-text.swift"
```

## Local development

```bash
claude --plugin-dir /path/to/linkedin-content
```

Edits to `SKILL.md` files take effect after `/reload-plugins`.
