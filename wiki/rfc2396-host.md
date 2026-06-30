---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396 Host (§3.2.2)

```
host       = hostname | IPv4address
hostname   = *( domainlabel "." ) toplabel [ "." ]
domainlabel = alphanum | alphanum *( alphanum | "-" ) alphanum
toplabel    = alpha | alpha *( alphanum | "-" ) alphanum
IPv4address = 1*digit "." 1*digit "." 1*digit "." 1*digit
```

## No IPv6 in the Base Spec

The original RFC 2396 `host` grammar has **no IP-literal/IPv6 alternative at all** — only a DNS-shaped `hostname` (top label must start with a letter, labels are alphanumeric-and-hyphen) or a purely syntactic `IPv4address` (`1*digit` per octet, with no range validation — `999.999.999.999` matches the grammar). This was a recognized gap closed by **RFC 2732** (December 1999), which updates RFC 2396 to add:

```
host         = hostname | IPv4address | IPv6reference
IPv6reference = "[" IPv6address "]"
```

introducing the `[...]` bracket convention specifically to disambiguate an IPv6 address's internal `:` separators from the URI's own port-separator `:` — the same problem [[uri-host|RFC 3986's `IP-literal`]] grammar solves with the identical bracket syntax. RFC 3986 absorbs RFC 2732's fix directly into its unified `host = IP-literal / IPv4address / reg-name`.

## hostname vs. reg-name

RFC 2396's `hostname` is **DNS-shaped by construction** (labels constrained to alphanumerics/hyphens, top label starting with a letter) — stricter than RFC 3986's `reg-name`, which is any string of `unreserved / pct-encoded / sub-delims` with no DNS-label structure imposed at the generic-syntax level. RFC 3986 deliberately loosened this because non-DNS naming systems (and IDN-related transformations) don't fit the strict `hostname` shape. See [[uri-host]].

## Comparison with WHATWG

The WHATWG [[url-host|host]] model is a further departure from both: it distinguishes **domain** (subject to IDNA processing and forbidden-code-point checks, [[url-host-parsing]]), **IPv4 address** (a numeric parser accepting legacy decimal/hex/octal mixed notation then validated as 4 octets, [[url-ipv4]]), **IPv6 address** ([[url-ipv6]]), **opaque host** (for non-special schemes), and **empty host** as five distinct runtime cases — none of which is purely "any string matching a DNS-label-shaped grammar" the way RFC 2396's `hostname` is.

## See Also

- [[rfc2396-scheme-authority]]
- [[uri-host]]
- [[uri-authority]]
- [[url-host]]
- [[url-ipv4]]
- [[url-ipv6]]
- [[rfc2396-vs-rfc3986]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-3.2.2
- https://datatracker.ietf.org/doc/html/rfc2396#appendix-A
