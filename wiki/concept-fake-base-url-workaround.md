---
spec: concept
tags: [concept, api]
updated: 2026-07-04
---

# The Fake-Base-URL Workaround for Relative Input

Since the [[url-parsing-algorithm|basic URL parser]] requires an absolute base to accept relative input, and the WHATWG URL Standard has no first-class relative-URL type (see [[concept-url-531-relative-url-debate]]), the community's de facto workaround — repeatedly suggested by WHATWG-affiliated participants across [whatwg/url#531](https://github.com/whatwg/url/issues/531) — is to supply a syntactically valid but semantically meaningless base URL, then discard or ignore the fields it fabricated.

## The Pattern

```js
const url = new URL('/foo/bar.json', 'https://nothing');
console.log(url.pathname); // "/foo/bar.json" — the only part that was real input
```

jasnell (COLLABORATOR) posed this as the standing answer to the whole issue: "It really needs to be recognized that `URL` *already* correctly handles relative URLs. The requirement, however, is that it is not possible to correctly parse a URL without *at least* knowing the protocol scheme to use." ([2645821926](https://github.com/whatwg/url/issues/531#issuecomment-2645821926)). annevk made the same suggestion earlier for a host-relative-path use case, proposing a fake origin such as `https://fakehost.invalid` to be "removed later on" ([681657589](https://github.com/whatwg/url/issues/531#issuecomment-681657589)).

## Variants Seen in the Thread

- **Fake scheme, not fake host** — brainkim used `local:///` (three slashes, so the first path segment isn't misread as a host) specifically to model an origin-relative static-asset prefix like `/static/` ([682165952](https://github.com/whatwg/url/issues/531#issuecomment-682165952)).
- **`thismessage:/`** — masinter pointed to the pre-existing IANA-registered [`thismessage:` scheme](https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml#thismessage), invented specifically for `multipart/related` documents that need to resolve relative references with no real base — the same shape of problem, solved decades earlier in a narrower context ([682161586](https://github.com/whatwg/url/issues/531#issuecomment-682161586), reused at [836838167](https://github.com/whatwg/url/issues/531#issuecomment-836838167)).
- **`Request` object as an implicit resolver** — sholladay noted `new Request(relativeInput).url` transparently resolves against `document.baseURI` (respecting an HTML `<base>` element), which `new URL()` alone will not do without that base being passed explicitly: `new URL(to, new Request(from).url)` ([2207680937](https://github.com/whatwg/url/issues/531#issuecomment-2207680937)). This only works in environments with a notion of origin (browsers), not Node.js/Deno/Bun — jasnell's direct rebuttal ([2645821926](https://github.com/whatwg/url/issues/531#issuecomment-2645821926)).

## Where the Workaround Breaks Down

The pattern is not lossless, and the thread documents two concrete failure modes:

1. **Dot-segments are not recoverable after resolution.** vwkd pointed out that a relative reference like `./a/../b/../c?c=d&e=f#g` gets collapsed by [[uri-reference-resolution|dot-segment removal]] during resolution against the fake base, with no way to recover the original unresolved form afterward — a real loss of information, not just cosmetic noise ([927301947](https://github.com/whatwg/url/issues/531#issuecomment-927301947)).
2. **The fake host isn't independent of the rest of parsing.** karwa's [[url-parser-states|Windows drive-letter]] example ([1029786172](https://github.com/whatwg/url/issues/531#issuecomment-1029786172)) shows that for `file:` URLs specifically, correct interpretation of a path segment depends on the *base path*, not just the scheme — so a generic fake base cannot be chosen independent of what's being resolved; see WHATWG issue [#574](https://github.com/whatwg/url/issues/574).

## See Also

- [[concept-url-531-relative-url-debate]]
- [[concept-relative-url-api-proposals]]
- [[url-parsing-algorithm]]
- [[url-parser-states]]
- [[uri-reference-resolution]]
- [[url-concepts]]

## Sources

- https://github.com/whatwg/url/issues/531
