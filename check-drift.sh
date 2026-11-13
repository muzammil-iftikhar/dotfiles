#!/usr/bin/env bash
# Compare every tracked config against the live copy on this machine.
# Read-only: it never writes to $HOME or to the repo.
#
#   ./check-drift.sh          summary + list of differences
#   ./check-drift.sh -v       also print the diff for each drifted file
#
# Exit 0 = repo matches the machine, 1 = drift, 2 = a live file is missing.
set -uo pipefail
cd "$(dirname "$0")" || exit 2

verbose=0
[ "${1-}" = "-v" ] && verbose=1

same=0 drift=0 missing=0
drifted=() missing_list=()

# Locally modified copies are expected: the repo stores secrets blanked and
# machine-specific ids stripped, so normalise both sides before comparing.
mask() { # mask <repo-relative-source> ; reads stdin
    case "$1" in
        .zshrc)      sed -E 's/^(export [A-Z_]*_API_KEY=).*/\1/' ;;
        pi/mcp.json) jq -S '.mcpServers.context7.args |= map(if test("^ctx7sk") then "" else . end)' ;;
        openviking/ov.conf)
            jq -S 'del(.server.root_api_key, .vlm.api_key)' ;;
        openviking/ovcli.conf)
            jq -S 'del(.api_key, .root_api_key)' ;;
        *)           cat ;;
    esac
}

check_file() { # check_file <repo-path> <live-path>
    local src=$1 live=$2
    if [ ! -e "$live" ]; then
        missing=$((missing + 1)); missing_list+=("$live  (repo: $src)")
        return
    fi
    if cmp -s <(mask "$src" < "$src") <(mask "$src" < "$live"); then
        same=$((same + 1))
    else
        drift=$((drift + 1)); drifted+=("$src  ->  $live")
        [ "$verbose" = 1 ] && diff -u <(mask "$src" < "$src") <(mask "$src" < "$live") | head -40
    fi
}

check_tree() { # check_tree <repo-dir> <live-dir>
    local src=$1 live=$2 f rel
    while IFS= read -r f; do
        rel=${f#"$src"/}
        check_file "$f" "$live/$rel"
    done < <(find "$src" -type f ! -path '*/node_modules/*')
}

# --- single files -------------------------------------------------------------
check_file .zshrc               "$HOME/.zshrc"
check_file .gitconfig           "$HOME/.gitconfig"
check_file tmux.conf            "$HOME/.config/tmux/tmux.conf"
check_file starship.toml        "$HOME/.config/starship/starship.toml"
check_file exa-wrapper.sh       "$HOME/exa-wrapper.sh"
check_file meld-wrapper.sh      "$HOME/meld-wrapper.sh"
check_file openviking/ov.conf   "$HOME/.openviking/ov.conf"
check_file openviking/ovcli.conf "$HOME/.openviking/ovcli.conf"
check_file openviking/ovcli.settings.conf "$HOME/.openviking/ovcli.settings.conf"
check_file openviking/openviking.service  "$HOME/.config/systemd/user/openviking.service"

# --- trees --------------------------------------------------------------------
check_tree nvim "$HOME/.config/nvim"
check_tree pi   "$HOME/.pi/agent"

# --- the one symlink we care about -------------------------------------------
link="$HOME/.tmux.conf"
if [ ! -L "$link" ]; then
    drift=$((drift + 1)); drifted+=("(symlink) $link is not a symlink")
elif [ "$(readlink -f "$link")" != "$(readlink -f "$HOME/.config/tmux/tmux.conf")" ]; then
    drift=$((drift + 1)); drifted+=("(symlink) $link -> $(readlink "$link") (broken or wrong target)")
else
    same=$((same + 1))
fi

# --- report -------------------------------------------------------------------
echo "checked: $same in sync, $drift drifted, $missing missing"
if [ ${#drifted[@]} -gt 0 ]; then
    echo "drifted:"
    printf '  %s\n' "${drifted[@]}"
fi
if [ ${#missing_list[@]} -gt 0 ]; then
    echo "missing live files:"
    printf '  %s\n' "${missing_list[@]}"
fi
[ "$drift" -eq 0 ] && [ "$missing" -eq 0 ] && exit 0
[ "$missing" -gt 0 ] && exit 2
exit 1
