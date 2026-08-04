# Manual User Acceptance Testing (UAT) Guide

## Authentication Flow
**Purpose**: Verify user can sign up, sign in, and sign out securely.

| Step | Action | Expected Result | Pass/Fail |
| :--- | :--- | :--- | :--- |
| 1 | Launch app and select "Sign Up" | Onboarding flow starts | |
| 2 | Complete onboarding with valid data | User profile created, landed on Dashboard | |
| 3 | Tap Knight Orb -> Settings -> Sign Out | App returns to Welcome screen | |
| 4 | Sign in with valid credentials | User returns to Dashboard with data intact | |

## Knowledge Vault Exploration
**Purpose**: Verify memory mapping and graph visualization.

| Step | Action | Expected Result | Pass/Fail |
| :--- | :--- | :--- | :--- |
| 1 | Navigate to Knowledge Vault | "Night Sky" UI appears with stars | |
| 2 | Tap a Memory Star | Detail view opens with evidence & reasoning | |
| 3 | Confirm an "Inferred" memory | Memory state changes to "User Confirmed" | |

## Data Ingestion
**Purpose**: Verify local file processing and deduplication.

| Step | Action | Expected Result | Pass/Fail |
| :--- | :--- | :--- | :--- |
| 1 | Go to Data Center -> Import | File picker opens | |
| 2 | Select a valid Timeline JSON | Success notification; Timeline events populated | |
| 3 | Import the SAME file again | Notification: "Skipping duplicate file" | |

## Knight AI Interaction
**Purpose**: Verify companion responsiveness.

| Step | Action | Expected Result | Pass/Fail |
| :--- | :--- | :--- | :--- |
| 1 | Tap Knight Orb | Command Center opens | |
| 2 | Swipe Orb to edge | Orb snaps to edge correctly | |
| 3 | Wait for Context Trigger | Orb glows when meaningful context changes | |
