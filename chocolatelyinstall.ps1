$ErrorActionPreference = 'Stop'

$packageName = 'xenofetch'
$repoOwner = 'cptcr'
$repoName = 'xenofetch'

# Get latest version from GitHub API
function Get-LatestVersion {
    try {
        $apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
        $version = $response.tag_name -replace '^v', ''
        Write-Host "Latest version detected: $version" -ForegroundColor Green
        return $version
    }
    catch {
        Write-Warning "Could not fetch latest version, using fallback: 1.0.0"
        return "1.0.0"
    }
}

$version = Get-LatestVersion
$url = "https://github.com/$repoOwner/$repoName/archive/v$version.zip"
$checksum = 'SKIP'  # Will be updated by automated build process
$checksumType = 'sha256'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path $toolsDir 'xenofetch'

Write-Host "Installing Xenofetch v$version..." -ForegroundColor Cyan

# Download and extract
Install-ChocolateyZipPackage `
  -PackageName $packageName `
  -Url $url `
  -UnzipLocation $toolsDir `
  -Checksum $checksum `
  -ChecksumType $checksumType

# Find the extracted directory
$extractedDir = Get-ChildItem $toolsDir -Directory | Where-Object { $_.Name -like "*xenofetch*" } | Select-Object -First 1

if ($extractedDir) {
  # Copy necessary files to a more accessible location
  $scriptPath = Join-Path $extractedDir.FullName "xenofetch.sh"
  $mainPath = Join-Path $extractedDir.FullName "main.sh"
  $targetScriptPath = Join-Path $toolsDir "xenofetch.sh"
  $targetMainPath = Join-Path $toolsDir "main.sh"
  
  if (Test-Path $scriptPath) {
    Copy-Item $scriptPath $targetScriptPath -Force
    
    # Copy main.sh if it exists
    if (Test-Path $mainPath) {
      Copy-Item $mainPath $targetMainPath -Force
    }
    
    # Create a PowerShell wrapper for Windows
    $psWrapper = @"
#!/usr/bin/env pwsh
# Xenofetch PowerShell Wrapper for Windows

param(
    [Parameter(Position = 0, ValueFromRemainingArguments = `$true)]
    [string[]]`$Arguments
)

# Check if running in Windows Terminal, PowerShell, or CMD
if (`$env:WT_SESSION -or `$env:TERM_PROGRAM -eq "vscode" -or `$Host.Name -eq "ConsoleHost") {
    # Check for WSL
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        # Run in WSL
        & wsl bash "$targetScriptPath" @Arguments
    }
    # Check for Git Bash
    elseif (Test-Path "C:\Program Files\Git\bin\bash.exe") {
        & "C:\Program Files\Git\bin\bash.exe" "$targetScriptPath" @Arguments
    }
    # Check for MSYS2
    elseif (Test-Path "C:\msys64\usr\bin\bash.exe") {
        & "C:\msys64\usr\bin\bash.exe" "$targetScriptPath" @Arguments
    }
    else {
        Write-Host "Error: No bash environment found!" -ForegroundColor Red
        Write-Host "Please install one of the following:" -ForegroundColor Yellow
        Write-Host "  - Windows Subsystem for Linux (WSL)" -ForegroundColor Yellow
        Write-Host "  - Git for Windows (includes Git Bash)" -ForegroundColor Yellow
        Write-Host "  - MSYS2" -ForegroundColor Yellow
        exit 1
    }
}
else {
    Write-Host "Please run xenofetch from Windows Terminal, PowerShell, or Command Prompt" -ForegroundColor Red
    exit 1
}
"@
    
    $psPath = Join-Path $toolsDir "xenofetch.ps1"
    $psWrapper | Out-File -FilePath $psPath -Encoding UTF8
    
    # Create a batch wrapper for Windows CMD
    $batchWrapper = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0xenofetch.ps1" %*
"@
    $batchPath = Join-Path $toolsDir "xenofetch.bat"
    $batchWrapper | Out-File -FilePath $batchPath -Encoding ASCII
    
    # Create a simple exe shim
    Install-BinFile -Name 'xenofetch' -Path $batchPath
    
    Write-Host "Xenofetch installed successfully!" -ForegroundColor Green
    Write-Host "You can now run 'xenofetch' from any command prompt" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor White
    Write-Host "Note: Xenofetch requires a bash environment on Windows:" -ForegroundColor Cyan
    Write-Host "  - WSL (Windows Subsystem for Linux) - Recommended" -ForegroundColor White
    Write-Host "  - Git Bash (comes with Git for Windows)" -ForegroundColor White
    Write-Host "  - MSYS2" -ForegroundColor White
  } else {
    throw "Could not find xenofetch.sh in the downloaded package"
  }
} else {
  throw "Could not find extracted xenofetch directory"
}