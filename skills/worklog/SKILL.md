---
name: worklog
description: 'Project worklog — append-only changelog of decisions, failures, gotchas, and corrections in .worklog/ at the project root. Project-shared (committed) so every agent — Claude Code, Cursor, v0, Codex — sees the same history. Personal Claude-Code-only corrections go to auto memory automatically (~/.claude/projects/<project>/memory/) — do not duplicate that surface here. Use when the user runs /worklog or /worklog-index, asks to log/recall project history, or proposes something the worklog flagged as already-failed.'
---

# Worklog

Append-only project log. The subject is the project, not the user and not Claude. Each entry is a dated, sourced fact — what happened, why, what file, what a future agent needs to know.

## Files

```
.worklog/
  WORKLOG.md     full log, newest-first.
  INDEX.md       tag → dates. Peek when a topic comes up.
```

`.worklog/` lives at the project root (git root if available, else CWD).

`INDEX.md` is auto-maintained — `/worklog` regenerates it after every successful append. The user should never have to remember to run `/worklog-index` to keep it current. `/worklog-index` exists only for periodic gardening (tag merges, retroactive graduation sweeps).

## Worklog vs auto memory

| Surface              | What it captures                                                              | Scope                              | Loaded how                                      |
| -------------------- | ----------------------------------------------------------------------------- | ---------------------------------- | ----------------------------------------------- |
| `.worklog/WORKLOG.md`| Project decisions, failures, corrections, durable gotchas. Cross-agent.       | Committed to repo, all agents      | Read on demand; pushback rule applies           |
| Auto memory          | Per-session model corrections, build/debug insights Claude noticed itself     | Per-machine, Claude Code only      | First 200 lines of `MEMORY.md` auto-load        |
| `.claude/rules/*.md` | Path-scoped durable rules (graduated from worklog)                            | Committed, Claude Code             | Loads when matching files are touched           |
| `AGENTS.md`          | Always-on durable rules (graduated from worklog)                              | Committed, all agents              | Loaded every session                            |

If something Claude learned would only matter to Claude on this machine, it belongs in auto memory — Claude writes it itself, no skill needed. WORKLOG.md is for facts that need to outlast the machine and reach Cursor, v0, and Codex too.

## Entry types

| Type         | When to use                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------- |
| `decision`   | A choice was made between alternatives. Log the choice, the why, the rejected option.       |
| `failure`    | An approach was tried and didn't work. Log the symptom, root cause, and what to do instead. |
| `learning`   | A non-obvious gotcha or system fact that future *agents* (not just Claude) need to know.    |
| `correction` | The user corrected an approach in a way the project should remember. Log if it's durable.   |
| `change`     | A non-trivial change shipped that future agents need to know about.                         |

`failure`, `correction`, and `decision` carry the highest future-agent value. `learning` is for cross-agent project facts — Claude-only "I learned X this session" corrections go to auto memory automatically and shouldn't be duplicated here. `change` is for the few shipped items that materially shift how the system works — not every commit.

## Entry format

```
#### H:MMam/pm | `type` | one-line headline (specific, file/area named)

tags: tag1, tag2, tag3

- terse bullet, evidence-first
- another bullet, no filler
- if a number matters (test count, file count, time), include it

→ src/path/one.ts, src/path/two.ts
```

Rules:

- Newest entry at the top of its date section. Date sections go newest-first.
- Headline names the area or file, not the verb (`sidebar refactor → grouped AppShell`, not `refactored sidebar`).
- `tags:` line is mandatory. Reuse existing tags from `INDEX.md` before inventing new ones. Target ~15 tags total; merge singletons into parents.
- Bullets only. No paragraphs. Every word adds information.
- Arrow line lists touched files when relevant.
- No em dashes. Use periods or commas.
- Translate emotional/frustrated user wording into a neutral durable claim. Preserve the original phrasing only inside quotes if it adds context.

## Significance gate

Before logging, ask: **would a future agent (any agent, not just Claude) make a better decision because this exists?**

Log when:

- The user explicitly asked.
- A correction landed that matters cross-agent.
- A rejected approach surfaced (failure with root cause).
- A decision was made between real alternatives.
- A non-obvious gotcha was hit and resolved that all agents need to avoid.
- A shipped change materially changes how the system works.

Skip when:

- Ordinary chat or planning that didn't produce a decision.
- Generic summaries of what was edited.
- Frustration without a durable claim.
- Implementation details obvious from reading the code.
- Every commit, every file edit, every plan step.
- Vague preferences with no future consequence.
- Single-session model corrections or preferences — auto memory handles those.

Aim for 2–5 entries on a busy day, not 50.

## Graduation: the loop must close

Worklog entries are project history, not a permanent rules archive. Entries graduate out of "recent and uncodified" into a durable surface as they harden into project facts.

**Graduation criteria.** An entry is a graduation candidate when any of these hold:

- Stable for 30+ days with no contradiction or refinement.
- Referenced or relevant in 3+ subsequent entries.
- Phrased as a permanent project fact rather than a recent correction.
- A new entry refines or restates an existing learning — both old and new are candidates to merge and graduate.

**When graduation is checked.**

- **Inline during `/worklog`** — at the moment of append, while context is hot. If a freshly-appended entry meets criteria, surface it before the run ends. This is the primary path.
- **Retroactively during `/worklog-index`** — sweep older entries that have since stabilised. This is the gardening path.

**What graduation does.** A graduated entry:

1. Gets rewritten as a positive rule (not a correction) and added to the most appropriate durable surface:
   - `AGENTS.md` § Hard nos — universal rules every agent loads every session.
   - `.claude/rules/<topic>.md` — path-scoped rules (Claude Code only) that load when matching files are touched. Pick the file whose `paths:` frontmatter matches the rule's scope; create a new one if no existing file fits.
   - A skill — when the rule is a multi-step procedure rather than a fact.
2. Stays in WORKLOG.md (append-only, never deleted) but receives a `promoted` tag.

Choose the narrowest surface that reaches every agent that needs the rule. If only Claude Code needs it and it's path-scoped, prefer `.claude/rules/`. If Cursor or v0 also need it, it has to live in AGENTS.md.

**Phrasing flip.** Graduated rules invert from corrective to declarative:

| WORKLOG phrasing (correction)                                                                     | Rule phrasing (declarative)                                                                                                                 |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| "Agent built X from scratch instead of using registry block."                                     | "Treat user-named registry blocks and pasted figma output as spec. Install or stop and flag — do not substitute."                           |
| "shadcn output uses `asChild`, this project is base-ui."                                          | "This project uses base-ui. Translate `asChild` from registry/figma output to `render={<child />}`."                                        |
| "Agent reached for playwright wrappers for UI verification."                                      | "UI verification stack: `tsc`, `jest`, curl 200, eyeball. Use `mcp__next-devtools__browser_eval` only when explicitly asked."               |
| "Burned tokens debugging right-aligned CSS via browser_eval; user benchmarked v0 in <500 tokens." | "When a user reports a UI bug and verification says the code is correct, ask for clarification of intent before running more verification." |

The point: WORKLOG framing logs that something happened. Rule framing tells future agents what to do. The latter is load-bearing; the former is history.

## Pushback rule

If the user proposes an approach that matches a logged `failure` or contradicts a logged `decision`, push back before agreeing. Format:

```
This was tried before and rejected.

On <date>, <attempt>, which led to <outcome>.

Relevant entry:
- <date> — <headline>

I recommend <alternative> instead.
```

Saying "you're right" when the worklog says otherwise is a failure mode, not politeness.

## Voice

- No filler. No rhetorical openers ("Great question…"). No em dashes.
- Evidence over opinion. State the fact, then cite the file or test count.
- Neutral language. "Bitbucket repo at 2.9 GB / 4 GB cap; commits rejected beyond." Not "we're in big trouble."
- Specific over abstract. Name files, versions, line numbers. "138 tests pass after clearing stale `.next/types/`" beats "tests pass."
- Same tone for human and agent readers. The log is one artefact, not two.

## Bootstrap

If `.worklog/` doesn't exist when a worklog command runs:

1. Create `.worklog/`.
2. Create `WORKLOG.md` with header `## Worklog\n\nAppend-only project log. Newest first.\n\n---\n`.
3. Create `INDEX.md` with header `## Worklog Index\n\nTag → entry dates. Target ~15 tags total. Auto-regenerated by /worklog.\n\n---\n`.

If a legacy `.worklog/LEARNINGS.md` exists, delete it. The skill does not generate or maintain that file — Claude Code's auto memory replaces its purpose.

## Commands

- `/worklog` (no args) — distill mode. Scan recent session, propose candidates inline, append, **auto-regen INDEX.md**, surface inline graduation candidates.
- `/worklog <topic or claim>` — user-directed write mode. Draft one entry on the named topic, evidence-backed, append directly. Same auto-regen and graduation pass on success.
- `/worklog-index` — periodic gardening. Full retroactive graduation sweep + tag-merge proposals. Not required for normal use.

### `/worklog` execution order

Every `/worklog` invocation, both modes, runs this sequence:

1. **Scan and select** entries per the significance gate.
2. **Append** to WORKLOG.md (newest first within today's section).
3. **Auto-regen INDEX.md** — rebuild tag → dates from WORKLOG.md. No prompts. No tag merges in this pass (those belong to `/worklog-index`).
4. **Inline graduation pass** — for each just-appended entry, check graduation criteria. If any qualify, **promote directly**: write the rewritten rule to the named target file (`AGENTS.md`, `.claude/rules/<topic>.md`, or relevant skill), add `promoted` tag to the WORKLOG entry. Do not ask the user to confirm, rank, or pick which candidates to promote. The criteria are the filter; the agent's job is to decide and act. The user can revert via git if a promotion landed wrong.
5. **Show the user** what was appended, what was regenerated, what was promoted (if anything). Brief — file paths and headlines, not full bodies. Surface promotions clearly so the user can review and revert if needed.

All steps run silently and without prompts. `/worklog` never pauses for input.

### `/worklog-index` — periodic gardening

Run when the user invokes it explicitly, or suggest it after a graduation pass surfaces a tag-merge opportunity. Steps:

1. **Retroactive graduation sweep** — re-evaluate older entries against current criteria. Stable, referenced, or now-enforced-upstream entries get **promoted directly** (rewrite as positive rule, write to target file — AGENTS.md / `.claude/rules/` / skill — tag entry as `promoted`). Surface what was promoted in the summary. Do not ask the user to confirm or pick.
2. **Tag pruning** — any tag with count 1 that doesn't fit a clear future category gets folded into a parent (e.g. `next-15` + `next-16` + `upgrade` → `next`). Apply merges directly. Surface what merged in the summary.
3. **INDEX regen** with the pruned vocabulary.

### `/worklog` discipline (both modes)

- **Running `/worklog` is the approval.** Write directly. Do not ask "keep / edit / discard" — that re-gates intent the user already expressed by invoking the command. Show what was appended after the write so the user can see and revise if needed.
- **Never ask the user "which moment to capture" when bare-invoked.** Commit to a reading. The significance gate is the filter; the agent's job is to be conservative on borderline cases.
- **Never spawn a subagent** (Explore or otherwise) to scan the transcript. The main thread already has the session loaded; passing the transcript into a subagent prompt overflows its window and produces a worse reading from less context. Run inline.
- **Translate phrasing.** Convert emotional, frustrated, or conversational user wording into a neutral durable claim. Preserve the exact words only if the phrasing itself is the lesson.
- **Never tell the user "if you /worklog-index later, X."** If a graduation candidate exists, surface it inline now. Deferring graduation to a command the user has to remember defeats the auto-maintenance design.
- **No confirmation prompts.** Both modes run without asking. Append, regen, promote, surface what happened. The user can revert via git if anything landed wrong. Asking the user to rank or pick between candidates re-gates the very judgment the skill exists to remove. Bootstrap and graduation writes both happen silently — surface the action in the post-run summary, not a pre-run prompt.
- **Don't recreate auto memory.** If a candidate is a single-session Claude correction that would only matter to Claude on this machine, skip it — auto memory handles it. WORKLOG.md is for cross-agent project history.

Zero candidates is a valid outcome in distill mode. Don't fabricate signal — the file is append-only and false entries decay it. If something landed wrong, the user edits the file directly or logs a correction.
