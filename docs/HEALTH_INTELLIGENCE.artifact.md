# Health Intelligence Explainability Layer

## Architecture
The Health Intelligence module provides an **Explainability Layer** that transforms raw biometric data into human-readable scores with full logical provenance. This is achieved through the `ReasoningTrace` and `Evidence` models, which are now integrated into every scoring cycle.

### Data Flow
1. **Perception**: External sensors (Galaxy Watch, Health Connect) or manual inputs provide raw metrics.
2. **Scoring Cycle**: The `HealthEngine` processes these metrics using domain-specific heuristics (Sleep, Hydration, Stress, etc.).
3. **Reasoning Synthesis**: For every score, a `ReasoningTrace` is generated, capturing:
    - Raw evidence used (with source trust weights).
    - Thought chain (logical steps taken).
    - Confidence score (weighted based on source reliability and freshness).
    - Actionable recommendations.
4. **Knowledge Graph Integration**: Scores and relationships (e.g., "Sleep influences Recovery") are persisted in the knowledge graph.
5. **Context Propagation**: The `KnightContext` hydrates with the `HealthScores` snapshot, making it available to the UI and the proactive agent.

## Confidence Model
KnightOS uses a multi-factor confidence weighting system:
- **Galaxy Watch**: 0.95 (High reliability sensor)
- **Manual Input**: 1.0 (Direct user observation)
- **Samsung Health**: 0.9 (Aggregated platform data)
- **Health Connect**: 0.85 (Cross-platform bridge)
- **AI Inference**: 0.7 (Reasoned guess)

Confidence is also adjusted based on **Freshness** (temporal decay).

## Verification Workflow
When confidence in a critical metric (Sleep, Stress, Hydration) falls below the **0.6 threshold**, the system automatically:
1. Logs a `LOW CONFIDENCE` warning.
2. Triggers a `VerificationMission` via the `VerificationEngine`.
3. Knight Orb presents a Socratic bubble to the user to confirm or correct the inference.

## Knowledge Graph Update
The `HealthEngine` maintains a dynamic map of health dependencies:
- **Sleep** --[influences]--> **Recovery**
- **Recovery** --[composes]--> **Readiness**
- **Workout** --[depletes]--> **Recovery**
- **Hydration** --[mitigates]--> **Stress**

## Testing Strategy
- **Unit Tests**: `test/intelligence/health_explainability_test.dart` validates:
    - Reasoning generation accuracy.
    - Confidence weighting math.
    - Graph link integrity.
- **Analysis**: Clean `flutter analyze` for the `lib/core/intelligence/engines/health/` domain.
