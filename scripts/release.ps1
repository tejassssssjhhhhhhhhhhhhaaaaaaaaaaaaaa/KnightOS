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

function Set-PublishStatus {
    param(
        [hashtable]$StatusMap,
        [string]$Key,
        [string]$Status,
        [string]$Detail
    )

    $message = if ([string]::IsNullOrWhiteSpace($Detail)) {
        $Status
    } else {
        '{0} - {1}' -f $Status, $Detail
    }

    $StatusMap[$Key] = $message
    Write-Host (' - {0}: {1}' -f $Key, $message) -ForegroundColor Cyan
}

function Record-PublishFailure {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$StepName,
        [string]$Message
    )

    $Failures.Add(('{0}: {1}' -f $StepName, $Message))
    Write-ErrorMessage ('{0} failed: {1}' -f $StepName, $Message)
}

try {
    $config = Get-ReleaseConfig -RootPath $root
    $currentVersion = Get-PubspecVersion -RootPath $root
    Write-Host 'KnightOS Release Manager' -ForegroundColor Cyan
    Write-Host ('Current Version: {0}' -f $currentVersion)

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
    Write-Success ('Updated pubspec.yaml to version {0}' -f $newVersion)

    $flutterCommand = $config.flutterCommand
    if (-not (Ensure-FlutterInstalled -FlutterCommand $flutterCommand)) {
        throw 'Flutter CLI is not installed or not available on PATH.'
    }

    Run-FlutterPubGet -RootPath $root -FlutterCommand $flutterCommand
    Write-Success 'flutter pub get'

    if ($config.runAnalyze -and (Prompt-YesNo 'Run flutter analyze?')) {
        $analyzerResult = Run-FlutterAnalyze -RootPath $root -FlutterCommand $flutterCommand -FailOnWarnings $config.analyzeFailOnWarnings
        if ($analyzerResult.Errors -gt 0) {
            throw ('flutter analyze reported {0} error(s).' -f $analyzerResult.Errors)
        }

        if ($analyzerResult.Warnings -gt 0 -and $config.analyzeFailOnWarnings) {
            throw ('flutter analyze reported {0} warning(s) and warnings are configured to fail.' -f $analyzerResult.Warnings)
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
        throw ('APK does not exist at expected location: {0}' -f $apkPath)
    }
    Write-Success ('APK verified at {0}' -f $apkPath)

    $tagName = ('v{0}.{1}.{2}' -f $newVersionObject.Major, $newVersionObject.Minor, $newVersionObject.Patch)
    if ($config.createGitTag -and (Prompt-YesNo ('Create git tag {0}?' -f $tagName))) {
        if (-not (Ensure-GitInstalled)) {
            throw 'Git is not installed or not available on PATH.'
        }
        if (-not (Git-StatusClean -RootPath $root)) {
            throw 'Git working tree is not clean. Commit or stash changes before tagging.'
        }
        Create-GitTag -RootPath $root -TagName $tagName -Message ('KnightOS {0}' -f $tagName)
        Write-Success ('Git tag created: {0}' -f $tagName)
    }

    Write-Host ''
    Write-Host ('Starting publish pipeline for {0}...' -f $tagName) -ForegroundColor Cyan
    $publishFailures = [System.Collections.Generic.List[string]]::new()
    $publishStatus = @{
        Git = 'Not started'
        GitHubRelease = 'Not started'
        ApkUpload = 'Not started'
        OtaMetadata = 'Not started'
    }
    $branchName = Get-CurrentBranch -RootPath $root
    $gitPushEnabled = $config.gitAutomation

    if ($gitPushEnabled) {
        if (-not (Ensure-GitInstalled)) {
            Record-PublishFailure -Failures $publishFailures -StepName 'Git publish' -Message 'Git CLI is not installed or not available on PATH.'
            Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Failed' -Detail 'Git CLI is not installed or not available on PATH.'
        } elseif (-not (Test-GitRemoteConfigured -RootPath $root)) {
            Record-PublishFailure -Failures $publishFailures -StepName 'Git publish' -Message 'No git remote is configured for this repository.'
            Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Failed' -Detail 'No git remote is configured for this repository.'
        } else {
            try {
                Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'In progress' -Detail 'Staging release changes.'
                Git-AddAll -RootPath $root | Out-Null

                Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'In progress' -Detail 'Creating a commit if release changes exist.'
                $commitCreated = Git-CommitIfNeeded -RootPath $root -Message ('chore(release): publish {0}' -f $tagName)
                if ($commitCreated) {
                    Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Completed' -Detail ('Created commit for {0}.' -f $tagName)
                } else {
                    Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Completed' -Detail 'No new changes were present to commit.'
                }

                if ($commitCreated) {
                    Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'In progress' -Detail ('Pushing branch {0} to origin.' -f $branchName)
                    Git-PushCurrentBranch -RootPath $root -BranchName $branchName | Out-Null
                    Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Completed' -Detail ('Pushed branch {0} to origin.' -f $branchName)
                }
            } catch {
                Record-PublishFailure -Failures $publishFailures -StepName 'Git publish' -Message $_.Exception.Message
                Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Failed' -Detail $_.Exception.Message
            }
        }
    } else {
        Set-PublishStatus -StatusMap $publishStatus -Key 'Git' -Status 'Skipped' -Detail 'Git automation is disabled in configuration.'
    }

    if ($config.createGitHubRelease -or $config.uploadApk) {
        $githubReleaseSucceeded = $false
        if (-not (Ensure-GitHubCliInstalled)) {
            Record-PublishFailure -Failures $publishFailures -StepName 'GitHub release' -Message 'GitHub CLI is not installed. Install it from https://cli.github.com/ and try again.'
            Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Failed' -Detail 'GitHub CLI is not installed.'
        } elseif (-not (Ensure-GitHubAuthenticated)) {
            Record-PublishFailure -Failures $publishFailures -StepName 'GitHub release' -Message 'GitHub CLI is not authenticated. Run gh auth login and retry.'
            Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Failed' -Detail 'GitHub CLI is not authenticated.'
        } else {
            $repo = $config.githubRepository
            if ([string]::IsNullOrWhiteSpace($repo)) {
                Record-PublishFailure -Failures $publishFailures -StepName 'GitHub release' -Message 'GitHub repository is not configured in scripts/config/release.json.'
                Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Failed' -Detail 'GitHub repository is not configured.'
            } else {
                try {
                    $releaseExists = GitHub-ReleaseExists -Repository $repo -TagName $tagName
                    if ($releaseExists) {
                        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'In progress' -Detail ('Updating GitHub release {0}.' -f $tagName)
                        Update-GitHubRelease -Repository $repo -TagName $tagName -Title ('KnightOS {0}' -f $tagName) -ReleaseNotes ('Release {0}' -f $tagName)
                        $githubReleaseSucceeded = $true
                        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Completed' -Detail ('Updated GitHub release {0}.' -f $tagName)
                    } elseif ($config.createGitHubRelease) {
                        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'In progress' -Detail ('Creating GitHub release {0}.' -f $tagName)
                        Create-GitHubRelease -Repository $repo -TagName $tagName -Title ('KnightOS {0}' -f $tagName) -ReleaseNotes ('Release {0}' -f $tagName) -ApkPath $apkPath
                        $githubReleaseSucceeded = $true
                        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Completed' -Detail ('Created GitHub release {0}.' -f $tagName)
                    } else {
                        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Skipped' -Detail 'GitHub release creation is disabled and no existing release was found.'
                    }
                } catch {
                    Record-PublishFailure -Failures $publishFailures -StepName 'GitHub release' -Message $_.Exception.Message
                    Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Failed' -Detail $_.Exception.Message
                }
            }
        }

        if ($config.uploadApk) {
            if ($githubReleaseSucceeded) {
                try {
                    Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'In progress' -Detail ('Uploading {0} to GitHub release {1}.' -f $apkPath, $tagName)
                    Upload-GitHubReleaseAsset -Repository $config.githubRepository -TagName $tagName -ApkPath $apkPath
                    Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'Completed' -Detail ('Uploaded APK to GitHub release {0}.' -f $tagName)
                } catch {
                    Record-PublishFailure -Failures $publishFailures -StepName 'APK upload' -Message $_.Exception.Message
                    Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'Failed' -Detail $_.Exception.Message
                }
            } else {
                Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'Skipped' -Detail 'GitHub release step did not complete successfully.'
            }
        } else {
            Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'Skipped' -Detail 'APK upload is disabled in configuration.'
        }
    } else {
        Set-PublishStatus -StatusMap $publishStatus -Key 'GitHubRelease' -Status 'Skipped' -Detail 'GitHub release creation is disabled in configuration.'
        Set-PublishStatus -StatusMap $publishStatus -Key 'ApkUpload' -Status 'Skipped' -Detail 'GitHub release creation and APK upload are disabled in configuration.'
    }

    if ($config.otaMetadataPath) {
        $otaMetadataPath = Join-Path $root $config.otaMetadataPath
        if (Test-Path $otaMetadataPath) {
            try {
                Set-PublishStatus -StatusMap $publishStatus -Key 'OtaMetadata' -Status 'In progress' -Detail ('Updating OTA metadata at {0}.' -f $otaMetadataPath)
                $otaJson = Get-Content -Path $otaMetadataPath -Raw | ConvertFrom-Json
                $otaJson.version = $newVersion
                $otaJson.releaseTag = $tagName
                $otaJson | ConvertTo-Json | Set-Content -Path $otaMetadataPath
                Set-PublishStatus -StatusMap $publishStatus -Key 'OtaMetadata' -Status 'Completed' -Detail ('Updated OTA metadata at {0}.' -f $otaMetadataPath)
            } catch {
                Record-PublishFailure -Failures $publishFailures -StepName 'OTA metadata' -Message $_.Exception.Message
                Set-PublishStatus -StatusMap $publishStatus -Key 'OtaMetadata' -Status 'Failed' -Detail $_.Exception.Message
            }
        } else {
            Record-PublishFailure -Failures $publishFailures -StepName 'OTA metadata' -Message ('OTA metadata path not found: {0}' -f $otaMetadataPath)
            Set-PublishStatus -StatusMap $publishStatus -Key 'OtaMetadata' -Status 'Failed' -Detail ('OTA metadata path not found: {0}' -f $otaMetadataPath)
        }
    } else {
        Set-PublishStatus -StatusMap $publishStatus -Key 'OtaMetadata' -Status 'Skipped' -Detail 'No OTA metadata path configured.'
    }

    Write-Host ''
    if ($publishFailures.Count -eq 0) {
        Write-Host ('Release {0} published successfully.' -f $tagName) -ForegroundColor Green
    } else {
        Write-Host ('Release publish completed with errors for {0}.' -f $tagName) -ForegroundColor Yellow
    }

    Write-Host 'Release summary:' -ForegroundColor Cyan
    Write-Host ('Current Version: {0}' -f $currentVersion)
    Write-Host ('New Version: {0}' -f $newVersion)
    Write-Host ('GitHub Release status: {0}' -f $publishStatus['GitHubRelease'])
    Write-Host ('APK upload status: {0}' -f $publishStatus['ApkUpload'])
    Write-Host ('OTA metadata status: {0}' -f $publishStatus['OtaMetadata'])
    Write-Host ''
    Write-Host 'User instructions:' -ForegroundColor Cyan
    Write-Host '1. Open KnightOS.'
    Write-Host '2. Go to Settings -> Check for Updates.'
    Write-Host '3. Download and install the latest version.'

    if ($publishFailures.Count -gt 0) {
        Write-Host ''
        Write-Host 'Failures encountered:' -ForegroundColor Yellow
        foreach ($failure in $publishFailures) {
            Write-Host (' - {0}' -f $failure) -ForegroundColor Yellow
        }
    }
}
catch {
    Write-ErrorMessage $_.Exception.Message
    exit 1
}
