---
spec: fetch
tags: [algorithm]
updated: 2026-07-06
---

# Fetch Algorithm

The **fetch** algorithm is the top-level entry point of the Fetch Standard: given a [[fetch-request-response|request]], it dispatches through scheme routing and ultimately produces a [[fetch-request-response|response]], exposed to callers (JavaScript's `fetch()`, HTML resource loading, `XMLHttpRequest`, etc.) as a set of processing callbacks rather than a single return value, since responses can stream in incrementally.

## Entry Point: Fetch

Inputs: a request, plus optional callbacks (`processRequestBodyChunk`, `processRequestEndOfBody`, `processEarlyHints`, `processResponse`, `processResponseEndOfBody`, `processResponseConsumeBody`), and a `useParallelQueue` flag.

Steps (abbreviated):
1. Assert the request's URL is non-null.
2. If `request.keepalive` is set, run additional keepalive-specific checks (payload/body size limits, inflight-request bookkeeping).
3. Resolve `request.client`/`request.origin` from the literal `"client"` placeholder to the actual environment settings object's [[url-concepts|origin]].
4. Create fetch params bundling the request, a new **fetch controller**, and the processing callbacks.
5. Invoke [[fetch-algorithm|main fetch]] with the fetch params, in parallel.
6. Return the fetch controller immediately, so callers can [[fetch-abort|abort]] the in-flight fetch.

## Main Fetch

The dispatcher that applies cross-cutting policy before scheme-specific handling:

1. Assert the request's *done* flag is unset; set it.
2. If the request is a navigation request without a reserved client, return a [[fetch-network-error|network error]] (`TypeError`).
3. If `request.mode` is `"websocket"`, hand off to the WebSocket/WebTransport establishment algorithms (out of scope for Fetch itself).
4. Set **response tainting** to `"basic"` as the default, later overridden per [[fetch-cors|mode in HTTP fetch]].
5. If `request.localURLsOnly` is set and the current URL isn't local (`about:`, `blob:`, `data:`, `file:`), return a network error.
6. Populate `request.client`/`request.policyContainer`/`request.origin` from the resolved values.
7. Resolve the request's referrer: either `"client"` (the environment's URL) or an explicit URL; see [[fetch-referrer-policy]].
8. Invoke [[fetch-algorithm|scheme fetch]] with the request.
9. If a response was returned and it's not a network error, run response-processing steps (CSP, extra headers, `Cross-Origin-Resource-Policy` checks) before the response is handed to the caller's `processResponse`.

## Scheme Fetch

Routes purely by `request.url`'s scheme:

| Scheme | Handling |
|---|---|
| `about:` | Returns an empty `text/html` response for `about:blank` / `about:srcdoc`; network error otherwise |
| `blob:` | Delegates to the File API's blob URL fetch |
| `data:` | Parses the `data:` URL body per RFC 2397, returns a response with the decoded body and declared MIME type |
| `file:` | System-dependent; unspecified in detail, implementation-defined |
| `http:` / `https:` | Invokes [[fetch-http-fetch|HTTP fetch]] |
| anything else | Network error |

## See Also

- [[fetch-http-fetch]]
- [[fetch-redirect]]
- [[fetch-request-response]]
- [[fetch-cors]]
- [[fetch-abort]]
- [[fetch-referrer-policy]]
- [[fetch-security-considerations]]
- [[fetch-network-error]]

## Sources

- https://fetch.spec.whatwg.org/#fetching
- https://fetch.spec.whatwg.org/#concept-main-fetch
- https://fetch.spec.whatwg.org/#concept-scheme-fetch
