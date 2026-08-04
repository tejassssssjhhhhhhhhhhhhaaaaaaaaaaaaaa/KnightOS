# KnightOS Database Architecture

## Engine: Drift (SQLite)
KnightOS uses Drift for a reactive, type-safe database layer.

## Core Schema: `MemoryTable`
The central repository for all knowledge fragments.

### Fields
- `id`: UUID (Primary Key)
- `logicalId`: Canonical ID for a specific fact (e.g., `HOME_LOCATION`).
- `category`: Knowledge domain (Health, Finance, etc.).
- `content`: JSON payload of the fact.
- `trustWeight`: Confidence score (0.0 - 1.0).
- `provenance`: Origin of data (e.g., `GOOGLE_HEALTH`).
- `createdAt`: Timestamp.
- `isLatest`: Boolean flag for the current version of the fact.

## Deduplication Logic
1. **Hash Generation**: Sha-256 hash of the `content` and `logicalId`.
2. **Conflict Resolution**: If a hash exists, update the timestamp but retain the logical entity.
3. **Chain of Truth**: Historical versions are kept but marked as `isLatest = false`.

## Performance Optimization
- **Indexing**: `logicalId` and `category` are indexed for fast retrieval.
- **Reactive Streams**: Use `watch` APIs to auto-update UI components.
