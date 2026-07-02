---
spec: concept
tags: [concept, idna]
updated: 2026-07-03
---

# IDNA2008 Label Terminology (RFC 5890 §2)

RFC 5890 defines a precise classification tree for domain labels, since IDNA2008's rules apply per-label (a domain name is a sequence of labels separated by dots) rather than to the whole name at once.

## Label Types

- **LDH label** — a label using only the classic DNS-safe alphabet: **L**etters, **D**igits, **H**yphen (the traditional RFC 952/1123 hostname charset). Purely ASCII.
- **NR-LDH label** ("non-reserved LDH label") — an LDH label that does **not** have `--` (two hyphens) in the third and fourth character positions. This carve-out exists specifically so ACE-encoded labels (which *do* have `--` there, from the `xn--` prefix) are distinguishable from ordinary ASCII labels.
- **XN-label** — an LDH label that starts with the ACE prefix `xn--`. This is the on-the-wire form of an internationalized label.
- **A-label** — the specific subset of XN-labels that are the valid output of encoding a U-label; i.e., an XN-label that actually decodes to a valid U-label. (An XN-label that fails to decode/validate is sometimes called a "fake A-label.")
- **U-label** — a label containing non-ASCII code points that, per IDNA2008's rules (see [[idna2008-vs-idna2003]]), is valid for use in an internationalized domain name. This is the "human-readable" Unicode form corresponding to an A-label.

## Whole-Name Concepts

- **IDNA-valid string** — a domain name where every label is individually valid per IDNA2008 (each label is either an LDH label, an A-label, or a valid U-label as appropriate).
- **Fully-Qualified Domain Name (FQDN)** — used in its conventional DNS sense; IDNA2008 labels compose into FQDNs the same way ASCII DNS labels always have.

## Why the Classification Matters

Because IDNA2008 validity is a **per-label** property, a single domain name can mix label types freely — e.g., `例え.xn--wgv71a` alongside plain ASCII labels — and each label is checked against its own applicable rule (LDH labels bypass IDNA processing entirely; U-labels/A-labels go through the [[idna2008-vs-idna2003|character-property validation]]). This label-by-label structure is exactly what [[idna-processing-algorithm|UTS #46's Break step]] mirrors when it splits a domain name at U+002E before validating each piece independently.

## See Also

- [[idna2008-overview]]
- [[idna2008-vs-idna2003]]
- [[idna-processing-algorithm]] — UTS #46's own Break-into-labels step
- [[idna-toascii-tounicode]] — how `xn--` labels (A-labels) are produced/decoded

## Sources

- https://datatracker.ietf.org/doc/html/rfc5890#section-2
