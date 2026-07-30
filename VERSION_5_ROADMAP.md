# Roadmap - Version 5.0.0 (Perception & Proactivity)

## Goal
Transition Knight OS from a reactive tool to a proactive companion by enhancing real-time perception and autonomous reasoning.

## Pending Improvements
- **Real-time Sensor Fusion**: Integrate high-frequency accelerometer and proximity data into the perception engine.
- **Improved reasoning latency**: Transition local reasoning cycles to a more efficient quantized LLM execution path.
- **Enhanced Orb UX**: Implement more expressive visual states for the Knight Orb during "Thinking" and "Acting" modes.

## New Features
- **Voice Intelligence**: Full integration of the local speech-to-text and text-to-speech engine.
- **Document OCR**: Automatic processing of images/documents into the Knowledge Vault.
- **Cross-module triggers**: Allow events in one module (e.g. Finance) to trigger actions in another (e.g. Planner).

## Technical Debt
- **Unit Test Coverage**: Increase coverage for the new Drift DAOs.
- **Power Management**: Refine background perception cycles to strictly adhere to Android's "Power Save" modes.
- **State Management Refactoring**: Standardize on `StateNotifier` across all older feature modules.

## Architecture Recommendations
- **Edge-AI Separation**: Moving heavy perception logic into a separate isolate to prevent frame drops in the main UI thread.
- **WASM Integration**: Explore WebAssembly for high-performance mathematical reasoning models.
