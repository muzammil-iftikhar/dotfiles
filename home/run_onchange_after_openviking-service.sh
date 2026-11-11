#!/bin/sh
# Runs once after `chezmoi apply` writes the OpenViking files, and again whenever
# this script's own contents change (run_onchange_). Idempotent.
set -e
[ -f "$HOME/.openviking/ov.conf" ] || exit 0
[ -f "$HOME/.config/systemd/user/openviking.service" ] || exit 0
command -v systemctl >/dev/null 2>&1 || exit 0
systemctl --user daemon-reload || true
systemctl --user enable --now openviking.service
