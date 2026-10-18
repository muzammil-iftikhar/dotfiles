# pi agent config backup — MANIFEST

- **Source dir:** `~/.pi/agent` (i.e. `/home/muzammil/.pi/agent`)
- **Host:** Muzammil-Laptop
- **Date (ISO):** 2026-10-19T01:26:19+05:00
- **pi version:** `1.3.0` (from `/home/muzammil/.pi/agent/install/releases/1.3.0/`; also equals `install/current-version`)
- **Purpose:** Version-control the hand-written, portable parts of the pi agent config (settings, extensions, prompt snippets, wrapper) while deliberately excluding secrets, session data, caches, and multi-hundred-MB re-installable/re-clonable trees.

---

## Copied

Everything below was copied with `cp -a` (mode + timestamps preserved). Sizes are the byte counts as copied.

| Path (relative to `.pi/`) | Bytes | Mode |
| --- | ---: | --- |
| `AGENTS.md` | 4061 | 0664 |
| `settings.json` | 763 | 0664 |
| `models.json` | 296 | 0664 |
| `mcp.json` | 312 | 0644 |
| `trust.json` | 157 | 0664 |
| `bin/pi` | 1467 | 0755 (executable) |
| `extensions/ask-user-question.ts` | 20411 | 0664 |
| `extensions/pi-tmux-status.ts` | 90 | symlink → `/home/muzammil/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts` |
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

Directories (copied implicitly): `bin/` (0755), `extensions/` (0755), `extensions/prompt-snippets/` (0775), `extensions/prompt-snippets/snippets/` (0775).

Total on disk: **120K** (`du -sh`).

> Note: `extensions/pi-tmux-status.ts` is a **symlink**, not a regular file. `cp -a` preserved it as a symlink pointing at the re-clonable `pi-tmux-status` repo (see *Cloned repos to re-clone*); the file content is not stored here. Restoring that repo at the same path makes the link resolve.

---

## Excluded

Not copied. Sizes are `du -sh` on the source.

| Path | Size | Reason |
| --- | ---: | --- |
| `auth.json` | 4.0K | **secret** — provider OAuth tokens/credentials |
| `mcp-auth.json` | 8.0K | **secret** — MCP OAuth tokens |
| `sessions/` | 330M | session data |
| `install/` | 306M | re-installable (pi releases) |
| `npm/` | 283M | re-installable (npm deps) |
| `git/` | 396M | too large for a git repo / re-clonable (see list below) |
| `models-store.json` | 308K | generated cache |
| `mcp-cache.json` | 200K | cache |
| `mcp-npx-cache.json` | 4.0K | cache |
| `mcp-onboarding.json` | 4.0K | cache / generated state |
| `mcp-project-approvals.json` | 4.0K | generated state |
| `pi-crash.log` | 3.2M | log / generated |
| `run-history.jsonl` | 12K | session data |
| `usage-cache.json` | 4.0K | cache |
| `backups/` | 48K | generated (patch backups, see section e) |
| `missions/` | 712K | session data |
| `pi-subagents/` | 8.0K | generated state |
| `skills/` | 4.0K | symlink to external source of truth (see section f) |
| `extensions/pi-interactive-subagents/` | 160M | too large / re-clonable (own `.git`, see section d) |

---

## Cloned repos to re-clone

All git repos found under `~/.pi/agent/git/` plus the separate repo at `extensions/pi-interactive-subagents`. Paths are relative to `~/.pi/agent`. **7 repos** total.

| Path | `remote.origin.url` | HEAD (short) |
| --- | --- | --- |
| `git/github.com/latentminds-ai/pi-quotas` | `git@github.com:muzammil-iftikhar/pi-quotas.git` | `61b35e7` |
| `git/github.com/cathrynlavery/diagram-design` | `https://github.com/cathrynlavery/diagram-design` | `550fd66` |
| `git/github.com/pasky/chrome-cdp-skill` | `https://github.com/pasky/chrome-cdp-skill` | `b7fa631` |
| `git/github.com/ayghri/i-have-adhd` | `https://github.com/ayghri/i-have-adhd` | `1ecea19` |
| `git/github.com/muzammil-iftikhar/pi-tmux-status` | `git@github.com:muzammil-iftikhar/pi-tmux-status.git` | `1e20835` |
| `git/github.com/DietrichGebert/ponytail` | `https://github.com/DietrichGebert/ponytail` | `09c434a` |
| `extensions/pi-interactive-subagents` | `https://github.com/amosblomqvist/pi-interactive-subagents.git` | `4ea1194` |

Restore notes for this section:

- The local directory name for pi-quotas is `git/github.com/latentminds-ai/pi-quotas`, but the origin remote is `muzammil-iftikhar/pi-quotas`. Clone **into the path column**, not into a path derived from the remote URL, otherwise the `"git/github.com/latentminds-ai/pi-quotas"` entry in `settings.json` will not resolve.
- `chrome-cdp-skill` is checked out at a detached HEAD (`b7fa631`, settings.json pins `@v1.0.1`).
- Working trees were not verified clean for all repos at backup time; `chrome-cdp-skill`, `i-have-adhd` and `ponytail` reported local changes, so their local edits are **not** captured by this backup.

---

## Local modifications worth preserving

`pi-interactive-subagents` was patched locally (its repo reported no uncommitted changes, so the patch is already applied/committed in the re-clonable tree, but the patch backup is kept under `backups/`). The patch header shows it modifies `README.md`, adding a **Worktrees** section that documents a `worktree: true` opt-in for running a sub-agent in its own git worktree (and a `/subagent --worktree <agent> <task>` invocation) instead of the caller's checkout.

Backup files (deliberately **not** copied into this repo):

- `/home/muzammil/.pi/agent/backups/pi-interactive-subagents.20261009-005046.patch`
- `/home/muzammil/.pi/agent/backups/pi-interactive-subagents.untracked-worktree-spawn.test.ts.20261009-005046`

(also present: `pi-interactive-subagents.20261009-005046.status.txt`, `last-backup.txt`)

---

## Symlinks

- **`skills/find-skills`** → `../../../.agents/skills/find-skills`, which resolves **outside `~/.pi`** to `/home/muzammil/.agents/skills/find-skills`. That skill is therefore **not backed up here**; its source of truth is `/home/muzammil/.agents/skills/find-skills`.
- **`extensions/pi-tmux-status.ts`** → `git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts`. This symlink **is** copied (see *Copied*), but it dangles until that repo is re-cloned at the same path (section d).

---

## Restore

Rebuild `~/.pi/agent` from this backup on a new machine:

1. **Copy config files back.** From the dotfiles repo:
   ```sh
   mkdir -p ~/.pi/agent
   cp -a .pi/AGENTS.md .pi/settings.json .pi/models.json .pi/mcp.json .pi/trust.json ~/.pi/agent/
   mkdir -p ~/.pi/agent/bin ~/.pi/agent/extensions
   cp -a .pi/bin/pi ~/.pi/agent/bin/pi
   cp -a .pi/extensions/ask-user-question.ts .pi/extensions/quotas.json ~/.pi/agent/extensions/
   cp -a .pi/extensions/prompt-snippets ~/.pi/agent/extensions/prompt-snippets
   ```
2. **Restore the wrapper's mode** (git may not preserve the exec bit):
   ```sh
   chmod 0755 ~/.pi/agent/bin/pi
   ```
3. **Re-clone the repos** from *Cloned repos to re-clone*, each into its exact path column, then check out the recorded SHA:
   ```sh
   mkdir -p ~/.pi/agent/git/github.com/{latentminds-ai,cathrynlavery,pasky,ayghri,muzammil-iftikhar,DietrichGebert}
   git clone git@github.com:muzammil-iftikhar/pi-quotas.git                     ~/.pi/agent/git/github.com/latentminds-ai/pi-quotas
   git clone https://github.com/cathrynlavery/diagram-design                    ~/.pi/agent/git/github.com/cathrynlavery/diagram-design
   git clone https://github.com/pasky/chrome-cdp-skill                          ~/.pi/agent/git/github.com/pasky/chrome-cdp-skill
   git clone https://github.com/ayghri/i-have-adhd                              ~/.pi/agent/git/github.com/ayghri/i-have-adhd
   git clone git@github.com:muzammil-iftikhar/pi-tmux-status.git                ~/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status
   git clone https://github.com/DietrichGebert/ponytail                         ~/.pi/agent/git/github.com/DietrichGebert/ponytail
   git clone https://github.com/amosblomqvist/pi-interactive-subagents.git      ~/.pi/agent/extensions/pi-interactive-subagents

   # pin to the SHAs recorded above
   git -C ~/.pi/agent/git/github.com/latentminds-ai/pi-quotas            checkout 61b35e7
   git -C ~/.pi/agent/git/github.com/cathrynlavery/diagram-design        checkout 550fd66
   git -C ~/.pi/agent/git/github.com/pasky/chrome-cdp-skill              checkout b7fa631
   git -C ~/.pi/agent/git/github.com/ayghri/i-have-adhd                  checkout 1ecea19
   git -C ~/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status    checkout 1e20835
   git -C ~/.pi/agent/git/github.com/DietrichGebert/ponytail             checkout 09c434a
   git -C ~/.pi/agent/extensions/pi-interactive-subagents                checkout 4ea1194
   ```
4. **Re-create the extension symlink** (fires once `pi-tmux-status` is cloned):
   ```sh
   ln -sfn /home/muzammil/.pi/agent/git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts \
           ~/.pi/agent/extensions/pi-tmux-status.ts
   ```
5. **Re-create the `skills/find-skills` symlink** (its source of truth lives outside `~/.pi`):
   ```sh
   mkdir -p ~/.pi/agent/skills
   ln -sfn ../../../.agents/skills/find-skills ~/.pi/agent/skills/find-skills
   # ensure the target exists: ~/.agents/skills/find-skills
   ```
6. **Re-authenticate — do NOT copy credentials from git.** `auth.json` and `mcp-auth.json` are **not** in this backup (they are secrets). Log in anew:
   ```sh
   # provider login + MCP OAuth, e.g.:
   pi            # then use the login/auth flow
   ```
   Model/provider selections in `settings.json` and the MCP server list in `mcp.json` are restored above and should be honoured once you are logged in.
7. **Sanity check:** `pi --version` should report `1.3.0`, `ls -l ~/.pi/agent/bin/pi` should be `-rwxr-xr-x`, and `pi` should start with your theme/model intact.

> `mcp.json` was copied with an inline `context7` API key; that value has since been blanked in this repo. Supply it locally at run time, or restore it from your own credentials.
