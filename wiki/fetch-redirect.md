---
spec: fetch
tags: [algorithm]
updated: 2026-07-06
---

# HTTP-Redirect Fetch

Handles HTTP redirect responses (status `301`, `302`, `303`, `307`, `308`) returned from [[fetch-http-fetch|HTTP-network-or-cache fetch]], deciding whether and how to re-issue the request.

## Steps

1. Extract the `Location` header from the response; if absent, return the response as-is (not treated as a redirect).
2. Parse `Location` relative to the response's URL. If parsing fails, return a network error. (Fragment-only Location values resolve relative to the request's current URL, not stripped.)
3. If `request.redirectMode` is `"error"`, return a network error immediately.
4. If `request.redirectMode` is `"manual"`, return an **opaque-redirect filtered response** without following it — the caller (e.g. a service worker) must decide.
5. Check the redirect count: if `request.redirectCount` ≥ 20, return a network error (loop protection).
6. Increment `request.redirectCount`.
7. If the new URL's scheme is not an HTTP(S) scheme and this isn't a same-origin-safe case, return a network error.
8. Method/body rewriting:
   - **303 See Other**: always rewrite method to `GET` and clear the body, regardless of original method.
   - **301/302** from an original method of `POST`: rewrite to `GET`, clear body (legacy user-agent behavior, not in the original HTTP spec but required for web compatibility).
   - **307/308**: preserve the original method and body unchanged.
9. Strip the `Authorization` header when the redirect target has a different origin (host, scheme, or port).
10. Update `request.url` and append it to `request.urlList` — the full redirect chain is tracked internally, but only `response.url` (the final URL) and `response.urlList` are exposed to JavaScript, so pages in the middle of a redirect chain aren't leaked to unauthorized code.
11. Recursively invoke [[fetch-algorithm|main fetch]] with the updated request.

## Response Types for Redirects

- Following a redirect to completion yields whatever response type the final resource produces (`"basic"`, `"cors"`, etc.) — see [[fetch-cors|response tainting]].
- `redirectMode: "manual"` yields `response.type === "opaqueredirect"`: status forced to `0`, headers emptied, body null — used by service workers that want to forward a redirect to the client without inspecting it.

## See Also

- [[fetch-algorithm]]
- [[fetch-http-fetch]]
- [[fetch-request-response]]
- [[fetch-cors]]
- [[fetch-security-considerations]]

## Sources

- https://fetch.spec.whatwg.org/#http-redirect-fetch
