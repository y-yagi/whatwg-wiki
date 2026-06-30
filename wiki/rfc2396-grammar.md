---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396 Top-Level Grammar

RFC 2396's generic syntax structure: `<scheme>://<authority><path>?<query>`, formalized through three top-level productions that together make up a **URI reference**.

## Core Productions (Appendix A)

```
URI-reference = [ absoluteURI | relativeURI ] [ "#" fragment ]
absoluteURI   = scheme ":" ( hier_part | opaque_part )
relativeURI   = ( net_path | abs_path | rel_path ) [ "?" query ]

hier_part     = ( net_path | abs_path ) [ "?" query ]
opaque_part   = uric_no_slash *uric

net_path      = "//" authority [ abs_path ]
abs_path      = "/"  path_segments
rel_path      = rel_segment [ abs_path ]
```

## absoluteURI: the URL/URN Split

`absoluteURI` branches into `hier_part` (the "URL-like" shape: optional `//authority` followed by a slash-delimited path — what the web thinks of as a URL) or `opaque_part` (the "URN-like" shape: scheme-specific data with no hierarchical structure at all, e.g. `mailto:user@host` or `urn:isbn:0451450523`). This structural fork is the formalization RFC 3986 later removed — see [[rfc2396-vs-rfc3986]] and [[uri-terminology]].

## relativeURI: No Scheme Allowed

A `relativeURI` is recognized purely by the **absence of a scheme**: it's one of `net_path` (starts with `//`, has authority), `abs_path` (starts with `/`, no authority), or `rel_path` (starts with a relative segment, no leading `/`), optionally followed by `?query`. This is structurally close to RFC 3986's `relative-part`, but RFC 2396 does not yet have RFC 3986's `path-noscheme` naming or its mutual-exclusion treatment of all five path forms in one production — see [[rfc2396-path]].

## URI-reference: the Common-Usage Wrapper

`URI-reference` allows either form (absolute or relative) plus an optional `#fragment` — "the common usage of a resource identifier" that most specs and applications actually accept as input. RFC 2396 explicitly notes that strictly speaking "the URI" excludes its own fragment; the fragment is appended only at the `URI-reference` level, just as in RFC 3986's `URI-reference = URI / relative-ref` (see [[uri-reference-resolution]]).

## See Also

- [[rfc2396-overview]]
- [[rfc2396-scheme-authority]]
- [[rfc2396-path]]
- [[rfc2396-query-fragment]]
- [[rfc2396-vs-rfc3986]]
- [[uri-generic-syntax]]
- [[uri-terminology]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-3
- https://datatracker.ietf.org/doc/html/rfc2396#appendix-A
