# WHATWG Wiki

Personal knowledge base for WHATWG specifications, maintained incrementally by Claude.

## How to Use

**Query** (default): Open Claude Code in this directory and ask about any WHATWG spec topic.
Claude reads the wiki first, answers, then writes valuable responses back.

**Ingest** a new source: `./scripts/ingest.sh sources/<file>` or `./scripts/ingest.sh <url>`

**Lint** the wiki: `./scripts/lint.sh`

---

## Agent Behavior

### On any WHATWG question
1. Read `wiki/index.md` to locate relevant pages
2. Read those pages
3. Answer the question
4. If the answer reveals a gap or new insight, create/update wiki pages and update `wiki/index.md`

### On ingest (`./scripts/ingest.sh`)
1. Read the source (file or URL)
2. Read `wiki/index.md` to see current coverage
3. Identify concepts, algorithms, interfaces, events, and examples in the source
4. Create or update ~10–15 wiki pages following the conventions below
5. Update `wiki/index.md`
6. Print a summary of what was created/updated

### On lint (`./scripts/lint.sh`)
1. Read `wiki/index.md`
2. Read all linked wiki pages
3. Check for:
   - Orphaned pages (not in index)
   - Contradictions between pages
   - Stale or vague claims
   - Missing cross-links between related concepts
   - Gaps (important topics referenced but not covered)
4. Fix issues in-place and report a summary

---

## Directory Layout

```
sources/    ← raw inputs: saved spec pages, articles, notes (add new content here)
wiki/       ← LLM-maintained markdown pages
  index.md  ← master index (always keep up to date)
scripts/    ← ingest.sh, lint.sh
```

---

## Wiki Page Conventions

### Filenames
Kebab-case with spec prefix. Examples:

| Spec | Example filenames |
|------|-------------------|
| html | `html-event-loop.md`, `html-parsing-tokenization.md`, `html-browsing-context.md` |
| fetch | `fetch-algorithm.md`, `fetch-cors.md`, `fetch-request-response.md` |
| url | `url-parsing.md`, `url-serialization.md` |
| streams | `streams-readable.md`, `streams-pipe.md` |
| dom | `dom-event-dispatch.md`, `dom-mutation-observer.md` |
| encoding | `encoding-utf8.md` |
| infra | `infra-sequences.md`, `infra-maps.md` |
| concept | `concept-microtask-queue.md` (cross-spec concepts) |

### Frontmatter (required on every page)
```yaml
---
spec: html | fetch | url | streams | dom | encoding | infra | concept
tags: [algorithm, interface, concept, event, parser, security]
updated: YYYY-MM-DD
---
```

### Page structure
1. `# Title` — short and specific
2. One-paragraph summary (what this is, why it matters)
3. Body with `##` sections as needed (e.g., `## Steps`, `## Key Properties`, `## Edge Cases`)
4. `## See Also` — internal links as `[[filename-without-extension]]`
5. `## Sources` — WHATWG spec URLs with section anchors where possible

### Cross-linking
Use `[[page-name]]` (Obsidian wikilink syntax) for internal references.
Cross-link liberally — every concept mentioned that has a page should be linked.

---

## WHATWG Specs in Scope

| Spec | URL | Focus areas |
|------|-----|-------------|
| HTML | html.spec.whatwg.org | event loop, parsing, scripting, browsing context, forms, workers |
| Fetch | fetch.spec.whatwg.org | fetch algorithm, CORS, request/response model, HTTP semantics |
| URL | url.spec.whatwg.org | URL parsing, serialization, origin |
| Streams | streams.spec.whatwg.org | readable/writable/transform streams, piping, backpressure |
| DOM | dom.spec.whatwg.org | node tree, events, ranges, mutation observers |
| Encoding | encoding.spec.whatwg.org | encodings, UTF-8 decode/encode |
| Infra | infra.spec.whatwg.org | primitives shared across all specs (sequences, maps, sets, strings) |

---

## wiki/index.md Format

Organized by spec. One line per page:

```markdown
## HTML
- [[html-event-loop]] — task queues, microtasks, rendering steps
- [[html-parsing-tokenization]] — tokenizer states and transitions

## Fetch
- [[fetch-algorithm]] — the main fetch algorithm, redirects, CORS checks
```
