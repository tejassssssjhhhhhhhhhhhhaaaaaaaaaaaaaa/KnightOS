# Privacy, Security & Consent Constitution

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO / CISO

## 1. Privacy by Design
Privacy is the bedrock of user trust. It is a technical requirement, not a policy checkbox.

## 2. Data Classification
*   **Public (Level 1):** Shared openly (e.g., public profile name).
*   **Personal (Level 2):** Identifiable but necessary for services (e.g., email address).
*   **Sensitive (Level 3):** High-impact data (e.g., finances, detailed health metrics).
*   **Highly Sensitive (Level 4):** Deeply personal data (e.g., private messages, raw biometric data).

## 3. Encryption Philosophy
*   **At Rest:** AES-256 encryption for all data on device and in cloud.
*   **In Transit:** TLS 1.3 for all network communication.
*   **Zero-Knowledge (Aspirational):** Move toward end-to-end encryption for the entire Evidence Graph where KnightOS Core acts only as a blind relay.

## 4. User Ownership & Sovereignty
*   **The User Owns the Key:** The user has the ultimate right to access, export, and destroy their data.
*   **Right to Forget:** Deleting a module or the account must result in verifiable cryptographic erasure of all associated data.

## 5. Processing Boundaries
*   **Local-First Processing:** All "Level 4" data must be processed locally. No raw Level 4 data may be sent to the cloud AI without explicit, single-use consent.
*   **Anonymization:** Data sent for cloud-based "Market Insights" or "Global Benchmarking" must be de-identified and aggregated.

## 6. Consent Flows
*   **Granular Consent:** Users approve specific data types for specific features (e.g., "Allow Career Compass to see Health Sleep data for performance correlation").
*   **Just-in-Time:** Requests for permission must happen at the moment the feature is activated, with a clear explanation of *why*.
*   **Revocability:** Consent can be revoked at any time, resulting in the immediate cessation of data flow for that feature.

## 7. Audit Logging
*   **Transparent Access:** Users can view a log of which KnightOS services accessed their data and when.
*   **Security Audits:** Regular third-party penetration testing and architectural reviews.

## 8. Integration Security
*   **Isolation:** Third-party integrations (APIs) run in sandboxed environments with "least-privilege" access.
*   **Token Management:** Secure, encrypted storage for all integration credentials (e.g., Keychain/Keystore).
