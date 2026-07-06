---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-05
---

# URLPattern Canonicalization

Before a component's pattern text is tokenized ([[urlpattern-syntax]]), the *literal* portions of it are run through an **encoding callback** specific to that component — the same canonicalization the URL Standard's own parser would apply to real URL input. This is what lets `new URLPattern({ hostname: "EXAMPLE.com" })` match `example.com`, and what makes a pattern's literal path segments get percent-encoded consistently with how `URL` itself would encode them.

## Per-Component Encoding Callbacks

- **protocol** — a single trailing `:` is stripped, then the result is parsed by appending `"://dummy.invalid/"` and running it through the *ordinary* URL-parsing entry point (not a state override) so that special-scheme recognition, which needs an authority-shaped input, works correctly; the canonicalized value is the resulting URL record's scheme.
- **username / password** — percent-encoded against the URL Standard's userinfo percent-encode set (see [[url-percent-encoding]]), by calling *set the username*/*set the password* directly on a fresh dummy URL record (no parser reentry needed).
- **hostname** — run through [[url-host-parsing|domain-to-ASCII]] processing: lowercased, Punycode/IDNA-encoded. A bracketed IPv6 literal is preserved as opaque bracket text rather than being domain-processed. This step and its siblings (port/pathname/search/hash canonicalization) work by feeding a dummy URL record into a URL Standard algorithm; how that dummy record is built — critically, whether it counts as a *special* URL — used to be left ambiguous by the spec text. Construction is now settled: the centralized **create a dummy URL** algorithm below (from `whatwg/urlpattern#269`, merged 2025-03-26) always produces a special (`https:`) URL, backed by an URL Standard fix (`whatwg/url#863`, merged) that makes hostname-state failures actually observable. What's still open is narrower — whether *non-special-scheme* or *protocol-less* patterns' hostname canonicalization should also route through this special-URL path — see [[concept-urlpattern-252-dummy-url-ambiguity]].
- **port** — takes the already-canonicalized `protocol` value as an input alongside the port string, and sets it as the dummy URL record's scheme *before* running the `port state` override, so the parser can recognize and normalize away the protocol's default port (e.g. `443` for `https`) the same way [[url-serialization|URL serialization]] omits default ports.
- **pathname** — likewise takes the canonicalized `protocol` value (defaulting to `"https"` if the pattern has none), sets it on the dummy URL record, and branches on whether that makes the URL [[url-concepts|special]]: special URLs go through `path start state` (backslashes treated as `/`, multiple/leading slash forms normalized); non-special URLs go through `cannot-be-a-base-URL path state` instead, percent-encoded against the appropriate path percent-encode set either way.
- **search / hash** — a single leading `?`/`#` is stripped, then the remainder is percent-encoded against the URL Standard's query/fragment percent-encode sets (see [[url-percent-encoding]]) by running `query state`/`fragment state` override on a dummy URL record whose query/fragment field was pre-set to the empty string.

These per-component algorithms — and the "feed a dummy URL record into a state override" pattern generally — originate in [[concept-urlpattern-54-canonicalization-origin|whatwg/urlpattern#54]], which replaced the original spec's `TODO` placeholders with the current design.

## "Dummy URL" Is Defined By URLPattern, Not the URL Standard

The current spec text (§1.5 "Internals") formalizes **create a dummy URL** as its own algorithm, native to the URLPattern Standard:

1. Let `dummyInput` be `"https://dummy.invalid/"`.
2. Return the result of running the [[url-parsing-algorithm|basic URL parser]] on `dummyInput`.

The URL Standard itself never uses the term "dummy URL" and defines no such concept — it only supplies the generic machinery (the basic URL parser, and its per-component `stateOverride` entry points) that URLPattern's algorithm happens to call. The placeholder host in the current spec text is `dummy.invalid` (an [[rfc2606-overview|RFC 2606]]-reserved TLD, like the `dummy.test` used in the original 2021 implementation PR [[concept-urlpattern-54-canonicalization-origin|#54]] before the spec text settled on `.invalid`) — the exact literal is arbitrary and unobservable to authors; only its syntactic validity as a special-URL authority matters.

## Why Reuse the URL Standard's Rules

`URLPattern` is explicitly designed so that a pattern's literal text canonicalizes the same way the equivalent literal `URL` component would. Without this, `new URLPattern({ hostname: "ex ample.com" })` (containing a space) could canonicalize differently than `new URL("https://ex ample.com")`, and a pattern that looks like it should match a given URL might silently fail to, because the pattern's stored form and the URL's parsed form diverged. Sharing the encoding callbacks with [[url-parsing-algorithm]] is what keeps the two in lockstep.

## Regex and Wildcard Groups Are Not Canonicalized

Canonicalization only applies to **literal** pattern text. A custom `(regex)` group's contents are used as-is to build the compiled regular expression — they are not percent-encoded or case-folded, which is part of why regex groups must be restricted to ASCII (see [[urlpattern-regexp-groups]]): there's no canonicalization step to normalize arbitrary Unicode inside them.

## See Also

- [[urlpattern-components]]
- [[urlpattern-regexp-groups]]
- [[url-percent-encoding]]
- [[url-host-parsing]]
- [[url-serialization]]
- [[url-ipv6]]
- [[concept-urlpattern-252-dummy-url-ambiguity]]
- [[concept-urlpattern-54-canonicalization-origin]]

## Sources

- https://urlpattern.spec.whatwg.org/
