# Validation Rules: The Integrity Framework

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Data Integrity & Quality Assurance  
**Date:** 2026-07-27  

---

## 1. Structural Integrity

### 1.1 Mandatory Fields
Every Atomic Memory Unit (AMU) MUST satisfy the `amu_metadata.schema.json`.
- `memoryId`: Primary logical key.
- `versionId`: Temporal key.
- `isLatest`: Boolean flag.
- `confidence`: Range [0.0, 1.0].
- `effectiveAt`: ISO 8601.

### 1.2 Referential Integrity
- **Graph Linkage:** Every `MemoryID` referenced in a Knowledge Graph Edge must exist in the Master Memory storage.
- **Evidence Linkage:** Every `sourceLink` (knight://evidence/[CAID]) must point to an artifact that passes SHA-256 verification.
- **Version Continuity:** If `previousVersionId` is present, that specific version must exist in the `History` directory.

---

## 2. Knowledge Graph Validation

### 2.1 Causal Loop Detection
The Semantic Engine must run a **Cycle Check** before committing new edges.
- *Rule:* Relationships of type `causes` or `precedes` cannot form a directed cycle.
- *Exception:* `influences` can be circular (feedback loops), but must be tagged as `feedback_loop: true`.

### 2.2 Orphan Detection
- **Definition:** A node with zero edges in the Knowledge Graph.
- **Action:** Orphans are flagged for "Categorization Review" and cannot be used in a "Why" Traversal until linked.

### 2.3 Paradox Handling
A paradox is detected when:
1.  Source A (High Confidence) supports Fact X.
2.  Source B (High Confidence) supports Fact Y.
3.  Fact X and Fact Y are semantically exclusive (e.g., location mismatch).
- **Rule:** Both facts are stored as `branching_memory`, and the `integrityScore` of the affected Book is reduced by 0.1 per paradox.

---

## 3. Duplicate Detection

### 3.1 Content-Based Deduplication
Before creating a new AMU:
1.  Calculate a hash of the `content` object.
2.  Search for an existing AMU with the same `memoryId` and `content_hash`.
3.  If found, merge the `provenance` and update `recordedAt`, but do not increment `VersionID`.

### 3.2 Fuzzy Deduplication
If two AMUs have high semantic similarity (>0.9) but different hashes:
1.  Flag for the **Conflict Resolution Prompt**.
2.  Do not merge automatically.

---

## 4. Confidence & Propagation Rules

### 4.1 Base Confidence
- **Direct Input:** 1.0
- **Primary Source (PDF/API):** 0.95
- **Secondary Source (Photo):** 0.8
- **Inference:** 0.5 (initial)

### 4.2 Attenuation
When a fact is derived through the Knowledge Graph:
- `Confidence(Target) = Confidence(Source) * Strength(Edge)`.
- If confidence drops below 0.3, the fact is marked as a `hypothesis` and moved to **Book XI**.

---

## 5. Book Consistency Validation

### 5.1 Integrity Score
Every Book has a score calculated as:
`Integrity = (Validated_Questions / Total_Questions) * (Average_Confidence) * (1 - (Active_Paradoxes / 10))`.

### 5.2 Cross-Reference Integrity
- A link in Book A to Book B must point to a valid `QuestionID`.
- If Question B is updated, Book A's corresponding section is marked as `needs_review: true`.

---

## 6. Schema Migration

### 6.1 Version Compatibility
When a schema updates from `v1.0` to `v1.1`:
- All existing AMUs must be validated against the new schema.
- If validation fails, a `transformation_script` must be applied to the `History`.
- If no script exists, the AMUs are marked as `legacy_format` and excluded from current synthesis.

---

**End of Specification.**
