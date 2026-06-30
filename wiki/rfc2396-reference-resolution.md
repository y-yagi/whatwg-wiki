---
spec: concept
tags: [concept, algorithm, parser]
updated: 2026-07-01
---

# RFC 2396 Relative Reference Resolution (§5)

## The Algorithm (§5.2)

Given a base URI and a relative reference `R`, RFC 2396's resolution algorithm (informally specified in numbered prose steps, not pseudocode tables like RFC 3986) works roughly:

1. **Parse** `R` into its (potentially absent) scheme, authority, path, query, fragment components.
2. If `R` is empty (zero-length), the target is the base URI unchanged — a **same-document reference**.
3. If `R` has a scheme, it is already an absolute URI — used as-is (no merging with base).
4. If `R` has authority (a `net_path`), use `R`'s path as-is; only the scheme is inherited from base.
5. If `R`'s path starts with `/` (`abs_path`), use it as-is relative to the base's authority.
6. Otherwise (`rel_path`), **merge**: take the base path up to and including its last `/`, append `R`'s path, then remove `.` and `..` segments by buffer manipulation — scanning left to right, dropping `./` and resolving each `../` by popping the previous segment off the result.
7. **Recombine** the resolved scheme/authority/path/query with `R`'s fragment to produce the target URI.

This is the direct ancestor of RFC 3986 §5.2's Transform References / Merge Paths / Remove Dot Segments pseudocode ([[uri-reference-resolution]]) — the logical structure (scheme present → absolute; authority present → network-path; path starts with `/` → absolute-path; else → merge-and-clean) carries over essentially unchanged.

## Worked Example (Appendix C)

Base `http://a/b/c/d;p?q`:

| Reference | Result |
|---|---|
| `g` | `http://a/b/c/g` |
| `./g` | `http://a/b/c/g` |
| `/g` | `http://a/g` |
| `//g` | `http://g` |
| `../g` | `http://a/b/g` |
| `../../g` | `http://a/g` |
| `../../../g` | `http://a/g` (excess `../` collapses harmlessly) |

Identical to RFC 3986's §5.4.1 example table, which reuses the same base URI and reference set verbatim.

## The `http:g` Loophole

RFC 2396 contains a known, acknowledged ambiguity: a relative reference whose first path segment happens to look like a scheme name followed by `:` (e.g. `http:g` used as a reference against a base of `http://a/b/c/d;p?q`) is structurally indistinguishable from an `absoluteURI` with scheme `http` and opaque-part `g`. RFC 2396-era parsers diverged: some treated it as a new absolute URI (per the strict grammar), others treated it as relative to the base for backward compatibility with older URL parsers that predated the scheme-presence rule. RFC 3986 §5.4.2 explicitly inherits and documents this as "a loophole in prior specifications of partial-URI" and mandates strict parsers resolve it as `T.scheme = "http"` with an opaque path — see [[uri-reference-resolution]]'s Abnormal Examples section.

## Comparison with WHATWG

The WHATWG URL Standard's [[url-parsing-algorithm|basic URL parser with a base]] is a deterministic state machine descendant of this same algorithm, and resolves the `http:g` ambiguity entirely by construction: special-scheme URLs are never parsed as rootless/opaque, so the loophole RFC 2396 leaves open (and RFC 3986 merely documents) cannot arise. See [[uri-reference-resolution]]'s full comparison.

## See Also

- [[rfc2396-grammar]]
- [[rfc2396-path]]
- [[uri-reference-resolution]]
- [[url-parsing-algorithm]]
- [[rfc2396-vs-rfc3986]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-5
- https://datatracker.ietf.org/doc/html/rfc2396#section-5.2
- https://datatracker.ietf.org/doc/html/rfc2396#appendix-C
