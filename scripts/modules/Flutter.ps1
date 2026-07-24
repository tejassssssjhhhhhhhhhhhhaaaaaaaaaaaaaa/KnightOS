function Ensure-FlutterInstalled {
    param([string]$FlutterCommand)
    try {
        & $FlutterCommand --version | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Invoke-FlutterCommand {
    param(
        [string]$FlutterCommand,
        [string[]]$Arguments,
        [string]$WorkingDirectory
    )

    $process = Start-Process -FilePath $FlutterCommand -ArgumentList $Arguments -WorkingDirectory $WorkingDirectory -NoNewWindow -Wait -PassThru -ErrorAction Stop
    if ($process.ExitCode -ne 0) {
        throw "Flutter command failed: $FlutterCommand $($Arguments -join ' ')"
    }
}

function Run-FlutterPubGet {
    param([string]$RootPath, [string]$FlutterCommand)
    Write-Host 'Running flutter pub get...'
    Invoke-FlutterCommand -FlutterCommand $FlutterCommand -Arguments @('pub', 'get') -WorkingDirectory $RootPath
}

function Invoke-FlutterCommandWithOutput {
    param(
        [string]$FlutterCommand,
        [string[]]$Arguments,
        [string]$WorkingDirectory
    )

    function Quote-Argument {
        param([string]$Value)
        if ($Value -match '[\s"]') {
            return '"' + $Value.Replace('"', '\\"') + '"'
        }
        return $Value
    }

    Push-Location $WorkingDirectory
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = 'cmd.exe'
        $quotedCommand = Quote-Argument -Value $FlutterCommand
        $quotedArguments = $Arguments | ForEach-Object { Quote-Argument -Value $_ }
        $psi.Arguments = '/c ' + $quotedCommand + ' ' + ($quotedArguments -join ' ')
        $psi.WorkingDirectory = $WorkingDirectory
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.UseShellExecute = $false
        $psi.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $psi
        $process.Start() | Out-Null

        $stdOut = $process.StandardOutput.ReadToEnd()
        $stdErr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        return [PSCustomObject]@{
            ExitCode = $process.ExitCode
            StdOut = $stdOut.Trim()
            StdErr = $stdErr.Trim()
        }
    } finally {
        Pop-Location
    }
}

function Parse-FlutterAnalyzeSummary {
    param([string]$Output)

    $errors = 0
    $warnings = 0
    $infos = 0

    foreach ($line in ($Output -split "\r?\n")) {
        if ($line -match '^[ \t]*(error|warning|info)\b') {
            switch ($Matches[1].ToLower()) {
                'error' { $errors++ }
                'warning' { $warnings++ }
                'info' { $infos++ }
            }
        }
    }

    if ($errors -eq 0 -and $warnings -eq 0 -and $infos -eq 0) {
        if ($Output -match '([0-9]+)\s+issues?\s+found') {
            $issues = [int]$Matches[1]
            if ($issues -gt 0) {
                Write-Verbose "Unable to classify analyzer issue severities from output; falling back to issue count: $issues"
            }
        }
    }

    return [PSCustomObject]@{
        Errors = $errors
        Warnings = $warnings
        Infos = $infos
    }
}

function Run-FlutterAnalyze {
    param(
        [string]$RootPath,
        [string]$FlutterCommand,
        [bool]$FailOnWarnings = $false
    )

    Write-Host 'Running flutter analyze...'
    $analyzeArgs = @('analyze', '--no-fatal-infos')
    if (-not $FailOnWarnings) {
        $analyzeArgs += '--no-fatal-warnings'
    }

    $result = Invoke-FlutterCommandWithOutput -FlutterCommand $FlutterCommand -Arguments $analyzeArgs -WorkingDirectory $RootPath
    $output = "$($result.StdOut.Trim())`n$($result.StdErr.Trim())".Trim()
    $summary = Parse-FlutterAnalyzeSummary -Output $output

    Write-Host "Analyzer results: $($summary.Errors) errors, $($summary.Warnings) warnings, $($summary.Infos) infos"
    if ($result.ExitCode -ne 0) {
        Write-Host "flutter analyze exited with code $($result.ExitCode); evaluating parsed diagnostics instead of relying on the process exit code." -ForegroundColor DarkYellow
    }

    if ($summary.Errors -gt 0) {
        Write-Host $output
        throw "flutter analyze detected $($summary.Errors) error(s)."
    }

    if ($summary.Warnings -gt 0) {
        Write-WarningMessage "flutter analyze detected $($summary.Warnings) warning(s)."
        Write-Host $output
        if ($FailOnWarnings) {
            throw "flutter analyze detected $($summary.Warnings) warning(s) and warnings are configured to fail."
        }
    }

    return $summary
}

function Run-FlutterTest {
    param([string]$RootPath, [string]$FlutterCommand)
    Write-Host 'Running flutter test...'
    Invoke-FlutterCommand -FlutterCommand $FlutterCommand -Arguments @('test') -WorkingDirectory $RootPath
}

function Run-FlutterBuildRelease {
    param([string]$RootPath, [string]$FlutterCommand)
    Write-Host 'Running flutter build apk --release...'
    Invoke-FlutterCommand -FlutterCommand $FlutterCommand -Arguments @('build', 'apk', '--release') -WorkingDirectory $RootPath
}
