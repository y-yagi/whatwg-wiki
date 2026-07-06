---
spec: url
tags: [concept]
updated: 2026-07-01
---

# URL Validation Errors

Validation errors are **non-fatal warnings** emitted by the [[url-parsing-algorithm]] for inputs that are parseable but use legacy, ambiguous, or technically invalid syntax — except for a specific subset (see Fatal vs. Non-fatal below) that abort parsing outright. Parsers that expose validation errors (e.g., for tooling, linting, or spec-conformance testing) are expected to report every one of them, fatal or not; the spec doesn't mandate any particular user-facing treatment.

## Full Reference

| Error | Emitted when |
|-------|-------------|
| `domain-to-ASCII` | IDNA processing of a domain fails or returns empty string |
| `domain-invalid-code-point` | Domain contains a forbidden domain code point |
| `host-invalid-code-point` | Opaque host contains a forbidden host code point |
| `host-missing` | Special URL has an authority but no host |
| `IPv4-empty-part` | IPv4 address has a trailing `.` (e.g., `1.2.3.4.`) |
| `IPv4-too-few-parts` | Fewer than 4 `.`-separated parts in a potential IPv4 (legacy shorthand, e.g. `1.2.3` or a bare decimal) |
| `IPv4-too-many-parts` | More than 4 `.`-separated parts in a potential IPv4 |
| `IPv4-non-decimal-part` | IPv4 part uses hex (`0x`) or octal (`0`) notation |
| `IPv4-non-numeric-part` | Part contains non-digit characters |
| `IPv4-out-of-range-part` | Part value exceeds 255 (for non-final parts) |
| `IPv4-non-ASCII-input` | Domain "ends in a number" but the domain string itself isn't all-ASCII at that point |
| `IPv6-unclosed` | `[...]` host is missing the closing `]` |
| `IPv6-invalid-compression` | IPv6 address begins with improper `::` compression |
| `IPv6-too-many-pieces` | IPv6 address has more than 8 pieces |
| `IPv6-multiple-compression` | IPv6 address is compressed (`::`) in more than one spot |
| `IPv6-invalid-code-point` | A code point that's neither an ASCII hex digit nor `:`, or the address unexpectedly ends |
| `IPv6-too-few-pieces` | An uncompressed IPv6 address has fewer than 8 pieces |
| `IPv6-piece-leading-zero` | An IPv6 piece has a leading `0` (e.g., `0042` instead of `42`) |
| `IPv4-in-IPv6-too-many-pieces` | Mixed-notation IPv6 address has more than 6 pieces before the embedded IPv4 part |
| `IPv4-in-IPv6-invalid-code-point` | Embedded IPv4 part is empty, non-digit, has a leading zero, or has too many dot-separated parts |
| `IPv4-in-IPv6-out-of-range-part` | Embedded IPv4 part exceeds 255 |
| `IPv4-in-IPv6-too-few-parts` | Embedded IPv4 part has fewer than 4 dot-separated parts |
| `invalid-URL-unit` | Input contains a code point not in the URL units set |
| `invalid-credentials` | URL contains credentials but host doesn't allow them |
| `missing-scheme-non-relative-URL` | Relative URL input but no base URL provided |
| `port-out-of-range` | Port number > 65535 |
| `port-invalid` | Port contains non-digit characters |
| `special-scheme-missing-following-solidus` | `http:foo` instead of `http://foo` |

See [[url-ipv4]] and [[url-ipv6]] for the algorithms that emit the IPv4/IPv6-specific rows above.

## Fatal vs. Non-fatal

Most validation errors are **non-fatal** — parsing continues and produces a URL. The parser only **returns failure** for:
- Missing scheme with no valid base
- Port > 65535
- Host parsing failure in a context that requires a valid host
- `IPv4-too-many-parts` (host parsing failure — see [[url-ipv4]])
- Unclosed IPv6 bracket, or any other IPv6 parse failure except `IPv6-piece-leading-zero`

## See Also

- [[url-parsing-algorithm]]
- [[url-host-parsing]]
- [[url-ipv4]]
- [[url-ipv6]]
- [[url-record]] — `invalid-credentials` and `port-out-of-range` are direct consequences of the record's credential/default-port rules
- [[url-concepts]] — non-fatal-warning summary; this page is the full error reference
- [[uri-security-considerations]] — RFC 3986 §7.4 names the IP-format ambiguity these errors close off

## Sources

- https://url.spec.whatwg.org/#validation-error
