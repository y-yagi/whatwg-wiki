---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-04
---

# URLPattern Base URL Handling

`URLPattern` accepts a `baseURL` in three places, all feeding the same underlying resolution behavior: the two-argument string constructor (`new URLPattern(pattern, baseURL)`), the `baseURL` member of `URLPatternInit`, and the optional second argument to `test()`/`exec()`.

## What baseURL Fills In

When a pattern (or match input) is given as a relative string, `baseURL` supplies whatever the string doesn't specify — mirroring how a base URL fills in missing pieces of a relative reference in the URL Standard's own [[url-parsing-algorithm|basic URL parser]]:

- **protocol, hostname, port** are inherited directly from `baseURL` if the pattern string doesn't specify its own.
- **pathname** given as a relative path (e.g. `../admin/*`) is resolved against `baseURL`'s path using ordinary relative-path resolution (collapsing `..`/`.` segments), not treated as a literal wildcard-free string.
- **username, password, search, hash** are *not* inherited from `baseURL` — they still default to wildcards unless the pattern string specifies them, since a base URL's own credentials/query/fragment aren't meaningfully "the pattern to match."

See [[urlpattern-init]] for the exact ordering ("process a URLPatternInit") that applies these defaults.

## Example

Pattern `../admin/*` with `baseURL: "https://discussion.example/forum/?page=2"`:

- `protocol` inherited: `https`
- `hostname` inherited: `discussion.example`
- `pathname` resolved: `/forum/?page=2`'s path is `/forum/`, and `../admin/*` relative to it resolves to `/admin/*`
- `search`, `hash` default to wildcard (not inherited from the base's `?page=2`)

This matches: `https://discussion.example/admin/`, and (since username/password are wildcarded) `https://edd:librarian@discussion.example/admin/update?id=1`.

## Why This Differs from Plain URL Resolution

`URLPattern`'s base-URL resolution reuses the URL Standard's mechanics for path resolution and component inheritance, but it applies them to a *pattern* string that may still contain wildcards, named groups, and modifiers after resolution — a step the URL Standard's basic parser has no equivalent of, since its inputs and outputs are always concrete URLs, never patterns.

## See Also

- [[urlpattern-init]]
- [[urlpattern-constructor]]
- [[url-parsing-algorithm]]
- [[urlpattern-examples]]

## Sources

- https://urlpattern.spec.whatwg.org/
