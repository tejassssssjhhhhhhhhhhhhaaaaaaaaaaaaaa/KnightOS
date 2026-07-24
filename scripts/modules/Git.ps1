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

function Git-AddAll {
    param([string]$RootPath)
    Push-Location $RootPath
    try {
        git add . | Out-Null
        return $true
    } finally {
        Pop-Location
    }
}

function Git-CommitIfNeeded {
    param(
        [string]$RootPath,
        [string]$Message
    )

    Push-Location $RootPath
    try {
        $status = git status --porcelain
        if ([string]::IsNullOrWhiteSpace($status)) {
            return $false
        }

        git commit -m $Message | Out-Null
        return $true
    } catch {
        if ($_.Exception.Message -match 'nothing to commit') {
            return $false
        }
        throw
    } finally {
        Pop-Location
    }
}

function Git-PushCurrentBranch {
    param(
        [string]$RootPath,
        [string]$BranchName
    )

    Push-Location $RootPath
    try {
        git push origin $BranchName | Out-Null
        return $true
    } finally {
        Pop-Location
    }
}

function Test-GitRemoteConfigured {
    param([string]$RootPath)

    Push-Location $RootPath
    try {
        $remoteUrl = git remote get-url origin 2>$null
        return -not [string]::IsNullOrWhiteSpace($remoteUrl)
    } catch {
        return $false
    } finally {
        Pop-Location
    }
}
