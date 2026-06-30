---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396 Path (§3.3)

```
path          = [ abs_path | opaque_part ]
path_segments = segment *( "/" segment )
segment       = *pchar *( ";" param )
param         = *pchar
pchar         = unreserved | escaped | ":" | "@" | "&" | "=" | "+" | "$" | ","
abs_path      = "/" path_segments
rel_path      = rel_segment [ abs_path ]
rel_segment   = 1*( unreserved | escaped | ";" | "@" | "&" | "=" | "+" | "$" | "," )
```

## Segments Carry Parameters

RFC 2396 bakes a **parameter sub-structure into every path segment**: `segment = *pchar *( ";" param )`, formalizing the `;`-separated "matrix parameter" convention (e.g. `/path;type=d`) directly in the generic grammar — something RFC 3986's `segment = *pchar` (no `;param` subdivision) drops, treating `;` as just another `sub-delim` with no special structural role baked into the grammar itself. See [[uri-path]].

## abs_path vs. rel_path vs. opaque_part

RFC 2396's path-related productions are fewer than RFC 3986's five mutually-exclusive forms ([[uri-path]]'s `path-abempty / path-absolute / path-noscheme / path-rootless / path-empty`):

| RFC 2396 | Shape | Roughly maps to RFC 3986 |
|---|---|---|
| `abs_path` | `/` + segments | `path-absolute` / `path-abempty` |
| `rel_path` | segment, no leading `/` | `path-noscheme` |
| `opaque_part` | scheme-specific, non-hierarchical | (no path equivalent — RFC 3986 keeps hierarchy uniform via `path-rootless`) |

The `opaque_part` case is the bigger structural difference: RFC 2396 lets an entire `absoluteURI` skip the hierarchical path model altogether (e.g. `mailto:user@host`, `urn:isbn:...`) via `opaque_part = uric_no_slash *uric`, whereas RFC 3986 keeps every URI's data after the scheme inside the unified `hier-part`/path grammar (using `path-rootless` for the same examples) so that reference resolution rules apply uniformly. See [[rfc2396-grammar]] and [[rfc2396-vs-rfc3986]].

## Dot Segments

RFC 2396 already recognizes `.` and `..` as relative-path indicators to be resolved away during [[rfc2396-reference-resolution|reference resolution]] (§5.2), the same mechanic RFC 3986 keeps as `remove_dot_segments` ([[uri-reference-resolution]]).

## Comparison with WHATWG

The WHATWG [[url-record|path]] model drops segment-level `;param` structure entirely (matrix parameters are not part of the URL Standard) and represents path as either a list of segments or a single opaque string, with dot-segment removal performed inline during parsing rather than as a discrete post-processing step. See [[uri-path]] for the fuller RFC 3986-vs-WHATWG comparison, which mostly carries over unchanged from RFC 2396's model.

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-reference-resolution]]
- [[uri-path]]
- [[url-record]]
- [[rfc2396-vs-rfc3986]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-3.3
- https://datatracker.ietf.org/doc/html/rfc2396#appendix-A
