Write-Host "=== KnightOS Validation ==="
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build apk --debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Automated validation completed."
Write-Host "Next: Run the app on a physical device and verify the changed functionality."
