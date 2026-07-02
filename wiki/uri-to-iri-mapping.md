---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-02
---

# URI-to-IRI Mapping (RFC 3987 §3.2)

The reverse of [[iri-to-uri-mapping]]: converting a URI back into a more human-readable IRI, e.g. for display in a browser address bar. Unlike the IRI→URI direction, this mapping is defined in exactly one encoding to keep it deterministic.

## The Five Steps

1. Represent the URI as a sequence of US-ASCII octets (its only legal form).
2. Percent-decode every `%HH` triplet **except** those that decode to `%` itself, to a character in `gen-delims`/`sub-delims`, or to a disallowed US-ASCII character (space, control characters, `<`, `>`, `"`, etc.) — those stay encoded.
3. Re-percent-encode any octet sequence that, after decoding, is **not** valid UTF-8 — a malformed byte sequence must not be passed through as if it were text.
4. Re-percent-encode any decoded character that would be inappropriate per §2.2 (bidi controls, non-`ucschar` code points), §4.1 (bidirectional restrictions, see [[iri-bidi]]), or §6.1 (security-sensitive characters, see [[iri-security-considerations]]).
5. Interpret the remaining octet sequence as UTF-8 and present it as Unicode text.

## Determinism Constraint

RFC 3987 states plainly: **"Conversions from URIs to IRIs MUST NOT use any character encoding other than UTF-8, even if it might be possible to guess from the context that another character encoding than UTF-8 was originally used to create the URI."** This closes off encoding-guessing heuristics that would make the mapping ambiguous or exploitable (see [[iri-security-considerations]]'s encoding-confusion risk).

## Round-Tripping

IRI→URI→IRI is not always the identity transform (Step 4 can strip characters an original IRI author included but that fail bidi/security checks), but URI→IRI→URI reproducing the same URI is expected — the mapping is designed to be safe to apply automatically to any URI for display purposes.

## See Also

- [[iri-to-uri-mapping]]
- [[iri-bidi]]
- [[iri-security-considerations]]
- [[url-percent-encoding]]
- [[uri-normalization]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-3.2
