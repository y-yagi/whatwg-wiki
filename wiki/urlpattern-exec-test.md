---
spec: concept
tags: [concept, interface, algorithm]
updated: 2026-07-04
---

# URLPattern test() and exec()

```webidl
boolean test(optional URLPatternInput input = {}, optional USVString baseURL);
URLPatternResult? exec(optional URLPatternInput input = {}, optional USVString baseURL);
```

Both methods accept the same input shapes a `URLPattern` can be constructed from (a URL-like string plus optional base, or a `URLPatternInit`-like object), and both run the pattern's already-compiled per-component regular expressions (see [[urlpattern-constructor]]) against the corresponding components of the input.

## test()

Returns a plain `boolean` — matched or not — with no capture information. Cheapest option when you only need a yes/no route check.

## exec()

Returns a `URLPatternResult`, or `null` if any component fails to match.

```webidl
dictionary URLPatternResult {
  sequence<URLPatternInput> inputs;
  URLPatternComponentResult protocol;
  URLPatternComponentResult username;
  URLPatternComponentResult password;
  URLPatternComponentResult hostname;
  URLPatternComponentResult port;
  URLPatternComponentResult pathname;
  URLPatternComponentResult search;
  URLPatternComponentResult hash;
};

dictionary URLPatternComponentResult {
  USVString input;
  record<USVString, (USVString or undefined)> groups;
};
```

- **`inputs`** — echoes back the arguments `exec()` was called with (the string/init and base URL), letting a caller recover what was matched without holding onto the original call arguments separately.
- **One `URLPatternComponentResult` per component** — each has:
  - **`input`** — the exact substring of that component that was matched.
  - **`groups`** — a record from group name (from `:name` or a numbered/regex group) to the matched string, or **`undefined`** if that group belongs to an optional (`?`/`*`) part that didn't end up matching anything.

## Matching Algorithm, in Brief

1. Extract the eight components from `input` (parsing it as a URL first if it's a string, or reading them off a `URLPatternInit`-shaped object), resolved against `baseURL` if supplied.
2. For each component, run its compiled regular expression ([[urlpattern-constructor]]) against the extracted component value.
3. If every component's regex matches, build and return the `URLPatternResult` (for `exec()`) or `true` (for `test()`).
4. If any component fails to match, return `null` (`exec()`) or `false` (`test()`) — matching is all-or-nothing across components, there is no partial match result.

## See Also

- [[urlpattern-constructor]]
- [[urlpattern-components]]
- [[urlpattern-regexp-groups]]
- [[urlpattern-examples]]

## Sources

- https://urlpattern.spec.whatwg.org/
