---
spec: url
tags: [concept, parser, algorithm]
updated: 2026-07-02
---

# Parse/Serialize Idempotence

One of the URL Standard's stated [[url-goals|goals]] is that URL handling be **idempotent**: applying parse and serialize repeatedly must reach a fixed point after the first pass, rather than drifting with each round trip.

## What It Guarantees

- **Serialize → parse → serialize** yields the same string every time after the first serialization. There is no WHATWG URL string that "keeps changing" if you feed a browser's own output back into itself.
- **Parse → serialize → parse** yields the same [[url-record|URL record]] every time after the first parse.

This is only possible because the [[url-parsing-algorithm|basic URL parser]] performs its normalization (lowercasing scheme/host, default-port nullification, dot-segment removal, percent-encoding of the correct set) unconditionally and inline — see [[uri-normalization]]'s comparison of WHATWG's unconditional normalization against RFC 3986's optional, opt-in comparison ladder. A parser that only normalized *some* inputs, or normalized lazily, could produce a serialization that itself parses to something different than the record that produced it.

## Why RFC 3986 Doesn't Make This Guarantee

RFC 3986 has no equivalent requirement. Its [[uri-normalization|normalization ladder]] (§6) is explicitly something an application chooses to apply when *comparing* two URIs — an unnormalized URI is still a perfectly valid URI under the grammar, and nothing in the RFC promises that recomposing components (§5.3) after parsing reproduces the original string or stabilizes on repeated application. Idempotence is a WHATWG-specific guarantee layered on top of the same general shape of algorithm.

## Practical Consequence

Because parsing is idempotent, `new URL(url.href).href === url.href` always holds for any WHATWG `URL` object — this is what allows [[url-concepts|URL equality]] to be implemented as plain string comparison on serializations instead of a structural/semantic comparison.

## See Also

- [[url-goals]]
- [[url-parsing-algorithm]]
- [[url-serialization]]
- [[uri-normalization]]
- [[url-concepts]]

## Sources

- https://url.spec.whatwg.org/#goals
- https://url.spec.whatwg.org/#url-writing
