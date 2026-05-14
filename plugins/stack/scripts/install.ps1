# Stack bootstrap - Windows PowerShell.
# Idempotent. Safe to re-run.

$ErrorActionPreference = "Stop"

$Marketplace = "yesitsfebreeze/stack"
$Plugins = @("stack", "git-fs", "vicky", "context7", "caveman", "context-mode")

Write-Host "==> Stack bootstrap"

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "'claude' CLI not on PATH. Install Claude Code first."
  exit 1
}

Write-Host "==> Add marketplace $Marketplace"
try { claude plugin marketplace add $Marketplace } catch { Write-Host "  (already added)" }

foreach ($p in $Plugins) {
  Write-Host "==> Install $p@stack"
  try { claude plugin install "$p@stack" } catch { Write-Host "  (already installed or failed, continuing)" }
}

Write-Host "==> Create .stack marker in $(Get-Location)"
if (-not (Test-Path .stack)) {
  New-Item -ItemType File -Path .stack | Out-Null
  Write-Host "  .stack created"
} else {
  Write-Host "  .stack already present"
}

if (-not $env:CONTEXT7_API_KEY) {
  Write-Host ""
  Write-Host "WARN: CONTEXT7_API_KEY not set. context7 MCP will fail auth."
  Write-Host "      Get key from https://context7.com, then:"
  Write-Host "        `$env:CONTEXT7_API_KEY = 'ctx7sk-...'"
}

Write-Host ""
Write-Host "==> Done. Run /stack-doctor to verify."
