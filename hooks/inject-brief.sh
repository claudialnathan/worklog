#!/usr/bin/env bash
# SessionStart hook: if the project has a worklog brief, load it into context so
# the agent orients on project history before doing anything. No-op when absent.
set -euo pipefail

root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
brief="$root/.worklog/BRIEF.md"

if [ -f "$brief" ]; then
  printf '%s\n\n' "Project history (from .worklog/BRIEF.md):"
  cat "$brief"
fi
exit 0
