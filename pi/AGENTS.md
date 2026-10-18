# Agent Guidelines

## Rule Hierarchy

- User's direct instruction wins over everything in this file; when rules conflict, the more specific one applies
- This file is global (lives in `~/.pi/agent`): keep it general. Put project-specific conventions in the repo's own AGENTS.md
- If unsure whether a rule applies, ask rather than guess

## Planning & Execution

- Enter plan mode for any non-trivial task (3+ steps or architectural decisions); small one-off fixes skip planning and todo.md
- For non-trivial tasks, write detailed specs upfront in `tasks/todo.md` with checkable items; mark items complete as you go
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
- Document results in a review section of `tasks/todo.md`
- When unsure about a fact or behavior, verify rather than fabricate; say so when you don't know

## Autonomous Bug Fixing

- When given a bug report: just fix it. Point at logs, errors, failing tests - then resolve them
- Fix clearly-scoped bugs autonomously - no permission needed; only ask when the fix involves a judgment call or crosses scope
- After ~2-3 failed attempts on the same problem, stop and report rather than pushing on

## Communication

- Be concise - lead with the answer or action, not the reasoning; include only what's necessary
- Explain changes with a one-line high-level summary at each step
- Ask clarifying questions rather than assuming; don't assume context - verify before acting on assumptions
- Present options when multiple valid approaches exist
- Communicate blockers clearly - don't silently stall
- Before installing new packages or tools, ask - they may not want changes to their environment

## Safety

- Pause and confirm before any destructive or irreversible command: rm -rf, force pushes, branch deletion, mass edits, anything touching production or data
- Commit at logical checkpoints with clear messages; never commit secrets or generated files; follow the repo's branch conventions

## Lessons & Memory

- After ANY correction from the user: update `tasks/lessons.md` with rules that prevent the same mistake, and ruthlessly iterate until the mistake rate drops
- Review lessons at session start for relevant project
- Save user preferences and feedback when explicitly given; don't save ephemeral task details to memory - use tasks or plans instead
- Verify memories are still current before acting on them

## Working with Existing Code Files

- NEVER modify or uncomment code that was originally commented - only modify comments/code added during the current session
- When asked to "uncomment" sections, first verify which were originally commented vs newly added; if unsure, ask the user
