---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-02
---

# IRI Normalization and Comparison (RFC 3987 §5)

RFC 3987 layers IRI-specific concerns on top of [[uri-normalization|RFC 3986's comparison ladder]] (§6), adding Unicode normalization and IDN handling to each rung.

## §5.3.1: Simple String Comparison

Character-for-character equality after both IRIs are put in the same encoding form. Critically, RFC 3987 states this comparison **must NOT** map either IRI down to a URI first — percent-encoding one side and not the other (or both, inconsistently) would create false equivalences between IRIs that are not actually the same string. Cheapest, most false-negative-prone level, same as RFC 3986 §6.2.1.

## §5.3.2: Syntax-Based Normalization

- **Case normalization**: lowercase the scheme and (ASCII-only) host labels; uppercase hex digits in percent-encoded triplets — identical in spirit to [[uri-normalization|RFC 3986's version]].
- **Character normalization**: IRIs **MUST** already be in Unicode Normalization Form C (NFC) for comparison purposes (mirroring the mandatory NFC step in [[iri-to-uri-mapping]]); NFKC is *recommended, not required,* at IRI-creation time for producers who want maximal interoperability, since NFKC folds compatibility variants (e.g. full-width vs. half-width forms) that NFC leaves distinct.
- **Percent-encoding normalization**: decode percent-encoded octets that correspond to [[iri-syntax|`iunreserved`]] characters, same rationale as RFC 3986.
- **Path segment normalization**: apply [[uri-reference-resolution|`remove_dot_segments`]], unchanged from RFC 3986.

## §5.3.3: Scheme-Based Normalization

Adds IDN-specific normalization on top of RFC 3986's scheme-based rules (default port elision, empty-path-as-`/`):
- Validate domain labels via `ToASCII` with `UseSTD3ASCIIRules` and `AllowUnassigned` per [[iri-idna]].
- Apply **Nameprep** (RFC 3491) character normalization to IDN labels.
- Optionally treat a Punycode (`xn--`) label and its equivalent percent-encoded UTF-8 form as comparison-equivalent.

## §5.3.4: Protocol-Based Normalization

Same aggressive, resource-interaction-dependent techniques as [[uri-normalization|RFC 3986 §6.2.4]] (e.g. web crawlers treating trailing-slash variants as equivalent after observing identical redirect targets) — RFC 3987 adds no IRI-specific content here.

## Relationship to WHATWG

WHATWG's [[url-parsing-algorithm|basic URL parser]] performs the syntax- and scheme-based rungs of this ladder unconditionally during parsing (see [[uri-normalization]]'s WHATWG comparison), and always applies [[url-host-parsing|IDNA]] to special-scheme hosts — collapsing RFC 3987's optional §5.3.2/§5.3.3 steps into mandatory parser behavior, the same pattern WHATWG applies to RFC 3986.

## See Also

- [[uri-normalization]]
- [[iri-idna]]
- [[iri-to-uri-mapping]]
- [[uri-reference-resolution]]
- [[iri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-5
