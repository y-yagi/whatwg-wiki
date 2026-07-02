---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# Transitional vs. Nontransitional Processing & Deviation Characters (UTS #46)

UTS #46's central compatibility trick is the **deviation** [[idna-mapping-table|Status]]: a small set of code points that IDNA2003 treated one way and IDNA2008 treats another. How they're handled depends on the `Transitional_Processing` flag.

## The Deviation Characters

| Code point | IDNA2003 behavior | IDNA2008 behavior |
|---|---|---|
| **ß** (U+00DF, LATIN SMALL LETTER SHARP S) | Mapped to `ss` (Nameprep case-folding) | Valid as its own character |
| **ς** (U+03C2, GREEK SMALL LETTER FINAL SIGMA) | Mapped to **σ** (regular sigma) | Valid as its own character |
| **ZWNJ** (U+200C, ZERO WIDTH NON-JOINER) | Mapped away (ignored) | Valid, but only in restricted contexts (ContextJ) |
| **ZWJ** (U+200D, ZERO WIDTH JOINER) | Mapped away (ignored) | Valid, but only in restricted contexts (ContextJ) |

## What the Flag Does

Per [[idna-validity-criteria|Validity Criterion 7]]:
- **Transitional Processing**: deviation characters are mapped away exactly as IDNA2003 did (ß → ss, ς → σ, ZWNJ/ZWJ dropped) — a deviation character's Status is *not* accepted as `valid` on its own, so if it survives to the validity check it's an error.
- **Nontransitional Processing**: deviation characters pass through unchanged and are accepted (Status `valid` or `deviation` both pass).

## Why This Exists

The practical problem: `faß.de` and `fass.de` are the *same* registered domain under IDNA2003 (case-folding), but *different* domains under IDNA2008 (ß is its own valid letter). A browser has no way to know which registration era produced any given bookmark, typed URL, or link — so it needs a single deterministic choice. UTS #46 does not mandate one; it exposes the choice as a flag and lets the calling protocol decide.

## WHATWG's Choice

[[url-host-parsing|WHATWG sets `transitionalProcessing = false`]] — i.e., **Nontransitional Processing** — meaning modern browsers treat `faß.de` and `fass.de` as distinct domains, matching current IDNA2008-era DNS registration practice rather than legacy IDNA2003 folding. This is the industry-wide browser convergence point UTS #46 was designed to produce (older browsers historically defaulted to transitional processing, causing the exact `faß.de`/`fass.de` divergence the table above illustrates).

## See Also

- [[idna-uts46-overview]]
- [[idna-mapping-table]]
- [[idna-validity-criteria]]
- [[idna-processing-algorithm]]
- [[idna-registry-security]] — CONTEXTJ's role in restricting ZWNJ/ZWJ misuse
- [[url-host-parsing]]

## Sources

- https://www.unicode.org/reports/tr46/#Deviations
- https://www.unicode.org/reports/tr46/#Transition_Processing
