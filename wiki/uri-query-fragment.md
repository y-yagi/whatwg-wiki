---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Query and Fragment (RFC 3986 §3.4–3.5)

## Query (§3.4)

```
query = *( pchar / "/" / "?" )
```

The query component contains non-hierarchical data that, along with the [[uri-path|path]], identifies a resource within the scope of the [[uri-scheme|scheme]] and [[uri-authority|authority]]. Its internal syntax (e.g. `key=value&key2=value2`) is **not defined by RFC 3986** — that structure is a convention established by individual schemes/applications (later standardized for the web as `application/x-www-form-urlencoded`).

`/` and `?` are explicitly allowed unescaped inside a query even though they're [[uri-reserved-characters|reserved]] elsewhere, because the query has already been delimited by `?` and terminates only at `#` or end-of-URI.

## Fragment (§3.5)

```
fragment = *( pchar / "/" / "?" )
```

Same grammar as query. The fragment identifies a secondary resource by reference to a primary resource — its semantics are defined by the **dereferenced media type**, not by the URI scheme. Critically, RFC 3986 states the fragment is processed **only by the user agent**, after retrieval; it is "not used in the scheme-specific processing of a URI reference" and (with rare exceptions) is not sent to the server.

## Same-Document Reference (§4.4)

A URI reference that is fragment-only (or resolves to the same base URI with only the fragment differing) is a **same-document reference** — it identifies a secondary resource without requiring a new retrieval.

## Comparison with WHATWG

The WHATWG URL Standard preserves the "fragment is client-side only, not sent to network layer" principle, and likewise leaves query string structure unspecified (the `key=value&...` convention lives in [[url-percent-encoding|application/x-www-form-urlencoded]] and `URLSearchParams`, not the [[url-parsing-algorithm|basic URL parser]] itself). Where they diverge: WHATWG distinguishes a **special-query percent-encode set** for special schemes (extra-encodes `'`) and treats an empty query/fragment (present but zero-length, e.g. `https://example.com/?`) as distinct from a null/absent one — a distinction RFC 3986's ABNF (`*( pchar / "/" / "?" )` allows zero repetitions either way) doesn't surface as cleanly.

## See Also

- [[uri-generic-syntax]]
- [[uri-reserved-characters]]
- [[url-percent-encoding]]
- [[url-api]]
- [[uri-vs-whatwg-url]]
- [[rfc2396-query-fragment]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-3.4
- https://datatracker.ietf.org/doc/html/rfc3986#section-3.5
- https://datatracker.ietf.org/doc/html/rfc3986#section-4.4
