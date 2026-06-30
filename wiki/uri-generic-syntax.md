---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Generic Syntax (RFC 3986)

RFC 3986 defines the generic syntax for **Uniform Resource Identifiers (URIs)** — a scheme-independent grammar that every URI scheme (http, ftp, mailto, urn, tel, ...) builds on. It predates and underlies the WHATWG URL Standard; see [[uri-vs-whatwg-url]] for how the two diverge.

## Top-Level Grammar

```
URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
hier-part   = "//" authority path-abempty
            / path-absolute
            / path-rootless
            / path-empty
```

A URI has five components: [[uri-scheme|scheme]], [[uri-authority|authority]] (optional), [[uri-path|path]] (always present, possibly empty), [[uri-query-fragment|query]] (optional), [[uri-query-fragment|fragment]] (optional).

## Example Breakdown

```
  foo://example.com:8042/over/there?name=ferret#nose
  \_/   \______________/\_________/ \_________/ \__/
   |           |              |          |         |
scheme     authority         path      query    fragment
```

## Design Considerations (§1.2)

- **Transcription**: URIs are designed to be portable across media — readable over the phone, written on a napkin, included in a printed document — which motivates the restricted character set ([[uri-reserved-characters]]).
- **Separating identification from interaction**: a URI only identifies a resource; it does not guarantee a dereferencing mechanism exists or will succeed.
- **Hierarchical identifiers**: the `/`, `?`, `#` delimiters impose a left-to-right hierarchy that enables [[uri-reference-resolution|relative reference resolution]] without scheme-specific knowledge.

## hier-part Forms

`hier-part` (and the analogous `relative-part` for relative references) is one of:

| Form | Shape | Example |
|------|-------|---------|
| `"//" authority path-abempty` | has authority | `http://example.com/path` |
| `path-absolute` | starts with `/`, no `//` | `urn:/local/path` (rare) |
| `path-rootless` | starts with a non-`/` segment | `mailto:user@example.com` |
| `path-empty` | zero characters | `about:` |

See [[uri-path]] for the full set of path forms (including the relative-reference-only `path-noscheme`).

## See Also

- [[uri-scheme]]
- [[uri-authority]]
- [[uri-path]]
- [[uri-query-fragment]]
- [[uri-reserved-characters]]
- [[uri-terminology]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-1
- https://datatracker.ietf.org/doc/html/rfc3986#section-3
- https://datatracker.ietf.org/doc/html/rfc3986#appendix-A
