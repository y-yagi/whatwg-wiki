---
spec: concept
tags: [concept, security]
updated: 2026-07-01
---

# RFC 2396 Security Considerations (§7)

RFC 2396's security section is shorter and less systematically enumerated than [[uri-security-considerations|RFC 3986 §7]] (which splits into six numbered subsections); RFC 2396 covers the same ground in prose form.

## Key Points

- **A URI is not inherently a security threat** — but the act of dereferencing one, or trusting its apparent meaning, can be.
- **URIs may not persistently identify the same resource.** A URI valid and resolvable today may point elsewhere (or nowhere) later; applications must not assume long-term stability beyond what the scheme guarantees.
- **Non-default port numbers can be abused to redirect a client into an unintended protocol interaction** — RFC 2396 specifically cites the historical case of a URI with an http-like syntax but a port number chosen to land on a different protocol's daemon (e.g. directing an HTTP client at an SMTP port), tricking the receiving server into misinterpreting attacker-controlled "HTTP request" text as SMTP commands — an early documented instance of cross-protocol scripting/request smuggling via URI.
- **Escaped delimiters must not be blindly unescaped before transmission.** If a percent-encoded CR/LF or other control sequence inside a URI component is decoded before being handed to a line-oriented protocol (e.g. telnet, SMTP), the decoded bytes can inject protocol commands — the same class of risk [[uri-reserved-characters|RFC 3986's pct-encoded handling]] guidance (§2.4) is designed to prevent.
- **Userinfo passwords are "strongly disrecommended."** Embedding `user:password@host` in a URI risks plaintext credential exposure via logs, browser history, and the `Referer` header — the same warning RFC 3986 §3.2.1 repeats and the WHATWG URL Standard / modern browsers enforce more aggressively (e.g. hiding or stripping userinfo from address-bar display).

## Comparison with RFC 3986

RFC 3986's security section (§7.1–§7.6, [[uri-security-considerations]]) systematizes and extends these same themes — reliability/consistency, malicious construction (the `trusted.example.com@evil.example` userinfo-confusion attack), back-end transcoding, rare IP address formats enabling allowlist bypass, sensitive information exposure, and semantic/homoglyph attacks — into named, numbered categories. None of RFC 3986's six subsections introduces a fundamentally new risk class beyond what RFC 2396 already flags in prose; RFC 3986's main addition is the explicit §7.4 "rare IP address formats" category, sharpened by RFC 2732's IPv6 addition and by growing awareness of allowlist-bypass attacks via non-canonical IP notation.

## Comparison with WHATWG

The WHATWG URL Standard's deterministic, canonicalizing parser closes off several of these ambiguities structurally rather than relying on application-level caution — see [[uri-security-considerations]]'s WHATWG comparison, which applies identically against RFC 2396's looser model.

## See Also

- [[rfc2396-overview]]
- [[rfc2396-vs-rfc3986]]
- [[uri-security-considerations]]
- [[uri-authority]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc2396#section-7
