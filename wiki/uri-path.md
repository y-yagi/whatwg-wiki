---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Path (RFC 3986 §3.3)

The **path** component contains data, usually organized in hierarchical form, that identifies a resource within the scope of the [[uri-scheme|scheme]] and (if present) [[uri-authority|authority]].

## Grammar

```
path          = path-abempty    ; begins with "/" or is empty
              / path-absolute   ; begins with "/" but not "//"
              / path-noscheme   ; begins with a non-colon segment (relative-ref only)
              / path-rootless   ; begins with a segment (URI only, has scheme)
              / path-empty      ; zero characters

segment       = *pchar
segment-nz    = 1*pchar
segment-nz-nc = 1*( unreserved / pct-encoded / sub-delims / "@" )  ; no ":"
pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
```

## The Five Forms

| Form | Used when | Constraint |
|------|-----------|------------|
| `path-abempty` | authority present | empty, or starts with `/` |
| `path-absolute` | no authority, URI looks "rooted" | starts with `/`, first segment isn't `//` |
| `path-rootless` | no authority, has a scheme | starts with a segment, no leading `/` (e.g. `mailto:user@host`) |
| `path-noscheme` | no authority, **relative reference** | starts with a segment that contains no `:` (avoids ambiguity with a scheme) |
| `path-empty` | — | zero characters |

The forms are mutually exclusive by construction so the grammar never has to choose between "is this a scheme or the first path segment."

## Dot Segments

`.` and `..` segments are **relative path indicators**, not literal path data. They are eliminated by the [[uri-reference-resolution|remove_dot_segments algorithm]] (§5.2.4) during reference resolution, and SHOULD be removed before a path is used as an identifier (this is also a [[uri-normalization|normalization]] step).

## Comparison with WHATWG

The WHATWG URL Standard's [[url-record|path]] field collapses these five grammar forms into two runtime representations: a **list of path segments** (special URLs, and non-special URLs with authority) or a single **opaque path** string (non-special URLs without authority, e.g. `data:`). Dot-segment removal happens inline as part of the [[url-parsing-algorithm|Path state]] rather than as a separate post-processing algorithm, and single-/double-dot detection is extended to percent-encoded variants (`%2e`, `.%2e`, etc.) that RFC 3986 does not special-case. See [[uri-vs-whatwg-url]].

## See Also

- [[uri-generic-syntax]]
- [[uri-reference-resolution]]
- [[uri-reserved-characters]]
- [[url-record]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-3.3
