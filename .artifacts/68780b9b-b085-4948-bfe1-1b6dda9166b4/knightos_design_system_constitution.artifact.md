# KnightOS Design System Constitution

**Status:** PERMANENT GOVERNANCE DOCUMENT
**Owner:** CTO / Lead Designer

## 1. Design Philosophy: "Cognitive Calm"
KnightOS is designed to reduce the mental load of managing a life. The interface should feel premium, elegant, and intentional.

## 2. Typography
*   **Primary Typeface:** Inter (Modern, Clean, Highly Legible).
*   **Display Typeface:** Montserrat (For headers and premium milestones).
*   **Scale:** 8-step typographic scale to ensure hierarchy and consistency.

## 3. Spacing & Layout
*   **8dp Grid:** All components, margins, and padding must align to an 8dp (or 4dp for fine details) grid.
*   **Adaptive Layout:** All screens must be designed for Phone, Tablet, and Desktop from the start.

## 4. Color & Mood
*   **The "Knight Suite" Palette:**
    *   **Knight Blue (#0A192F):** Depth, trust, and focus.
    *   **Evidence Emerald (#10B981):** Growth and verified truth.
    *   **Calm White (#F8FAFC):** Cleanliness and space.
*   **Dark Mode:** Mandatory. Not a second-class citizen.

## 5. Component Standards
*   **Cards:** Minimalistic containers with subtle shadows. No "borders for the sake of borders."
*   **Charts:** High-density, interactive visualizations. Prefer "Trend Lines" and "Distribution Maps" over simple bar charts.
*   **Navigation:** A unified "Command Bar" or "Global Rail" across all modules.

## 6. Motion & Animation
*   **Functional Motion:** Every animation must serve a purpose (e.g., showing a relationship, confirming an action).
*   **Subtle Physics:** Use natural easing (Ease-in-out). Avoid "bouncy" or distracting animations.
*   **Performance:** All animations must target 60fps (120fps where hardware supports).

## 7. Accessibility
*   **Contrast:** Minimum WCAG AA compliance for all text and interactive elements.
*   **Touch Targets:** Minimum 48x48dp for all interactive components.
*   **Screen Readers:** Semantic labeling is required for every UI component.

## 8. Interaction Principles
*   **Progressive Disclosure:** Show only what is needed. Hide complexity until requested.
*   **Predictive Loading:** Use shimmer effects and skeleton screens. Never show a "frozen" UI.
*   **Haptic Feedback:** Purposeful haptics for "Verification" and "Mission Completion."

## 9. Empty States & Error Handling
*   **Empathetic Errors:** Explain what happened and how to fix it. No "Error 404" or "Unexpected Exception."
*   **Actionable Empty States:** Every empty screen should guide the user toward their first action.
