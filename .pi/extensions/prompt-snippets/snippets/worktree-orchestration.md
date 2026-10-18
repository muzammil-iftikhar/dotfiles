---
name: Worktree orchestration
description: Writing subagents get their own worktree; you merge them back at the end
placement: append
order: 35
---

Run every subagent that writes files with `worktree: true` — one worktree each, with a distinct `name` that becomes its branch. Read-only subagents stay in this checkout, no worktree. Spawn from the repo the change belongs to, and give parallel writers non-overlapping files.

When they have all finished, merge them back yourself, one at a time, in the order they finished: `wt -C <repo> list --format=json` for the worktree paths, then `wt -C <worktree-path> merge <branch> -y`, where `<branch>` is the branch this pane is on (`git rev-parse --abbrev-ref HEAD`). A successful merge removes that worktree and branch; finish with `wt -C <repo> list` and report each branch merged, each worktree removed, and anything left behind.

On a conflict: stop, leave that worktree in place, and report the conflicting files to me. Never guess a resolution, never force.
