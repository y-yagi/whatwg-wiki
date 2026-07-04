---
spec: concept
tags: [concept, interface]
updated: 2026-07-04
---

# URLPattern vs. the URL API

`URLPattern` and [[url-api|`URL`/`URLSearchParams`]] are complementary, not competing: `URL` parses and serializes one concrete URL; `URLPattern` matches many candidate URLs against a reusable template. They share the same eight-component model ([[url-record]]) and the same canonicalization primitives ([[url-percent-encoding]], [[url-host-parsing]]), but differ in purpose and shape.

| | `URL` | `URLPattern` |
|---|---|---|
| Input | One concrete URL string | A **pattern** string or `URLPatternInit`, containing wildcards/named groups/regex groups |
| Output | A parsed, serializable `URL` object (`href`, `origin`, live `searchParams`, ...) | A boolean (`test()`) or a match/capture result (`exec()`) — never a serializable URL |
| Mutability | Settable attributes that re-run parsing per component | Read-only pattern-string attributes (`protocol`, `pathname`, ...); immutable once constructed |
| Canonicalizes | The URL being parsed | The **literal** portions of the pattern text (see [[urlpattern-canonicalization]]) — using the same callbacks `URL` uses |
| Typical use | Building/normalizing/navigating to a URL | Routing: "does this incoming URL match one of my registered routes, and if so what are `:id` etc.?" (service workers, client-side routers, HTTP header field matching) |

## Where They Meet

`URLPattern`'s canonicalization step is defined in terms of the URL Standard's own encoding callbacks (see [[urlpattern-canonicalization]]) — it does not reimplement percent-encoding or IDNA processing, it calls into the same algorithms [[url-parsing-algorithm|the basic URL parser]] uses. Its `baseURL` handling ([[urlpattern-base-url]]) likewise reuses ordinary relative-URL path resolution. In that sense `URLPattern` is best understood as *the URL Standard's grammar, generalized to admit wildcards and captures* — every concrete URL is trivially also a valid, fully-literal `URLPattern` input with no groups at all.

## What URLPattern Deliberately Doesn't Do

- It does not build or return a new URL — there is no `URLPattern` equivalent of `URL`'s `href` or `toString()` producing a navigable address.
- It does not offer `URLSearchParams`-style structured query access; `search` is matched/captured as an opaque pattern component like any other, not decomposed into name/value pairs.
- It has no live/mutable state after construction — contrast with `URL`'s settable attributes and live `searchParams` (see [[url-api]]).

## See Also

- [[url-api]]
- [[url-record]]
- [[urlpattern-overview]]
- [[urlpattern-canonicalization]]
- [[urlpattern-base-url]]

## Sources

- https://urlpattern.spec.whatwg.org/
- https://url.spec.whatwg.org/#api
