---
spec: concept
tags: [concept, security]
updated: 2026-07-04
---

# URLPattern Custom Regex Groups

Alongside named groups (`:name`) and wildcards (`*`), a component pattern may embed a literal `(regex)` group for matching logic the built-in syntax can't express, e.g. `:id([0-9]+)` to constrain a named capture to digits.

## Constraints

- **ASCII-only.** A regex group's source text must consist only of ASCII characters — there is no canonicalization step for regex group contents (see [[urlpattern-canonicalization]]), so allowing arbitrary Unicode inside them would leave their matching semantics undefined relative to the rest of the pattern's Unicode-aware canonicalization.
- **Properly nested parentheses.** Unbalanced or malformed grouping is a tokenization/parse error.
- **No lookahead or lookbehind.** Regex groups are restricted to plain capturing/non-capturing forms; assertions like `(?=...)`/`(?<=...)` are disallowed, keeping the compiled regex's behavior predictable when it's spliced into a larger generated regular expression alongside other components' parts.

## Early Compilation

As described in [[urlpattern-constructor]], every component's pattern — including any embedded regex groups — is compiled into a JavaScript `RegExp` **at construction time**, not lazily on first `test()`/`exec()`. The spec calls this out explicitly: it matters that custom regular expressions are evaluated immediately so an invalid one throws a `TypeError` from `new URLPattern(...)` itself, rather than failing confusingly on first match.

## hasRegExpGroups

```webidl
readonly attribute boolean hasRegExpGroups;
```

`true` if any component's pattern contains a custom `(regex)` group (as opposed to only literal text, wildcards, and named groups with no custom regex). This exists as an optimization signal: an implementation (or a caller building on top of `URLPattern`) can skip constructing/running a full regex engine and match directly against the parsed part list when `hasRegExpGroups` is `false`, since only custom regex groups require genuine regex semantics.

## Security Note

Because a regex group's contents become part of a compiled `RegExp` executed against attacker-influenceable input (e.g. a URL a service worker or router is matching against), a pathologically backtracking custom regex embedded in a `URLPattern` carries the same ReDoS risk as any other hand-written `RegExp` matched against untrusted strings — the spec does not define a mitigation for this beyond requiring ASCII-only, no-lookaround regex groups, which narrows but does not eliminate catastrophic-backtracking patterns (e.g. `(a+)+b`-style nested quantifiers are still expressible in a compliant regex group).

## See Also

- [[urlpattern-syntax]]
- [[urlpattern-constructor]]
- [[urlpattern-canonicalization]]
- [[urlpattern-exec-test]]

## Sources

- https://urlpattern.spec.whatwg.org/
