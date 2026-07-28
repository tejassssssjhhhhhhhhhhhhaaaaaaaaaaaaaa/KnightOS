# Master Memory Specification: The Universal Life Ontology

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Information Architecture & Ontology  
**Date:** 2026-07-27  

---

## 1. Introduction

### 1.1 Purpose
The Master Memory Specification defines the universal structure of everything Knight can know about a human being. It is the "Data Blueprint" that complements the "Operational Blueprint." This document provides a exhaustive, high-fidelity ontology that maps the complex, multi-dimensional reality of a human life into a format that can be stored, reasoned over, and evolved by an artificial intelligence.

### 1.2 The Concept of "Life-Fidelity"
Knight's memory system is designed for **Life-Fidelity**. This means the memory is not just a collection of strings and numbers, but a rich web of versioned facts, evidence, and relationships. Every entry in the Master Memory must be an **Atomic Memory Unit (AMU)** that conforms to the rules defined in this specification.

---

## 2. Universal Memory Schema (Conceptual)

Before defining specific categories, every memory in this ontology shares a common metadata substrate:

*   **MemoryID:** Unique identifier for the logical fact.
*   **VersionID:** Unique identifier for the specific iteration of that fact.
*   **Timestamp (Effective):** When the fact became true.
*   **Timestamp (Recorded):** When Knight learned it.
*   **Confidence:** (0.0 - 1.0).
*   **SourceType:** (Direct_Input, Sensor, Inference, Third_Party).
*   **SourceLink:** Pointer to the raw evidence in the `Evidence/` framework.
*   **Tags:** Semantic markers for cross-category retrieval.

---

## 3. Domain Catalog

### 1. Identity
*   **Purpose:** To define the core uniqueness of the individual.
*   **Why it Matters:** Without a stable identity core, Knight cannot distinguish between "Who the owner is" and "What the owner does."
*   **Memory Granularity:** Atomic attributes (Legal Name, DNA sequence, Blood Type, Fingerprint hashes, SSN, Digital Identifiers).
*   **Update Rules:** Immutable for biological markers; strictly controlled versioning for legal/digital identifiers.
*   **Confidence Rules:** Requires 1.0 (Government docs or Lab results).
*   **Evidence Hierarchy:** Birth certificates, Passports, DNA reports.
*   **Relationships:** Links to `Biography` (History of name changes) and `Health` (Biological markers).
*   **Versioning Strategy:** Linear history of "Current State."
*   **Expiration Rules:** None.

### 2. Biography
*   **Purpose:** To track the chronological narrative of the owner's life.
*   **Why it Matters:** Contextualizes current behavior within past experiences.
*   **Memory Granularity:** Epochs (Childhood, University, Career phases) and Milestones (Marriage, First job).
*   **Update Rules:** Append-only. Corrections allowed but original version must be preserved.
*   **Confidence Rules:** 0.8+ for owner's recall; 1.0 for third-party records.
*   **Evidence Hierarchy:** School records, employment contracts, journals.
*   **Relationships:** Links to `Education`, `Career`, `Memories`.
*   **Versioning Strategy:** Cumulative narrative.
*   **Expiration Rules:** None.

### 3. Family
*   **Purpose:** To map the biological and legal foundation of the owner's social world.
*   **Why it Matters:** Determines genetic health risks and deep-seated psychological patterns.
*   **Memory Granularity:** Individual person nodes with defined relation types (Parent, Sibling, Ancestor).
*   **Update Rules:** Updated on birth, death, or marriage events.
*   **Confidence Rules:** 0.9 (Family records, DNA testing).
*   **Evidence Hierarchy:** Family trees, census data, personal accounts.
*   **Relationships:** Links to `Health` (Genetic lineage) and `Relationships` (Social dynamics).
*   **Versioning Strategy:** Graph-based versioning (Snapshot of the tree).
*   **Expiration Rules:** None.

### 4. Relationships
*   **Purpose:** To track the current social network and emotional connections.
*   **Why it Matters:** Social health is a primary indicator of well-being.
*   **Memory Granularity:** Dynamic "Connection Strength" scores, interaction logs, and roles (Mentor, Friend, Rival).
*   **Update Rules:** Real-time update based on interactions; periodic "Strength Decay" calculation.
*   **Confidence Rules:** 0.7 (Inferred from frequency/tone) to 1.0 (Explicit owner statement).
*   **Evidence Hierarchy:** Communication logs, calendar events, direct owner feedback.
*   **Relationships:** Links to `Career` (Professional network) and `Social` (Events).
*   **Versioning Strategy:** Sliding window of relationship health.
*   **Expiration Rules:** Relationships with zero interaction for >10 years moved to `Archives`.

### 5. Education
*   **Purpose:** To catalog formal and informal learning paths.
*   **Why it Matters:** Defines the owner's foundational mental frameworks.
*   **Memory Granularity:** Course-level data, grades, thesis topics, self-study modules.
*   **Update Rules:** Updated upon completion of milestones or courses.
*   **Confidence Rules:** 1.0 (Transcripts, Certificates).
*   **Evidence Hierarchy:** Diplomas, Transcripts, Course syllabi.
*   **Relationships:** Links to `Skills` and `Knowledge`.
*   **Versioning Strategy:** Cumulative achievement log.
*   **Expiration Rules:** None.

### 6. Career
*   **Purpose:** To track professional evolution and economic output.
*   **Why it Matters:** The primary source of "Impact" in Knight's mission.
*   **Memory Granularity:** Role, Responsibility, Performance review metrics, Salary history.
*   **Update Rules:** Updated on role changes, promotions, or project completions.
*   **Confidence Rules:** 1.0 (Pay stubs, Contracts).
*   **Evidence Hierarchy:** LinkedIn, CV, Employment contracts, Performance reviews.
*   **Relationships:** Links to `Finance`, `Skills`, `Projects`.
*   **Versioning Strategy:** Career timeline.
*   **Expiration Rules:** None.

### 7. Skills
*   **Purpose:** To track specific capabilities and proficiencies.
*   **Why it Matters:** Determines what Knight can ask the owner to do or what Knight should do for them.
*   **Memory Granularity:** Skill-level (Beginner to Expert), Last-used timestamp, Certification status.
*   **Update Rules:** Decay over time if unused; increase upon successful project completion.
*   **Confidence Rules:** 0.6 (Self-assessment) to 1.0 (External certification).
*   **Evidence Hierarchy:** GitHub repos, portfolio items, certifications, test results.
*   **Relationships:** Links to `Career`, `Education`, `Projects`.
*   **Versioning Strategy:** Competency matrix evolution.
*   **Expiration Rules:** Skills unused for >5 years marked as "Atrophied."

### 8. Health
*   **Purpose:** To maintain a high-resolution state-of-the-body.
*   **Why it Matters:** The biological foundation for all other life domains.
*   **Memory Granularity:** Micro (Blood glucose, Heart rate) to Macro (Diagnoses, Surgeries, Vitals).
*   **Update Rules:** Real-time for sensor data; periodic for medical checkups.
*   **Confidence Rules:** 1.0 (Lab results, Clinical diagnosis).
*   **Evidence Hierarchy:** Lab reports, MRI scans, Wearable data.
*   **Relationships:** Links to `Family` (Genetics) and `Habits` (Impact of behavior on health).
*   **Versioning Strategy:** Time-series for metrics; state-machine for conditions.
*   **Expiration Rules:** Sensor data older than 2 years may be down-sampled for trends.

### 9. Mental Models
*   **Purpose:** To catalog the thinking tools the owner uses to process reality.
*   **Why it Matters:** Allows Knight to communicate in the owner's language of logic (e.g., First Principles, Inversion).
*   **Memory Granularity:** Model name, Definition, Context of use, Successful applications.
*   **Update Rules:** Added when learned; updated when applied.
*   **Confidence Rules:** 0.8 (Consistent usage in decision history).
*   **Evidence Hierarchy:** Journal entries, decision logs, book highlights.
*   **Relationships:** Links to `Education`, `Decision History`, `Knowledge`.
*   **Versioning Strategy:** Maturity level of the model.
*   **Expiration Rules:** None.

### 10. Personality
*   **Purpose:** To define the psychological profile and behavioral tendencies.
*   **Why it Matters:** Used to tune Knight's communication and coaching style.
*   **Memory Granularity:** Trait scores (Big Five, MBTI, Enneagram - as metaphors or data), Temperament, Social battery levels.
*   **Update Rules:** Updated through psychological assessment or long-term behavioral analysis.
*   **Confidence Rules:** 0.7 (Observed behavior) to 0.9 (Standardized tests).
*   **Evidence Hierarchy:** Assessment results, behavioral logs, peer feedback.
*   **Relationships:** Links to `Identity`, `Relationships`, `Values`.
*   **Versioning Strategy:** Psychometric snapshots over time.
*   **Expiration Rules:** Re-assess every 5 years to track "Maturation."

### 11. Habits
*   **Purpose:** To track recurring automated behaviors (Positive and Negative).
*   **Why it Matters:** Habits are the "code" of a human life. Changing them is the fastest way to change outcomes.
*   **Memory Granularity:** Frequency, Trigger, Action, Reward, Streak, Strength (0.0 - 1.0).
*   **Update Rules:** Daily updates based on behavior logs.
*   **Confidence Rules:** 0.9 (Sensor data/Direct log).
*   **Evidence Hierarchy:** App logs, check-ins, physical sensor data (e.g., smart toothbrush, gym entry).
*   **Relationships:** Links to `Health`, `Routine`, `Goals`.
*   **Versioning Strategy:** Habit strength timeline.
*   **Expiration Rules:** Habits not logged for 90 days are marked as "Extinct."

### 12. Daily Routine
*   **Purpose:** To map the typical structure of the owner's day.
*   **Why it Matters:** Allows Knight to predict availability and optimal times for different types of work/rest.
*   **Memory Granularity:** Time-blocks (Morning, Work, Evening) and activities (Wake up, Meal times, Deep work).
*   **Update Rules:** Updated when the owner's schedule shifts significantly.
*   **Confidence Rules:** 0.8 (Consistent patterns in logs).
*   **Evidence Hierarchy:** Calendar data, phone usage logs, location history.
*   **Relationships:** Links to `Habits`, `Projects`, `Focus`.
*   **Versioning Strategy:** Seasonal or lifestyle-based snapshots (e.g., "Summer 2026 Routine").
*   **Expiration Rules:** Older routines archived as `History`.

### 13. Finance
*   **Purpose:** To track the flow and accumulation of material value.
*   **Why it Matters:** Provides the constraints and opportunities for all life-decisions.
*   **Memory Granularity:** Income, Expenses, Taxes, Savings Rate, Cash Flow.
*   **Update Rules:** Monthly reconciliation; real-time for significant transactions.
*   **Confidence Rules:** 1.0 (Bank statements, Tax filings).
*   **Evidence Hierarchy:** Bank APIs, PDFs, receipts, tax returns.
*   **Relationships:** Links to `Assets`, `Career`, `Goals`.
*   **Versioning Strategy:** Monthly financial snapshots.
*   **Expiration Rules:** Records >7 years moved to deep archive.

### 14. Assets
*   **Purpose:** To catalog everything the owner owns (Physical, Digital, Intellectual).
*   **Why it Matters:** Represents stored value and tools for work/life.
*   **Memory Granularity:** Description, Value, Location, Maintenance status, Ownership percentage.
*   **Update Rules:** Updated on purchase, sale, or significant value change.
*   **Confidence Rules:** 1.0 (Title deeds, receipts).
*   **Evidence Hierarchy:** Purchase receipts, ownership docs, photos of assets.
*   **Relationships:** Links to `Finance`, `Devices`, `Projects`.
*   **Versioning Strategy:** Inventory history.
*   **Expiration Rules:** Deleted upon disposal; kept in `History` as "Sold/Discarded."

### 15. Devices
*   **Purpose:** To map the hardware tools the owner uses.
*   **Why it Matters:** Knight's "eyes and ears." Understanding the device capabilities helps in deploying Knight's functions.
*   **Memory Granularity:** Model, Serial, Specs, Security status, Battery health, Integration level.
*   **Update Rules:** Updated on hardware acquisition or firmware updates.
*   **Confidence Rules:** 1.0 (System info query).
*   **Evidence Hierarchy:** Hardware metadata, purchase receipts.
*   **Relationships:** Links to `Assets`, `Projects`, `Security`.
*   **Versioning Strategy:** Device lifecycle tracking.
*   **Expiration Rules:** Archived when no longer in use.

### 16. Preferences
*   **Purpose:** To document the "Settings" of the owner's life.
*   **Why it Matters:** Eliminates friction and cognitive load for the owner.
*   **Memory Granularity:** Domain (Food, Environment, UI), Item (Coffee temp, Font size), Value.
*   **Update Rules:** Updated through explicit statement or inferred from "Undo" actions.
*   **Confidence Rules:** 0.9 (Direct input).
*   **Evidence Hierarchy:** App settings, direct feedback, behavioral observation.
*   **Relationships:** Links to `Routine`, `Assets`, `Knowledge`.
*   **Versioning Strategy:** Current state with change history.
*   **Expiration Rules:** Preferences not exercised for 2 years are marked for "Re-verification."

### 17. Entertainment
*   **Purpose:** To track the consumption of leisure and art.
*   **Why it Matters:** Reflects tastes, influences, and relaxation patterns.
*   **Memory Granularity:** Media type (Book, Movie, Game), Title, Rating, Impact, Status (Finished/Paused).
*   **Update Rules:** Real-time logging of consumption.
*   **Confidence Rules:** 1.0 (Integration with Spotify/Steam/Kindle).
*   **Evidence Hierarchy:** API logs, watch history, highlights.
*   **Relationships:** Links to `Preferences`, `Knowledge`, `Routine`.
*   **Versioning Strategy:** Consumption log.
*   **Expiration Rules:** None.

### 18. Travel
*   **Purpose:** To document movement and geographical experiences.
*   **Why it Matters:** Travel is a major source of growth and memory formation.
*   **Memory Granularity:** Trip name, Destination, Purpose, Dates, Key experiences, People met.
*   **Update Rules:** Updated at the end of every trip.
*   **Confidence Rules:** 1.0 (GPS logs, Booking receipts).
*   **Evidence Hierarchy:** Itineraries, Photos, Location history, Receipts.
*   **Relationships:** Links to `Finance`, `Relationships`, `Memories`.
*   **Versioning Strategy:** Chronological travelogue.
*   **Expiration Rules:** None.

### 19. Projects
*   **Purpose:** To track focused, goal-oriented work.
*   **Why it Matters:** The unit of "Doing." Projects are where skills are applied and results generated.
*   **Memory Granularity:** Title, Objective, Status, Progress, Milestones, Resources, Time spent.
*   **Update Rules:** Weekly status updates or real-time progress via task-managers.
*   **Confidence Rules:** 0.9 (Documented progress).
*   **Evidence Hierarchy:** Project plans, git commits, task lists, artifacts.
*   **Relationships:** Links to `Career`, `Skills`, `Goals`, `Assets`.
*   **Versioning Strategy:** Project lifecycle states.
*   **Expiration Rules:** Completed projects archived in `Achievements`.

### 20. Goals
*   **Purpose:** To track the intended future state of the owner.
*   **Why it Matters:** The "Target" for Knight's proactive alignment.
*   **Memory Granularity:** Short-term (<1y), Medium (1-5y), Long (>5y), Moonshot. Metric of success.
*   **Update Rules:** Reviewed quarterly; updated when achieved or abandoned.
*   **Confidence Rules:** 1.0 (Explicit owner intent).
*   **Evidence Hierarchy:** Goal statements, vision boards, planning docs.
*   **Relationships:** Links to `Values`, `Projects`, `Finance`, `Ambition`.
*   **Versioning Strategy:** Successive goal sets.
*   **Expiration Rules:** Abandoned goals moved to `Lessons Learned`.

### 21. Values
*   **Purpose:** To define the moral and ethical foundation of the owner.
*   **Why it Matters:** The highest-level constraint for all decision-making. Values are the "Why."
*   **Memory Granularity:** Value name, Definition, Priority rank, Behavioral evidence of this value.
*   **Update Rules:** Updated through deep reflection (Book VI) or when values are tested by hard decisions.
*   **Confidence Rules:** 0.8 (Explicitly stated) to 0.9 (Consistent behavioral alignment).
*   **Evidence Hierarchy:** Value statements, ethical dilemma logs, reflection journals.
*   **Relationships:** Links to `Identity`, `Philosophy`, `Goals`.
*   **Versioning Strategy:** Value evolution over life stages.
*   **Expiration Rules:** None.

### 22. Beliefs
*   **Purpose:** To catalog what the owner assumes to be true about the world.
*   **Why it Matters:** Beliefs filter reality. Understanding them helps Knight identify biases and cognitive blindspots.
*   **Memory Granularity:** Proposition, Confidence level (Probability), Supporting evidence, Conflicting evidence.
*   **Update Rules:** Updated when belief is challenged or reaffirmed.
*   **Confidence Rules:** Subjective probability assigned by the owner.
*   **Evidence Hierarchy:** Anecdotal experiences, books read, owner statements.
*   **Relationships:** Links to `Philosophy`, `Mental Models`, `Knowledge`.
*   **Versioning Strategy:** Belief network state-changes.
*   **Expiration Rules:** None.

### 23. Decision History
*   **Purpose:** To track the "Log of Choices."
*   **Why it Matters:** Allows Knight to perform "Post-Mortems" on decisions and improve future advice.
*   **Memory Granularity:** The Problem, Context, Options considered, Chosen option, Reasoning, Predicted outcome, Actual outcome.
*   **Update Rules:** Logged at the time of decision; updated when outcome is known.
*   **Confidence Rules:** 1.0 (Direct log of reasoning).
*   **Evidence Hierarchy:** Decision journals, emails, meeting minutes.
*   **Relationships:** Links to `Mental Models`, `Career`, `Finance`, `Goals`.
*   **Versioning Strategy:** Immutable log entries.
*   **Expiration Rules:** None.

### 24. Achievements
*   **Purpose:** To record the peaks of the owner's life.
*   **Why it Matters:** Boosts motivation and provides evidence of competence for `Confidence` scoring.
*   **Memory Granularity:** Title, Date, Category, Magnitude of impact, Evidence of success.
*   **Update Rules:** Added upon completion of major milestones.
*   **Confidence Rules:** 1.0 (Public record or tangible result).
*   **Evidence Hierarchy:** Awards, certificates, bank deposits, finished products.
*   **Relationships:** Links to `Career`, `Goals`, `Projects`, `Biography`.
*   **Versioning Strategy:** Cumulative list.
*   **Expiration Rules:** None.

### 25. Failures
*   **Purpose:** To record when things didn't go as planned.
*   **Why it Matters:** Failures are the most dense sources of information in a human life.
*   **Memory Granularity:** The Incident, Expected vs. Actual, Root Cause analysis, Cost (Time, Money, Social).
*   **Update Rules:** Logged during reflection phases.
*   **Confidence Rules:** 0.8 (Interpretive) to 1.0 (Financial/Project loss).
*   **Evidence Hierarchy:** Project post-mortems, rejection letters, loss statements.
*   **Relationships:** Links to `Lessons Learned`, `Decision History`, `Projects`.
*   **Versioning Strategy:** Immutable log.
*   **Expiration Rules:** None.

### 26. Lessons Learned
*   **Purpose:** To extract wisdom from history.
*   **Why it Matters:** Prevents the owner from making the same mistake twice.
*   **Memory Granularity:** The Lesson (Aphorism), The Source Event, Context of applicability, Verification status.
*   **Update Rules:** Added when a realization is confirmed by experience.
*   **Confidence Rules:** 0.7 (Intuition) to 1.0 (Scientifically or practically proven).
*   **Evidence Hierarchy:** Journals, books, verified outcomes.
*   **Relationships:** Links to `Failures`, `Achievements`, `Mental Models`.
*   **Versioning Strategy:** Refinement of the lesson text.
*   **Expiration Rules:** None.

### 27. Memories
*   **Purpose:** To track high-impact episodic memories (The "Highlights").
*   **Why it Matters:** These define the owner's personal narrative and emotional landscape.
*   **Memory Granularity:** Description, Key players, Sensory details, Emotional valence, Narrative meaning.
*   **Update Rules:** Added via journaling or photo analysis.
*   **Confidence Rules:** 0.5 - 0.9 (Subject to human memory distortion).
*   **Evidence Hierarchy:** Photos, Videos, Journals, Witness statements.
*   **Relationships:** Links to `Biography`, `History`, `Travel`.
*   **Versioning Strategy:** Narrative revision history.
*   **Expiration Rules:** None.

### 28. Documents
*   **Purpose:** To index the external storage of the owner's life.
*   **Why it Matters:** Provides the raw "Proof" for Knight's inferences.
*   **Memory Granularity:** File name, Type, Metadata (OCR text, hash), Storage location, Security level.
*   **Update Rules:** Real-time on file creation/ingestion.
*   **Confidence Rules:** 1.0 (Digital artifact).
*   **Evidence Hierarchy:** The file itself.
*   **Relationships:** Links to all other domains as `Evidence`.
*   **Versioning Strategy:** File versioning (if available).
*   **Expiration Rules:** Retention policies based on legal or practical needs.

### 29. Knowledge
*   **Purpose:** To catalog the owner's intellectual database.
*   **Why it Matters:** What the owner *knows* determines what they can *create*.
*   **Memory Granularity:** Concept, Source, Summary, Relationship to other concepts.
*   **Update Rules:** Updated when the owner reads, watches, or discusses new ideas.
*   **Confidence Rules:** 0.7 (Familiar) to 1.0 (Mastered).
*   **Evidence Hierarchy:** Book highlights, course notes, writing.
*   **Relationships:** Links to `Skills`, `Mental Models`, `Education`.
*   **Versioning Strategy:** Intellectual growth tracking.
*   **Expiration Rules:** None.

### 30. Unknowns
*   **Purpose:** To track the gaps in the "Map."
*   **Why it Matters:** Directs the future efforts of the owner and Knight.
*   **Memory Granularity:** Question, Why it's unknown, Impact of not knowing, Strategy for discovery.
*   **Update Rules:** Updated whenever a gap is identified in another category.
*   **Confidence Rules:** 0.0 (The definition of an unknown).
*   **Evidence Hierarchy:** None (The absence of evidence).
*   **Relationships:** Links to all other domains (e.g., "Unknown genetic risk in Health").
*   **Versioning Strategy:** Evolution of the question.
*   **Expiration Rules:** Resolved unknowns are moved to `Knowledge`.

---

## 4. Cross-Domain Integrity Rules

1.  **Causality Requirement:** Any memory in `Achievements` or `Failures` must have a corresponding link in `Decision History`.
2.  **Health-Habit Loop:** Any significant change in `Health` (±20%) must trigger an analysis of `Habits` and `Routine`.
3.  **Finance-Goal Constraint:** Any `Goal` with a cost >10% of liquid `Finance` must include a "Financial Feasibility Study."
4.  **Skills-Project Mapping:** No new `Skill` is marked as "Mastered" without at least one completed `Project` evidence.

---

## 5. Conclusion

The Master Memory is the structural foundation of the Knight project. By adhering to this ontology, we ensure that Knight's memory is not just a database, but a living, breathing model of a human existence. This specification provides the necessary constraints for the generation of all future JSON schemas and data-collection prompts.

**End of Specification.**


