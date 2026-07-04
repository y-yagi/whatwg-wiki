---
name: ingest
description: Ingest a WHATWG-related document from the given URL and create/update wiki pages
argument-hint: <URL>
---

Treat the URL given in `$ARGUMENTS` as a new source and ingest it into the wiki following the procedure defined under "On ingest" in CLAUDE.md.

## Steps

1. Fetch the source:
   - If the URL is a GitHub issue or pull request (`github.com/<org>/<repo>/issues/<n>` or `/pull/<n>`), do NOT use WebFetch — it doesn't reliably expose commenter roles. Instead use `gh api`:
     - `gh api repos/<org>/<repo>/issues/<n> --jq '{title, body, user: .user.login, author_association, created_at, state}'`
     - `gh api repos/<org>/<repo>/issues/<n>/comments --paginate --jq '.[] | {user: .user.login, author_association, created_at, html_url, body}'`
     - See "Weighting GitHub Issue Comments" below for how to use `author_association`.
   - Otherwise, fetch the URL with WebFetch.
2. Read `wiki/index.md` to check current coverage (list of existing pages).
3. Identify the concepts, algorithms, interfaces, events, and examples in the source.
4. Following the "Wiki Page Conventions" in CLAUDE.md, create or update approximately 10-15 wiki pages.
   - Filenames: spec prefix + kebab-case (e.g. `url-parsing.md`)
   - Frontmatter required: `spec`, `tags`, `updated`
   - Structure: `# Title` → summary → `##` sections → `## See Also` (using `[[wikilink]]` syntax) → `## Sources`
   - Also add cross-links to related existing pages (link `[[page-name]]` bidirectionally)
5. Update `wiki/index.md` to reflect the new/changed pages.
6. Print a summary of the pages created/updated.

## Rules

- Proceed autonomously without asking for confirmation.
- If the source is not one of the 7 target specs (HTML/Fetch/URL/Streams/DOM/Encoding/Infra) (e.g. an RFC), use `spec: concept` and create a page comparing it with the existing specs.
- If content contradicts an existing page, update it to resolve the contradiction.

## Weighting GitHub Issue Comments

When the source is a GitHub issue or PR, each comment's `author_association` tells you whether the commenter speaks for the standard or is an outside participant:

- **`MEMBER`** (and `OWNER`, if seen) — a WHATWG org member. Treat these comments as the **official/authoritative position** of the spec maintainers. Quote them explicitly, attribute them by role (e.g. "annevk (MEMBER, WHATWG URL editor)"), and let them anchor the page's framing of "where the standard currently stands" or "why a change was/wasn't made."
- **`COLLABORATOR`** — a repo collaborator without full member status. Treat as a well-informed but non-authoritative voice; note the role but don't present it as the spec's official stance.
- **`CONTRIBUTOR`** / **`NONE`** — outside participants (issue reporters, other implementers, interested developers). Summarize their arguments and proposals, but distinguish them clearly from MEMBER/COLLABORATOR comments — don't let community consensus get conflated with maintainer sign-off.

In the resulting wiki page(s), lead with the MEMBER position(s) as the definitive framing of the current state, then cover the community debate/proposals underneath. If MEMBER comments conflict with an existing wiki page's claims, update that page — a MEMBER comment is closer to ground truth about the spec than an inference from the spec text alone.
