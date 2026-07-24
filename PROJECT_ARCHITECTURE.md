# Project Architecture

## Overview
KnightOS is a Flutter-based personal operating system app with onboarding, authentication, dashboard and feature trackers, settings, and OTA update support.

## Architecture layers
- App layer: routing, shell navigation, screen composition, and high-level UI state.
- Core layer: repositories, storage, router, theme, authentication, and update services.
- Feature layer: vertical modules such as finance, fitness, sleep, work, onboarding, and learning.

## State and navigation
- Riverpod is used for provider-based state and UI-facing async state.
- GoRouter handles application navigation and route guards.
- Screens and providers interact with repositories and storage helpers rather than directly talking to platform APIs.

## Data flow
1. Screens render from provider state.
2. Providers or controllers call repositories or storage services.
3. Storage services persist JSON through local file storage and secure storage.
4. The UI updates after providers refresh state.

## Update flow
- The OTA path uses a GitHub Releases provider and an Android installer flow.
- The update screen must refresh package info and GitHub data on each open and refresh event.
