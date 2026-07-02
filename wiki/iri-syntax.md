---
spec: concept
tags: [concept, parser]
updated: 2026-07-02
---

# IRI Syntax (RFC 3987 §2)

RFC 3987 defines IRI grammar by taking [[uri-generic-syntax|RFC 3986's ABNF]] and re-deriving every production that could contain non-ASCII text under an `i`-prefixed name, widening exactly one rule: `unreserved` becomes `iunreserved`.

## Top-Level Grammar

```
IRI           = scheme ":" ihier-part [ "?" iquery ] [ "#" ifragment ]
ihier-part    = "//" iauthority ipath-abempty
              / ipath-absolute / ipath-rootless / ipath-empty
iauthority    = [ iuserinfo "@" ] ihost [ ":" port ]
ipath         = ipath-abempty / ipath-absolute / ipath-noscheme
              / ipath-rootless / ipath-empty
ipchar        = iunreserved / pct-encoded / sub-delims / ":" / "@"
iquery        = *( ipchar / iprivate / "/" / "?" )
ifragment     = *( ipchar / "/" / "?" )
```

`scheme`, `port`, `IP-literal`/`IPv4address` (inside `ihost`), and `pct-encoded` are **byte-for-byte identical** to RFC 3986 — they stay US-ASCII because scheme names and ports are protocol-critical, not human text.

## The Widened Character Classes

- **`iunreserved`** = `ALPHA / DIGIT / "-" / "." / "_" / "~" / ucschar` — everything RFC 3986's `unreserved` allows, plus `ucschar`.
- **`ucschar`** — Unicode/UCS code points outside the ASCII range that are considered safe, printable, and non-private-use: `U+00A0–D7FF`, `U+F900–FDCF`, `U+FDF0–FFEF`, and the equivalent ranges in planes 1–14 (`U+10000–1FFFD` through `U+E0000–EFFFD`, minus each plane's final two "non-character" code points).
- **`iprivate`** = `U+E000–F8FF`, `U+F0000–FFFFD`, `U+100000–10FFFD` — Unicode private-use areas, permitted **only** in `iquery` (and, via `iprivate`, nowhere else), since query strings are often used as an opaque escape hatch by applications.

Surrogate code points, unassigned code points, and control characters are excluded from `ucschar` — they are not valid inside an IRI regardless of position.

## What Stays Narrow

`ireg-name` — the registered-name form of `ihost` — is `*( iunreserved / pct-encoded / sub-delims )`, so it can contain Unicode text directly, but IRI does **not** define how that text maps to a resolvable domain name; that's deferred to IDNA (see [[iri-idna]]). Reserved/generic delimiters (`:`, `/`, `?`, `#`, `[`, `]`, `@`, and `sub-delims`) remain ASCII-only in every production — internationalization only ever widens *unreserved* character positions.

## See Also

- [[iri-overview]]
- [[iri-idna]]
- [[uri-generic-syntax]]
- [[uri-reserved-characters]]
- [[url-percent-encoding]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-2
