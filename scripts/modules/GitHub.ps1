function Ensure-GitHubCliInstalled {
    try {
        gh --version | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Ensure-GitHubAuthenticated {
    try {
        gh auth status --hostname github.com | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Create-GitHubRelease {
    param(
        [string]$Repository,
        [string]$TagName,
        [string]$Title,
        [string]$ReleaseNotes,
        [string]$ApkPath
    )

    $arguments = @('release', 'create', $TagName, '--repo', $Repository, '--title', $Title, '--notes', $ReleaseNotes, $ApkPath)
    $process = Start-Process -FilePath 'gh' -ArgumentList $arguments -NoNewWindow -Wait -PassThru -ErrorAction Stop
    if ($process.ExitCode -ne 0) {
        throw "GitHub release creation failed for $TagName"
    }
}

function Update-GitHubRelease {
    param(
        [string]$Repository,
        [string]$TagName,
        [string]$Title,
        [string]$ReleaseNotes
    )

    $arguments = @('release', 'edit', $TagName, '--repo', $Repository, '--title', $Title, '--notes', $ReleaseNotes)
    $process = Start-Process -FilePath 'gh' -ArgumentList $arguments -NoNewWindow -Wait -PassThru -ErrorAction Stop
    if ($process.ExitCode -ne 0) {
        throw "GitHub release update failed for $TagName"
    }
}

function Upload-GitHubReleaseAsset {
    param(
        [string]$Repository,
        [string]$TagName,
        [string]$ApkPath
    )

    $arguments = @('release', 'upload', $TagName, $ApkPath, '--repo', $Repository, '--clobber')
    $process = Start-Process -FilePath 'gh' -ArgumentList $arguments -NoNewWindow -Wait -PassThru -ErrorAction Stop
    if ($process.ExitCode -ne 0) {
        throw "GitHub asset upload failed for release $TagName"
    }
}

function GitHub-ReleaseExists {
    param(
        [string]$Repository,
        [string]$TagName
    )

    $arguments = @('release', 'view', $TagName, '--repo', $Repository)
    $process = Start-Process -FilePath 'gh' -ArgumentList $arguments -NoNewWindow -Wait -PassThru -ErrorAction SilentlyContinue
    return $process.ExitCode -eq 0
}
