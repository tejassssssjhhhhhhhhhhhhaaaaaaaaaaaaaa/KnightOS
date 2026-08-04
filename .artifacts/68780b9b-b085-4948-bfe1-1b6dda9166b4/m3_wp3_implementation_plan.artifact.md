# Implementation Plan - M3-WP3: Evidence Center

This plan covers the implementation of the central review and management experience for all imported evidence in KnightOS.

## Proposed Changes

### [KnightOS Core]

#### [MODIFY] [evidence.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/entities/evidence.dart)
Add `verificationStatus`, `domain`, `privacyLevel`, `confidence`, and `auditHistory`.
Define `EvidenceVerificationStatus` enum: `pending`, `verified`, `trusted`, `rejected`.

#### [MODIFY] [evidence.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/evidence.dart)
Update Drift schema to include new columns for status, domain, and confidence.

#### [MODIFY] [i_evidence_repository.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/repositories/i_evidence_repository.dart)
Add methods for:
- `updateStatus(String caid, EvidenceVerificationStatus status)`
- `getPendingEvidence()`
- `getFilteredEvidence(EvidenceFilter filter)`
- `addAuditLog(String caid, String action)`

#### [MODIFY] [evidence_repository_impl.dart](file:///C:/Users/tejas/knight_os/lib/core/repositories/evidence_repository_impl.dart)
Implement new repository methods and map new Drift columns.

#### [NEW] [evidence_review_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/evidence_review_service.dart)
Business logic for:
- Duplicate detection (heuristic based on name, size, or metadata).
- Merge operations (combining metadata from two evidence nodes).
- Verification transitions.

### [Features - Import/Evidence]

#### [NEW] [evidence_inbox_controller.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/controllers/evidence_inbox_controller.dart)
Riverpod notifier to manage the inbox state, filtering, and bulk actions.

#### [NEW] [evidence_inbox_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/screens/evidence_inbox_screen.dart)
The main list view for evidence review.

#### [NEW] [evidence_detail_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/screens/evidence_detail_screen.dart)
Detailed metadata view with action buttons (Accept, Reject, Merge).

## Verification Plan

### Automated Tests
- Unit tests for `EvidenceReviewService` duplicate detection logic.
- Integration tests for the verification workflow: `Pending` -> `Verified` -> `Timeline Update`.
- Repository tests for filtering and status updates.

### Manual Verification
- Import a document via `Import Center`.
- Navigate to `Evidence Inbox`.
- Verify the document appears as `Pending`.
- Review the document, edit metadata, and click `Verify`.
- Confirm the status change and check `Timeline` for reflected updates.
