---
spec: concept
tags: [concept]
updated: 2026-07-04
---

# URLPattern Component Behavior

`URLPattern` matches the same eight components the [[url-record|URL record]] and [[url-api|`URL` interface]] expose: `protocol`, `username`, `password`, `hostname`, `port`, `pathname`, `search`, `hash`. Each component's pattern is parsed with its own **delimiter code point** and **prefix code point**, which change how wildcards, named groups, and modifiers behave — this is what makes `:id` in `pathname` stop at the next `/` while `:id` in `search` does not stop at anything.

## Delimiter and Prefix Code Points

| Component | Delimiter code point | Prefix code point |
|---|---|---|
| protocol | (none) | (none) |
| username | (none) | (none) |
| password | (none) | (none) |
| hostname | `.` | (none) |
| port | (none) | (none) |
| pathname | `/` | `/` |
| search | (none) | (none) |
| hash | (none) | (none) |

Only `hostname` and `pathname` have a non-empty delimiter — matching that these are the two components with meaningful internal segment structure (dot-separated labels, slash-separated path segments). Only `pathname` has a prefix code point, which is what drives the "optional segment absorbs its leading slash" behavior described in [[urlpattern-syntax]].

## Per-Component Notes

- **protocol** — matched against the scheme; whether the resulting scheme is one of the [[url-concepts|special schemes]] (`http`, `https`, `ws`, `wss`, `ftp`, `file`) determines pathname parsing/canonicalization rules downstream, same as in the URL Standard's own parser.
- **username / password** — no delimiter or prefix; wildcarded unless explicitly given, since most real-world patterns don't care about userinfo.
- **hostname** — dot-delimited, so `:sub.:domain` style patterns split on labels the way [[url-host]] labels do. A leading `[`, `{[`, or `\[` signals an IPv6 literal, parsed as opaque bracket text rather than dot-delimited labels.
- **port** — matching an explicit numeric pattern is literal; to match any port you must write `:*` (or omit hostname/pathname entirely, since port defaults to wildcard). If a pattern's hostname is given but port is omitted, port defaults to the **empty string**, not `*` — matching only the default port for that protocol.
- **pathname** — slash-delimited with `/` as prefix; default pattern is `/` for special-scheme URLs and empty for opaque paths, mirroring the [[url-record|opaque-path]] distinction in the URL Standard.
- **search / hash** — no delimiter; behave like `username`/`password` structurally, but participate in the [[urlpattern-init|pathname/search/hash cascade]] defaulting rule.

## See Also

- [[urlpattern-syntax]]
- [[urlpattern-canonicalization]]
- [[urlpattern-init]]
- [[url-record]]
- [[url-concepts]]
- [[url-host]]

## Sources

- https://urlpattern.spec.whatwg.org/
