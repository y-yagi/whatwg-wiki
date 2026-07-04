---
spec: concept
tags: [concept]
updated: 2026-07-04
---

# HTTP Origin-Form Request-Targets Are Not Relative References

A specific technical correction raised by karwa (CONTRIBUTOR) in [whatwg/url#531](https://github.com/whatwg/url/issues/531#issuecomment-1029786172) against the most commonly cited motivating use case for relative-URL support (HTTP routing): a value like `/foo?bar` used as an HTTP request target is **not** an [[uri-reference-resolution|RFC 3986 relative reference]], even though it looks like one.

## The Distinction

- A **relative reference**, per RFC 3986's [[uri-reference-resolution|transform-references algorithm]], is resolved against a base URI component-by-component (scheme/authority/path/query each individually inherited or overridden; dot-segments removed; paths merged).
- An HTTP **origin-form request-target**, per [RFC 7230 §5.3 / the HTTP effective-request-URI construction](https://httpwg.org/specs/rfc7230.html#effective.request.uri), is combined with the connection's scheme/host/port by **plain string concatenation** — not RFC 3986 reference resolution.

karwa's illustrative case: given the origin-form request target `//foo/bar?baz`, RFC 3986 relative-reference resolution would parse `//foo` as an authority (making `foo` a *hostname*) with path `/bar`, whereas the HTTP effective-request-URI construction treats the whole `//foo/bar?baz` as a literal path-and-query to concatenate after the connection's already-known authority — producing a completely different result ([1029786172](https://github.com/whatwg/url/issues/531#issuecomment-1029786172)).

## Why This Matters for the `#531` Debate

Several participants motivated wanting relative-URL support in the WHATWG standard specifically by pointing at HTTP request-routing code (constructing or matching paths like `/api/users/:id`). karwa's point is that this motivation is founded on a category error: routing logic should be built on `pathname`/`search` string manipulation (already fully supported via `URL`'s existing setters) or on a purpose-built router/pattern type (see [[urlpattern-overview|`URLPattern`]], mentioned elsewhere in the thread as the more appropriate adjacent API), not on RFC 3986 relative-reference resolution semantics. Conflating the two would import WHATWG's [[url-parser-states|special-URL host/authority disambiguation rules]] into a context (HTTP request-target parsing) where they don't apply and never did.

This objection was also independently raised on the related [nodejs/node#12682](https://github.com/nodejs/node/issues/12682#issuecomment-399149181) thread and, per karwa, was "positively received but ultimately appears to have been ignored" there too.

## See Also

- [[concept-url-531-relative-url-debate]]
- [[concept-uri-reference-vs-whatwg-url]]
- [[uri-reference-resolution]]
- [[url-parser-states]]
- [[uri-authority]]

## Sources

- https://github.com/whatwg/url/issues/531#issuecomment-1029786172
- https://httpwg.org/specs/rfc7230.html#effective.request.uri
