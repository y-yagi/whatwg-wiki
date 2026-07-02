---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# IDNA2008 vs. IDNA2003: Blocklist → Allowlist (RFC 5890 §4.7)

The single most important architectural change from IDNA2003 to IDNA2008 is a reversal of default polarity: from "allow a code point unless it's known to be problematic" to "allow a code point only if it's known to be safe."

## IDNA2003's Approach (Nameprep)

[[iri-idna|Nameprep]] (RFC 3491) is a Stringprep profile: a fixed pipeline of case-folding, NFKC normalization, and a **prohibited-characters blocklist**, pinned to the Unicode version current when it shipped. Any code point not explicitly prohibited was implicitly allowed.

## IDNA2008's Approach (RFC 5892 Tables, referenced from RFC 5890 §1.2/§4.7)

IDNA2008 **bypasses Stringprep entirely** rather than extending it. Instead, RFC 5892 derives a per-code-point classification from Unicode character properties (General_Category and others), sorting every code point into one of four categories:

- **PVALID** — "protocol valid": permitted in a label without further restriction.
- **CONTEXTJ** — permitted only in specific contexts, for *joiner* characters (this is where UTS #46's [[idna-registry-security|CONTEXTJ rule for ZWNJ/ZWJ]] comes from — IDNA2008 is the origin of that restriction, and UTS #46's `CheckJoiners` flag enforces it).
- **CONTEXTO** — permitted only in specific contexts, for other characters needing script- or context-sensitive rules (e.g., certain punctuation that's legitimate in some scripts but suspicious in others).
- **DISALLOWED** — never permitted.

Anything not falling into PVALID/CONTEXTJ/CONTEXTO by derivation from its Unicode properties is effectively unusable — including, critically, **unassigned code points** in the Unicode version in force. IDNA2003 permitted unassigned code points (since it only blocked *known* problems); IDNA2008 rejects them by construction, because an allowlist can't include what doesn't yet have assigned properties.

## Consequence: The ß/ς Divergence

Because Nameprep case-folded **ß** (U+00DF) to `ss` and **ς** (U+03C2) to **σ**, while IDNA2008's property-based classification treats them as ordinary PVALID letters in their own right, the *same* Unicode input string can produce two different ASCII-normalized results depending on which standard processed it. This is precisely the problem [[idna-transitional-processing|UTS #46's deviation characters and Transitional/Nontransitional Processing]] exist to paper over for client software that must interoperate with domains registered under either regime.

## Practical Effect for WHATWG

[[url-host-parsing|WHATWG runs UTS #46 with `transitionalProcessing = false`]] — i.e., it follows the **IDNA2008-aligned** (Nontransitional) interpretation for deviation characters, consistent with modern registry practice per [[idna-registry-security|UTS #46's registry guidance]] to register only Nontransitional-valid labels.

## See Also

- [[idna2008-overview]]
- [[idna2008-labels]]
- [[idna-transitional-processing]]
- [[idna-mapping-table]]
- [[idna-registry-security]]
- [[iri-idna]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc5890#section-4.7
- https://datatracker.ietf.org/doc/html/rfc5892 (referenced; defines the PVALID/CONTEXTJ/CONTEXTO/DISALLOWED tables — not separately ingested)
