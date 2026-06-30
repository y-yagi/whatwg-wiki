---
name: ingest
description: Ingest a WHATWG-related document from the given URL and create/update wiki pages
argument-hint: <URL>
---

Treat the URL given in `$ARGUMENTS` as a new source and ingest it into the wiki following the procedure defined under "On ingest" in CLAUDE.md.

## Steps

1. Fetch the URL in `$ARGUMENTS` with WebFetch.
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
