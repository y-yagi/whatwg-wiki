---
spec: concept
tags: [concept, security]
updated: 2026-07-01
---

# URI Security Considerations (RFC 3986 §7)

RFC 3986's security section catalogs risks inherent to the *generic syntax* itself — independent of any specific scheme's transport security.

## §7.1 Reliability and Consistency

Because URI producers and consumers are independent and a URI's interpretation can depend on context (e.g. the [[uri-reference-resolution|base URI]] for a relative reference), the same URI string is not guaranteed to identify the same resource in every context. Applications must not assume two occurrences of an identical URI string are interchangeable without confirming the resolution context is also identical.

## §7.2 Malicious Construction

A URI can be deliberately crafted to be misleading to a human while remaining syntactically valid, e.g. abusing [[uri-authority|userinfo]] (`http://trusted.example.com@evil.example/`) so a user reads "trusted.example.com" as the host when it is actually the userinfo of a URI whose real host is `evil.example`. RFC 3986's deprecation of cleartext passwords in userinfo (§3.2.1) is partly motivated by this same confusability. This class of attack persists on the modern web and is exactly why [[url-record|URL parsers]] and browser UI treat userinfo and host as strictly separate, security-relevant fields — see [[url-host]].

## §7.3 Back-End Transcoding

When percent-encoded octets are decoded and handed to a back-end system that assumes a different character encoding than the one used to produce the percent-encoding, the decoded data can be misinterpreted — a generic-syntax-level instance of the broader problem [[url-percent-encoding|UTF-8 percent-encoding]] standardizes away by mandating a single encoding.

## §7.4 Rare IP Address Formats

Because [[uri-host|host]] permits multiple valid textual representations of the same IP address (e.g. IPv4 in dotted-decimal vs. less-common forms), an attacker can use a non-obvious representation to bypass naive string-based host allowlists/blocklists that only recognize the canonical form. This directly motivates strict, canonicalizing host parsers — see [[url-ipv4]]'s rejection of non-decimal forms as validation errors rather than silently accepting them.

## §7.5 Sensitive Information

URIs are frequently logged, cached, displayed in browser history/autocomplete, and sent in the `Referer` header — so embedding sensitive data (session tokens, passwords) in any URI component, not just userinfo, risks unintended disclosure.

## §7.6 Semantic Attacks

Because a URI's human-readable rendering can differ from its machine interpretation (e.g. via [[uri-reserved-characters|percent-encoding]], IDN homoglyphs, or [[uri-authority|userinfo]] confusion as in §7.2), attackers can present a URI designed to deceive a human reader about the resource it actually identifies — a category that includes phishing via deceptive domains.

## Comparison with WHATWG

The WHATWG URL Standard's stricter, deterministic parser closes off several of these generic-syntax ambiguities by construction: a single canonical [[url-host-parsing|host parsing]] path (no alternate IP representations surviving to comparison), [[url-validation-errors|validation errors]] surfaced for non-canonical inputs instead of silent acceptance, and IDNA processing applied uniformly. Userinfo confusability (§7.2) remains a live concern on the web platform and is why browser address bars specifically de-emphasize or hide userinfo in displayed URLs.

## See Also

- [[uri-authority]]
- [[uri-host]]
- [[uri-reserved-characters]]
- [[url-validation-errors]]
- [[uri-vs-whatwg-url]]
- [[rfc2396-security-considerations]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-7
