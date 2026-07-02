---
spec: url
tags: [concept]
updated: 2026-07-02
---

# URL Key Concepts

Cross-cutting concepts in the WHATWG URL spec that span multiple algorithms.

## Special URLs

A URL is **special** if its scheme is one of: `ftp`, `file`, `http`, `https`, `ws`, `wss`.

Special URLs have different parsing rules:
- `\` is treated as `/` in paths (with a validation error).
- Host must be non-null and non-empty.
- Default ports are defined and automatically nullified.
- Query uses the **special-query percent-encode set** (encodes `'`).

Default ports: `ftp`→21, `http`/`ws`→80, `https`/`wss`→443.

## Base URL

A **base URL** is a URL record used to resolve relative references. When parsing a relative URL like `/path` or `../other`, the base URL provides the scheme, host, and path context.

The browser's base URL for a document comes from the `<base href>` element or the document's own URL.

## Opaque Origins vs. Tuple Origins

- **Tuple origin**: `(scheme, host, port, null)` — for http/https/ftp/ws/wss URLs. Two URLs have the same origin if all four components match.
- **Opaque origin**: an internal value, unique and never equal to anything else. Used by `file:` URLs and non-special non-blob URLs.

Defining origin is one of the URL Standard's explicit [[url-goals|goals]]: it supersedes RFC 6454 ("The Web Origin Concept") rather than deferring to it as a separate document.

## Windows Drive Letters

For `file:` URLs on Windows, the spec handles drive letter paths like `C:\`:
- A **Windows drive letter** is two characters: ASCII alpha + `:` or `|`.
- A **normalized** Windows drive letter uses `:` (not `|`).
- Detected during File Slash and File Host parser states.
- Example: `file:///C:/path` has path `["C:", "path"]`.

## Opaque Path

A URL has an **opaque path** when:
- It has no authority (no host), AND
- It is not a special URL, AND  
- The path is a single string (not a list of segments).

Example: `data:text/plain,hello` has an opaque path `text/plain,hello`.
Opaque-path URLs cannot have a username, password, or port.

## Blob URLs

`blob:` URLs are created by `URL.createObjectURL()`. They:
- Have an inner URL (e.g., `blob:https://example.com/uuid`).
- Have a **blob URL entry** in the URL store mapping to a `Blob` object.
- Derive their origin from the inner URL's origin.
- Are stored in the **blob URL store** and revoked with `URL.revokeObjectURL()`.

## URL Equivalence

Two URLs are **equal** when their serializations (excluding fragment) are identical. This is used for navigation (same-document vs. cross-document).

## Validation Errors

Validation errors are non-fatal warnings emitted during parsing for inputs that are technically valid but potentially problematic or use legacy formats. They do not cause parsing failure. Examples: `invalid-URL-unit`, `IPv4-non-decimal-part`, `domain-to-ASCII`.

## See Also

- [[url-record]]
- [[url-parsing-algorithm]]
- [[url-host]]
- [[url-serialization]]
- [[url-validation-errors]] — full reference table of every named validation error
- [[uri-vs-whatwg-url]] — special schemes, base URLs, and equivalence contrasted against RFC 3986
- [[url-goals]] — origin, terminology, and idempotence as stated spec objectives

## Sources

- https://url.spec.whatwg.org/#concept-url-origin
- https://url.spec.whatwg.org/#url-miscellaneous
- https://url.spec.whatwg.org/#concept-blob-url-entry
