function Get-ProjectRoot {
    $scriptPath = $PSScriptRoot
    while ($scriptPath -and (Test-Path (Join-Path $scriptPath 'pubspec.yaml')) -eq $false) {
        $scriptPath = Split-Path $scriptPath -Parent
    }

    if (-not $scriptPath) {
        throw 'Unable to locate project root. Ensure scripts are run from within the KnightOS repository.'
    }

    return $scriptPath
}

function Write-Success($message) {
    Write-Host "[SUCCESS] $message" -ForegroundColor Green
}

function Write-ErrorMessage($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}

function Write-WarningMessage($message) {
    Write-Host "[WARNING] $message" -ForegroundColor Yellow
}

function Prompt-YesNo($message, $defaultYes=$true) {
    $yesChoices = 'Y','y'
    $noChoices = 'N','n'
    $default = if ($defaultYes) { 'Y' } else { 'N' }
    do {
        $input = Read-Host "$message [Y/N] (default: $default)"
        if ([string]::IsNullOrWhiteSpace($input)) {
            return $defaultYes
        }
    } while ($input -notin $yesChoices + $noChoices)

    return $input -in $yesChoices
}

function Invoke-JsonFile($path) {
    if (-not (Test-Path $path)) {
        throw "JSON configuration file not found: $path"
    }

    $json = Get-Content -Path $path -Raw
    return $json | ConvertFrom-Json
}

function Get-ReleaseConfig {
    param(
        [string]$RootPath
    )

    $configPath = Join-Path $RootPath 'scripts\config\release.json'
    return Invoke-JsonFile $configPath
}
