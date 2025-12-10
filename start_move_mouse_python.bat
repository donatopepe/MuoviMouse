@echo off
setlocal

REM Avvia lo script Python per muovere il mouse in modo minimale.
cd /d "%~dp0"
start "" /min python "%~dp0move_mouse.py"

endlocal
