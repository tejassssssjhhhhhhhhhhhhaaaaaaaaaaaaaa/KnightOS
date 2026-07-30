# Release Notes - Version 4.0.0 (Stable)

## Overview
Version 4.0.0 represents a major infrastructure overhaul of Knight OS, focusing on hardware stability, robust persistence, and performance optimization for Mediatek-based Android devices.

## Major Features
- **Drift Migration**: Successfully migrated from legacy JSON-based storage to a reactive SQLite engine (Drift).
- **Hybrid Storage Strategy**: Implemented a secondary persistence layer that automatically activates if the Android Keystore hangs.
- **Autonomous Execution Framework**: Foundational support for background perception and scheduler loops.
- **Pill Navigation**: New ergonomic bottom navigation system optimized for one-handed use.

## Bug Fixes
- **Resolved Hardware Deadlocks**: Fixed a critical issue where the app would freeze on a "Black Screen" or "Frozen Logo" on Xiaomi/Mediatek devices due to slow Android Keystore operations.
- **Rendering Stability**: Fixed GPU synchronization errors in `RenderThread` by simplifying the global Shell Stack.
- **Startup Guard**: Added an absolute 10s timeout to the splash screen to prevent infinite loading states during database initialization failures.

## Root Cause Analysis
The "Xiaomi Freeze" was identified as an `uninterruptible wait` in the native Android Keystore during high-frequency cryptographic operations. This blocked the Flutter UI thread. Our solution uses a 500ms timeout on all secure storage calls with a transparent fallback to an unencrypted `LocalDatabase`.

## Performance Improvements
- **Database Initialization**: Reduced from an average of 5.2s to 22ms via Drift's lazy-loading and optimized migration ledger.
- **Navigation Latency**: Improved hit-testing and frame budget in `KnightShell` by utilizing native `Scaffold` slots.

## Known Limitations
- Background Perception is currently limited by Android's `WorkManager` battery optimization constraints. Performance may vary on aggressive power-saving ROMs (MIUI/HyperOS).
