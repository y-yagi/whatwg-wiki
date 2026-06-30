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
