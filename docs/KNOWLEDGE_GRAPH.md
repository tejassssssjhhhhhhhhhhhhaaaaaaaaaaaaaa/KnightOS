# KnightOS Knowledge Graph (The Weaver)

## Overview
The Knowledge Graph represents relationships between canonical memories, enabling Knight to reason across domains.

## Confidence Levels
| Level | Weight | Trigger |
| :--- | :--- | :--- |
| **Observed** | 0.9 | Direct import from trusted API. |
| **Inferred** | 0.4 - 0.9 | Knight's reasoning based on patterns. |
| **User Confirmed** | 1.0 | Manual verification via UI. |
| **Deprecated** | 0.0 | Superceded by new information. |

## The Weaver Process
1. **Ingestion**: Raw data enters via connectors.
2. **Extraction**: Entities and facts are identified.
3. **Linking**: Facts are linked to existing nodes in the graph.
4. **Reasoning**: Knight identifies gaps or inconsistencies (e.g., "Salary changed").
5. **Verification**: Socratic mission triggered for user confirmation.

## Promotion Rules
- **Evidence Threshold**: High-confidence inferences are automatically promoted if multiple sources agree.
- **Socratic Interaction**: Users are asked simple questions to confirm ambiguous links.
