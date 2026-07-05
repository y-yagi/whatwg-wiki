---
spec: concept
tags: [concept, algorithm, security]
updated: 2026-07-05
---

# `whatwg/urlpattern#252`: Ambiguous Use of URL Records in Canonicalization

[whatwg/urlpattern#252](https://github.com/whatwg/urlpattern/issues/252) ("URLPattern use of URL record is ambiguous"), opened 2025-01-15 by youennf (NONE) and still open, identifies a spec-authoring gap in [[urlpattern-canonicalization]]: several canonicalization steps — [canonicalize a hostname](https://urlpattern.spec.whatwg.org/#canonicalize-a-hostname), and the equivalent steps for port, pathname, search, and hash — feed a URL record into a URL Standard algorithm (e.g. the [hostname state](https://url.spec.whatwg.org/#hostname-state) of the [[url-parsing-algorithm|basic URL parser]]) without ever specifying how that URL record was constructed. This "dummy URL fed into a state override" pattern was introduced back in [[concept-urlpattern-54-canonicalization-origin|whatwg/urlpattern#54]] (2021), which is the PR that first implemented these algorithms; the ambiguity issue #252 raises is a gap left in that original design, not a regression. Since a URL record's default [scheme](https://url.spec.whatwg.org/#concept-url-scheme) is the empty string — not a [[url-concepts|special scheme]] — a literal reading of the spec makes it unclear whether hostname parsing should fall through to the [[url-host-parsing|opaque host parser]] instead of ordinary domain processing. WPT tests and Chrome's actual behavior require the special-URL, non-opaque path, but the spec text didn't say so.

## Why This Matters

This is not cosmetic underspecification: which parser path runs changes observable behavior. A hostname of `café.com` is domain-processed (IDNA/Punycode → `xn--caf-dma.com`) only on the special-URL path; on the opaque-host path it would instead be percent-encoded (`caf%C3%A9.com`) and left otherwise alone. An implementer following the letter of the old spec text could produce a conforming-looking but wrong implementation that diverges from Chrome and from WPT.

## Maintainer Resolution (annevk, MEMBER)

annevk (MEMBER, WHATWG URL editor) confirmed the bug and drove the fix across two specs:

- Agreed the intended behavior is what youennf described: the dummy URL used in canonicalization should be treated as a **special URL**, so hostname canonicalization always takes the non-opaque path — including when no `protocol` was given in the pattern (["I think what we want is that URLs without explicit protocol also use the special URL code path. At least I think that's what the current tests end up requiring and what is implemented."](https://github.com/whatwg/urlpattern/issues/252#issuecomment-2751126283)).
- Rejected sisidovski's (COLLABORATOR) first proposal of building the dummy URL by running the full [basic URL parser](https://url.spec.whatwg.org/#concept-basic-url-parser) on a literal string like `"http://dummy.test"` and reusing its result, because success/failure of the hostname-state override becomes unobservable that way: *"you cannot distinguish between someone passing in a hostname of `:` and a hostname of `dummy.test`. So how exactly do you know whether it succeeded?"* ([2718081160](https://github.com/whatwg/urlpattern/issues/252#issuecomment-2718081160)). A magic sentinel hostname (e.g. `urlpattern.invalid`) was floated and dismissed as inelegant in the same breath ([2718084288](https://github.com/whatwg/urlpattern/issues/252#issuecomment-2718084288)).
- Instead fixed it at the URL Standard layer: [whatwg/url#863](https://github.com/whatwg/url/pull/863) ("Report all hostname state failures for URLPattern"), merged 2025-03-19, makes the [[url-parser-states|hostname state]] report failure in more cases than before — historically every other caller of the basic URL parser with hostname as the override state ignores the return value, so this caller was the outlier that needed the state itself to become stricter rather than working around it in URLPattern. A follow-up WPT patch ([web-platform-tests/wpt#51316](https://github.com/web-platform-tests/wpt/pull/51316)) covers the one test this impacted.
- On the URLPattern side, two competing fixes were proposed:
  - [whatwg/urlpattern#255](https://github.com/whatwg/urlpattern/pull/255) (rubycon, CONTRIBUTOR) proposed a `https`-defaulted "canonicalize a domain name" path used only for special-scheme patterns, leaving non-special and protocol-less patterns on the plain "canonicalize a hostname" path. annevk called the direction reasonable but noted it still left the dummy URL's construction not fully defined, and that its default may be wrong when `protocol` is absent (protocol-less patterns need the special-URL path too, per his comment above). **Closed unmerged.**
  - [whatwg/urlpattern#269](https://github.com/whatwg/urlpattern/pull/269) ("Make dummyURL from the basic URL parser with a special scheme", sisidovski, COLLABORATOR) took the direction annevk actually asked for and **merged 2025-03-26**. It introduces a single centralized **create a dummy URL** algorithm (§ Internals): parse the fixed string `https://dummy.invalid/` with the basic URL parser, and reuse that result everywhere a dummy URL was previously built ad hoc as `a new URL record`. Per annevk's own review comments on the PR, `dummy.invalid` (not the `dummy.test` used since [[concept-urlpattern-54-canonicalization-origin|#54]]) was chosen specifically ["to more clearly indicate it's not meant to go anywhere"](https://github.com/whatwg/urlpattern/pull/269) and `https` "because that's preferred over `http`". This closes the core complaint of this issue — the dummy URL's special-ness is now guaranteed by construction, not merely assumed — for every canonicalization algorithm except protocol itself (which still parses `value` + `"://dummy.invalid/"` through the *ordinary* parsing entry point, unchanged in spirit from #54's `dummy.test` trick, just updated to the new placeholder string).
  - **#252 itself remains open** as of this writing despite #269 landing: the residual, unresolved question is the one rubycon's #255 discussion surfaced — whether *non-special-scheme* and *protocol-less* patterns' hostname canonicalization should also default to the special-URL path (annevk's view, stated 2025-03-25: ["I think what we want is that URLs without explicit protocol also use the special URL code path."](https://github.com/whatwg/urlpattern/issues/252#issuecomment-2751126283)) — a question #269 didn't need to answer since it only centralized dummy-URL *construction*, not the *routing logic* that decides which canonicalization method (domain vs. opaque-host) a given pattern's hostname goes through.

## Other Participant Input

- **sisidovski (COLLABORATOR)**: independently spotted that the empty-string default scheme means a literal reading of the old spec wouldn't even reach the special-URL path, reinforcing that the spec was actually wrong, not just unclear. Iterated on the fix with annevk across several comments, picked up the URLPattern-side work once url#863 landed, and authored the merged fix, #269.
- **rubycon (CONTRIBUTOR)**: authored #255, and defended its "hackish" feel as already consistent with the existing spec structure, since "canonicalize a domain name" (the `https`-defaulted path) is only ever invoked for special URLs, while non-special and protocol-less patterns still go through plain "canonicalize a hostname" — a distinction later confirmed by annevk to need adjustment for the protocol-less case.

## See Also

- [[urlpattern-canonicalization]]
- [[url-host-parsing]]
- [[url-parser-states]]
- [[url-concepts]]
- [[url-parsing-algorithm]]
- [[concept-urlpattern-54-canonicalization-origin]]

## Sources

- https://github.com/whatwg/urlpattern/issues/252
- https://github.com/whatwg/url/pull/863
- https://github.com/whatwg/urlpattern/pull/255
- https://github.com/whatwg/urlpattern/pull/269
