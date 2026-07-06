---
spec: fetch
tags: [concept, security]
updated: 2026-07-06
---

# Credentials Modes and Request Modes

Two related but distinct axes of policy on a [[fetch-request-response|request]]: **credentials mode** governs whether cookies/auth are sent and read; **mode** governs cross-origin access shape and whether [[fetch-cors|CORS]] applies at all.

## Credentials Modes (`request.credentials`)

- **`"omit"`**: never attach credentials (cookies, HTTP authentication, TLS client certificates) to the outgoing request; ignore any `Set-Cookie` in the response.
- **`"same-origin"`** (default for `fetch()`): attach credentials only when the request URL is same-origin with the request's client; cross-origin requests get none, and cross-origin `Set-Cookie` is ignored.
- **`"include"`**: always attach credentials, cross-origin or not. For a cross-origin response to be readable at all under `mode: "cors"`, the server must additionally respond with `Access-Control-Allow-Credentials: true` and a non-wildcard `Access-Control-Allow-Origin` — see [[fetch-cors|CORS check]].

Navigation requests (top-level page loads) default to `"include"`; subresource requests initiated via `fetch()` default to `"same-origin"`.

## Request Modes (`request.mode`)

- **`"same-origin"`**: request URL must be same-origin with the client, or the fetch is a [[fetch-network-error|network error]] — no cross-origin access path at all.
- **`"cors"`**: cross-origin allowed subject to the [[fetch-cors|CORS protocol]] (preflight where required, CORS check on the response); response tainting `"cors"`.
- **`"no-cors"`**: cross-origin allowed with no CORS validation, but the response is **opaque** — script gets a response object with status `0`, no headers, no body access. Restricted to [[fetch-cors|CORS-safelisted methods and headers]] (no arbitrary custom headers), since there's no server-side opt-in check possible.
- **`"navigate"`**: reserved for top-level/frame navigations; response tainting `"basic"`.
- **`"websocket"`** / **`"webtransport"`**: reserved for the WebSocket/WebTransport establishment handshakes, which delegate connection setup outside the ordinary fetch flow.

## Interaction

Mode and credentials mode compose independently: a `no-cors` request can still carry `credentials: "include"`, but under cross-origin-isolation policies like COEP-credentialless, credentials may be stripped from `no-cors` requests even when explicitly requested, to avoid credentialed responses leaking into an opaque (unauditable) response.

## See Also

- [[fetch-cors]]
- [[fetch-headers]]
- [[fetch-http-fetch]]
- [[fetch-security-considerations]]
- [[fetch-network-error]]

## Sources

- https://fetch.spec.whatwg.org/#concept-request-credentials-mode
- https://fetch.spec.whatwg.org/#concept-request-mode
- https://fetch.spec.whatwg.org/#concept-request-response-tainting
