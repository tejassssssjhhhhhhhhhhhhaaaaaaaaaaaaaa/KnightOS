# Implementation Plan - Phase 8: Knight Intelligence Platform Design

This plan outlines the architectural design and initial implementation of the Knight Intelligence Platform. The platform will serve as an event-driven, plugin-based reasoning core for KnightOS, coordinating domain-specific intelligence modules.

## User Review Required

> [!IMPORTANT]
> - This phase transitions the intelligence layer from a linear pipeline to an **asynchronous, event-driven architecture**.
> - Every module (Health, Finance, etc.) will contribute intelligence through a common `IntelligenceModule` interface.
> - We will introduce an **Intelligence Bus** to decouple event emission from reasoning execution.

## Proposed Changes

### 1. [Intelligence Core] [Architecture]
Define the foundational types and interfaces for the event-driven reasoning system.

#### [NEW] [IntelligenceEvents](file:///C:/Users/tejas/knight_os/lib/core/intelligence/domain/intelligence_events.dart)
- Define `IntelligenceEvent` base class.
- Concrete events: `DataChangedEvent`, `ContextChangedEvent`, `UserIntentEvent`.

#### [NEW] [IntelligenceModule](file:///C:/Users/tejas/knight_os/lib/core/intelligence/domain/intelligence_module.dart)
- Define `IntelligenceModule` interface with `onEvent`, `inputDomains`, and `id`.

#### [NEW] [IntelligenceBus](file:///C:/Users/tejas/knight_os/lib/core/intelligence/intelligence_bus.dart)
- Concrete implementation of `KnightEventBus` using a `StreamController.broadcast()`.

#### [NEW] [IntelligenceOrchestrator](file:///C:/Users/tejas/knight_os/lib/core/intelligence/intelligence_orchestrator.dart)
- Coordinates the execution of registered `IntelligenceModule`s based on events.
- Manages module lifecycle and execution order.

#### [NEW] [IntelligencePlatform](file:///C:/Users/tejas/knight_os/lib/core/intelligence/intelligence_platform.dart)
- Unified facade that encapsulates the Bus, Orchestrator, and Core Engines (Memory, Graph, etc.).

---

### 2. [Infrastructure] [Integration]
Integrate the platform with the existing reactive infrastructure.

#### [MODIFY] [MemoryEngine](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/memory_engine.dart)
- Emit `DataChangedEvent` to the `IntelligenceBus` whenever a memory is saved or updated.

#### [NEW] [IntelligencePlatformProvider](file:///C:/Users/tejas/knight_os/lib/core/intelligence/providers/intelligence_platform_provider.dart)
- Riverpod providers for `IntelligenceBus` and `IntelligencePlatform`.

---

### 3. [Reasoning Modules] [Implementation]
Adapt a few existing engines into the new plugin architecture as a proof of concept.

#### [NEW] [ContextIntelligenceModule](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/modules/context_module.dart)
- Adapts `WorldContextEngine` logic into an `IntelligenceModule`.

#### [NEW] [InsightIntelligenceModule](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/modules/insight_module.dart)
- Adapts `InsightEngine` logic into an `IntelligenceModule`.

## Verification Plan

### Automated Tests
- `intelligence_bus_test.dart`: Verify that events are emitted and received correctly.
- `intelligence_orchestrator_test.dart`: Verify that modules are triggered by relevant events.
- `memory_engine_event_test.dart`: Verify that saving a memory triggers a `DataChangedEvent`.

### Manual Verification
- Monitor debug logs to confirm that importing data triggers the appropriate intelligence modules.
- Verify that the Dashboard reflects updates triggered by the event-driven platform.
