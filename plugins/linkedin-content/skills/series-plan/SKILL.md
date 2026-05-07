---
name: series-plan
description: Generate a 5-topic editorial roadmap for a LinkedIn series promoting the current repository, following the awareness -> adoption narrative arc.
disable-model-invocation: true
argument-hint: "[context or topic overrides, optional]"
---

# series-plan

Generate a 5-topic editorial roadmap for a LinkedIn series promoting the current project. The series follows a narrative arc from awareness to adoption.

## When to use

Run after `/linkedin-content:proof-pack`. Use this when planning a multi-post LinkedIn campaign — typically 5 posts spaced over a few weeks.

## User input

```text
$ARGUMENTS
```

Treat user input (if any) as additional context, audience focus, or topic overrides.

## Prerequisites

Verify these files exist:

1. `content/claims.md`

If `claims.md` is missing, output the following and STOP — do not proceed:

```
ERROR: Missing prerequisite.
- Claims not found at content/claims.md
- Run /linkedin-content:proof-pack first to generate it.
```

## Process

### Step 1: Load context

1. Read `content/claims.md` — load all claims for grounding.
2. Sample the repository to refresh context beyond what `claims.md` already captured. Use the same area-discovery approach as `proof-pack`: package config, source layout, design docs, examples, tests, CI.

### Step 2: Generate 5 topics

Synthesize findings into exactly 5 topics following this narrative arc:

| # | Arc Position | Focus |
|---|---|---|
| 1 | **Awareness** | What this is — introduce the concept and the problem it addresses |
| 2 | **Problem** | The business problem it solves — why existing approaches fall short |
| 3 | **Technical** | How it works technically — architecture, design decisions |
| 4 | **Impact** | Why it matters for teams — organizational and developer experience benefits |
| 5 | **Adoption** | How to use it — getting started, practical next steps |

For each topic, generate these fields:

- **Topic number** (1–5)
- **Title**: Concise, descriptive topic title
- **Core message**: 1–2 sentences — the single key takeaway
- **CTA angle**: 1 sentence — the call-to-action direction
- **Contrarian hook**: 1–2 sentences — a non-obvious or contrarian angle to open with
- **Repo artifact references**: List of specific repo files that support this topic (minimum 1)
- **Supporting claim IDs**: List of claim IDs from `claims.md` that ground this topic (minimum 2)

### Step 3: Validate

1. **Exactly 5 topics** — no more, no fewer
2. **No topic overlap >20%** — each topic must cover substantially different ground. If two topics share more than 20% conceptual territory, merge or differentiate them.
3. **Every core message maps to at least one repo artifact and one claim**
4. **Narrative arc is maintained** — topics flow from awareness → adoption

### Step 4: Write output

Write to `content/series-plan.md`. Create parent directories as needed.

Format:

```markdown
# Series Plan: [project name]

**Generated**: [YYYY-MM-DD]
**Source**: Repository analysis of [project name]

## Topic 1: [Title]

**Arc position**: Awareness
**Core message**: [1–2 sentences]
**CTA angle**: [1 sentence]
**Contrarian hook**: [1–2 sentences]
**Supporting claims**: [C-XXX, C-YYY]
**Repo artifacts**:
- [file path 1]
- [file path 2]

## Topic 2: [Title]

...

## Topic 3: [Title]

...

## Topic 4: [Title]

...

## Topic 5: [Title]

...

---

## Validation

- Topics: [5/5]
- Overlap check: [PASS — no pair exceeds 20% overlap]
- Repo grounding: [PASS — all core messages reference repo artifacts]
- Claim grounding: [PASS — all topics reference claims]
- Narrative arc: [awareness → problem → technical → impact → adoption]
```

## Error handling

| Condition | Response |
|---|---|
| `claims.md` missing | HARD BLOCK — see Prerequisites |
| User argument conflicts with narrative arc | Incorporate user input as override; note deviation from default arc in the output |
| Cannot identify 5 distinct topics | Output available topics with a note explaining why fewer were found |
