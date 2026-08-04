# KnightOS Context Engine

## Definition
The Context Engine maintains the "Current State" of the user and their environment to drive proactivity.

## Data Inputs
- **Sensors**: Accelerometer, GPS (Location context).
- **Schedule**: Calendar events and upcoming tasks.
- **Usage**: Active apps and interaction frequency.
- **External**: Weather, time of day.

## Proactivity Cycles
1. **Perception**: Engine scans inputs for significant changes.
2. **Appraisal**: Determines if the change requires action (e.g., "User is late for a meeting").
3. **Trigger**: Knight Orb initiates a suggestion or notification.

## Privacy Guardrails
Context data is ephemeral and processed locally. It is never uploaded to the cloud without explicit encryption and user intent.
