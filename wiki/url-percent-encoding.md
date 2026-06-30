---
spec: url
tags: [algorithm, concept]
updated: 2026-07-01
---

# Percent Encoding

Percent-encoding converts a byte or code point into the `%XX` escape form. The URL spec defines specific **percent-encode sets** that determine which characters must be encoded in each URL component.

## Core Algorithm: UTF-8 percent-encode

Takes a **code point** and a **percent-encode set**:
1. If code point is in the percent-encode set → percent-encode it.
2. Otherwise → return as-is.

**Percent-encode a byte**: return `%` followed by the byte's value as two uppercase hex digits.

**Percent-encode a code point**: encode as UTF-8, then percent-encode each byte.

## Percent-Encode Sets

Sets form a hierarchy — each extends the previous:

| Set | Used for | Includes |
|-----|----------|----------|
| **C0 percent-encode set** | Base; opaque paths, hosts | C0 controls (U+0000–U+001F) and code points > U+007E |
| **Fragment percent-encode set** | Fragment | C0 set + `space ` `` ` `` `"` `<` `>` |
| **Query percent-encode set** | Non-special query | Fragment set + `#` `'` (no `<>` removed) |
| **Special query percent-encode set** | Special URL query | Query set + `'` |
| **Path percent-encode set** | Path segments | Query set + `?` `` ` `` `{` `}` |
| **Userinfo percent-encode set** | username, password | Path set + `/` `:` `;` `=` `@` `[`..`^` `` | `` |
| **Component percent-encode set** | `encodeURIComponent` equivalent | Userinfo set + `$`..`&` `+` `,` |
| **Application/x-www-form-urlencoded percent-encode set** | Form data | Component set + `!` `'`..`)` `~` |

## application/x-www-form-urlencoded Serializer

Used by `URLSearchParams` serialization:
- Encode each name and value using the **application/x-www-form-urlencoded** set.
- Additionally: replace `0x20` (space) with `+` (not `%20`).
- Join pairs as `name=value`, separated by `&`.

## Percent Decoding

**Percent-decode a string**: find `%XX` sequences, decode the hex, interpret as UTF-8. Invalid sequences are preserved as-is (the `%` is kept).

**Percent-decode a byte sequence**: similar but works on raw bytes.

## See Also

- [[url-parsing-algorithm]]
- [[url-api]]
- [[uri-reserved-characters]] — RFC 3986's reserved/unreserved split that this hierarchy refines

## Sources

- https://url.spec.whatwg.org/#percent-encoded-bytes
- https://url.spec.whatwg.org/#percent-encode-after-encoding
