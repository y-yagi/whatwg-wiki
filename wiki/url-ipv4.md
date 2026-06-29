---
spec: url
tags: [algorithm, concept]
updated: 2026-06-30
---

# IPv4 Address Parsing and Serialization

An IPv4 address is internally a **32-bit unsigned integer**. The WHATWG URL spec has a distinctive IPv4 parser that accepts several non-standard formats that browsers have historically supported.

## IPv4 Parser

Input: a domain string (post-IDNA processing) that ends with a numeric final label.

### Steps

1. Split input on `.` to get `parts`.
2. If the last part is empty (trailing dot) → remove it; emit `IPv4-empty-part` validation error.
3. If `parts.length > 4` → return failure (not an IPv4 address; keep as domain).
4. For each part, call **parse an IPv4 number** → `result`, `validationError`.
5. If any part fails → failure.
6. If any part is > 255 → failure (unless it's the last part, which can represent the remaining octets).
7. **Combine parts**: multiply accumulated value left by 256 per remaining part, add final part. E.g., `0xffff` with 1 part remaining = `0xffff0000... + part`.
8. If combined value ≥ 2³² → failure (number too large).
9. Return the 32-bit integer.

### Parse an IPv4 Number

Accepts decimal, hex (`0x`/`0X` prefix), and octal (`0` prefix) formats — this is the legacy behavior browsers support. Emits `IPv4-non-decimal-part` validation error for non-decimal.

Returns failure for empty strings or strings with non-digit characters after the prefix.

## IPv4 Serializer

1. Initialize `output = ""` and `n = address` (the 32-bit integer).
2. Repeat 4 times:
   - Prepend `n % 256` to output.
   - Prepend `.` if not the first iteration.
   - `n = floor(n / 256)`.
3. Return `output`.

Result is always standard dotted-decimal (e.g., `127.0.0.1`).

## Validation Errors

| Error | Cause |
|-------|-------|
| `IPv4-empty-part` | Trailing dot (e.g., `1.2.3.4.`) |
| `IPv4-non-decimal-part` | Hex or octal notation used |
| `IPv4-too-many-parts` | More than 4 dot-separated parts |
| `IPv4-non-numeric-part` | Part contains non-digit characters |
| `IPv4-out-of-range-part` | Part value > 255 (for non-final parts) |

## See Also

- [[url-host]]
- [[url-host-parsing]]
- [[url-ipv6]]

## Sources

- https://url.spec.whatwg.org/#concept-ipv4-parser
- https://url.spec.whatwg.org/#concept-ipv4-serializer
