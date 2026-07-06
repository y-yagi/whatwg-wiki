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
3. If `parts.length < 4` → emit `IPv4-too-few-parts` validation error (non-fatal: shorthand forms like `1.2.3` or a single 32-bit decimal are legacy-legal and continue to the next step).
4. If `parts.length > 4` → emit `IPv4-too-many-parts` validation error and **return failure**. Unlike too-few, this is fatal: this parser only runs once the domain's final label has already been classified as "ends in a number" (see [[url-host-parsing]]), so failure here is a genuine host-parsing failure, not a silent fallback to treating the input as an ordinary domain.
5. For each part, call **parse an IPv4 number** → `result`, `validationError`. If any part fails → failure.
6. If any part is > 255 → emit `IPv4-out-of-range-part` validation error (unless it's the last part, which can represent the remaining octets).
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

| Error | Cause | Fatal? |
|-------|-------|--------|
| `IPv4-empty-part` | Trailing dot (e.g., `1.2.3.4.`) | No |
| `IPv4-too-few-parts` | Fewer than 4 dot-separated parts (e.g., `1.2.3`, or a bare decimal/hex number) | No — legacy shorthand |
| `IPv4-too-many-parts` | More than 4 dot-separated parts | Yes — host parsing fails |
| `IPv4-non-decimal-part` | Hex or octal notation used | No |
| `IPv4-non-numeric-part` | Part contains non-digit characters | Yes |
| `IPv4-out-of-range-part` | Part value > 255 (for non-final parts) | No |

See [[url-validation-errors]] for the full reference table, including `IPv4-non-ASCII-input` (emitted one level up, by the host parser before the IPv4 parser is even invoked).

## See Also

- [[url-host]]
- [[url-host-parsing]]
- [[url-ipv6]]
- [[url-validation-errors]]

## Sources

- https://url.spec.whatwg.org/#concept-ipv4-parser
- https://url.spec.whatwg.org/#concept-ipv4-serializer
