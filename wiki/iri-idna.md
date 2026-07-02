---
spec: concept
tags: [concept]
updated: 2026-07-02
---

# IRI Domain Name Handling (IDNA, RFC 3987 §3.1 / §5.3.3)

RFC 3987 does not define its own scheme for encoding non-ASCII domain names — it defers to **IDNA** (Internationalizing Domain Names in Applications, RFC 3490/3491) as the alternative to plain UTF-8 percent-encoding for the `ireg-name` component of [[iri-syntax|`ihost`]].

## ToASCII / ToUnicode

- **`ToASCII`** (RFC 3490): converts a Unicode domain label to an ASCII-compatible encoding (ACE) label prefixed `xn--`, using the **Punycode** algorithm (RFC 3492) internally. Applying it during [[iri-to-uri-mapping|IRI→URI mapping]] is optional (`MAY`) — an implementation can equally choose plain UTF-8 percent-encoding for the same label.
- **`ToUnicode`**: the inverse, recovering the original Unicode label from an `xn--` ACE label.

## Nameprep (RFC 3491)

Before `ToASCII`/`ToUnicode` runs, domain labels are passed through **Nameprep**, a profile of Unicode Stringprep that case-folds, normalizes (NFKC), and prohibits certain code points to ensure two visually/semantically equivalent domain names map to the same ACE form. RFC 3987 invokes Nameprep as part of [[iri-normalization-comparison|scheme-based normalization]] (§5.3.3) for schemes known to use domain names.

## Flags Relevant to Normalization

When RFC 3987 recommends comparing IRIs by their IDN-normalized form, it calls for `ToASCII` with:
- `UseSTD3ASCIIRules` — reject ASCII characters not valid in traditional hostnames (rejects e.g. `_`, space).
- `AllowUnassigned` — depends on context (stored vs. just-typed strings) since the set of assigned Unicode code points grows over time.

## Contrast with WHATWG's Host Parser

[[url-host-parsing|WHATWG's domain-to-ASCII step]] uses the newer **[[idna-uts46-overview|UTS #46]]** (Unicode IDNA Compatibility Processing) rather than RFC 3490/3491's older Nameprep/Punycode-only pipeline, and pins its flags explicitly: `checkHyphens = false`, `checkBidi = false`, `checkJoiners = false`, `useSTD3ASCIIRules = false`, `transitionalProcessing = false`. Where RFC 3987 leaves `ToASCII` invocation as an optional, scheme-dependent choice, WHATWG makes IDNA processing **mandatory and unconditional** for every special-scheme host — there is no percent-encoding fallback for domains in the WHATWG model. See [[iri-vs-whatwg-url]].

UTS #46 was created specifically to bridge this RFC 3490/3491 (**IDNA2003**) pipeline with its IETF successor **IDNA2008** (RFC 5890–5895, see [[idna2008-overview]]), which replaced Nameprep's blocklist approach with a per-character allowlist. Where RFC 3987's Nameprep unconditionally case-folds and NFKC-normalizes, UTS #46 introduces the [[idna-transitional-processing|transitional/nontransitional distinction]] specifically to reconcile domains registered under either era — see [[idna-mapping-table]] and [[idna-validity-criteria]] for the mechanics.

## See Also

- [[iri-syntax]]
- [[iri-to-uri-mapping]]
- [[iri-normalization-comparison]]
- [[url-host-parsing]]
- [[uri-host]]
- [[idna-uts46-overview]]
- [[idna2008-overview]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-3.1
- https://datatracker.ietf.org/doc/html/rfc3987#section-5.3.3
