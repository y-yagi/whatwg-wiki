---
spec: url
tags: [interface, algorithm]
updated: 2026-06-30
---

# URL and URLSearchParams API

The JavaScript `URL` and `URLSearchParams` interfaces are the primary way developers interact with URLs in the browser and Node.js.

## URL Interface

```webidl
[Exposed=(Window,Worker), LegacyWindowAlias=webkitURL]
interface URL {
  constructor(USVString url, optional USVString base);
  static URL parse(USVString url, optional USVString base);
  static boolean canParse(USVString url, optional USVString base);

  stringifier attribute USVString href;
  readonly attribute USVString origin;
  attribute USVString protocol;
  attribute USVString username;
  attribute USVString password;
  attribute USVString host;
  attribute USVString hostname;
  attribute USVString port;
  attribute USVString pathname;
  attribute USVString search;
  [SameObject] readonly attribute URLSearchParams searchParams;
  attribute USVString hash;

  USVString toJSON();
};
```

### Constructor

`new URL(url, base)`: parses `url` against `base`. Throws `TypeError` on failure.

`URL.parse(url, base)`: returns `URL` object or **null** on failure (no throw).

`URL.canParse(url, base)`: returns boolean — useful for validation without try/catch or null check.

### Getters and Setters

Each attribute maps to a [[url-record]] field:

| Attribute | Record field | Notes |
|-----------|-------------|-------|
| `href` | All fields (serialize) | Setter re-parses entire URL |
| `origin` | scheme+host+port | Read-only |
| `protocol` | scheme | Setter uses scheme state override; includes trailing `:` |
| `username` | username | |
| `password` | password | |
| `host` | host+port | Includes port if non-null |
| `hostname` | host | No port |
| `port` | port | Empty string if null |
| `pathname` | path | Includes leading `/` for list paths |
| `search` | query | `""` if null, else `?` + query |
| `searchParams` | — | Live URLSearchParams object linked to query |
| `hash` | fragment | `""` if null, else `#` + fragment |

### searchParams Synchronization

`url.searchParams` is a **live** `URLSearchParams` object. Mutations to it update `url.search`, and setting `url.search` updates the object's underlying list.

## URLSearchParams Interface

```webidl
interface URLSearchParams {
  constructor(optional (sequence<sequence<USVString>> or
              record<USVString, USVString> or USVString) init = "");
  
  undefined append(USVString name, USVString value);
  undefined delete(USVString name, optional USVString value);
  USVString? get(USVString name);
  sequence<USVString> getAll(USVString name);
  boolean has(USVString name, optional USVString value);
  undefined set(USVString name, USVString value);
  undefined sort();
  iterable<USVString, USVString>;
  stringifier;
};
```

### Internal List

URLSearchParams maintains a list of name/value pairs (not a map — duplicate names are allowed). Serialized with `application/x-www-form-urlencoded` encoding (see [[url-percent-encoding]]).

### Constructor Init Variants

- **String** → parsed as `application/x-www-form-urlencoded` (leading `?` stripped).
- **Sequence of sequences** → `[["name","value"],...]`.
- **Record** → `{"name":"value",...}`.

### sort()

Sorts pairs by name in **code unit order** (stable sort). Used to canonicalize query strings.

### Iteration

`for (const [name, value] of params)` iterates all pairs in list order.

## See Also

- [[url-record]]
- [[url-serialization]]
- [[url-percent-encoding]]

## Sources

- https://url.spec.whatwg.org/#api
- https://url.spec.whatwg.org/#interface-url
- https://url.spec.whatwg.org/#interface-urlsearchparams
