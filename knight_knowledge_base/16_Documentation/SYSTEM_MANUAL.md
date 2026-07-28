# Knight Knowledge Base: System Manual

## 1. Core Operating Logic
The KKB operates on a **Synthesize-on-Demand** or **Synthesize-on-Trigger** basis.
- **Ingestion:** Raw data is turned into AMUs (Atomic Memory Units).
- **Orchestration:** AMUs are linked via the Knowledge Graph.
- **Synthesis:** The Knowledge Generator writes or updates the 11 Books based on the Question Bank.

## 2. Managing the 11 Books
The Books are stored in the `books/` directory (created at runtime).
- **Book I-X:** Factual and interpretive narrative of the owner's life.
- **Book XI:** The "Uncertainty Buffer" where missing or contradictory info is resolved.

## 3. Evidence Handling
All evidence is stored in the `evidence/` vault.
- **Rule:** Never reference a fact without a CAID (Content-Addressable Identifier).
- **Rule:** If evidence is deleted, all dependent AMUs must have their confidence scores set to 0.1 (Inference/Assumption).

## 4. Troubleshooting the Graph
- **Paradoxes:** Occur when evidence from different books conflicts.
- **Resolution:** Use the `conflict_resolution.prompt.md` to navigate logic errors.
- **Orphans:** Facts with no relationships. Use the `categorization.prompt.md` to re-integrate them.

## 5. Security Protocols
- **Local-First:** The KKB is designed to be stored locally.
- **Encryption:** All evidence and Master Memory files should be encrypted at rest using the owner's master key.

---
