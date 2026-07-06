---
spec: fetch
tags: [interface, algorithm]
updated: 2026-07-06
---

# Body Mixin

The shared interface (Section 5.3) giving [[fetch-request-response|`Request` and `Response`]] a uniform way to expose and consume their payload as a stream, backed by the Streams Standard.

## Internal Body Concept

A body is a struct of:
- **stream** — a `ReadableStream` of bytes.
- **source** — the original value the body was constructed from (`null`, a byte sequence, `Blob`, or `FormData`), retained so `clone()` can produce an independent copy without re-reading the stream.
- **length** — `null` or a known byte length (used to set `Content-Length` when possible).

## Body Operations

- **Clone body**: `tee()`s the stream into two branches; the original body keeps one branch, the clone gets the other — both remain independently readable.
- **Get byte sequence as body**: wraps a plain byte sequence into a body struct without going through a stream reader.
- **Fully read**: asynchronously drains the entire stream into a single byte sequence (used internally by `text()`, `json()`, `blob()`, `arrayBuffer()`, `bytes()`, `formData()`), driving a reader chunk-by-chunk and concatenating.
- **Incrementally read**: lower-level primitive used by the network layer to process chunks as they arrive rather than buffering the whole body (relevant to streaming request bodies and to how [[fetch-http-fetch|HTTP-network fetch]] writes bytes to the wire as they're produced).

## Body Interface Properties and Methods

- `body` — the `ReadableStream`, or `null` if there is none.
- `bodyUsed` — `true` once the stream has started being consumed or is disturbed/locked.
- `arrayBuffer()`, `blob()`, `bytes()`, `formData()`, `json()`, `text()` — each returns a `Promise` that fully reads the body and converts it:
  1. If `bodyUsed` is already `true`, or the stream is locked/disturbed, reject with `TypeError`.
  2. Set `bodyUsed` to `true`.
  3. If body is `null`, resolve immediately with the type-appropriate empty value (`""`, empty `ArrayBuffer`, empty `Blob`, `null` for `json()` throwing a parse error instead, etc.).
  4. Otherwise fully read the stream, apply `Content-Encoding` decoding (gzip/deflate/br) if declared, then convert: `text()` UTF-8 decodes; `json()` UTF-8 decodes then `JSON.parse`s; `blob()`/`arrayBuffer()`/`bytes()` return the raw bytes in the requested container; `formData()` parses per `Content-Type` (`multipart/form-data` or `application/x-www-form-urlencoded`).

## Streams Integration

The body's `ReadableStream` is a first-class Streams Standard object: it can be piped, tee'd, or read manually with a reader, which is what makes `clone()` and incremental network writes possible without buffering an entire response in memory. A body stream that's been read via `getReader()` and locked cannot be cloned or re-consumed through the Body methods — both paths throw `TypeError` rather than silently truncating data.

## See Also

- [[fetch-request-response]]
- [[fetch-http-fetch]]
- [[fetch-headers]]

## Sources

- https://fetch.spec.whatwg.org/#body-mixin
- https://fetch.spec.whatwg.org/#concept-body
- https://fetch.spec.whatwg.org/#concept-body-consume-body
