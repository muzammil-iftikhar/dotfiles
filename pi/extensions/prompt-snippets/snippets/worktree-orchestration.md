---
name: Worktree orchestration
description: Writing subagents get their own worktree; you merge them back at the end
placement: append
order: 35
---
Run every file-writing subagent with `worktree: true` — one worktree each, its `name` becoming the branch (`<repo>.<name>`). Read-only subagents stay in this checkout. Spawn from the repo the change belongs to; parallel writers get non-overlapping files.

When all have finished, merge them back one at a time in the order they finished: `git -C <repo> worktree list` gives the paths, then from the repo checkout on this pane's branch (`git rev-parse --abbrev-ref HEAD`) run `merge --no-ff <branch>` (or `--squash` if I asked for one commit), `worktree remove <path>`, `branch -d <branch>`. Report every branch merged, every worktree removed, and anything left behind.

Stop and report instead of forcing: on a merge conflict, leave that worktree in place and name the conflicting files; on a removal refused for uncommitted files. Never guess a resolution, never `--force`.
