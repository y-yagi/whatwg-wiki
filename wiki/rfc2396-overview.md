---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396: Uniform Resource Identifiers (URI) — Generic Syntax

RFC 2396 (August 1998, Berners-Lee/Fielding/Masinter) is the **direct predecessor** of [[uri-generic-syntax|RFC 3986]] and the immediate ancestor of the URI/URL model the WHATWG URL Standard eventually replaced. It defines a scheme-independent grammar — "a superset of all valid URI" — covering both absolute and relative forms, explicitly revising and merging the generic syntax previously split across RFC 1738 (URLs) and RFC 1808 (relative URLs).

RFC 2396 was itself updated by RFC 2732 (added the `[...]` IPv6 literal-address bracket syntax to `host`) before being **obsoleted in full by RFC 3986** in January 2005. See [[rfc2396-vs-rfc3986]] for the point-by-point successor diff.

## Scope

- Defines URI syntax only; explicitly **does not address non-US-ASCII characters** ("does not discuss the issues and recommendation for dealing with characters outside of the US-ASCII character set") — a gap RFC 3986 also left mostly open, eventually closed on the web by the WHATWG URL Standard's mandatory UTF-8 percent-encoding ([[url-percent-encoding]]).
- Grammar is expressed in a BNF dialect (not the formal ABNF used later by RFC 3986); productions use `|` for alternation and `*`/`+` repetition prefixes like ABNF, but the rule set is organized differently (see [[rfc2396-grammar]]).
- Structurally separates **URL-like** and **URN-like** identifiers via the `absoluteURI = scheme ":" ( hier_part | opaque_part )` production — a split RFC 3986 later collapsed into a single unified `URI` grammar. See [[uri-terminology]] for how this connects to the URI/URL/URN terminology debate.

## Document History

| RFC | Year | Role |
|---|---|---|
| RFC 1738 | 1994 | Original URL syntax |
| RFC 1808 | 1995 | Relative URL resolution |
| **RFC 2396** | 1998 | Unifies 1738 + 1808 into one generic URI grammar |
| RFC 2732 | 1999 | Updates RFC 2396 to add IPv6 `[...]` literal syntax |
| RFC 3986 | 2005 | Obsoletes RFC 2396, formal ABNF, gen-delims/sub-delims split |
| WHATWG URL Standard | ongoing | Living Standard; replaces RFC 3986 as the web's operative URL spec |

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-scheme-authority]]
- [[rfc2396-host]]
- [[rfc2396-path]]
- [[rfc2396-query-fragment]]
- [[rfc2396-reserved-characters]]
- [[rfc2396-reference-resolution]]
- [[rfc2396-security-considerations]]
- [[rfc2396-vs-rfc3986]]
- [[uri-generic-syntax]]
- [[uri-terminology]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396
- https://datatracker.ietf.org/doc/html/rfc2396#section-1
