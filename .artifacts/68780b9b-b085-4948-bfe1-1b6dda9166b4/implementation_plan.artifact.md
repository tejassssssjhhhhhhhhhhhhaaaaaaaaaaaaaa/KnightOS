# Implementation Plan - Milestone 1: Platform Foundation

This plan covers the execution of Milestone 1 as defined in the KnightOS Master Execution Plan. We will establish the secure core, identity systems, and universal data persistence.

## User Review Required

> [!IMPORTANT]
> This phase modifies core storage and authentication logic. Existing Google Sign-In data will be migrated into the new Unified Identity model.

## Proposed Changes

### [KnightOS Core]

#### [NEW] [identity.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/entities/identity.dart)
Defines the unified `Identity` entity.

#### [NEW] [auth_user.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/entities/auth_user.dart)
Defines the `AuthUser` entity representing a logged-in session.

#### [MODIFY] [google_auth_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/google_auth_service.dart)
Refactor to implement the new `IAuthProvider` interface.

#### [NEW] [identity_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/identity_service.dart)
The central orchestrator for identity and multi-provider auth.

#### [MODIFY] [secure_storage.dart](file:///C:/Users/tejas/knight_os/lib/core/storage/secure_storage.dart)
Add support for privacy classifications and managed encryption keys.

#### [NEW] [privacy_vault.dart](file:///C:/Users/tejas/knight_os/lib/core/storage/privacy_vault.dart)
Service for handling sensitive data with on-device encryption.

#### [NEW] [uds_schemas.dart](file:///C:/Users/tejas/knight_os/lib/core/storage/uds_schemas.dart)
Isar/SQLite collection definitions for the Universal Data Schema.

#### [NEW] [evidence_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/evidence_service.dart)
API for verified evidence ingestion.

## Verification Plan

### Automated Tests
- Unit tests for `IdentityService` and `AuthRepository`.
- Integration tests for `PrivacyVault` encryption/decryption.
- Persistence tests for `UDS` schemas ensuring graph relationships hold.

### Manual Verification
- Verify successful Google Sign-In and check if identity is correctly mapped in the new `IdentityService`.
- Inspect local storage to ensure "Sensitive" data is encrypted.
