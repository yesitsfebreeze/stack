#!/usr/bin/env node
// PreToolUse routing nudges. Non-blocking — emits additionalContext.
// Active only when stack opt-in present.

import fs from "node:fs";
import path from "node:path";

const cwd = process.cwd();
const optIn =
  process.env.STACK_ROUTING === "1" ||
  fs.existsSync(path.join(cwd, ".stack")) ||
  fs.existsSync(path.join(cwd, ".stack.toml"));

if (!optIn) process.exit(0);

let raw = "";
process.stdin.on("data", c => (raw += c));
process.stdin.on("end", () => {
  let input;
  try { input = JSON.parse(raw); } catch { process.exit(0); }

  const tool = input.tool_name || input.toolName;
  const params = input.tool_input || input.toolInput || {};
  const advice = inspect(tool, params);

  if (!advice) process.exit(0);

  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: `[stack routing] ${advice}`
    }
  }));
});

const LIB_DOC_HOSTS = [
  "react.dev", "reactjs.org",
  "nextjs.org",
  "vuejs.org",
  "svelte.dev", "kit.svelte.dev",
  "tailwindcss.com",
  "docs.python.org",
  "pkg.go.dev", "go.dev",
  "doc.rust-lang.org", "docs.rs",
  "developer.mozilla.org",
  "typescriptlang.org",
  "prisma.io",
  "expressjs.com",
  "fastapi.tiangolo.com",
  "django.readthedocs.io", "docs.djangoproject.com",
  "spring.io",
  "anthropic.com/docs", "docs.anthropic.com",
  "platform.openai.com/docs"
];

function inspect(tool, p) {
  if (tool === "WebFetch" && p.url) {
    try {
      const host = new URL(p.url).hostname.replace(/^www\./, "");
      if (LIB_DOC_HOSTS.some(h => host === h || host.endsWith("." + h))) {
        return `WebFetch on library docs host '${host}'. Prefer Context7: resolve-library-id → query-docs. Versioned, current.`;
      }
    } catch {}
  }

  if (tool === "WebSearch") {
    return `WebSearch. Try vicky.query first — persistent KB across sessions. Only WebSearch on vicky gap signal.`;
  }

  if (tool === "Read" && p.file_path) {
    try {
      const st = fs.statSync(p.file_path);
      if (st.size > 50_000) {
        return `Read on ${(st.size / 1024).toFixed(0)} KB file '${path.basename(p.file_path)}'. If analyzing (not editing), prefer Grep / Glob — sub-file scope.`;
      }
    } catch {}
  }

  return null;
}
