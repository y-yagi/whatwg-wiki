---
spec: fetch
tags: [concept]
updated: 2026-07-06
---

# Cache Modes

`request.cache` controls how [[fetch-http-fetch|HTTP-network-or-cache fetch]] interacts with the browser's HTTP cache, independent of `Cache-Control`/`Expires` headers the response itself carries (those determine *freshness*; cache mode determines *whether and how* the cache is consulted at all).

## Modes

| Mode | Behavior |
|---|---|
| `"default"` | Normal browser behavior: use a fresh cached response if present; otherwise make a conditional request against a stale one, or a full network request if there's no cache entry — and store the result. |
| `"no-store"` | Bypass the cache entirely in both directions: never read a cached response, never write the new one to the cache. |
| `"reload"` | Bypass the cache on the way to the network (always issue a full network request), but still store the fresh response into the cache afterward. |
| `"no-cache"` | Always revalidate: if a cached entry exists, issue a conditional request (`If-None-Match`/`If-Modified-Since`) regardless of freshness; if none exists, issue a normal request. |
| `"force-cache"` | Use any cached response — fresh or stale — without revalidation if one exists at all; only go to the network on a cache miss. |
| `"only-if-cached"` | Use a cached response if present; otherwise return a network error without ever touching the network. Only valid combined with `request.mode: "same-origin"`. |

## Freshness and Validation

- **Fresh**: within the `Cache-Control: max-age` window or before the `Expires` date.
- **Stale-while-revalidate**: usable immediately even past staleness for a bounded extra window, while a background request refreshes the cache entry.
- **Stale**: no longer fresh but eligible for conditional revalidation via `If-None-Match` (matching `ETag`) or `If-Modified-Since` (matching `Last-Modified`); a `304 Not Modified` response reuses the cached body without re-transferring it.

## See Also

- [[fetch-http-fetch]]
- [[fetch-request-response]]
- [[fetch-credentials-mode]]

## Sources

- https://fetch.spec.whatwg.org/#concept-request-cache-mode
- https://fetch.spec.whatwg.org/#http-network-or-cache-fetch
