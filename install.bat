@echo off
setlocal EnableDelayedExpansion

:: WSL Network Fixer - Installer
:: Copyright (c) 2025 Lautaro Dominguez (Oratual)
:: Licensed under MIT License

echo ========================================
echo    WSL Network Fixer - Installer
echo ========================================
echo.

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrator privileges required
    echo.
    echo Please run this script as Administrator
    echo Right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Run PowerShell script
echo [INFO] Configuring WSL networking...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0src\Set-WslNetworking.ps1" -Force

if %errorLevel% equ 0 (
    echo.
    echo ========================================
    echo    Installation Complete!
    echo ========================================
    echo.
    echo Next steps:
    echo 1. Run: wsl --shutdown
    echo 2. Restart your WSL instance
    echo 3. Access services via localhost
    echo.
    echo Example:
    echo - In WSL: npm run dev
    echo - In Windows: http://localhost:3000
    echo.
) else (
    echo.
    echo [ERROR] Installation failed
    echo Please check the error messages above
    echo.
)

pause