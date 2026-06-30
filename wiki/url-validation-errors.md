---
spec: url
tags: [concept]
updated: 2026-06-30
---

# URL Validation Errors

Validation errors are **non-fatal warnings** emitted by the [[url-parsing-algorithm]] for inputs that are parseable but use legacy, ambiguous, or technically invalid syntax. Parsers that expose validation errors (e.g., for tooling) should report these; browsers typically ignore them silently.

## Full Reference

| Error | Emitted when |
|-------|-------------|
| `domain-to-ASCII` | IDNA processing of a domain fails or returns empty string |
| `domain-invalid-code-point` | Domain contains a forbidden domain code point |
| `host-invalid-code-point` | Opaque host contains a forbidden host code point |
| `host-missing` | Special URL has an authority but no host |
| `IPv4-empty-part` | IPv4 address has a trailing `.` (e.g., `1.2.3.4.`) |
| `IPv4-non-decimal-part` | IPv4 part uses hex (`0x`) or octal (`0`) notation |
| `IPv4-too-many-parts` | More than 4 `.`-separated parts in a potential IPv4 |
| `IPv4-non-numeric-part` | Part contains non-digit characters |
| `IPv4-out-of-range-part` | Part value exceeds 255 (for non-final parts) |
| `invalid-URL-unit` | Input contains a code point not in the URL units set |
| `invalid-credentials` | URL contains credentials but host doesn't allow them |
| `missing-scheme-non-relative-URL` | Relative URL input but no base URL provided |
| `port-out-of-range` | Port number > 65535 |
| `port-invalid` | Port contains non-digit characters |
| `special-scheme-missing-following-solidus` | `http:foo` instead of `http://foo` |

## Fatal vs. Non-fatal

Most validation errors are **non-fatal** — parsing continues and produces a URL. The parser only **returns failure** for:
- Missing scheme with no valid base
- Port > 65535
- Host parsing failure in a context that requires a valid host
- Unclosed IPv6 bracket
- IPv6 parse failure

## See Also

- [[url-parsing-algorithm]]
- [[url-host-parsing]]
- [[url-ipv4]]
- [[uri-security-considerations]] — RFC 3986 §7.4 names the IP-format ambiguity these errors close off

## Sources

- https://url.spec.whatwg.org/#validation-error
