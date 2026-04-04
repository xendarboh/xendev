---
name: xndv-sync-aztec-ai-tools
description: Sync bin/x-aztec-ai-tools with the latest Aztec AI tooling recommendations from docs.aztec.network, updating the injected AGENTS.md text and checking for tool additions or removals.
---

## What this skill does

Keeps `bin/x-aztec-ai-tools` aligned with the official Aztec AI tooling guide at
https://docs.aztec.network/developers/ai_tooling.

Two distinct concerns:

1. **AGENTS.md injected text** — the two heredocs in `inject_aztec_section()` that
   get appended to project AGENTS.md/CLAUDE.md files.
2. **Tooling coverage** — the set of tools/plugins/MCP servers the script installs,
   compared to the "Aztec and Noir tool reference" table in the docs.

---

## Step 1 — Fetch the current docs

Fetch the live page:

```
https://docs.aztec.network/developers/ai_tooling
```

Extract:
- The **"Recommended CLAUDE.md / AGENTS.md"** code block (under
  `### Recommended CLAUDE.md / AGENTS.md`).
- The **"Aztec and Noir tool reference"** table, listing every tool with its
  repo, compatible clients, and description.

---

## Step 2 — Read the current script

Read `bin/x-aztec-ai-tools` in full. Identify:

- The `AZTEC_UPSTREAM` heredoc — verbatim copy of the docs recommended template.
- The `XNDV_CUSTOM` heredoc — xndv-specific additions that survive upstream syncs.
- Every external tool/package installed or configured:
  - Variables: `AZTEC_CLAUDE_PLUGIN_PKG`, `NOIR_CLAUDE_PLUGIN_PKG`,
    `NETHERMIND_SKILLS_REPO`, `AZTEC_MCP_NPM_PKG`, `NOIR_MCP_NPM_PKG`
  - `opkg install`, `git clone`, and MCP config calls in the body.

---

## Step 3 — Reconcile the AZTEC_UPSTREAM heredoc

The `AZTEC_UPSTREAM` heredoc must be a **verbatim copy** of the docs recommended
template. No interpretation, no merging — replace it exactly.

Compare the current `AZTEC_UPSTREAM` content against the fetched docs template.
Present a summary before editing:

```
AZTEC_UPSTREAM changes:
  UPDATED  ## Critical: Use `aztec` CLI, not `nargo` directly   (content changed)
  ADDED    ## New Section Name                                    (new in docs)
  REMOVED  ## Old Section Name                                    (removed from docs)
  OK       ## Error Handling
  OK       ## Version Compatibility
  OK       ## Hashing: Default to Poseidon2
```

If there are no changes, say so and skip the edit.

Once confirmed (or operating autonomously), replace the `AZTEC_UPSTREAM` heredoc
content to match the docs exactly. Do not touch the `XNDV_CUSTOM` heredoc.

---

## Step 4 — Reconcile the tooling coverage

Build two lists:

**Docs tool list** — every row in the "Aztec and Noir tool reference" table.
Record: tool name, repo URL, compatible clients, description.

**Script tool list** — every external package/repo currently installed (Step 2).

Compare:

- **OK** — tool present in both
- **MISSING** — in docs but not in script
- **EXTRA** — in script but not in docs (may be renamed)

Present a table:

```
Tooling coverage vs docs:
  OK       @aztec/mcp-server          (Any MCP client)
  OK       noir-mcp-server            (Any MCP client)
  OK       aztec-claude-plugin        (Claude Code)
  OK       noir-claude-plugin         (Claude Code)
  OK       NethermindEth/aztec-skills (Claude Code, Codex)
  MISSING  noir-lang/noir skills      (Claude Code, Codex) — https://github.com/noir-lang/noir/tree/master/.claude/skills
  EXTRA    some-old-package           — no longer in docs reference table
```

For each **MISSING** tool: describe what it does, what clients it supports, and the
suggested pattern to add it (opkg plugin, clone-and-copy like Nethermind skills, or
new MCP entry with `build_*_mcp_entry` helper).

For each **EXTRA** tool: note whether it may be a rename of something in MISSING,
or whether the variable and install step should be removed.

**Do not automatically edit the script for tooling changes.** Present findings and
ask the operator which items to act on before making any changes.

---

## Step 5 — Apply approved changes

**AGENTS.md text (Step 3):** apply directly unless the operator objects.

**Tooling changes (Step 4):** apply only items the operator explicitly approves.
Follow existing script patterns:

- New opkg plugins: add a `*_PKG` variable near the top and an `opkg install` call
  in the numbered steps section.
- New skills repos: follow the `NethermindEth/aztec-skills` clone-and-copy pattern.
- New MCP servers: add a `build_*_mcp_entry` helper, a `*_MCP_NPM_PKG` variable,
  and entries in both the Claude `.mcp.json` and OpenCode `.opencode/opencode.json`
  sections.
- Removed tools: delete the variable, install step, and any MCP config writes;
  confirm it does not appear under a different name first.

---

## Step 6 — Verify

After edits, re-read the modified sections and confirm:

1. `AZTEC_UPSTREAM` matches the docs template verbatim.
2. `XNDV_CUSTOM` is unchanged.
3. The `AZTEC_SECTION_MARKER` and both heredoc delimiters (`AZTEC_UPSTREAM`,
   `XNDV_CUSTOM`) are intact.
4. All approved tooling changes are reflected in variables and steps.
5. File is still executable: `ls -la bin/x-aztec-ai-tools`.
