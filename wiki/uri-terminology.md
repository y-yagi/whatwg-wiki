---
spec: concept
tags: [concept]
updated: 2026-07-01
---

# URI, URL, and URN Terminology (RFC 3986 §1.1)

## Definitions

- **URI (Uniform Resource Identifier)**: a compact sequence of characters that identifies an abstract or physical resource. "Uniform" means a consistent syntax across schemes; "Identifier" means it refers to a resource, without necessarily saying how to access it.
- **URL (Uniform Resource Locator)**: historically, the subset of URIs that, in addition to identifying a resource, describe its primary access mechanism (e.g. network location).
- **URN (Uniform Resource Name)**: historically, URIs under the `urn` scheme intended to be persistent, location-independent identifiers.

## RFC 3986's Position

RFC 3986 explicitly **deprecates the URL/URN split** as a formal taxonomy. §1.1.3 states that the terms "URL" and "URN" should be considered historical, and that specifications "should use the general term 'URI' rather than the more restrictive terms 'URL' and 'URN'." Under this RFC, every URL and every URN is simply a URI — there is no syntactic distinction in the generic grammar between an identifier that "locates" versus one that merely "names."

This was a deliberate correction: RFC 2396 (RFC 3986's predecessor) had structurally separated `absoluteURI` into URL-like and URN-like productions; RFC 3986 unified them into the single `URI` grammar described in [[uri-generic-syntax]].

## Example Schemes (§1.1.2)

`ftp`, `http`, `ldap`, `mailto`, `news`, `tel`, `telnet`, `urn` — illustrating that the generic syntax spans network-locating schemes, naming schemes, and schemes for non-network resources alike.

## Contrast with the Web Platform

Despite RFC 3986's recommendation, colloquial and even spec usage on the web reverted to "URL" as the dominant term — directly reflected in the name **WHATWG URL Standard** itself. The WHATWG spec does not use "URI" or "URN" as separate concepts at all: every absolute identifier processed by [[url-parsing-algorithm|the basic URL parser]] is called a URL, regardless of whether the underlying scheme is locating or naming. See [[uri-vs-whatwg-url]] for the fuller comparison.

## See Also

- [[uri-generic-syntax]]
- [[uri-vs-whatwg-url]]
- [[url-record]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3986#section-1.1
