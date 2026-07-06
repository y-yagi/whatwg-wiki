---
spec: fetch
tags: [algorithm, interface]
updated: 2026-07-06
---

# Abort and AbortController Integration

`request.signal` (an `AbortSignal`) lets a caller cancel an in-flight fetch cooperatively, propagating through the [[fetch-algorithm|fetch controller]] returned by the top-level fetch algorithm.

## Fetch Controller

Created fresh for each call to [[fetch-algorithm|fetch()]], holding:
- **state**: `"ongoing"`, `"terminated"`, or `"aborted"`.
- **full timing info** and **report timing steps**, used regardless of outcome.
- **serialized abort reason**: captured via `StructuredSerialize` so the reason (any value, not just an `Error`) survives across realms/threads (e.g. to a worker).
- **next manual redirect steps**: state for `redirect: "manual"` handling.

## Abort Flow

1. Script calls `controller.abort(reason)` (or the signal fires for another reason, e.g. a linked timeout signal).
2. The fetch controller's abort algorithm runs: state is set to `"aborted"`, the reason is structured-serialized and stored.
3. Any pending network operation (connection, TLS handshake, in-flight read) is torn down.
4. [[fetch-body|Body]] streams associated with the request/response are errored with the abort reason.
5. The overall fetch's promise rejects with the abort reason (or a generic `AbortError` `DOMException` if none was given), rather than resolving with a network-error response — abort is distinguished from ordinary network failure at the JS-visible layer.

## Fetch Params Cancellation Check

Internally, most steps of [[fetch-algorithm|main fetch]]/[[fetch-http-fetch|HTTP fetch]] periodically check "fetch params is canceled", true when the controller's state is `"aborted"` or `"terminated"` — this is how a long-running body read or redirect chain notices an abort promptly rather than only at the next natural checkpoint.

## See Also

- [[fetch-algorithm]]
- [[fetch-request-response]]
- [[fetch-body]]

## Sources

- https://fetch.spec.whatwg.org/#fetch-controller
- https://fetch.spec.whatwg.org/#dom-request-signal
- https://dom.spec.whatwg.org/#interface-abortcontroller
