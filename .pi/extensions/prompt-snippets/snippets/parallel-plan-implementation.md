---
name: Parallel plan implementation
description: Once the plan is ready, implement it with parallel subagents
placement: append
order: 31
---

Once the plan is written and you start implementing it, split the work into independent units and run every unit without a real dependency in parallel, each in its own subagent. Serialize only what must share files or consume another unit's output - never do sequentially what can be done concurrently. Keep the main agent free to integrate and verify.
