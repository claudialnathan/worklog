# Changelog

Notable changes to the worklog skill, newest first.

## 0.3.0 — 2026-06-18

- Added `worklog-minor` (`/worklog-minor`): a fast-append companion skill that writes one or a few typed entries to `.worklog/LOG.md` and stops — no `BRIEF.md` regeneration, no graduation pass. Same log, same entry format; the next full `/worklog` projects the entries into `BRIEF.md` and graduates any that qualify. Lowers the cost of logging a failure mode or gotcha to roughly that of writing a commit message, since invoking it loads only the append rules rather than the full skill.
- Moved the full skill's one-time Bootstrap and Legacy-migration sections into `skills/worklog/references/setup.md`, leaving a short pointer in `SKILL.md` so the ~20 lines of first-run-only setup no longer load on every `/worklog`.

## 0.2.0 — 2026-06-12

- Split the single `WORKLOG.md` into `LOG.md` (append-only history, newest last) and `BRIEF.md` (a ~100-line dated orientation surface, regenerated from `LOG.md` on every run).
- Added `CONVENTION.md` specifying the `.worklog/` format so non-Claude agents can read and append.
- Added a SessionStart hook (`hooks/inject-brief.sh`) that loads `BRIEF.md` into context when present.
- Added `.worklog/.gitattributes` (`LOG.md merge=union`) for conflict-free parallel appends.
- Removed tags, `INDEX.md`, and the `/worklog-index` command; graduation now runs inline on every `/worklog`.
- Reduced entry types from five to four: `decision`, `failure`, `gotcha`, `question`.

## 0.1.0 — 2026-05-29

- First release of worklog as a single Markdown-only Claude Code plugin.
- Collapsed the former "Priors" MCP server and CLI (~14k lines of TypeScript) into one `SKILL.md` over a committed `.worklog/`; renamed Priors → worklog.

---

Pre-0.1.0 history (the "Priors" MCP/CLI system) is preserved at git tag `legacy/priors-v1.1.0-rc.2`.
