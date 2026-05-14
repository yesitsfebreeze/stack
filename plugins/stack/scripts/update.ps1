# Stack update - Windows PowerShell.
# Idempotent. Safe to re-run.

$ErrorActionPreference = "Continue"

$Marketplace = "stack"
$Plugins = @("stack", "git-fs", "vicky", "context7", "caveman", "context-mode")

Write-Host "==> Stack update"

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "'claude' CLI not on PATH. Install Claude Code first."
  exit 1
}

Write-Host "==> Refresh marketplace $Marketplace"
try { claude plugin marketplace update $Marketplace } catch { Write-Host "  (marketplace refresh failed, continuing)" }

foreach ($p in $Plugins) {
  Write-Host "==> Update $p@stack"
  try { claude plugin update "$p@stack" } catch { Write-Host "  (update failed or not installed, continuing)" }
}

Write-Host ""
Write-Host "==> Done. Restart Claude Code to apply. Then /stack:doctor to verify."
