---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Scheme (RFC 3986 §3.1)

The **scheme** identifies which set of rules governs the rest of the URI. It is the only component the generic syntax requires (URI references without a scheme are [[uri-reference-resolution|relative references]]).

## Grammar

```
scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
```

Must start with a letter; remaining characters may be letters, digits, `+`, `-`, `.`.

## Key Rules

- **Case-insensitive**: `HTTP`, `Http`, and `http` are equivalent schemes.
- **Canonical form is lowercase**: producers should generate lowercase scheme names; consumers should normalize to lowercase for comparison (see [[uri-normalization]]).
- The scheme determines how the rest of the URI — especially the [[uri-authority|authority]] and [[uri-path|path]] — should be interpreted, but the generic syntax itself is scheme-agnostic.

## Comparison with WHATWG

The WHATWG URL Standard keeps the same ABNF shape for scheme but adds the notion of a **special scheme** (`ftp`, `file`, `http`, `https`, `ws`, `wss`) with bespoke parsing behavior baked into the parser itself — something RFC 3986 leaves entirely to scheme-specific specs. See [[url-record]] (the "is special" property) and [[uri-vs-whatwg-url]].

## See Also

- [[uri-generic-syntax]]
- [[uri-authority]]
- [[uri-vs-whatwg-url]]
- [[url-record]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
