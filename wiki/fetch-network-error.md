---
spec: fetch
tags: [concept]
updated: 2026-07-06
---

# Network Error

A **network error** is a [[fetch-request-response|response]] whose type is `"error"`: status always `0`, status message always the empty byte sequence, header list always empty, and body always null — regardless of what actually went wrong. It's the uniform failure value nearly every Fetch algorithm returns instead of propagating a specific error.

## Why a Single Undifferentiated Value

Collapsing every failure mode (DNS failure, TLS error, CORS check failure, integrity mismatch, disallowed scheme, redirect loop, etc.) into one indistinguishable response is deliberate: it prevents script from using error *details* as a cross-origin side channel (e.g. distinguishing "connection refused" from "CORS blocked" would leak information about a target's existence/configuration that the requesting page isn't authorized to see). Script only ever observes a rejected `fetch()` promise or a `Response` with `type: "error"` — never the underlying cause.

## Where It's Produced

Returned by, among others:
- [[fetch-algorithm|main fetch]] — navigation requests without a reserved client, disallowed `localURLsOnly` schemes.
- [[fetch-http-fetch]] — failed CORS-preflight, `"only-if-cached"` with no cache match or wrong request mode.
- [[fetch-redirect|HTTP-redirect fetch]] — unparseable `Location`, non-HTTP(S) redirect target, redirect-count limit exceeded.
- [[fetch-cors|CORS check]] failure.
- [[fetch-integrity|Subresource Integrity]] hash mismatch.
- `Response.error()` — constructs one directly from JavaScript.

## Consuming a Network Error

- The JS `fetch()` promise rejects with a `TypeError` rather than resolving to the network-error response, for the top-level entry point.
- A `Response` object with `type: "error"` (obtained via `Response.error()` or observed on a `no-cors`/service-worker-intercepted fetch) has `ok: false`, `status: 0`, and throws on any attempt to read a meaningful status.

## See Also

- [[fetch-request-response]] — the `Response` interface and `type` property this shows up as
- [[fetch-algorithm]]
- [[fetch-http-fetch]]
- [[fetch-redirect]]
- [[fetch-cors]]
- [[fetch-integrity]]
- [[fetch-security-considerations]] — why undifferentiated failure is itself a security property

## Sources

- https://fetch.spec.whatwg.org/#concept-network-error
- https://fetch.spec.whatwg.org/#concept-aborted-network-error
