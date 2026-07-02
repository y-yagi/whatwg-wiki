---
spec: concept
tags: [concept, idna, algorithm]
updated: 2026-07-03
---

# UTS #46 Processing Algorithm (§4)

**Processing** is the shared core algorithm that both [[idna-toascii-tounicode|ToASCII and ToUnicode]] call before doing their format-specific work. It takes a domain name string plus the flags `CheckHyphens`, `CheckBidi`, `CheckJoiners`, `UseSTD3ASCIIRules`, and `Transitional_Processing`, and produces a mapped/validated string (recording errors rather than aborting early — all errors accumulate and are checked at the end).

## Steps

1. **Map** — for each code point, consult the [[idna-mapping-table|IDNA Mapping Table]]: drop `ignored` code points, replace `mapped` ones with their mapping, replace `deviation` code points per [[idna-transitional-processing|Transitional/Nontransitional Processing]], and record an error for any `disallowed` code point.
2. **Normalize** — apply Unicode Normalization Form C (NFC) to the entire mapped string.
3. **Break** — split the normalized string into labels at U+002E (`.`) FULL STOP (and the other three characters Unicode treats as label separators for compatibility: U+3002, U+FF0E, U+FF61).
4. **Convert/Validate** — for each label:
   - If the label starts with `xn--`: verify it contains only ASCII code points (else record an error), attempt Punycode decoding to Unicode, and if decoding succeeds, verify the *decoded* label against the [[idna-validity-criteria|Validity Criteria]] using **Nontransitional** Processing specifically (regardless of the input's own flag) — this reflects that a label already in ACE form was necessarily produced under IDNA2008-era rules.
   - If the label does not start with `xn--`: verify it against the Validity Criteria using whichever Processing choice (transitional/nontransitional) was passed in.

The end result is either a mapped-and-validated Unicode string (with a recorded pass/fail status) that `ToUnicode` returns directly, or that `ToASCII` further encodes to Punycode.

## Design Note: Errors Accumulate

Processing does not short-circuit on the first problem. This matters for `ToUnicode`, which per spec "will always produce a converted Unicode string" and separately signals whether an error occurred — callers can choose to display the (invalid) Unicode result to a user for diagnostic purposes even when validation failed, rather than getting nothing back.

## See Also

- [[idna-uts46-overview]]
- [[idna-mapping-table]]
- [[idna-validity-criteria]]
- [[idna-toascii-tounicode]]
- [[idna-transitional-processing]]
- [[url-host-parsing]] — WHATWG's call site for this algorithm via `domain-to-ASCII`

## Sources

- https://www.unicode.org/reports/tr46/#Processing
