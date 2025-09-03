# PowerShell script to start PocketBase

# Determine directories
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$buildDir = Join-Path $scriptDir '..\build'
try {
    $buildDir = (Resolve-Path -Path $buildDir -ErrorAction Stop).Path
}
catch {
    Write-Error "Build folder not found at path: $buildDir"
    exit 1
}

$isWindowsHost = $env:OS -eq 'Windows_NT'

if ($isWindowsHost) {
    $exePath = Join-Path $buildDir 'pocketbase.exe'
    if (-not (Test-Path $exePath)) {
        Write-Error "Windows binary not found: $exePath"
        exit 2
    }
    
    Write-Host "Starting PocketBase (Windows) from: $exePath"
    # Run in the current console so logs stream to the user
    & $exePath serve
    
}
else {
    $binPath = Join-Path $buildDir 'pocketbase'

    if (-not (Test-Path $binPath)) {
        Write-Error "Linux binary not found: $binPath"
        exit 2
    }

    Write-Host "Starting PocketBase (Linux) from: $binPath"
    & $binPath serve
}
