# WHATWG Wiki Index

<!-- LLM-maintained. Update this file whenever pages are created or removed. -->

## HTML

## Fetch

## URL

- [[url-record]] — URL record struct: fields (scheme, host, port, path, query, fragment), path types, opaque path
- [[url-parsing-algorithm]] — basic URL parser: inputs, state machine overview, failure conditions, stateOverride
- [[url-parser-states]] — all named parser states: No Scheme, Scheme, Authority, Host, Path, Query, Fragment
- [[url-host]] — host types (domain, IPv4, IPv6, opaque, empty) and forbidden code points
- [[url-host-parsing]] — host parser algorithm, IDNA processing, opaque host parsing, host serializer
- [[url-ipv4]] — IPv4 address parsing (decimal/hex/octal), serialization, validation errors
- [[url-ipv6]] — IPv6 address parsing (compressed form, mixed IPv4), serialization
- [[url-percent-encoding]] — percent-encode sets hierarchy, UTF-8 percent-encode algorithm, form encoding
- [[url-serialization]] — URL serializer, path serialization, origin computation and serialization
- [[url-api]] — URL and URLSearchParams JavaScript interfaces, constructor, getters/setters, searchParams sync
- [[url-concepts]] — special URLs, base URL, opaque origin, Windows drive letters, opaque path, blob URLs
- [[url-validation-errors]] — full validation error reference, fatal vs. non-fatal distinction
- [[url-goals]] — the spec's stated objectives: align/obsolete RFC 3986 & 3987, unify URI/IRI/URL/URN terminology, supersede RFC 6454 for origin, extend the JS API
- [[url-idempotence]] — the parse/serialize round-trip stability guarantee

## Streams

## DOM

## Encoding

## Infra

## Cross-Spec Concepts

### RFC 3986 (URI Generic Syntax)

The IETF predecessor/foundation underlying the WHATWG URL Standard. Not a WHATWG spec — included for historical context and comparison.

- [[uri-generic-syntax]] — top-level URI grammar, hier-part forms, design considerations
- [[uri-terminology]] — URI vs. URL vs. URN, why RFC 3986 deprecates the URL/URN split
- [[uri-scheme]] — scheme ABNF, case-insensitivity
- [[uri-authority]] — userinfo, host, port grammar
- [[uri-host]] — IP-literal/IPv4address/reg-name grammar
- [[uri-path]] — five mutually exclusive path forms, dot segments
- [[uri-query-fragment]] — query/fragment grammar and fragment-is-client-side-only semantics
- [[uri-reserved-characters]] — gen-delims/sub-delims/unreserved, percent-encoding mechanism
- [[uri-reference-resolution]] — relative reference resolution algorithm (transform references, merge paths, remove dot segments), worked examples
- [[uri-normalization]] — comparison ladder: string, syntax-based, scheme-based, protocol-based
- [[uri-security-considerations]] — userinfo confusability, IP-format ambiguity, semantic attacks
- [[uri-vs-whatwg-url]] — point-by-point contrast with the WHATWG URL Standard

### RFC 3987 (Internationalized Resource Identifiers)

The IETF's IRI companion to RFC 3986, extending URI syntax to Unicode. Not a WHATWG spec — its scope (non-ASCII in identifiers) is what the WHATWG URL Standard's goals name as something to absorb and obsolete; see [[url-goals]].

- [[iri-overview]] — definition, applicability conditions, why IRI is a separate protocol element from URI
- [[iri-syntax]] — ABNF grammar: iunreserved, ucschar, iprivate ranges, i-prefixed productions
- [[iri-to-uri-mapping]] — §3.1: NFC normalization + UTF-8 percent-encoding, optional IDNA ToASCII path
- [[uri-to-iri-mapping]] — §3.2: the 5-step reverse mapping, UTF-8-only determinism constraint
- [[iri-idna]] — ToASCII/ToUnicode, Nameprep, Punycode, contrast with WHATWG's UTS #46 pipeline
- [[iri-bidi]] — §4: logical storage order vs. visual rendering, forbidden bidi controls, component-level RTL/LTR rules
- [[iri-normalization-comparison]] — §5: comparison ladder extending RFC 3986's with NFC + IDN normalization
- [[iri-security-considerations]] — §8: homograph attacks, bidi-override spoofing, encoding confusion, IDN spoofing
- [[iri-processing-guidelines]] — §7: where IRI↔URI conversion belongs across interfaces, entry, transfer, generation, display
- [[iri-vs-uri]] — point-by-point contrast with RFC 3986
- [[iri-vs-whatwg-url]] — point-by-point contrast with the WHATWG URL Standard's inline internationalization handling

### UTS #46 (Unicode IDNA Compatibility Processing)

A Unicode Consortium spec (not IETF, not WHATWG) that WHATWG's [[url-host-parsing|domain-to-ASCII step]] delegates to directly. Bridges IDNA2003 (RFC 3490/3491, see [[iri-idna]]) and IDNA2008 (RFC 5890–5895) into one deterministic algorithm.

- [[idna-uts46-overview]] — purpose, ToASCII/ToUnicode operations, why it exists, WHATWG's flag choices
- [[idna-mapping-table]] — per-code-point Status values (valid/ignored/mapped/deviation/disallowed), informative NV8/XV8 fields
- [[idna-processing-algorithm]] — the shared Map → Normalize → Break → Convert/Validate steps
- [[idna-validity-criteria]] — the nine per-label validity conditions and which WHATWG enforces
- [[idna-toascii-tounicode]] — ToASCII/ToUnicode algorithm steps, DNS length verification, WHATWG's usage
- [[idna-transitional-processing]] — transitional vs. nontransitional processing, the ß/ς/ZWNJ/ZWJ deviation characters
- [[idna-registry-security]] — registry guidance, confusable-label bundling, CONTEXTJ spoofing mitigation limits

### RFC 5890 (IDNA2008: Definitions and Document Framework)

The IETF standard UTS #46 was built to bridge against [[iri-idna|IDNA2003]]. Replaces Nameprep's fixed blocklist with a Unicode-property-derived allowlist; not a WHATWG spec.

- [[idna2008-overview]] — the six-document IDNA2008 set (RFC 5890–5895), why it replaced IDNA2003, audience/scope
- [[idna2008-labels]] — LDH/NR-LDH/XN-label/A-label/U-label terminology, per-label validity model
- [[idna2008-vs-idna2003]] — blocklist (Nameprep) vs. allowlist (PVALID/CONTEXTJ/CONTEXTO/DISALLOWED) shift, the ß/ς divergence
- [[idna2008-security-considerations]] — §4: U-label length risks, local charset ambiguity, confusable characters, unassigned-code-point tradeoff

### RFC 2396 (URI Generic Syntax, obsoleted by RFC 3986)

RFC 3986's direct predecessor. Not a WHATWG spec — included for historical context; see [[rfc2396-vs-rfc3986]] for the grammar-level diff against its successor.

- [[rfc2396-overview]] — scope, document history (RFC 1738/1808 → 2396 → 2732 → 3986), obsoleted-by status
- [[rfc2396-grammar]] — absoluteURI/relativeURI/URI-reference, the hier_part/opaque_part URL/URN split
- [[rfc2396-scheme-authority]] — scheme, authority = server | reg_name, userinfo/hostport grammar
- [[rfc2396-host]] — hostname/IPv4address grammar, the RFC 2732 IPv6 bracket-syntax update
- [[rfc2396-path]] — abs_path/rel_path/opaque_part, segment `;param` matrix-parameter structure
- [[rfc2396-query-fragment]] — query/fragment grammar, fragment defined under URI references (§4)
- [[rfc2396-reserved-characters]] — flat reserved set, the `mark` character class, "unwise" characters
- [[rfc2396-reference-resolution]] — relative resolution algorithm, worked examples, the `http:g` loophole
- [[rfc2396-security-considerations]] — port-confusion attacks, escaped-delimiter injection, userinfo passwords
- [[rfc2396-vs-rfc3986]] — full point-by-point diff: grammar notation, character classes, authority/host, path, terminology
