---
name: article-plan
description: Outline a long-form technical article (1500–2500 words) about the current repository, with each section mapped to verified claims and repo file references. Use this AFTER proof-pack when the user wants a long-form article or blog post (NOT a short LinkedIn post — for that use series-plan). Requires content/claims.md from proof-pack.
argument-hint: "[angle, audience, or focus override, optional]"
---

# article-plan

Generate a detailed section-by-section outline for a single long-form article (1500–2500 words) about the current project. The outline maps every section to verified claims and specific repo file references, so the final article is grounded and links back to the project.

## When to use

Run after `/linkedin-content:proof-pack`. Run before `/linkedin-content:draft-article`.

## User input

```text
$ARGUMENTS
```

Treat user input (if any) as additional context, angle, or target audience.

## Prerequisites

Verify these files exist:

1. `content/claims.md`

If `claims.md` is missing, output the following and STOP:

```
ERROR: Missing prerequisite.
- Claims not found at content/claims.md
- Run /linkedin-content:proof-pack first to generate it.
```

## Process

### Step 1: Load context

1. Read `content/claims.md` — load every claim for inline referencing.
2. Sample the repository to refresh context beyond claims (same area-discovery approach as `proof-pack`).
3. Determine the **repo URL base** for GitHub links: run `git remote get-url origin` (or read `.git/config`). Convert SSH form (`git@github.com:owner/repo.git`) to HTTPS (`https://github.com/owner/repo`). If no remote is set, ask the user or fall back to repo-relative paths.

### Step 2: Design article structure

Design an article with **6–8 sections** following this narrative arc:

| Phase | Purpose |
|---|---|
| **Opening** | Hook the reader with a concrete problem or provocative observation |
| **Context** | Establish what the project is and why it matters |
| **Architecture** | Walk through the design with specific code/file references |
| **Developer Experience** | Show how easy it is to use — code examples |
| **Security** (if applicable) | Explain the security/auth model and why it differentiates |
| **Getting Started** | Concrete steps: clone, install, configure, run |
| **Closing** | Restate the core value prop; CTA to the repo |

Adapt the section list to the project — drop sections that don't apply, but always keep Opening, Context, Architecture, and Closing.

For each section:

- **Section number** (1–N)
- **Heading**: Concise, descriptive section heading
- **Purpose**: 1 sentence — what this section accomplishes in the arc
- **Key points**: 3–5 bullet points of specific content to include
- **Target word count**: Approximate words for this section (totals must sum to 1500–2500)
- **Claims referenced**: List of claim IDs from `claims.md` that ground this section (minimum 1)
- **Repo links**: Specific repo files to link, formatted as `<repo-url>/blob/<default-branch>/<path>`
- **Code snippet**: Yes/No — if Yes, which file and what to excerpt

### Step 3: Generate metadata

- **Title**: Compelling, specific (not clickbait)
- **Subtitle**: 1-sentence supporting line
- **Target word count**: Total (1500–2500)
- **Target audience**: Primary and secondary
- **SEO keywords**: 5–8 keywords for discoverability
- **Hashtags**: 5–7 LinkedIn hashtags (see hashtag pool below)
- **Repo URL**: from `git remote get-url origin`

#### Hashtag selection

Pick 5–7 hashtags total. Prefer hashtags that match the project's domain (language/framework/platform/topic). Examples by domain:

- Open source: `#OpenSource`, `#GitHub`
- Language/runtime: `#Python`, `#TypeScript`, `#Java`, `#Go`, `#Rust`, `#Apex`
- Platform: `#Salesforce`, `#AWS`, `#Kubernetes`, `#NodeJS`
- Topic: `#API`, `#DevOps`, `#AIAgents`, `#LLM`, `#OAuth`, `#JSONRPC`, `#MCP`, `#DeveloperExperience`, `#EnterpriseSoftware`

### Step 4: Validate

1. **6–8 sections** — no more, no fewer
2. **Total target words** sum to 1500–2500
3. **Every section references at least 1 claim** from `claims.md`
4. **Every section references at least 1 repo file** as a full URL (or repo-relative path if no remote)
5. **Narrative arc is maintained** — opening hooks, context builds, technical deepens, closing converts
6. **At least 3 sections include code snippet indicators**

### Step 5: Write output

Write to `content/article-plan.md`.

Format:

```markdown
# Article Plan: [Title]

**Generated**: [YYYY-MM-DD]
**Source**: Repository analysis of [project name]
**Repo**: [repo URL]

## Metadata

- **Title**: [title]
- **Subtitle**: [subtitle]
- **Target word count**: [N]
- **Target audience**: [primary] / [secondary]
- **SEO keywords**: [keyword1], [keyword2], ...
- **Hashtags**: [copy-paste line of 5–7 hashtags]

## Section 1: [Heading]

- **Purpose**: [1 sentence]
- **Target words**: [N]
- **Key points**:
  - [point 1]
  - [point 2]
  - [point 3]
- **Claims**: [C-XXX, C-YYY]
- **Repo links**:
  - [full URL 1]
  - [full URL 2]
- **Code snippet**: [Yes/No — if yes, which file and what to excerpt]

## Section 2: [Heading]

...

---

## Validation

- Sections: [N] (target: 6–8)
- Total target words: [N] (target: 1500–2500)
- All sections claim-grounded: [YES/NO]
- All sections have repo links: [YES/NO]
- Narrative arc: [opening → ... → closing]
- Code snippet sections: [N] (minimum: 3)
```

## Error handling

| Condition | Response |
|---|---|
| Missing prerequisite | HARD BLOCK — see Prerequisites |
| User argument conflicts with default structure | Incorporate user input; note deviation in output |
| Cannot fill 6 sections with distinct content | Output available sections with a note explaining why fewer were found |
| `git remote get-url origin` fails | Use repo-relative paths for "Repo links" and add a WARNING to the output: "No git remote configured — links use repo-relative paths." |
