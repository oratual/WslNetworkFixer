# WSL Network Fixer - Core Module
# Copyright (c) 2025 Lautaro Dominguez (Oratual)
# Licensed under MIT License

<#
.SYNOPSIS
    Configures WSL2 networking to use mirrored mode
.DESCRIPTION
    This script configures WSL2 to use networkingMode=mirrored which solves
    connectivity issues between WSL2 and Windows host
.PARAMETER Force
    Force update even if configuration exists
.PARAMETER Backup
    Create backup of existing configuration
.EXAMPLE
    Set-WslNetworking -Force -Backup
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Backup = $true
)

$ErrorActionPreference = "Stop"
$wslConfigPath = "$env:USERPROFILE\.wslconfig"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [string]$Prefix = ""
    )
    
    if ($Prefix) {
        Write-Host "[$Prefix] " -ForegroundColor $Color -NoNewline
        Write-Host $Message -ForegroundColor White
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

function Test-WslInstallation {
    try {
        $wslVersion = wsl --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "WSL not installed"
        }
        return $true
    } catch {
        Write-ColorOutput "WSL is not installed or not accessible" "Red" "ERROR"
        return $false
    }
}

function Get-CurrentConfig {
    if (Test-Path $wslConfigPath) {
        return Get-Content $wslConfigPath -Raw
    }
    return $null
}

function Test-NetworkingMode {
    param([string]$Content)
    
    if ($Content -match "networkingMode\s*=\s*mirrored") {
        return $true
    }
    return $false
}

function Set-NetworkingMode {
    param(
        [string]$Content,
        [switch]$CreateNew
    )
    
    if ($CreateNew -or [string]::IsNullOrWhiteSpace($Content)) {
        $config = @"
[wsl2]
# Memory allocation (adjust as needed)
memory=4GB

# CPU cores allocation
processors=2

# Network mode - mirrored shares Windows IP
networkingMode=mirrored

# Memory reclaim - gradual is more stable
autoMemoryReclaim=gradual

# Sparse VHD - saves disk space
sparseVhd=true

# Optional: GUI applications support
# guiApplications=true

# Optional: Debug console
# debugConsole=true
"@
        return $config
    }
    
    # Add networkingMode to existing config
    if ($Content -notmatch "\[wsl2\]") {
        $Content = "[wsl2]`n$Content"
    }
    
    # Insert networkingMode after [wsl2]
    $Content = $Content -replace "(\[wsl2\])", "`$1`nnetworkingMode=mirrored"
    
    return $Content
}

function Backup-Config {
    param([string]$Path)
    
    if (Test-Path $Path) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupPath = "$Path.backup_$timestamp"
        Copy-Item $Path $backupPath -Force
        Write-ColorOutput "Backup created: $backupPath" "Green" "OK"
    }
}

# Main execution
Write-ColorOutput "WSL Network Fixer v1.0" "Cyan"
Write-ColorOutput "======================" "Cyan"
Write-Host ""

# Check WSL installation
if (-not (Test-WslInstallation)) {
    exit 1
}

# Get current configuration
$currentConfig = Get-CurrentConfig
$configExists = -not [string]::IsNullOrWhiteSpace($currentConfig)

# Check if already configured
if ($configExists -and (Test-NetworkingMode $currentConfig) -and -not $Force) {
    Write-ColorOutput "networkingMode=mirrored is already configured" "Green" "OK"
    Write-ColorOutput "Use -Force to update configuration anyway" "Yellow" "INFO"
    exit 0
}

# Backup if requested and file exists
if ($Backup -and $configExists) {
    Backup-Config $wslConfigPath
}

# Set new configuration
try {
    if ($configExists -and -not (Test-NetworkingMode $currentConfig)) {
        Write-ColorOutput "Adding networkingMode=mirrored to existing config" "Yellow" "INFO"
        $newConfig = Set-NetworkingMode -Content $currentConfig
    } else {
        Write-ColorOutput "Creating new optimal configuration" "Yellow" "INFO"
        $newConfig = Set-NetworkingMode -CreateNew
    }
    
    # Write configuration
    Set-Content -Path $wslConfigPath -Value $newConfig -Encoding UTF8
    Write-ColorOutput "Configuration updated successfully" "Green" "OK"
    
    # Display next steps
    Write-Host ""
    Write-ColorOutput "Next steps:" "Yellow"
    Write-Host "1. Run: " -NoNewline
    Write-Host "wsl --shutdown" -ForegroundColor Cyan
    Write-Host "2. Wait 10 seconds"
    Write-Host "3. Start WSL again"
    Write-Host "4. Your services will be accessible via " -NoNewline
    Write-Host "localhost" -ForegroundColor Cyan
    
} catch {
    Write-ColorOutput "Failed to update configuration: $_" "Red" "ERROR"
    exit 1
}