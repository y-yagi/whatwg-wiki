---
spec: concept
tags: [concept]
updated: 2026-07-02
---

# RFC 3987 Overview: Internationalized Resource Identifiers (IRIs)

RFC 3987 (January 2005, M. Duerst & M. Suignard) defines the **IRI**, a resource identifier expressed as "a sequence of characters from the Universal Character Set (Unicode/ISO 10646)" rather than US-ASCII only. It is a companion to [[uri-generic-syntax|RFC 3986]] (URI), not a revision of it — see [[iri-vs-uri]] for the relationship.

## Why a New Protocol Element Instead of Extending URI

The spec deliberately introduces IRI as a **distinct** syntax rather than widening `URI` itself, to avoid breaking existing software that assumes URIs are US-ASCII. Every IRI has a deterministic, defined mapping down to a URI ([[iri-to-uri-mapping]]) that legacy systems can consume unchanged, and every URI can be mapped back up to an IRI for display ([[uri-to-iri-mapping]]).

## Applicability Conditions (§1.2)

IRIs are only usable where all three hold:

1. The protocol or format element explicitly permits IRIs (e.g. XML Schema's `anyURI` type) — most existing specs (including HTTP request lines) still call for URIs, not IRIs.
2. The transport mechanism can represent the wider character range, either natively or through escaping (e.g. XML numeric character references).
3. The corresponding URI form encodes non-ASCII characters as UTF-8 before percent-encoding — a requirement RFC 2718 already places on all new URI schemes.

## Relationship to the Web Platform

[[url-goals|The WHATWG URL Standard]] names RFC 3987 directly as one of the two IETF documents ("align RFC 3986 and RFC 3987 with contemporary implementations and obsolete the RFCs in the process") it intends to obsolete. WHATWG does not keep IRI as a separate term or algorithm — non-ASCII handling is folded directly into [[url-parsing-algorithm|the basic URL parser]] via [[url-percent-encoding|UTF-8 percent-encoding]] and [[url-host-parsing|IDNA host processing]]. See [[iri-vs-whatwg-url]] for the detailed comparison.

## See Also

- [[iri-syntax]]
- [[iri-to-uri-mapping]]
- [[uri-to-iri-mapping]]
- [[iri-vs-uri]]
- [[iri-vs-whatwg-url]]
- [[uri-generic-syntax]]
- [[url-goals]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-1
- https://datatracker.ietf.org/doc/html/rfc3987#section-1.2
