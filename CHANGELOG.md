# CHANGELOG - KnightOS

## [4.0.0+3] - 2026-08-03
### Added
- **Health Explainability Layer**: Every score now includes a `ReasoningTrace`.
- **Confidence Model**: Source-based trust weighting (Galaxy Watch: 0.95, Manual: 1.0).
- **Explainability UI**: New tap-to-explain interaction in the Health Dashboard.
- **Verification Missions**: Automated requests to user for low-confidence biometric data.
- **Knowledge Graph Expansion**: Directional relationships between Sleep, Recovery, Stress, and Nutrition.
- **Developer Audit**: Health Intelligence section added to Developer Mode.

### Changed
- Refactored `HealthEngine` to output `HealthScoreResult` objects.
- Updated `KnightContext` to propagate full reasoning data.
- Normalized log categories for intelligence analysis.

### Fixed
- Resolved `KnightDataRefreshEvent` missing class error.
- Fixed truncated model files in the core intelligence layer.
- Cleaned up unused imports across the health module.
