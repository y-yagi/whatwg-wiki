---
spec: url
tags: [algorithm, parser]
updated: 2026-07-05
---

# URL Parsing Algorithm

The **basic URL parser** is a state machine that takes a scalar value string input and optionally a base URL and encoding, producing a [[url-record]] or failure.

## Invocation

Two entry points both delegate to the basic parser:

- **Parse a URL** — wrapper that takes `input` + optional `base`, returns URL record or failure.
- **Parse relative** — used when a base URL is required (e.g., resolving `./foo` against `https://example.com/`).

## Inputs

| Parameter | Type | Default |
|-----------|------|---------|
| input | string (will be stripped of leading/trailing C0 whitespace and tabs/newlines with a validation warning) | required |
| base | URL record or null | null |
| encoding | encoding label | UTF-8 |
| url | URL record | new URL record |
| stateOverride | parser state or null | null |

`stateOverride` is used by the `URL` API setter implementations (e.g., `href=`, `host=`) to re-enter the parser at a specific state.

## Processing Model

1. Strip leading/trailing ASCII tab or newline; emit `invalid-URL-unit` validation error for each removed character.
2. Strip leading/trailing C0 control or space; emit `invalid-URL-unit` validation error if any removed.
3. Process input as a stream of Unicode code points using a **pointer** (integer, starts at 0, -1 = before start, EOF = beyond end).
4. Each iteration reads `c` (code point at pointer, or EOF) and dispatches to the current **state**.
5. States can change the current state, advance or rewind the pointer, append to accumulator buffers, or set fields on the URL being constructed.

## Key States (overview)

See [[url-parser-states]] for the full state reference.

- **Scheme start** — entry state for every parse; dispatches to Scheme or No scheme based on the first character.
- **No scheme** — determine if URL is relative or absolute based on first character and base URL presence.
- **Scheme** — accumulate and classify the scheme.
- **Special relative or authority** / **Path or authority** — disambiguate `//` authority from path.
- **Authority** — parse username, password, host, port.
- **Host** / **Hostname** / **Port** — parse host string and optional port number.
- **Path** — accumulate path segments, applying dot-segment normalization.
- **Query** — accumulate the query string; switch to percent-encode set based on special-ness.
- **Fragment** — accumulate the fragment (not percent-decoded in the record itself).

## Failure Conditions

The parser returns **failure** on unrecoverable errors such as:
- Missing scheme (when no base is given)
- Missing host in a special URL with authority
- Invalid port number (non-16-bit integer, port > 65535)
- Host parsing failure for the host component

The "missing scheme when no base is given" condition is precisely the limitation that motivates [[concept-url-531-relative-url-debate|an ongoing community request]] to let the parser (or a sibling API) accept and represent relative-only input with no base at all; see also the commonly-used [[concept-fake-base-url-workaround|fake-base-URL workaround]] for this exact failure.

The [[url-parser-states|hostname state]] override is also the site of a separate spec-authoring gap: [[urlpattern-canonicalization|URLPattern's canonicalization steps]] invoke this parser with a dummy URL record whose "special-ness" the spec didn't clearly define, and whose hostname-state failures weren't reliably reported back to the caller — see [[concept-urlpattern-252-dummy-url-ambiguity]].

## See Also

- [[url-record]]
- [[url-parser-states]]
- [[url-host-parsing]]
- [[url-percent-encoding]]
- [[urlpattern-base-url]] — how `URLPattern` reuses this parser's relative-resolution mechanics for pattern strings
- [[uri-reference-resolution]] — RFC 3986's relative-reference resolution algorithm, this parser's conceptual ancestor
- [[uri-vs-whatwg-url]]
- [[url-idempotence]] — the parse/serialize round-trip guarantee this algorithm's unconditional normalization exists to satisfy
- [[concept-url-531-relative-url-debate]]
- [[concept-fake-base-url-workaround]]
- [[concept-urlpattern-252-dummy-url-ambiguity]]
- [[concept-urlpattern-54-canonicalization-origin]]

## Sources

- https://url.spec.whatwg.org/#concept-url-parser
- https://url.spec.whatwg.org/#basic-url-parser
