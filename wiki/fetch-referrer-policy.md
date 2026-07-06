---
spec: fetch
tags: [algorithm, security]
updated: 2026-07-06
---

# Referrer and Referrer Policy Handling

Fetch computes and attaches the `Referer` header (note the header name's historical misspelling) according to the request's referrer policy, itself defined by the separate Referrer Policy spec but invoked from within [[fetch-algorithm|main fetch]].

## Determining the Referrer

1. If `request.referrer` is the literal `"no-referrer"`, no `Referer` header is sent.
2. If it's `"client"`, resolve to the request's client's associated document/worker URL.
3. Otherwise it's an explicit URL supplied by the caller (e.g. `fetch(url, { referrer })`).

## Applying Referrer Policy

`request.referrerPolicy` (one of `no-referrer`, `no-referrer-when-downgrade`, `same-origin`, `origin`, `strict-origin`, `origin-when-cross-origin`, `strict-origin-when-cross-origin` (the default), `unsafe-url`) is applied to strip or reduce the referrer before sending:

- **Cross-origin requests**: policies like `origin`/`strict-origin`/`origin-when-cross-origin` reduce the referrer to just the scheme+host+port, dropping path/query/fragment.
- **HTTPS→HTTP downgrade**: `strict-origin`/`strict-origin-when-cross-origin`/`no-referrer-when-downgrade` suppress the referrer entirely to avoid leaking a secure context's URL to an insecure destination.
- **`unsafe-url`**: always sends the full referrer URL regardless of origin/scheme changes — discouraged, since it leaks the most information, but sometimes required for legacy interop.
- The referrer is never sent with user credentials or password components — those are stripped from the URL before it's ever considered a candidate value.

## Setting the Header

If the computed referrer isn't suppressed, it's serialized and set as the `Referer` request header — this happens as part of [[fetch-algorithm|main fetch]]'s referrer resolution step, before scheme routing, so it's present by the time [[fetch-http-fetch|HTTP fetch]] sends the request.

## See Also

- [[fetch-algorithm]]
- [[fetch-http-fetch]]
- [[fetch-security-considerations]]
- [[fetch-cors]]

## Sources

- https://fetch.spec.whatwg.org/#determine-requests-referrer
- https://fetch.spec.whatwg.org/#request-referrer-policy
- https://w3c.github.io/webappsec-referrer-policy/
