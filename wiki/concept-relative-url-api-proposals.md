---
spec: concept
tags: [concept, api]
updated: 2026-07-04
---

# Proposed APIs for Relative URL Manipulation

[whatwg/url#531](https://github.com/whatwg/url/issues/531) accumulated a long list of concrete API shapes for handling relative references, none of which has been adopted into the standard. Collected here for reference against [[concept-url-531-relative-url-debate|the debate]] and [[concept-uri-reference-vs-whatwg-url|the underlying type-design disagreement]].

## Proposals Discussed In-Thread

- **`URL` object-as-base argument** — jasnell (COLLABORATOR)'s minimal-change suggestion: let `new URL()`'s second argument accept a partial record like `{ protocol: 'http:' }` instead of requiring an absolute base string, e.g. `new URL('/foo', { protocol: 'http:' })` ([837029855](https://github.com/whatwg/url/issues/531#issuecomment-837029855)).
- **`new PartialURL()` / `URL.resolve()`** — the original reporter's own first sketch: a constructor that tolerates missing components, plus a static method to resolve two relative URLs against each other and return another relative URL, e.g. `URL.resolve('./from/index.html', './to') → './from/to'` (original post).
- **`RelativeURL`** — name proposed independently on the [related Node.js issue](https://github.com/nodejs/node/issues/12682) and voted for by lonr, who shipped an implementation ([href](https://github.com/lonr/href)) built by parsing URLs starting from the [[url-parser-states|Path state]] directly ([1084636588](https://github.com/whatwg/url/issues/531#issuecomment-1084636588)).
- **`URLPathAndHash`** — styfle's narrower framing: something between `URL` and `URLSearchParams` that covers only path+query+fragment manipulation, explicitly sidestepping the question of what "relative" means for scheme/host ([836753269](https://github.com/whatwg/url/issues/531#issuecomment-836753269)).
- **`URLFragment`** — jasnell's alternative minimal-scope idea: a type that could never itself be interpreted as a usable, resolvable `URL`, used purely for composing fragments before an eventual `Resolve` step, e.g. `new URLFragment('/foo/'); new URLFragment('bar', fragment1)` ([837029855](https://github.com/whatwg/url/issues/531#issuecomment-837029855) — same comment as the object-argument idea, offered as the alternative branch).
- **`URIReference` / `URLReference`** — alwinb's full formal model (see [[concept-uri-reference-vs-whatwg-url]]), with `Rebase` (combine, stay possibly-relative) and `Resolve` (combine, coerce to absolute) operations; packaged at [alwinb/url-reference](https://github.com/alwinb/url-reference) ([2646328707](https://github.com/whatwg/url/issues/531#issuecomment-2646328707), [2646349146](https://github.com/whatwg/url/issues/531#issuecomment-2646349146)).

## Independent Reference Implementations Named in the Thread

- **[reurl](https://github.com/alwinb/reurl)** (alwinb) — an earlier, simpler iteration; immutable URL objects supporting `.set()`, `.goto()` (merge/resolve), `.force()` (repairs missing authority per WHATWG's special-URL rules), and `.normalize()` (dot-segment collapse) — shared by "ghost" (ghost/zamfofex) as a concrete illustration mid-thread ([696422606](https://github.com/whatwg/url/issues/531#issuecomment-696422606)).
- **[alwinb/url-specification](https://alwinb.github.io/url-specification)** — the full formal grammar + reference implementation, passing all WPT URL tests except 6 IDNA-related ones at the time ([836838167](https://github.com/whatwg/url/issues/531#issuecomment-836838167)); superseded by `url-reference` above.
- **[href](https://github.com/lonr/href)** (lonr) — reuses jsdom/whatwg-url internals, parses starting from the Path state.
- **[astro-community/relative-url](https://github.com/astro-community/relative-url)** — a third-party API wrapper built directly on alwinb's implementation, cited by alwinb as evidence the use case is real ("It shows that I anticipated the use cases correctly" — [1817055088](https://github.com/whatwg/url/issues/531#issuecomment-1817055088)).

## Userland Hacks (Not Proposals, But Documented Coping Patterns)

- The [[concept-fake-base-url-workaround|fake-base-URL trick]] in its various forms.
- A `URLfrom(origin)` higher-order factory that wraps the global `URL` constructor to always inject a fixed base, letting call sites read `new RelativeURL('/get')` — jimmywarting's example, built for Node.js environments lacking `location`/`origin` ([1372473805](https://github.com/whatwg/url/issues/531#issuecomment-1372473805)).
- Regex-based string concatenation, which is what Ky (the library that prompted the original report) fell back to after abandoning `new URL()` — documented in detail in sholladay's account of Ky's multi-year attempt to support relative input safely ([836836953](https://github.com/whatwg/url/issues/531#issuecomment-836836953)).

## See Also

- [[concept-url-531-relative-url-debate]]
- [[concept-uri-reference-vs-whatwg-url]]
- [[concept-fake-base-url-workaround]]
- [[url-api]]
- [[url-parser-states]]

## Sources

- https://github.com/whatwg/url/issues/531
