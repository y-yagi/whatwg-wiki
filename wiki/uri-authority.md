---
spec: concept
tags: [concept, parser]
updated: 2026-07-01
---

# URI Authority (RFC 3986 §3.2)

The **authority** component groups together who/where a resource is served from. It is introduced by `//` and terminated by the next `/`, `?`, `#`, or the end of the URI.

## Grammar

```
authority = [ userinfo "@" ] host [ ":" port ]
```

## §3.2.1 User Information

```
userinfo = *( unreserved / pct-encoded / sub-delims / ":" )
```

`user:password` form is permitted by the grammar but **its use is deprecated** — RFC 3986 explicitly warns against transmitting passwords in clear text within a URI, since the URI is often visible (logs, history, Referer headers).

## §3.2.2 Host

```
host = IP-literal / IPv4address / reg-name
```

See [[uri-host]] for the full grammar of each alternative.

## §3.2.3 Port

```
port = *DIGIT
```

A decimal number; absence means "use the scheme's default port," not port 0 — see [[url-record]] for the WHATWG URL Standard's default-port table.

## Comparison with WHATWG

The WHATWG URL Standard's [[url-parser-states|Authority state]] parses the same conceptual fields (username, password, host, port) but as part of an imperative state machine over code points rather than a declarative grammar, and layers on validation errors, forbidden host code points, and special-scheme-specific host requirements not present in RFC 3986. See [[uri-vs-whatwg-url]].

## See Also

- [[uri-generic-syntax]]
- [[uri-host]]
- [[uri-reserved-characters]]
- [[url-parser-states]]
- [[url-record]]
- [[uri-vs-whatwg-url]]
- [[rfc2396-scheme-authority]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-3.2
- https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.1
