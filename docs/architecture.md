# KnightOS architecture

## Product direction

KnightOS is a personal operating system for decision support. It combines data from sleep, work, finance, fitness, planning, goals, and life context to generate proactive insights and recommendations.

## Architectural principles

- Feature-first modular structure
- Clean Architecture boundaries
- Cross-cutting AI layer for every module
- Dark-first, premium Material 3 experience
- Offline-first local cache with optional cloud sync
- Responsive and accessible UI

## Updated module map

lib/
- core/
  - app/
  - theme/
  - router/
  - services/
  - constants/
  - utils/
  - shared/
  - extensions/
  - models/
  - engines/
  - providers/
  - ai/
- features/
  - onboarding/
  - dashboard/
  - sleep/
  - work/
  - finance/
  - fitness/
  - planner/
  - goals/
  - analytics/
  - memory/
  - integrations/
  - automation/
  - ai/
  - settings/
  - auth/

## Cross-cutting intelligence

The intelligence layer is no longer owned by one screen or one feature. It lives in the core engines layer and is consumed by every module.

### Core engines
- core/engines/knight_score_engine.dart
- core/engines/insight_engine.dart
- core/engines/recommendation_engine.dart
- core/engines/prediction_engine.dart

These engines combine signals from multiple domains to produce:
- a daily Knight Score
- narrative insights
- actionable recommendations
- tomorrow-level predictions

## New modules

### features/integrations
Used for future integrations with Google Calendar, Health Connect, SmartThings, Gmail, and wearables.

### features/automation
Used for intelligent automations, workflows, and scheduled experiences.

### features/memory
Replaces the prior knowledge module. This is the long-term memory and second brain for the user.

## AI layer

AI is a cross-cutting concern and is used by:
- onboarding
- dashboard
- sleep
- work
- finance
- fitness
- planner
- goals
- analytics
- memory
- integrations
- automation
- settings

The AI experience is exposed through core services and shared engines rather than a single assistant screen.

## Phase 1 scope

Phase 1 focuses on the foundation layer only:
- app shell
- theming
- router
- provider scaffolding
- AI engine scaffolding
- module entrypoints
- navigation structure
