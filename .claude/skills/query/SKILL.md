---
name: query
description: Answer a WHATWG spec question using the wiki, then write back new insights
argument-hint: <question>
---

Treat the question given in `$ARGUMENTS` as a WHATWG spec question and answer it following the procedure defined under "On any WHATWG question" in CLAUDE.md.

## Steps

1. Read `wiki/index.md` to locate pages relevant to the question.
2. Read those pages (and any pages they link to via `[[wikilink]]` that are directly relevant).
3. Answer the question using the wiki content. Prefer citing/quoting the wiki pages over re-deriving from memory.
4. If the wiki doesn't fully cover the question, or the spec source is needed for accuracy, fetch the relevant spec URL (see the spec table in CLAUDE.md) to fill the gap before answering.
5. After answering, decide whether the answer revealed something worth persisting:
   - A gap: the question touched a concept with no existing page.
   - A new insight: something true and non-obvious that isn't captured in any current page.
   - A correction: something in the wiki that turned out to be stale or wrong.
   If so, create/update the relevant wiki page(s) following the "Wiki Page Conventions" in CLAUDE.md (frontmatter, `## See Also`, `## Sources`), and update `wiki/index.md` to match.
6. If nothing new was learned, don't touch the wiki — not every question needs a wiki write.

## Rules

- Answer the user directly and concisely first; wiki maintenance is a side effect, not the primary output.
- Only write to the wiki when there's a genuine gap, insight, or correction — avoid low-value edits (rewording, redundant pages).
- Keep new/updated pages consistent with the filename and frontmatter conventions in CLAUDE.md.
- Cross-link liberally: link the new content to related existing pages, and update those pages' `## See Also` sections to link back.
- If you updated the wiki, briefly note what was created/updated after answering the question.
