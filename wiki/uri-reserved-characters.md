---
spec: concept
tags: [concept, security]
updated: 2026-07-01
---

# Reserved, Unreserved, and Percent-Encoded Characters (RFC 3986 §2)

RFC 3986 restricts URIs to a subset of US-ASCII and defines a uniform mechanism — percent-encoding — for representing any other octet within that subset.

## Percent-Encoding (§2.1)

```
pct-encoded = "%" HEXDIG HEXDIG
```

A `%` followed by two hex digits represents the octet with that value. This is the *only* escaping mechanism in the generic syntax — there is no backslash-escaping or similar.

## Reserved Characters (§2.2)

```
reserved    = gen-delims / sub-delims
gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
sub-delims  = "!" / "$" / "&" / "'" / "(" / ")"
            / "*" / "+" / "," / ";" / "="
```

**gen-delims** separate the generic *components* of a URI (scheme, authority, path, query, fragment). **sub-delims** are used as delimiters *within* a component (e.g. `;` and `=` in path/query parameters). Reserved characters are only "reserved" in the sense that, if they appear with their delimiter meaning, they must not be percent-encoded — and if data needs to include the literal character without that meaning, it must be percent-encoded.

## Unreserved Characters (§2.3)

```
unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
```

These characters are guaranteed to never need encoding and never carry reserved/delimiter meaning. RFC 3986 explicitly recommends producers leave unreserved characters un-encoded, since percent-encoding them doesn't change identity but does hurt human readability, and recommends **normalizing** any unnecessarily-encoded unreserved character back to its literal form (see [[uri-normalization]]).

## When to Encode or Decode (§2.4)

- Percent-encoding is applied at the time a URI component is produced from its data.
- A URI should never be percent-decoded and then re-encoded blindly, since that risks corrupting data that intentionally used percent-encoding to escape a delimiter — decoding then re-encoding can change a `%2F` (encoded `/`, literal data) into the structural delimiter `/`.
- Decoding `%XX` for an unreserved character is always safe; decoding `%XX` for a reserved character changes the URI's meaning and should only be done by something that understands the specific component's structure.

## Identifying Data (§2.5)

When original source data isn't ASCII, RFC 3986 recommends converting to UTF-8 and then percent-encoding the resulting bytes — establishing UTF-8 as the de facto character encoding for non-ASCII URI content, well before this became a hard requirement elsewhere.

## Comparison with WHATWG

The WHATWG URL Standard keeps the same `%XX` mechanism and the same reserved/unreserved character vocabulary, but replaces the single "reserved set" with a **hierarchy of percent-encode sets** ([[url-percent-encoding]]) — C0, fragment, query, special-query, path, userinfo, component, form — each tuned to exactly which characters are unsafe in that specific component. This is a direct, more granular descendant of the gen-delims/sub-delims split: e.g. the userinfo set encodes `/`, `:`, `;`, `=`, `@` because those are gen/sub-delims that would be ambiguous specifically inside userinfo. WHATWG also mandates UTF-8 (§2.5's recommendation becomes a hard requirement) and adds the **C0 control percent-encode set** as the baseline floor for every URL component.

## See Also

- [[uri-generic-syntax]]
- [[uri-normalization]]
- [[url-percent-encoding]]
- [[uri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-2
