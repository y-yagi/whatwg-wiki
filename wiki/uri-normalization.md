---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-01
---

# URI Normalization and Comparison (RFC 3986 §6)

RFC 3986 defines a ladder of normalization techniques used to decide whether two different URI strings identify the same resource, without dereferencing either of them.

## §6.1: Equivalence

Two URIs are **equivalent** if they identify the same resource — but since this can't be determined in general without dereferencing, RFC 3986 instead defines syntax-level tests that are *sufficient but not necessary*: syntactically equivalent URIs are guaranteed equivalent, but two syntactically different URIs might still identify the same resource.

## §6.2: Comparison Ladder

Each level below is strictly more aggressive (and more likely to produce false negatives if applied incorrectly) than the one before it.

### §6.2.1: Simple String Comparison

Direct octet-by-octet comparison after the URIs are in identical case and encoding form. Fast and safe, but produces many false negatives (e.g. `example.com` vs `EXAMPLE.com` compare unequal even though hosts are case-insensitive).

### §6.2.2: Syntax-Based Normalization

Scheme-independent transformations that don't require knowledge of the specific scheme:
- **Case normalization**: lowercase the [[uri-scheme|scheme]] and [[uri-host|host]]; uppercase hex digits in [[uri-reserved-characters|percent-encoded]] triplets (`%3a` → `%3A`).
- **Percent-encoding normalization**: decode any percent-encoded octet that corresponds to an [[uri-reserved-characters|unreserved]] character (e.g. `%7E` → `~`), since encoding it added no value.
- **Path segment normalization**: apply [[uri-reference-resolution|remove_dot_segments]] even outside of reference resolution, since a path with `.`/`..` segments that wasn't produced via relative resolution is still normalizable the same way.

### §6.2.3: Scheme-Based Normalization

Requires scheme-specific knowledge:
- **Default port elision**: `http://example.com:80/` normalizes to `http://example.com/` because 80 is http's default port.
- **Empty path normalization**: `http://example.com` and `http://example.com/` are equivalent for schemes that define an empty path as equivalent to `/`.
- Other scheme-defined equivalences (e.g. trailing-dot DNS names).

### §6.2.4: Protocol-Based Normalization

The most aggressive level: normalization that requires actually interacting with the protocol/resource (e.g. following a redirect to find a canonical form, or comparing resources by content). RFC 3986 notes this can produce **false positives** — two syntactically different URIs being treated as equivalent when they aren't always guaranteed to be — and should only be used when an application controls and trusts the dereferencing process.

## Comparison with WHATWG

The WHATWG URL Standard performs §6.2.1–§6.2.3-equivalent normalization unconditionally as part of parsing rather than as an optional post-hoc comparison step: the [[url-parsing-algorithm|basic URL parser]] always lowercases scheme/host, always strips default ports (see [[url-record]]'s port-nullification rule), and always removes dot-segments during path construction. This means two WHATWG `URL` objects can be compared with simple string equality on their [[url-serialization|serialization]] and get RFC 3986 §6.2.3-level correctness "for free" — see [[url-concepts]]'s URL equivalence note. WHATWG does not define an equivalent of §6.2.4 protocol-based normalization.

## See Also

- [[uri-reserved-characters]]
- [[uri-reference-resolution]]
- [[uri-host]]
- [[url-concepts]]
- [[url-serialization]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-6
