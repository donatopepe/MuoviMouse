$checkIntervalSeconds = 2
$idleSeconds = 30
$offsetPixels = 12
$pulseSeconds = 0.5

Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public struct POINT { public int X; public int Y; }
    public static class Mouse {
        [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT lpPoint);
        [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
    }
"@

Write-Host "Mouse keep-alive armed: jiggles after ${idleSeconds}s idle, offset ${offsetPixels}px. Ctrl+C to stop."

$lastPoint = New-Object Win32.NativeMethods+POINT
[Win32.NativeMethods+Mouse]::GetCursorPos([ref]$lastPoint) | Out-Null
$lastMove = Get-Date

try {
    while ($true) {
        $currentPoint = New-Object Win32.NativeMethods+POINT
        [Win32.NativeMethods+Mouse]::GetCursorPos([ref]$currentPoint) | Out-Null

        if ($currentPoint.X -ne $lastPoint.X -or $currentPoint.Y -ne $lastPoint.Y) {
            $lastMove = Get-Date
            $lastPoint = $currentPoint
        }

        $idleDuration = (Get-Date) - $lastMove
        if ($idleDuration.TotalSeconds -ge $idleSeconds) {
            do {
                $dx = Get-Random -Minimum -$offsetPixels -Maximum ($offsetPixels + 1)
                $dy = Get-Random -Minimum -$offsetPixels -Maximum ($offsetPixels + 1)
            } until ($dx -ne 0 -or $dy -ne 0)

            Write-Host ("Idle for {0:N0}s - jiggle {1}px, direction ({2},{3})." -f $idleDuration.TotalSeconds, $offsetPixels, $dx, $dy)
            [Win32.NativeMethods+Mouse]::SetCursorPos($currentPoint.X + $dx, $currentPoint.Y + $dy)
            Start-Sleep -Seconds $pulseSeconds
            [Win32.NativeMethods+Mouse]::SetCursorPos($currentPoint.X, $currentPoint.Y)
            $lastMove = Get-Date
            $lastPoint = $currentPoint
        }

        Start-Sleep -Seconds $checkIntervalSeconds
    }
} catch {
    Write-Host "Mouse keep-alive stopped."
}
