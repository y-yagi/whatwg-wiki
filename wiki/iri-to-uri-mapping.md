---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-02
---

# IRI-to-URI Mapping (RFC 3987 §3.1)

RFC 3987 defines a deterministic, one-directional algorithm for converting any IRI into an equivalent URI, so legacy US-ASCII-only software can consume internationalized identifiers unchanged.

## Step 1: Character Normalization

- If the IRI came from a source without a specific character encoding (e.g. typed or spoken), apply **Unicode Normalization Form C (NFC)**, per Unicode Standard Annex #15.
- If the IRI came from a non-Unicode character encoding, first transcode to UCS, then apply NFC.
- If the IRI is already in a Unicode-based encoding, this step is a no-op — proceed directly to Step 2.

## Step 2: Percent-Encode Non-ASCII Characters

For every character that falls in [[iri-syntax|`ucschar` or `iprivate`]]:

1. Convert the character to its UTF-8 byte sequence.
2. Encode each byte as `%HH` (uppercase hex digits preferred).
3. Replace the original character with the resulting escape sequence.

Example: `é` (U+00E9) → UTF-8 bytes `C3 A9` → `%C3%A9`. A full URL example: `http://example.org/Dürst` → `http://example.org/D%C3%BCrst`.

## Domain Names: Optional IDNA Path

For `ireg-name` components under schemes that use domain names, an implementation **MAY** apply the `ToASCII` operation (RFC 3490, see [[iri-idna]]) instead of UTF-8 percent-encoding — producing Punycode (`xn--`) labels rather than percent-escapes. Example: `http://résumé.example.org` → `http://xn--rsum-bpad.example.org`. This is the only place in the mapping where the destination isn't percent-encoding.

## Characters Requiring Special Care

- Printable ASCII characters excluded from URI syntax (`<`, `>`, `"`, space, `{`, `}`, `|`, `\`, `^`, `` ` ``) are not part of `ucschar`/`iprivate`; if present and not already percent-encoded, the conversion should be treated as failing rather than silently passing them through.
- Reserved/generic-delimiter characters (`#`, `%`, `[`, `]`, and the rest of `gen-delims`/`sub-delims`) **MUST NOT** be percent-encoded by this process — they already have syntactic meaning identical in both IRI and URI.

## See Also

- [[iri-overview]]
- [[iri-syntax]]
- [[uri-to-iri-mapping]]
- [[iri-idna]]
- [[url-percent-encoding]]
- [[iri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-3.1
