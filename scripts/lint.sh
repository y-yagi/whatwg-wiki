#!/usr/bin/env bash
set -euo pipefail

PROMPT="You are auditing a personal WHATWG wiki. Follow the agent behavior defined in CLAUDE.md under 'On lint':

1. Read wiki/index.md
2. Read all linked wiki pages
3. Check for:
   - Orphaned pages (exist in wiki/ but not listed in index.md)
   - Contradictions between pages
   - Stale or vague claims that need updating
   - Missing cross-links between related concepts
   - Gaps: important topics referenced but lacking a dedicated page
4. Fix all issues in-place
5. Print a report: what was fixed, what gaps remain

Do not ask for confirmation. Proceed autonomously."

claude --print "$PROMPT"
