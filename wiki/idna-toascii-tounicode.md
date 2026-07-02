---
spec: concept
tags: [concept, idna, algorithm]
updated: 2026-07-03
---

# UTS #46 ToASCII and ToUnicode (§4.2, §4.3)

`ToASCII` and `ToUnicode` are the two public entry points of UTS #46, both built on top of the shared [[idna-processing-algorithm|Processing algorithm]].

## ToASCII (§4.2)

**Inputs:** `domain_name`, `CheckHyphens`, `CheckBidi`, `CheckJoiners`, `UseSTD3ASCIIRules`, `Transitional_Processing`, `VerifyDnsLength`.

**Steps:**
1. Run [[idna-processing-algorithm|Processing]] on `domain_name` with the given flags. This may record errors.
2. Break the result into labels at U+002E FULL STOP.
3. Convert each label containing non-ASCII characters to Punycode and prefix it with `xn--`.
4. If `VerifyDnsLength` is true, check DNS length restrictions:
   - Whole domain name (excluding the root label and its trailing dot): 1 to 253 characters.
   - Each individual label: 1 to 63 characters.
5. If any error was recorded in steps 1–4, the operation **fails** (returns no result).
6. Otherwise, join the labels with U+002E FULL STOP and return the resulting ASCII string.

## ToUnicode (§4.3)

Runs the same [[idna-processing-algorithm|Processing]] algorithm but skips the Punycode-encoding and DNS-length steps — it "always produces a converted Unicode string" and separately signals whether an error occurred, rather than failing outright. This lets callers show a best-effort Unicode rendering (e.g., for diagnostics or UI) even for a string that doesn't fully validate.

## WHATWG's `domain-to-ASCII`

[[url-host-parsing|WHATWG's host parser]] calls `ToASCII` and, unlike the general UTS #46 API, treats an empty-string result or any recorded error as an outright parsing failure (raising the `domain-to-ASCII` validation error) — it does not expose the "succeed with error flag" flexibility that `ToUnicode` callers get. `VerifyDnsLength` is left off in WHATWG's usage, so the 253/63-character DNS limits are **not** enforced at the URL-parsing layer.

## See Also

- [[idna-uts46-overview]]
- [[idna-processing-algorithm]]
- [[idna-validity-criteria]]
- [[url-host-parsing]]
- [[url-validation-errors]]
- [[iri-idna]] — the older RFC 3490 `ToASCII`/`ToUnicode` this pair supersedes for WHATWG purposes

## Sources

- https://www.unicode.org/reports/tr46/#ToASCII
- https://www.unicode.org/reports/tr46/#ToUnicode
