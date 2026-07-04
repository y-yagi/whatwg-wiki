---
spec: concept
tags: [concept]
updated: 2026-07-04
---

# URI Reference vs. WHATWG URL: Why "Relative URL" Is a Contested Term

RFC 3986 has a name for a value that may or may not have a scheme, authority, or host: a **URI reference** (§4.1: `URI-reference = URI / relative-ref`; see [[uri-reference-resolution]]). The WHATWG URL Standard, per its own [[url-goals|stated goal]] of collapsing URI/IRI/URL/URN into one term, has no equivalent concept — every value the [[url-parsing-algorithm|basic URL parser]] successfully produces is called a URL, and a URL is (with only cosmetic exceptions) absolute. [whatwg/url#531](https://github.com/whatwg/url/issues/531) is largely a five-year argument about whether that collapse discarded something real.

## karwa's Position: "Relative URL" Isn't Even Well-Defined

karwa (CONTRIBUTOR) argued that under the current standard, the boundary of "relative" is genuinely fuzzy — not just unsupported. `http:foo` is a relative reference in the sense that a *scheme-relative* resolution takes its host from an http base URL if one is supplied, yet browsers parse the bare string `http:foo` standalone as the absolute `http://foo/` ([2645901571](https://github.com/whatwg/url/issues/531#issuecomment-2645901571)). This directly parallels the RFC 3986 `http:g` ambiguity documented in [[uri-reference-resolution]] — WHATWG resolves it by specification for special schemes, but only inside the parser's state machine, never as an explicit property of a value you can hold and inspect.

## alwinb's Position: `URIReference` as a Missing Type

alwinb (CONTRIBUTOR) built an independent formal specification and reference implementation ([alwinb/url-specification](https://alwinb.github.io/url-specification), later packaged as [URLReference](https://github.com/alwinb/url-reference)) arguing the opposite: that a `URIReference` class — strictly more general than, and less constrained than, `URL` — is exactly the missing piece, with two combining operations:
- **Rebase**: produces another (possibly still relative) `URIReference`, e.g. combining `http:foo` (no host, path `foo`) with something else while staying unresolved.
- **Resolve**: the RFC 3986 §5.2 "transform references" operation, which additionally coerces the result to a fully absolute URL, including converting a path-only first segment into an authority for `http`-like schemes ([2646328707](https://github.com/whatwg/url/issues/531#issuecomment-2646328707)).

His summary of why `URL` alone can't play this role: "URLs just have more constraints on them, specifically on the presence of the authority and also on the type of the authority... these additional constraints make it difficult to work with them directly; they're too constrained. You'd want to loosen some of these constraints whilst manipulating and combining them." A `URIReference` is deliberately *both* more general (can omit scheme/authority) and less constrained (can hold `.`/`..` path segments before normalization) than a `URL` record.

## karwa's Counter: Invariants Matter, and "Equal" ≠ "Equivalent"

karwa's central objection is that `URL` records carry invariants users rely on — notably that serializing and re-parsing produces the same record (see [[url-idempotence]]) — and a looser `URIReference`-like structure that permits raw `.`/`..` segments in its path-component list would not have that guarantee without careful qualification ([1032991440](https://github.com/whatwg/url/issues/531#issuecomment-1032991440)). alwinb's rebuttal distinguishes **equal** (identical serialization) from **equivalent** (same resolved meaning) and claims his model preserves a matching property: `normalise(strict-resolve(url1, url2)) == normalise(strict-resolve(normalise(url1), normalise(url2)))` — resolution and normalization commute — which he argues is the right invariant to hold onto, not literal idempotence of the unresolved form ([2646328707](https://github.com/whatwg/url/issues/531#issuecomment-2646328707)).

## Unresolved

Neither side's model has been adopted. The practical upshot documented across the issue: anything calling itself a WHATWG "URL" is absolute by construction, so any value that needs to stay unresolved (a route template, a relative asset path, a to-be-mounted plugin prefix) currently has no standard type to live in — see [[concept-relative-url-api-proposals]] for the concrete API shapes proposed to fill that gap.

## See Also

- [[concept-url-531-relative-url-debate]]
- [[concept-relative-url-api-proposals]]
- [[uri-reference-resolution]]
- [[uri-terminology]]
- [[uri-vs-whatwg-url]]
- [[url-idempotence]]
- [[url-goals]]

## Sources

- https://github.com/whatwg/url/issues/531
- https://datatracker.ietf.org/doc/html/rfc3986#section-4.1
