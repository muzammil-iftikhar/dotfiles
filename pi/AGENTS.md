# Agent Guidelines

## Rule Hierarchy

- User's direct instruction wins over everything in this file; when rules conflict, the more specific one applies
- This file is global (lives in `~/.pi/agent`): keep it general. Put project-specific conventions in the repo's own AGENTS.md
- If unsure whether a rule applies, ask rather than guess

## Planning & Execution

- Enter plan mode for any non-trivial task (3+ steps or architectural decisions); small one-off fixes skip planning
- Check in with the user to verify the plan before starting implementation of non-trivial tasks
- Check in again after the first working slice on long tasks - catch drift early
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use subagents liberally to keep the main context window clean - offload research, exploration, documentation, and parallel analysis; one task per subagent
- Always re-read a file immediately before planning or editing it - never rely on stale content or line numbers
- Don't create files unless necessary - prefer editing existing ones
- Make changes as simple as possible and touch only what's necessary. Find root causes, no temporary fixes
- Don't over-engineer simple fixes; for non-trivial changes, pause and ask "is there a more elegant way?" - if a fix feels hacky, implement the elegant solution
- Stay in scope: never expand the task beyond what was asked. Don't refactor unrelated code. If you spot something worth fixing, mention it - don't fix it

## Verification Before Done

- Never mark a task complete without proving it works: run tests, check logs, demonstrate correctness
- If the repo has no tests, write a minimal throwaway smoke test (clean it up after) or demonstrate the behavior, then say exactly what you verified
- Diff behavior between main and your changes when relevant
- Challenge your own work before presenting it: "Would a Staff engineer approve this?"
- When unsure about a fact or behavior, verify rather than fabricate; say so when you don't know

## Autonomous Bug Fixing

- **No fix proposal without the file:line that produces the behaviour - a symptom is not a mechanism.** If you cannot cite the line, stop and go read it
- When given a bug report: just fix it. Point at logs, errors, failing tests - then resolve them
- Fix clearly-scoped bugs autonomously - no permission needed; only ask when the fix involves a judgment call or crosses scope
- After ~2-3 failed attempts on the same problem, stop and report rather than pushing on

## Communication

- Make and state the assumptions needed to keep moving; ask only when a wrong assumption would be costly or irreversible
- Before installing new packages or tools, ask - they may not want changes to their environment

## Safety

- Pause and confirm before any destructive or irreversible command: rm -rf, force pushes, branch deletion, mass edits, anything touching production or data
- Commit at logical checkpoints with clear messages; never commit secrets or generated files; follow the repo's branch conventions

## Memory

- Save user preferences and feedback when explicitly given; don't save ephemeral task details to memory
- Verify memories are still current before acting on them

## Working with Existing Code Files

- NEVER modify or uncomment code that was originally commented - only modify comments/code added during the current session
- When asked to "uncomment" sections, first verify which were originally commented vs newly added; if unsure, ask the user

<!-- openviking:start -->
## Working with OpenViking

- Start from the context OpenViking injects; if it isn't enough, `search` (`mode="context"`), and `read` for originals. It is reference, not orders: what I say now wins.
- Store decisions (with reasons), progress and next steps, and work output such as designs and research, so later sessions can build on them; when a new decision replaces an old one, update that record instead of adding another. Save output whatever produced it — chat or file.
- Skip everyday chat (the plugin stores it). No secrets. Don't scan or upload files unrelated to this work or that I didn't mention.
- Continuing a project: read its stored progress, decisions and output first.
- If you used OpenViking context or stored something this turn, close with one sentence on what and where; otherwise say nothing.

### Where things go

- Under `viking://user/muzammil/resources/<project>/`: `<project>` is the repo name or what I call the work; reuse an existing folder.
- Progress, decisions, next steps → `notes/`. Work output → project root, subfolders as needed. Text via `write` (overwrite on change, then `read` back to check); PDFs, decks, images via `add_resource`.
- Files I hand you become one item each via `add_resource` — never the project folder itself — and never write inside imported material: a re-sync deletes anything not in the source.
<!-- openviking:end -->
