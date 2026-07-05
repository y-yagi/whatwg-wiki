---
spec: concept
tags: [concept, security]
updated: 2026-07-06
---

# RFC 2606: Reserved Top Level DNS Names

RFC 2606 (June 1999, Eastlake/Panitz) is a Best Current Practice (BCP 32) that reserves a small set of domain names for documentation, testing, and non-functional examples, so that test code and written examples never collide with a real, resolvable domain. It predates and is narrower in scope than [[idna2008-overview|IDNA]] or the WHATWG URL Standard — it says nothing about parsing or encoding, only about which names are *safe to write down* without accidentally naming something real.

## Reserved Top-Level Domains

| TLD | Purpose |
|---|---|
| `.test` | Testing DNS implementations and protocols in a controlled environment, without risk of colliding with a production domain. |
| `.example` | Illustrative use in written materials — tutorials, documentation, code samples — where a domain name is needed but must not resolve to anything real. |
| `.invalid` | Constructing a domain that is guaranteed non-functional; used where the point is precisely that the name *cannot* resolve. |
| `.localhost` | Preserves the pre-existing convention (already widespread before this RFC) of resolving to the loopback address, `127.0.0.1`. |

## Reserved Second-Level Domains

Three names are reserved as SLDs within existing, already-operational TLDs, for the same documentation purpose as `.example`:

- `example.com`
- `example.net`
- `example.org`

## Rationale

The RFC's core concern is that, absent a reservation, someone might register a name for testing (e.g. inside a private testbed) that later becomes a real, delegated TLD or domain — silently breaking the test setup or, worse, letting test traffic leak to the real internet once the name goes live. Reserving these names up front removes that hazard for anyone writing documentation, examples, or test suites.

## Later History: RFC 6761

RFC 2606 was formally updated by **RFC 6761** (February 2013, "Special-Use Domain Names"), which generalized the concept into an IANA registry of special-use names (adding `.onion`, `.local`, etc.) and tightened the required resolver/application behavior for `.test`, `.example`, `.invalid`, and `.localhost`. RFC 6761 is the document implementers should treat as authoritative for behavior today; RFC 2606 remains the historical origin of the four TLD reservations and is still the RFC most commonly cited for them.

## Relevance to WHATWG Specs

None of the seven core WHATWG specs tracked in this wiki normatively depend on RFC 2606, but two of its reservations surface directly in spec text and in this wiki:

- **`.localhost`** — the WHATWG URL Standard gives `"localhost"` special-cased host handling in `file:` URLs (see [[url-host]]), setting it to an empty host rather than keeping it as a domain — a direct, if narrower, echo of this RFC's loopback reservation.
- **`example.com`/`example.org`/etc.** — used throughout WHATWG spec prose (HTML, Fetch, URL) as the default illustrative domain in algorithm walkthroughs, exactly the documentation use case this RFC carves out.

See [[concept-reserved-example-domains]] for how these two threads connect across the tracked specs.

## See Also

- [[url-host]] — WHATWG's own special-casing of `"localhost"` in `file:` URLs
- [[concept-reserved-example-domains]] — how reserved example/test names are actually used across WHATWG spec text
- [[idna2008-overview]] — contrast: RFC 2606 reserves *names*, IDNA governs how names are *encoded*
- [[uri-vs-whatwg-url]] — broader IETF-vs-WHATWG framing this RFC fits into

## Sources

- https://datatracker.ietf.org/doc/html/rfc2606
- https://datatracker.ietf.org/doc/html/rfc6761
