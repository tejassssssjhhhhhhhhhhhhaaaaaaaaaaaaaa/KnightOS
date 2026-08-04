# Knight OS Version 5 - Development Standards

## Overview
Mandatory standards for all Version 5 development to ensure consistency and maintainability.

## General Principles
- Write clean, readable, and self-documenting code.
- Prioritize simplicity; avoid over-engineering.
- No TODO, FIXME, or stubs in production-ready code.

## Coding Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `lowerCamelCase` or `static const PascalCase`

## Feature Structure
Every feature module must follow:
```
lib/features/feature_name/
├── models/
├── views/
├── viewmodels/ (or controllers/blocs)
├── services/
├── repositories/
├── widgets/
├── tests/
└── README.md
```

## Documentation Requirements
Every new feature or major change must document:
- Purpose and responsibilities.
- Public APIs and usage.
- Data flow and state management.
- Error handling strategy.

## Error Handling & Logging
- Use `try-catch` in services; never let exceptions bubble to the UI unhandled.
- Log significant lifecycle events and critical failures.
- NEVER log sensitive user data (PII, tokens, passwords).

## Testing Standards
- **Unit Tests**: Mandatory for business logic and services.
- **Widget Tests**: Required for reusable UI components.
- **Integration Tests**: Required for critical user flows.
- Aim for high coverage in core modules (AI, Automation, Finance).

## Git Commit Standards
Follow Conventional Commits:
- `feat: ...`
- `fix: ...`
- `docs: ...`
- `refactor: ...`
- `test: ...`
- `chore: ...`
