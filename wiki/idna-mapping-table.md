---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# IDNA Mapping Table (UTS #46 §5)

The **IDNA Mapping Table** assigns every Unicode code point a **Status** value that determines how the [[idna-processing-algorithm|Map step]] treats it. This table — not a fixed blocklist like Nameprep (see [[iri-idna]]) — is what lets UTS #46 track new Unicode versions without a protocol change.

## Status Values

| Status | Meaning |
|---|---|
| **valid** | Code point is allowed as-is in a domain label. |
| **ignored** | Code point is removed entirely during mapping (contributes nothing to the output). |
| **mapped** | Code point is replaced by one or more other code points (e.g., uppercase → lowercase folding). |
| **deviation** | Code point was valid under IDNA2003 but is disallowed or mapped differently under IDNA2008; its treatment depends on [[idna-transitional-processing|Transitional vs. Nontransitional Processing]]. |
| **disallowed** | Code point must never appear in a domain label; its presence is always an error. |

A second, **informative-only** field records **IDNA2008 status** for code points that are `valid`/`ignored`/`mapped`/`deviation` under UTS #46 but treated differently by IDNA2008 proper:

- **NV8** — excluded from IDNA2008 for all Unicode versions ("Not Valid in IDNA2008").
- **XV8** — excluded from IDNA2008 for the specific Unicode version cited.

These two informative flags don't change UTS #46 processing; they exist so implementers can cross-check against strict IDNA2008 behavior if needed.

## UseSTD3ASCIIRules Is Not a Table Column

Unlike the Status values above, `UseSTD3ASCIIRules` is **not** encoded as separate mapping-table statuses. It is applied purely within [[idna-validity-criteria|Validity Criterion 7]]: when the flag is true, ASCII code points in a label must be lowercase letters, digits, or hyphen-minus (the traditional STD3/RFC 952 hostname rule) — rejecting characters like `_` or space that the base mapping table would otherwise pass through as `valid`/`mapped`.

## Effect on WHATWG's Domain-to-ASCII

[[url-host-parsing|WHATWG]] runs `ToASCII` with `useSTD3ASCIIRules = false`, so this extra check is skipped — a domain label containing `_` (common in some real-world hostnames despite not being spec-legal DNS) is not rejected purely for that reason.

## See Also

- [[idna-uts46-overview]]
- [[idna-processing-algorithm]]
- [[idna-validity-criteria]]
- [[idna-transitional-processing]]
- [[iri-idna]] — Nameprep's blocklist-style precursor

## Sources

- https://www.unicode.org/reports/tr46/#IDNA_Mapping_Table
