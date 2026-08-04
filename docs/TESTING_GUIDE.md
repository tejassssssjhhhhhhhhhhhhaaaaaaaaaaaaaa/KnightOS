# KnightOS Testing Guide

## Strategy
KnightOS uses a multi-layered testing approach to ensure stability and reasoning accuracy.

## Test Types

### 1. Unit Tests
- Location: `test/core/`
- Focus: Business logic, DAOs, Mappers.
- Command: `flutter test test/core`

### 2. Widget Tests
- Location: `test/widget/`
- Focus: UI components and interactions.
- Command: `flutter test test/widget`

### 3. Integration Tests
- Location: `test/integration/`
- Focus: End-to-end flows (Auth, Sync).
- Command: `flutter test test/integration`

## Mocking
Use `mocktail` for all mocking needs.
- **Google APIs**: Always mock network responses.
- **Database**: Use in-memory Drift databases for testing.

## Coverage Requirements
- New logic: 100%
- Core Platform: > 90%
- UI Components: > 70%
