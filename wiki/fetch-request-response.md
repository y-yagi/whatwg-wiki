---
spec: fetch
tags: [interface]
updated: 2026-07-06
---

# Request and Response Interfaces

The JavaScript-facing wrappers (Section 5) around the internal **request** and **response** concepts that drive the [[fetch-algorithm|fetch algorithm]].

## Request

```
new Request(input, init)
```

- `input`: a URL string, or an existing `Request` (whose settings are copied, and whose body — if unused — is transferred/cloned).
- `init` (`RequestInit`): `method`, `headers`, `body`, `mode`, `credentials`, `cache`, `redirect`, `integrity`, `keepalive`, `signal`, `referrer`, `referrerPolicy`, `priority`.

Read-only properties: `method`, `url` (serialized), `headers` (a [[fetch-headers|`Headers`]] object with `"request"`/`"request-no-CORS"` guard), `destination`, `mode`, `credentials`, `cache`, `redirect`, `referrerPolicy`, `integrity`, `keepalive`, `isReloadNavigation`, `isHistoryNavigation`, `signal` (`AbortSignal`, see [[fetch-abort]]).

`clone()` returns a deep copy: the body stream is `tee()`'d so both the original and the clone can be read independently, and a fresh internal identity is assigned. Throws if the body is already disturbed or locked.

## Response

```
new Response(body, init)
```

- `body`: optional — `ReadableStream`, `Blob`, `BufferSource`, `FormData`, `URLSearchParams`, or string.
- `init` (`ResponseInit`): `status` (200–599 by default constructor constraints, though internal responses can be 0–999), `statusText`, `headers`.

Static constructors:
- `Response.error()` — a [[fetch-network-error|network error]] response (`type: "error"`, status `0`, no headers/body).
- `Response.redirect(url, status)` — a redirect response with `Location` set; `status` must be one of 301/302/303/307/308.
- `Response.json(data, init)` — serializes `data` via `JSON.stringify` and sets `Content-Type: application/json`.

Read-only properties: `status`, `statusText`, `headers` (`"response"` guard), `ok` (true iff status 200–299), `type` (`"basic"`/[[fetch-cors|`"cors"`]]/`"default"`/`"error"`/[[fetch-cors|`"opaque"`]]/[[fetch-redirect|`"opaqueredirect"`]]), `url` (last entry of the internal URL list, empty string if the list is empty), `redirected` (true iff the URL list has more than one entry), `body`.

`clone()` behaves like `Request.clone()`; throws on a disturbed/locked body.

## The Guard Concept

Every `Headers` object carries an internal **guard** that constrains which headers can be added/removed through the JS API, independent of what the underlying network layer will actually send. See [[fetch-headers]] for the full guard list (`"immutable"`, `"request"`, `"request-no-CORS"`, `"response"`, `"none"`) — guards are what stop script from setting `Cookie` on a `Request` or reading `Set-Cookie` off a `no-cors` `Response`, without needing separate validation logic scattered through the constructors.

## Body Access

Both interfaces mix in the shared [[fetch-body|Body]] interface (`body`, `bodyUsed`, `arrayBuffer()`, `blob()`, `bytes()`, `formData()`, `json()`, `text()`).

## See Also

- [[fetch-headers]]
- [[fetch-body]]
- [[fetch-cors]]
- [[fetch-abort]]
- [[fetch-algorithm]]
- [[fetch-redirect]]
- [[fetch-network-error]]

## Sources

- https://fetch.spec.whatwg.org/#request-class
- https://fetch.spec.whatwg.org/#response-class
- https://fetch.spec.whatwg.org/#concept-request
- https://fetch.spec.whatwg.org/#concept-response
