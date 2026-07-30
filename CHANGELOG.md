# Changelog

## [4.0.0-rc.1] - 2026-07-29
### Added
- **Planning Engine**: AI-powered goal decomposition and task planning.
- **World Engine**: Structured perception of the user's environment via connectors.
- **AI Copilot**: Proactive conversational assistance across the system.
- **Autonomous Knight**: Safe multi-device execution of multi-step workflows.
- **Ambient Voice**: Seamless voice-first interaction with ripple-pulse visual feedback.
- **Self-Healing**: Automatic recovery and repair reasoning for failed workflows.
- **Knowledge Graph**: Relationship discovery and memory networks.

### Fixed
- **Account Persistence**: Implemented automatic migration of legacy user accounts from Documents to Support directory.
- **Voice Interaction**: Fixed broken voice capture in onboarding by merging services and providing valid simulation fallback.
- **Navigation**: Resolved black screen issues when skipping onboarding or accessing settings by adding missing `/launch` route and standardizing shell navigation.
- **Startup Stability**: Fixed a "ref used after dispose" race condition in `SplashScreen` using defensive `mounted` guards.
- **Test Quality**: Resolved `UnimplementedError` in core intelligence tests by optimizing memory mocks.

### Changed
- Migrated to full Version 4 Intelligence Architecture.
- Updated design system to Horizon 2.0 specs.

## [2.0.26]
- Initial Version 3 baseline stability improvements.
