---
spec: url
tags: [algorithm]
updated: 2026-07-02
---

# URL Serialization

The **URL serializer** takes a [[url-record]] and an optional boolean `excludeFragment` (default false), returning an ASCII string.

## URL Serializer Steps

1. `output = url.scheme + ":"`
2. If `url.host` is not null:
   - Append `//`.
   - If URL includes credentials: append `url.username`; if password non-empty, append `:` + `url.password`; append `@`.
   - Append serialized host (see [[url-host-parsing]]).
   - If `url.port` is not null: append `:` + `url.port`.
3. If host is null:
   - If URL has opaque path and path starts with `//`: append `/.` (to avoid `scheme:///path` being misread as an authority).
4. Append serialized path (see below).
5. If `url.query` is not null: append `?` + `url.query`.
6. If not `excludeFragment` and `url.fragment` is not null: append `#` + `url.fragment`.
7. Return `output`.

## Path Serialization

- **Opaque path** (single string) → append the string directly.
- **List path** → for each segment, append `/` + segment.

An empty path on a non-special URL outputs nothing. An empty path on a special URL outputs `/`.

## Includes Credentials

A URL **includes credentials** when `username ≠ ""` or `password ≠ ""`.

## Origin and Serialization

A URL's **origin** depends on its scheme:
- `blob:` URLs → origin of the inner URL.
- `ftp`, `http`, `https`, `ws`, `wss` → tuple origin `(scheme, host, port, null)`.
- `file:` → opaque origin (implementation-defined).
- Everything else → opaque origin.

**Origin serialization**: `scheme + "://" + host + (port ? ":" + port : "")`.

## See Also

- [[url-record]]
- [[url-host-parsing]]
- [[url-api]]
- [[uri-reference-resolution]] — RFC 3986 §5.3 component recomposition, this serializer's ancestor
- [[uri-normalization]]
- [[url-idempotence]] — the round-trip guarantee this serializer participates in

## Sources

- https://url.spec.whatwg.org/#concept-url-serializer
- https://url.spec.whatwg.org/#concept-url-origin
