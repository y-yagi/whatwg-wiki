---
spec: concept
tags: [concept, security]
updated: 2026-07-06
---

# Reserved Example/Test Domains in WHATWG Specs

[[rfc2606-overview|RFC 2606]] reserves `.test`, `.example`, `.invalid`, `.localhost`, and `example.com`/`.net`/`.org` so that documentation and test code never accidentally name a live, resolvable domain. WHATWG spec text doesn't cite the RFC directly, but its reservations show up in two distinct ways across the tracked specs: as illustrative names in prose, and as one real, spec-normative special case.

## Illustrative Use (Non-Normative)

Across HTML, Fetch, and URL spec prose, algorithm walkthroughs and examples consistently use `example.com`, `example.org`, and similar names for sample origins, URLs, and hosts — precisely the documentation use case RFC 2606 defines these names for. This usage carries no spec weight; any placeholder-looking domain would do, but the spec authors default to the RFC-reserved names rather than inventing ad hoc ones.

## Normative Use: `.localhost` in `file:` URLs

The one place a reserved name gets actual parsing behavior in a tracked spec is [[url-host|the WHATWG URL Standard's host parser]]: in the file host state, the literal string `"localhost"` is special-cased to an empty host rather than retained as an ordinary domain. This is narrower than RFC 2606's TLD-level reservation (WHATWG cares only about the exact label `localhost`, not the `.localhost` TLD as a whole) but serves the same underlying goal RFC 2606 documents — preserving the pre-existing loopback convention rather than treating the name as an arbitrary, resolvable domain.

## What's Notably Absent

Neither `.test`, `.example`, nor `.invalid` receive any parsing special-case in the URL Standard — they are ordinary domains as far as [[url-host-parsing|host parsing]] is concerned. Any special *behavioral* treatment of these names (e.g. secure-context treatment of `.localhost`-adjacent addresses, or DNS-resolver-level handling) lives outside the seven specs this wiki tracks, closer to platform/DNS-resolver behavior than to URL/HTML/Fetch spec text.

## See Also

- [[rfc2606-overview]] — the RFC defining these reservations and their rationale
- [[url-host]] — WHATWG's own `"localhost"` special case in `file:` URLs
- [[url-host-parsing]] — the host parser algorithm in which that special case lives

## Sources

- https://datatracker.ietf.org/doc/html/rfc2606
- https://url.spec.whatwg.org/#file-host-state
