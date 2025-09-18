#!/bin/bash

#!/bin/bash

echo "=== meld-wrapper.sh called ===" >>/tmp/meld-debug.log
echo "ARGS: $@" >>/tmp/meld-debug.log
date >>/tmp/meld-debug.log

# Convert WSL paths to Windows paths
to_win_path() {
  wslpath -w "$1"
}

if [[ "$#" -eq 2 ]]; then
  # Difftool mode: LOCAL, REMOTE
  LOCAL_WIN=$(to_win_path "$1")
  REMOTE_WIN=$(to_win_path "$2")

  powershell.exe -Command "Start-Process -Wait 'C:\\Users\\Muzammil Iftikhar\\scoop\\shims\\meld.exe' -ArgumentList '${LOCAL_WIN}', '${REMOTE_WIN}'"
elif [[ "$#" -eq 4 ]]; then
  # Mergetool mode: LOCAL, REMOTE, BASE, MERGED
  LOCAL_WIN=$(to_win_path "$1")
  REMOTE_WIN=$(to_win_path "$2")
  BASE_WIN=$(to_win_path "$3")
  MERGED_WIN=$(to_win_path "$4")

  powershell.exe -Command "Start-Process -Wait 'C:\\Users\\Muzammil Iftikhar\\scoop\\shims\\meld.exe' -ArgumentList '${LOCAL_WIN}', '${REMOTE_WIN}', '${BASE_WIN}', '${MERGED_WIN}'"
else
  echo "Unsupported number of arguments: $#" >&2
  exit 1
fi
