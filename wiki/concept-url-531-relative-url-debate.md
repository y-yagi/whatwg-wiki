---
spec: concept
tags: [concept, api]
updated: 2026-07-04
---

# The `whatwg/url#531` Debate: Should `URL` Support Relative References?

[whatwg/url#531](https://github.com/whatwg/url/issues/531) ("Support relative URLs"), opened 2020-07-17 and still open as of this writing, is the longest-running community discussion about a structural gap between the WHATWG URL Standard and [[uri-reference-resolution|RFC 3986's relative-reference model]]: the `URL` constructor requires an absolute URL (a scheme, and for [[url-concepts|special schemes]] a host) to succeed at all, and there is no way to parse, hold, or manipulate a **relative reference** (`/foo`, `./bar`, `//host/baz`) as a first-class value in the standard JS API.

## The Original Problem

The reporter (sholladay, maintainer of the [Ky](https://github.com/sindresorhus/ky) HTTP library) demonstrated the failure mode directly:

```js
new URL('./page.html', 'https://site.com/help/');  // OK
new URL('./page.html', '/help/');                  // TypeError: not a valid URL
```

Determining an absolute base URL to satisfy the constructor is environment-dependent (`document.baseURI` in a document, `self.location` in a worker, nothing at all in Node.js/Deno without extra flags), which made writing environment-agnostic ("isomorphic") URL-handling code difficult enough that Ky ultimately dropped `new URL()` in favor of regex string manipulation — see comment [660070816](https://github.com/whatwg/url/issues/531#issuecomment-660070816).

## The Core Positions

This is not a bug report with an agreed fix; it is an ongoing design disagreement, tracked here by participant role (`author_association` from the GitHub API — MEMBER/COLLABORATOR are WHATWG-affiliated maintainers, CONTRIBUTOR/NONE are outside participants):

- **annevk (MEMBER, WHATWG URL editor)**: the `URL` object's entire purpose is to represent something absolute and "complete... useful in a wide variety of contexts that expect a scheme"; changing that would break the meaning of the type. Progress requires concrete **browser-context** use cases, not just cross-platform library pain, citing the WHATWG [working-mode](https://whatwg.org/working-mode#changes) bar for new features ([714305738](https://github.com/whatwg/url/issues/531#issuecomment-714305738)).
- **jyasskin (MEMBER)**: even in adjacent efforts like Web Packages, there was no plan to expose "relative-ness" to JavaScript — relative references would just be resolved against a package base internally, mirroring how HTML already handles relative URLs invisibly ([716204129](https://github.com/whatwg/url/issues/531#issuecomment-716204129)).
- **jasnell (COLLABORATOR)**: a relative reference is fundamentally unusable in isolation — you cannot separate parsing/resolution from the environment providing the "relative to what" context. Proposed the smallest workable path forward: let `new URL()`'s second argument accept a partial URL-record-shaped object (e.g. `new URL('/foo', { protocol: 'http:' })`) instead of requiring a full absolute base string ([837029855](https://github.com/whatwg/url/issues/531#issuecomment-837029855)). Later reiterated that the [[concept-fake-base-url-workaround|fake-base-URL workaround]] already covers the common case and questioned why it's insufficient ([2645821926](https://github.com/whatwg/url/issues/531#issuecomment-2645821926)).
- **mgiuca (CONTRIBUTOR)**: pushed back on an earlier, more radical version of the request (defaulting `base` to `document.location` implicitly) as removing a valuable explicitness guarantee — that not passing `document.location` means the result is a pure function of its inputs ([660743675](https://github.com/whatwg/url/issues/531#issuecomment-660743675)). Once the ask was clarified to "let the *result* also be relative, not force resolution to absolute," he agreed the narrower version made sense but noted it requires the `URL` object model to represent every kind of relative-ness (scheme-relative, host-relative, path-relative, query-relative, fragment-relative) — currently only implicit in the parser's state machine, not the data model ([660783332](https://github.com/whatwg/url/issues/531#issuecomment-660783332)).
- **alwinb / karwa (both CONTRIBUTOR)**: the longest sub-thread (2020–2025) between a from-scratch formal reference implementation ([[concept-relative-url-api-proposals|`alwinb/url-specification`, later `URIReference`]]) and a WHATWG-adjacent implementer skeptical of both the scope and the evidence base for it — see [[concept-relative-url-api-proposals]] for the substance and [[concept-http-origin-form-vs-relative-reference|karwa's HTTP-routing counterexample]] for the strongest concrete technical objection raised in the thread.

## Why It's Stalled

No PR or Web IDL change has landed as of the last comment (2026, ongoing). The recurring blockers, consistent across five years of comments, are:
1. **No browser-context use case**, only cross-platform library/tooling pain — the WHATWG's stated bar for scope changes ([[url-goals]] frames the standard as reactive to concrete implementation needs, not speculative generality).
2. **Disagreement on whether a new type is needed** at all, versus extending `URL`/`new URL()`, versus just documenting the existing [[concept-fake-base-url-workaround|fake-base-URL trick]] as sufficient.
3. **No committed reference implementation + test suite** integrated into the standard itself, despite an independent one existing (alwinb's).

## See Also

- [[concept-fake-base-url-workaround]]
- [[concept-relative-url-api-proposals]]
- [[concept-uri-reference-vs-whatwg-url]]
- [[concept-http-origin-form-vs-relative-reference]]
- [[url-parsing-algorithm]]
- [[url-goals]]
- [[uri-reference-resolution]]
- [[uri-vs-whatwg-url]]

## Sources

- https://github.com/whatwg/url/issues/531
