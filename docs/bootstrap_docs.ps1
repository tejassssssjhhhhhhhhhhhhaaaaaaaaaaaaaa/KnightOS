# bootstrap_docs.ps1
# Creates the Knight OS Engineering Manual structure.
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$folders = @(
    "Assets","Prompts","Research","Roadmaps","Sprints","Archive"
)

$files = @{
"00_Roadmap.md" = @"
# Knight OS Engineering Manual Roadmap

## Status
- Phase 1: Vision & Product Blueprint
- Phase 2: Architecture
- Phase 3: Development Standards
- Phase 4: Version 3
- Phase 5: Version 4
- Phase 6: Release & Maintenance
"@;
"01_Vision.md" = "# Vision`n`n## Mission`n`n## Long-term Goals`n";
"02_Product_Philosophy.md" = "# Product Philosophy`n";
"03_Architecture.md" = "# Architecture`n";
"04_Development_Standards.md" = "# Development Standards`n";
"05_UI_Design_System.md" = "# UI Design System`n";
"06_Version3.md" = "# Version 3`n";
"07_Version4.md" = "# Version 4`n";
"08_Task_Index.md" = "# Task Index`n";
"09_Testing.md" = "# Testing`n";
"10_Release_Process.md" = "# Release Process`n";
"CHANGELOG.md" = "# Changelog`n";
"IDEAS.md" = "# Ideas`n";
"DECISIONS.md" = "# Decisions`n";
"KNOWN_ISSUES.md" = "# Known Issues`n";
}

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Root $folder) | Out-Null
}

foreach ($entry in $files.GetEnumerator()) {
    $path = Join-Path $Root $entry.Key
    if (!(Test-Path $path)) {
        Set-Content -Path $path -Value $entry.Value -Encoding UTF8
    }
}

Write-Host ""
Write-Host "Knight OS documentation bootstrap complete." -ForegroundColor Green
Write-Host "Location: $Root"
