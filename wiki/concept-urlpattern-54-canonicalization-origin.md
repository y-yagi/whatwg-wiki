---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-05
---

# `whatwg/urlpattern#54`: Original Implementation of Component Canonicalization Algorithms

[whatwg/urlpattern#54](https://github.com/whatwg/urlpattern/pull/54) ("Attempt to canonicalize components for test()/exec()."), authored and merged 2021-07-20 by wanderview (MEMBER, WHATWG URLPattern editor), is the PR that first filled in the `canonicalize protocol` / `canonicalize username` / `canonicalize password` / `canonicalize hostname` / `canonicalize port` / `canonicalize pathname` / `canonicalize search` / `canonicalize hash` algorithms in [[urlpattern-canonicalization]] — all eight were previously stub `TODO` steps in spec.bs. The shape it gave these algorithms (feed a fresh dummy [[url-record|URL record]] into a [[url-parsing-algorithm|basic URL parser]] state override, then read a field back off) is still how [[urlpattern-canonicalization]] works today, and its unresolved edge case — how "special" the dummy URL is — is exactly what [[concept-urlpattern-252-dummy-url-ambiguity]] flagged four years later.

## What the PR Established (wanderview, MEMBER)

- **protocol**: not a state-override parse. wanderview parses `strippedValue` with `"://dummy.test"` appended through the *ordinary* URL-parsing entry point, then reads back `dummyURL`'s scheme: *"I purposely don't use state override for protocol since it prevents the scheme from being set in many cases."* A later revision added the `dummy.test` suffix specifically because *"I needed to provide `://` and a dummy hostname in order for special schemes to be accepted"* — special-scheme recognition needs a real authority-shaped input, not just a bare scheme string. The literal spelling `dummy.test` is not itself discussed or justified anywhere in the PR (domenic's follow-up review comment on that line only fixes markup italics, not the string) — the hostname's actual content is irrelevant to the algorithm, it just has to be syntactically valid; `.test` is one of the four TLDs [[rfc2606-overview|RFC 2606]] reserves for exactly this kind of placeholder use (guaranteed to never collide with a real domain). This `"://dummy.test"` string-append trick is unique to protocol canonicalization — the other five components below build their dummy URL record directly (`new URL record` + field assignment / state override), never by parsing a `dummy.test`-containing string.
- **username / password**: no parsing at all — [=set the username=]/[=set the password=] are invoked directly on a fresh URL record, since these algorithms already do their own percent-encoding without needing state-override reentry.
- **hostname**: `hostname state` override on a fresh dummy URL record. This is the exact call whose default scheme (empty string, not special) issue [[concept-urlpattern-252-dummy-url-ambiguity|#252]] later showed made hostname-state failures partly unobservable and domain-vs-opaque routing ambiguous.
- **port** and **pathname**: both gained a `protocolValue` parameter in this PR — not present in the original stub signatures. wanderview: *"I forcibly set the scheme in port and pathname depending on it already having been canonicalized before getting passed in to those algorithms."* Port needs the scheme on the dummy URL so the parser can recognize and normalize away default ports (`443` for `https`, etc.); pathname needs it to decide, via [[url-concepts|is-special]], whether to route through `path start state` (special) or `cannot-be-a-base-URL path state` (non-special) — and pathname specifically defaults a missing/empty protocol to `"https"` so path canonicalization always assumes the special path by default.
- **search / hash**: strip a single leading `?`/`#` if present, then run `query state` / `fragment state` override on a dummy URL whose query/fragment field was pre-set to the empty string.

## Why This Matters Later

wanderview flagged the underlying tension in the PR discussion itself: *"Not sure if there is a good place to note that kind of stuff in the spec text."* — i.e., the scheme-forcing and dummy-URL-shaping tricks needed to make these algorithms work were somewhat ad hoc, and the spec prose doesn't fully explain the invariants each one depends on (e.g. that port's dummy URL must already have protocol's canonicalized output on it, or that hostname's dummy URL's special-ness was never pinned down). That gap is precisely what [whatwg/urlpattern#252](https://github.com/whatwg/urlpattern/issues/252) surfaced in 2025 for the hostname case specifically. `whatwg/url#863` and `whatwg/urlpattern#269` (not the unmerged `#255`) are what actually closed the dummy-URL-construction half of it in 2025-03; a narrower routing-logic question — whether non-special/protocol-less patterns should also use the special-URL path — remains open on `#252` itself. See [[concept-urlpattern-252-dummy-url-ambiguity]] for the full resolution timeline.

## See Also

- [[urlpattern-canonicalization]]
- [[concept-urlpattern-252-dummy-url-ambiguity]]
- [[url-parsing-algorithm]]
- [[url-parser-states]]
- [[url-concepts]]
- [[url-record]]

## Sources

- https://github.com/whatwg/urlpattern/pull/54
