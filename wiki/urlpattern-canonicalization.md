---
spec: concept
tags: [concept, algorithm]
updated: 2026-07-04
---

# URLPattern Canonicalization

Before a component's pattern text is tokenized ([[urlpattern-syntax]]), the *literal* portions of it are run through an **encoding callback** specific to that component — the same canonicalization the URL Standard's own parser would apply to real URL input. This is what lets `new URLPattern({ hostname: "EXAMPLE.com" })` match `example.com`, and what makes a pattern's literal path segments get percent-encoded consistently with how `URL` itself would encode them.

## Per-Component Encoding Callbacks

- **protocol** — lowercased and validated as a URL scheme, reusing the URL Standard's scheme validity rules.
- **username / password** — percent-encoded against the URL Standard's userinfo percent-encode set (see [[url-percent-encoding]]).
- **hostname** — run through [[url-host-parsing|domain-to-ASCII]] processing: lowercased, Punycode/IDNA-encoded. A bracketed IPv6 literal is preserved as opaque bracket text rather than being domain-processed.
- **port** — validated as numeric; if it equals the default port for the pattern's protocol (e.g. `443` for `https`), it is normalized away the same way [[url-serialization|URL serialization]] omits default ports.
- **pathname** — percent-encoded against the appropriate path percent-encode set; for special-scheme URLs, backslashes are treated as `/` and multiple/leading slash forms are normalized the way the URL Standard's path state does.
- **search / hash** — percent-encoded against the URL Standard's query/fragment percent-encode sets (see [[url-percent-encoding]]).

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

## Sources

- https://urlpattern.spec.whatwg.org/
