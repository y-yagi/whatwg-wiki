---
spec: url
tags: [concept]
updated: 2026-07-02
---

# Goals of the URL Standard

The URL Standard's introduction states its objectives explicitly, framing the spec as a deliberate replacement for the IETF URI/IRI RFCs rather than a mere implementation guide for them.

## The Four Goals

1. **Align the RFCs with contemporary implementations, then obsolete them.** The stated goal is to "align RFC 3986 and RFC 3987 with contemporary implementations and obsolete the RFCs in the process." This targets both [[uri-generic-syntax|RFC 3986]] (URI) *and* [[iri-overview|RFC 3987]] (IRI, Internationalized Resource Identifiers) — RFC 3987's scope (non-ASCII characters in URIs) is what WHATWG's IDNA-based [[url-host-parsing|host processing]] and [[url-percent-encoding|UTF-8 percent-encoding]] absorb natively into the single parser; see [[iri-vs-whatwg-url]] for the detailed mapping. Motivating gaps called out by name: inconsistent handling of spaces, "illegal" code points, query string encoding, equality, and canonicalization — none uniformly defined across the legacy RFCs. The spec frames the ambition directly: **"URL parsing needs to become as solid as HTML parsing."**
2. **Collapse URI/IRI/URL/URN terminology into one term: URL.** Rather than preserve [[uri-terminology|RFC 3986's URI/URL/URN taxonomy]] (or add [[iri-overview|IRI]] as a fourth), the standard uses "URL" for everything, on pragmatic grounds: the terms confuse people in practice, implementations already run one algorithm regardless of which term applies, and — in the spec's own words — "URL also easily wins the search result popularity contest."
3. **Supersede RFC 6454 for origin.** The standard defines [[url-concepts|origin]] itself rather than deferring to RFC 6454 ("The Web Origin Concept"), giving origin a home inside the same living document as the parser that produces the URLs origins are computed from.
4. **Specify and extend the JavaScript URL API.** Beyond documenting the existing `URL`/`URLSearchParams` behavior, the standard adds facilities such as constructing a [[url-api|`URL` object]] without needing an HTML element — enabling URL handling in contexts like workers that have no DOM.

## Idempotence Guarantee

A goal not listed as a numbered bullet but stated as a hard requirement: parsing must be **idempotent**. Parse → serialize → parse → serialize must stabilize after the first round trip — re-parsing a serialized URL always reproduces the same record, and re-serializing it always reproduces the same string. See [[url-idempotence]].

## Why This Framing Matters

Every one of these goals is a reaction to the RFCs' declarative-grammar approach failing to describe what browsers actually had to do with malformed, real-world URLs already on the web — the same motivation documented component-by-component in [[uri-vs-whatwg-url]]. The goals section is the spec's own justification for existing as a competitor to, rather than a profile of, RFC 3986/3987/6454.

## Tension: Goal 2 in Practice

Goal 2's terminology collapse (everything is a URL, and a URL is absolute) is also the root of an unresolved five-year community debate — [whatwg/url#531](https://github.com/whatwg/url/issues/531) — over whether the standard should support relative references as a first-class, non-absolute value at all. See [[concept-url-531-relative-url-debate]] for the discussion and [[concept-uri-reference-vs-whatwg-url]] for how it maps back onto RFC 3986's `URI-reference` concept that this goal explicitly set out to retire.

## See Also

- [[uri-vs-whatwg-url]] — concrete, mechanical diff implementing these goals
- [[concept-url-531-relative-url-debate]] — ongoing pushback against the absolute-only consequence of goal 2
- [[iri-vs-whatwg-url]] — the same diff for RFC 3987's internationalization scope
- [[uri-terminology]] — the URI/URL/URN split this standard collapses
- [[url-concepts]] — origin, the concept this standard took over from RFC 6454
- [[url-api]] — the JavaScript API goal
- [[url-idempotence]] — the parse/serialize round-trip guarantee
- [[uri-normalization]] — RFC 3986's optional normalization ladder vs. WHATWG's unconditional approach

## Sources

- https://url.spec.whatwg.org/#goals
