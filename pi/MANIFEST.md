# pi agent config backup — MANIFEST

- **Source dir:** `~/.pi/agent` (`/home/muzammil/.pi/agent`)
- **Location:** `dotfiles/pi/` (this directory), mirroring `~/.pi/agent/`. Not named `.pi/` on purpose: `.pi/` is pi's own project-config location, so pi running with this repo as cwd installed npm packages and cloned packages into it, regenerating **89M / 10,883 files** of runtime state (since deleted).
- **Host:** Muzammil-Laptop
- **Date (ISO):** 2026-10-19T01:37:58+05:00 (no-remote files vendored; everything with a remote is referenced by https URL + full SHA and rebuilt from the Clone tables in this document)
- **pi version:** `1.3.0` (from `/home/muzammil/.pi/agent/install/releases/1.3.0/`; equals `install/current-version`)
- **Purpose:** Version-control the hand-written, portable parts of the pi agent config (settings, extensions, prompt snippets, wrapper), excluding secrets, session data, caches and multi-hundred-MB re-installable/re-clonable trees.

**Policy:** nothing with a git remote is vendored here — it is referenced by https URL + full SHA. Only files with no remote are copied.

> History: commit `a4f79f4` added this backup as `dotfiles/.pi/`; it was later renamed to `dotfiles/pi/`, so `git log --follow` / `--find-renames` still shows the old `.pi/` path. Expected, not a second copy.

## Copied

Copied with `cp -a` (mode + timestamps preserved); `skills/find-skills/` used `cp -aL` (dereferencing the symlink it was on the source machine). Bytes are as copied.

| Path (relative to `pi/`) | Bytes | Mode |
| --- | ---: | --- |
| `AGENTS.md` | 4061 | 0664 |
| `settings.json` | 763 | 0664 |
| `models.json` | 296 | 0664 |
| `mcp.json` | 269 | 0644 |
| `trust.json` | 157 | 0664 |
| `bin/pi` | 1467 | 0755 (executable) |
| `extensions/ask-user-question.ts` | 20411 | 0664 |
| `extensions/quotas.json` | 134 | 0664 |
| `extensions/prompt-snippets/README.md` | 2095 | 0664 |
| `extensions/prompt-snippets/index.ts` | 11655 | 0664 |
| `extensions/prompt-snippets/snippets/ask-questions.md` | 257 | 0664 |
| `extensions/prompt-snippets/snippets/delegate-exploration.md` | 346 | 0664 |
| `extensions/prompt-snippets/snippets/diagnose-report.md` | 258 | 0664 |
| `extensions/prompt-snippets/snippets/orchestrator-mode.md` | 385 | 0664 |
| `extensions/prompt-snippets/snippets/parallel-plan-implementation.md` | 499 | 0644 |
| `extensions/prompt-snippets/snippets/session-kickoff.md` | 280 | 0664 |
| `extensions/prompt-snippets/snippets/verify-not-assume.md` | 343 | 0664 |
| `extensions/prompt-snippets/snippets/worktree-orchestration.md` | 1015 | 0644 |
| `skills/find-skills/` | 12K (1 file) | dir, **vendored** from `~/.agents/skills/find-skills` (`cp -aL`, real directory) |
| `skills/find-skills/SKILL.md` | 5472 | 0664 |
| `MANIFEST.md` | — | 0644 (this file; not part of the restore) |

Directories (implicitly): `bin/` 0755, `extensions/` 0755, `extensions/prompt-snippets/` 0775, `extensions/prompt-snippets/snippets/` 0775, `skills/` 0755, `skills/find-skills/` 0775.

Total on disk: **148K, 20 files, zero symlinks** (`du -sh pi`; `find pi -type f | wc -l`; `find pi -type l | wc -l`).

> Note: neither `extensions/pi-tmux-status.ts` nor `extensions/pi-interactive-subagents/` is stored here — both have git remotes, so the Restore steps clone them and re-create the `pi-tmux-status.ts` symlink. `skills/find-skills/` is the one exception: it is vendored as a real directory precisely because it has no remote anywhere.

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

Also measured on the source (none of it stored, being re-installable, re-clonable, generated, session data or secrets): `install/` **306M**, `npm/` **283M**, `sessions/` **332M**, `git/` **396M**, `pi-quotas/node_modules` **293M**, `pi-interactive-subagents/node_modules` **158M**, `models-store.json` (308K), `pi-crash.log` (3.2M), and the `mcp-*cache` / `usage-cache` / `backups/` / `missions/` / `pi-subagents/` / `run-history.jsonl` entries above.

A fully-offline vendored copy of all 7 repos would be **~46M** (measured; excluding `.git/` and `node_modules/`). This backup **deliberately does not vendor them** — they are pinned by commit in the Clone table below and rebuilt from exactly those commits.

## Cloned repos to re-clone

Every repo under `~/.pi/agent/git/`, plus `extensions/pi-interactive-subagents`. Paths relative to `~/.pi/agent`. **7 repos** total.

| Path (relative to `~/.pi/agent`) | https clone URL | commit (full SHA) |
| --- | --- | --- |
| `git/github.com/DietrichGebert/ponytail` | `https://github.com/DietrichGebert/ponytail` | `09c434ab73ca43761c5d8b0c5d341926c2fba710` |
| `git/github.com/ayghri/i-have-adhd` | `https://github.com/ayghri/i-have-adhd` | `1ecea1993b7fce257ffbd686c070948b5e07eda6` |
| `git/github.com/cathrynlavery/diagram-design` | `https://github.com/cathrynlavery/diagram-design` | `550fd66edff058bc73056c3416b76d69cfe865ba` |
| `git/github.com/latentminds-ai/pi-quotas` | `https://github.com/muzammil-iftikhar/pi-quotas` | `61b35e74cf621b979936f016633eb2cded7f57c3` |
| `git/github.com/muzammil-iftikhar/pi-tmux-status` | `https://github.com/muzammil-iftikhar/pi-tmux-status` | `1e20835a8da52bfbc3ff36088fc60bf3c1e986e2` |
| `git/github.com/pasky/chrome-cdp-skill` | `https://github.com/pasky/chrome-cdp-skill` | `b7fa631fb8201ef42dab040f3ce20fca1790abb0` |
| `extensions/pi-interactive-subagents` | `https://github.com/muzammil-iftikhar/pi-interactive-subagents` | `4ea1194f50d8f36feccdc11f2aac760252750966` |

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

Manual, numbered — there is no script. Run everything from the repo root; `pi/` below is this backup tree.

1. **Install pi itself first.** `bin/pi` in this backup is only a wrapper; the real install (`~/.pi/agent/install/`, ~306M) is **not backed up**. Install pi (the config here is from pi **`1.3.0`**) so that `~/.pi/agent/install/` exists before anything else.
2. **Create the tree:** `mkdir -p ~/.pi/agent/{bin,extensions,skills,git/github.com}`
3. **Copy the five config files** into `~/.pi/agent/`:
   `cp -a pi/AGENTS.md pi/settings.json pi/models.json pi/mcp.json pi/trust.json ~/.pi/agent/`
4. **Copy the wrapper and make it executable:**
   `cp -a pi/bin/pi ~/.pi/agent/bin/pi && chmod 0755 ~/.pi/agent/bin/pi`
5. **Copy the no-remote extension files only** (nothing else in `extensions/` is vendored).
   ```sh
   cp -a pi/extensions/ask-user-question.ts pi/extensions/quotas.json ~/.pi/agent/extensions/
   cp -a pi/extensions/prompt-snippets ~/.pi/agent/extensions/
   ```
6. **Copy the skill as a REAL directory — never a symlink:**
   `cp -aL pi/skills/find-skills ~/.pi/agent/skills/find-skills`
   On the source machine this was a symlink to `~/.agents/skills/find-skills`, which is outside pi and is not backed up; the real files are vendored here.
7. **Clone the 7 repos** into their exact path column. `cd ~/.pi/agent` first — the targets below are relative to that directory, not to the repo root:
   ```sh
   git clone <url> <target> && git -C <target> fetch --depth 1 origin <sha> && git -C <target> checkout --detach <sha>
   ```
   If the `--depth 1` fetch of an unreferenced SHA is refused, run `git -C <target> fetch origin` first, then `git -C <target> checkout --detach <sha>`.

   | `<target>` (relative to `~/.pi/agent`) | `<url>` | `<sha>` |
   | --- | --- | --- |
   | `git/github.com/DietrichGebert/ponytail` | `https://github.com/DietrichGebert/ponytail` | `09c434ab73ca43761c5d8b0c5d341926c2fba710` |
   | `git/github.com/ayghri/i-have-adhd` | `https://github.com/ayghri/i-have-adhd` | `1ecea1993b7fce257ffbd686c070948b5e07eda6` |
   | `git/github.com/cathrynlavery/diagram-design` | `https://github.com/cathrynlavery/diagram-design` | `550fd66edff058bc73056c3416b76d69cfe865ba` |
   | `git/github.com/latentminds-ai/pi-quotas` | `https://github.com/muzammil-iftikhar/pi-quotas` | `61b35e74cf621b979936f016633eb2cded7f57c3` |
   | `git/github.com/muzammil-iftikhar/pi-tmux-status` | `https://github.com/muzammil-iftikhar/pi-tmux-status` | `1e20835a8da52bfbc3ff36088fc60bf3c1e986e2` |
   | `git/github.com/pasky/chrome-cdp-skill` | `https://github.com/pasky/chrome-cdp-skill` | `b7fa631fb8201ef42dab040f3ce20fca1790abb0` |
   | `extensions/pi-interactive-subagents` | `https://github.com/muzammil-iftikhar/pi-interactive-subagents` | `4ea1194f50d8f36feccdc11f2aac760252750966` |

   - `pi-quotas` **must** land in the `latentminds-ai/pi-quotas` directory: `settings.json` references that path, not one derived from its remote (`muzammil-iftikhar/pi-quotas`).
   - `pi-interactive-subagents` **must** come from **https://github.com/muzammil-iftikhar/pi-interactive-subagents** — the user's fork. Upstream `amosblomqvist/…` does not contain the pinned commit `4ea1194`.
   - Two of these are **private** (`pi-quotas`, `pi-tmux-status`), so the https clones need credentials with access.
8. **Re-create the one symlink, after step 7** (it is not vendored):
   ```sh
   ln -sfn ~/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts \
           ~/.pi/agent/extensions/pi-tmux-status.ts
   ```
   Verify the target exists first — otherwise the extension silently will not load.
9. **Install npm deps** (`npm ci --no-audit --no-fund`) in exactly two trees, both of which ship a `package-lock.json`:
   - `~/.pi/agent/git/github.com/latentminds-ai/pi-quotas`
   - `~/.pi/agent/extensions/pi-interactive-subagents`
10. **Manual steps afterwards.** `auth.json` / `mcp-auth.json` are **secrets and deliberately never stored** — authenticate providers with the login flow. If you use the context7 MCP server, supply its API key (it was blanked in `mcp.json`). Verify `defaultProvider` / `defaultModel` in `settings.json`. Then restart pi.
