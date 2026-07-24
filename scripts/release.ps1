#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Path $MyInvocation.MyCommand.Definition -Parent }
$modulePath = Join-Path $scriptDir 'modules'
. (Join-Path $modulePath 'Utils.ps1')
. (Join-Path $modulePath 'Version.ps1')
. (Join-Path $modulePath 'Flutter.ps1')
. (Join-Path $modulePath 'Git.ps1')
. (Join-Path $modulePath 'GitHub.ps1')

$root = Get-ProjectRoot

try {
    $config = Get-ReleaseConfig -RootPath $root
    $currentVersion = Get-PubspecVersion -RootPath $root
    Write-Host 'KnightOS Release Manager' -ForegroundColor Cyan
    Write-Host "Current Version: $currentVersion"

    $versionObject = Parse-SemVer -version $currentVersion
    Write-Host 'Select release type:'
    Write-Host '1) Patch'
    Write-Host '2) Minor'
    Write-Host '3) Major'
    $selection = Read-Host 'Enter choice (1-3)'
    switch ($selection) {
        '1' { $releaseType = 'patch' }
        '2' { $releaseType = 'minor' }
        '3' { $releaseType = 'major' }
        default { throw 'Invalid release type selection.' }
    }

    $newVersionObject = Increment-SemVer -ReleaseType $releaseType -VersionObject $versionObject
    $newVersion = Format-SemVer -VersionObject $newVersionObject
    Update-PubspecVersion -RootPath $root -NewVersion $newVersion
    Write-Success "Updated pubspec.yaml to version $newVersion"

    $flutterCommand = $config.flutterCommand
    if (-not (Ensure-FlutterInstalled -FlutterCommand $flutterCommand)) {
        throw 'Flutter CLI is not installed or not available on PATH.'
    }

    Run-FlutterPubGet -RootPath $root -FlutterCommand $flutterCommand
    Write-Success 'flutter pub get'

    if ($config.runAnalyze -and (Prompt-YesNo 'Run flutter analyze?')) {
        $analyzerResult = Run-FlutterAnalyze -RootPath $root -FlutterCommand $flutterCommand -FailOnWarnings $config.analyzeFailOnWarnings
        if ($analyzerResult.Errors -gt 0) {
            throw "flutter analyze reported $($analyzerResult.Errors) error(s)."
        }

        if ($analyzerResult.Warnings -gt 0 -and $config.analyzeFailOnWarnings) {
            throw "flutter analyze reported $($analyzerResult.Warnings) warning(s) and warnings are configured to fail."
        }

        Write-Success 'flutter analyze'
    }

    if ($config.runTests -and (Prompt-YesNo 'Run flutter test?')) {
        Run-FlutterTest -RootPath $root -FlutterCommand $flutterCommand
        Write-Success 'flutter test'
    }

    Run-FlutterBuildRelease -RootPath $root -FlutterCommand $flutterCommand
    Write-Success 'flutter build apk --release'

    $apkPath = Join-Path $root $config.apkPath
    if (-not (Test-Path $apkPath)) {
        throw "APK does not exist at expected location: $apkPath"
    }
    Write-Success "APK verified at $apkPath"

    $tagName = "v$($newVersionObject.Major).$($newVersionObject.Minor).$($newVersionObject.Patch)"
    if ($config.createGitTag -and (Prompt-YesNo "Create git tag $tagName?")) {
        if (-not (Ensure-GitInstalled)) {
            throw 'Git is not installed or not available on PATH.'
        }
        if (-not (Git-StatusClean -RootPath $root)) {
            throw 'Git working tree is not clean. Commit or stash changes before tagging.'
        }
        Create-GitTag -RootPath $root -TagName $tagName -Message "KnightOS $tagName"
        Write-Success "Git tag created: $tagName"
    }

    if (Prompt-YesNo "Ready to publish Release $tagName. Continue?" $false) {
        Write-Host 'Publishing workflow confirmed. Starting automated publish steps...'

        $branchName = Get-CurrentBranch -RootPath $root
        $gitPushEnabled = $config.gitAutomation

        if (-not (Ensure-GitInstalled)) {
            Write-WarningMessage 'Git is not installed or not available on PATH. Skipping git publish steps.'
        } elseif (-not (Test-GitRemoteConfigured -RootPath $root)) {
            Write-WarningMessage 'No git remote is configured for this repository. Skipping git push.'
        } else {
            if ($gitPushEnabled) {
                Git-AddAll -RootPath $root
                $commitCreated = Git-CommitIfNeeded -RootPath $root -Message "chore(release): publish $tagName"
                if ($commitCreated) {
                    Write-Success "Created git commit for $tagName"
                } else {
                    Write-Host 'No new changes to commit. Skipping commit step.'
                }

                try {
                    Git-PushCurrentBranch -RootPath $root -BranchName $branchName | Out-Null
                    Write-Success "Pushed branch $branchName to origin"
                } catch {
                    Write-WarningMessage "Git push failed: $($_.Exception.Message)"
                }
            } else {
                Write-Host 'Git automation disabled in configuration. Skipping git add/commit/push.'
            }
        }

        if ($config.createGitHubRelease -or $config.uploadApk) {
            if (-not (Ensure-GitHubCliInstalled)) {
                Write-WarningMessage 'GitHub CLI is not installed. Install it from https://cli.github.com/ and try again.'
            } elseif (-not (Ensure-GitHubAuthenticated)) {
                Write-WarningMessage 'Not authenticated with GitHub CLI. Run gh auth login and retry.'
            } else {
                $repo = $config.githubRepository
                if ([string]::IsNullOrWhiteSpace($repo)) {
                    Write-WarningMessage 'GitHub repository is not configured in scripts/config/release.json. Skipping GitHub release publish.'
                } else {
                    $releaseExists = GitHub-ReleaseExists -Repository $repo -TagName $tagName
                    if ($releaseExists) {
                        Update-GitHubRelease -Repository $repo -TagName $tagName -Title "KnightOS $tagName" -ReleaseNotes "Release $tagName"
                        Write-Success "GitHub release updated: $tagName"
                    } elseif ($config.createGitHubRelease) {
                        Create-GitHubRelease -Repository $repo -TagName $tagName -Title "KnightOS $tagName" -ReleaseNotes "Release $tagName" -ApkPath $apkPath
                        Write-Success "GitHub release created: $tagName"
                    }

                    if ($config.uploadApk) {
                        Upload-GitHubReleaseAsset -Repository $repo -TagName $tagName -ApkPath $apkPath
                        Write-Success 'APK uploaded to GitHub release.'
                    }
                }
            }
        }

        if ($config.otaMetadataPath) {
            $otaMetadataPath = Join-Path $root $config.otaMetadataPath
            if (Test-Path $otaMetadataPath) {
                try {
                    $otaJson = Get-Content -Path $otaMetadataPath -Raw | ConvertFrom-Json
                    $otaJson.version = $newVersion
                    $otaJson.releaseTag = $tagName
                    $otaJson | ConvertTo-Json | Set-Content -Path $otaMetadataPath
                    Write-Success "Updated OTA metadata at $otaMetadataPath"
                } catch {
                    Write-WarningMessage ("Unable to update OTA metadata at {0}: {1}" -f $otaMetadataPath, $_.Exception.Message)
                }
            } else {
                Write-WarningMessage "OTA metadata path not found: $otaMetadataPath"
            }
        } else {
            Write-Host 'No OTA metadata path configured. Skipping OTA metadata update.'
        }
    } else {
        Write-Host 'Release workflow aborted by user.'
    }

    Write-Host 'Release summary:' -ForegroundColor Cyan
    Write-Host "Current Version: $currentVersion"
    Write-Host "New Version: $newVersion"
    Write-Host 'Release complete.'
} catch {
    Write-ErrorMessage $_.Exception.Message
    exit 1
}