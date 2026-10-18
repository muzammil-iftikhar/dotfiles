#!/usr/bin/env bash
#
# restore.sh — rebuild `~/.pi/agent` from this backup (`dotfiles/pi`).
#
# This directory is named `pi/`, NOT `.pi/`, on purpose: a `.pi/` directory in a
# repo is pi's own project-config location, and pi will install npm packages and
# clone packages into it whenever it runs with that repo as the cwd.
#
# What it does
#   1. copies the portable pi config: AGENTS.md, settings.json, models.json,
#      mcp.json, trust.json and the `bin/pi` wrapper
#   2. copies the files that have NO git remote anywhere (the only vendored
#      content): extensions/ask-user-question.ts, extensions/quotas.json,
#      extensions/prompt-snippets/
#   3. installs the vendored `find-skills` skill as a REAL directory
#      (on the source machine it lived outside pi, in `~/.agents/skills/`)
#   4. re-clones the 7 third-party repos, each pinned to the recorded full SHA
#   5. re-creates the `extensions/pi-tmux-status.ts` symlink into that clone
#   6. runs `npm ci` for the two trees that carry a package-lock.json
#
# Policy: NOTHING that has a git remote is vendored here — every such file is
# referenced by https URL + full SHA in the REPOS table below and rebuilt by
# this script. Only files with no remote are copied (steps 2 and 3).
#
# Prerequisites
#   * pi must already be installed. `bin/pi` is only a wrapper; the real pi
#     install (`~/.pi/agent/install/`, ~306M) is NOT part of this backup and
#     is not restored here — install pi first, then run this script.
#   * git (required), npm (optional; skipped with a warning if absent).
#
# Credentials are NOT restored: `auth.json`, `mcp-auth.json` and the API key
# in `mcp.json` are secrets and are never stored in this backup. Re-run the
# provider login flow after restoring (see the "manual steps" block at the end).
#
# Usage
#   ./restore.sh            # refuses to touch an existing ~/.pi/agent
#   ./restore.sh --force    # restores into an existing ~/.pi/agent

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.pi/agent"
FORCE=0

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help) sed -n '2,40p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

say() { printf '\n==> %s\n' "$*"; }

if [ -e "$DEST" ] && [ "$FORCE" -ne 1 ]; then
  cat >&2 <<EOF
Error: ${DEST} already exists.

Refusing to overwrite it. Move it aside, or re-run with --force:

    ./restore.sh --force

EOF
  exit 1
fi

say "Restoring pi agent config from ${SRC} into ${DEST}"
mkdir -p "${DEST}/bin" "${DEST}/extensions" "${DEST}/skills" "${DEST}/git/github.com"

say "Copying config files"
cp -a "${SRC}/AGENTS.md" "${SRC}/settings.json" "${SRC}/models.json" \
      "${SRC}/mcp.json" "${SRC}/trust.json" "${DEST}/"
cp -a "${SRC}/bin/." "${DEST}/bin/"
chmod 0755 "${DEST}/bin/pi"
echo "    AGENTS.md settings.json models.json mcp.json trust.json bin/pi"

say "Copying extensions (no-remote files only)"
cp -a "${SRC}/extensions/." "${DEST}/extensions/"
echo "    extensions/ask-user-question.ts extensions/quotas.json extensions/prompt-snippets/"

say "Installing vendored find-skills skill (real directory, not a symlink)"
mkdir -p "${DEST}/skills"
cp -aL "${SRC}/skills/find-skills" "${DEST}/skills/find-skills"
test ! -L "${DEST}/skills/find-skills" || { echo "    ERROR: find-skills is a symlink" >&2; exit 1; }
echo "    skills/find-skills/"

# ---------------------------------------------------------------------------
# Third-party repos, pinned to the commits recorded in MANIFEST.md.
#
# https:// URLs are used on purpose so the restore works without SSH keys.
# NOTE: three of them live under `muzammil-iftikhar` (pi-quotas, pi-tmux-status,
# and the pi-interactive-subagents FORK). pi-quotas and pi-tmux-status are
# private, so cloning those over https needs an account with access to them
# (a GitHub token / credential helper), or they will fail and be reported at
# the end.
# ---------------------------------------------------------------------------
REPOS=(
  "git/github.com/DietrichGebert/ponytail|https://github.com/DietrichGebert/ponytail|09c434ab73ca43761c5d8b0c5d341926c2fba710"
  "git/github.com/ayghri/i-have-adhd|https://github.com/ayghri/i-have-adhd|1ecea1993b7fce257ffbd686c070948b5e07eda6"
  "git/github.com/cathrynlavery/diagram-design|https://github.com/cathrynlavery/diagram-design|550fd66edff058bc73056c3416b76d69cfe865ba"
  # directory name is latentminds-ai/pi-quotas, but the origin remote is muzammil-iftikhar/pi-quotas;
  # settings.json references the DIRECTORY path, so clone into the target column verbatim.
  "git/github.com/latentminds-ai/pi-quotas|https://github.com/muzammil-iftikhar/pi-quotas|61b35e74cf621b979936f016633eb2cded7f57c3"
  "git/github.com/muzammil-iftikhar/pi-tmux-status|https://github.com/muzammil-iftikhar/pi-tmux-status|1e20835a8da52bfbc3ff36088fc60bf3c1e986e2"
  "git/github.com/pasky/chrome-cdp-skill|https://github.com/pasky/chrome-cdp-skill|b7fa631fb8201ef42dab040f3ce20fca1790abb0"
  # the user's own FORK (muzammil-iftikhar), NOT upstream amosblomqvist: fork/main ==
  # the pinned HEAD and is 13 commits ahead of upstream, so upstream lacks these changes.
  "extensions/pi-interactive-subagents|https://github.com/muzammil-iftikhar/pi-interactive-subagents|4ea1194f50d8f36feccdc11f2aac760252750966"
)

FAILURES=()

say "Cloning ${#REPOS[@]} third-party repos (pinned commits)"
for entry in "${REPOS[@]}"; do
  IFS='|' read -r target url sha <<<"$entry"
  full="${DEST}/${target}"
  printf '\n--- %s\n    url: %s\n    sha: %s\n' "$target" "$url" "$sha"

  mkdir -p "$(dirname "$full")"
  if [ -e "$full/.git" ]; then
    echo "    already cloned, reusing"
  else
    rm -rf "$full"
    if ! git clone "$url" "$full"; then
      echo "    FAILED to clone $url" >&2
      FAILURES+=("clone $target")
      continue
    fi
  fi

  # Shallow fetch of the exact commit; fall back to a full fetch if the server
  # refuses to serve an unreferenced SHA with --depth 1.
  if ! git -C "$full" fetch --depth 1 origin "$sha" 2>/dev/null; then
    echo "    shallow fetch of $sha failed, retrying with a full fetch"
    git -C "$full" fetch origin || true
  fi

  if git -C "$full" checkout --detach "$sha"; then
    echo "    checked out $sha"
  else
    echo "    FAILED to check out $sha in $target" >&2
    FAILURES+=("checkout $target@$sha")
  fi
done

# ---------------------------------------------------------------------------
# pi-tmux-status.ts is NOT vendored (it has a remote). Re-create the symlink
# into the freshly cloned repo, as pi finds the extension through this path.
# ---------------------------------------------------------------------------
say "Linking extensions/pi-tmux-status.ts"
TMUX_SRC="${DEST}/git/github.com/muzammil-iftikhar/pi-tmux-status/pi-tmux-status.ts"
TMUX_LINK="${DEST}/extensions/pi-tmux-status.ts"
if [ -f "$TMUX_SRC" ]; then
  mkdir -p "$(dirname "$TMUX_LINK")"
  ln -sfn "$TMUX_SRC" "$TMUX_LINK"
  echo "    ${TMUX_LINK} -> ${TMUX_SRC}"
else
  echo "    ERROR: target ${TMUX_SRC} not found — did the pi-tmux-status clone fail?" >&2
  FAILURES+=("symlink extensions/pi-tmux-status.ts (missing target)")
fi

# ---------------------------------------------------------------------------
# npm dependencies for the two trees that ship a package-lock.json
# ---------------------------------------------------------------------------
NPM_TREES=(
  "git/github.com/latentminds-ai/pi-quotas"
  "extensions/pi-interactive-subagents"
)

say "Installing npm dependencies"
if command -v npm >/dev/null 2>&1; then
  for tree in "${NPM_TREES[@]}"; do
    dir="${DEST}/${tree}"
    if [ -f "${dir}/package.json" ] && [ -f "${dir}/package-lock.json" ]; then
      echo "    npm ci in ${tree}"
      if ! (cd "$dir" && npm ci --no-audit --no-fund); then
        echo "    WARNING: npm ci failed in ${tree}" >&2
        FAILURES+=("npm ci $tree")
      fi
    else
      echo "    WARNING: ${tree} is missing package.json/package-lock.json, skipping" >&2
    fi
  done
else
  echo "    WARNING: npm not found — skipping dependency install."
  echo "             Run 'npm ci --no-audit --no-fund' later in:"
  for tree in "${NPM_TREES[@]}"; do echo "               ${DEST}/${tree}"; done
fi

# ---------------------------------------------------------------------------
cat <<EOF

============================================================
 Restore finished.
============================================================

Manual steps remaining:

  1. Authenticate providers — credentials are NEVER restored from this
     backup (\`auth.json\` / \`mcp-auth.json\` are secrets on purpose).
     Start pi and run the login/auth flow for each provider.
     If you use the context7 MCP server, also supply its API key
     (it was blanked in the backed-up \`mcp.json\`).

  2. Verify \`defaultProvider\` / \`defaultModel\` in:
         ${DEST}/settings.json
     The pinned model/provider names may differ on a fresh machine.

  3. Restart pi.
EOF

if [ "${#FAILURES[@]}" -gt 0 ]; then
  cat >&2 <<EOF

============================================================
 ${#FAILURES[@]} FAILURE(S) — please finish these by hand:
============================================================
EOF
  for f in "${FAILURES[@]}"; do echo "  - $f" >&2; done
  echo >&2
  exit 1
fi

echo
echo "All steps completed successfully."
