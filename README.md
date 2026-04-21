# diverge

Divergent planning skill for Claude Code. Given one goal, `diverge` explores
several implementation directions in parallel, refines them with you, and
emits one executable launcher script per approach so you can start the
implementation you like best in an isolated worktree.

## Install

```
/plugin marketplace add Qnurye/diverge
/plugin install diverge@diverge
```

## Use

```
/diverge <goal description or GitHub issue URL>
```

`diverge` runs through a six-phase state machine (grounding → clarifying →
abstracting → planning → reviewing → launching). At the end you get one
script per direction under `/tmp/diverge/<goal-slug>/<direction-slug>.sh`.

## Requirements

- Claude Code with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- `jq`, `git`, and [`wt` (worktrunk)](https://github.com/max-sixty/worktrunk)
  on your PATH. `gather-context.sh` checks these at Phase 0.

## What's inside

- `skills/diverge/SKILL.md` — state-machine orchestrator playbook
- `PROTOCOL.md` — signal definitions shared across the agent team
- `agents/diverge-*.md` — 7 agents (plan writer, devil's advocate, spec
  auditor, implementer, TDD writer/implementer/DA)
- `scripts/*.sh` — Phase 0 context grounding, Phase 5 launcher
  generation, and worktree helper scripts
- `monitor/` — optional observability UI (Bun server + HTML) that
  surfaces live state during a diverge run; emits are best-effort and
  the skill falls back silently if `bun` is not installed
