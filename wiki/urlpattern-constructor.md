---
spec: concept
tags: [concept, algorithm, interface]
updated: 2026-07-04
---

# URLPattern Constructor

```webidl
[Exposed=(Window,Worker)]
interface URLPattern {
  constructor(URLPatternInput input, USVString baseURL,
              optional URLPatternOptions options = {});
  constructor(optional URLPatternInput input = {},
              optional URLPatternOptions options = {});
  ...
};
typedef (USVString or URLPatternInit) URLPatternInput;
```

There are effectively two ways to construct a pattern:

## 1. Pattern String (+ optional base URL)

```js
new URLPattern("https://example.com/:category/*")
new URLPattern("/admin/*", "https://example.com")
```

A single shorthand string is parsed by the **constructor string parser** — a state machine that walks the string and slices it into the same eight components a URL has, applying pattern syntax ([[urlpattern-syntax]]) within each slice using the **lenient** tokenizing policy. If the string has no scheme/protocol and no `baseURL` is supplied, construction throws a `TypeError` — there is no implicit default protocol the way relative URLs assume one from a document's base.

Components not present in the string default per [[urlpattern-init]]'s processing rules (wildcarded, or inherited from `baseURL` if given).

## 2. URLPatternInit Object

```js
new URLPattern({ hostname: "example.com", pathname: "/:category/*" })
```

Each dictionary member is parsed independently as a single component pattern, using the **strict** tokenizing policy — a malformed component pattern throws immediately rather than being tolerated as literal text.

## Construction-Time Compilation

Both forms compile every component's pattern to a regular expression **during construction**, not lazily at first match. This is deliberate: it surfaces an invalid custom `(regex)` group ([[urlpattern-regexp-groups]]) as a `TypeError` at `new URLPattern(...)` time, rather than as a confusing failure the first time `.test()`/`.exec()` is called.

## Example: Constructor String Parsing

`https://example.com/:category/*` is parsed as:

| Component | Value |
|---|---|
| protocol | `https` |
| hostname | `example.com` |
| pathname | `/:category/*` |
| username, password, port, search, hash | default (wildcard) |

## Relative Constructor Strings

`../admin/*` with `baseURL: "https://discussion.example/forum/?page=2"` resolves the pathname relative to the base URL's path and inherits `protocol`, `hostname`, and `port` from it. See [[urlpattern-base-url]].

## See Also

- [[urlpattern-init]]
- [[urlpattern-syntax]]
- [[urlpattern-base-url]]
- [[urlpattern-regexp-groups]]
- [[urlpattern-examples]]

## Sources

- https://urlpattern.spec.whatwg.org/
