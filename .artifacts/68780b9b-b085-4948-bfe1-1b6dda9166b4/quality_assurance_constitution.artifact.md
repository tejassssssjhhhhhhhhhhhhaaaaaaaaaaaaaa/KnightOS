# Quality Assurance Constitution

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO / Head of QA

## 1. The Testing Pyramid
*   **70% Unit Tests:** Focus on pure logic and data mapping.
*   **20% Integration/Widget Tests:** Focus on component interaction and UI state.
*   **10% E2E/Manual Tests:** Focus on critical user journeys.

## 2. Mandatory Test Types
*   **Golden Tests:** Visual regression testing for all UI components in the Design System.
*   **Accessibility Tests:** Automated checks for contrast, touch targets, and semantics.
*   **Security Scans:** Automated dependency vulnerability scanning.
*   **Performance Benchmarking:** Automated tracking of frame rates, startup time, and memory usage in CI.

## 3. Regression Policy
*   **Zero Regression Tolerance:** Any bug found in production must have a corresponding regression test written before the fix is merged.

## 4. Release Gates (The "Knight Gates")
No module may move to production unless it passes:
1.  **CI Gate:** 100% pass rate for Unit and Integration tests.
2.  **Lint Gate:** Zero warnings or errors from static analysis.
3.  **Security Gate:** No critical or high-severity vulnerabilities.
4.  **Performance Gate:** Meets or exceeds baseline benchmarks.
5.  **Design Gate:** Verified compliance with the Design System Constitution.

## 5. Security & Privacy Testing
*   **Data Isolation Check:** Verify that Level 4 data cannot be accessed by unauthorized services.
*   **Encryption Verification:** Ensure data is encrypted at rest and in transit in test environments.

## 6. Error Simulation
*   **Chaos Testing:** Simulate network failures, low memory, and slow disk I/O to ensure graceful degradation.

## 7. User Acceptance Testing (UAT)
*   **Internal Beta:** Mandatory "Dogfooding" period for all major feature releases.
*   **Feedback Loop:** A standardized process for capturing and prioritizing user feedback during beta phases.
