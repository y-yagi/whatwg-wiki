---
spec: concept
tags: [concept, interface]
updated: 2026-07-04
---

# URLPattern Standard: Overview

The URL Pattern Standard (urlpattern.spec.whatwg.org) defines `URLPattern`, "a web platform primitive for matching URLs based on a convenient pattern syntax" — the same pattern language used informally by routers like Express (`/users/:id`) and service-worker route matching, standardized and applied component-by-component against a URL. It is a separate WHATWG living standard from the URL Standard, but it is not self-contained: its canonicalization step reuses the URL Standard's own host, port, and percent-encoding algorithms (see [[urlpattern-canonicalization]]), so it is filed here as `concept` rather than `url` — it sits on top of [[url-parsing-algorithm]] rather than replacing it.

## Why It Exists

Before `URLPattern`, matching "does this URL look like `/users/:id`?" required hand-rolling a regular expression per component, re-deriving delimiter and escaping rules that the URL Standard already defines implicitly through its grammar. `URLPattern` standardizes that pattern syntax once, matches it against the same eight components the [[url-record|URL record]] exposes, and reuses [[url-percent-encoding|URL Standard canonicalization]] so a pattern's `:id` group in `pathname` matches percent-encoded input the same way `URL` itself would parse it.

## Core Pieces

- **[[urlpattern-init]]** — the `URLPatternInit` dictionary and `URLPatternOptions`, the object-shaped way to specify per-component patterns
- **[[urlpattern-constructor]]** — the two-overload constructor (pattern string + baseURL, or `URLPatternInit` + options), and the constructor-string parsing state machine
- **[[urlpattern-syntax]]** — the pattern language itself: wildcards, named groups, regex groups, modifiers, grouping, escaping
- **[[urlpattern-components]]** — per-component delimiter and prefix code points that shape how wildcards and named groups behave differently in `pathname` vs. `hostname` vs. other components
- **[[urlpattern-canonicalization]]** — how each component's pattern text is normalized using the URL Standard's own encoding callbacks
- **[[urlpattern-exec-test]]** — `test()`/`exec()`, `URLPatternResult`, `URLPatternComponentResult`
- **[[urlpattern-base-url]]** — resolving relative pattern strings against a base URL
- **[[urlpattern-regexp-groups]]** — custom `(regex)` groups, `hasRegExpGroups`, and their constraints
- **[[urlpattern-examples]]** — worked examples straight from the spec
- **[[urlpattern-vs-url-api]]** — how this differs in purpose from the [[url-api|`URL`/`URLSearchParams` API]]

## See Also

- [[url-record]]
- [[url-api]]
- [[url-goals]]

## Sources

- https://urlpattern.spec.whatwg.org/
