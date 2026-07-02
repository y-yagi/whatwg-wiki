---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# UTS #46: Unicode IDNA Compatibility Processing

**UTS #46** (Unicode Technical Standard #46, "Unicode IDNA Compatibility Processing") is a Unicode Consortium specification — not an IETF RFC — that reconciles two incompatible IETF domain-name-internationalization standards: **IDNA2003** (RFC 3490/3491, see [[iri-idna]]) and **IDNA2008** (RFC 5890–5895, see [[idna2008-overview]]). Its stated purpose is "allowing client software to access domains that are valid under either system."

## Why It Exists

IDNA2008 changed the rules for which Unicode code points are allowed in domain labels (moving from Nameprep's blocklist model to a per-character allowlist, see [[idna2008-overview]]). This meant a domain name valid and registered under IDNA2003 could become invalid — or resolve to a different string — under IDNA2008, and vice versa. Browsers need one deterministic algorithm that behaves sensibly for both eras of registered names, since they cannot know which standard was in force when any given domain was registered. UTS #46 is that bridging algorithm.

## Two Operations

UTS #46 defines two primary operations, both delegating to a shared **Processing** algorithm (see [[idna-processing-algorithm]]):

- **[[idna-toascii-tounicode|ToASCII]]** — converts a Unicode domain name to an ASCII-compatible encoding (labels prefixed `xn--`, Punycode-encoded).
- **[[idna-toascii-tounicode|ToUnicode]]** — the inverse, recovering a Unicode string from ASCII/Punycode labels.

Both take the same set of boolean flags (`CheckHyphens`, `CheckBidi`, `CheckJoiners`, `UseSTD3ASCIIRules`, `Transitional_Processing`, `IgnoreInvalidPunycode`) plus `VerifyDnsLength` for `ToASCII` only.

## Key Supporting Mechanisms

- **[[idna-mapping-table]]** — per-code-point status values (valid/ignored/mapped/deviation/disallowed) that drive the Map step.
- **[[idna-validity-criteria]]** — the per-label rules a string must satisfy after mapping and normalization.
- **[[idna-transitional-processing]]** — the transitional/nontransitional distinction and the deviation characters (ß, ς, ZWJ, ZWNJ) it exists to handle.
- **[[idna-registry-security]]** — registry-facing guidance and spoofing/bundling considerations.

## Contrast with WHATWG's Usage

[[url-host-parsing|WHATWG's domain-to-ASCII step]] calls UTS #46's `ToASCII` with a specific, non-default flag combination: `checkHyphens = false`, `checkBidi = false`, `checkJoiners = false`, `useSTD3ASCIIRules = false`, `transitionalProcessing = false`. This is deliberately permissive — WHATWG disables nearly every optional strictness check UTS #46 offers, prioritizing "does this resolve to *some* domain" over rejecting ambiguous or spoofable input at the parser level. See [[idna-registry-security]] for why this shifts spoofing-prevention responsibility to registries and browser UI rather than the parsing algorithm itself.

## See Also

- [[iri-idna]] — RFC 3987's older Nameprep/Punycode (IDNA2003) pipeline, and its contrast with UTS #46
- [[idna2008-overview]]
- [[idna-processing-algorithm]]
- [[idna-mapping-table]]
- [[idna-validity-criteria]]
- [[idna-toascii-tounicode]]
- [[idna-transitional-processing]]
- [[idna-registry-security]]
- [[url-host-parsing]]

## Sources

- https://www.unicode.org/reports/tr46/
