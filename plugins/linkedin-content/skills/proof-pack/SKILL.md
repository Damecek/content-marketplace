---
name: proof-pack
description: Entry point for any LinkedIn content (post, article, or series) about the current repository. Use this FIRST whenever the user wants to write, draft, plan, or promote anything on LinkedIn about this project — it extracts the verifiable factual claims that every other drafting skill depends on. Triggers on intents like "write a LinkedIn post about this repo", "draft an article about this project", "promote this on LinkedIn".
argument-hint: "[focus area or context, optional]"
---

# proof-pack

Extract at least 15 verifiable factual claims from the current repository, organized into 6 categories. Each claim must cite a specific source file with a verbatim excerpt. The output (`content/claims.md`) serves as the factual foundation for all subsequent skills in this plugin.

## When to use

Always run this **first**, before any other `linkedin-content` skill. Re-run if the repository has changed substantially or if you want to expand coverage.

## User input

```text
$ARGUMENTS
```

Treat user input (if any) as additional focus area or context for claim extraction (e.g., "focus on security", "emphasize developer experience").

## Prerequisites

- Run from inside a git repository (current working directory).
- The repo must contain readable source code, configuration, and ideally some design documentation.

## Process

### Step 1: Map the repository

Discover what kind of project this is and what areas are worth scanning. Use the file structure to infer:

- **Package layout** — `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`, `sfdx-project.json`, etc.
- **Source layout** — `src/`, `lib/`, `packages/`, `force-app/`, language-specific conventions
- **Design docs** — `docs/`, `README.md`, `ARCHITECTURE.md`, `specs/`, ADRs (`docs/adr/`)
- **Examples** — `examples/`, `samples/`, `demo/`
- **Tests** — `test/`, `tests/`, `__tests__/`, `*.test.*`
- **CI/Deploy** — `.github/workflows/`, `Dockerfile`, deploy configs

Enumerate 5–8 high-signal areas to scan based on what you find. Don't read every file — sample representative files per area.

### Step 2: Extract claims

For each content-worthy fact, create a claim entry with these fields:

- **ID**: Unique identifier (`C-001`, `C-002`, ...)
- **Category**: One of the 6 categories below
- **Statement**: 1–2 sentence factual claim in quotable form
- **Source file**: Repo-relative path to the file the claim is grounded in
- **Excerpt**: Verbatim code snippet or quote from the source file that proves the claim
- **Business value**: 1 sentence translating the technical fact into business value

### Step 3: Organize by category

Organize all claims into these 6 mandatory categories. Every category must have at least 1 claim.

1. **Package Purpose** — What the project does and why it exists
2. **Architecture** — Design decisions, patterns, protocol/dependency choices
3. **Developer Experience** — Ease of use, API design, getting started
4. **Security** — Auth model, credential handling, security design
5. **Deployment** — Packaging, distribution, installation
6. **Differentiation** — What makes this different from alternatives

If the repo genuinely has no claims for a category (e.g., no auth surface for "Security"), use the closest applicable angle (e.g., "no network surface, no secrets to handle") and document the rationale in the validation block.

### Step 4: Exclusion rules

**NEVER** extract claims from:

- `.env` files or `.env.*` files
- Credential files, external client app configurations
- Any file containing API keys, secrets, passwords, or tokens

If you encounter such a file, silently skip it and log the exclusion in the comments section at the bottom of the output file.

### Step 5: Validate

Before writing output, verify:

1. **At least 15 claims** total
2. **All 6 categories represented** — at least 1 claim per category
3. **Every claim has a source file and verbatim excerpt** — no unsourced claims
4. **No secret-containing files** were used as sources

### Step 6: Write output

Write claims to `content/claims.md` (relative to the current working directory). Create parent directories as needed.

Format:

```markdown
# Claims: [project name from package config or repo name]

**Generated**: [YYYY-MM-DD]
**Source**: Repository analysis of [project name]
**Total claims**: [N]

## Package Purpose

### C-001: [Short title]

- **Statement**: [1–2 sentence quotable claim]
- **Source**: `[repo-relative file path]`
- **Excerpt**:
  ```
  [verbatim code/text from source]
  ```
- **Business value**: [1 sentence]

### C-002: [Short title]

...

## Architecture

...

## Developer Experience

...

## Security

...

## Deployment

...

## Differentiation

...

---

## Validation

- Total claims: [N] (minimum: 15)
- Categories covered: [6/6]
- All claims sourced: [YES]
- Secret files excluded: [list of skipped files, or "None encountered"]
```

## Error handling

| Condition | Response |
|---|---|
| Fewer than 15 extractable claims | WARNING in output: "Only [N] claims extracted. Consider expanding repo documentation or relaxing category requirements." Proceed with available claims. |
| Secret-containing file encountered | Silently skip. Log exclusion in comments section at bottom of output. |
| Category cannot be filled | Document the gap in validation block; do not invent claims. |
| Not a git repository / no source files found | ERROR: "proof-pack must run from inside a project repository. Current directory has no recognizable source layout." Stop. |
