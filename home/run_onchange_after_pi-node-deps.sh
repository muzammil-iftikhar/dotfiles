#!/bin/sh
# Runs once after `chezmoi apply` writes the pi config, and again whenever this
# script's own contents change (run_onchange_). Idempotent.
#
# The three trees pi loads as extensions ship a package-lock.json; pi's own
# `pi update --extensions` and the git clones are handled by pi itself.
#
# Only acts when node_modules is missing: this script must never destroy a
# working tree by running `npm ci` (which deletes node_modules) on it.
set -e
[ -d "$HOME/.pi/agent" ] || exit 0
command -v npm >/dev/null 2>&1 || exit 0

for tree in \
    "$HOME/.pi/agent/git/github.com/latentminds-ai/pi-quotas" \
    "$HOME/.pi/agent/extensions/pi-interactive-subagents" \
    "$HOME/.pi/agent/extensions/openviking"
do
    [ -f "$tree/package-lock.json" ] || continue
    [ -d "$tree/node_modules" ] && continue
    echo "npm ci in $tree"
    (cd "$tree" && npm ci --no-audit --no-fund)
done
