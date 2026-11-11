# pi agent config backup — MANIFEST

- **Source dir:** `~/.pi/agent` (`/home/muzammil/.pi/agent`)
- **Location:** `dotfiles/home/dot_pi/private_agent/` in the chezmoi source state, mirroring `~/.pi/agent/`. Every entry is applied with `chezmoi apply ~/.pi/agent`; chezmoi's `dot_`/`private_` prefixes encode the leading dot and the `0700` mode, so `dot_pi/private_agent` is `~/.pi/agent`.
- **Host:** Muzammil-Laptop
- **Date (ISO):** 2026-11-11T22:27:48+05:00 (no-remote files vendored; everything with a remote is referenced by https URL + full SHA and rebuilt from the Clone tables in this document)
- **pi version:** `1.5.2` (from `/home/muzammil/.pi/agent/install/releases/1.5.2/`; equals `install/current-version`; `settings.json` has `lastChangelogVersion: 1.5.2`)
- **Purpose:** Version-control the hand-written, portable parts of the pi agent config (settings, extensions, prompt snippets, wrapper), excluding secrets, session data, caches and multi-hundred-MB re-installable/re-clonable trees.

**Policy:** nothing with a git remote is vendored here — it is referenced by https URL + full SHA. Only files with no remote are copied.

> History: commit `a4f79f4` added this backup as `dotfiles/.pi/`; it was later renamed to `dotfiles/pi/`, so `git log --follow` / `--find-renames` still shows the old `.pi/` path. Expected, not a second copy.

## Copied

Tracked by chezmoi (contents copied from `~/.pi/agent`); `skills/find-skills/` used `cp -aL` (dereferencing the symlink it was on the source machine). Bytes are as copied.

| Path (relative to `home/dot_pi/private_agent/`) | Bytes | Mode |
| --- | ---: | --- |
| `AGENTS.md` | 5708 | 0664 |
| `settings.json` | 958 | 0664 |
| `models.json` | 567 | 0664 |
| `mcp.json` | 269 | 0644 |
| `trust.json` | 201 | 0664 |
| `bin/pi` | 1467 | 0755 (executable) |
| `extensions/ask-user-question.ts` | 20411 | 0664 |
| `extensions/quotas.json` | 138 | 0664 |
| `extensions/prompt-snippets/README.md` | 2095 | 0664 |
| `extensions/prompt-snippets/index.ts` | 11655 | 0664 |
| `extensions/prompt-snippets/snippets/ask-questions.md` | 257 | 0664 |
| `extensions/prompt-snippets/snippets/delegate-exploration.md` | 346 | 0664 |
| `extensions/prompt-snippets/snippets/diagnose-report.md` | 258 | 0664 |
| `extensions/prompt-snippets/snippets/orchestrator-mode.md` | 385 | 0664 |
| `extensions/prompt-snippets/snippets/parallel-plan-implementation.md` | 499 | 0644 |
| `extensions/prompt-snippets/snippets/session-kickoff.md` | 280 | 0664 |
| `extensions/prompt-snippets/snippets/verify-not-assume.md` | 343 | 0664 |
| `extensions/prompt-snippets/snippets/worktree-orchestration.md` | 1028 | 0644 |
| *(not stored here)* `skills/find-skills/` | 12K (1 file) | **moved to `extras/find-skills/`** — chezmoi must not own a path that is a symlink into `~/.agents` |

| `extensions/openviking/` | 896K (78 files) | dir, **vendored** — hand-written extension with **no git remote**; `node_modules/` excluded (see Excluded) |
| `MANIFEST.md` | — | 0644 (this file; not part of the restore) |

`extensions/openviking/` contents (78 files, no `node_modules/`): `index.ts`, `client.ts`, `config.ts`, `recall.ts`, `sync.ts`, `takeover.ts`, `tools.ts`, `package.json`, `package-lock.json` (so `npm ci` reproduces deps), `DESIGN.md`, `README.md`, `lib/` (11 generated `.mjs`/`.d.mts`), `shared/` (33 `.mjs`/`.d.mts`), `scripts/` (4), `tests/` (15, incl. `fixtures/`), `skills/` (4 `SKILL.md`: `openviking-memory`, `openviking-rule-search`, `openviking-skills`, `ov-experience-memory`).

Directories (implicitly): `bin/` 0755, `extensions/` 0755, `extensions/prompt-snippets/` 0775, `extensions/prompt-snippets/snippets/` 0775, `extensions/openviking/` 0755 (`lib/`, `shared/`, `scripts/`, `tests/`, `skills/` all 0755), `skills/` 0755, `skills/find-skills/` 0775.

Total on disk: **1.1M, 98 files, zero symlinks** (`du -sh pi`; `find pi -type f | wc -l`; `find pi -type l | wc -l`).

> Note: neither `extensions/pi-tmux-status.ts` nor `extensions/pi-interactive-subagents/` is stored here — both have git remotes, so the Restore steps clone them and re-create the `pi-tmux-status.ts` symlink. One entry is the exception, vendored as real files because it has no remote anywhere: `extensions/openviking/`. The `find-skills` skill is kept in the repo's `extras/` instead (see Restore).

## Excluded

Not copied; sizes are `du -sh` on the source.

| Path | Size | Reason |
| --- | ---: | --- |
| `auth.json` | 4.0K | **secret** — provider OAuth tokens/credentials |
| `mcp-auth.json` | 8.0K | **secret** — MCP OAuth tokens |
| `sessions/` | 330M | session data |
| `install/` | 306M | re-installable (pi releases) |
| `npm/` | 283M | re-installable (npm deps) |
| `git/` | 396M | too large to vendor / re-clonable (see below) |
| `models-store.json` | 308K | generated cache |
| `mcp-*cache*.json`, `usage-cache.json`, `mcp-onboarding.json`, `mcp-project-approvals.json` | ~220K | caches / generated state |
| `pi-crash.log` | 3.2M | log / generated |
| `run-history.jsonl` | 12K | session data |
| `backups/` | 48K | generated (patch backups, see below) |
| `missions/` | 712K | session data |
| `pi-subagents/` | 8.0K | generated state |
| `skills/` (rest of the dir) | 4.0K | the only source entry was the `find-skills` symlink; that skill has **no remote**, so it is vendored under `skills/find-skills/` (real directory) |
| `extensions/pi-interactive-subagents/` | 158M (524K without `node_modules/`) | **not vendored at all** — it has a remote (the user's fork), so step 7 of Restore clones it from URL + pinned SHA |
| `extensions/openviking/node_modules/` | 18M | re-installable — `package-lock.json` **is** vendored, so `npm ci` reproduces it exactly (step 9) |

Also measured on the source (none of it stored, being re-installable, re-clonable, generated, session data or secrets): `install/` **306M**, `npm/` **283M**, `sessions/` **332M**, `git/` **396M**, `pi-quotas/node_modules` **293M**, `pi-interactive-subagents/node_modules` **158M**, `models-store.json` (308K), `pi-crash.log` (3.2M), and the `mcp-*cache` / `usage-cache` / `backups/` / `missions/` / `pi-subagents/` / `run-history.jsonl` entries above.

A fully-offline vendored copy of all 7 repos would be **~46M** (measured; excluding `.git/` and `node_modules/`). This backup **deliberately does not vendor them** — they are pinned by commit in the Clone table below and rebuilt from exactly those commits.

## Cloned repos to re-clone

Every repo under `~/.pi/agent/git/`, plus `extensions/pi-interactive-subagents`. Paths relative to `~/.pi/agent`. **7 repos** total.

| Path (relative to `~/.pi/agent`) | https clone URL | commit (full SHA) |
| --- | --- | --- |
| `git/github.com/DietrichGebert/ponytail` | `https://github.com/DietrichGebert/ponytail` | `96608e078b2d5ea607c5c3b8b5a54d1c1fba6846` |
| `git/github.com/ayghri/i-have-adhd` | `https://github.com/ayghri/i-have-adhd` | `1ecea1993b7fce257ffbd686c070948b5e07eda6` |
| `git/github.com/cathrynlavery/diagram-design` | `https://github.com/cathrynlavery/diagram-design` | `f2496acbde9f45ccb55c24d4f75210c8a1355df8` |
| `git/github.com/latentminds-ai/pi-quotas` | `https://github.com/muzammil-iftikhar/pi-quotas` | `3fbff2303c8dea02f160abf5c56337298baac9c1` |
| `git/github.com/muzammil-iftikhar/pi-tmux-status` | `https://github.com/muzammil-iftikhar/pi-tmux-status` | `1e20835a8da52bfbc3ff36088fc60bf3c1e986e2` |
| `git/github.com/pasky/chrome-cdp-skill` | `https://github.com/pasky/chrome-cdp-skill` | `b7fa631fb8201ef42dab040f3ce20fca1790abb0` |
| `extensions/pi-interactive-subagents` | `https://github.com/muzammil-iftikhar/pi-interactive-subagents` | `cdcbaa9553566efddb6da29a7927bb43f714c1b8` |

**https URLs, not ssh**, so the restore works without SSH keys. Three live under `muzammil-iftikhar` (`pi-quotas`, `pi-tmux-status`, the `pi-interactive-subagents` fork); `pi-quotas` and `pi-tmux-status` are **private**, so cloning them over https needs an account with access (token/credential helper).

- `extensions/pi-interactive-subagents` clones from the user's own **fork** `muzammil-iftikhar/pi-interactive-subagents`, **not** upstream `amosblomqvist/…`: `fork/main ==` the pinned HEAD and is **13 commits ahead** of upstream, so upstream lacks the pinned commit `4ea1194`.
- pi-quotas's local directory is `git/github.com/latentminds-ai/pi-quotas` but its origin is `muzammil-iftikhar/pi-quotas`. Clone into the **path column**, or the `settings.json` entry will not resolve.
- `chrome-cdp-skill` sits at a detached HEAD (`b7fa631`; settings.json pins `@v1.0.1`).
- Working trees: the only dirt on the three third-party clones (`ponytail`, `i-have-adhd`, `chrome-cdp-skill`) was an **untracked `package-lock.json`** each — no tracked edits were lost by not vendoring.

## Local modifications

`pi-interactive-subagents` was patched locally (already applied/committed in the re-clonable tree; the patch backup is kept under `backups/`). The patch adds a **Worktrees** section to `README.md`, documenting a `worktree: true` opt-in (and a `/subagent --worktree <agent> <task>` invocation) for running a sub-agent in its own git worktree instead of the caller's checkout. Backup files (not copied here):

- `/home/muzammil/.pi/agent/backups/pi-interactive-subagents.20261009-005046.patch`
- `/home/muzammil/.pi/agent/backups/pi-interactive-subagents.untracked-worktree-spawn.test.ts.20261009-005046`

(also present: `pi-interactive-subagents.20261009-005046.status.txt`, `last-backup.txt`)

## Symlinks

**No symlinks are stored** — `find pi -type l` returns nothing. The two symlinks on the source machine were resolved differently:

- `extensions/pi-tmux-status.ts` was a symlink into the `pi-tmux-status` clone. It has a remote, so it is **not stored**; the Restore steps re-create it at `git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts`.
- `skills/find-skills` was a symlink to `~/.agents/skills/find-skills`, **outside** pi. It has no remote (installed by `vercel-labs/skills` into `~/.agents`), which is exactly why it is vendored here as a real directory.

## Restore

**Managed by chezmoi** — there is no manual copy step any more. These files are the `home/dot_pi/private_agent/` source state, so any machine with the repo gets them with one command:

```sh
chezmoi apply ~/.pi/agent     # pi only
chezmoi apply                 # everything
```

1. **Install pi first.** `bin/pi` is only a wrapper; the real install (`~/.pi/agent/install/`, ~306M) is **not backed up**. Install pi (this config is from **`1.5.2`**) so `~/.pi/agent/install/` exists. `bin/pi` reads `install/current-version`, so any release works.
2. **Apply the config:** `chezmoi apply ~/.pi/agent`. `create_mcp.json` is `create_`-attributed: it is written when absent and **never overwritten**, so a key you filled in survives every later apply.
3. **Clone the 7 repos** from the Clone table above into their exact paths under `~/.pi/agent/`.
4. **Re-create the one symlink**, after the clones (it is not vendored):
   ```sh
   ln -sfn ~/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts \
           ~/.pi/agent/extensions/pi-tmux-status.ts
   ```
5. **Install npm deps** in the three trees that ship a `package-lock.json`: `extensions/openviking` (`node_modules` is excluded from the repo), `git/github.com/latentminds-ai/pi-quotas`, `extensions/pi-interactive-subagents`. `run_onchange_after_pi-node-deps.sh` in the source state does this automatically on `chezmoi apply` for whichever of the three exist.
6. **Authenticate and fill secrets.** `auth.json` / `mcp-auth.json` are secrets and never stored — log in with the provider flows. Fill the blanked context7 `--api-key` in `~/.pi/agent/mcp.json`. Then restart pi.

`skills/find-skills` is **not** managed by chezmoi: on this machine `~/.pi/agent/skills/find-skills` is a symlink into `~/.agents/skills` (installed by `vercel-labs/skills`), and a managed copy would replace that symlink with a real directory. The skill's only backup is `extras/find-skills/SKILL.md`. On a machine without the symlink, copy it in by hand:

```sh
mkdir -p ~/.pi/agent/skills && cp -r extras/find-skills ~/.pi/agent/skills/
```
