---
spec: url
tags: [algorithm, parser]
updated: 2026-06-30
---

# URL Host Parsing

The **host parser** takes a string and an `isOpaque` boolean, returning a host or failure. It is called from the [[url-parser-states]] (Host/Hostname states) to parse the authority's host component.

## Host Parser Steps

1. If `input` starts with `[` → parse as **IPv6** (must end with `]`); return [[url-ipv6]] or failure.
2. If `isOpaque` → return input as an **opaque host** after checking for forbidden host code points (percent-decoded). Return failure if any found.
3. Percent-decode `input`.
4. Run **IDNA domain-to-ASCII** on the decoded string → `asciiDomain` or failure.
   - Emits `domain-invalid-code-point` validation error if forbidden domain code points exist.
5. If `asciiDomain` ends in a number (final label is all ASCII digits, or looks like an IPv4 octet) → parse as **IPv4** and return or failure.
6. Return `asciiDomain` as a **domain**.

## IDNA Processing (domain-to-ASCII)

Delegates to [[idna-uts46-overview|UTS #46 (Unicode IDNA Compatibility Processing)]] — specifically its [[idna-toascii-tounicode|ToASCII]] operation — with:
- `checkHyphens = false`
- `checkBidi = false`
- `checkJoiners = false`
- `useSTD3ASCIIRules = false`
- `transitionalProcessing = false` (see [[idna-transitional-processing]] for what this means for deviation characters like ß/ς/ZWNJ/ZWJ)

This disables nearly every optional strictness check UTS #46 offers; see [[idna-validity-criteria]] for exactly which of the nine validity criteria remain enforced under these flags. `VerifyDnsLength` is not set, so the 253/63-character DNS length limits are not enforced here either (see [[idna-toascii-tounicode]]).

Emits a `domain-to-ASCII` validation error on failure. Returns failure if the result is the empty string.

## Opaque Host Parsing

For non-special URLs (`isOpaque = true`):
- Percent-decode the input.
- Check each decoded code point against **forbidden host code points**; if any → failure.
- Return the original (un-decoded) input as the opaque host.

## Host Serializer

| Host type | Serialization |
|-----------|---------------|
| IPv4 address | Dotted-decimal notation (see [[url-ipv4]]) |
| IPv6 address | `[` + compressed IPv6 serialization + `]` (see [[url-ipv6]]) |
| empty host | `""` |
| domain / opaque | Returned as-is |

## See Also

- [[url-host]]
- [[url-ipv4]]
- [[url-ipv6]]
- [[url-parsing-algorithm]]
- [[idna-uts46-overview]]
- [[idna-toascii-tounicode]]
- [[idna-validity-criteria]]
- [[idna-transitional-processing]]
- [[urlpattern-canonicalization]] — `URLPattern` hostname canonicalization delegates to this same domain-to-ASCII processing
- [[concept-urlpattern-252-dummy-url-ambiguity]] — a caller reusing this parser with an undefined "special-ness" dummy record, exposing ambiguity in the domain-vs-opaque routing here

## Sources

- https://url.spec.whatwg.org/#concept-host-parser
- https://url.spec.whatwg.org/#concept-host-serializer
