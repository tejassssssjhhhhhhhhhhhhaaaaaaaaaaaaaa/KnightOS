# Knowledge Graph Specification: The Semantic Backbone of Knight

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Semantic Modeling & Causal Logic  
**Date:** 2026-07-27  

---

## 1. Introduction

### 1.1 Purpose
The Knowledge Graph (KG) is the connective tissue of the Knight Knowledge Base. While the 11 Books store information, the Knowledge Graph stores the **Relationships** and **Causality** between those pieces of information. It enables Knight to transition from a "Database of Facts" to an "Understanding of Life." This specification defines the entities, edges, and inference logic required to map the intricate web of cause-and-effect in a human existence.

### 1.2 The Goal of the Graph
The primary goal is to enable **Holistic Contextualization**. Every new fact or memory must be positioned within the graph to understand its downstream effects on other life domains. The KG prevents information silos and allows for predictive modeling (e.g., "If I change this habit, how does it affect my 5-year goal?").

---

## 2. Graph Elements

### 2.1 Entities (Nodes)
Entities are the fundamental units of the graph, corresponding to AMUs (Atomic Memory Units) from the Master Memory Specification.
*   **Domain Entities:** Facts belonging to one of the 11 Books (e.g., a specific Skill, a Health metric).
*   **Meta Entities:** Values, Beliefs, and Identity pillars that govern behavior.
*   **Event Entities:** Temporal nodes representing specific points in time.
*   **Target Entities:** Goals and Ambitions representing desired future states.

### 2.2 Attributes
Every Node contains:
*   **Internal State:** The raw data (Value, Date, Category).
*   **Metabolic Rate:** How fast the entity is expected to change.
*   **Gravity:** The relative importance of the node to the overall system (0.0 - 1.0).

### 2.3 Relationships (Edges)
Edges are the semantic links between nodes. Every edge MUST have:
*   **Type:** The semantic nature of the link (Influences, Causes, PartOf, Contradicts).
*   **Direction:** Uni-directional or Bi-directional.
*   **Strength (Weight):** The magnitude of the influence (0.0 to 1.0).
*   **Confidence:** The reliability of the relationship link itself.
*   **Latency:** The delay between a change in the Source and a change in the Target.

---

## 3. Core Influence Paths (The Life-Flow)

Knight understands the following primary causal chains:

### 3.1 The Identity-Action Chain
*   **Identity → Goals:** Core values and identity parameters provide the "Source Code" for all ambitions. A goal not rooted in Identity is flagged as "Low Alignment."
*   **Goals → Decisions:** Active goals serve as the primary filter for the Decision Engine. Decisions are weighed by their "Goal-Proximity" score.
*   **Decisions → Habits:** Repeated decisions crystallize into automated habits.

### 3.2 The Habit-Outcome Chain
*   **Habits → Health:** Physical and mental health are viewed as the cumulative output of habit nodes.
*   **Health → Productivity:** Health metrics (Sleep, Energy, Nutrition) directly modulate the "Execution Capacity" of the Skills and Career domains.
*   **Career → Finance:** Professional output and role seniority are the primary drivers of financial inflow.
*   **Finance → Lifestyle:** Available resources determine the environmental and preference "Settings" (Book IX).

### 3.3 The Mental Health Loop
*   **Relationships → Mental Health:** Social nodes (Book V) exert high-strength influence on mental vitality.
*   **Projects → Skills:** Active work projects are the primary "Training Data" that increases skill proficiency.
*   **Skills → Career:** Competency peaks in Book VII unlock new advancement opportunities in Book II.

---

## 4. Relationship Types

### 4.1 Direct Relationships
*   **Definition:** Source Node `A` explicitly modifies Target Node `B`.
*   **Example:** "Running 5km" (Habit) → "Reduced RHR" (Health).

### 4.2 Indirect (Transitive) Relationships
*   **Definition:** `A` influences `B`, which influences `C`.
*   **Logic:** `Influence(A, C) = Strength(A, B) * Strength(B, C)`.
*   **Example:** "Financial Education" (Skill) → "Better Investing" (Decision) → "Increased Net Worth" (Finance).

### 4.3 Bidirectional (Feedback Loops)
*   **Definition:** `A` and `B` influence each other.
*   **Example:** "Career Success" ↔ "Confidence/Identity."

### 4.4 Derived Relationships
*   **Definition:** A relationship inferred by the engine based on pattern recognition across multiple books.
*   **Rule:** Derived links start with low confidence (0.3) and increase as more data supports the correlation.

### 4.5 Temporal & Historical Relationships
*   **Definition:** Links between a current node and its past versions.
*   **Purpose:** Tracks evolution and "Self-Correction" history.

---

## 5. Graph Logic & Operations

### 5.1 Confidence Propagation
When a node's confidence changes, that change propagates through the graph.
*   **Attenuation Rule:** Confidence decreases as it travels across edges. 
*   **Formula:** `TargetConfidence = SourceConfidence * EdgeConfidence`.

### 5.2 Cascade-Update Rules
When a High-Gravity node is updated (e.g., a core Value changes):
1.  **Identify Sub-Graph:** Extract all nodes downstream of the changed node.
2.  **Trigger Review:** Mark all downstream Knowledge Book answers as "Stale/Needs Revision."
3.  **Recursive Update:** Knight's Knowledge Generation Engine is triggered to re-verify the affected answers.

### 5.3 Inference Rules
Knight uses the graph to fill "Unknowns":
*   **Similarity Inference:** If `A` is similar to `B`, and `B` has relationship `R` to `C`, Knight hypothesizes that `A` also has relationship `R` to `C`.
*   **Causal Inference:** If `A` consistently precedes `B`, Knight proposes a "CausedBy" edge for verification.

### 5.4 Graph Consistency Validation
*   **Conflict Detection:** If two nodes have a "Positive Influence" on a Target, but the Target is declining, Knight flags a "Logic Paradox."
*   **Orphan Detection:** Nodes with no incoming or outgoing edges are flagged for "Categorization Review." No fact is an island.

---

## 6. Graph Traversal Protocols

To answer complex questions, Knight performs specific traversals:

### 6.1 The "Why" Traversal (Reverse Path)
*   **Action:** Follow "InfluencedBy" or "CausedBy" edges back to Book I (Identity) or Book VI (Philosophy).
*   **Purpose:** To explain the deep reasoning behind a current state or recommendation.

### 6.2 The "What If" Traversal (Forward Path)
*   **Action:** Simulate a change in a node and follow "Influences" edges downstream.
*   **Purpose:** Predictive modeling of decisions.

---

## 7. Future Compatibility

### 7.1 Schema-Less Flexibility
The Graph is defined by its **Logic**, not its **Implementation**. It can be stored in a relational database (as an Adjacency List), a dedicated Graph Database, or even a collection of JSON-LD files.

### 7.2 Semantic Web Alignment
Edges should aim to use standardized semantic types (e.g., from schema.org or similar ontologies) where possible to ensure long-term data interoperability.

---

**End of Specification.**
