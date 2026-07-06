---
spec: fetch
tags: [algorithm]
updated: 2026-07-06
---

# HTTP Fetch, HTTP-Network-or-Cache Fetch, HTTP-Network Fetch

The three-layer algorithm that turns an HTTP(S) request into bytes on the wire (and back), sitting beneath [[fetch-algorithm|scheme fetch]] and above the network layer.

## HTTP Fetch

1. Resolve `request.client` for user-facing prompts (e.g. HTTP auth dialogs) to the actual navigable/traversable.
2. Determine `request.responseTainting` from `request.mode`: `"cors"` → `"cors"`, `"no-cors"` → `"opaque"`, `"same-origin"`/`"navigate"` → `"basic"`. See [[fetch-cors|response tainting]].
3. If `request.unsafeRequest` flag is set — i.e. the method isn't CORS-safelisted or the header list contains a non-safelisted header — perform a [[fetch-cors|CORS-preflight fetch]] first and fail the whole fetch if it fails.
4. Invoke **HTTP-network-or-cache fetch**.
5. If the response is a redirect (300–399 with a `Location` header) and `request.redirectMode` is `"follow"`, invoke [[fetch-redirect|HTTP-redirect fetch]].

## HTTP-Network-or-Cache Fetch

Mediates between the HTTP cache and the network per `request.cache` (see [[fetch-cache-mode]]):

1. If cache mode is `"only-if-cached"` and `request.mode` isn't `"same-origin"`, return a network error (this combination is only valid for same-origin requests; see [[fetch-cache-mode]]). If cache mode is `"only-if-cached"` and there's no cache match, also return a network error.
2. If cache mode is `"no-store"`, skip cache reads/writes entirely and go straight to network.
3. Look up a matching cached response.
4. If fresh and mode isn't `"no-cache"`/`"reload"`, return the cached response directly (no network round-trip).
5. If stale-while-revalidate applies, return the stale response immediately and queue a background revalidation request.
6. If stale, issue a conditional request (`If-None-Match`/`If-Modified-Since`) to revalidate; a `304` reuses the cached body, otherwise the fresh response replaces it.
7. Otherwise fall through to **HTTP-network fetch** for a full request.
8. Apply `request.credentials` (see [[fetch-credentials-mode]]) when deciding whether to attach cookies/HTTP auth/client certificates to the outgoing request.

## HTTP-Network Fetch

The actual wire-level exchange:

1. Obtain a connection (opening a new one, or reusing a pooled/multiplexed HTTP/2 connection).
2. Perform TLS negotiation for `https:`.
3. If a [[fetch-cors|CORS-preflight]] is pending for this request, resolve it first.
4. Serialize the request line, headers (respecting [[fetch-headers|forbidden header]] restrictions on what the user agent vs. developer may set), and body.
5. Transmit to the server.
6. As the response arrives, if status is `103 Early Hints`, invoke `processEarlyHints` and keep reading for the final response.
7. Populate the response's header list, status, and body stream as bytes arrive; update timing-info markers used by the Resource Timing API.
8. If `request.integrity` is non-empty, [[fetch-integrity|verify the response body hash]] once the body is fully read, and replace the response with a [[fetch-network-error|network error]] on mismatch.

## See Also

- [[fetch-algorithm]]
- [[fetch-redirect]]
- [[fetch-cors]]
- [[fetch-cache-mode]]
- [[fetch-credentials-mode]]
- [[fetch-integrity]]
- [[fetch-headers]]
- [[fetch-network-error]]

## Sources

- https://fetch.spec.whatwg.org/#http-fetch
- https://fetch.spec.whatwg.org/#http-network-or-cache-fetch
- https://fetch.spec.whatwg.org/#http-network-fetch
