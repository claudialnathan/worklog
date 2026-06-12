# worklog

Committed project history for agents and humans. Plain Markdown in your repo — `.worklog/`.

**AGENTS.md tells agents how to behave; `.worklog/` tells them what already happened.**

## Two files

- **`BRIEF.md`** — the read path. ~100 lines, every line dated: what's decided, ruled out, unresolved. Read it first.
- **`LOG.md`** — the evidence. Append-only history. BRIEF is a projection of it, regenerated on every run.

LOG can't lie (it's append-only). BRIEF can't go stale (it's rebuilt from LOG).

```markdown
# Project brief
Built from .worklog/LOG.md through 2026-06-12. Log it; don't edit this file.

## Recent (last 14 days)
- 2026-06-10 — decision: auth moved to session cookies; JWT refresh loop killed it

## Don't retry (dead ends)
- 2026-04-22 — embedding-based retrieval: grep wins at this volume

## Constraints in force
- 2026-05-01 — Bitbucket repo at 2.9 GB of 4 GB cap; large binaries rejected

## Open questions
- 2026-06-05 — canonical project identity: directory, repo, or UUID?
```

## Use

- `/worklog` — distills the recent session into entries, appends to LOG, regenerates BRIEF.
- `/worklog <topic>` — logs one entry on that topic.

Invoking is the approval; both write immediately. When you propose something the log already rejected, the agent pushes back with the dated entry.

## Cross-agent, zero install

The files are plain Markdown, so any agent that reads AGENTS.md participates without the plugin. Add:

```
## Project history
Before non-trivial work, read .worklog/BRIEF.md (≈100 lines, dated).
When a topic recurs, grep .worklog/LOG.md.
After a real decision, failure, or gotcha, append a dated entry to the END of
LOG.md matching the existing format. Never edit old entries or BRIEF.md.
```

Format spec: [`CONVENTION.md`](./CONVENTION.md).

## Why not just…

- **auto-memory** (Claude/Codex/Copilot) — per-machine, per-tool, never reaches your teammate.
- **git history** — records what changed, not what was rejected.
- **AGENTS.md** — standing instructions, no history.

## License

MIT.
