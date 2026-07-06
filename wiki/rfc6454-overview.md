---
spec: concept
tags: [concept, security]
updated: 2026-07-05
---

# RFC 6454: The Web Origin Concept

RFC 6454 (December 2011) is the IETF standard that first formally defined **origin** — the (scheme, host, port) unit that browsers use to decide whether two pieces of web content may interact. It predates the WHATWG URL Standard's own origin definition and is the document that standard names as something it explicitly [[url-goals|supersedes]] rather than defers to.

## Computing an Origin (§4)

Given a URI: if the scheme is not one that has a well-defined hierarchical/authority form the RFC recognizes (or the URI can't otherwise be parsed into scheme/host/port), the user agent generates a fresh **globally unique identifier** as the origin — a value equal only to itself, never to anything else, including a second globally-unique origin computed from the identical URI. Otherwise the origin is the triple `(scheme, host, port)`, with `port` defaulting to the scheme's well-known port when the URI omits one.

## Same-Origin Comparison (§5)

Two origins are the same origin if and only if they are both non-globally-unique and their schemes, hosts, and ports are all identical. A globally unique origin is never same-origin with anything, including another instance of itself.

## ASCII Serialization (§6.2)

An origin serializes as `scheme "://" host [ ":" port ]`, omitting the port when it matches the scheme's default — the same shape later reused, unmodified, by [[url-serialization|the WHATWG URL Standard's origin serializer]].

## `file:` URIs (§6.5.1)

RFC 6454 recommends — but does not mandate — that user agents treat each `file:` URI's origin as a fresh globally unique identifier, precisely because reg-name-free filesystem paths give no meaningful host to compare. WHATWG's own [[url-concepts|opaque origin for `file:` URLs]] is the same policy adopted as a firm rule rather than a recommendation.

## The `Origin` Header (§7)

RFC 6454 also specifies the HTTP `Origin` request header: a serialized origin sent with certain requests (cross-origin `XMLHttpRequest`/`fetch`, some form submissions) so servers can make access-control or CSRF decisions without parsing a full `Referer` URL. The WHATWG Fetch Standard is the document that now actually specifies when this header is attached — see [[fetch-cors|Fetch's Origin header rules]], which send it on all CORS requests and same-origin non-GET/HEAD requests, not only cross-origin ones.

## Security and Privacy Considerations (§8)

The RFC is explicit that origin is a **security boundary approximation**, not a cryptographic identity: IDN homograph confusion, IP-address-vs-hostname ambiguity, and mixed-content scenarios can all cause two origins that are technically distinct by this algorithm to be confusable by a human user. It also flags that the `Origin` header can leak the fact that a request is cross-origin to any observer of the request, a privacy consideration weighed against its CSRF-mitigation value.

## Relation to the WHATWG URL Standard

The WHATWG URL Standard names superseding RFC 6454 as one of its four stated [[url-goals|goals]]: rather than deferring origin to this separate IETF document, it defines origin natively in [[url-concepts|its own "Opaque Origins vs. Tuple Origins" split]] and computes it as part of [[url-serialization|URL serialization]]. The core algorithm carries over essentially unchanged — WHATWG's tuple origin `(scheme, host, port, null)` is RFC 6454's `(scheme, host, port)` triple with an extra `domain` field slot for `document.domain` mutation, and WHATWG's opaque origin is RFC 6454's globally unique identifier under a new name. WHATWG extends the model to cases RFC 6454 predates, such as `blob:` URLs (2012+), whose origin is defined by delegating to the inner URL's origin rather than computed fresh.

## See Also

- [[url-concepts]] — WHATWG's native tuple/opaque origin definitions
- [[url-serialization]] — origin computation and serialization as part of the URL Standard
- [[url-goals]] — origin superseding as one of the URL Standard's four stated goals
- [[uri-vs-whatwg-url]] — origin as one axis of the broader RFC 3986/WHATWG contrast
- [[uri-security-considerations]] — RFC 3986's own, narrower security-considerations section
- [[fetch-cors]] — Fetch's CORS protocol, which consumes origin comparisons for the CORS check and Origin header rules

## Sources

- https://datatracker.ietf.org/doc/html/rfc6454
