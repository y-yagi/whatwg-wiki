---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# IDNA2008 (RFC 5890 Document Set)

**IDNA2008** is the IETF's second-generation standard for internationalized domain names, replacing **IDNA2003** (RFC 3490/3491, see [[iri-idna]]). It **obsoletes RFC 3490** and **updates RFC 4343** (DNS case-insensitivity). RFC 5890 itself, informally called "Defs," is the terminology/framework document for a six-document set (§1.2 "Road Map"):

| Document | Informal name | Role |
|---|---|---|
| **RFC 5890** | Defs | Definitions and document framework (this page's source) |
| **RFC 5894** | Rationale | Background/overview — explicitly non-normative |
| **RFC 5891** | Protocol | The core IDNA2008 protocol and its operations |
| **RFC 5893** | (Bidi) | Special rules for right-to-left labels |
| **RFC 5892** | Tables | Defines which code points are allowed, based on Unicode 5.2 property assignments |
| *(Mapping document)* | — | Advisory-only guidance on character mapping; explicitly **not** a required part of IDNA |

RFC 5890 frames its audience broadly (§1.1.1): not just protocol implementers, but also those setting **registry policy** — "what names are permitted in DNS zone files" — signaling that IDNA2008 is as much a governance framework as a wire protocol.

## Why IDNA2008 Replaced IDNA2003

IDNA2003's Nameprep (see [[iri-idna]]) worked as a fixed **blocklist**: a Stringprep profile that case-folded, NFKC-normalized, and prohibited certain characters, baked to a specific Unicode version. IDNA2008's core change (§4.7) is that it **bypasses Stringprep entirely** rather than patching it, replacing the blocklist with an allowlist derived from Unicode character properties (see [[idna2008-vs-idna2003]] and RFC 5892's PVALID/CONTEXTJ/CONTEXTO/DISALLOWED categories). The most consequential behavioral change: **unassigned Unicode code points are now rejected outright**, where IDNA2003 permitted them — a strictness inversion from "allow unless known-bad" to "allow only if known-good."

## See Also

- [[idna2008-labels]] — A-label/U-label/LDH-label terminology and the label classification tree
- [[idna2008-vs-idna2003]] — the Stringprep-bypass and allowlist/blocklist shift in detail
- [[idna2008-security-considerations]]
- [[iri-idna]] — IDNA2003 (RFC 3490/3491/Nameprep), which this document set obsoletes
- [[idna-uts46-overview]] — UTS #46, the Unicode Consortium's compatibility bridge between IDNA2003 and IDNA2008

## Sources

- https://datatracker.ietf.org/doc/html/rfc5890
