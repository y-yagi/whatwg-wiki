---
spec: concept
tags: [concept, algorithm, parser]
updated: 2026-07-01
---

# URI Reference Resolution (RFC 3986 §4–5)

Defines how a **relative reference** (`../g`, `?y`, `#s`) combines with a **base URI** to produce a **target URI** — the algorithmic core of RFC 3986, and the direct ancestor of the WHATWG URL Standard's [[url-parsing-algorithm|base-URL parsing]].

## §4: Usage Forms

```
URI-reference = URI / relative-ref
relative-ref  = relative-part [ "?" query ] [ "#" fragment ]
relative-part = "//" authority path-abempty
              / path-absolute
              / path-noscheme
              / path-empty
absolute-URI  = scheme ":" hier-part [ "?" query ]   ; no fragment
```

- **URI reference**: either a full URI or a relative-ref — the general term for "thing that appears where a URI is expected."
- **Absolute URI**: a full URI with no fragment; used where a fragment would be meaningless (e.g. as a [[uri-authority|base URI]] itself).
- **Same-document reference** (§4.4): fragment-only reference, resolves within the current document.
- **Suffix reference** (§4.5): informal forms like `www.w3.org/Addressing/` that omit the scheme and rely on the application to guess it (e.g. by heuristic). Explicitly discouraged for any long-term or interoperable use.

## §5.1: Establishing a Base URI

Four-tier precedence for determining the base URI against which a relative reference resolves:
1. **Base URI embedded in content** (e.g., an explicit base declaration within the document — the ancestor of HTML's `<base href>`).
2. **Encapsulating entity** (e.g., the URI of a multipart MIME body part's envelope).
3. **URI used to retrieve the entity** (the URL the document was fetched from).
4. **Default base URI**: application-dependent fallback when none of the above apply.

## §5.2.2: Transform References (the core algorithm)

Pseudocode mapping reference `R` to target `T`, given base `Base`:

- If `R.scheme` is defined: `T.scheme = R.scheme`; `T.authority = R.authority`; `T.path = remove_dot_segments(R.path)`; `T.query = R.query`.
- Else if `R.authority` is defined: `T.authority = R.authority`; `T.path = remove_dot_segments(R.path)`; `T.query = R.query`; `T.scheme = Base.scheme`.
- Else if `R.path` is empty: `T.path = Base.path`; `T.query = R.query` if defined, else `Base.query`.
- Else if `R.path` starts with `/`: `T.path = remove_dot_segments(R.path)`.
- Else: `T.path = remove_dot_segments(merge(Base, R.path))`.
- In all non-scheme-defined branches: `T.authority = Base.authority`; `T.scheme = Base.scheme`.
- Always: `T.fragment = R.fragment`.

## §5.2.3: Merge Paths

When `R.path` is relative and must be merged with the base's path:
- If `Base` has authority and an empty path: result is `"/"` + `R.path`.
- Otherwise: result is everything in `Base.path` up to (and including) the last `/`, concatenated with `R.path`.

## §5.2.4: Remove Dot Segments

Buffer-based algorithm that processes a path left to right, popping a parent segment off the output buffer for each `..` encountered, and dropping bare `.` segments — the same mechanic the WHATWG URL Standard's Path state performs inline. See [[uri-path]] for the segment grammar this operates on.

## §5.3: Component Recomposition

Pseudocode reassembling `T.scheme`, `T.authority`, `T.path`, `T.query`, `T.fragment` back into a URI string — the inverse of parsing, analogous to the WHATWG [[url-serialization|URL serializer]].

## §5.4: Examples

**Normal (§5.4.1)** — base `http://a/b/c/d;p?q`:

| Reference | Result |
|-----------|--------|
| `g` | `http://a/b/c/g` |
| `./g` | `http://a/b/c/g` |
| `g/` | `http://a/b/c/g/` |
| `/g` | `http://a/g` |
| `//g` | `http://g` |
| `?y` | `http://a/b/c/d;p?y` |
| `g?y` | `http://a/b/c/g?y` |
| `#s` | `http://a/b/c/d;p?q#s` |
| `../g` | `http://a/b/g` |
| `../../g` | `http://a/g` |
| `` (empty) | `http://a/b/c/d;p?q` |

**Abnormal (§5.4.2)**: excess `../` beyond the root collapses harmlessly (`../../../g` → `http://a/g`, same as `../../g`); dot-segments in the query/fragment are *not* removed (`/./g` differs from `g?y/./x` because the latter's `.` is inside the query); and a reference whose first path segment looks like a scheme (`http:g`) is, per a "loophole" in the original RFC 2396, ambiguous — RFC 3986 says strict parsers MUST treat it as `T.scheme = "http"` with the rest as an opaque path, while many deployed parsers historically treated it relative to the base for backward compatibility.

## Comparison with WHATWG

The WHATWG URL Standard's "parse relative" / [[url-parsing-algorithm|basic URL parser with a base]] is a direct, more deterministic descendant of this algorithm: instead of branching on which components are "defined" in the abstract, it runs a single state machine over the input code points, copying fields from the base URL when the input doesn't override them (mirroring §5.2.2's branches almost one-to-one for the "no scheme" cases). Crucially, WHATWG resolves RFC 3986's `http:g` ambiguity by specification — special-scheme URLs never fall into the rootless/opaque-path branch.

## See Also

- [[uri-generic-syntax]]
- [[uri-path]]
- [[uri-normalization]]
- [[url-parsing-algorithm]]
- [[url-concepts]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-4
- https://datatracker.ietf.org/doc/html/rfc3986#section-5
