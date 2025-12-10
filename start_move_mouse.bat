@echo off
setlocal

REM Avvia lo script PowerShell per muovere il mouse in modo minimale.
cd /d "%~dp0"
start "" /min powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0MoveMouse.ps1"

endlocal
