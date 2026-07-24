function Get-PubspecVersion {
    param([string]$RootPath)

    $pubspecPath = Join-Path $RootPath 'pubspec.yaml'
    if (-not (Test-Path $pubspecPath)) {
        throw 'pubspec.yaml not found in project root.'
    }

    $lines = Get-Content -Path $pubspecPath
    foreach ($line in $lines) {
        if ($line -match '^version:\s*(\S+)') {
            return $Matches[1]
        }
    }

    throw 'Unable to parse version from pubspec.yaml.'
}

function Parse-SemVer {
    param([string]$version)

    if ($version -match '^(\d+)\.(\d+)\.(\d+)\+(\d+)$') {
        return [PSCustomObject]@{
            Major = [int]$Matches[1]
            Minor = [int]$Matches[2]
            Patch = [int]$Matches[3]
            Build = [int]$Matches[4]
        }
    }

    throw "Invalid semantic version format: $version"
}

function Increment-SemVer {
    param(
        [Parameter(Mandatory)][ValidateSet('patch','minor','major')][string]$ReleaseType,
        [PSCustomObject]$VersionObject
    )

    switch ($ReleaseType) {
        'patch' {
            $VersionObject.Patch++
        }
        'minor' {
            $VersionObject.Minor++
            $VersionObject.Patch = 0
        }
        'major' {
            $VersionObject.Major++
            $VersionObject.Minor = 0
            $VersionObject.Patch = 0
        }
    }

    $VersionObject.Build++
    return $VersionObject
}

function Format-SemVer {
    param([PSCustomObject]$VersionObject)
    return "$($VersionObject.Major).$($VersionObject.Minor).$($VersionObject.Patch)+$($VersionObject.Build)"
}

function Update-PubspecVersion {
    param(
        [string]$RootPath,
        [string]$NewVersion
    )

    $pubspecPath = Join-Path $RootPath 'pubspec.yaml'
    $content = Get-Content -Path $pubspecPath
    $updated = $content | ForEach-Object {
        if ($_ -match '^(version:\s*)(\S+)$') {
            "$($Matches[1])$NewVersion"
        } else {
            $_
        }
    }
    Set-Content -Path $pubspecPath -Value $updated -Encoding utf8
}
