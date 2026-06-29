---
spec: url
tags: [concept, interface]
updated: 2026-06-30
---

# URL Record

A URL record is the internal representation of a URL — a struct of typed fields that parsers produce and serializers consume. It is distinct from the JavaScript `URL` object, which wraps a URL record.

## Fields

| Field | Type | Initial value |
|-------|------|---------------|
| scheme | ASCII string | `""` |
| username | ASCII string | `""` |
| password | ASCII string | `""` |
| host | null, empty string, domain, IPv4, IPv6, or opaque host | null |
| port | null or 16-bit unsigned integer | null |
| path | URL path (opaque segment or list of segments) | `« »` |
| query | null or ASCII string | null |
| fragment | null or ASCII string | null |
| blob URL entry | null or blob URL entry | null |

## Key Properties

**Has an opaque path**: path is a URL path segment (a single string), not a list. Such URLs cannot have authority (username, password, port).

**Includes credentials**: username or password is non-empty.

**Cannot have username/password/port**: when host is null or `""`, or scheme is `file`.

**Is special**: scheme is one of `ftp`, `file`, `http`, `https`, `ws`, `wss`. Special URLs have stricter parsing rules and default ports.

**Default ports by scheme**: `ftp`→21, `http`/`ws`→80, `https`/`wss`→443. A port field equal to the scheme default is nullified during parsing.

## Path Types

- **Opaque path**: a single ASCII string segment — used for non-special URLs without authority (e.g., `data:text/plain,hello`).
- **List path**: a list of zero or more URL path segment strings, one per `/`-separated component.

**Single-dot segments**: `.` or case-insensitive `%2e` — removed during path shortening.

**Double-dot segments**: `..`, `.%2e`, `%2e.`, `%2e%2e` (case-insensitive) — cause the parent segment to be popped.

## See Also

- [[url-parsing-algorithm]]
- [[url-serialization]]
- [[url-host]]
- [[url-api]]

## Sources

- https://url.spec.whatwg.org/#concept-url
