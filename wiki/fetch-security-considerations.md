---
spec: fetch
tags: [security]
updated: 2026-07-06
---

# Fetch Security Considerations

A cross-cutting summary of how the Fetch Standard's mechanisms combine to form the web's cross-origin security boundary — each piece is a separate algorithm elsewhere in this wiki, but they're only defensive in combination.

## Opaque Responses Are the Default Cross-Origin Boundary

A `mode: "no-cors"` request (the default for e.g. `<img>`, `<script>` cross-origin loads) returns an **opaque** response: status forced to `0`, no header list, no body access — regardless of whether the request actually succeeded. This is what lets browsers load cross-origin images/scripts/styles by default without leaking their content to page script; see [[fetch-credentials-mode|mode]] and [[fetch-cors|response tainting]].

## CORS Requires Explicit Server Opt-In

[[fetch-cors|CORS]] flips the default from "deny" to "allow if the server says so" via `Access-Control-Allow-Origin` (and `-Credentials`, `-Methods`, `-Headers`). Because the check happens client-side after the response already arrived at the browser, CORS protects **confidentiality of the response from script**, not the server itself — a CORS-preflight failure doesn't undo a side-effecting request the server already processed (e.g. a preflighted `DELETE` still requires the *preflight* to fail before the real request is even sent, which is why unsafe methods/headers force a preflight rather than relying on a post-hoc check).

## Forbidden Headers Prevent Request Smuggling and Spoofing

[[fetch-headers|Forbidden request headers]] (`Host`, `Content-Length`, `Connection`, `Cookie`, etc.) can't be set by script, because letting page JS control them would enable HTTP request smuggling or cookie injection independent of the same-origin policy. The `Sec-*` prefix is reserved specifically so browser-computed values like `Sec-Fetch-Mode`/`Sec-Fetch-Site` (consumed by servers to distinguish real browser navigation from forged cross-origin requests) can't be spoofed by an attacker's script.

## Referrer Stripping Limits Cross-Origin Leakage

[[fetch-referrer-policy|Referrer policy]] defaults (`strict-origin-when-cross-origin`) balance analytics utility against leaking a full URL (which may contain session tokens, search queries, or other sensitive path/query data) to third-party origins, and unconditionally suppress the referrer on an HTTPS→HTTP downgrade to avoid a secure page's URL leaking over a plaintext connection.

## Credentials Require Explicit Intent

[[fetch-credentials-mode|Credentials mode]] defaults to `"same-origin"` rather than always-on, so a cross-origin `fetch()` doesn't silently attach cookies unless the caller opts in with `"include"` — and even then, `Access-Control-Allow-Credentials: true` from the server is mandatory, and a wildcard `Access-Control-Allow-Origin: *` is explicitly disallowed in the credentialed case (see [[fetch-cors|CORS check]]) to prevent a maximally-permissive CORS header from accidentally exposing credentialed data.

## Integrity Verification Guards Against Compromised Origins

[[fetch-integrity|Subresource Integrity]] protects against a scenario CORS/credentials don't cover at all: a trusted-and-allowed origin serving unexpectedly modified content (compromised CDN, on-path tampering). Fetch treats a hash mismatch as a full network error rather than handing back the (wrong) content.

## Timing Side Channels

Even opaque/cross-origin responses leak *some* information through timing (size, cache status, error vs. success) unless explicitly gated: the [[fetch-cors|TAO check]] must pass before fine-grained Resource/Navigation Timing marks are exposed for a cross-origin resource, and opaque responses report only coarse start/end timestamps by default.

## Redirects Don't Leak Intermediate URLs

[[fetch-redirect|HTTP-redirect fetch]] tracks the full chain internally, but only exposes the final URL (`response.url`) to script by default — an attacker embedding a cross-origin resource that redirects through a sensitive internal URL can't recover that intermediate URL via the Fetch API, only via `redirect: "manual"`'s deliberately opaque `"opaqueredirect"` response type.

## See Also

- [[fetch-cors]]
- [[fetch-credentials-mode]]
- [[fetch-headers]]
- [[fetch-referrer-policy]]
- [[fetch-integrity]]
- [[fetch-redirect]]

## Sources

- https://fetch.spec.whatwg.org/#security-considerations-and-privacy-considerations
