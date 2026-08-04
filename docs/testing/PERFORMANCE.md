# Performance Validation Benchmarks

## Targets & Thresholds

| Metric | Target | Warning | Critical |
| :--- | :--- | :--- | :--- |
| **App Startup (Cold)** | < 1.5s | 2.5s | > 4.0s |
| **Frame Rate (Main UI)** | 60 fps | 45 fps | < 30 fps |
| **Memory (Baseline)** | 120MB | 200MB | > 350MB |
| **SQLite Query (Single)** | < 10ms | 50ms | > 100ms |
| **Graph Sync (100 nodes)** | < 2.0s | 5.0s | > 10.0s |

## Measurement Procedures

### Startup Time
Run `flutter run --profile` and observe the "Timeline" in DevTools. Measure from process start to `firstFrame`.

### Memory Usage
Use Android Studio Profiler or `flutter devtools`. Check for leaks after multiple navigation cycles between Dashboard and Knowledge Vault.

### Battery Impact
Monitor CPU usage in `profile` mode. Ensure background workers (Ingestion) strictly follow the `ImportPreferenceService` throttle settings.

### SQLite Performance
Enable `Drift` logging in debug mode to see query durations. Any query exceeding 50ms must be optimized with an Index.
