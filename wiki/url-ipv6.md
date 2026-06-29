---
spec: url
tags: [algorithm, concept]
updated: 2026-06-30
---

# IPv6 Address Parsing and Serialization

An IPv6 address is internally a **16-element list of 16-bit unsigned integers** (each element represents a 16-bit "piece"). The URL parser handles the `[...]` wrapper; the IPv6 parser receives the bracketed content without brackets.

## IPv6 Parser

Input: the string between `[` and `]` in the authority.

### Key Steps

1. Initialize `address` as 16-element list of zeros; `pieceIndex = 0`; `compress = null`.
2. If input starts with `::` → `compress = 0`, advance pointer by 2.
3. Main loop: read hex digits (up to 4) into a value.
   - `:` → store value at `address[pieceIndex]`, increment `pieceIndex`.
   - `::` → set `compress = pieceIndex`, start over.
   - `.` at end of hex chunk → treat the accumulated value as start of IPv4 address (mixed notation like `::ffff:192.0.2.1`); parse IPv4 into the last two pieces.
4. After loop, if pointer is not EOF → failure.
5. Expand compression: shift pieces right, fill zeros where `::` was.
6. Return `address`.

### Mixed IPv4/IPv6 (IPv4-mapped)

When a `.` appears mid-parse, the last 32 bits of the IPv6 address are populated by an embedded IPv4 address. E.g., `::ffff:192.0.2.1` → pieces `[0,0,0,0,0,0xffff,0xc000,0x0201]`.

## IPv6 Serializer

Produces the **compressed** canonical form:

1. Find the **longest run of consecutive zero pieces** with length ≥ 2 → `compress`. Ties broken by first occurrence.
2. For each of 8 pieces:
   - If this is the start of the compressed run → emit `::`, skip the run, set `ignore0 = true`.
   - If `ignore0` → skip.
   - Else → emit the piece as lowercase hex (no leading zeros), followed by `:` (except after last piece).
3. Wrap result in `[...]` by the host serializer.

Example: `[0,0,0,0,0,0xffff,0xc000,0x0201]` → `[::ffff:c000:201]`

## See Also

- [[url-host]]
- [[url-host-parsing]]
- [[url-ipv4]]

## Sources

- https://url.spec.whatwg.org/#concept-ipv6-parser
- https://url.spec.whatwg.org/#concept-ipv6-serializer
