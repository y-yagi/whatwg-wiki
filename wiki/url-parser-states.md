---
spec: url
tags: [algorithm, parser]
updated: 2026-06-30
---

# URL Parser States

The [[url-parsing-algorithm]] is a state machine with the following named states. Each state reads `c` (the current code point or EOF) and transitions accordingly.

## Scheme States

### No Scheme
If `c` is ASCII alpha and base exists with an opaque path → failure.
Otherwise, if base scheme is `file` → file state; if base is non-null → relative state; else → failure.

### Scheme
Accumulates ASCII alphanumeric, `+`, `-`, `.` into `buffer`. On `:`:
- Identifies the scheme type (special vs. non-special, `file`).
- Transitions to: **Special Relative or Authority**, **Special Authority Slashes**, **No Scheme** (for state override file changes), **File**, **Path**, or **Opaque Path**.

## Authority States

### Special Relative or Authority
`//` → Special Authority Slashes; else → Relative state (with pointer rewind).

### Path or Authority
`//` → Authority; else → Path (pointer rewind).

### Relative
Copies base URL fields as defaults, then re-dispatches on `c`:
- `/` → Relative Slash
- `?` → set query, state = Query
- `#` → state = Fragment
- else → pop last path segment, state = Path (pointer rewind)

### Relative Slash
`/` (or `\` for special) → Authority; else → set host/query/path from base, state = Path (pointer rewind).

### Special Authority Slashes
Expects `//`; any deviation emits validation error and falls through to Authority.

### Special Authority Ignore Slashes
Skips extra `/` and `\` (validation error each time), then → Authority.

### Authority
Accumulates characters looking for `@` (credentials) or end of authority:
- `@` → extract username:password from buffer, clear buffer, continue.
- `[` → set `insideBrackets = true`.
- `]` → set `insideBrackets = false`.
- `/`, `?`, `#`, EOF (or `\` for special) → extract host from buffer → Host.

### Host / Hostname
Accumulate host, forwarded to [[url-host-parsing]]. Differences:
- **Host**: also parses port.
- **Hostname**: `stateOverride` variant that stops at `:` without entering Port.

On `:` (outside brackets) → Port.
On `/`, `?`, `#`, `\` (special), EOF → set host, validate special URL non-empty host.

Historically, most callers that invoke the basic URL parser with `hostname` as the `stateOverride` ignored this state's return value; `whatwg/url#863` changed the hostname state to report failure in more cases than before, which surfaced a gap in how `URLPattern` builds the dummy URL record it feeds into this state — see [[concept-urlpattern-252-dummy-url-ambiguity]].

### Port
Accumulates ASCII digits into `buffer`.
On EOF, `/`, `?`, `#`, `\` (special): parse integer, fail if > 65535; nullify if equals scheme default.

### File
Special handling for `file:` URLs.
- `\` or `/` → File Slash.
- Reuses base if base scheme is `file`.

### File Slash
- Second `/` or `\` → File Host.
- Windows drive letter detection: if `buffer` is a drive letter → Path.

### File Host
Accumulates characters until `/`, `\`, `?`, `#`, EOF.
Empty buffer → host `""` (localhost).
Windows drive letter → path instead.

## Path States

### Path Start
Entry point for path parsing; handles leading `/` and `\` (for special).

### Path
Accumulates a path segment until `/`, `\` (special), `?`, `#`, EOF.
Applies **shorten URL path** to handle `.` and `..` segments.
Appends non-empty, non-double-dot segments to `url.path`.

### Opaque Path
For non-special URLs without authority.
Accumulates everything (percent-encoding as needed) until EOF.

## Query and Fragment States

### Query
Accumulates query (uses **special percent-encode set** for special URLs, **query percent-encode set** otherwise).
`#` → Fragment.

### Fragment
Accumulates fragment using **fragment percent-encode set**.
(Fragment is not part of URL serialization for same-document navigation checks.)

## See Also

- [[url-parsing-algorithm]]
- [[url-host-parsing]]
- [[url-percent-encoding]]
- [[concept-urlpattern-252-dummy-url-ambiguity]]

## Sources

- https://url.spec.whatwg.org/#basic-url-parser
