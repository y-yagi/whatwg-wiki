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
1. Read the source (if a URL, fetch it; if a file path, read it)
2. Read wiki/index.md to see current coverage
3. Identify concepts, algorithms, interfaces, events, and examples in the source
4. Create or update ~10-15 wiki pages following the CLAUDE.md conventions
5. Update wiki/index.md with any new or changed pages
6. Print a summary of pages created/updated

Do not ask for confirmation. Proceed autonomously."

claude --print --permission-mode acceptEdits "$PROMPT"
