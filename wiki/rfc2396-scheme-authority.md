---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# RFC 2396 Scheme and Authority

## Scheme (§3.1)

```
scheme = alpha *( alpha | digit | "+" | "-" | "." )
```

Must begin with a letter; "for resiliency, programs interpreting URI should treat upper case letters as equivalent to lower case in scheme names," though the spec recommends lowercase as the canonical producer form — the same case-insensitivity rule [[uri-scheme|RFC 3986 §3.1]] keeps verbatim.

## Authority (§3.2)

```
authority = server | reg_name
```

Unlike RFC 3986 — where `authority = [ userinfo "@" ] host [ ":" port ]` is the *only* form — RFC 2396 forks authority into two alternatives:

- **`server`**: the network-locating form, parsed further into userinfo/host/port (below).
- **`reg_name`**: a registry-of-naming-authorities form for **non-server-based** naming schemes, defined only as `reg_name = 1*( unreserved | escaped | "$" | "," | ";" | ":" | "@" | "&" | "=" | "+" )` — opaque from the generic grammar's point of view, structurally similar to RFC 3986's `reg-name` but reachable only when the authority *isn't* server-shaped, rather than being one of three uniform host alternatives (compare [[uri-host]]'s `IP-literal / IPv4address / reg-name`).

## Server (§3.2.2)

```
server   = [ [ userinfo "@" ] hostport ]
userinfo = *( unreserved | escaped | ";" | ":" | "&" | "=" | "+" | "$" | "," )
hostport = host [ ":" port ]
host     = hostname | IPv4address
hostname = *( domainlabel "." ) toplabel [ "." ]
port     = *digit
```

`server` may be entirely empty (`//`) — an explicit, empty-but-present authority. `port`'s `*digit` (zero or more digits) means an explicit empty port (`http://host:/`) is syntactically distinct from no port at all, same ambiguity RFC 3986 inherits unchanged.

Base RFC 2396 has **no IPv6 literal syntax** in `host` — only `hostname | IPv4address`. RFC 2732 (1999) is the update that retrofits `host = hostname | IPv4address | IPv6reference`, the direct ancestor of RFC 3986's `IP-literal` bracket form. See [[rfc2396-host]].

## Comparison with RFC 3986 / WHATWG

RFC 3986 flattens `server`/`reg_name` into the single `authority = [ userinfo "@" ] host [ ":" port ]` with `host` itself absorbing the three-way IP-literal/IPv4/reg-name split ([[uri-authority]], [[uri-host]]). The WHATWG URL Standard goes further still, parsing userinfo as separate **username** and **password** fields rather than one undifferentiated `userinfo` string — see [[url-record]].

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-host]]
- [[uri-authority]]
- [[uri-host]]
- [[uri-scheme]]
- [[rfc2396-vs-rfc3986]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-3.1
- https://datatracker.ietf.org/doc/html/rfc2396#section-3.2
