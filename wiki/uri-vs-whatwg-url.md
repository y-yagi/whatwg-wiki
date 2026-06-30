---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 3986 vs. the WHATWG URL Standard

RFC 3986 ("URI Generic Syntax") and the WHATWG URL Standard both define how to parse URLs/URIs, but they take fundamentally different approaches and disagree on several points. The WHATWG URL Standard's introduction explicitly positions itself as a response to RFC 3986's inadequacy for real-world web content.

## Core Philosophical Difference

| | RFC 3986 | WHATWG URL |
|---|---|---|
| **Form** | Declarative ABNF grammar + separate prose algorithms | Single imperative state machine ([[url-parsing-algorithm]]) that *is* the spec |
| **Goal** | Define a valid/invalid syntax that all schemes can share | Match what real browsers must do with the malformed URLs that already exist on the web |
| **Invalid input** | Rejected — a string not matching the ABNF is not a URI | Mostly **recovered from** — errors are non-fatal [[url-validation-errors|validation errors]] in most cases; parsing fails only in specific narrow conditions |
| **Versioning** | Frozen RFC, obsoletes RFC 2396 | "Living Standard" — updated continuously |
| **Terminology** | URI is general; URL/URN are deprecated subtypes ([[uri-terminology]]) | Everything is a URL; "URI" not used |

## Where WHATWG Diverges Concretely

- **Special schemes**: WHATWG singles out `ftp`, `file`, `http`, `https`, `ws`, `wss` as **special** with bespoke rules (mandatory non-empty host, default ports, backslash-as-slash). RFC 3986 has no such concept — all schemes are equally generic. See [[url-record]], [[uri-scheme]].
- **Host validation**: WHATWG mandates IDNA processing and forbidden-code-point rejection as part of the generic parser ([[url-host-parsing]]); RFC 3986's `reg-name` is unconstrained text, deferring meaning to the scheme/resolver. See [[uri-host]].
- **Percent-encode sets**: WHATWG replaces RFC 3986's single reserved/unreserved split with eight component-specific [[url-percent-encoding|percent-encode sets]]. See [[uri-reserved-characters]].
- **Error recovery**: WHATWG's parser is built to never simply reject most malformed real-world input the way a strict ABNF matcher would — it has explicit per-character recovery behavior in every [[url-parser-states|state]]. RFC 3986 offers no equivalent error-recovery model; non-conforming input is simply not a URI.
- **Dot-segment removal timing**: RFC 3986 removes dot segments as a discrete post-processing algorithm during [[uri-reference-resolution|reference resolution]] (§5.2.4). WHATWG performs the equivalent removal inline, character-by-character, inside the Path state, and additionally recognizes percent-encoded dot segments (`%2e`) that RFC 3986's literal-character grammar does not.
- **The `http:g` ambiguity**: RFC 3986 (§5.4.2) acknowledges a real ambiguity inherited from RFC 2396 about whether a rootless path beginning with what looks like a scheme name should be treated specially. WHATWG has no such ambiguity — special-scheme URLs are never rootless.
- **Normalization is optional vs. inherent**: RFC 3986's [[uri-normalization|normalization ladder]] (§6) is something an application opts into when *comparing* URIs. WHATWG performs the syntax/scheme-based-equivalent normalization unconditionally as part of parsing — there's no "unnormalized" WHATWG URL to begin with.
- **IPv4/IPv6 strictness**: RFC 3986's `IPv4address`/`IPv6address` are pure ABNF (any string matching the shape is valid). WHATWG's [[url-ipv4]]/[[url-ipv6]] parsers additionally validate numeric ranges and accept/reject specific legacy notations (octal, hex, mixed) with explicit [[url-validation-errors|validation errors]] — closing the §7.4 ambiguity RFC 3986 itself calls out as a security risk ([[uri-security-considerations]]).

## What's Preserved

The five-component model (scheme, authority, path, query, fragment), the `%XX` percent-encoding mechanism, the gen-delims/sub-delims vocabulary, the fragment-is-client-side-only rule, and the overall shape of relative reference resolution all carry over from RFC 3986 into WHATWG largely unchanged in spirit, even where the mechanics differ.

## See Also

- [[uri-generic-syntax]]
- [[uri-terminology]]
- [[uri-reference-resolution]]
- [[uri-normalization]]
- [[uri-security-considerations]]
- [[url-parsing-algorithm]]
- [[url-record]]
- [[url-concepts]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986
- https://url.spec.whatwg.org/#goals
