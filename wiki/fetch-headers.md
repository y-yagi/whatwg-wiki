---
spec: fetch
tags: [interface]
updated: 2026-07-06
---

# Headers Interface and Header List

The `Headers` JS interface (Section 5.1) wraps an internal ordered **header list** of (name, value) byte-sequence tuples, shared by [[fetch-request-response|`Request` and `Response`]].

## Header List Operations

- **Get**: returns the combined value for a name — values from multiple headers of the same name are joined with `", "`, *except* `Set-Cookie`, which is never combined (each stays a separate entry, since cookie syntax uses commas internally).
- **Set**: replaces the first matching header's value and removes the rest, or appends if none exist.
- **Append**: adds a new entry, preserving any existing ones with the same name (used to build up multi-value headers like `Set-Cookie` or repeated `Accept-Language`).
- **Delete**: removes all entries matching a name.
- **Combine**: append-if-new, else extend the existing value with `", "` — the primitive `append()` on the JS `Headers` object is actually built from this.
- **Contains**: byte-case-insensitive name match.

## Headers JS Interface

`new Headers(init)` — `init` optional: an iterable of `[name, value]` pairs or a record/object.

Methods: `append(name, value)`, `delete(name)`, `get(name)`, `has(name)`, `set(name, value)`, `getSetCookie()` (returns all `Set-Cookie` values as an array, the one deliberate exception to header combining above), plus iteration (`entries()`, `keys()`, `values()`, `forEach()`) in sorted-by-name order.

## Guards

Each `Headers` instance is created with a **guard** that restricts what `append`/`delete`/`set` are allowed to do, silently no-oping or throwing depending on the guard:

| Guard | Used for | Restriction |
|---|---|---|
| `"immutable"` | Responses to `no-cors` requests, `Response.error()` | No mutation permitted at all |
| `"request"` | `Request.headers` | Forbidden request-header names blocked; `Sec-*`/`Proxy-*` prefixes blocked |
| `"request-no-CORS"` | `Request` headers when `mode: "no-cors"` | Only CORS-safelisted names, or the additional no-CORS-safelisted set, may be set |
| `"response"` | `Response.headers` | Forbidden response-header names (`Set-Cookie`, `Set-Cookie2`) blocked |
| `"none"` | Internal/free-standing `Headers` | No restriction |

## Forbidden Request Headers

Names the user agent reserves for itself and that script cannot set via `fetch()`/`XMLHttpRequest`/`Request`: `Accept-Charset`, `Accept-Encoding`, `Access-Control-Request-Headers`, `Access-Control-Request-Method`, `Connection`, `Content-Length`, `Cookie`, `Cookie2`, `Date`, `DNT`, `Expect`, `Host`, `Keep-Alive`, `Origin`, `Referer`, `Set-Cookie`, `TE`, `Trailer`, `Transfer-Encoding`, `Upgrade`, `Via`, and any header starting with `Proxy-` or `Sec-` (the latter reserved so [[fetch-security-considerations|browser-set security signals]] like `Sec-Fetch-Mode` can't be spoofed by page script).

## Forbidden Response Headers

`Set-Cookie`, `Set-Cookie2` — blocked from the `"response"` guard so that a `Response` constructed by script (e.g. in a service worker) cannot inject cookies via the JS API; the network layer still honors real `Set-Cookie` headers from the server, which reach script only through `getSetCookie()`, not general header inspection.

## See Also

- [[fetch-request-response]]
- [[fetch-cors]]
- [[fetch-credentials-mode]]
- [[fetch-security-considerations]]

## Sources

- https://fetch.spec.whatwg.org/#headers-class
- https://fetch.spec.whatwg.org/#concept-header-list
- https://fetch.spec.whatwg.org/#forbidden-request-header
- https://fetch.spec.whatwg.org/#forbidden-response-header-name
