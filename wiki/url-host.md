---
spec: url
tags: [concept]
updated: 2026-06-30
---

# URL Host

A **host** in WHATWG URLs is one of five distinct types. The type determines how it is parsed, validated, and serialized.

## Host Types

| Type | Description | Example |
|------|-------------|---------|
| **domain** | A non-empty ASCII string (post-IDNA processing) | `example.com` |
| **IPv4 address** | A 32-bit unsigned integer | `2130706433` (= `127.0.0.1`) |
| **IPv6 address** | A 16-element array of 16-bit unsigned integers | `[0,0,0,0,0,0,0,1]` (= `[::1]`) |
| **opaque host** | An opaque ASCII string for non-special URLs | `my.host%2Fname` |
| **empty host** | Empty string `""` | `file:///path` |

## Domain vs. Opaque Host

- **Domain**: used only by **special URLs** (`http`, `https`, `ftp`, `ws`, `wss`). Must pass IDNA/UTS46 processing via `domain-to-ASCII`. Cannot contain certain forbidden code points.
- **Opaque host**: used by non-special URLs. Must not contain forbidden host code points but bypasses IDNA processing.

## Forbidden Host Code Points

These cannot appear (percent-decoded) in any host:
`U+0000 NULL`, `U+0009 TAB`, `U+000A LF`, `U+000D CR`, `U+0020 SPACE`, `#`, `/`, `:`, `<`, `>`, `?`, `@`, `[`, `\`, `]`, `^`, `|`

## Forbidden Domain Code Points

Superset of forbidden host code points, additionally forbidding:
`%`, `U+007F DELETE`, C0 controls, and various other code points not valid in domain labels.

## Localhost

The string `"localhost"` has special treatment in `file:` URLs — it is treated the same as an empty host.
Any domain that is a **loopback** IPv4/IPv6 address is also considered local.

## See Also

- [[url-host-parsing]]
- [[url-ipv4]]
- [[url-ipv6]]
- [[url-record]]

## Sources

- https://url.spec.whatwg.org/#concept-host
- https://url.spec.whatwg.org/#forbidden-host-code-point
