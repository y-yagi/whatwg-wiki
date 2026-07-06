---
spec: concept
tags: [concept, example]
updated: 2026-07-04
---

# URLPattern Worked Examples

Examples given directly in the spec, illustrating how the pieces in [[urlpattern-syntax]], [[urlpattern-components]], and [[urlpattern-base-url]] combine.

## Simple: Named Group + Wildcard

```js
const pattern = new URLPattern("https://example.com/:category/*");
```

- **Matches:** `https://example.com/products/`, `https://example.com/blog/our-greatest-product-ever`
- **Does not match:** `https://example.com/` (nothing to fill `:category`/`*`), `http://example.com/products/` (wrong protocol — `http` ≠ `https`), `https://example.com:8443/products/` (per the spec's own note: since `hostname` is specified in this constructor string and `port` is not, `port` collapses to matching only `https`'s default port 443 — a non-default port like `8443` fails; write `:*` after the hostname to match any port; see [[urlpattern-components]])

## Complex: Optional Protocol Suffix, Optional Subdomain, Regex-Constrained Group, Fixed Fragment

```js
const pattern = new URLPattern(
  "http{s}?://{:subdomain.}?shop.example/products/:id([0-9]+)#reviews"
);
```

- `http{s}?` — the literal `s` is grouped with `{ }` and made optional, so both `http` and `https` match (a bare `s?` without grouping would instead make only the trailing `s` character optional in a way that doesn't cleanly express "http or https").
- `{:subdomain.}?` — an optional named group `subdomain` bundled with its trailing `.` delimiter via `{ }`, so the whole `subdomain.` prefix is present or absent as a unit, and its captured value never includes a dangling `.` when present.
- `:id([0-9]+)` — the named group `id` is constrained by a regex group to one-or-more ASCII digits (see [[urlpattern-regexp-groups]]).
- `#reviews` — a fixed literal fragment; only URLs ending in `#reviews` match.
- **Matches:** `https://shop.example/products/123#reviews`, `https://intl.shop.example/products/7#reviews` (`subdomain` captures `intl`), and — since `username`/`password` default to wildcard — userinfo-bearing hosts like `https://kathryn@voyager.shop.example/products/1#reviews` (`subdomain` captures `voyager`, username `kathryn` is unconstrained).

## Relative: Pattern String + baseURL

```js
const pattern = new URLPattern("../admin/*", "https://discussion.example/forum/?page=2");
```

- Resolves to a pathname pattern of `/admin/*` on `discussion.example`, per [[urlpattern-base-url]].
- **Matches:** `https://discussion.example/admin/`, `https://edd:librarian@discussion.example/admin/update?id=1` (username/password/search/hash all wildcarded).

## See Also

- [[urlpattern-syntax]]
- [[urlpattern-components]]
- [[urlpattern-base-url]]
- [[urlpattern-regexp-groups]]
- [[urlpattern-exec-test]]

## Sources

- https://urlpattern.spec.whatwg.org/
