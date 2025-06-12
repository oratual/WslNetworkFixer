@echo off
setlocal EnableDelayedExpansion

:: WSL Network Fixer - Diagnostic Tool
:: Copyright (c) 2025 Lautaro Dominguez (Oratual)

echo ========================================
echo    WSL Network Fixer - Diagnostics
echo ========================================
echo.

echo [CHECK] WSL Version...
wsl --version
echo.

echo [CHECK] Current .wslconfig...
if exist "%USERPROFILE%\.wslconfig" (
    echo Found at: %USERPROFILE%\.wslconfig
    echo Content:
    echo ----------------------------------------
    type "%USERPROFILE%\.wslconfig"
    echo ----------------------------------------
) else (
    echo [WARNING] No .wslconfig file found
)
echo.

echo [CHECK] WSL Status...
wsl --status
echo.

echo [CHECK] Network Configuration...
powershell -Command "Get-NetAdapter | Where-Object {$_.Name -like '*WSL*'} | Select-Object Name, Status, LinkSpeed"
echo.

echo [INFO] Diagnostic complete
pause