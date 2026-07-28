# KnightOS

KnightOS is a high-performance personal operating system built with Flutter. It aims to be the central hub for your life, tracking missions, recovery, finances, and history through an intelligent, local-first architecture.

## Features

- **Personal AI (Knight)**: A premium chat experience designed for future LLM integration.
- **Mission Center (Focus)**: Track your daily priorities and AI-optimized goals.
- **Health & Readiness (Recovery)**: Monitor sleep, energy, and stress levels.
- **Financial Dashboard (Money)**: Track income, expenses, and savings with an adaptive UI.
- **Planning (Upcoming)**: Manage events, tasks, and deadlines in a unified view.
- **Life History (Timeline)**: A chronological record of milestones, journals, and achievements.

## Architecture

KnightOS follows a robust **Repository-Controller-UI** pattern powered by **Riverpod**:

- **Presentation**: Adaptive layouts for phones and tablets using Material 3.
- **State Management**: Reactive state via `AsyncNotifier`.
- **Persistence**: Hybrid storage using SQLite (Drift) and JSON files (LocalDatabase).
- **Core Intelligence**: Extensible orchestration layer for cross-module insights.

## Getting Started

1. **Install Flutter**: Follow the [official guide](https://docs.flutter.dev/get-started/install).
2. **Clone the Repo**: `git clone https://github.com/your-repo/knight_os.git`
3. **Get Dependencies**: `flutter pub get`
4. **Run the App**: `flutter run`

## Documentation

- [Project Architecture](PROJECT_ARCHITECTURE.md)
- [Design Guidelines](DESIGN.md)
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
