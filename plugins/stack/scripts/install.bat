@echo off
REM Stack bootstrap — cmd.exe wrapper. Delegates to PowerShell.
powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
