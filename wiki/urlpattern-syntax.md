---
spec: concept
tags: [concept, parser]
updated: 2026-07-04
---

# URLPattern Pattern Syntax

Each `URLPattern` component (protocol, username, password, hostname, port, pathname, search, hash) is specified as a **pattern string** in its own small grammar, tokenized and parsed independently. See [[urlpattern-components]] for how the resulting matching behavior differs per component.

## Elements

| Element | Meaning |
|---|---|
| `*` | **Full wildcard** — matches any number of any characters, greedily |
| `:name` | **Named group** — captures text as `name`, constrained by the component's delimiter code point (e.g. stops at `/` in `pathname`, `.` in `hostname`) |
| `(regex)` | **Regex group** — custom matching logic; must be an ASCII-only regular expression, properly nested, and may not use lookahead/lookbehind. Unlike `:name`, a bare `(regex)` group is unnamed — the parser assigns it the next integer in sequence (`"0"`, `"1"`, ...), stringified, as its group name, so its captured text still shows up keyed in `URLPatternComponentResult.groups` (see [[urlpattern-exec-test]]) even though nothing in the pattern text named it |
| `?` (after a group) | **Optional modifier** — zero or one occurrence |
| `+` (after a group) | **One-or-more modifier** — repeats with the component's delimiter re-inserted between repetitions |
| `*` (after a group) | **Zero-or-more modifier** — like `+` but also allows zero occurrences |
| `{ ... }` | **Explicit grouping** — brackets a literal/group sequence so a modifier applies to the whole group rather than just the trailing token, and so a literal prefix isn't silently absorbed into an optional group |
| `\` | **Escape** — forces the next code point to be treated as a literal rather than pattern syntax |

## Prefix Code Points and Optionality

Some components have a **prefix code point** (see [[urlpattern-components]]) — e.g. `/` for `pathname`. When a named group or wildcard is immediately preceded by that prefix and made optional/repeating (`:foo?`, `:foo*`, `:foo+`), the prefix character is treated as part of the group and becomes optional/repeating along with it. This is why `/foo/:bar?` behaves as "the whole `/:bar` segment is optional," not just the captured text. Explicit `{ }` grouping is how you opt out of this — `/foo/{:bar}?` makes the same text optional without folding the prefix in.

## Tokenizing

Pattern strings are tokenized before parsing, into token types including: `open` (`{`), `close` (`}`), `regexp` (a `(...)` regex group), `name` (`:` + valid identifier characters), `char` (an ordinary literal code point), `escaped-char` (`\` + literal), `other-modifier` (`?` or `+`), `asterisk` (`*`, wildcard or modifier), `end`, and `invalid-char`.

Tokenizing runs under one of two **policies**:

- **`strict`** — a tokenization error throws a `TypeError` immediately. Used when parsing an individual component's pattern string out of a `URLPatternInit` dictionary member, where the input is expected to already be a well-formed pattern.
- **`lenient`** — a tokenization error is folded into an `invalid-char` token rather than thrown, letting parsing continue. Used while parsing the top-level **constructor string** (see [[urlpattern-constructor]]), so that a shorthand string like `https://example.com/:id` can be pulled apart into components even though, read as a whole, it isn't itself a single valid component pattern.

## See Also

- [[urlpattern-components]]
- [[urlpattern-constructor]]
- [[urlpattern-regexp-groups]]
- [[urlpattern-canonicalization]]
- [[urlpattern-examples]]

## Sources

- https://urlpattern.spec.whatwg.org/
