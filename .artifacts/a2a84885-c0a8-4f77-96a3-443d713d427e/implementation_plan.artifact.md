# Recovery & Completion Plan: KnightOS Finance Platform Foundation (Phase A)

This plan addresses the remaining gaps in Phase A identified during the codebase inspection, including a critical bug in the deduplication pipeline and missing components for the Finance Inbox.

## User Review Required

> [!IMPORTANT]
> A bug in the `GenericUpiParser` is causing bank statement emails to be skipped during deduplication, leading to duplicate transaction entries. I will be broadening this parser to act as a catch-all for financial emails until institution-specific parsers are added.

## Proposed Changes

### [Engine Refinement]

#### [MODIFY] [generic_upi_parser.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/parsers/generic_upi_parser.dart)
Broaden `canHandle` to include generic financial terms (debit, credit, transaction, rs, inr, amount) to ensure high-confidence matching for diverse financial emails.

#### [MODIFY] [finance_evidence_vault.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/finance_evidence_vault.dart)
Enhance `_inferType` to use the extraction result's metadata (card, paymentMethod) to differentiate between 'expense' and 'income' or 'transfer'.

### [Infrastructure Completion]

#### [NEW] [finance_inbox_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/sync/finance_inbox_service.dart)
Service to manage the lifecycle of `FinanceInboxTaskTable` entries, allowing the UI to fetch pending reviews and resolve them.

#### [MODIFY] [developer_mode_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/settings/presentation/developer_mode_screen.dart)
Add a "Finance Audit" subsection to the SYNC tab to display metrics from `GmailAuditEngine` and a link to the Finance Inbox.

## Verification Plan

### Automated Tests
- Run `flutter test test/features/finance/platform/milestone3_test.dart` to verify the deduplication fix.
- Add `test/features/finance/platform/inbox_service_test.dart` for the new Inbox service.

### Manual Verification
- Inspect the new "Finance Audit" section in Developer Mode.
- Verify that low-confidence emails correctly appear in the Finance Inbox (simulated via tests).
