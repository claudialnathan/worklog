# The `.worklog/` convention

A committed, plain-Markdown record of a project's history — decisions, dead ends, gotchas, and open questions — written and read by any coding agent or human. No server, no database, no install required to read or append. The Claude Code skill in this repo is the reference implementation; this file is the format it writes, so any other agent can participate.

## Files

```
.worklog/
  BRIEF.md         ~100-line orientation surface. Every line dated. A projection of LOG.md.
  LOG.md           append-only history. Oldest first, newest at the end. Never edited.
  .gitattributes   contains: LOG.md merge=union
```

`.worklog/` lives at the repository root.

## The split

- **LOG.md is written.** Append-only, so it cannot lie — it's a record of what happened, in order.
- **BRIEF.md is derived.** A mechanical projection of LOG: every line copies or shortens a LOG headline plus its date. It cannot go stale, because it's rebuilt from LOG. It is never hand-edited.

BRIEF is the read path (skim it at session start). LOG is the evidence behind it (grep it when a topic recurs).

## LOG entry format

Append at the **end** of the file:

```
#### YYYY-MM-DD | `type` | one-line headline (specific, names a file or area)

- terse, evidence-first bullets
- include a number if one matters

supersedes: YYYY-MM-DD <headline this reverses>   (only when reversing a past entry)
→ path/one, path/two                               (touched files, when relevant)
```

Four types: `decision`, `failure`, `gotcha`, `question`. The date starts the heading and is mandatory. Entries are never edited or deleted — to reverse one, append a new entry with a `supersedes:` line naming it.

## BRIEF projection rules

1. Every line is a copy or pure shortening of a LOG headline + date. No synthesized claims, no cross-entry summary, no inferred "direction."
2. Every line is dated.
3. Superseded entries and entries promoted to a rules file drop out automatically.
4. Hard per-section caps, ~100 lines total. Overflow drops lowest-priority items and prints a grep hint. Empty sections are omitted.

Sections: **Recent (last 14 days)**, **Don't retry (dead ends)**, **Constraints in force**, **Open questions**. Header states the LOG date the brief was built through, plus the don't-edit and merge-conflict rules.

## Degraded mode (agents without the skill)

Any AGENTS.md-reading agent can participate with zero install. Put this in `AGENTS.md`:

```
## Project history
Before non-trivial work, read .worklog/BRIEF.md (≈100 lines, dated).
When a topic recurs or feels already-decided, grep .worklog/LOG.md.
After a real decision, failure, or gotcha, append a dated entry to the END of
LOG.md matching the format of existing entries. Never edit old entries or BRIEF.md.
```

A skill-less agent reads BRIEF, greps LOG, appends to LOG. It won't regenerate BRIEF — and that's fine: BRIEF's header states how far behind it is, and the next skill-driven run catches it up.

## Merge behavior

`LOG.md merge=union` (in `.worklog/.gitattributes`) means two agents in parallel worktrees that both append entries merge cleanly — git keeps both blocks. Appending at end-of-file (not top) is what makes this conflict-free. BRIEF conflicts are non-events: take either side and regenerate from LOG.

## Related work

The same gap — git captures the diff but not the rejected alternatives, the constraints, or the reasoning — is being approached from several directions in 2026:

- **Lore** (arXiv) names it the "Decision Shadow" and encodes decision records in git trailers.
- **Contextual Commits** structures rationale into commit bodies.
- **Agent Decision Records (AgDR)** extend ADRs with agent/model/trigger metadata.
- **Entire / Checkpoints** pairs each commit with the raw prompts and transcripts that produced it.

All of these are commit-anchored or raw-transcript. `.worklog/` is deliberately neither: it captures distilled knowledge that *never produced a commit* (a rejected approach, a failed spike, an environment gotcha), and it optimizes the **read path** — the cited failure mode is agents re-proposing what was already ruled out, which a 100-line dated brief at session start is meant to prevent.

On a different axis: **"The Log Is the Agent"** (Sehgal, Omnara) argues an agent *is* its append-only event log, with every other surface (UI timeline, traces, compaction) a projection of it. That is the same log-to-projection inversion `.worklog/` runs (LOG.md the durable record, BRIEF.md the projection), pointed at a different subject: his log's subject is the agent runtime (resume, fork, or replay a live agent), ours is the project (orient whoever shows up next). It is noted here to mark that boundary, since `.worklog/` deliberately does not grow toward runtime concerns.
