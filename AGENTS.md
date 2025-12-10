# Repository Guidelines

## Project Structure & Module Organization
- `MoveMouse.ps1`: PowerShell script that nudges the cursor after idle detection using `user32.dll`.
- `move_mouse.py`: Python equivalent using `ctypes` with the same idle-aware jiggle logic.
- `start_move_mouse.bat` / `start_move_mouse_python.bat`: convenience launchers for the PowerShell or Python variants. Adjust timings inside the scripts before running.

## Build, Test, and Development Commands
- Run PowerShell version: `.\MoveMouse.ps1` (PowerShell). Key knobs at top: `$idleSeconds`, `$checkIntervalSeconds`, `$offsetPixels`, `$pulseSeconds`. Defaults: 30s idle, 2s check, 12px random offset.
- Run Python version: `python move_mouse.py`. Optional overrides, e.g., `jiggle(idle_seconds=45, offset_pixels=6)`. Defaults: 30s idle, 2s check, 12px random offset.
- Requirements: Windows plus a local Python interpreter for the `.py` script; no extra packages needed.

## Coding Style & Naming Conventions
- Python: follow PEP 8 with 4-space indents; `snake_case` for functions/locals; keep timing defaults grouped in the function signature; use `print` for status and idle notices.
- PowerShell: use descriptive PascalCase variable names for new logic; keep configuration variables at the top; use `Write-Host` for status and idle notices.
- Keep motion minimal but detectable (default 12 px, random direction); note any timing/offset changes in a nearby comment if you adjust them.

## Testing Guidelines
- Manual checks only:
  - Let the script sit idle >30s; confirm you see the idle notice and a small nudge that returns to the starting point.
  - Nudge the mouse yourself; verify the idle timer resets and no jiggle triggers.
  - Check CPU stays near idle; interrupt with `Ctrl+C` and confirm the stop message appears.
- If adding options (e.g., CLI args), add a brief usage example in the script header and verify both default and custom values.

## Commit & Pull Request Guidelines
- Use short, imperative commit messages (e.g., "Add Python jiggle params", "Tweak PowerShell timing defaults").
- In pull requests, describe:
  - What changed and why (timing, offsets, new flags).
  - Manual validation performed (commands run, duration observed).
  - Any risks (e.g., larger offsets causing visible movement).
- Link related issue/ticket when available and keep PRs small and focused on a single behavior change.
