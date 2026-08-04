# Knight OS Version 5 - Consolidated Architecture

## Overview
This document defines the high-level architecture for Knight OS Version 5, established as the authoritative foundation for the "Perception & Proactivity" era.

## Architecture Principles
- **Modular by Design**: Independent features communicating through well-defined interfaces.
- **AI-First**: Intelligence is baked into the core, not added as an afterthought.
- **Event-Driven**: Asynchronous communication between modules.
- **Privacy by Default**: User data is treated with the highest security.
- **Offline-First**: Core functionality works without internet connectivity where practical.

## System Layers
1. **User Interface**: Flutter-based responsive UI.
2. **Presentation Layer**: Navigation, Screens, Widgets, Themes.
3. **Application Layer**: AI Engine, Automation Engine, Feature Logic.
4. **Service Layer**: Authentication, APIs, Notifications, Storage.
5. **Data Layer**: Local SQLite (Drift), Cache, Cloud Sync.

## Core Modules
- **AI Engine**: Assistant, Memory, Context, Planning.
- **Automation Engine**: Triggers, Actions, Workflows, Scheduler.
- **Feature Modules**: Health, Finance, Devices, Productivity, Communication.
- **Infrastructure**: Auth, Navigation, Database, Settings.

## Architecture Rules
- Every module has a single responsibility.
- Business logic must not exist in the UI.
- Direct dependencies between feature modules must be avoided. Use service interfaces.
- AI components are decoupled from UI implementation.
- Every module MUST include documentation and tests.
