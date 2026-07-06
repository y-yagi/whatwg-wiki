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

When a `URLPatternInit` is processed (whether passed directly to the constructor, or produced by parsing a constructor string), the algorithm takes a **type** of `"pattern"` (constructing a `URLPattern`) or `"url"` (matching a concrete URL against an already-built pattern, e.g. the second argument to `test()`/`exec()`) — several of the baseURL-inheritance rules below depend on which:

1. If **`baseURL`** is present, it is parsed as a URL first, and used to fill in components *not* explicitly given in the init, but each component only inherits if `init` also lacks every component *more specific* than it (the two orderings the spec uses are `protocol, hostname, port, pathname, search, hash` and `protocol, hostname, port, username, password`):
   - `protocol` inherits from `baseURL` if `init` has no `protocol`.
   - `hostname` inherits if `init` has neither `protocol` nor `hostname`.
   - `port` inherits (or becomes the empty string if `baseURL` has no port) if `init` has none of `protocol`, `hostname`, `port`.
   - **`username`/`password` are never inherited from `baseURL` when constructing a `URLPattern` (type `"pattern"`)** — full stop, regardless of what else is unspecified. They *are* inherited from `baseURL` when type is `"url"`, i.e. when resolving a concrete URL to match against a pattern, and even then only if `init` has none of `protocol`/`hostname`/`port`/`username` (for username) or none of those plus `username` (for password).
2. **`pathname`/`search`/`hash` cascade**: `pathname` inherits from `baseURL` only if `init` has none of `protocol`, `hostname`, `port`, `pathname`. `search` inherits only if none of those plus `pathname` are given. `hash` inherits only if none of those plus `search` are given. The intent is that specifying only a later component shouldn't silently wildcard-match every earlier one.
3. Any component still unspecified after the above stays absent from the processed init at this stage — see the `URLPattern` `create` algorithm's own separate step for defaulting absent components to the full wildcard `*` (and its special-cased default-port collapse), described in [[urlpattern-components|the port component notes]].

This is why `new URLPattern({ pathname: "/foo" })` matches any protocol/hostname/port but a specific path, while `new URLPattern({ hostname: "example.com" })` (no `baseURL`, no `pathname`) still ends up with a `pathname` pattern of `*`, not empty — and why `new URLPattern({ hostname: "example.com", baseURL: "https://user:pw@example.org/" })` never picks up `user`/`pw`, even though it would happily inherit `port` from the same `baseURL` if unset.

## See Also

- [[urlpattern-constructor]]
- [[urlpattern-base-url]]
- [[urlpattern-components]]
- [[urlpattern-canonicalization]]

## Sources

- https://urlpattern.spec.whatwg.org/
