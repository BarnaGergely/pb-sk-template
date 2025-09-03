# Downloads the specified PocketBase .zip release from GitHub and extracts it to the OutputDir.
# If the OverwriteExisting is turned off and the OutputDir already contains pocketbase file, show an error

param(
    [ValidateSet('windows', 'linux')]
    [string]$Platform = "windows",
    [string]$Version = "latest",
    [string]$OutputDir = "build",
    [switch]$OverwriteExisting = $false
)

function Write-ErrorAndExit {
    param($Message, $Code = 1)
    if ($Host -and $Host.UI -and $Host.UI.RawUI) {
        Write-Host $Message -ForegroundColor Red
    }
    else {
        Write-Output $Message
    }
    exit $Code
}

# Ensure output directory exists
if (-not (Test-Path -Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Check for existing pocketbase executable(s)
$exePath = Join-Path $OutputDir 'pocketbase'
$binPath = Join-Path $OutputDir 'pocketbase'
if ((Test-Path $exePath -PathType Leaf) -or (Test-Path $binPath -PathType Leaf)) {
    if (-not $OverwriteExisting) {
        Write-ErrorAndExit "The OutputDir '$OutputDir' already contains a pocketbase executable. Use -OverwriteExisting to update the current installation"
    }
    else {
        # remove any existing pocketbase files
        Get-ChildItem -Path $OutputDir -Filter 'pocketbase*' -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

# Query GitHub API for release
$apiUrl = "https://api.github.com/repos/pocketbase/pocketbase/releases/$Version"
try {
    $release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing -ErrorAction Stop
}
catch {
    Write-ErrorAndExit "Failed to query GitHub releases: $_"
}

# Prefer a platform-specific zip asset
$zipAssets = @($release.assets | Where-Object { $_.name -match '\.zip$' })
if ($zipAssets.Count -eq 0) {
    Write-ErrorAndExit "No .zip assets found in {$Version} PocketBase release."
}

$archToken = if ($Platform -eq 'windows') { 'windows_amd64' } else { 'linux_amd64' }

# look for exact arch token in asset name (case-insensitive)
$asset = $zipAssets | Where-Object { $_.name -match [regex]::Escape($archToken) } | Select-Object -First 1
if (-not $asset) {
    Write-ErrorAndExit "Couldn't find a PocketBase .zip for platform '$Platform' (looking for '$archToken') in the {$Version} release."
}

if (-not $asset -or -not $asset.browser_download_url) {
    Write-ErrorAndExit "Couldn't determine a download URL for the PocketBase zip asset."
}

$zipPath = Join-Path $OutputDir $asset.name

try {
    Write-Output "Downloading $($asset.name) from $($asset.browser_download_url) to '$zipPath'..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
}
catch {
    Write-ErrorAndExit "Failed to download asset: $_"
}

# Extract
try {
    Write-Output "Extracting '$zipPath' to '$OutputDir'..."
    Expand-Archive -Path $zipPath -DestinationPath $OutputDir -Force
}
catch {
    Write-ErrorAndExit "Failed to extract zip: $_"
}

# Cleanup zip
try {
    Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
}
catch { }

Write-Output "PocketBase downloaded and extracted to '$OutputDir'."
exit 0
