---
spec: concept
tags: [concept]
updated: 2026-07-02
---

# IRI Processing Guidelines for Software (RFC 3987 §7)

Non-normative recommendations for where in a software stack each IRI operation belongs.

## By Component

- **Interfaces**: internal APIs that pass identifiers between software components should use UTF-8 (or an equivalent Unicode encoding) for IRIs rather than a legacy charset, minimizing conversion points.
- **User entry**: input methods should accept IRIs in the user's own script/language directly; entered text should be validated against the §2.2 character restrictions ([[iri-syntax]]) before being treated as a well-formed IRI.
- **Transfer**: when scanning plain text for identifiers to link/activate, detect the IRI grammar (not just the narrower URI grammar) — and convert to URI form ([[iri-to-uri-mapping]]) only at the point where the identifier must actually leave for a wire protocol that requires it.
- **Generation**: server-side code producing identifiers from local (non-Unicode) filenames or database content must transcode to UTF-8 before treating the result as an IRI.
- **Display**: user-facing rendering should show the **original IRI form**, not its URI-mapped equivalent; optionally offer the URI form for compatibility with users of legacy tools that don't understand IRIs. See [[uri-to-iri-mapping]] for producing a display form from a wire-level URI.
- **Interpretation/dereferencing**: at the point of actually retrieving a resource, map the IRI to its URI form ([[iri-to-uri-mapping]]) since the underlying transport (e.g. HTTP) still expects URIs — but retain the original IRI for any identity/comparison purpose, since the URI form is a derived encoding, not the canonical identity.

## Underlying Principle

Every guideline follows from the same rule: **convert to URI as late as possible, and only where required** — the IRI form is treated as canonical for human-facing and comparison purposes, the URI form as a wire-protocol compatibility artifact derived from it on demand.

## Relationship to WHATWG

WHATWG's [[url-record|URL record]] sidesteps this "which form is canonical" question — because [[url-percent-encoding|percent-encoding]] and [[url-host-parsing|IDNA]] happen inline during parsing, there is only ever one representation (the parsed record), with [[url-serialization|serialization]] producing display or wire forms as needed on demand rather than maintaining IRI and URI as two coexisting representations of the same identifier.

## See Also

- [[iri-overview]]
- [[iri-to-uri-mapping]]
- [[uri-to-iri-mapping]]
- [[iri-vs-whatwg-url]]

## Sources

- https://datatracker.ietf.org/doc/html/rfc3987#section-7
