---
description: Generate git conventional commit message alternatives from provided context
agent: build
subtask: true
---

Generate conventional commit message alternatives from staged git context.

Primary source is attached files when present.
Fallback is running git commands directly when files are not attached.

Use this contract:

1. Build context in this priority order:
   - If files are attached, use them as context (status, staged diff, recent log).
   - If files are not attached, run these commands and use their output:
     - `git status --short`
     - `git diff --staged`
     - `git log --oneline -20 --name-only`
   - If no staged changes exist, output exactly: `1. chore: no staged changes`
2. Generate `$ARGUMENTS` count if a `count=<n>` hint is present, otherwise generate 3.
3. Apply `hint=<...>` from `$ARGUMENTS` when it is valid and helpful.
4. Output only a numbered list, one subject line per item:

   ```
   1. type(scope): subject
   2. type(scope): subject
   3. type(scope): subject
   ```

5. Rules:
   - Conventional Commits type from: feat, fix, docs, style, refactor, perf, test, chore, ci, build
   - Subject is imperative
   - Subject <= 72 characters
   - No trailing period
   - Prefer one-line subject only (no body/footer)
   - No explanations, no markdown, no extra text
