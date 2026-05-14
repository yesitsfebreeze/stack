#!/usr/bin/env node
// Inject stack routing summary at session start.
// Detects opt-in via `.stack` marker file or env STACK_ROUTING=1.
// Without opt-in: prints nothing (zero context cost).

import fs from "node:fs";
import path from "node:path";

const cwd = process.cwd();
const optIn =
  process.env.STACK_ROUTING === "1" ||
  fs.existsSync(path.join(cwd, ".stack")) ||
  fs.existsSync(path.join(cwd, ".stack.toml"));

if (!optIn) process.exit(0);

const summary = `# Stack routing active

Project opted in via \`.stack\` marker. Apply silently:

- Library/SDK question → Context7 (\`resolve-library-id\` → \`query-docs\`)
- "Latest" / external research → vicky \`query\`; web-search on gap; \`remember\`
- Project code search → Grep / Glob (no kern in this stack)
- Multi-agent / throwaway → git-fs branch (\`git_fs_branch_create\`)
- Raw tool output > 20 lines → context-mode sandbox

Anti-patterns: Read whole file to analyze; WebFetch library docs; repeat web search across sessions.

Full table: invoke skill \`stack-routing\`.`;

process.stdout.write(JSON.stringify({
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: summary
  }
}));
