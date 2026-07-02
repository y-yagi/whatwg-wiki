---
spec: concept
tags: [concept]
updated: 2026-07-02
---

# RFC 3987 (IRI) vs. RFC 3986 (URI)

RFC 3987 is explicitly a **companion** to [[uri-generic-syntax|RFC 3986]], not a revision of it — every IRI production is derived from an RFC 3986 production, and every valid URI is trivially also a valid IRI (US-ASCII is a subset of Unicode).

## Side-by-Side

| Aspect | RFC 3986 (URI) | RFC 3987 (IRI) |
|---|---|---|
| Character repertoire | US-ASCII only | Unicode/UCS, via widened `iunreserved` ([[iri-syntax]]) |
| Relationship to legacy systems | N/A — is the legacy baseline | Deterministically maps to/from URI ([[iri-to-uri-mapping]], [[uri-to-iri-mapping]]) |
| Normalization | Optional comparison-time ladder (§6) | Same ladder plus mandatory NFC + IDN steps ([[iri-normalization-comparison]]) |
| Domain names | `reg-name`, uninterpreted text | `ireg-name`, with optional IDNA `ToASCII` ([[iri-idna]]) |
| Bidirectional text | Not addressed | Dedicated §4, logical-order storage + display rules ([[iri-bidi]]) |
| Security considerations | §7: userinfo confusability, back-end transcoding, IP-format ambiguity, semantic attacks | §8: adds homograph/visual confusability, bidi-override spoofing, IDN spoofing, encoding-guessing risk ([[iri-security-considerations]]) |
| Applicability | Universal — every scheme, every context | Conditional (§1.2): only where the surrounding protocol, transport, and target URI scheme all explicitly support it |

## What's Identical

`scheme`, `port`, IP-literal forms, and the generic/sub-delimiter vocabulary (`:`, `/`, `?`, `#`, `[`, `]`, `@`, `sub-delims`) carry over into IRI's grammar completely unchanged — internationalization only ever widens *unreserved* character positions, never delimiter or scheme syntax. See [[iri-syntax]].

## Why Two Documents

RFC 3987 could have widened RFC 3986's `URI` grammar directly, but chose not to, precisely so that existing URI-only software continues working unmodified against the mapped-down URI form of any IRI. This mirrors — and directly motivated — [[uri-vs-whatwg-url|WHATWG's later decision]] to collapse both documents into a single living parser rather than maintain the split; see [[url-goals]].

## See Also

- [[iri-overview]]
- [[uri-generic-syntax]]
- [[iri-syntax]]
- [[iri-to-uri-mapping]]
- [[iri-vs-whatwg-url]]
- [[uri-terminology]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987
- https://datatracker.ietf.org/doc/html/rfc3986
