---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-04
---

# URLPattern Base URL Handling

`URLPattern` accepts a `baseURL` in three places, all feeding the same underlying resolution behavior: the two-argument string constructor (`new URLPattern(pattern, baseURL)`), the `baseURL` member of `URLPatternInit`, and the optional second argument to `test()`/`exec()`.

## What baseURL Fills In

When a pattern (or match input) is given as a relative string, `baseURL` supplies whatever the string doesn't specify — mirroring how a base URL fills in missing pieces of a relative reference in the URL Standard's own [[url-parsing-algorithm|basic URL parser]]:

- **protocol, hostname, port** are inherited directly from `baseURL` if the pattern string doesn't specify its own (subject to a "more specific component" cascade — see [[urlpattern-init]]).
- **pathname** given as a relative path (e.g. `../admin/*`) is resolved against `baseURL`'s path using ordinary relative-path resolution (collapsing `..`/`.` segments), not treated as a literal wildcard-free string.
- **search, hash** *can* inherit from `baseURL` too, but only as the tail of the same specificity cascade as pathname: `search` inherits only if `pathname` (and everything before it) is also unspecified, and `hash` only if `search` is too. In practice, as soon as a pattern specifies its own `pathname` (as in the example below), `search`/`hash` fall through to the ordinary wildcard default instead — it isn't that they're categorically excluded from inheritance.
- **username, password** are the one genuine exception: they are **never** inherited from `baseURL` when *constructing* a pattern, no matter what else is left unspecified — only when *matching* a concrete URL against an already-built pattern (the `baseURL` argument to `test()`/`exec()`) do username/password inherit from it, since there a base URL's own credentials really do belong to "the URL being tested," not "the pattern."

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
