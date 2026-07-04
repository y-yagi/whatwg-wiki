#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:-}"
if [[ -z "$SOURCE" ]]; then
  echo "Usage: $0 <source_file_or_url>"
  echo ""
  echo "Examples:"
  echo "  $0 sources/fetch-spec-section.md"
  echo "  $0 https://fetch.spec.whatwg.org/"
  exit 1
fi

PROMPT="You are maintaining a personal WHATWG wiki. A new source has been provided.

Source: ${SOURCE}

Follow the agent behavior defined in CLAUDE.md under 'On ingest':
1. Read the source:
   - If it is a GitHub issue or pull request URL (github.com/<org>/<repo>/issues/<n> or /pull/<n>), do NOT use a generic fetch — it won't reliably expose commenter roles. Instead use the gh CLI:
     - gh api repos/<org>/<repo>/issues/<n> --jq '{title, body, user: .user.login, author_association, created_at, state}'
     - gh api repos/<org>/<repo>/issues/<n>/comments --paginate --jq '.[] | {user: .user.login, author_association, created_at, html_url, body}'
   - Otherwise, if a URL, fetch it; if a file path, read it.
2. Read wiki/index.md to see current coverage
3. Identify concepts, algorithms, interfaces, events, and examples in the source
4. Create or update ~10-15 wiki pages following the CLAUDE.md conventions
5. Update wiki/index.md with any new or changed pages
6. Print a summary of pages created/updated

When the source is a GitHub issue/PR, weight comments by author_association: MEMBER (and OWNER) comments are the official/authoritative position of the spec maintainers and should anchor the page's framing, quoted explicitly and attributed by role. COLLABORATOR is a well-informed but non-authoritative voice. CONTRIBUTOR/NONE are outside participants whose arguments should be summarized but clearly distinguished from maintainer sign-off. If a MEMBER comment conflicts with an existing wiki page, update that page to match — it is closer to ground truth than an inference from spec text alone.

Do not ask for confirmation. Proceed autonomously."

claude --print --permission-mode acceptEdits "$PROMPT"
