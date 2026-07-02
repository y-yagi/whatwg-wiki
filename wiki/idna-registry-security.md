---
spec: concept
tags: [concept, idna, security]
updated: 2026-07-03
---

# UTS #46 Registry Guidance & Security Considerations

UTS #46 includes non-normative but load-bearing guidance for **domain registries** (the operators who decide which labels may be registered), separate from the ToASCII/ToUnicode algorithms that browsers run.

## Registry Guidance

Registries are advised to **not allow registration of labels that are invalid according to Nontransitional Processing** — i.e., to register only labels that would validate the same way under the modern (IDNA2008-aligned) flag setting, even if they also want to remain reachable via transitional/legacy clients. This pushes the transitional/nontransitional ambiguity described in [[idna-transitional-processing]] toward resolving in favor of the nontransitional interpretation at the source (registration time), rather than leaving it purely to client-side flag choices.

## Bundling

Where a registry does permit visually or semantically **confusable** labels to coexist (e.g., a label using Cyrillic look-alike characters alongside its Latin-script twin), the guidance is **bundling**: all confusable variants of a label must be registered to, and remain controlled by, the same registrant. This prevents a third party from registering a homograph of an existing domain to impersonate it — see [[iri-security-considerations]] for the general homograph-attack problem this addresses.

## CONTEXTJ Is a Partial Mitigation, Not a Fix

IDNA2008's **CONTEXTJ** rule (referenced by [[idna-validity-criteria|Validity Criterion 8]]) restricts where ZWNJ/ZWJ can appear specifically to reduce their use as invisible spoofing tools. UTS #46 is explicit that this "only partially mitigates" the risk: "applications that perform IDNA2008 lookup are not required to check for these contexts," so a resolver can still accept a label a well-behaved registry would have rejected. This is a direct consequence of [[url-host-parsing|WHATWG running with `checkJoiners = false`]] — the check is opt-in per implementation, not enforced end-to-end.

## Why This Matters Alongside WHATWG's Permissive Flags

[[idna-uts46-overview|WHATWG's domain-to-ASCII]] disables nearly every strictness flag UTS #46 offers (`checkHyphens`, `checkBidi`, `checkJoiners`, `useSTD3ASCIIRules` all `false`). Combined with the fact that CONTEXTJ enforcement is itself optional even when enabled, spoofing prevention for internationalized domains falls almost entirely on **registries** (bundling policy) and **browser UI** (e.g., punycode-display heuristics for suspicious scripts), not on the URL parser. See [[iri-security-considerations]] for RFC 3987's parallel treatment of IDN spoofing and bidi-override attacks.

## See Also

- [[idna-uts46-overview]]
- [[idna-transitional-processing]]
- [[idna-validity-criteria]]
- [[iri-security-considerations]]
- [[url-host-parsing]]

## Sources

- https://www.unicode.org/reports/tr46/#Registry_Restrictions
- https://www.unicode.org/reports/tr46/#Security_Considerations
