---
spec: concept
tags: [concept, security]
updated: 2026-07-01
---

# RFC 2396 Reserved, Unreserved, and Escaped Characters (§2)

## Grammar

```
reserved   = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" | "$" | ","
unreserved = alphanum | mark
mark       = "-" | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")"
escaped    = "%" hex hex
uric       = reserved | unreserved | escaped
```

## One Reserved Set, Not Two

RFC 2396 defines a **single, flat `reserved` set** of ten characters with no further subdivision. This is the key structural difference from [[uri-reserved-characters|RFC 3986 §2.2]], which splits `reserved` into **gen-delims** (`: / ? # [ ] @` — separate the URI's generic *components*) and **sub-delims** (`! $ & ' ( ) * + , ; =` — delimit *within* a component). RFC 2396's flat set is roughly the union of what later becomes sub-delims plus three of the seven gen-delims (`/`, `?`, `:`); it is missing `#`, `[`, `]` — `#` is handled separately as the fragment delimiter (never part of `reserved`), and `[`/`]` don't exist yet because base RFC 2396 has no IPv6 bracket syntax (see [[rfc2396-host]]).

## `mark`: a Concept RFC 3986 Drops

```
mark = "-" | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")"
```

RFC 2396's `unreserved = alphanum | mark` names this nine-character punctuation set `mark`. RFC 3986 narrows `unreserved` to just `ALPHA / DIGIT / "-" / "." / "_" / "~"` — four of `mark`'s nine characters (`!`, `*`, `'`, `(`, `)`) are **reclassified as sub-delims** in RFC 3986, meaning they go from "always safe, no delimiter meaning" under RFC 2396 to "potentially meaningful as a delimiter within a component" under RFC 3986. This is a real, observable shift in how those five characters should be treated, not just a renaming. See [[rfc2396-vs-rfc3986]].

## Excluded and "Unwise" Characters (§2.4.3)

RFC 2396 explicitly enumerates characters that "are excluded because they are most often used as either delimiters of URI" syntax-incompatible:

```
control = US-ASCII coded characters 00-1F and 7F
space   = " "
delims  = "<" | ">" | "#" | "%" | <">
unwise  = "{" | "}" | "|" | "\" | "^" | "[" | "]" | "`"
```

The `unwise` category — characters "known to cause problems" in transcription/transport (mail gateways, etc.) but not formally forbidden — is unique to RFC 2396. RFC 3986 drops the `unwise` terminology entirely, simply excluding all non-ASCII and non-listed characters from the generic grammar without this softer "discouraged but not invalid" tier.

## Percent-Encoding (`escaped`)

```
escaped = "%" hex hex
```

Identical mechanism to RFC 3986's `pct-encoded = "%" HEXDIG HEXDIG` ([[uri-reserved-characters]]) — `%20` for space, and a literal `%` in data must itself be escaped as `%25`. This `%XX` mechanism is the one piece of the character model that survives completely unchanged from RFC 2396 through RFC 3986 into the WHATWG URL Standard's [[url-percent-encoding|percent-encode sets]].

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-vs-rfc3986]]
- [[uri-reserved-characters]]
- [[url-percent-encoding]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-2
- https://datatracker.ietf.org/doc/html/rfc2396#section-2.4.3
