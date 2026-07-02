---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# UTS #46 Validity Criteria (§4.1)

The **Validity Criteria** are nine conditions a non-empty label must satisfy during the [[idna-processing-algorithm|Convert/Validate step]]. The spec notes the first six derive from IDNA2008 "except for the fourth criterion," and that stricter, application-specific criteria are always permitted on top of these.

## The Nine Criteria

1. **NFC form** — the label must already be in Unicode Normalization Form C (guaranteed by the preceding Normalize step).
2. **Hyphen positions** *(if `CheckHyphens`)* — no hyphen-minus (`-`) in both the third and fourth positions (guards against unintentional collision with the `xn--` ACE prefix pattern).
3. **Leading/trailing hyphen** *(if `CheckHyphens`)* — the label must not start or end with `-`.
4. **`xn--` prefix restriction** — *even when `CheckHyphens` is false*, the label must not begin with `xn--` (this is the one criterion that is *not* purely inherited from IDNA2008; it protects the ACE namespace regardless of hyphen-checking).
5. **No embedded dot** — the label must not contain U+002E FULL STOP (dots only ever appear as the label separator, handled by the Break step).
6. **No leading combining mark** — the label's first code point must not have `General_Category=Mark` (a combining character at label-start has no visible base to attach to).
7. **Per-code-point Status**, three sub-parts — see [[idna-transitional-processing]] and [[idna-mapping-table]]:
   - Under **Transitional Processing**: every code point's Status must be `valid`.
   - Under **Nontransitional Processing**: every code point's Status must be `valid` or `deviation`.
   - If `UseSTD3ASCIIRules` is true: ASCII code points must be lowercase letters, digits, or hyphen-minus — uppercase `A`–`Z` is explicitly excluded.
8. **ContextJ compliance** *(if `CheckJoiners`)* — the label must satisfy the ContextJ rules referenced from IDNA2008 Appendix A (governs when U+200C ZWNJ / U+200D ZWJ are permitted).
9. **Bidi compliance** *(if `CheckBidi`, and only for Bidi domain names)* — the label must meet all six numbered conditions of RFC 5893 §2 (see [[iri-bidi]] for the general bidi-in-identifiers problem).

## Relevance to WHATWG

[[url-host-parsing|WHATWG's `domain-to-ASCII` call]] sets `checkHyphens = false`, `checkBidi = false`, `checkJoiners = false`, and `useSTD3ASCIIRules = false` — disabling criteria 2, 3, 8, 9, and the ASCII-case restriction in 7c. Only criteria 1, 4, 5, 6, and the base Status check in 7a/7b remain enforced. This is why, for example, a WHATWG-parsed domain can contain characters or hyphen patterns that a strict IDNA2008 validator would reject.

## See Also

- [[idna-uts46-overview]]
- [[idna-processing-algorithm]]
- [[idna-mapping-table]]
- [[idna-transitional-processing]]
- [[iri-bidi]]
- [[url-host-parsing]]

## Sources

- https://www.unicode.org/reports/tr46/#Validity_Criteria
