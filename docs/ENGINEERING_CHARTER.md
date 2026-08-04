# KnightOS Engineering Charter

## Core Principles
1. **Quality First**: No features are merged without tests.
2. **SSoT**: Data must be canonical. Avoid duplication at all costs.
3. **Reactive UI**: Use Riverpod and Drift `watch` APIs for zero-manual-refresh interfaces.
4. **Privacy by Design**: All intelligence and data must remain local-first.

## Technical Standards

### State Management
- **Riverpod**: Use `Provider`, `AsyncNotifier`, and `StateProvider`.
- **Immutability**: All data models must be immutable (`@freezed` or similar patterns).

### Persistence
- **Drift**: Primary SQLite engine.
- **Migrations**: Always include versioned migration scripts.
- **Deduplication**: Use Sha-256 hashing for all ingested data blocks.

### UI/UX
- **Horizon Language**: Strictly follow `DesignColors` and `DesignGradients`.
- **Performance**: Maintain 60fps. Heavy logic moves to Isolates.

## Definition of Done
- [ ] Code passes `flutter analyze`.
- [ ] Code passes all unit/widget tests.
- [ ] Documentation updated in `docs/`.
- [ ] README/CHANGELOG updated if applicable.
