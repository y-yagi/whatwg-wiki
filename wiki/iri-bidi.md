---
spec: concept
tags: [concept]
updated: 2026-07-02
---

# IRI Bidirectional (Bidi) Text Handling (RFC 3987 §4)

Because IRIs can contain right-to-left scripts (Arabic, Hebrew), RFC 3987 dedicates a full section to preventing ambiguity between how an IRI is *stored* and how it is *displayed* — a concern that has no counterpart in ASCII-only [[uri-generic-syntax|RFC 3986]].

## Storage vs. Presentation

- **Storage/processing order is always logical order** — the same left-to-right sequence of characters an IRI would have if every character were ASCII, regardless of script directionality. All of [[iri-syntax|IRI's ABNF]] is defined over this logical-order sequence.
- **Visual rendering** applies the Unicode Bidirectional Algorithm (UBA), optionally wrapped in explicit directional embedding (`U+202A` LRE ... `U+202C` PDF) so a right-to-left IRI displays correctly inside a left-to-right document, or vice versa.

## Bidi Format Characters Are Forbidden Inside IRIs

LRM, RLM, LRE, RLE, LRO, RLO, and PDF (the Unicode bidirectional control characters) are **excluded from IRI syntax entirely** — they may be used *around* an IRI for display purposes but never *within* one. This prevents an IRI's meaning from silently changing based on invisible directional overrides.

## Component-Level Restrictions

Within each syntactic component (`iuserinfo`, `ireg-name`, path segment, `iquery`, `ifragment`), independently:

1. The component **should not mix** right-to-left and left-to-right characters.
2. A component containing right-to-left characters **should both start and end** with a right-to-left character (not a digit or neutral character), to avoid the reading-order ambiguity Unicode's bidi algorithm otherwise introduces at the boundary.

A component that can't satisfy these restrictions must fall back to the URI form via [[iri-to-uri-mapping]] (percent-encoding), since percent-encoded octets carry no bidi directionality of their own.

## Worked Ambiguity Example

`GH1/2IJ` mixing RTL letters (`GH`, `IJ`) with digits and `/` can be visually rendered so `1/2` reads as the *fraction* one-half rather than as two separate path segments — exactly the class of confusion the component-level rules above are designed to rule out.

## Domain Example

Logical (storage) order: `http://ab.CDEFGH.ij/kl/mn/op.html` (uppercase = RTL characters) renders visually as `http://ab.HGFEDC.ij/kl/mn/op.html` — the RTL domain label displays reversed relative to its logical storage order, which is exactly why comparison/processing must always operate on the logical form, never the rendered one.

## See Also

- [[iri-syntax]]
- [[iri-security-considerations]]
- [[uri-to-iri-mapping]]
- [[iri-to-uri-mapping]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-4
