# CRITICAL TOOL SCHEMA RULES

- NEVER omit the `description` field in `bash` calls.
- ALWAYS use the key `filePath` (not `path`) for read, write, and edit tools.
- If a tool call fails with "received undefined", it means you missed a required key in the schema. Check your parameters and retry.
