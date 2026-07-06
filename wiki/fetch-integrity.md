---
spec: fetch
tags: [algorithm, security]
updated: 2026-07-06
---

# Subresource Integrity (SRI) in Fetch

`request.integrity` carries a Subresource Integrity metadata string (e.g. `"sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"`), populated from HTML attributes like `<script integrity="...">` and verified as part of [[fetch-http-fetch|HTTP-network fetch]].

## Verification Steps

1. If `request.integrity` is the empty string, skip verification entirely — no hash was requested.
2. Once the response body is fully received (verification requires the complete body, so it cannot happen incrementally on a streaming response), parse the integrity string into a list of `algorithm-base64value` pairs (e.g. multiple hashes may be given; the strongest supported algorithm is used per the SRI spec's precedence rules).
3. Compute the digest of the response body bytes using each listed algorithm.
4. If none of the computed digests match a provided value, replace the response with a **network error** — the resource is treated as if the fetch failed outright, not merely as an invalid resource.
5. Otherwise, the original response proceeds unchanged.

## Why Fetch, Not HTML/SRI Alone

The check is performed inside Fetch (rather than purely in the consuming spec) because it needs access to the raw response bytes before any [[fetch-body|Body consumption]] or caching decisions finalize, and because it must apply uniformly regardless of which API (`<script>`, `<link>`, `fetch()`) initiated the request.

## Security Role

Integrity metadata protects against a compromised or MITM'd CDN silently serving different content for a resource embedded by hash — without it, `Content-Security-Policy` origin allowlisting alone permits any content the trusted origin serves, including content an attacker manages to substitute. See [[fetch-security-considerations]] for how this fits alongside CORS and CSP as defense layers.

## See Also

- [[fetch-http-fetch]]
- [[fetch-security-considerations]]
- [[fetch-request-response]]

## Sources

- https://fetch.spec.whatwg.org/#concept-request-integrity-metadata
- https://fetch.spec.whatwg.org/#integrity-metadata
- https://www.w3.org/TR/SRI/
