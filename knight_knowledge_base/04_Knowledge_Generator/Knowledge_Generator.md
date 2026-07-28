# Knowledge Generation Engine: The Synthesis Specification

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Reasoning Logic & Synthesis Architecture  
**Date:** 2026-07-27  

---

## 1. Introduction

### 1.1 Purpose
The Knowledge Generation Engine (KGE) is the cognitive heart of the Knight Knowledge Base. Its role is to transform raw, fragmented data and structured memory into cohesive, high-fidelity "Knowledge Books." This specification defines the logical workflows, reasoning protocols, and stylistic constraints that allow an intelligence to synthesize evidence into a narrative that perfectly reflects the owner’s existence.

### 1.2 System Independence
This engine is designed as a **Model-Agnostic Instruction Set**. It defines *how* to reason, not *which* tool to use for reasoning. It ensures that regardless of the underlying AI model, the resulting Knowledge Books remain consistent in tone, structure, and integrity.

---

## 2. Knowledge Generation Workflow

The transformation of data into a Knowledge Book follows a strict, sequential pipeline. No step may be bypassed.

### 2.1 The Pipeline (The Synthesis Loop)
1.  **Selection:** Identify the specific Book and Question from the **Question Bank** to be addressed.
2.  **Retrieval:** Fetch all relevant Atomic Memory Units (AMUs) from the **Master Memory** linked to the question’s Domain.
3.  **Evidence Assembly:** Gather all primary source artifacts (documents, logs, media) referenced by the memory units.
4.  **Blueprint Alignment:** Load the **Knight Blueprint** to retrieve communication constraints and the "Constitutional" persona.
5.  **Reasoning (The Core):** Apply the **Evidence Reasoning Protocol** to synthesize multi-source data.
6.  **Drafting:** Generate the answer according to the **Answer Generation Rules**.
7.  **Conflict Resolution:** If data is contradictory, apply the **Conflict Resolution Logic**.
8.  **Self-Review:** Pass the draft through the **Integrity Check** (Second-Pass Review).
9.  **Commitment:** Save the finalized answer into the appropriate Knowledge Book markdown file.

---

## 3. Answer Generation Rules

### 3.1 Writing Quality and Style
*   **Stoic Precision:** Answers must be devoid of conversational fillers. Every sentence must provide a new fact, context, or logical connection.
*   **The "Architecture of Truth":** Start with the most certain conclusion. Follow with supporting evidence. End with a statement of uncertainty or future research if applicable.
*   **Technical Depth:** The terminology must scale to the owner’s expertise in the relevant field (as defined in Book VII).

### 3.2 Simplicity vs. Complexity
*   **The "Executive Summary" Rule:** Every answer must be immediately actionable or understandable. 
*   **Detailed Appendices:** Use markdown tables or lists for raw data (e.g., specific dates/values) to keep the narrative flow clean while maintaining high information density.

### 3.3 Honesty and Uncertainty
*   **The Uncertainty Marker:** Every answer must explicitly state its confidence level. 
*   **Phrasing Uncertainty:** Use phrases like "Based on [Evidence X], it is highly probable that..." instead of "I think..." or "I believe..."

---

## 4. Unknown Handling

When the KGE encounters a lack of information, it must follow the **Void Protocol**.

1.  **Zero Invention (The Hallucination Guard):** Never "hallucinate" or guess. If no evidence exists, the KGE must explicitly state: "Information missing."
2.  **Confidence Estimation:** If partial evidence exists, the KGE must assign a low confidence score (e.g., 0.2) and explain the logical gap.
3.  **Future Evidence Request:** Every unknown must conclude with a specific request: "To resolve this, Knight requires access to [Document Type] or an explicit statement from the owner."
4.  **The Unknown Ledger:** All unresolved questions are automatically logged in **Book XI (The Unknown)**.

---

## 5. Evidence Reasoning Protocol

The KGE treats evidence as a multi-modal puzzle.

### 5.1 Evidence Hierarchy
1.  **Level 1 (Hard Data):** Financial transaction logs, GPS history, medical lab results, raw sensor data.
2.  **Level 2 (Documentation):** Employment contracts, scanned receipts, digital artifacts.
3.  **Level 3 (Owner Statements):** Journal entries, direct chat messages, verbal assertions.
4.  **Level 4 (External Inference):** Social media posts, calendar descriptions, third-party mentions.

### 5.2 Synthesis Logic (The Multi-Source Merge)
*   **Temporal Reconciliation:** If a calendar event says "Gym at 6 PM" but GPS data shows the owner at home, the KGE prioritizes the GPS data (Hard Data) while noting the "failed intent" in the answer.
*   **Semantic Merging:** Combine a medical record’s technical term (e.g., "Tachycardia") with the owner’s journal entry (e.g., "Heart was racing during the meeting") to create a comprehensive view of a health event.

---

## 6. Multi-Source Conflict Resolution

When Evidence A contradicts Evidence B, the KGE applies the **Resolution Matrix**:

| Scenario | Resolution Logic |
| :--- | :--- |
| **Hard Data vs. Opinion** | Prioritize Hard Data. Document the opinion as a "Subjective Perception Mismatch." |
| **Conflict within Hard Data** | Flag as a "Sensor Fault/Data Integrity Error." Do not synthesize until manual review. |
| **Recency Conflict** | Generally prioritize the most recent data point, unless it is a clear outlier. |
| **Magnitude of Conflict** | Small discrepancies (e.g., 10:00 vs 10:05) are averaged. Large discrepancies trigger a "Verification Request." |

---

## 7. Book Generation Workflow

### 7.1 Structure and Ordering
*   **Sequential Logic:** Books are generated in numerical order (I to XI), as Book I (Identity) provides the filters used to generate the others.
*   **Chaptering:** Each Book is divided into chapters based on the **Question Bank categories**.
*   **Cross-Referencing:** Every answer should contain markdown links to related answers in other books (e.g., A health event in Book III linking to a financial cost in Book IV).

### 7.2 Versioning and Updates
*   **Non-Destructive Updates:** When a Book is "regenerated," the old version is moved to the `history/` directory.
*   **The Delta Log:** Every update must include a "Synthesis Summary" explaining what was learned since the last version.

---

## 8. Writing Philosophy

*   **Human-Sounding but Professional:** The voice should be intelligent and calm. Avoid robotic phrasing like "Initiating synthesis," but avoid overly casual slang.
*   **Timelessness:** Write as if the record will be read 50 years from now. Use absolute dates (2026-07-27) rather than relative ones ("Yesterday").
*   **Consistency:** The same terminology and tone must persist across all 1,100 answers.

---

## 9. Self-Review Process (Second-Pass Integrity)

Before an answer is committed, the KGE must perform a **Reflection Step**:

1.  **Fact-Check:** "Does this answer contradict any entry in the Blueprint?"
2.  **Evidence-Check:** "Is every claim backed by a SourceLink?"
3.  **Clarity-Check:** "Is the conclusion clear to a human reader?"
4.  **Tone-Check:** "Is this stoic and objective, or has bias crept in?"

If any check fails, the answer is returned for **Recursive Re-reasoning**.

---

## 10. Regeneration Logic

*   **Atomic Regeneration:** A single question can be updated if new evidence arrives.
*   **Cascade Regeneration:** If a core Identity fact (Book I) changes, the KGE must re-evaluate all answers in the other 10 books that link to that fact.
*   **Global Build:** A periodic full-system rebuild is required to ensure the Knowledge Graph is fully optimized and all cross-references are valid.

---

## 11. Future Compatibility

### 11.1 Standard Formats
The output is strictly **Markdown** with **YAML Frontmatter**. This ensures that the Knowledge Books can be indexed by any future vector database, graph engine, or LLM context window.

### 11.2 Reasoning Transparency
By documenting the "Reasoning Steps" in a hidden markdown comment within each file, the KGE ensures that future intelligences can audit its logic and understand *how* it arrived at its conclusions.

---

**End of Specification.**
