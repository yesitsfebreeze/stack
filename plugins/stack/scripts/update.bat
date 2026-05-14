@echo off
REM Stack update - cmd.exe wrapper. Prefers pwsh (PS7, UTF-8 default), falls back to powershell.
where pwsh >nul 2>&1
if %ERRORLEVEL%==0 (
  pwsh -ExecutionPolicy Bypass -File "%~dp0update.ps1" %*
) else (
  powershell -ExecutionPolicy Bypass -File "%~dp0update.ps1" %*
)
