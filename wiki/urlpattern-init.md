---
spec: concept
tags: [concept, interface]
updated: 2026-07-04
---

# URLPatternInit and URLPatternOptions

The object-shaped way to construct a `URLPattern`, giving independent control over each component's pattern instead of writing one shorthand string (see [[urlpattern-constructor]] for the string form).

## URLPatternInit Dictionary

```webidl
dictionary URLPatternInit {
  USVString protocol;
  USVString username;
  USVString password;
  USVString hostname;
  USVString port;
  USVString pathname;
  USVString search;
  USVString hash;
  USVString baseURL;
};
```

Every member is optional. A member left unset generally defaults to the full wildcard (`*`) for that component — **except** where `baseURL` supplies a value, per the defaulting rules below.

## URLPatternOptions Dictionary

```webidl
dictionary URLPatternOptions {
  boolean ignoreCase = false;
};
```

`ignoreCase` controls whether the compiled per-component regular expressions are case-insensitive. Default is `false` (case-sensitive matching, matching normal URL component comparison).

## "Process a URLPatternInit" — Defaulting Rules

When a `URLPatternInit` is processed (whether passed directly to the constructor, or produced by parsing a constructor string):

1. If **`baseURL`** is present, it is parsed as a URL first, and its `protocol`, `username`, `password`, `hostname`, and `port` are used to fill in any of those components *not* explicitly given in the init — rather than defaulting those components to `*`.
2. **`pathname`/`search`/`hash` cascade**: if `pathname` is unspecified but `search` or `hash` is given, `pathname` is filled from the base URL (or defaults per [[urlpattern-components]]) rather than wildcarded — the intent being that specifying only a later component shouldn't silently wildcard-match every path. Likewise, if `search` is unspecified but `hash` is given, `search` defaults to the empty string rather than `*`.
3. Any component still unspecified after the above falls back to the full wildcard `*`.

This is why `new URLPattern({ pathname: "/foo" })` matches any protocol/hostname/port but a specific path, while `new URLPattern({ hostname: "example.com" })` (no `baseURL`, no `pathname`) still ends up with a `pathname` pattern of `*`, not empty.

## See Also

- [[urlpattern-constructor]]
- [[urlpattern-base-url]]
- [[urlpattern-components]]
- [[urlpattern-canonicalization]]

## Sources

- https://urlpattern.spec.whatwg.org/
