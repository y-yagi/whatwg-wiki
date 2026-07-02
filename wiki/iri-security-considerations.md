---
spec: concept
tags: [concept, security]
updated: 2026-07-02
---

# IRI Security Considerations (RFC 3987 §8)

RFC 3987's security section extends [[uri-security-considerations|RFC 3986 §7's]] concerns with risks specific to a much larger character repertoire and bidirectional text.

## Visual Confusability / Homograph Attacks

Distinct Unicode code points can be visually indistinguishable or near-identical depending on font and script (Latin `A`, Greek capital Alpha `Α`, Cyrillic `А`), letting an attacker register or construct an IRI that a human reads as a trusted identifier while it is a different sequence of code points entirely. This is the internationalized-text analogue of [[uri-security-considerations|RFC 3986 §7.2's]] userinfo-confusability attack, but far larger in scope since it isn't limited to a single component.

## Bidi Override Spoofing

Because [[iri-bidi|bidirectional rendering]] can differ from logical storage order, an attacker could in principle construct a component whose *visual* rendering suggests a different, trusted identifier than its *logical* content — motivating the strict component-level bidi restrictions in §4 that forbid explicit override characters inside the IRI itself.

## Normalization Bypass

If a security-relevant comparison (e.g. an allowlist check) is performed before [[iri-normalization-comparison|NFC normalization]] or IDN processing, two IRIs that would normalize to the same value can be treated as different — or, more dangerously, two visually/semantically distinct IRIs that share a normalized form could be conflated. Comparisons intended to be security decisions must be normalized consistently and completely before use.

## Encoding Confusion

Because [[iri-to-uri-mapping|IRI→URI conversion]] and its reverse mandate UTF-8 specifically (see [[uri-to-iri-mapping]]'s "MUST NOT use any character encoding other than UTF-8" rule), a system that instead guesses or accepts a legacy encoding when decoding percent-escapes can misinterpret the resulting bytes — the IRI-scale version of [[uri-security-considerations|RFC 3986 §7.3's]] back-end transcoding risk.

## IDN Spoofing

[[iri-idna|IDNA-processed domain labels]] inherit all of the well-known internationalized-domain-name spoofing risk: two different Unicode domain labels can produce visually identical rendered glyphs while resolving to entirely different Punycode/ASCII labels and thus different hosts. Both IDNA generations acknowledge this openly rather than solving it: [[idna2008-security-considerations|IDNA2008 (RFC 5890 §4.4)]] states plainly that "there are no comprehensive technical solutions to the problems of confusable characters," and [[idna-registry-security|UTS #46]] pushes mitigation to registry-side bundling policy instead of the parsing algorithm.

## Relationship to WHATWG

The WHATWG URL Standard does not add IRI-specific mitigations beyond what [[uri-vs-whatwg-url|it already does for RFC 3986's security concerns]] — mandatory, uniform [[url-host-parsing|IDNA processing]] with no percent-encoding fallback for domains closes off the "ToASCII was optional" ambiguity RFC 3987 leaves open, but visual homograph confusability across scripts remains a live, unsolved concern on the modern web regardless of spec.

## See Also

- [[uri-security-considerations]]
- [[iri-bidi]]
- [[iri-normalization-comparison]]
- [[iri-idna]]
- [[uri-to-iri-mapping]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-8
