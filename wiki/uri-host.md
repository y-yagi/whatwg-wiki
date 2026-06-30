---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Host (RFC 3986 §3.2.2)

The **host** subcomponent of [[uri-authority]] identifies a registered name or IP address governing the namespace of the rest of the URI.

## Grammar

```
host       = IP-literal / IPv4address / reg-name
IP-literal = "[" ( IPv6address / IPvFuture  ) "]"
IPvFuture  = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )
reg-name   = *( unreserved / pct-encoded / sub-delims )
```

`IPv4address` is the standard `dec-octet "." dec-octet "." dec-octet "." dec-octet` form. `IPv6address` covers the full set of compressed/uncompressed/mixed-IPv4 IPv6 literal forms, bracketed with `[` `]` to disambiguate the address's `:` separators from the URI's own port-separator `:`.

`reg-name` is intentionally vague — RFC 3986 doesn't mandate DNS syntax, since hosts can be looked up via DNS, local hosts files, or scheme-specific naming systems.

## Comparison with WHATWG Host Model

RFC 3986's three-way host grammar (`IP-literal / IPv4address / reg-name`) is structurally similar to but **semantically narrower** than [[url-host]]:

| RFC 3986 | WHATWG URL |
|----------|------------|
| `reg-name` — any unreserved/pct-encoded/sub-delims string, no further interpretation | **domain** — must pass [[url-host-parsing\|IDNA processing]] (Unicode → ASCII via Punycode), forbidden-host-code-point checks |
| `IPv4address` — syntactic only | [[url-ipv4]] — full numeric parser accepting decimal/hex/octal mixed notation, *then* validated as 4 octets |
| `IPv6address` | [[url-ipv6]] — same grammar shape, dedicated serializer for compressed form |
| (no equivalent) | **opaque host** — non-special URLs allow hosts that are just a percent-encoded string, closer in spirit to `reg-name` |
| (no equivalent) | **empty host** — explicitly representable, e.g. `file:///path` |

RFC 3986 treats hostname validity as scheme-specific (deferred to whatever resolves the name); the WHATWG URL Standard bakes IDNA and forbidden-code-point validation directly into the generic parser for all special URLs.

## See Also

- [[uri-authority]]
- [[url-host]]
- [[url-host-parsing]]
- [[url-ipv4]]
- [[url-ipv6]]
- [[uri-vs-whatwg-url]]
- [[rfc2396-host]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2
