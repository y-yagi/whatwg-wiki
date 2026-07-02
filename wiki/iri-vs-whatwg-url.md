---
spec: concept
tags: [concept, parser]
updated: 2026-07-02
---

# RFC 3987 (IRI) vs. the WHATWG URL Standard

[[url-goals|The WHATWG URL Standard's stated goals]] name RFC 3987 alongside RFC 3986 as a document it intends to obsolete. Where [[uri-vs-whatwg-url|the RFC 3986 comparison]] is about generic syntax and error recovery, this page is specifically about how WHATWG handles the *internationalization* problem RFC 3987 was written to solve — without keeping "IRI" as a separate concept at all.

## No Separate IRI Term or Algorithm

RFC 3987 defines IRI as a distinct protocol element with its own grammar ([[iri-syntax]]) and an explicit two-way mapping to/from URI ([[iri-to-uri-mapping]], [[uri-to-iri-mapping]]). WHATWG has no equivalent split: [[url-parsing-algorithm|the basic URL parser]] accepts non-ASCII input directly and produces a [[url-record|URL record]] in one pass — there is no separate "parse as IRI, then map to URI" step. Per [[uri-terminology]], WHATWG folds URI, URL, URN, *and* IRI into the single term "URL."

## Non-ASCII Handling Is Inline, Not a Post-Processing Mapping

- **Path/query/fragment**: WHATWG's [[url-percent-encoding|percent-encode sets]] UTF-8-encode and percent-encode non-ASCII code points as part of the state machine itself (Path, Query, Fragment states), achieving the same *outcome* as [[iri-to-uri-mapping|RFC 3987 §3.1 Step 2]] without a distinct algorithm invocation.
- **Host**: WHATWG's [[url-host-parsing|domain-to-ASCII step]] runs IDNA (UTS #46) **unconditionally** on every special-scheme host. RFC 3987 makes the equivalent IDNA step (`ToASCII`, [[iri-idna]]) **optional** — a producer may choose plain UTF-8 percent-encoding of the domain instead. WHATWG removes that choice: there is exactly one way a non-ASCII domain becomes valid.

## Normalization: Unconditional vs. Opt-In

RFC 3987's [[iri-normalization-comparison|comparison ladder]] (NFC requirement, IDN Nameprep, percent-encoding normalization) is something an application invokes when it wants to *compare* two IRIs. WHATWG performs the syntax- and scheme-based equivalents unconditionally as part of parsing, giving two [[url-serialization|serialized]] WHATWG URLs the RFC 3987 §5.3.2/§5.3.3-equivalent comparison guarantee "for free" via simple string equality — the same pattern noted for RFC 3986 in [[uri-normalization]].

## Bidi: No Dedicated Algorithm

RFC 3987 §4 defines explicit storage-vs-display rules and component-level bidi restrictions ([[iri-bidi]]) because IRI is a text-interchange format that must survive being embedded in RTL and LTR documents alike. WHATWG's URL Standard has no equivalent section — it defines a code-point-level state machine, not a text-presentation format, and leaves bidi rendering entirely to the surrounding UI layer (e.g. the browser address bar).

## Security: Same Underlying Risk, Different Mitigation Shape

[[iri-security-considerations|RFC 3987 §8]]'s homograph/IDN-spoofing concerns remain fully applicable to WHATWG URLs — mandatory IDNA processing removes the "which encoding was chosen" ambiguity but does not by itself prevent visually confusable Unicode domains from resolving to different hosts. This class of risk is a browser-UI concern (e.g. Punycode display heuristics) that lives outside both specs' normative text.

## See Also

- [[iri-overview]]
- [[iri-vs-uri]]
- [[uri-vs-whatwg-url]]
- [[url-goals]]
- [[url-host-parsing]]
- [[url-percent-encoding]]
- [[uri-normalization]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987
- https://url.spec.whatwg.org/#goals
