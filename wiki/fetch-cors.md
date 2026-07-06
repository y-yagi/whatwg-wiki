---
spec: fetch
tags: [algorithm, security]
updated: 2026-07-06
---

# CORS Protocol

Cross-Origin Resource Sharing (CORS) is the mechanism by which a cross-origin HTTP response opts in to being readable by the requesting page's script, layered on top of [[fetch-http-fetch|HTTP fetch]] rather than replacing the same-origin default.

## Response Tainting

Set during [[fetch-http-fetch|HTTP fetch]] based on `request.mode`, and determines how much of the response JS is allowed to see:

| Mode | Response tainting | Effect |
|---|---|---|
| `"same-origin"` | `"basic"` | Full access; network error if cross-origin |
| `"cors"` | `"cors"` | Access to status/[[fetch-headers|CORS-exposed headers]]/body if CORS check passes |
| `"no-cors"` | `"opaque"` | Status forced to `0`, no header/body access, regardless of success |
| `"navigate"` | `"basic"` | Full access (top-level navigation) |

## CORS-Safelisted Methods and Headers

Requests using only these don't need a preflight:

- **Safelisted methods**: `GET`, `HEAD`, `POST`.
- **Safelisted request headers**: `Accept`, `Accept-Language`, `Content-Language`, `Content-Type` (only `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`), `Range` (single-range requests only) — each additionally bounded by value-shape and length restrictions (e.g. `Accept` ≤ 128 bytes with no CORS-unsafe byte).

Any other method, or any header outside this list (or exceeding its constraints), marks the request's `unsafeRequest` flag, forcing a preflight.

## CORS-Preflight Fetch

Triggered from [[fetch-http-fetch|HTTP fetch]] when `request.mode` is `"cors"` and the request is not safelisted:

1. Build a preflight request: method `OPTIONS`, same URL, no body.
2. Add `Access-Control-Request-Method` with the real request's method.
3. Add `Access-Control-Request-Headers` listing the non-safelisted header names (sorted, comma-separated).
4. Send via HTTP-network fetch directly, bypassing the HTTP cache.
5. Run the **CORS check** against the preflight response; on failure, the whole fetch becomes a [[fetch-network-error|network error]].
6. Validate `Access-Control-Allow-Methods` and `Access-Control-Allow-Headers` permit the actual request's method/headers.
7. On success, cache the preflight result keyed by origin/URL/method for a duration set by `Access-Control-Max-Age` (implementation-defined cap; not a fixed spec ceiling), so repeated requests to the same endpoint can skip the round-trip.
8. Proceed with the original request.

## CORS Check

Applied to the *actual* response (and to the preflight response above):

1. If `request.mode` isn't `"cors"`, succeed trivially.
2. If response type is `"opaque"`/`"opaqueredirect"`, succeed trivially (nothing to check).
3. Read `Access-Control-Allow-Origin`. If missing, or it's neither `*` nor byte-for-byte equal to the serialized request origin, fail.
4. If `request.credentialsMode` is `"include"`, `Access-Control-Allow-Origin` of `*` is **not** sufficient — an exact origin match is required, *and* `Access-Control-Allow-Credentials: true` must be present.
5. Otherwise succeed.

## Origin Header

Set on the outgoing request (Section 3.2) for: all CORS requests, and any non-GET/HEAD same-origin request (notably all `POST`s) — not just cross-origin ones, so servers can apply CSRF-style checks. Omitted when the [[fetch-referrer-policy|referrer policy]] would forbid disclosing the origin, or replaced with the literal string `"null"` for [[url-concepts|opaque origins]].

## TAO (Timing-Allow-Origin) Check

Gatekeeps whether the Resource Timing / Navigation Timing APIs expose fine-grained timing for a cross-origin resource:

1. If `request.mode` isn't `"cors"`, succeed (same-origin timing is always visible).
2. If the `Timing-Allow-Origin` header is absent, fail.
3. If its value is `*`, or is a comma-separated list of origins containing the serialized request origin, succeed; otherwise fail.
4. On failure, only coarse timing (start/end time) is exposed, not detailed marks.

## See Also

- [[fetch-http-fetch]]
- [[fetch-headers]]
- [[fetch-credentials-mode]]
- [[fetch-request-response]]
- [[fetch-security-considerations]]
- [[fetch-network-error]]
- [[url-concepts]] — opaque origin, used as the `Origin` header value for opaque-origin requests
- [[url-serialization]] — origin serialization used in CORS/TAO origin comparisons

## Sources

- https://fetch.spec.whatwg.org/#http-cors-protocol
- https://fetch.spec.whatwg.org/#cors-preflight-fetch
- https://fetch.spec.whatwg.org/#cors-check
- https://fetch.spec.whatwg.org/#tao-check
- https://fetch.spec.whatwg.org/#cors-safelisted-method
- https://fetch.spec.whatwg.org/#cors-safelisted-request-header
