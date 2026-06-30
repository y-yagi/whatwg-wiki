---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396 Query and Fragment (§3.4, §4.1)

## Query (§3.4)

```
query = *uric
uric  = reserved | unreserved | escaped
```

The query component is "*uric* — i.e., it may contain *any* reserved, unreserved, or escaped character. RFC 2396 explicitly leaves the internal structure (`key=value&key2=value2`) undefined, deferring it to scheme/application convention — the same deferral [[uri-query-fragment|RFC 3986 §3.4]] keeps. RFC 3986 narrows the grammar slightly to `*( pchar / "/" / "?" )`, which is equivalent in practice (both allow unreserved, percent-encoded, and the sub-delim set, plus `/` and `?`) but expressed as an explicit pchar-based set rather than the broader `uric` catch-all.

## Fragment (§4.1)

```
fragment = *uric
```

Notably, RFC 2396 defines `fragment` in **§4 ("URI References")** rather than alongside the other URI components in §3 — reflecting that the fragment is structurally outside the URI itself, attached only at the `URI-reference` level (`URI-reference = [ absoluteURI | relativeURI ] [ "#" fragment ]`, see [[rfc2396-grammar]]). RFC 3986 instead promotes fragment into the main `URI` production (`URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`) while keeping the same "client-side only" semantics.

## Client-Side-Only Semantics

RFC 2396 already establishes that the fragment "is not considered part of the URI" for retrieval purposes and is interpreted only by the user agent after dereferencing — the same principle RFC 3986 §3.5 keeps verbatim ([[uri-query-fragment]]).

## Comparison with WHATWG

The WHATWG URL Standard keeps query/fragment as free-form trailing components with scheme-agnostic grammar and the same client-side-only fragment rule, but layers on a dedicated **special-query percent-encode set** and treats present-but-empty query/fragment (`?`, `#`) as distinct from absent — see [[uri-query-fragment]] for the fuller RFC 3986-vs-WHATWG comparison, which applies unchanged relative to RFC 2396.

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-reserved-characters]]
- [[uri-query-fragment]]
- [[url-percent-encoding]]
- [[rfc2396-vs-rfc3986]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-3.4
- https://datatracker.ietf.org/doc/html/rfc2396#section-4.1
