function Ensure-GitInstalled {
    try {
        git --version | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Get-CurrentBranch {
    param([string]$RootPath)
    Push-Location $RootPath
    try {
        $branch = git rev-parse --abbrev-ref HEAD
        return $branch.Trim()
    } finally {
        Pop-Location
    }
}

function Create-GitTag {
    param(
        [string]$RootPath,
        [string]$TagName,
        [string]$Message
    )
    Push-Location $RootPath
    try {
        git tag -a $TagName -m $Message
    } finally {
        Pop-Location
    }
}

function Git-StatusClean {
    param([string]$RootPath)
    Push-Location $RootPath
    try {
        $status = git status --porcelain
        return [string]::IsNullOrWhiteSpace($status)
    } finally {
        Pop-Location
    }
}
