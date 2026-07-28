# Question Bank: The Knowledge Acquisition Framework

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Information Architecture & Inquiry Logic  
**Date:** 2026-07-27  

---

## 1. Introduction
The Question Bank is the "Active Intelligence" of the Knight Knowledge Base. It contains 1,100 structured inquiries designed to extract a high-fidelity model of a human existence. These questions are categorized into 11 Books, each representing a core dimension of life.

### Metadata Schema
Every question follows this metadata structure:
- **ID:** Unique identifier (B[Book]-Q[Number]).
- **Question:** The specific inquiry.
- **Purpose:** Why this knowledge is critical for Knight.
- **Type:** (String, List, Boolean, Date, JSON, Map).
- **Domain:** Related memory domains from the Master Memory Specification.
- **Priority:** (Critical, High, Medium, Low).
- **Update:** (Never, Rarely, Sometimes, Frequently).
- **Dynamic:** Whether the answer changes over time.

---

## Book I: Identity (The Soul)
*Focus: The immutable and foundational core of the individual.*

### Category: Legal & Biological (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B01-Q001 | What is your full legal name as it appears on official documents? | Essential for legal and administrative tasks. | String | Critical | Rarely | No |
| B01-Q002 | What is your date of birth? | Foundations for age-related calculations and health risk assessment. | Date | Critical | Never | No |
| B01-Q003 | Where were you born (City, State, Country)? | Establishes nationality and early environmental context. | String | High | Never | No |
| B01-Q004 | What is your biological sex? | Critical for medical and health optimization. | Enum | Critical | Never | No |
| B01-Q005 | What is your blood type? | Life-saving information for emergencies. | String | Critical | Never | No |
| B01-Q006 | Do you have any known genetic markers or predispositions? | Advanced health forecasting and prevention. | List | High | Rarely | No |
| B01-Q007 | What is your current height? | Basis for BMI and physical health metrics. | Number | Medium | Rarely | Yes |
| B01-Q008 | What are your primary citizenship(s)? | Determines legal rights, travel constraints, and tax obligations. | List | High | Rarely | Yes |
| B01-Q009 | What is your Social Security Number or national ID? | Essential for financial and legal system interaction. | String | Critical | Rarely | No |
| B01-Q010 | What is your primary language? | Sets the default communication protocol. | String | Critical | Never | No |
| B01-Q011 | What other languages do you speak or understand? | Expands the communication and research surface. | Map | High | Sometimes | Yes |
| B01-Q012 | What is your current legal marital status? | Impact on taxes, insurance, and social graph. | Enum | High | Sometimes | Yes |
| B01-Q013 | What are your current official residential addresses? | Geographical context for logistics and routine. | List | High | Frequently | Yes |
| B01-Q014 | What is your dominant hand? | Optimization for device interaction and ergonomics. | Enum | Low | Never | No |
| B01-Q015 | Do you use any corrective lenses (glasses/contacts)? | Optimization for visual UI and health tracking. | Boolean | Medium | Sometimes | Yes |
| B01-Q016 | What is your natural hair color? | Identity marker. | String | Low | Rarely | Yes |
| B01-Q017 | What is your natural eye color? | Identity marker. | String | Low | Never | No |
| B01-Q018 | Do you have any permanent physical identifiers (scars/tattoos)? | Identity and medical verification. | List | Medium | Rarely | Yes |
| B01-Q019 | What are your primary digital handles (usernames)? | Maps the owner's digital footprint. | List | High | Frequently | Yes |
| B01-Q020 | What is your primary contact email address? | Primary communication channel. | String | Critical | Rarely | Yes |

### Category: Core Values & Beliefs (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B01-Q021 | What are your top 5 non-negotiable personal values? | The ultimate decision-making filter for Knight. | List | Critical | Rarely | Yes |
| B01-Q022 | How do you define "Success" in your own terms? | Calibrates Knight's goal-alignment logic. | String | Critical | Sometimes | Yes |
| B01-Q023 | What is your stance on the balance between risk and security? | Influences financial and career recommendations. | Enum | High | Sometimes | Yes |
| B01-Q024 | Do you subscribe to a specific religion or spiritual framework? | Context for ethical and social behavior. | String | High | Rarely | Yes |
| B01-Q025 | What is your core political philosophy? | Context for societal interaction and content filtering. | String | Medium | Rarely | Yes |
| B01-Q026 | What is your primary motivator: Achievement, Power, or Affiliation? | Sets the "Coaching Style" for Knight. | Enum | High | Rarely | Yes |
| B01-Q027 | What is your view on the inherent nature of human beings? | Influences how Knight interprets social interactions. | String | Medium | Rarely | Yes |
| B01-Q028 | How do you prioritize Self vs. Others in a crisis? | Ethical constraint for decision simulations. | Enum | High | Rarely | Yes |
| B01-Q029 | What is your attitude toward tradition vs. innovation? | Influences recommendation bias. | Enum | Medium | Sometimes | Yes |
| B01-Q030 | What do you consider to be your "Life Mission"? | The north star for all long-term strategic planning. | String | Critical | Rarely | Yes |
| B01-Q031 | What is your greatest fear? | Identifying psychological constraints and triggers. | String | High | Rarely | Yes |
| B01-Q032 | What is your definition of "Honesty"? | Calibrates the communication ethics between owner and Knight. | String | High | Never | No |
| B01-Q033 | Do you believe in free will or determinism? | Influences how Knight frames choices. | Enum | Medium | Rarely | No |
| B01-Q034 | What is your relationship with "Authority"? | Context for how Knight should challenge the owner. | String | High | Sometimes | Yes |
| B01-Q035 | How do you value privacy vs. convenience? | Sets the security and data-sharing protocol. | Enum | Critical | Sometimes | Yes |
| B01-Q036 | What role does "Loyalty" play in your relationships? | Mapping social priority and conflict resolution. | String | Medium | Rarely | Yes |
| B01-Q037 | What is your view on the accumulation of wealth? | Calibrates Book IV (Finance) goals. | String | High | Sometimes | Yes |
| B01-Q038 | What is your stance on environmental stewardship? | Filter for consumer and travel recommendations. | Enum | Medium | Sometimes | Yes |
| B01-Q039 | How do you define "Legacy"? | Focuses Book X (Ambition) on post-life impact. | String | High | Rarely | Yes |
| B01-Q040 | What is the one thing you would never do, regardless of the reward? | Identifies the ultimate moral boundaries. | String | Critical | Never | No |

### Category: Personality & Temperament (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B01-Q041 | Are you primarily an Introvert or an Extrovert? | Optimizes social scheduling and communication tone. | Enum | High | Rarely | No |
| B01-Q042 | What is your typical response to high-stress situations? | Allows Knight to trigger "Calm Protocols" or provide data. | String | High | Sometimes | Yes |
| B01-Q043 | How do you prefer to receive feedback: Direct or Softened? | Sets the "Feedback Style" for Knight. | Enum | Critical | Sometimes | Yes |
| B01-Q044 | Do you consider yourself more of a "Big Picture" or "Detail Oriented" person? | Adjusts the level of depth in Knight's reports. | Enum | High | Rarely | No |
| B01-Q045 | What is your "Social Battery" capacity (hours of interaction)? | Optimizes calendar and recovery cycles. | Number | Medium | Sometimes | Yes |
| B01-Q046 | How do you handle conflict: Confront, Avoid, or Negotiate? | Conflict resolution strategy for relationships. | Enum | High | Sometimes | Yes |
| B01-Q047 | What is your Myers-Briggs (MBTI) type (if known)? | General psychological baseline. | String | Medium | Rarely | No |
| B01-Q048 | What is your Enneagram type (if known)? | Insight into core drivers and stress reactions. | String | Medium | Rarely | No |
| B01-Q049 | How do you react to unexpected change in routine? | Calibrates how Knight introduces new suggestions. | Enum | Medium | Sometimes | Yes |
| B01-Q050 | Are you more Intuitive or Analytical in your decision-making? | Sets the "Reasoning Framework" Knight should present. | Enum | High | Rarely | No |
| B01-Q051 | What is your primary love language (in any relationship)? | Mapping emotional intelligence and relationship health. | String | Medium | Rarely | Yes |
| B01-Q052 | How much "Alone Time" do you require daily for optimal function? | Constraint for routine and scheduling. | Number | High | Sometimes | Yes |
| B01-Q053 | Are you a "Morning Person" or a "Night Owl"? | Optimizes peak performance scheduling. | Enum | High | Rarely | Yes |
| B01-Q054 | What is your tolerance for ambiguity (1-10)? | Determines how Knight presents "Unknowns." | Number | Medium | Sometimes | Yes |
| B01-Q055 | Do you prefer to work in silence or with background noise? | Environmental optimization for focus sessions. | Enum | Low | Sometimes | Yes |
| B01-Q056 | How do you handle rejection? | Context for career and social resilience. | String | Medium | Sometimes | Yes |
| B01-Q057 | Are you prone to "Overthinking"? | Triggers Knight to provide "Simplicity Filters." | Boolean | High | Sometimes | Yes |
| B01-Q058 | What is your level of patience (1-10)? | Adjusts the frequency of Knight's follow-ups. | Number | Medium | Sometimes | Yes |
| B01-Q059 | Do you consider yourself an optimist, pessimist, or realist? | Sets the "Perspective Bias" in reports. | Enum | Medium | Rarely | Yes |
| B01-Q060 | What is your "Sense of Humor" style? | Personalizes the communication layer. | String | Low | Rarely | Yes |

### Category: Intellectual & Cognitive (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B01-Q061 | What is your primary learning style: Visual, Auditory, or Kinesthetic? | Optimizes how Knight teaches new concepts. | Enum | High | Rarely | No |
| B01-Q062 | What is your estimated reading speed (words per minute)? | Optimizes content summaries and briefing lengths. | Number | Medium | Sometimes | Yes |
| B01-Q063 | How long is your typical "Deep Work" focus span? | Determines block sizes for productivity scheduling. | Number | High | Sometimes | Yes |
| B01-Q064 | What are your "Top 3" fields of deep expertise? | Maps the "Expertise Peak" in the Skill domain. | List | High | Rarely | Yes |
| B01-Q065 | How do you prefer to brainstorm: Alone first or in a group? | Sets the "Ideation Protocol" with Knight. | Enum | Medium | Rarely | No |
| B01-Q066 | Do you have any diagnosed cognitive conditions (ADHD, Dyslexia, etc.)? | Allows Knight to provide specific cognitive scaffolding. | List | High | Rarely | No |
| B01-Q067 | What is your relationship with "Logic" vs "Emotion"? | Calibrates how Knight should justify recommendations. | Enum | High | Rarely | Yes |
| B01-Q068 | How do you store information for later: Analog (paper) or Digital? | Optimizes the "Capture" phase of learning. | Enum | Medium | Sometimes | Yes |
| B01-Q069 | What is the most complex concept you have ever mastered? | Baseline for cognitive ceiling and learning strategy. | String | Medium | Rarely | Yes |
| B01-Q070 | Do you suffer from "Information Overload" easily? | Triggers Knight's "Executive Summary" mode. | Boolean | High | Sometimes | Yes |
| B01-Q071 | What is your favorite way to solve a puzzle: Trial/Error or Pure Logic? | Influences how Knight presents problem-solving steps. | Enum | Low | Rarely | No |
| B01-Q072 | How much "Meta-cognition" (thinking about thinking) do you do? | Sets the level of philosophical depth in interactions. | Enum | Medium | Sometimes | Yes |
| B01-Q073 | What is your "Memory Retention" profile for names vs. faces vs. facts? | Allows Knight to compensate for specific memory gaps. | Map | Medium | Rarely | No |
| B01-Q074 | How often do you seek out opposing viewpoints? | Measures "Open-mindedness" for the Knowledge Graph. | Enum | High | Sometimes | Yes |
| B01-Q075 | What is your primary "Mental Model" for problem-solving? | Sets the default analytical framework. | String | High | Sometimes | Yes |
| B01-Q076 | Do you prefer "Bottom-Up" or "Top-Down" explanations? | Sets the structure of technical reports. | Enum | Medium | Rarely | No |
| B01-Q077 | What is your "Curiosity Quotient" (1-10)? | Adjusts how many "Interesting Facts" Knight shares. | Number | Low | Sometimes | Yes |
| B01-Q078 | How do you determine if a source of information is "Trustworthy"? | Calibrates the Evidence Framework for the owner. | String | High | Sometimes | Yes |
| B01-Q079 | What is your tolerance for "Cognitive Dissonance"? | Measures how Knight should introduce challenging truths. | Enum | High | Sometimes | Yes |
| B01-Q080 | What is the one subject you could talk about for 30 minutes with no preparation? | Identifies core intellectual passion and "Flow" state topic. | String | Medium | Rarely | Yes |

### Category: Philosophical & Existential (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B01-Q081 | What do you believe happens after death? | Ultimate existential context. | String | Medium | Rarely | Yes |
| B01-Q082 | What is your view on the "Meaning of Life"? | Context for Book X (Ambition). | String | High | Rarely | Yes |
| B01-Q083 | Do you believe in "Luck" or "Fate"? | Influences how Knight frames success/failure. | Enum | Medium | Rarely | No |
| B01-Q084 | What is your "Personal Manifesto" in one sentence? | The core distillation of identity. | String | Critical | Rarely | Yes |
| B01-Q085 | How do you justify your own existence? | Deepest level of motivation and value. | String | High | Rarely | Yes |
| B01-Q086 | What is the most important lesson you have learned from a failure? | Seeds the "Lessons Learned" domain. | String | High | Rarely | Yes |
| B01-Q087 | If you could change one thing about your core self, what would it be? | Identifies the primary "Self-Optimization" target. | String | High | Sometimes | Yes |
| B01-Q088 | What does "Freedom" mean to you? | Key constraint for career and finance recommendations. | String | High | Rarely | Yes |
| B01-Q089 | Do you believe you are more than the sum of your parts? | Philosophical stance on consciousness. | Boolean | Low | Rarely | No |
| B01-Q090 | What is your "Shadow Self" (the parts of you you dislike)? | Critical for Knight to monitor and mitigate during stress. | String | High | Rarely | Yes |
| B01-Q091 | How do you define "Good" and "Evil"? | Foundational ethics for Book VI. | String | High | Rarely | No |
| B01-Q092 | What is the role of "Suffering" in a human life? | Context for resilience and coaching during hardship. | String | Medium | Rarely | Yes |
| B01-Q093 | What is your "Ideal Self" image? | The target for all Knight-led growth initiatives. | String | Critical | Sometimes | Yes |
| B01-Q094 | How do you feel about your own mortality (1-10 level of comfort)? | Context for time-management and urgency. | Number | Medium | Sometimes | Yes |
| B01-Q095 | What is your "Internal Monologue" like (critical, supportive, quiet)? | Knight mimics or balances this in its communication. | String | High | Rarely | Yes |
| B01-Q096 | Do you feel like the "Hero" or the "Observer" in your own life story? | Sets the "Agency Level" Knight encourages. | Enum | High | Sometimes | Yes |
| B01-Q097 | What is your "Untapped Potential" according to you? | Directs the Skill and Career domains. | String | High | Sometimes | Yes |
| B01-Q098 | What is the "Question" you have been asking yourself your whole life? | The central mystery of the individual. | String | Critical | Rarely | No |
| B01-Q099 | What is your "One Truth" you would share with everyone? | The primary message/legacy of the soul. | String | High | Rarely | Yes |
| B01-Q100 | Who are you, really, when nobody is watching? | The ultimate identity statement. | String | Critical | Rarely | Yes |

---
---

## Book II: Career & Mission (The Impact)
*Focus: Professional growth, contribution, and long-term work.*

### Category: Current State & Occupation (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B02-Q001 | What is your current primary job title? | Basic professional identification. | String | Critical | Frequently | Yes |
| B02-Q002 | What is the name of your current employer/organization? | Context for professional environment. | String | High | Frequently | Yes |
| B02-Q003 | What is your primary industry? | Maps the expertise domain and market context. | String | High | Rarely | Yes |
| B02-Q004 | What are your top 3 daily responsibilities? | Identifies the "Active Work" profile. | List | High | Frequently | Yes |
| B02-Q005 | What is your current annual gross income? | Primary financial and career metric. | Number | Critical | Sometimes | Yes |
| B02-Q006 | What is your current employment type (Full-time, Freelance, Owner)? | Determines time-management and security needs. | Enum | High | Sometimes | Yes |
| B02-Q007 | How many hours do you work per week on average? | Work-life balance and productivity metric. | Number | Medium | Frequently | Yes |
| B02-Q008 | What is the size of your current organization (employees)? | Context for corporate navigation and impact. | Enum | Medium | Rarely | Yes |
| B02-Q009 | What is your level of seniority (Entry, Mid, Senior, Executive)? | Calibrates career coaching and skill needs. | Enum | High | Sometimes | Yes |
| B02-Q010 | Do you manage people? If so, how many? | Identifies leadership and management skill needs. | Number | High | Sometimes | Yes |
| B02-Q011 | What is your primary mode of work (Remote, Hybrid, On-site)? | Logistics and environmental optimization. | Enum | Medium | Sometimes | Yes |
| B02-Q012 | What is your current level of job satisfaction (1-10)? | Triggers "Career Pivot" or "Optimization" logic. | Number | High | Frequently | Yes |
| B02-Q013 | What is the biggest "Pain Point" in your current role? | Identifying targets for automation or strategy. | String | High | Frequently | Yes |
| B02-Q014 | What are the "Key Performance Indicators" (KPIs) you are judged by? | Focuses Knight on the metrics that matter for career growth. | List | Critical | Sometimes | Yes |
| B02-Q015 | Who is your immediate superior, and what is your relationship with them? | Mapping the professional power graph. | String | Medium | Sometimes | Yes |
| B02-Q016 | What is the "Mission Statement" of your current employer? | Checks for alignment between owner and organization. | String | Medium | Rarely | No |
| B02-Q017 | How much of your current work do you consider "Deep Work"? | Productivity and fulfillment metric. | Number | High | Sometimes | Yes |
| B02-Q018 | What is your commute time (if any)? | Cost-of-work calculation. | Number | Low | Sometimes | Yes |
| B02-Q019 | Do you have any "Side Hustles" or secondary income streams? | Financial and time-allocation mapping. | List | Medium | Sometimes | Yes |
| B02-Q020 | What is the "Terminal Value" of your current career path? | Long-term strategy and exit-planning context. | String | High | Rarely | Yes |

### Category: History & Trajectory (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B02-Q021 | What was your first-ever paid job? | Seeds the career history and work ethic origin. | String | Low | Never | No |
| B02-Q022 | What is the longest duration you have stayed at one employer? | Measures loyalty and "Iteration Speed." | Number | Medium | Rarely | Yes |
| B02-Q023 | What was the reason for your last career change? | Identifies "Push/Pull" factors in life decisions. | String | High | Never | No |
| B02-Q024 | Have you ever been fired or laid off? If so, what was the lesson? | Identifies resilience and systemic risks. | String | High | Never | No |
| B02-Q025 | What is the most significant professional achievement of your life so far? | Benchmarks the "High Point" for future scaling. | String | Critical | Rarely | Yes |
| B02-Q026 | What is the biggest "Career Mistake" you have made? | Prevents repetition of past strategic errors. | String | High | Never | No |
| B02-Q027 | Who has been the most influential mentor in your career? | Maps the professional social graph and influence. | String | Medium | Rarely | Yes |
| B02-Q028 | How has your income grown over the last 5 years? | Measures economic trajectory. | Map | High | Rarely | Yes |
| B02-Q029 | What was your original "Dream Job" as a child? | Identifies core interests vs. practical realities. | String | Low | Never | No |
| B02-Q030 | Have you ever completely changed industries? | Measures adaptability and transferable skills. | Boolean | Medium | Never | No |
| B02-Q031 | What is the "Skill" that has consistently earned you the most money? | Identifies the "Cash Cow" skill. | String | High | Sometimes | Yes |
| B02-Q032 | What is the most difficult professional feedback you have received? | Identifies blindspots and growth areas. | String | High | Rarely | Yes |
| B02-Q033 | Have you ever owned your own business? | Identifies entrepreneurial risk tolerance. | Boolean | High | Rarely | Yes |
| B02-Q034 | What is the most "Impactful" project you have ever worked on? | Measures value-creation capacity. | String | High | Rarely | Yes |
| B02-Q035 | How do you typically find new job opportunities (Networking, Job Boards, etc.)? | Optimizes the "Search Engine" for career moves. | Enum | Medium | Sometimes | Yes |
| B02-Q036 | What is your "Professional Reputation" in 3 words? | Understanding the "Brand" Knight must protect. | List | High | Sometimes | Yes |
| B02-Q037 | What is the "Minimum Viable Income" you would accept? | Sets the "Survival Floor" for career pivots. | Number | Critical | Sometimes | Yes |
| B02-Q038 | Have you ever taken a "Sabbatical" or long break from work? | Measures "Recovery" and "Reflection" capacity. | Boolean | Medium | Rarely | Yes |
| B02-Q039 | What is the most valuable "Soft Skill" you have developed? | Maps non-technical contribution. | String | Medium | Sometimes | Yes |
| B02-Q040 | What is the current "Market Value" of your role? | Calibrates negotiation strategy for salary. | Number | High | Frequently | Yes |

### Category: Strategic Goals & Ambition (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B02-Q041 | What is your "One-Year" career goal? | Immediate tactical target. | String | High | Frequently | Yes |
| B02-Q042 | What is your "Five-Year" career goal? | Strategic horizon target. | String | High | Sometimes | Yes |
| B02-Q043 | What is your "Ultimate Career Peak" (The Dream)? | Long-term vision and ambition ceiling. | String | Critical | Rarely | Yes |
| B02-Q044 | If money were no object, what work would you do tomorrow? | Identifies "True Calling" vs "Current Path." | String | Critical | Sometimes | Yes |
| B02-Q045 | What is the next "Promotion" or "Step Up" for you? | Identifies the immediate growth vector. | String | High | Sometimes | Yes |
| B02-Q046 | What is the one "Skill" you need to learn to reach the next level? | Directs the Skill domain's learning path. | String | High | Sometimes | Yes |
| B02-Q047 | What is your "Retirement Age" target? | Sets the temporal constraint for wealth building. | Number | High | Rarely | Yes |
| B02-Q048 | Do you want to be a "Specialist" or a "Generalist"? | Influences the type of career advice Knight gives. | Enum | High | Rarely | Yes |
| B02-Q049 | What is the "Legacy" you want to leave through your work? | Ties career to Identity (Book I). | String | High | Rarely | Yes |
| B02-Q050 | How much "Power/Influence" do you want in your career (1-10)? | Calibrates ambition levels. | Number | Medium | Sometimes | Yes |
| B02-Q051 | Would you rather be "Loved" or "Respected" in the workplace? | Sets the communication and social strategy. | Enum | Medium | Rarely | No |
| B02-Q052 | What is the "Company" or "Person" you would most like to work for? | Identifies specific networking targets. | String | High | Sometimes | Yes |
| B02-Q053 | Are you interested in "Thought Leadership" (Writing, Speaking)? | Directs the "Brand Building" strategy. | Boolean | Medium | Sometimes | Yes |
| B02-Q054 | What is your "Exit Strategy" for your current role? | Prepares Knight for transitions. | String | Medium | Sometimes | Yes |
| B02-Q055 | How much "Creative Freedom" do you require in your work? | Key filter for job satisfaction and new roles. | Enum | High | Sometimes | Yes |
| B02-Q056 | What is the "Economic Engine" of your dream life? | Understanding the business model of the self. | String | Critical | Sometimes | Yes |
| B02-Q057 | Do you plan to transition into a new industry in the next 3 years? | Triggers "Market Research" mode. | Boolean | High | Sometimes | Yes |
| B02-Q058 | What is the "Threshold of Wealth" that would make you quit your job? | Identifies the "Freedom Number." | Number | Critical | Sometimes | Yes |
| B02-Q059 | What is the "Social Good" you want your work to achieve? | Ties career to Ethics (Book VI). | String | Medium | Rarely | Yes |
| B02-Q060 | What is your "Working Style" preference (Solo, Small Team, Corporate)? | Filter for organizational fit. | Enum | Medium | Rarely | Yes |

### Category: Network & Social Capital (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B02-Q061 | Who are the "Top 5" most important people in your professional network? | Identifies key nodes in the social graph. | List | Critical | Frequently | Yes |
| B02-Q062 | How often do you actively "Network"? | Measures the growth of social capital. | Enum | Medium | Sometimes | Yes |
| B02-Q063 | What is your "LinkedIn" or professional profile status? | Mapping the external brand. | String | Medium | Frequently | Yes |
| B02-Q064 | Who is your biggest professional "Rival" or "Competitor"? | Benchmarks performance against the market. | String | Medium | Sometimes | Yes |
| B02-Q065 | How many "Meaningful Connections" do you have in your industry? | Measures network depth. | Number | Medium | Sometimes | Yes |
| B02-Q066 | Do you belong to any professional associations or groups? | Identifies industry resources. | List | Medium | Sometimes | Yes |
| B02-Q067 | What is the "One Favor" you could ask of your network right now? | Measures immediate leverage. | String | High | Frequently | Yes |
| B02-Q068 | Who in your network could "Vouch" for your character? | Identifies character witnesses for high-stakes moves. | List | High | Sometimes | Yes |
| B02-Q069 | How do you "Give Back" to your professional community? | Measures social contribution. | String | Medium | Sometimes | Yes |
| B02-Q070 | What is the "Gap" in your current network? | Directs Knight to find new connection types. | String | High | Sometimes | Yes |
| B02-Q071 | Do you have a board of "Personal Advisors"? | Maps the high-level influence circle. | List | High | Rarely | Yes |
| B02-Q072 | How much of your success is due to "Who you know"? | Measures dependence on social vs. human capital. | Enum | Medium | Rarely | Yes |
| B02-Q073 | What is your strategy for maintaining "Weak Ties"? | Optimizes social CRM logic. | String | Low | Sometimes | Yes |
| B02-Q074 | Who is the person you are "Avoiding" professionally? | Identifies social friction and risks. | String | Medium | Frequently | Yes |
| B02-Q075 | What is the "Value Proposition" you offer to your network? | Defines the owner's social "Worth." | String | High | Sometimes | Yes |
| B02-Q076 | How do you handle "Professional Betrayal"? | Identifies social resilience and conflict logic. | String | Medium | Rarely | Yes |
| B02-Q077 | Are you an "Influencer" in your niche? | Measures external authority levels. | Boolean | Medium | Sometimes | Yes |
| B02-Q078 | What is the "Social Debt" you owe to others professionally? | Identifies obligations. | List | Medium | Frequently | Yes |
| B02-Q079 | What is the "Social Credit" others owe to you? | Identifies untapped social assets. | List | Medium | Frequently | Yes |
| B02-Q080 | How many people would follow you to a new company? | Measures "Leadership Gravity." | Number | High | Sometimes | Yes |

### Category: Skills & Competitive Advantage (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B02-Q081 | What is your "Unique Selling Proposition" (USP)? | Identifies the core competitive advantage. | String | Critical | Rarely | Yes |
| B02-Q082 | What is the "Hardest Skill" you have ever learned? | Benchmarks cognitive and technical capacity. | String | Medium | Never | No |
| B02-Q083 | What is the "Obsolete Skill" you still possess? | Identifies sunk-cost fallacies or legacy knowledge. | String | Low | Rarely | Yes |
| B02-Q084 | What is your "Speed of Learning" for new software (1-10)? | Calibrates technical onboarding advice. | Number | High | Rarely | Yes |
| B02-Q085 | What is your "Deepest Expertise" area (The 10,000 Hour Skill)? | Defines the "Specialist" peak. | String | Critical | Rarely | Yes |
| B02-Q086 | What is the "Skill" you are currently learning? | Tracks active growth in Book VII. | String | High | Frequently | Yes |
| B02-Q087 | How do you stay current in your industry? | Maps the "Information Inflow" strategy. | List | Medium | Sometimes | Yes |
| B02-Q088 | What is the "Tool" (Software/Hardware) you are most proficient with? | Identifies the "Primary Instrument." | String | High | Sometimes | Yes |
| B02-Q089 | What is your "Output Rate" for your primary work? | Measures productivity baseline. | String | Medium | Frequently | Yes |
| B02-Q090 | What is the "Skill Gap" that keeps you up at night? | Identifies the most urgent learning target. | String | High | Frequently | Yes |
| B02-Q091 | Do you have any "Rare Skill Combinations"? | Identifies niche market opportunities. | List | Critical | Rarely | Yes |
| B02-Q092 | What is your "Sales/Persuasion" ability (1-10)? | Measures the ability to move ideas/products. | Number | High | Sometimes | Yes |
| B02-Q093 | What is your "Technical Literacy" (1-10)? | Calibrates how technical Knight's advice should be. | Number | Critical | Sometimes | Yes |
| B02-Q094 | How many "Certifications" do you hold? | Measures formal validation of skills. | Number | Medium | Sometimes | Yes |
| B02-Q095 | What is the "Skill" people always ask you for help with? | Identifies the "Perceived Value" peak. | String | High | Sometimes | Yes |
| B02-Q096 | Are you a "Maker" or a "Manager"? | Sets the focus of career optimization. | Enum | High | Rarely | Yes |
| B02-Q097 | What is the "Language" (Human or Computer) you are most proud of? | Identifies intellectual pride points. | String | Low | Never | No |
| B02-Q098 | What is your "Public Speaking" comfort level (1-10)? | Identifies capacity for broad influence. | Number | Medium | Sometimes | Yes |
| B02-Q099 | What is the "Art" or "Craft" in your work? | Identifies the source of quality and pride. | String | Medium | Rarely | Yes |
| B02-Q100 | What is your "Endgame" for your career? | The ultimate conclusion of Book II. | String | Critical | Rarely | Yes |

---

## Book III: Health & Vitality (The Vessel)
*Focus: Physical health, nutrition, sleep, and medical history.*

### Category: Physical Baseline & Vitals (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B03-Q001 | What is your current body weight? | Baseline metabolic and health metric. | Number | Critical | Frequently | Yes |
| B03-Q002 | What is your "Target Weight"? | Calibrates fitness and nutrition advice. | Number | High | Sometimes | Yes |
| B03-Q003 | What is your resting heart rate (RHR)? | Primary indicator of cardiovascular fitness. | Number | High | Frequently | Yes |
| B03-Q004 | What is your typical blood pressure (Systolic/Diastolic)? | Critical long-term health indicator. | String | High | Sometimes | Yes |
| B03-Q005 | What is your current Body Fat Percentage (if known)? | More accurate health metric than weight. | Number | Medium | Sometimes | Yes |
| B03-Q006 | What is your "Basal Metabolic Rate" (BMR)? | Calibrates calorie-in/out logic. | Number | High | Rarely | Yes |
| B03-Q007 | Do you have any "Chronic Conditions"? | The most important constraint for Book III. | List | Critical | Rarely | Yes |
| B03-Q008 | List all current "Medications" you take. | Safety and chemical context. | List | Critical | Frequently | Yes |
| B03-Q009 | List all "Supplements" you take. | Nutritional context. | List | High | Frequently | Yes |
| B03-Q010 | Do you have any "Allergies" (Food, Environmental, Medical)? | Life-saving safety constraint. | List | Critical | Rarely | Yes |
| B03-Q011 | What is your current "Blood Type"? | Emergency context. | Enum | Critical | Never | No |
| B03-Q012 | What was the date of your last "Full Physical"? | Measures health-maintenance compliance. | Date | High | Sometimes | Yes |
| B03-Q013 | What is your "VO2 Max" (if known)? | Metric of aerobic capacity. | Number | Medium | Rarely | Yes |
| B03-Q014 | What is your "Waist-to-Hip" ratio? | Predictor of metabolic health. | Number | Medium | Sometimes | Yes |
| B03-Q015 | Do you use any "Medical Devices" (CPAP, Insulin pump)? | Technical and health integration context. | List | Critical | Rarely | Yes |
| B03-Q016 | What is your current "Pain Level" (0-10) on a typical day? | Chronic health and quality-of-life metric. | Number | High | Frequently | Yes |
| B03-Q017 | How is your "Vision" (20/20, nearsighted, etc.)? | Sensory context. | String | Medium | Sometimes | Yes |
| B03-Q018 | How is your "Hearing" (Any loss or tinnitus)? | Sensory context. | String | Medium | Sometimes | Yes |
| B03-Q019 | What is your "Biological Age" vs. your Chronological Age? | Measures the success of longevity protocols. | Number | High | Sometimes | Yes |
| B03-Q020 | What is the "Metric of Health" you care about most? | Calibrates Knight's monitoring priorities. | String | Critical | Sometimes | Yes |

### Category: Nutrition & Metabolism (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B03-Q021 | What is your "Primary Diet" (Omnivore, Vegan, Keto)? | Sets the nutritional filter. | Enum | Critical | Sometimes | Yes |
| B03-Q022 | How many "Calories" do you consume on a typical day? | Fuel mapping. | Number | High | Frequently | Yes |
| B03-Q023 | What is your "Macro Split" (Protein/Carb/Fat)? | Calibrates nutrition optimization. | Map | High | Sometimes | Yes |
| B03-Q024 | How many liters of "Water" do you drink daily? | Hydration tracking. | Number | High | Frequently | Yes |
| B03-Q025 | What is your relationship with "Caffeine" (Amount/Timing)? | Energy and sleep optimization. | String | High | Frequently | Yes |
| B03-Q026 | How much "Alcohol" do you consume per week? | Toxicity and lifestyle tracking. | Number | High | Frequently | Yes |
| B03-Q027 | Do you "Smoke" or "Vape" (any substance)? | Primary health risk factor. | Boolean | Critical | Sometimes | Yes |
| B03-Q028 | How many "Meals" do you eat per day? | Metabolism and routine context. | Number | Medium | Sometimes | Yes |
| B03-Q029 | Do you practice "Intermittent Fasting"? | Metabolic and routine context. | Boolean | Medium | Sometimes | Yes |
| B03-Q030 | What is your "Favorite Healthy Food"? | Incentivizes good habits. | String | Low | Sometimes | Yes |
| B03-Q031 | What is your "Go-To Junk Food"? | Identifies "Cheat Day" triggers and risks. | String | Low | Sometimes | Yes |
| B03-Q032 | Do you have any "Food Intolerances" (Gluten, Lactose)? | Nutritional constraint. | List | High | Rarely | Yes |
| B03-Q033 | How many grams of "Sugar" do you consume daily (est.)? | Metabolic risk tracking. | Number | High | Frequently | Yes |
| B03-Q034 | How often do you "Cook" vs "Eat Out"? | Financial and health impact. | Enum | Medium | Frequently | Yes |
| B03-Q035 | Do you take a "Multivitamin"? | Nutritional baseline. | Boolean | Medium | Sometimes | Yes |
| B03-Q036 | What is your "Satiety" profile (Do you feel full easily)? | Metabolic and behavioral mapping. | String | Medium | Sometimes | Yes |
| B03-Q037 | What is your view on "Process Foods"? | Calibrates grocery/restaurant recommendations. | Enum | Medium | Rarely | Yes |
| B03-Q038 | How does "Stress" affect your appetite? | Behavioral trigger mapping. | Enum | High | Sometimes | Yes |
| B03-Q039 | What is your "Target Daily Protein" intake? | Muscle maintenance and growth metric. | Number | High | Sometimes | Yes |
| B03-Q040 | What is the "Supplement" you feel has the most impact? | Identifies perceived efficacy. | String | Medium | Sometimes | Yes |

### Category: Sleep & Recovery (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B03-Q041 | What is your average "Sleep Duration" (hours)? | Primary recovery metric. | Number | Critical | Frequently | Yes |
| B03-Q042 | What is your "Ideal Wake-Up" time? | Routine optimization. | Date | High | Sometimes | Yes |
| B03-Q043 | What is your "Ideal Bedtime"? | Routine optimization. | Date | High | Sometimes | Yes |
| B03-Q044 | What is your "Sleep Quality" score (1-10)? | Subjective recovery metric. | Number | High | Frequently | Yes |
| B03-Q045 | How long does it take you to "Fall Asleep" (Latency)? | Indicator of sleep hygiene and stress. | Number | Medium | Frequently | Yes |
| B03-Q046 | Do you wake up during the night? How many times? | Sleep continuity tracking. | Number | Medium | Frequently | Yes |
| B03-Q047 | Do you "Snore"? | Indicator of apnea and sleep quality. | Boolean | High | Sometimes | Yes |
| B03-Q048 | What is your "Deep Sleep" % (if using tracker)? | Recovery fidelity metric. | Number | High | Frequently | Yes |
| B03-Q049 | What is your "REM Sleep" % (if using tracker)? | Cognitive recovery metric. | Number | High | Frequently | Yes |
| B03-Q050 | How do you feel "Immediately upon Waking"? | Subjective readiness metric. | String | Medium | Frequently | Yes |
| B03-Q051 | Do you "Nap" during the day? | Energy management mapping. | Boolean | Low | Frequently | Yes |
| B03-Q052 | What is your "Bedroom Temperature" preference? | Sleep environment optimization. | Number | Low | Rarely | Yes |
| B03-Q053 | Do you use "White Noise" or a fan? | Sleep environment optimization. | Boolean | Low | Rarely | Yes |
| B03-Q054 | Do you use "Sleep Supplements" (Melatonin, Magnesium)? | Recovery integration. | List | Medium | Sometimes | Yes |
| B03-Q055 | What is your "Digital Sunset" (time you stop using screens)? | Sleep hygiene protocol. | Date | High | Sometimes | Yes |
| B03-Q056 | How does "Exercise" affect your sleep? | Causal mapping of habits. | String | Medium | Sometimes | Yes |
| B03-Q057 | How does "Alcohol" affect your sleep? | Causal mapping of toxins. | String | High | Sometimes | Yes |
| B03-Q058 | Do you use a "Weighted Blanket"? | Sleep environment optimization. | Boolean | Low | Never | No |
| B03-Q059 | What is the biggest "Distraction" to your sleep? | Environmental cleanup target. | String | High | Sometimes | Yes |
| B03-Q060 | What is your "Recovery" protocol (Sauna, Ice, Stretching)? | Active recovery mapping. | List | Medium | Sometimes | Yes |

### Category: Exercise & Performance (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B03-Q061 | How many "Steps" do you average per day? | Baseline physical activity. | Number | High | Frequently | Yes |
| B03-Q062 | How many times per week do you "Strength Train"? | Physical capability metric. | Number | High | Frequently | Yes |
| B03-Q063 | How many times per week do you do "Cardio"? | Heart health metric. | Number | High | Frequently | Yes |
| B03-Q064 | What is your "Favorite Exercise"? | Motivator for adherence. | String | Low | Sometimes | Yes |
| B03-Q065 | What is your "Least Favorite Exercise"? | Identifies friction points. | String | Low | Sometimes | Yes |
| B03-Q066 | What is your current "1-Rep Max" for Bench Press/Squat/Deadlift (if applicable)? | Measures raw physical strength Peak. | Map | Medium | Sometimes | Yes |
| B03-Q067 | How "Flexible" are you (1-10)? | Mobility and injury-prevention metric. | Number | Medium | Sometimes | Yes |
| B03-Q068 | Do you have any "Active Injuries"? | Critical constraint for exercise plans. | List | Critical | Frequently | Yes |
| B03-Q069 | What is your "Rest Day" frequency? | Overtraining prevention. | Number | Medium | Sometimes | Yes |
| B03-Q070 | Do you prefer "Solo" or "Group" workouts? | Motivational optimization. | Enum | Low | Rarely | Yes |
| B03-Q071 | What is your primary "Fitness Goal" (Muscle, Fat Loss, Endurance)? | Sets the training filter. | Enum | Critical | Sometimes | Yes |
| B03-Q072 | How much do you "Sit" per day (hours)? | Sedentary risk tracking. | Number | High | Frequently | Yes |
| B03-Q073 | What is your "Heart Rate Variability" (HRV) average? | Primary indicator of nervous system readiness. | Number | High | Frequently | Yes |
| B03-Q074 | Do you "Stretch" regularly? | Mobility tracking. | Boolean | Medium | Frequently | Yes |
| B03-Q075 | What is your "Grip Strength" (if known)? | General longevity indicator. | Number | Medium | Rarely | Yes |
| B03-Q076 | How do you "Track" your workouts (App, Journal)? | Integration context. | String | Low | Rarely | Yes |
| B03-Q077 | What "Sports" do you play? | Functional activity mapping. | List | Low | Sometimes | Yes |
| B03-Q078 | Have you ever run a "Marathon" or similar endurance event? | High-water mark of endurance. | Boolean | Low | Never | No |
| B03-Q079 | What is your "Time to Fatigue" during intense work? | Performance baseline. | Number | Medium | Sometimes | Yes |
| B03-Q080 | What is the "Best Shape" you have ever been in? | Target baseline for the "Ideal Vessel." | String | Medium | Never | No |

### Category: Medical History & Longevity (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B03-Q081 | Have you ever had "Surgery"? List them. | Major medical history. | List | Critical | Never | No |
| B03-Q082 | Have you ever been "Hospitalized"? | Major medical history. | List | High | Never | No |
| B03-Q083 | What is your "Family Medical History" (Cancer, Heart, Diabetes)? | Genetic risk mapping. | Map | Critical | Rarely | No |
| B03-Q084 | What "Vaccinations" are you current on? | Immunity context. | List | High | Sometimes | Yes |
| B03-Q085 | Have you ever had a "Concussion" or TBI? | Cognitive and neurological risk tracking. | Number | High | Never | No |
| B03-Q086 | Do you have any "Genetic Test" results (23andMe, etc.)? | Deep biological mapping. | JSON | High | Rarely | No |
| B03-Q087 | What is your "Cholesterol" (LDL/HDL) profile? | Cardiovascular risk. | String | High | Sometimes | Yes |
| B03-Q088 | What is your "Blood Sugar" (HbA1c) level? | Metabolic risk. | Number | High | Sometimes | Yes |
| B03-Q089 | How often do you see a "Dentist"? | Preventive care compliance. | Enum | Medium | Sometimes | Yes |
| B03-Q090 | What is your "Sun Exposure" habit (Sunscreen use)? | Skin health/cancer risk. | Enum | Medium | Frequently | Yes |
| B03-Q091 | Do you have "Health Insurance"? | Financial health risk. | Boolean | High | Rarely | Yes |
| B03-Q092 | What is the "Longest Life" lived by a direct ancestor? | Genetic potential baseline. | Number | Medium | Never | No |
| B03-Q093 | What is your view on "Biohacking"? | Calibrates aggressiveness of health advice. | String | Medium | Sometimes | Yes |
| B03-Q094 | How often do you "Fast" for >24 hours? | Longevity protocol tracking. | Enum | Medium | Sometimes | Yes |
| B03-Q095 | What is your "Bone Density" status (if known)? | Aging risk. | String | Medium | Rarely | Yes |
| B03-Q096 | Have you ever used "Hormone Replacement" (TRT, HRT)? | Endocrine context. | Boolean | High | Sometimes | Yes |
| B03-Q097 | What is your "Immune System" like (How often do you get sick)? | General resilience metric. | Enum | High | Sometimes | Yes |
| B03-Q098 | What is the "One Health Change" you want to make this year? | Primary health goal. | String | Critical | Frequently | Yes |
| B03-Q099 | Do you have a "Living Will"? | Critical end-of-life context. | Boolean | High | Rarely | Yes |
| B03-Q100 | What is your "Target Lifespan"? | The ultimate goal of Book III. | Number | Critical | Rarely | Yes |

---
---

## Book IV: Finance & Resources (The Fuel)
*Focus: Net worth, budget, investment, and material security.*

### Category: Current Financial State (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B04-Q001 | What is your current "Net Worth"? | The master metric of Book IV. | Number | Critical | Frequently | Yes |
| B04-Q002 | What is your "Total Liquid Cash" available right now? | Measures immediate survival and opportunity capacity. | Number | Critical | Frequently | Yes |
| B04-Q003 | What are your "Monthly Expenses" on average? | Baseline for the "Burn Rate." | Number | Critical | Frequently | Yes |
| B04-Q004 | What is your "Savings Rate" (% of income)? | Measures wealth-building speed. | Number | High | Frequently | Yes |
| B04-Q005 | Do you have an "Emergency Fund"? How many months does it cover? | Measures financial resilience. | Number | Critical | Sometimes | Yes |
| B04-Q006 | What is your current "Credit Score"? | Measures access to leverage and financial reputation. | Number | High | Frequently | Yes |
| B04-Q007 | List all current "Bank Accounts" (Type/Purpose). | Mapping the financial plumbing. | List | High | Rarely | Yes |
| B04-Q008 | What is your primary "Currency" for calculation? | Sets the default financial unit. | String | High | Rarely | No |
| B04-Q009 | What is your "Debt-to-Income" ratio? | Measures financial risk. | Number | High | Sometimes | Yes |
| B04-Q010 | Do you use a "Budgeting App" or system? | Integration context. | String | Medium | Rarely | Yes |
| B04-Q011 | What is your "Annual Tax Liability" estimate? | Critical for cash flow planning. | Number | High | Sometimes | Yes |
| B04-Q012 | Do you have any "Passive Income" streams? | Measures financial independence progress. | List | High | Frequently | Yes |
| B04-Q013 | What is your "Financial Independence" (FI) number? | The target for total financial freedom. | Number | Critical | Rarely | Yes |
| B04-Q014 | What is your "Safe Withdrawal Rate" (SWR) assumption? | Calibrates retirement simulations. | Number | Medium | Rarely | Yes |
| B04-Q015 | How much "Debt" do you currently owe (Total)? | Measures the "Financial Weight." | Number | Critical | Frequently | Yes |
| B04-Q016 | What is the "Interest Rate" on your highest-cost debt? | Priority target for financial optimization. | Number | Critical | Sometimes | Yes |
| B04-Q017 | How many "Days of Freedom" does your current cash provide? | A more intuitive metric of security. | Number | High | Frequently | Yes |
| B04-Q018 | What is your "Financial Personality" (Saver, Spender, Gambler)? | Calibrates Knight's behavioral advice. | Enum | High | Rarely | Yes |
| B04-Q019 | What is your "Main Source" of financial advice? | Maps external influence on wealth. | String | Medium | Sometimes | Yes |
| B04-Q020 | Do you feel "Wealthy" (1-10)? | Subjective financial health metric. | Number | High | Frequently | Yes |

### Category: Assets & Investments (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B04-Q021 | What is the total value of your "Investment Portfolio"? | Measures wealth growth engine. | Number | Critical | Frequently | Yes |
| B04-Q022 | What is your "Asset Allocation" (Stocks, Bonds, Real Estate, Crypto)? | Measures diversification and risk profile. | Map | Critical | Frequently | Yes |
| B04-Q023 | Do you own "Real Estate"? List properties and equity. | Major asset class mapping. | List | High | Sometimes | Yes |
| B04-Q024 | Do you own any "Businesses"? | Entrepreneurial asset mapping. | List | High | Sometimes | Yes |
| B04-Q025 | What is your "Investment Philosophy" (Value, Growth, Index)? | Sets the investment strategy filter. | String | High | Rarely | Yes |
| B04-Q026 | What is your "Risk Tolerance" for a 20% market drop? | Calibrates portfolio aggressiveness. | Enum | Critical | Sometimes | Yes |
| B04-Q027 | Do you hold any "Cryptocurrency"? | Digital asset mapping. | List | Medium | Frequently | Yes |
| B04-Q028 | What "Brokerage Platforms" do you use? | Integration context. | List | Medium | Rarely | Yes |
| B04-Q029 | Do you have a "Retirement Account" (401k, IRA, Super)? | Long-term asset tracking. | List | High | Sometimes | Yes |
| B04-Q030 | What is your "Expected Return" on investments (annual %)? | Calibrates growth projections. | Number | High | Rarely | Yes |
| B04-Q031 | Do you have any "Illiquid Assets" (Art, Collectibles)? | Total net worth context. | List | Low | Sometimes | Yes |
| B04-Q032 | Do you use "Leverage" (Margin) in your investments? | High-risk factor tracking. | Boolean | High | Frequently | Yes |
| B04-Q033 | What is your "Exit Price" for your largest investment? | Pre-plans profit-taking. | Number | High | Sometimes | Yes |
| B04-Q034 | Do you have "Pre-IPO" shares or options? | Potential future wealth mapping. | List | Medium | Sometimes | Yes |
| B04-Q035 | How much "Gold/Precious Metals" do you own? | Hedging strategy mapping. | Number | Low | Sometimes | Yes |
| B04-Q036 | What is the "Dividend Yield" of your portfolio? | Cash flow tracking. | Number | Medium | Frequently | Yes |
| B04-Q037 | Do you have a "Financial Advisor"? | External control mapping. | Boolean | High | Rarely | Yes |
| B04-Q038 | What is your "Time Horizon" for your investments? | Sets the strategy duration. | Enum | High | Rarely | Yes |
| B04-Q039 | Have you ever "Lost Everything" financially? | Identifies deep-seated trauma and risk aversion. | Boolean | High | Never | No |
| B04-Q040 | What is the "Asset" you would never sell? | Identifies core emotional/strategic holdings. | String | High | Rarely | Yes |

### Category: Cash Flow & Budgeting (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B04-Q041 | What is your "Highest Recurring Expense"? | Target for cost optimization. | String | High | Frequently | Yes |
| B04-Q042 | How much do you spend on "Food" monthly? | Lifestyle and health impact cost. | Number | Medium | Frequently | Yes |
| B04-Q043 | What are your total "Subscription Costs" per month? | Identifies "Subscription Creep." | Number | Medium | Frequently | Yes |
| B04-Q044 | How much "Tax" did you pay last year? | Financial efficiency metric. | Number | High | Rarely | Yes |
| B04-Q045 | Do you use "Credit Cards"? Do you pay the full balance? | Debt management behavior. | Enum | High | Frequently | Yes |
| B04-Q046 | What is your "Daily Spending Limit" (Mental or Hard)? | Behavioral constraint mapping. | Number | Medium | Sometimes | Yes |
| B04-Q047 | How much do you spend on "Travel" annually? | Lifestyle and values cost. | Number | Medium | Rarely | Yes |
| B04-Q048 | Do you "Auto-invest" a portion of your income? | Automation level of wealth building. | Boolean | High | Rarely | Yes |
| B04-Q049 | What is your "Largest Discretionary Purchase" ever? | Measures spending ceiling and impulsivity. | String | Low | Rarely | Yes |
| B04-Q050 | How often do you "Review" your finances? | Financial literacy and engagement metric. | Enum | High | Sometimes | Yes |
| B04-Q051 | Do you have any "Dependents" financially? | Critical cost constraint. | Number | Critical | Rarely | Yes |
| B04-Q052 | What is the "Cost of your Routine"? | Baseline survival cost. | Number | High | Frequently | Yes |
| B04-Q053 | Do you "Donate" to charity? What % of income? | Values-based spending mapping. | Number | Medium | Sometimes | Yes |
| B04-Q054 | How much "Cash" do you keep under the mattress? | Alternative security mapping. | Number | Low | Sometimes | Yes |
| B04-Q055 | What is your "Tax Minimization" strategy? | Financial efficiency protocol. | String | High | Rarely | Yes |
| B04-Q056 | Do you use "Cash" or "Card" for most transactions? | Data capture and privacy preference. | Enum | Low | Sometimes | Yes |
| B04-Q057 | What is your "Impulse Buy" trigger? | Behavioral risk mapping. | String | Medium | Sometimes | Yes |
| B04-Q058 | How do you feel after a "Big Purchase"? | Emotional financial health mapping. | String | Medium | Frequently | Yes |
| B04-Q059 | What is the "Expense" you most regret? | Identifies past misalignments. | String | Low | Rarely | Yes |
| B04-Q060 | What is the "Expense" that brings you the most joy? | Identifies high-value lifestyle choices. | String | Medium | Sometimes | Yes |

### Category: Insurance & Protection (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B04-Q061 | Do you have "Health Insurance"? | Critical risk mitigation. | Boolean | Critical | Rarely | Yes |
| B04-Q062 | Do you have "Life Insurance"? What is the coverage? | Family security mapping. | Number | High | Rarely | Yes |
| B04-Q063 | Do you have "Disability Insurance"? | Career and income protection. | Boolean | High | Rarely | Yes |
| B04-Q064 | Do you have "Home/Renter Insurance"? | Asset protection. | Boolean | Medium | Rarely | Yes |
| B04-Q065 | Do you have "Auto Insurance"? | Liability protection. | Boolean | Medium | Rarely | Yes |
| B04-Q066 | Do you have an "Umbrella Policy"? | High-net-worth liability protection. | Boolean | Low | Rarely | Yes |
| B04-Q067 | Who is the "Beneficiary" of your assets? | Critical legal and social mapping. | List | Critical | Rarely | Yes |
| B04-Q068 | Do you have a "Will" or "Trust"? | Legal asset continuity. | Boolean | Critical | Rarely | Yes |
| B04-Q069 | What is your "Identity Theft" protection level? | Digital and financial security. | Enum | Medium | Sometimes | Yes |
| B04-Q070 | Have you ever filed "Bankruptcy"? | Major financial trauma/history. | Boolean | High | Never | No |
| B04-Q071 | Where are your "Essential Documents" stored (Safe, Cloud)? | Emergency access mapping. | String | High | Rarely | Yes |
| B04-Q072 | Do you have a "Power of Attorney"? | Emergency control mapping. | Boolean | High | Rarely | Yes |
| B04-Q073 | What is your "Security Protocol" for banking (2FA, etc.)? | Financial security baseline. | String | Critical | Sometimes | Yes |
| B04-Q074 | How often do you "Back Up" your financial data? | Continuity mapping. | Enum | Medium | Frequently | Yes |
| B04-Q075 | Do you have "Audit" insurance or support? | Tax risk mitigation. | Boolean | Low | Rarely | Yes |
| B04-Q076 | What is the "Worst Case Scenario" you are insured against? | Identifies the limits of protection. | String | High | Rarely | Yes |
| B04-Q077 | Do you have "Key Man" insurance (if business owner)? | Business continuity. | Boolean | Medium | Rarely | Yes |
| B04-Q078 | What is the "Asset" that is currently UNINSURED? | Identifies risk gaps. | List | High | Frequently | Yes |
| B04-Q079 | Do you trust the "Banking System" (1-10)? | Identifies alternative asset needs (Crypto/Gold). | Number | Medium | Rarely | Yes |
| B04-Q080 | Who has "Emergency Access" to your funds? | Critical social and financial node. | String | Critical | Rarely | Yes |

### Category: Strategy, Legacy & Values (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B04-Q081 | What is your "Primary Financial Goal" right now? | Immediate strategic focus. | String | Critical | Frequently | Yes |
| B04-Q082 | What does "Financial Freedom" mean to you specifically? | Calibrates the "Winning Condition." | String | Critical | Rarely | Yes |
| B04-Q083 | What is your "Inheritance" plan for your children/heirs? | Legacy mapping. | String | High | Rarely | Yes |
| B04-Q084 | What is your "Charitable Giving" goal for your lifetime? | Contribution mapping. | Number | Medium | Sometimes | Yes |
| B04-Q085 | How much of your net worth is "Digital" vs "Physical"? | Measures systemic risk. | Map | Medium | Frequently | Yes |
| B04-Q086 | What is the "Money Mindset" you learned from your parents? | Identifies inherited biases. | String | High | Never | No |
| B04-Q087 | Do you believe money can buy "Happiness"? | Philosophical financial filter. | Boolean | Medium | Rarely | No |
| B04-Q088 | What is the "Financial Metric" you track daily? | Identifies the owner's focus. | String | High | Sometimes | Yes |
| B04-Q089 | If you received $1M tomorrow, how would you spend it? | Identifies priorities and desires. | Map | Critical | Sometimes | Yes |
| B04-Q090 | What is the "Expensive Hobby" you allow yourself? | Identifies high-value lifestyle choices. | String | Low | Sometimes | Yes |
| B04-Q091 | Do you "Barter" or trade services? | Alternative economy mapping. | Boolean | Low | Sometimes | Yes |
| B04-Q092 | What is your "Financial Advice" to your younger self? | Extracts core financial wisdom. | String | Medium | Never | No |
| B04-Q093 | What is the "Market Event" you fear most? | Identifies psychological stress triggers. | String | High | Sometimes | Yes |
| B04-Q094 | How do you define "Frugality"? | Behavioral filter for recommendations. | String | Medium | Rarely | No |
| B04-Q095 | What is your "Luxury Limit" (The price where you start asking questions)? | Behavioral constraint mapping. | Number | High | Sometimes | Yes |
| B04-Q096 | How do you handle "Financial Failure"? | Identifies resilience logic. | String | Medium | Rarely | Yes |
| B04-Q097 | What is the "Material Possession" you are most proud of? | Identifies value-to-asset mapping. | String | Low | Rarely | Yes |
| B04-Q098 | What is the "Financial Secret" you keep? | Critical for Knight's complete picture. | String | High | Rarely | Yes |
| B04-Q099 | Do you want to die with "Zero" or with a "Surplus"? | The ultimate financial exit strategy. | Enum | Critical | Rarely | Yes |
| B04-Q100 | What is the "Purpose of Wealth" in your life? | The ultimate conclusion of Book IV. | String | Critical | Rarely | Yes |

---

## Book V: Social & Relationships (The Tribe)
*Focus: Friendships, family, professional network, and social dynamics.*

### Category: Core Circle & Family (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B05-Q001 | Who is your "Closest Person" (Partner/Best Friend)? | The most important node in the social graph. | String | Critical | Rarely | Yes |
| B05-Q002 | How many "Inner Circle" friends do you have? | Measures social depth. | Number | High | Sometimes | Yes |
| B05-Q003 | What is your relationship with your "Parents" (1-10)? | Foundational social context. | Number | High | Sometimes | Yes |
| B05-Q004 | Do you have "Siblings"? What is the relationship status? | Core social node mapping. | List | Medium | Rarely | Yes |
| B05-Q005 | Do you have "Children"? List names and ages. | Primary life-responsibility mapping. | List | Critical | Rarely | Yes |
| B05-Q006 | What is the "Primary Conflict" in your family right now? | Identifies social stress and risks. | String | High | Frequently | Yes |
| B05-Q007 | Who is the "Matriarch/Patriarch" of your extended family? | Identifies family power structures. | String | Low | Rarely | Yes |
| B05-Q008 | How often do you see your "Extended Family"? | Social obligation mapping. | Enum | Medium | Sometimes | Yes |
| B05-Q009 | What "Family Tradition" do you value most? | Identifies cultural/social anchors. | String | Medium | Rarely | No |
| B05-Q010 | Who is the "Person you Trust" with your life? | Identifies ultimate security nodes. | String | Critical | Rarely | Yes |
| B05-Q011 | What is your "Relationship Status" (Single, Married, etc.)? | Core identity and social context. | Enum | Critical | Sometimes | Yes |
| B05-Q012 | How long have you been in your current "Romantic Relationship"? | Relationship stability metric. | Number | High | Frequently | Yes |
| B05-Q013 | What is the "Core Value" you share with your partner? | Measures relationship alignment. | String | High | Rarely | Yes |
| B05-Q014 | What is the biggest "Friction Point" in your marriage/partnership? | Target for relationship coaching/advice. | String | High | Frequently | Yes |
| B05-Q015 | Do you want (more) "Children"? | Long-term life-planning constraint. | Boolean | Critical | Sometimes | Yes |
| B05-Q016 | Who is the "Mentor" within your family? | Identifies wisdom sources. | String | Low | Rarely | Yes |
| B05-Q017 | Have you ever been "Estranged" from a family member? | Identifies social trauma and boundaries. | Boolean | High | Never | No |
| B05-Q018 | What is the "Secret" your family keeps? | Deep social context. | String | Low | Never | No |
| B05-Q019 | How do you handle "Family Holidays"? | Social routine and stress mapping. | String | Medium | Sometimes | Yes |
| B05-Q020 | What is the "Best Advice" your father/mother gave you? | Extracts foundational life-lessons. | String | Medium | Never | No |

### Category: Friendships & Community (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B05-Q021 | Who is your "Oldest Friend"? | Measures long-term social continuity. | String | High | Never | No |
| B05-Q022 | What is the "Common Trait" among all your friends? | Identifies the owner's social preference. | String | High | Rarely | Yes |
| B05-Q023 | How often do you meet friends "In Person"? | Social health metric. | Enum | High | Frequently | Yes |
| B05-Q024 | Do you have a "Third Place" (Cafe, Gym, Club) where you socialize? | Maps social environment. | String | Medium | Sometimes | Yes |
| B05-Q025 | Who is the "Friend who Challenges" you the most? | Identifies growth-oriented nodes. | String | High | Sometimes | Yes |
| B05-Q026 | Have you ever "Fired" a friend? Why? | Identifies social boundaries and values. | String | High | Never | No |
| B05-Q027 | How many "Groups/Communities" are you active in? | Measures social breadth. | Number | Medium | Sometimes | Yes |
| B05-Q028 | What is your "Role" in a group (Leader, Joker, Support)? | Social identity mapping. | Enum | Medium | Rarely | Yes |
| B05-Q029 | Who is the "Friend you can Call" at 3 AM? | Identifies crisis-support nodes. | String | Critical | Rarely | Yes |
| B05-Q030 | What is the "Shared Activity" that defines your friendships? | Identifies social utility. | String | Low | Sometimes | Yes |
| B05-Q031 | Are you a "Giver" or a "Taker" in friendships? | Behavioral self-mapping. | Enum | High | Rarely | Yes |
| B05-Q032 | How many "New Friends" have you made in the last year? | Measures social expansion speed. | Number | Medium | Frequently | Yes |
| B05-Q033 | What is your "Social Battery" recharge method? | Social recovery mapping. | String | High | Sometimes | Yes |
| B05-Q034 | Do you have "International Friends"? | Geographical social graph breadth. | Boolean | Low | Sometimes | Yes |
| B05-Q035 | Who is your "Rival" in your social circle? | Identifies social competition. | String | Low | Sometimes | Yes |
| B05-Q036 | Have you ever been "Betrayed" by a friend? | Identifies social trauma. | Boolean | High | Never | No |
| B05-Q037 | What "Subject" do you only discuss with your best friend? | Identifies the deepest trust layer. | String | Medium | Rarely | Yes |
| B05-Q038 | Do you prefer "One-on-One" or "Group" hangouts? | Social interaction preference. | Enum | High | Never | No |
| B05-Q039 | What is the "Gift" you are most proud of giving? | Measures social generosity/intelligence. | String | Low | Rarely | Yes |
| B05-Q040 | How would your friends describe you in "One Word"? | External social identity. | String | High | Sometimes | Yes |

### Category: Professional & Network (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B05-Q041 | Who is your "Professional Mentor"? | Identifies career-influence node. | String | High | Rarely | Yes |
| B05-Q042 | How many "Strategic Connections" do you have? | Measures professional social capital. | Number | High | Sometimes | Yes |
| B05-Q043 | Who is the person you "Admire Most" in your industry? | Identifies success models. | String | Medium | Sometimes | Yes |
| B04-Q044 | What is your "Networking Strategy"? | Optimization for Book II. | String | Medium | Sometimes | Yes |
| B05-Q045 | Who could "Get you a Job" with one phone call? | Measures professional leverage. | List | Critical | Sometimes | Yes |
| B05-Q046 | Do you have a "Professional Nemesis"? | Identifies competitive stress. | String | Low | Sometimes | Yes |
| B05-Q047 | How many "Referrals" did you give last year? | Measures social capital output. | Number | Medium | Frequently | Yes |
| B05-Q048 | What is your "LinkedIn" engagement level? | Digital professional sociality. | Enum | Low | Frequently | Yes |
| B05-Q049 | Who is your "Peer" group for benchmarking success? | Identifies social comparison set. | List | High | Sometimes | Yes |
| B05-Q050 | Have you ever "Mentored" someone else? | Measures leadership/generosity. | Boolean | Medium | Sometimes | Yes |
| B05-Q051 | What is the "Industry Event" you never miss? | Social routine mapping. | String | Low | Rarely | Yes |
| B05-Q052 | How do you handle "Small Talk"? | Social skill mapping. | Enum | Low | Rarely | No |
| B05-Q053 | Who is the "Power Player" you are currently trying to meet? | Identifies social targets. | String | High | Frequently | Yes |
| B05-Q054 | How much "Value" do you bring to your network? | Self-worth mapping. | String | High | Sometimes | Yes |
| B05-Q055 | Do you prefer "Formal" or "Informal" networking? | Social preference. | Enum | Low | Rarely | No |
| B05-Q056 | What is your "First Impression" of people based on? | Identifies social bias. | String | Medium | Rarely | No |
| B05-Q057 | How do you "End" a professional relationship? | Exit-logic mapping. | String | Medium | Rarely | No |
| B05-Q058 | Who is the "Linchpin" in your network? | Identifies critical node dependencies. | String | High | Sometimes | Yes |
| B05-Q059 | Do you have any "International" professional ties? | Geographical network breadth. | Boolean | Low | Sometimes | Yes |
| B05-Q060 | What is your "Digital Reputation"? | Measures external social identity. | String | High | Sometimes | Yes |

### Category: Social Skills & Dynamics (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B05-Q061 | What is your "Conflict Resolution" style? | Critical for social maintenance. | Enum | High | Rarely | No |
| B05-Q062 | How "Persuasive" are you (1-10)? | Social leverage metric. | Number | High | Sometimes | Yes |
| B05-Q063 | Are you a "Good Listener" (1-10)? | Social intelligence metric. | Number | High | Sometimes | Yes |
| B05-Q064 | How do you handle "Gossip"? | Social ethics and boundary mapping. | Enum | Medium | Rarely | No |
| B05-Q065 | What is your "Social Battery" indicator? | Predicts when to stop interacting. | String | High | Sometimes | Yes |
| B05-Q066 | How do you "Win an Argument"? | Communication strategy mapping. | String | Medium | Rarely | No |
| B05-Q067 | How do you "Apologize"? | Relationship repair logic. | String | High | Rarely | No |
| B05-Q068 | Do you "Trust" people by default? | Foundational social filter. | Boolean | Critical | Never | No |
| B05-Q069 | What is the "Social Situation" you fear most? | Identifies psychological stress. | String | High | Sometimes | Yes |
| B05-Q070 | How do you handle "Awkward Silence"? | Social comfort mapping. | String | Low | Rarely | No |
| B05-Q071 | What is your "Public Image" vs "Private Image"? | Measures social performativity. | String | High | Sometimes | Yes |
| B05-Q072 | Are you "Charismatic" (1-10)? | Social gravity metric. | Number | Medium | Sometimes | Yes |
| B05-Q073 | How often do you "Lie" socially (White lies)? | Social ethics mapping. | Enum | Medium | Sometimes | Yes |
| B05-Q074 | How do you "Read" a room? | Social awareness metric. | String | Medium | Rarely | No |
| B05-Q075 | What is your "Social Legacy" (What people will say at your funeral)? | Ties social to Identity (Book I). | String | High | Rarely | Yes |
| B05-Q076 | How do you handle "Envy"? | Emotional social mapping. | String | Medium | Sometimes | Yes |
| B05-Q077 | Do you "Bridge" different social groups? | Measures social brokerage. | Boolean | High | Sometimes | Yes |
| B05-Q078 | What is the "Boundaries" you set with others? | Social security mapping. | List | High | Sometimes | Yes |
| B05-Q079 | How do you "Imprint" on new people? | First-impression logic. | String | Low | Rarely | No |
| B05-Q080 | What is the "Social Skill" you most want to improve? | Targets Book VII learning. | String | High | Frequently | Yes |

### Category: Legacy & Impact (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B05-Q081 | What is the "Greatest Gift" you have ever received? | Measures social gratitude. | String | Low | Never | No |
| B05-Q082 | Who is the person you have "Helped" the most? | Measures social contribution. | String | Medium | Sometimes | Yes |
| B05-Q083 | What "Social Cause" do you support? | Values-based sociality. | String | Medium | Sometimes | Yes |
| B05-Q084 | What is the "Rumor" about you that is actually true? | Identifies social reality vs perception. | String | High | Rarely | Yes |
| B05-Q085 | Who is the person you "Miss" most? | Emotional social mapping. | String | Medium | Frequently | Yes |
| B05-Q086 | What is the "Social Regret" you carry? | Social learning mapping. | String | High | Rarely | Yes |
| B05-Q087 | If you died tomorrow, who would "Carry your Torch"? | Legacy node mapping. | String | Critical | Rarely | Yes |
| B05-Q088 | What is the "Tradition" you want your children to keep? | Social continuity mapping. | String | Medium | Rarely | No |
| B05-Q089 | Who is the "Person you are Most Proud of"? | Measures social values. | String | Low | Frequently | Yes |
| B05-Q090 | What is the "Social Rule" you always break? | Identifies social rebellion/individuality. | String | Low | Rarely | No |
| B05-Q091 | How do you want to be "Remembered" by your peers? | Social legacy. | String | High | Rarely | Yes |
| B05-Q092 | What is the "Community" you would die for? | Measures ultimate social loyalty. | String | Critical | Never | No |
| B05-Q093 | Who is the person you "Need to Forgive"? | Social debt/emotional weight. | String | High | Frequently | Yes |
| B05-Q094 | Who is the person you "Need to Ask for Forgiveness"? | Social debt/guilt mapping. | String | High | Frequently | Yes |
| B05-Q095 | What is your "Social Superpower"? | Identifies the core social advantage. | String | High | Rarely | Yes |
| B05-Q096 | How do you "Vet" new people before they enter your inner circle? | Social security protocol. | String | High | Rarely | No |
| B05-Q097 | What is the "Social Burden" you carry for others? | Measures social stress/responsibility. | String | Medium | Sometimes | Yes |
| B05-Q098 | Who is your "Anchor" in the world? | Ultimate stability node. | String | Critical | Rarely | Yes |
| B05-Q099 | What is the "Social Truth" you have discovered? | Extracts social wisdom. | String | Medium | Rarely | No |
| B05-Q100 | What is the "Purpose of People" in your life? | The ultimate conclusion of Book V. | String | Critical | Rarely | Yes |

---
---

## Book VI: Philosophy & Ethics (The Compass)
*Focus: Moral framework, ethical dilemmas, worldview, and logic.*

### Category: Ethical Framework & Logic (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B06-Q001 | Are you primarily a Utilitarian, Deontologist, or Virtue Ethicist? | Defines the foundational logic for moral decisions. | Enum | Critical | Rarely | No |
| B06-Q002 | What is your "First Principle" for deciding right from wrong? | The highest-level heuristic for Knight's ethical engine. | String | Critical | Rarely | No |
| B06-Q003 | How do you define "Justice"? | Context for social and legal reasoning. | String | High | Rarely | No |
| B06-Q004 | What is your stance on "The Trolley Problem"? | Tests the boundaries of your ethical framework. | Enum | Medium | Never | No |
| B06-Q005 | Do you believe in "Absolute Truth" or "Relativism"? | Calibrates how Knight presents facts vs. opinions. | Enum | High | Rarely | No |
| B06-Q006 | What is the "Highest Good" in a human life? | The target for moral alignment. | String | Critical | Rarely | No |
| B06-Q007 | Do the "Ends justify the Means"? | Critical constraint for strategic planning. | Boolean | Critical | Rarely | No |
| B06-Q008 | What is your view on "Free Will" vs. "Determinism"? | Influences how Knight frames responsibility and choices. | Enum | Medium | Never | No |
| B06-Q009 | What is the role of "Intuition" in your ethics? | Calibrates how much Knight should trust "Gut Feelings." | Enum | Medium | Sometimes | Yes |
| B06-Q010 | How do you handle "Ethical Gray Areas"? | Defines the "Uncertainty Protocol" for moral advice. | String | High | Sometimes | Yes |
| B06-Q011 | What is your definition of "Evil"? | Identifying the ultimate negative boundary. | String | High | Rarely | No |
| B06-Q012 | Do you believe in "Karma" or cosmic justice? | Influences expectations of outcomes. | Boolean | Medium | Never | No |
| B06-Q013 | What is your stance on "Sacrifice"? | Mapping the willingness to incur loss for a greater good. | String | High | Rarely | No |
| B06-Q014 | How do you weigh "Individual Rights" vs "Collective Good"? | Context for political and social decisions. | Enum | High | Rarely | No |
| B06-Q015 | What is your "Code of Honor"? | Identifying the self-imposed rules of behavior. | List | Critical | Rarely | Yes |
| B06-Q016 | How do you determine "Moral Status" (Animals, AI, Environment)? | Sets boundaries for empathy and resource allocation. | String | High | Sometimes | Yes |
| B06-Q017 | Is "Ignorance" an excuse for unethical behavior? | Defines the standard of accountability. | Boolean | Medium | Never | No |
| B06-Q018 | What is your view on "Redemption"? | Influences how Knight advises on social repair. | String | Medium | Rarely | No |
| B06-Q019 | How do you define "Fairness"? | Calibrates expectations in negotiations and relationships. | String | High | Rarely | No |
| B06-Q020 | What is your "Ethical North Star"? | The ultimate moral compass point. | String | Critical | Rarely | No |

### Category: Worldview & Reality (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B06-Q021 | What is the "Nature of Reality" according to you? | Foundational metaphysical context. | String | Low | Never | No |
| B06-Q022 | Is the universe "Friendly, Hostile, or Indifferent"? | Sets the tone for risk assessment and optimism. | Enum | High | Rarely | No |
| B06-Q023 | What is the "Purpose of Human Consciousness"? | Deepest contextual layer for ambition. | String | Medium | Rarely | No |
| B06-Q024 | Do you believe in "Objective Reality"? | Calibrates evidence-based reasoning. | Boolean | High | Never | No |
| B06-Q025 | What is the most "Beautiful" thing in the world? | Identifies the source of aesthetic and spiritual value. | String | Low | Sometimes | Yes |
| B06-Q026 | What is the role of "Science" in your worldview? | Sets the priority for empirical evidence. | Enum | High | Never | No |
| B06-Q027 | Do you believe in "Miracles" or the supernatural? | Context for interpreting anomalies. | Boolean | Medium | Rarely | No |
| B06-Q028 | What is the "Meaning of Suffering"? | Context for coaching during hardship. | String | High | Rarely | No |
| B06-Q029 | Is "Progress" inevitable or cyclical? | Influences long-term planning expectations. | Enum | Medium | Rarely | No |
| B06-Q030 | What is the "Greatest Threat" to humanity? | Identifies global concerns and priorities. | String | High | Sometimes | Yes |
| B06-Q031 | What is your view on "Technology" as a force for good/evil? | Calibrates Knight's self-image and role. | Enum | Critical | Sometimes | Yes |
| B06-Q032 | How much "Control" do you have over your life? | Measures internal vs. external locus of control. | Number | High | Sometimes | Yes |
| B06-Q033 | What is your view on "Nature" vs. "Nurture"? | Influences how Knight advises on personal change. | Enum | Medium | Rarely | No |
| B06-Q034 | Is the world getting "Better" or "Worse"? | Measures macro-optimism. | Enum | Medium | Sometimes | Yes |
| B06-Q035 | What is the role of "Art" in society? | Value-mapping for entertainment and expression. | String | Low | Rarely | No |
| B06-Q036 | Do you believe in "Soulmates"? | Context for relationship advice. | Boolean | Low | Never | No |
| B06-Q037 | What is the most important "Historical Event" to your worldview? | Identifies the source of learned patterns. | String | Medium | Never | No |
| B06-Q038 | What is the "Ideal Society" in your view? | The ultimate target for political/social contribution. | String | High | Rarely | No |
| B06-Q039 | Is "Power" inherently corrupting? | Influence mapping for career and social moves. | Boolean | Medium | Rarely | No |
| B06-Q040 | What is the "Unanswered Question" that bothers you most? | Directs Book XI (The Unknown). | String | High | Sometimes | Yes |

### Category: Dilemmas & Boundaries (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B06-Q041 | Under what circumstances would you "Lie"? | Defines the boundaries of honesty. | String | Critical | Rarely | No |
| B06-Q042 | Under what circumstances would you "Kill"? | Identifies the ultimate life-preservation boundary. | String | Critical | Never | No |
| B06-Q043 | Under what circumstances would you "Steal"? | Defines the boundaries of property rights. | String | High | Never | No |
| B06-Q044 | Under what circumstances would you "Betray a Friend"? | Identifies the limits of loyalty. | String | High | Never | No |
| B06-Q045 | Would you "Torture" one person to save a million? | Tests the depth of utilitarianism. | Boolean | Medium | Never | No |
| B06-Q046 | How do you handle "Unfairness" when it benefits you? | Measures moral integrity. | String | High | Sometimes | Yes |
| B06-Q047 | What is your stance on "Censorship"? | Context for information filtering. | String | Medium | Rarely | No |
| B06-Q048 | What is the "Price" of your integrity? | Identifies the point of moral collapse. | Number | Critical | Rarely | No |
| B06-Q049 | How do you treat people who can do "Nothing for you"? | The ultimate test of character/empathy. | String | High | Sometimes | Yes |
| B06-Q050 | Do you believe in "Self-Defense" at any cost? | Legal and physical security logic. | Boolean | High | Never | No |
| B06-Q051 | What is your view on "Whistleblowing"? | Integrity vs Loyalty mapping. | String | Medium | Rarely | No |
| B06-Q052 | How do you handle "Conflicting Loyalties"? | Logic for social and professional friction. | String | High | Sometimes | Yes |
| B06-Q053 | Is it ever right to "Break the Law"? | Defines the relationship with societal rules. | String | High | Rarely | No |
| B06-Q054 | What is your "Ethical Line" in business? | Constraint for Book II (Career). | String | Critical | Rarely | No |
| B06-Q055 | How do you balance "Ambition" and "Ethics"? | Strategic constraint for growth. | String | High | Sometimes | Yes |
| B06-Q056 | What is the most "Unethical" thing you have ever done? | Identifying past failures for correction. | String | High | Never | No |
| B06-Q057 | What is the most "Ethical" thing you have ever done? | Identifying peak moral achievement. | String | High | Rarely | Yes |
| B06-Q058 | How do you handle "Hypocrisy" in yourself? | Measures self-awareness and correction. | String | High | Frequently | Yes |
| B06-Q059 | What is your "Rule for Disagreement"? | Logic for civil discourse and conflict. | String | Medium | Rarely | No |
| B06-Q060 | What is the "Moral Obligation" of the wealthy? | Context for Book IV (Finance). | String | High | Sometimes | Yes |

### Category: Spiritual & Transcendent (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B06-Q061 | Do you believe in a "Higher Power"? | Core spiritual context. | Boolean | Critical | Rarely | No |
| B06-Q062 | How do you "Connect" with the transcendent? | Identifies spiritual/meditative routine. | String | Medium | Sometimes | Yes |
| B06-Q063 | What is your view on "Prayer" or "Meditation"? | Activity mapping for recovery and focus. | String | Medium | Sometimes | Yes |
| B06-Q064 | What is the "Sacred" to you? | Identifying the untouchable values/objects. | String | High | Rarely | No |
| B06-Q065 | Have you ever had a "Mystical Experience"? | Major episodic memory context. | String | Low | Never | No |
| B06-Q066 | What is your "Relationship with Death"? | Context for time-management and legacy. | String | High | Sometimes | Yes |
| B06-Q067 | Do you believe in "Reincarnation" or an afterlife? | Long-term existential mapping. | String | Medium | Rarely | No |
| B06-Q068 | What is the role of "Faith" in your life? | Context for reasoning vs. belief. | String | High | Rarely | Yes |
| B06-Q069 | How do you define "Grace"? | Context for forgiveness and social dynamics. | String | Low | Rarely | No |
| B06-Q070 | What is the "Soul" to you? | Identity definition (Book I). | String | Medium | Rarely | No |
| B06-Q071 | Do you have a "Spiritual Mentor"? | Social mapping (Book V). | String | Low | Sometimes | Yes |
| B06-Q072 | What is your favorite "Sacred Text" or Philosophical book? | Foundational source of wisdom. | String | Medium | Rarely | Yes |
| B06-Q073 | How do you handle "Doubt"? | Intellectual and spiritual resilience mapping. | String | High | Sometimes | Yes |
| B06-Q074 | What is the "Sin" you are most prone to? | Behavioral risk mapping. | String | High | Frequently | Yes |
| B06-Q075 | What is your view on "Divine Providence"? | Expectations of future support/safety. | String | Medium | Rarely | No |
| B06-Q076 | How do you define "Enlightenment"? | The ultimate target for wisdom. | String | Low | Rarely | No |
| B06-Q077 | What is the role of "Silence" in your life? | Environmental optimization for reflection. | Enum | Low | Sometimes | Yes |
| B06-Q078 | Do you believe in "Evil Spirits" or personified evil? | Context for irrational fears or cultural beliefs. | Boolean | Low | Never | No |
| B06-Q079 | What is your "Spiritual Community"? | Social mapping (Book V). | String | Medium | Sometimes | Yes |
| B06-Q080 | How do you want your "Funeral" to be conducted? | The ultimate end-of-life protocol. | String | High | Rarely | Yes |

### Category: Wisdom & Applied Philosophy (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B06-Q081 | What is the "Wisest Thing" you have ever done? | Benchmarks peak wisdom. | String | High | Never | No |
| B06-Q082 | What is the "Wisest Thing" someone has ever told you? | Extracts foundational wisdom. | String | High | Never | No |
| B06-Q083 | What is your "Personal Manifesto" (Version 2.0)? | The core rules of your life. | String | Critical | Rarely | Yes |
| B06-Q084 | How do you "Test" a new idea? | Logic and validation protocol. | String | High | Sometimes | Yes |
| B06-Q085 | What is your "Stance on Change"? | Measures adaptability. | Enum | Medium | Sometimes | Yes |
| B06-Q086 | How do you handle "Paradoxes"? | Cognitive mapping for complex issues. | String | Low | Rarely | No |
| B06-Q087 | What is the "Truth" that most people disagree with you on? | Identifies independent thinking. | String | High | Rarely | Yes |
| B06-Q088 | How do you define "Wisdom"? | The target for intellectual growth. | String | High | Rarely | No |
| B06-Q089 | What is the role of "Experience" vs "Study"? | Calibrates learning strategy. | Enum | Medium | Rarely | No |
| B06-Q090 | What is your "Legacy of Thought"? | The ideas you want to leave behind. | String | High | Rarely | Yes |
| B06-Q091 | How do you distinguish between "Urgent" and "Important"? | Time-management logic. | String | Critical | Sometimes | Yes |
| B06-Q092 | What is the "Smallest Thing" that matters most? | Identifies micro-values. | String | Low | Sometimes | Yes |
| B06-Q093 | How do you handle "Success" without ego? | Personality and ethics mapping. | String | Medium | Sometimes | Yes |
| B06-Q094 | How do you handle "Failure" without despair? | Resilience and philosophy mapping. | String | High | Sometimes | Yes |
| B06-Q095 | What is your "Philosophical Razor" (e.g., Occam's Razor)? | Heuristic for simplifying complexity. | String | High | Rarely | No |
| B06-Q096 | How do you define "A Life Well Lived"? | The ultimate goal of the entire Knowledge Base. | String | Critical | Rarely | Yes |
| B06-Q097 | What is the "First Thing" you would teach an AI about humanity? | Core ethical/philosophical value. | String | Critical | Rarely | No |
| B06-Q098 | If you could ask "God" (or the Universe) one question, what would it be? | Identifies the deepest curiosity. | String | High | Rarely | No |
| B06-Q099 | What is the "Truth" you are still running away from? | Identifies the core internal conflict. | String | Critical | Sometimes | Yes |
| B06-Q100 | Who is the "Philosopher" of your own life? | The ultimate conclusion of Book VI. | String | Critical | Rarely | Yes |

---

## Book VII: Skills & Expertise (The Toolbelt)
*Focus: Technical proficiency, cognitive tools, and learning pathways.*

### Category: Technical & Professional Skills (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B07-Q001 | What is your "Primary Professional Skill"? | The core of your career value. | String | Critical | Rarely | Yes |
| B07-Q002 | List all "Software Tools" you are proficient in (>7/10). | Maps technical capacity. | List | High | Frequently | Yes |
| B07-Q003 | What "Programming Languages" do you know? | Digital literacy and creation capacity. | List | High | Sometimes | Yes |
| B07-Q004 | What "Hardware" are you capable of operating? | Physical world interaction capacity. | List | Medium | Sometimes | Yes |
| B07-Q005 | What is your "WPM" (Words Per Minute) typing speed? | Digital input bandwidth metric. | Number | Low | Sometimes | Yes |
| B07-Q006 | Do you have any "Trade Skills" (Carpentry, Electrical)? | Physical self-reliance mapping. | List | Medium | Rarely | Yes |
| B07-Q007 | How many "Languages" can you conduct business in? | Communication breadth. | List | High | Rarely | Yes |
| B07-Q008 | What is your "Mathematics" proficiency level (1-10)? | Analytical baseline. | Number | Medium | Rarely | Yes |
| B07-Q009 | What "Certifications" do you hold? | Formal validation of expertise. | List | High | Sometimes | Yes |
| B07-Q010 | What is your "Most Niche" skill? | Identifies unique competitive advantage. | String | High | Rarely | Yes |
| B07-Q011 | What skill have you "Mastered" but no longer use? | Legacy expertise mapping. | String | Low | Never | No |
| B07-Q012 | What is your "Public Speaking" ability (1-10)? | Influence capacity. | Number | High | Sometimes | Yes |
| B07-Q013 | What "Creative Skills" do you have (Music, Art, Design)? | Expression and ideation capacity. | List | Medium | Sometimes | Yes |
| B07-Q014 | What is your "Writing" ability (1-10)? | Communication and reasoning fidelity. | Number | High | Sometimes | Yes |
| B07-Q015 | What is your "Sales/Persuasion" ability (1-10)? | Capability to move ideas and products. | Number | High | Sometimes | Yes |
| B07-Q016 | What "Management Skills" do you possess? | Leadership and coordination capacity. | List | Medium | Sometimes | Yes |
| B07-Q017 | Do you have any "Survival Skills" (First aid, Camping)? | Emergency resilience mapping. | List | Medium | Rarely | Yes |
| B07-Q018 | What is your "Teaching/Mentoring" ability (1-10)? | Knowledge transmission capacity. | Number | Medium | Sometimes | Yes |
| B07-Q019 | What is your "Research" ability (1-10)? | Information discovery capacity. | Number | High | Sometimes | Yes |
| B07-Q020 | What is the "Skill" you are most famous for in your circle? | Perceived value mapping. | String | High | Rarely | Yes |

### Category: Cognitive & Meta-Skills (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B07-Q021 | What is your primary "Mental Model" for solving problems? | Analytical framework baseline. | String | Critical | Rarely | Yes |
| B07-Q022 | How is your "Focus/Concentration" (1-10)? | Productivity and cognitive health metric. | Number | High | Frequently | Yes |
| B07-Q023 | What is your "Reading Speed" (WPM)? | Information ingestion bandwidth. | Number | Medium | Sometimes | Yes |
| B07-Q024 | How is your "Memory" for names vs. numbers vs. concepts? | Cognitive profile mapping. | Map | Medium | Rarely | Yes |
| B07-Q025 | What is your "Emotional Intelligence" (EQ) score (est. 1-10)? | Social navigation capacity. | Number | High | Sometimes | Yes |
| B07-Q026 | Are you more "Logical" or "Creative"? | Cognitive bias mapping. | Enum | High | Rarely | No |
| B07-Q027 | How do you handle "Information Overload"? | Cognitive stress management. | String | High | Frequently | Yes |
| B07-Q028 | What is your "Decision-Making Speed" (1-10)? | Measures throughput vs. accuracy. | Number | Medium | Sometimes | Yes |
| B07-Q029 | How well do you handle "Ambiguity" (1-10)? | Resilience in complex systems. | Number | High | Sometimes | Yes |
| B07-Q030 | What is your "System 1 vs System 2" balance? | Cognitive heuristic mapping. | Enum | Medium | Rarely | No |
| B07-Q031 | Do you practice "Critical Thinking" frameworks? | Analytical fidelity. | List | High | Sometimes | Yes |
| B07-Q032 | What is your "Pattern Recognition" ability (1-10)? | Synthesis capacity. | Number | High | Rarely | No |
| B07-Q033 | How "Self-Aware" are you (1-10)? | The foundational meta-skill. | Number | Critical | Sometimes | Yes |
| B07-Q034 | What is your "Learning Rate" for new concepts (1-10)? | Future-proofing metric. | Number | High | Sometimes | Yes |
| B07-Q035 | How do you "Deconstruct" a complex problem? | Analytical methodology mapping. | String | High | Rarely | No |
| B07-Q036 | Do you use "Checklists" or other external cognitive aids? | Organizational protocol mapping. | String | Medium | Frequently | Yes |
| B07-Q037 | What is your "Creativity" protocol (How do you get ideas)? | Ideation strategy mapping. | String | Medium | Sometimes | Yes |
| B07-Q038 | How "Skeptical" are you by default (1-10)? | Information filter baseline. | Number | High | Rarely | No |
| B07-Q039 | What is your "Time-Management" system (GTD, Pomodoro)? | Productivity protocol mapping. | String | Critical | Frequently | Yes |
| B07-Q040 | What is your "Focus Environment" (Quiet, Music, Chaos)? | Environmental optimization. | String | Low | Sometimes | Yes |

### Category: Learning & Growth (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B07-Q041 | What is the "Skill" you are currently learning? | Active growth tracking. | String | Critical | Frequently | Yes |
| B07-Q042 | What was the last "Book" you read to learn a skill? | Information source mapping. | String | Medium | Frequently | Yes |
| B07-Q043 | What is your "Learning Budget" (Time/Money) per month? | Growth investment tracking. | Map | High | Sometimes | Yes |
| B07-Q044 | Who is your current "Teacher" or "Mentor"? | Social learning mapping (Book V). | String | High | Sometimes | Yes |
| B07-Q045 | How do you "Validate" that you have learned a skill? | Feedback loop logic. | String | High | Rarely | No |
| B07-Q046 | What "Skill Gap" is currently costing you the most money? | Identifying high-ROI learning targets. | String | Critical | Frequently | Yes |
| B07-Q047 | What is your favorite "Learning Platform" (YouTube, Coursera)? | Resource optimization. | String | Medium | Sometimes | Yes |
| B07-Q048 | Do you prefer "Self-Study" or "Formal Instruction"? | Learning preference mapping. | Enum | High | Rarely | No |
| B07-Q049 | How do you handle "Plateaus" in learning? | Resilience mapping. | String | Medium | Sometimes | Yes |
| B07-Q050 | What is the "Next Skill" on your roadmap? | Future growth planning. | String | High | Sometimes | Yes |
| B07-Q051 | How often do you "Review" what you have learned? | Knowledge retention mapping. | Enum | Medium | Frequently | Yes |
| B07-Q052 | What "Difficulty Level" do you prefer when learning (1-10)? | Optimizes "Flow State" difficulty. | Number | Low | Rarely | No |
| B07-Q053 | Do you "Teach" what you learn to others? | Measures mastery and social contribution. | Boolean | Medium | Sometimes | Yes |
| B07-Q054 | What is the "Hardest Skill" you failed to learn? | Identifies cognitive boundaries or friction. | String | High | Never | No |
| B07-Q055 | How do you "Note-Take"? | Information capture protocol. | String | Medium | Sometimes | Yes |
| B07-Q056 | Do you use "Spaced Repetition" (Anki, etc.)? | Knowledge retention technology. | Boolean | Medium | Sometimes | Yes |
| B07-Q057 | What is your "Deep Work" capacity (hours/day)? | Peak output bandwidth. | Number | High | Frequently | Yes |
| B07-Q058 | How do you stay "Inspired" to learn? | Motivational mapping. | String | Low | Sometimes | Yes |
| B07-Q059 | What is the "Skill" you want your children to learn? | Legacy learning mapping. | String | Medium | Rarely | Yes |
| B07-Q060 | What is the "Future Skill" that doesn't exist yet but you need? | Anticipatory growth mapping. | String | Low | Rarely | Yes |

### Category: Tools & Infrastructure (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B07-Q061 | What is your "Primary Workstation" setup? | Productivity environment mapping. | String | Medium | Rarely | Yes |
| B07-Q062 | What "Mobile Device" do you use most? | Digital interaction context. | String | High | Rarely | Yes |
| B07-Q063 | What is your "Internet Speed" at home? | Digital bandwidth constraint. | Number | Low | Rarely | Yes |
| B07-Q064 | What "AI Tools" do you use daily? | AI-integration mapping. | List | High | Frequently | Yes |
| B07-Q065 | What is your "Backup Strategy" for digital files? | Continuity mapping. | String | High | Rarely | Yes |
| B07-Q066 | What is your "Privacy Setup" (VPN, Browser, etc.)? | Digital security context. | String | Medium | Sometimes | Yes |
| B07-Q067 | What "Subscription" is most critical to your work? | Dependency mapping. | String | High | Sometimes | Yes |
| B07-Q068 | Do you have a "Home Office"? | Professional environment context. | Boolean | Medium | Rarely | Yes |
| B07-Q069 | What is your "Cable Management" style? | Organizational preference. | String | Low | Never | No |
| B07-Q070 | What "Physical Tools" are essential for your hobby? | Resource mapping. | List | Low | Sometimes | Yes |
| B07-Q071 | What is your "Keyboard" of choice? | Input device optimization. | String | Low | Rarely | Yes |
| B07-Q072 | Do you use "Multiple Monitors"? | Information bandwidth optimization. | Number | Low | Rarely | Yes |
| B07-Q073 | What "Operating System" are you most proficient in? | Technical context. | Enum | High | Rarely | Yes |
| B07-Q074 | How many "Devices" are currently in your ecosystem? | Complexity mapping. | Number | Medium | Frequently | Yes |
| B07-Q075 | Do you use "Voice Assistants" (Siri, Alexa)? | Interaction mapping. | Boolean | Low | Sometimes | Yes |
| B07-Q076 | What "Security Hardware" do you use (Yubikey, etc.)? | Deep security context. | List | High | Rarely | Yes |
| B07-Q077 | What is your "Email Management" strategy? | Communication bandwidth optimization. | String | Medium | Frequently | Yes |
| B07-Q078 | What "Note-Taking App" is your "Second Brain"? | Information architecture context. | String | Critical | Sometimes | Yes |
| B07-Q079 | Do you own "Tools" you don't know how to use? | Untapped resource mapping. | List | Low | Sometimes | Yes |
| B07-Q080 | What is the "Best Tool" you have ever bought? | Value-to-tool mapping. | String | Low | Rarely | Yes |

### Category: Mastery & Legacy (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B07-Q081 | What does "Mastery" look like in your field? | Benchmarking the ultimate goal. | String | High | Rarely | No |
| B07-Q082 | Have you ever achieved "Flow State" while working? How? | Identifies the conditions for peak performance. | String | High | Sometimes | Yes |
| B07-Q083 | What is your "Portfolio" of work? | External evidence of skills. | List | High | Frequently | Yes |
| B07-Q084 | Have you ever "Invented" something (Method, Tool, Code)? | Peak creation mapping. | String | Medium | Never | No |
| B07-Q085 | What is the "Legacy Skill" you want to be remembered for? | Strategic alignment with Identity. | String | High | Rarely | Yes |
| B07-Q086 | How do you "Keep your Edge"? | Maintenance protocol for expertise. | String | High | Sometimes | Yes |
| B07-Q087 | What "Industry Standard" do you disagree with? | Independent thinking mapping. | String | Medium | Rarely | Yes |
| B07-Q088 | Who is the "Master" you are following? | Identifies peak performance models. | String | Medium | Sometimes | Yes |
| B07-Q089 | What is your "10-Year Skill" goal? | Long-term expertise target. | String | High | Rarely | Yes |
| B07-Q090 | What is the "Skill" you want to be your 'Third Act' in life? | Late-stage life planning. | String | Low | Rarely | Yes |
| B07-Q091 | How do you handle "Skill Decay"? | Expertise maintenance. | String | Medium | Sometimes | Yes |
| B07-Q092 | What is the "Barrier to Entry" in your niche? | Market context. | String | Medium | Rarely | Yes |
| B07-Q093 | What is the "Hardest Part" of what you do? | Identifying the core difficulty peak. | String | High | Sometimes | Yes |
| B07-Q094 | How many "Hours" have you put into your primary skill? | Measures depth of expertise. | Number | High | Frequently | Yes |
| B07-Q095 | What is your "Signature Move" or unique style? | Identifies the "Art" in the skill. | String | Medium | Rarely | Yes |
| B07-Q096 | Do you have a "Successor"? | Skill continuity mapping. | String | Low | Rarely | Yes |
| B07-Q097 | What is the "Book" that every beginner in your field must read? | Resource curation. | String | Medium | Rarely | No |
| B07-Q098 | What is the "Question" a master would ask that a beginner wouldn't? | Measures depth of understanding. | String | High | Rarely | Yes |
| B07-Q099 | What is the "One Truth" about your skill most people miss? | Extracts core expertise wisdom. | String | Critical | Rarely | No |
| B07-Q100 | Who is the "Expert" you strive to become? | The ultimate conclusion of Book VII. | String | Critical | Rarely | Yes |

---
---

## Book VIII: History & Archives (The Ledger)
*Focus: Chronological narrative, major life events, journals, and archives.*

### Category: Early Life & Roots (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B08-Q001 | What is your "First Memory"? | Identifying the origin of consciousness and earliest emotional imprint. | String | Low | Never | No |
| B08-Q002 | Where did you spend your "First 10 Years"? | Environmental and cultural baseline. | String | High | Never | No |
| B08-Q003 | Who was your "Best Friend" in childhood? | Earliest social influence node. | String | Medium | Never | No |
| B08-Q004 | What was the "House" you grew up in like? | Environmental context and nostalgia anchor. | String | Low | Never | No |
| B08-Q005 | What was the "Primary Emotion" of your childhood home? | Foundational psychological atmosphere. | Enum | High | Never | No |
| B08-Q006 | What was your "Favorite Toy" or game as a child? | Identifies early interests and cognitive play style. | String | Low | Never | No |
| B08-Q007 | What was your "School Experience" like (1-10)? | Foundational educational and social context. | Number | Medium | Never | No |
| B08-Q008 | Who was the "First Teacher" who believed in you? | Early mentor mapping. | String | Medium | Never | No |
| B08-Q009 | What was your "Dream Job" at age 10? | Early ambition baseline. | String | Low | Never | No |
| B08-Q010 | Did you have any "Childhood Pets"? | Early emotional bond and responsibility mapping. | List | Low | Never | No |
| B08-Q011 | What was the "Biggest Trouble" you got into as a kid? | Identifies early boundary-testing and ethics. | String | Medium | Never | No |
| B08-Q012 | What was the "Language" spoken at home? | Core linguistic identity. | String | High | Never | No |
| B08-Q013 | What "Family Tradition" do you remember most clearly? | Cultural continuity mapping. | String | Medium | Never | No |
| B08-Q014 | What was your "Greatest Achievement" before age 18? | Early success peak. | String | Medium | Never | No |
| B08-Q015 | What was your "Biggest Fear" as a child? | Early psychological constraint mapping. | String | Low | Never | No |
| B08-Q016 | How did you spend your "Summer Breaks"? | Early routine and leisure mapping. | String | Low | Never | No |
| B08-Q017 | What was your "First Interaction" with technology? | Origin of digital identity. | String | Medium | Never | No |
| B08-Q018 | Who was the "Person you Admired" most as a child? | Early success models. | String | Medium | Never | No |
| B08-Q019 | What "Historical Event" happened during your childhood that you remember? | Contextualizes life within world history. | String | Low | Never | No |
| B08-Q020 | What is the "Smell" or "Sound" that reminds you most of childhood? | Sensory memory anchor. | String | Low | Never | No |

### Category: Major Life Transitions (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B08-Q021 | What was the "Day you Left Home" like? | First major transition and autonomy marker. | String | High | Never | No |
| B08-Q022 | What was your "First Apartment/House" like? | Early adult environment context. | String | Low | Never | No |
| B08-Q023 | What was your "First Real Job"? | Career origin (Book II). | String | High | Never | No |
| B08-Q024 | Who was your "First Serious Partner"? | Social origin (Book V). | String | Medium | Never | No |
| B08-Q025 | What was the "Most Difficult Move" (Geographical) you have made? | Adaptability and life-friction mapping. | String | Medium | Never | No |
| B08-Q026 | Have you ever lived in "Another Country"? | Global context and adaptability. | List | High | Rarely | Yes |
| B08-Q027 | What was the "Day you Felt like an Adult" for the first time? | Psychological maturity milestone. | String | Medium | Never | No |
| B08-Q028 | What was your "Wedding Day" like (if applicable)? | Major social and legal milestone. | String | Medium | Never | No |
| B08-Q029 | What was the "Birth of your First Child" like (if applicable)? | Major life-responsibility milestone. | String | Critical | Never | No |
| B08-Q030 | Have you ever had a "Mid-Life Crisis" or equivalent? | Major psychological transition. | String | Medium | Rarely | Yes |
| B08-Q031 | What was the "Most Impactful Death" you have experienced? | Loss and resilience context. | String | High | Rarely | Yes |
| B08-Q032 | What was the "Best Year" of your life so far? | Benchmarking peak fulfillment. | Number | High | Sometimes | Yes |
| B08-Q033 | What was the "Worst Year" of your life? | Benchmarking peak resilience/adversity. | Number | High | Sometimes | Yes |
| B08-Q034 | What was the "Most Spontaneous Decision" you ever made? | Measures impulsive risk-taking. | String | Medium | Never | No |
| B08-Q035 | Have you ever "Restarted" your life from scratch? | Measures ultimate resilience and pivot capacity. | Boolean | High | Never | No |
| B08-Q036 | What was the "Meeting" that changed your life trajectory? | Identifies critical social nodes. | String | High | Never | No |
| B08-Q037 | What was the "Mistake" that cost you the most? | Primary lesson-learned context. | String | High | Never | No |
| B08-Q038 | What was the "Day you Discovered your Passion"? | Purpose origin mapping. | String | Critical | Never | No |
| B08-Q039 | Have you ever had a "Near-Death Experience"? | Perspective and risk mapping. | String | High | Never | No |
| B08-Q040 | What was the "Last Major Decision" that felt right? | Current decision-making calibration. | String | High | Frequently | Yes |

### Category: Documentation & Artifacts (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B08-Q041 | Do you keep a "Journal" or Diary? | Primary source for episodic memory. | Boolean | Critical | Frequently | Yes |
| B08-Q042 | Where is your "Photo Archive" stored? | Visual memory index. | String | High | Rarely | Yes |
| B08-Q043 | How many "Physical Journals" do you have? | Analog memory volume. | Number | Medium | Sometimes | Yes |
| B08-Q044 | Do you have a "Personal Blog" or public archive? | Public history mapping. | String | Medium | Sometimes | Yes |
| B08-Q045 | What is the "Oldest Digital File" you still possess? | Digital continuity marker. | String | Low | Never | No |
| B08-Q046 | Do you save "Letters/Emails" of importance? | Social history mapping. | Boolean | Medium | Frequently | Yes |
| B08-Q047 | Do you have a "Box of Memories" (Physical artifacts)? | Physical archive mapping. | String | Low | Rarely | Yes |
| B08-Q048 | What is the "Most Valuable Item" in your personal archive (Non-monetary)? | Identifies emotional anchors. | String | High | Rarely | Yes |
| B08-Q049 | Do you have "Video Footage" of your early life? | High-fidelity history. | Boolean | Low | Never | No |
| B08-Q050 | How often do you "Review" your past records? | History engagement metric. | Enum | Medium | Sometimes | Yes |
| B08-Q051 | Do you have "Genealogical Records" (Family tree)? | Ancestral mapping (Book V). | String | Medium | Rarely | Yes |
| B08-Q052 | Where are your "Official Documents" (Birth cert, etc.)? | Legal and administrative context. | String | Critical | Rarely | Yes |
| B08-Q053 | Do you have a "Medical File" history? | Health history mapping (Book III). | String | High | Rarely | Yes |
| B08-Q054 | Do you save "Tickets" or mementos from events? | Experiential history mapping. | Boolean | Low | Frequently | Yes |
| B08-Q055 | What "Books" from your past do you still own? | Intellectual continuity mapping. | List | Low | Rarely | Yes |
| B08-Q056 | Do you have "Recordings" of your own voice? | Auditory identity mapping. | Boolean | Low | Rarely | Yes |
| B08-Q057 | Have you ever "Written a Memoir" or life summary? | High-level narrative context. | Boolean | High | Rarely | Yes |
| B08-Q058 | How do you "Organize" your digital archives? | Information architecture preference. | String | Medium | Sometimes | Yes |
| B08-Q059 | What is the "Gap" in your personal history documentation? | Directs the search for missing evidence. | String | Medium | Sometimes | Yes |
| B08-Q060 | Who is the "Guardian" of your history besides you? | Social redundancy for memory. | String | High | Rarely | Yes |

### Category: Narratives & Interpretations (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B08-Q061 | What is the "Title" of your life story so far? | Summarizes current identity and narrative. | String | High | Sometimes | Yes |
| B08-Q062 | Who is the "Villain" in your personal history? | Identifies perceived external conflicts/trauma. | String | Medium | Rarely | Yes |
| B08-Q063 | Who is the "Hero" who saved you when you needed it? | Identifies deep social gratitude. | String | High | Never | No |
| B08-Q064 | What is the "Secret" you have never told anyone? | Ultimate trust and identity layer. | String | Critical | Rarely | Yes |
| B08-Q065 | What is the "Regret" that still wakes you up at night? | Identifies unresolved conflicts and lessons. | String | High | Sometimes | Yes |
| B08-Q066 | What is the "Proudest Moment" of your life? | Benchmarking peak internal validation. | String | Critical | Rarely | Yes |
| B08-Q067 | How has your "Narrative of Self" changed in the last 10 years? | Measures psychological growth/shift. | String | High | Rarely | Yes |
| B08-Q068 | What is the "Story" your family tells about you most often? | External narrative vs. internal reality. | String | Medium | Rarely | Yes |
| B08-Q069 | What "Event" would you delete from your history if you could? | Identifies core trauma or embarrassment. | String | Medium | Never | No |
| B08-Q070 | What "Event" was a blessing in disguise? | Identifies the ability to find meaning in hardship. | String | High | Never | No |
| B08-Q071 | How do you define your "Generations" (e.g., Millennial, Gen X)? | Cultural and historical cohort mapping. | Enum | Low | Never | No |
| B08-Q072 | What is the "Historical Era" you wish you lived in? | Identifies cultural and values-based preference. | String | Low | Rarely | No |
| B08-Q073 | What is your "Relationship with your Past Self" (Peaceful/Conflict)? | Psychological health metric. | Enum | High | Sometimes | Yes |
| B08-Q074 | What "Inheritance" (Non-financial) did you receive from your ancestors? | Maps cultural and behavioral legacy. | String | Medium | Never | No |
| B08-Q075 | What is the "Turning Point" in your life? | Identifies the most significant pivot. | String | Critical | Never | No |
| B08-Q076 | How do you handle "Nostalgia"? | Emotional response to history. | Enum | Low | Sometimes | Yes |
| B08-Q077 | What is the "Myth" about yourself that you finally stopped believing? | Identifies breakthroughs in self-awareness. | String | High | Rarely | Yes |
| B08-Q078 | What is the "Legacy" you are currently building? | Connects History to Ambition (Book X). | String | High | Frequently | Yes |
| B08-Q079 | What "Lesson" did you learn too late? | Extracts foundational wisdom (Book VI). | String | High | Never | No |
| B08-Q080 | If you died today, would your "History" feel complete? | The ultimate satisfaction metric. | Boolean | Critical | Frequently | Yes |

### Category: Cycles & Patterns (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B08-Q081 | What "Mistake" have you made more than three times? | Identifies recurring negative patterns. | String | Critical | Frequently | Yes |
| B08-Q082 | What "Success Pattern" do you repeat consistently? | Identifies core strengths and "Winning Formulas." | String | Critical | Frequently | Yes |
| B08-Q083 | What is the "Cycle" you are currently trying to break? | Targets immediate self-improvement. | String | High | Frequently | Yes |
| B08-Q084 | How long is your typical "Life Chapter" (years)? | Predicts future stability/change cycles. | Number | Medium | Rarely | Yes |
| B08-Q085 | What "Seasonal" patterns do you notice in your behavior? | Routine and mental health mapping. | String | Medium | Sometimes | Yes |
| B08-Q086 | How do you "End" things (Relationships, Jobs, Projects)? | Identifies exit-logic and closure patterns. | String | High | Rarely | No |
| B08-Q087 | How do you "Start" things (The first 10% of a project)? | Identifies initiation-logic and excitement patterns. | String | High | Rarely | No |
| B08-Q088 | What is your "Default Response" to a crisis? | Identifies crisis-pattern logic. | String | High | Rarely | No |
| B08-Q089 | Who is the "Type of Person" you consistently attract? | Social pattern mapping (Book V). | String | High | Sometimes | Yes |
| B08-Q090 | What is the "Conflict" you have in every job? | Identifies professional friction patterns. | String | High | Sometimes | Yes |
| B08-Q091 | How has your "Communication Style" evolved over your life? | Measures social skill growth. | String | Medium | Rarely | Yes |
| B08-Q092 | What is the "Value" you have never compromised? | Identifies the core stable pillar of history. | String | Critical | Never | No |
| B08-Q093 | What is the "Habit" you have had the longest? | Identifies core behavioral bedrock. | String | High | Rarely | Yes |
| B08-Q094 | How often do you "Reinvent" yourself? | Measures identity volatility. | Enum | Medium | Sometimes | Yes |
| B08-Q095 | What is the "Peak" of your physical history? | Benchmarking health (Book III). | String | Medium | Never | No |
| B08-Q096 | What is the "Peak" of your intellectual history? | Benchmarking skills (Book VII). | String | Medium | Never | No |
| B08-Q097 | What is the "Peak" of your emotional history? | Benchmarking happiness/fulfillment. | String | Medium | Never | No |
| B08-Q098 | What is the "Low Point" you are most proud of surviving? | Measures ultimate resilience. | String | Critical | Never | No |
| B08-Q099 | What is the "Unfinished Business" in your past? | Targets closure and resolution. | String | High | Frequently | Yes |
| B08-Q100 | What is the "Grand Narrative" of your life? | The ultimate conclusion of Book VIII. | String | Critical | Rarely | Yes |

---

## Book IX: Preferences & Tastes (The Style)
*Focus: Environment, aesthetics, food, entertainment, and comfort.*

### Category: Environmental Preferences (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B09-Q001 | What is your "Ideal Indoor Temperature"? | Environmental optimization. | Number | Medium | Rarely | Yes |
| B09-Q002 | Do you prefer "Bright Light" or "Dim/Warm Light"? | Environmental optimization. | Enum | Low | Rarely | Yes |
| B09-Q003 | What is your "Ideal Level of Noise" for focus? | Productivity optimization. | Enum | High | Sometimes | Yes |
| B09-Q004 | What is your "Favorite Color" (Current)? | Aesthetic and UI optimization. | String | Low | Sometimes | Yes |
| B09-Q005 | Do you prefer "Minimalist" or "Cozy/Cluttered" spaces? | Environmental and lifestyle mapping. | Enum | Medium | Rarely | Yes |
| B09-Q006 | What is your "Ideal Climate" (City/Weather type)? | Geographical and relocation context. | String | High | Rarely | Yes |
| B09-Q007 | Do you prefer "Urban, Suburban, or Rural" living? | Geographical context. | Enum | High | Rarely | Yes |
| B09-Q008 | What is your "Favorite Room" in your current house? | Identifies the comfort anchor. | String | Low | Sometimes | Yes |
| B09-Q009 | What "Scent" makes you feel most relaxed? | Sensory environmental optimization. | String | Low | Rarely | Yes |
| B09-Q010 | Do you prefer "Hard or Soft" furniture? | Physical comfort optimization. | Enum | Low | Rarely | No |
| B09-Q011 | What is your "Ideal View" from a window? | Aesthetic and mental health optimization. | String | Low | Rarely | Yes |
| B09-Q012 | Do you like "Plants" in your environment? | Environmental optimization. | Boolean | Low | Sometimes | Yes |
| B09-Q013 | What is your "Cleaning/Organization" style (1-10)? | Lifestyle and routine mapping. | Number | Medium | Sometimes | Yes |
| B09-Q014 | Do you prefer "Open-Plan" or "Segmented" rooms? | Architectural preference. | Enum | Low | Never | No |
| B09-Q015 | What "Material" (Wood, Metal, Glass) do you like most? | Aesthetic preference. | String | Low | Rarely | No |
| B09-Q016 | Do you prefer "Modern" or "Vintage" aesthetics? | Aesthetic filter for recommendations. | Enum | Medium | Rarely | Yes |
| B09-Q017 | How much "Natural Light" do you require to feel happy? | Mental health and environment mapping. | Enum | High | Rarely | No |
| B09-Q018 | What is your "Pet" preference (Cats, Dogs, None)? | Lifestyle and social mapping. | List | Medium | Rarely | Yes |
| B09-Q019 | Do you prefer "Mountains" or the "Ocean"? | Aesthetic and travel preference. | Enum | Low | Never | No |
| B09-Q020 | What is the "One Object" in your room that must always be there? | Identifies the environmental anchor. | String | Medium | Rarely | Yes |

### Category: Culinary & Sensory Tastes (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B09-Q021 | What is your "Last Meal" choice (The ultimate favorite)? | Identifies core culinary peak. | String | High | Rarely | Yes |
| B09-Q022 | What is your "Comfort Food"? | Emotional and health trigger mapping. | String | Medium | Sometimes | Yes |
| B09-Q023 | What "Cuisine" do you like most (Italian, Japanese, etc.)? | Restaurant and recipe filter. | List | Medium | Sometimes | Yes |
| B09-Q024 | How do you take your "Coffee or Tea"? | Daily routine and micro-preference. | String | High | Rarely | Yes |
| B09-Q025 | What is your "Spice Tolerance" (1-10)? | Culinary filter. | Number | Medium | Rarely | Yes |
| B09-Q026 | What is the "One Food" you absolutely hate? | Culinary constraint. | String | High | Never | No |
| B09-Q027 | Do you prefer "Sweet, Savory, Sour, or Bitter"? | Flavor profile mapping. | Enum | Medium | Rarely | No |
| B09-Q028 | What is your "Favorite Drink" (Non-alcoholic)? | Daily routine mapping. | String | Low | Sometimes | Yes |
| B09-Q029 | What is your "Favorite Alcoholic Drink" (if any)? | Social and entertainment filter. | String | Low | Sometimes | Yes |
| B09-Q030 | Do you prefer "Fine Dining" or "Street Food"? | Values and lifestyle mapping. | Enum | Medium | Sometimes | Yes |
| B09-Q031 | What "Texture" in food do you dislike most? | Culinary constraint. | String | Low | Never | No |
| B09-Q032 | What is your "Go-To Breakfast"? | Routine optimization. | String | Medium | Frequently | Yes |
| B09-Q033 | Do you prefer "Hot" or "Cold" food in general? | Culinary preference. | Enum | Low | Rarely | No |
| B09-Q034 | What is your "Favorite Snack"? | Behavioral trigger mapping. | String | Low | Frequently | Yes |
| B09-Q035 | Do you "Cook" for pleasure or utility? | Lifestyle mapping. | Enum | Medium | Sometimes | Yes |
| B09-Q036 | What "Kitchen Gadget" can you not live without? | Technical and culinary mapping. | String | Low | Rarely | Yes |
| B09-Q037 | What "Scent" reminds you of "Home"? | Emotional sensory anchor. | String | Medium | Never | No |
| B09-Q038 | What "Fabric" (Cotton, Wool, Silk) do you like against your skin? | Comfort and apparel optimization. | List | Low | Rarely | No |
| B09-Q039 | Do you prefer "Hard or Soft" water (for drinking)? | Sensory micro-preference. | Enum | Low | Never | No |
| B09-Q040 | What is the "Most Exotic" thing you have ever eaten? | Measures culinary adventurousness. | String | Low | Never | No |

### Category: Entertainment & Media (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B09-Q041 | What is your "All-Time Favorite Movie"? | Aesthetic and narrative filter. | String | High | Rarely | Yes |
| B09-Q042 | What "Genre" of music do you listen to most? | Entertainment and mood optimization. | List | High | Frequently | Yes |
| B09-Q043 | Who is your "Favorite Author"? | Intellectual and aesthetic filter. | String | High | Sometimes | Yes |
| B09-Q044 | Do you prefer "Non-Fiction" or "Fiction"? | Information ingestion preference. | Enum | High | Rarely | Yes |
| B09-Q045 | What is your "Favorite TV Show" ever? | Narrative preference. | String | Medium | Rarely | Yes |
| B09-Q046 | Do you play "Video Games"? What genre? | Entertainment and cognitive play mapping. | List | Medium | Frequently | Yes |
| B09-Q047 | What is your "Favorite Podcast"? | Current information and influence source. | String | Medium | Frequently | Yes |
| B09-Q048 | Do you prefer "Cinema" or "Watching at Home"? | Entertainment environment preference. | Enum | Low | Sometimes | Yes |
| B09-Q049 | What "Instrument" do you wish you could play? | Aesthetic ambition. | String | Low | Rarely | No |
| B09-Q050 | Who is the "Artist" whose work you would buy if you were rich? | Ultimate aesthetic preference. | String | Medium | Rarely | Yes |
| B09-Q051 | Do you follow any "Sports"? Which ones? | Social and entertainment filter. | List | Medium | Sometimes | Yes |
| B09-Q052 | Do you prefer "Live Performances" or "Recordings"? | Experiential preference. | Enum | Low | Rarely | No |
| B09-Q053 | What is your "Guilty Pleasure" in entertainment? | Identifies "Relaxation" triggers and low-brow tastes. | String | Low | Sometimes | Yes |
| B09-Q054 | What "Art Movement" (Surrealism, Cubism, etc.) do you like? | High-level aesthetic filter. | List | Low | Rarely | No |
| B09-Q055 | How many "Hours of Media" do you consume daily? | Time-management and attention mapping. | Number | High | Frequently | Yes |
| B09-Q056 | Do you "Collect" anything? | Identifies obsessive interests and assets. | String | Medium | Sometimes | Yes |
| B09-Q057 | What "App" do you spend the most time on for fun? | Digital lifestyle mapping. | String | High | Frequently | Yes |
| B09-Q058 | Do you prefer "Subtitles" or "Dubbing"? | Information processing preference. | Enum | Low | Never | No |
| B09-Q059 | What is the "Book" that changed your life? | Major intellectual milestone. | String | Critical | Rarely | Yes |
| B09-Q060 | What "Song" would you want played as you enter a room? | Ultimate "Theme" or vibe. | String | Low | Sometimes | Yes |

### Category: Apparel & Appearance (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B09-Q061 | How would you describe your "Personal Style" in 3 words? | External identity mapping. | List | High | Sometimes | Yes |
| B09-Q062 | What is your "Go-To Outfit" for comfort? | Everyday optimization. | String | Medium | Sometimes | Yes |
| B09-Q063 | What is your "Favorite Clothing Brand"? | Consumer preference. | String | Low | Sometimes | Yes |
| B09-Q064 | Do you prefer "Function" or "Fashion"? | Value mapping for apparel. | Enum | High | Rarely | No |
| B09-Q065 | What "Color" do you wear most often? | Aesthetic identity mapping. | String | Medium | Sometimes | Yes |
| B09-Q066 | How do you feel about "Jewelry/Accessories"? | Aesthetic mapping. | String | Low | Rarely | Yes |
| B09-Q067 | What is your "Shoe" of choice? | Comfort and lifestyle mapping. | String | Low | Sometimes | Yes |
| B09-Q068 | Do you "Dress Up" for work? | Professional identity mapping. | Boolean | Medium | Sometimes | Yes |
| B09-Q069 | What is your "Hair Care" routine? | Self-care and time mapping. | String | Low | Sometimes | Yes |
| B09-Q070 | Do you wear "Perfume/Cologne"? What scent? | Sensory identity mapping. | String | Low | Sometimes | Yes |
| B09-Q071 | What is your view on "Luxury Brands"? | Financial and status values mapping. | Enum | Medium | Rarely | Yes |
| B09-Q072 | Do you prefer "New Clothes" or "Thrifting"? | Values and consumer mapping. | Enum | Low | Sometimes | Yes |
| B09-Q073 | What is your "Watch" preference (Analog, Smart, None)? | Technical and aesthetic mapping. | Enum | Medium | Rarely | Yes |
| B09-Q074 | How much do you spend on "Personal Appearance" monthly? | Financial mapping (Book IV). | Number | Medium | Frequently | Yes |
| B09-Q075 | Do you have any "Tattoos or Piercings"? | Identity and aesthetic mapping. | List | Medium | Rarely | Yes |
| B07-Q076 | What is your "Ideal Hair Length"? | Aesthetic preference. | String | Low | Sometimes | Yes |
| B09-Q077 | Do you "Makeup"? | Aesthetic and time mapping. | Boolean | Low | Frequently | Yes |
| B09-Q078 | What "Hat" style do you prefer? | Aesthetic mapping. | String | Low | Rarely | Yes |
| B09-Q079 | What is your "Worst Fashion Choice" ever? | Past identity learning. | String | Low | Never | No |
| B09-Q080 | If you were a "Character" in a game, what would your 'Skin' be? | Ultimate aesthetic identity. | String | Low | Sometimes | Yes |

### Category: Leisure & Lifestyle (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B09-Q081 | What is your "Ideal Weekend"? | Lifestyle optimization. | String | High | Frequently | Yes |
| B09-Q082 | Do you prefer "Active" or "Relaxing" vacations? | Travel optimization (Book XVIII). | Enum | High | Sometimes | Yes |
| B09-Q083 | What is your "Favorite Hobby" right now? | Active interest tracking. | String | High | Frequently | Yes |
| B09-Q084 | What "Social Activity" do you actually enjoy? | Social optimization (Book V). | String | Medium | Sometimes | Yes |
| B09-Q085 | Do you "Garden" or work with soil? | Environmental activity mapping. | Boolean | Low | Sometimes | Yes |
| B09-Q086 | What "Games" (Board, Card, etc.) do you like? | Social and cognitive play mapping. | List | Low | Sometimes | Yes |
| B09-Q087 | Do you prefer "Reading or Watching"? | Leisure preference. | Enum | Medium | Rarely | No |
| B09-Q088 | What is your "Vacation Destination" of choice? | Travel optimization. | String | High | Sometimes | Yes |
| B09-Q089 | How do you "Decompress" after a hard day? | Recovery and stress-management mapping. | String | Critical | Frequently | Yes |
| B09-Q090 | Do you like "Crowds" or "Solitude"? | Social preference mapping. | Enum | High | Rarely | No |
| B09-Q091 | What is your "Ideal Social Group" size (for fun)? | Social optimization. | Number | Medium | Rarely | No |
| B09-Q092 | Do you "Volunteer" your time? | Values and social contribution mapping. | Boolean | Medium | Sometimes | Yes |
| B09-Q093 | What is your "Favorite Time of Day"? | Routine optimization. | Enum | Low | Rarely | No |
| B09-Q094 | Do you prefer "Planning" or "Spontaneity"? | Lifestyle and routine preference. | Enum | High | Rarely | No |
| B09-Q095 | What is your "Relationship with Nature" (1-10)? | Mental health and travel mapping. | Number | Medium | Sometimes | Yes |
| B09-Q096 | What "Skill" do you do purely for fun? | Identifies "Flow" and play peaks. | String | Medium | Sometimes | Yes |
| B09-Q097 | What is the "Most Fun" you have ever had? | Benchmarking peak leisure. | String | Low | Never | No |
| B09-Q098 | What is your "Guilty Pleasure" habit? | Identifies relaxation and potential risks. | String | Low | Sometimes | Yes |
| B09-Q099 | Do you want to be "Famous" (1-10)? | Ambition and social values mapping. | Number | Medium | Rarely | Yes |
| B09-Q100 | What is the "Essence of Style" according to you? | The ultimate conclusion of Book IX. | String | Critical | Rarely | Yes |

---
---

## Book X: Ambitions & Future (The Horizon)
*Focus: Long-term goals, legacy, bucket list, and the "Ideal Self."*

### Category: Vision & Long-Term Goals (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B10-Q001 | What is your "One Sentence Vision" for your life? | The ultimate strategic target. | String | Critical | Rarely | Yes |
| B10-Q002 | Where do you want to be "Physically" in 10 years? | Geographical and lifestyle target. | String | High | Sometimes | Yes |
| B10-Q003 | What is your "Net Worth" target for age 50/60/70? | Financial target (Book IV). | Number | High | Sometimes | Yes |
| B10-Q004 | What is the "One Achievement" that would make your life feel 'Complete'? | Identifies the "Winning Condition." | String | Critical | Rarely | Yes |
| B10-Q005 | How many "Languages" do you want to speak fluently before you die? | Intellectual ambition. | Number | Medium | Sometimes | Yes |
| B10-Q006 | What is your "Ideal Daily Routine" in your dream life? | The target for lifestyle optimization. | String | High | Sometimes | Yes |
| B10-Q007 | Do you want to "Write a Book"? About what? | Intellectual and legacy ambition. | String | Medium | Sometimes | Yes |
| B10-Q008 | What "Industry" do you want to dominate? | Professional ambition (Book II). | String | High | Sometimes | Yes |
| B10-Q009 | What "Country" do you want to live in eventually? | Geographical ambition. | String | Medium | Sometimes | Yes |
| B10-Q010 | Do you want to "Start a Foundation" or charity? | Contribution and legacy ambition. | String | Medium | Rarely | Yes |
| B10-Q011 | What is your "Dream House" specifically? | Material ambition (Book IV/IX). | String | Low | Sometimes | Yes |
| B10-Q012 | How many "People" do you want to have impacted positively? | Impact and social ambition. | Number | High | Sometimes | Yes |
| B10-Q013 | Do you want to "Go to Space"? | Moonshot ambition. | Boolean | Low | Rarely | No |
| B10-Q014 | What "Award" or recognition do you secretly want to win? | Identifies social validation targets. | String | Medium | Sometimes | Yes |
| B10-Q015 | What is your "Philosophy of Aging"? | Context for health and time-management. | String | High | Rarely | Yes |
| B10-Q016 | Do you want to be "Retired" by a certain age? | Time-management and finance target. | Number | Critical | Sometimes | Yes |
| B10-Q017 | What is your "Moonshot Idea" that sounds crazy? | Identifies high-risk, high-reward creativity. | String | Medium | Sometimes | Yes |
| B10-Q018 | What "Expertise" do you want to be world-class in? | Skill ambition (Book VII). | String | High | Sometimes | Yes |
| B10-Q019 | What is the "Conflict" you want to have resolved by the end of your life? | Emotional and social ambition. | String | High | Sometimes | Yes |
| B10-Q020 | What is the "First Thing" on your current 10-year roadmap? | Immediate strategic focus. | String | Critical | Frequently | Yes |

### Category: Bucket List & Experiences (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B10-Q021 | What are the "Top 3" items on your Bucket List right now? | Immediate experiential goals. | List | High | Frequently | Yes |
| B10-Q022 | What "Wonder of the World" have you not seen yet? | Travel ambition. | String | Medium | Sometimes | Yes |
| B10-Q023 | What "Skill" have you always wanted to learn but haven't? | Skill backlog. | String | Medium | Frequently | Yes |
| B10-Q024 | What "Person" do you want to meet before you die? | Social ambition. | String | Medium | Sometimes | Yes |
| B10-Q025 | What "Physical Feat" do you want to accomplish (e.g., Marathon)? | Health and performance ambition. | String | Medium | Sometimes | Yes |
| B10-Q026 | What "Language" sounds most beautiful to you to learn? | Intellectual/Aesthetic ambition. | String | Low | Rarely | Yes |
| B10-Q027 | Is there a "Mistake" you need to correct before you're done? | Closure and history ambition. | String | High | Sometimes | Yes |
| B10-Q028 | What "Animal" do you want to see in the wild? | Experiential ambition. | String | Low | Rarely | Yes |
| B10-Q029 | What "Event" (e.g., Olympics, Burning Man) do you want to attend? | Social/Cultural ambition. | String | Low | Sometimes | Yes |
| B10-Q030 | What "Extreme Sport" do you want to try once? | Risk-taking ambition. | String | Low | Sometimes | Yes |
| B10-Q031 | What "Instrument" do you want to play a song on? | Aesthetic ambition. | String | Low | Rarely | Yes |
| B10-Q032 | What "Food" have you never tried but want to? | Culinary ambition. | String | Low | Sometimes | Yes |
| B10-Q033 | Do you want to "Live Off-Grid" for a period? | Lifestyle experiment ambition. | Boolean | Low | Rarely | Yes |
| B10-Q034 | What "Historical Site" do you want to walk through? | History/Intellectual ambition. | String | Medium | Sometimes | Yes |
| B10-Q035 | What "Fear" do you want to conquer this year? | Psychological growth ambition. | String | High | Frequently | Yes |
| B10-Q036 | What "Technology" are you waiting for to be invented? | Future context mapping. | String | Medium | Sometimes | Yes |
| B10-Q037 | Do you want to "Mentor" a certain type of person? | Legacy and social ambition. | String | Medium | Sometimes | Yes |
| B10-Q038 | What "Legacy Project" are you currently ignoring? | Identifies procrastination on high-value items. | String | High | Frequently | Yes |
| B10-Q039 | What is the "Smallest Item" on your bucket list? | Identifies easy-win satisfaction. | String | Low | Sometimes | Yes |
| B10-Q040 | If you had "6 Months to Live", what would you do first? | Ultimate priority distillation. | String | Critical | Rarely | Yes |

### Category: The Ideal Self & Growth (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B10-Q041 | Who is the "Ideal Version" of you in 5 years? | The target for self-optimization. | String | Critical | Sometimes | Yes |
| B10-Q042 | What "Trait" of your current self do you want to amplify? | Strength-based growth focus. | String | High | Sometimes | Yes |
| B10-Q043 | What "Trait" of your current self do you want to eliminate? | Weakness-based growth focus. | String | High | Sometimes | Yes |
| B10-Q044 | What "Habit" would the 'Ideal You' have? | Targets Book IX and Book III. | String | High | Frequently | Yes |
| B10-Q045 | What is your "Intellectual North Star"? | The person/idea you follow for wisdom. | String | Medium | Sometimes | Yes |
| B10-Q046 | How "Fit" is the 'Ideal You' (1-10)? | Health target. | Number | High | Sometimes | Yes |
| B10-Q047 | How "Wealthy" is the 'Ideal You' (Net Worth)? | Finance target. | Number | High | Sometimes | Yes |
| B10-Q048 | How "Social" is the 'Ideal You' (1-10)? | Social target. | Number | Medium | Sometimes | Yes |
| B10-Q049 | What "Knowledge" does the 'Ideal You' possess? | Skill/Education target. | List | High | Sometimes | Yes |
| B10-Q050 | How does the 'Ideal You' handle "Conflict"? | Character growth target. | String | Medium | Rarely | No |
| B10-Q051 | What "Routine" does the 'Ideal You' follow? | Lifestyle target. | String | High | Sometimes | Yes |
| B10-Q052 | What is the "Primary Emotion" the 'Ideal You' feels daily? | Emotional target. | Enum | High | Sometimes | Yes |
| B10-Q053 | How does the 'Ideal You' contribute to the world? | Legacy target. | String | High | Sometimes | Yes |
| B10-Q054 | What "Boundary" does the 'Ideal You' enforce? | Identity growth target. | String | Medium | Sometimes | Yes |
| B10-Q055 | What "Addiction/Vice" has the 'Ideal You' overcome? | Risk-mitigation target. | String | High | Sometimes | Yes |
| B10-Q056 | How "Brave" is the 'Ideal You' (1-10)? | Psychological growth target. | Number | Medium | Rarely | No |
| B10-Q057 | What is the "First Impression" the 'Ideal You' makes? | Social identity target. | String | Medium | Sometimes | Yes |
| B10-Q058 | What is the "Success Story" the 'Ideal You' tells? | Future history mapping. | String | High | Sometimes | Yes |
| B10-Q059 | What "Unknown" has the 'Ideal You' resolved? | Knowledge growth target. | String | Medium | Sometimes | Yes |
| B10-Q060 | Are you "Chasing" the 'Ideal You' or "Becoming" them? | Psychological mindset mapping. | Enum | Medium | Sometimes | Yes |

### Category: Legacy & Impact (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B10-Q061 | What is the "One Sentence" on your tombstone? | The ultimate legacy summary. | String | Critical | Rarely | Yes |
| B10-Q062 | Who are the "People" who will carry your values forward? | Continuity node mapping. | List | High | Sometimes | Yes |
| B10-Q063 | What "Organization" will exist because of you? | Institutional legacy. | String | Medium | Rarely | Yes |
| B10-Q064 | What "Knowledge" have you contributed to the world? | Intellectual legacy. | String | High | Sometimes | Yes |
| B10-Q065 | What is the "Problem" you want to have solved for others? | Impact legacy. | String | High | Sometimes | Yes |
| B10-Q066 | How many "Generations" will remember your name? | Ambition scale mapping. | Enum | Medium | Rarely | Yes |
| B10-Q067 | What "Material Legacy" (Trusts, Buildings) will you leave? | Financial legacy. | String | High | Rarely | Yes |
| B10-Q068 | What "Cultural Legacy" (Art, Music) will you leave? | Aesthetic legacy. | String | Low | Rarely | Yes |
| B10-Q069 | What is the "Lesson" you want your grandchildren to know? | Wisdom legacy. | String | High | Rarely | No |
| B10-Q070 | What "Negative Cycle" did you end in your family line? | Generational healing legacy. | String | High | Never | No |
| B10-Q071 | What "Positive Cycle" did you start? | Generational growth legacy. | String | High | Rarely | Yes |
| B10-Q072 | Who would "Speak" at your funeral? | Social impact mapping. | List | Medium | Sometimes | Yes |
| B10-Q073 | What "Secret" will you take to the grave? | Ultimate privacy/identity boundary. | String | Low | Never | No |
| B10-Q074 | How much "Money" do you want to leave behind? | Financial exit strategy. | Number | High | Sometimes | Yes |
| B10-Q075 | What is the "Most Important Thing" you've ever built? | Achievement peak mapping. | String | High | Rarely | Yes |
| B10-Q076 | Does the world "Need" you? Why? | Meaning and contribution mapping. | String | Critical | Sometimes | Yes |
| B10-Q077 | What is the "Moral Impact" of your life? | Ethical legacy. | String | High | Rarely | Yes |
| B10-Q078 | What "Bridge" did you build between people? | Social legacy. | String | Medium | Sometimes | Yes |
| B10-Q079 | What "Truth" did you stand for? | Intellectual/Spiritual legacy. | String | High | Rarely | No |
| B10-Q080 | Are you a "Good Ancestor"? | The ultimate generational metric. | Boolean | Critical | Frequently | Yes |

### Category: Strategy & Tactics (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B10-Q081 | What is the "Primary Constraint" to your 5-year goal? | Identifies the bottleneck for Knight to solve. | String | Critical | Frequently | Yes |
| B10-Q082 | What is the "Next Move" you need to make this month? | Immediate tactical action. | String | Critical | Frequently | Yes |
| B10-Q083 | What is the "Risk" you are currently ignoring? | Critical for Knight's safety/risk engine. | String | High | Frequently | Yes |
| B10-Q084 | What "Resource" (Money, Time, Network) is most scarce? | Optimization constraint. | Enum | High | Frequently | Yes |
| B10-Q085 | Who is the "Ally" you need to recruit? | Social strategic mapping. | String | High | Frequently | Yes |
| B10-Q086 | What "Skill" is the force-multiplier for your vision? | Learning strategy priority. | String | High | Sometimes | Yes |
| B10-Q087 | What is the "Price" you are willing to pay for your goal? | Identifies the limit of sacrifice. | String | High | Rarely | No |
| B10-Q088 | What is the "Plan B" if your primary mission fails? | Resilience and continuity planning. | String | High | Sometimes | Yes |
| B10-Q089 | How do you "Measure" progress toward your vision? | Calibrates Knight's reporting metrics. | String | High | Sometimes | Yes |
| B10-Q090 | What is the "Distraction" you need to cut out? | Productivity optimization. | String | High | Frequently | Yes |
| B10-Q091 | What "Assumptions" is your 10-year plan built on? | Identifies logical risks. | List | High | Sometimes | Yes |
| B10-Q092 | What is the "Probability of Success" (0-100%) you assign to your dream? | Measures confidence vs. realism. | Number | Medium | Frequently | Yes |
| B10-Q093 | How will you "Celebrate" the first milestone? | Motivational mapping. | String | Low | Frequently | Yes |
| B10-Q094 | What is the "Moral Hazard" in your current ambition? | Ethical constraint mapping (Book VI). | String | High | Sometimes | Yes |
| B10-Q095 | Who is your "Competition" for your future state? | Market/Social benchmarking. | String | Medium | Sometimes | Yes |
| B10-Q096 | What is the "First Sign" that your plan is failing? | Early-warning trigger for Knight. | String | High | Sometimes | Yes |
| B10-Q097 | What is the "First Sign" that your plan is succeeding? | Positive feedback trigger for Knight. | String | High | Sometimes | Yes |
| B10-Q098 | How "Adaptable" is your vision to a changing world? | Future-proofing metric. | Number | Medium | Sometimes | Yes |
| B10-Q099 | What is the "Question" you will ask yourself on your deathbed? | The ultimate perspective filter. | String | Critical | Rarely | No |
| B10-Q100 | What is the "Ultimate Horizon" of your life? | The final conclusion of Book X. | String | Critical | Rarely | Yes |

---

## Book XI: The Unknown & Mystery (The Void)
*Focus: Gaps in knowledge, unanswered questions, research, and paradoxes.*

### Category: Knowledge Gaps & Research (Q001-Q020)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B11-Q001 | What is the "One Thing" you don't know but wish you did? | Primary research target. | String | Critical | Frequently | Yes |
| B11-Q002 | What "Subject" do you find most confusing? | Identifies cognitive barriers. | String | Medium | Sometimes | Yes |
| B11-Q003 | What "History" of your family is missing or hidden? | Directs research into Book VIII and V. | String | High | Rarely | Yes |
| B11-Q004 | What is the "Unknown Risk" in your current health? | Directs diagnostic/preventative efforts in Book III. | String | High | Sometimes | Yes |
| B11-Q005 | What "Financial Data" are you currently blind to? | Directs audit/tracking in Book IV. | String | High | Frequently | Yes |
| B11-Q006 | What is the "Truth" about a relationship that you suspect but don't know? | Directs social research in Book V. | String | Medium | Frequently | Yes |
| B11-Q007 | What "Skill" do you have no idea how to even start learning? | Identifies deep skill gaps. | String | Medium | Sometimes | Yes |
| B11-Q008 | What "Law" (Legal or Physical) do you not understand but should? | Directs research into constraints. | String | Medium | Sometimes | Yes |
| B11-Q009 | What "Company" or "Person" is a 'Black Box' to you? | Directs social/market research. | String | Medium | Sometimes | Yes |
| B11-Q010 | What is the "Statistical Probability" of your biggest fear coming true? | Directs risk analysis. | Number | High | Sometimes | Yes |
| B11-Q011 | What "Language" would unlock the most knowledge for you? | Prioritizes Book VII. | String | Medium | Rarely | Yes |
| B11-Q012 | What is the "Source" of your most persistent problem? | Directs root-cause analysis. | String | High | Frequently | Yes |
| B11-Q013 | What "Data Point" would change your mind about your core mission? | Identifies the "Falsification Trigger." | String | Critical | Rarely | Yes |
| B11-Q014 | What "Technology" do you use but don't understand? | Identifies technical dependencies. | String | Medium | Sometimes | Yes |
| B11-Q015 | What "Market" is most mysterious to you? | Directs financial/career research. | String | Low | Sometimes | Yes |
| B11-Q016 | What "Conflict" in the world do you not understand? | Directs worldview research. | String | Low | Sometimes | Yes |
| B11-Q017 | What "Scientific Discovery" are you waiting for? | Identifies external dependencies. | String | Medium | Sometimes | Yes |
| B11-Q018 | What "Document" is missing from your archives? | Directs Book VIII retrieval. | String | Medium | Sometimes | Yes |
| B11-Q019 | What is the "Price" of the information you are missing? | Measures the value of research. | Number | Medium | Frequently | Yes |
| B11-Q020 | What is the "First Step" to resolving your biggest unknown? | Immediate research action. | String | Critical | Frequently | Yes |

### Category: Paradoxes & Contradictions (Q021-Q040)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B11-Q021 | What is your "Internal Contradiction" (The two parts of you that fight)? | Identifies core psychological friction. | String | Critical | Sometimes | Yes |
| B11-Q022 | What "Value" do you hold that you consistently break? | Identifies hypocrisy and growth areas. | String | High | Frequently | Yes |
| B11-Q023 | What is the "Paradox of your Career" (e.g., more money, less time)? | Identifies strategic trade-offs. | String | High | Sometimes | Yes |
| B11-Q024 | How can you be "Both X and Y" (e.g., Kind and Cruel)? | Deep identity mapping (Book I). | String | Medium | Rarely | Yes |
| B11-Q025 | What "Truth" do you believe that you cannot prove? | Identifies foundational assumptions. | String | High | Rarely | No |
| B11-Q026 | What "Lie" do you tell yourself most often? | Identifies self-deception and blindspots. | String | Critical | Frequently | Yes |
| B11-Q027 | How do you handle "Cognitive Dissonance" specifically? | Logic and resilience mapping. | String | Medium | Rarely | No |
| B11-Q028 | What is the "Most Irrational" thing you do? | Identifies non-logical behavioral triggers. | String | High | Sometimes | Yes |
| B11-Q029 | What is the "Gap" between your public image and your private self? | Measures social performativity (Book V). | String | High | Sometimes | Yes |
| B11-Q030 | What "Rule" do you follow that you also despise? | Identifies external constraint friction. | String | Medium | Sometimes | Yes |
| B11-Q031 | What "Freedom" feels like a prison? | Identifies complex values/desires. | String | Medium | Sometimes | Yes |
| B11-Q032 | What "Responsibility" makes you feel free? | Identifies alignment with duty. | String | Medium | Sometimes | Yes |
| B11-Q033 | How can you be "Wealthy" but feel "Poor"? | Finance-psychology mapping. | String | High | Sometimes | Yes |
| B11-Q034 | What is the "Most Certain" thing you were once "Most Uncertain" about? | Measures intellectual evolution. | String | Low | Never | No |
| B11-Q035 | What is the "Most Uncertain" thing you were once "Most Certain" about? | Measures intellectual humility/growth. | String | Low | Never | No |
| B11-Q036 | What "Logic" do you use to justify an "Emotional" decision? | Identifies post-hoc rationalization patterns. | String | High | Frequently | Yes |
| B11-Q037 | What is the "Paradox of your Health" (e.g., fit but tired)? | Directs health research (Book III). | String | High | Frequently | Yes |
| B11-Q038 | What "Relationship" is both your strength and your weakness? | Social paradox mapping. | String | High | Sometimes | Yes |
| B11-Q039 | What "Future" do you both want and fear? | Ambition paradox mapping. | String | Critical | Sometimes | Yes |
| B11-Q040 | What is the "Question" that has no answer? | Identifies ultimate philosophical boundaries. | String | Medium | Rarely | No |

### Category: Intuitions & Hypotheses (Q041-Q060)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B11-Q041 | What is your "Gut Feeling" about the next 12 months? | Measures intuition vs. data. | String | Medium | Frequently | Yes |
| B11-Q042 | What "Hypothesis" are you currently testing in your life? | Active life-experiment tracking. | String | High | Frequently | Yes |
| B11-Q043 | Who do you "Suspect" is a secret ally? | Intuitive social mapping. | String | Low | Sometimes | Yes |
| B11-Q044 | Who do you "Suspect" is a secret rival? | Intuitive social mapping. | String | Low | Sometimes | Yes |
| B11-Q045 | What is your "Hunch" about the future of your industry? | Intuitive career forecasting. | String | Medium | Sometimes | Yes |
| B11-Q046 | Do you have a "Sense" of impending change? | Measures sensitivity to environmental shifts. | Boolean | Medium | Frequently | Yes |
| B11-Q047 | What "Coincidence" has happened too often to be random? | Identifies pattern recognition or superstition. | String | Low | Sometimes | Yes |
| B11-Q048 | What "Internal Voice" do you trust most? | Identifies core internal authority. | Enum | High | Rarely | Yes |
| B11-Q049 | What "Dream" (Sleeping) keeps recurring? | Subconscious mapping. | String | Low | Frequently | Yes |
| B11-Q050 | What "Potential" do others see in you that you don't see yet? | Identifies external vs internal perception gap. | String | High | Sometimes | Yes |
| B11-Q051 | What "Risk" feels safe to you but dangerous to others? | Identifies unique risk-tolerance peak. | String | High | Rarely | Yes |
| B11-Q052 | What "Safety" feels dangerous to you? | Identifies unique risk-aversion peak. | String | High | Rarely | Yes |
| B11-Q053 | What is your "Theory" on why you haven't reached your goal yet? | Identifies internal narrative on failure. | String | Critical | Frequently | Yes |
| B11-Q054 | What "Unseen Force" do you feel influences your life? | Metaphysical/Intuitive mapping. | String | Low | Rarely | Yes |
| B11-Q055 | What is your "Intuition" on the meaning of a recent event? | Contextual interpretation tracking. | String | Medium | Frequently | Yes |
| B11-Q056 | How "Accurate" is your intuition usually (1-10)? | Calibrates Knight's trust in owner's hunches. | Number | High | Sometimes | Yes |
| B11-Q057 | What "Pattern" in your life are you just starting to notice? | Early pattern detection. | String | High | Frequently | Yes |
| B11-Q058 | What "Disruption" is coming that nobody is talking about? | Strategic foresight. | String | Medium | Sometimes | Yes |
| B11-Q059 | What "Idea" do you have that you're afraid to say out loud? | Identifies high-value/high-risk thoughts. | String | High | Sometimes | Yes |
| B11-Q060 | What is the "Next Big Mystery" you want to solve? | Future research target. | String | Medium | Sometimes | Yes |

### Category: Philosophical Mysteries (Q061-Q080)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B11-Q061 | What is "Time" to you? | Deep philosophical context. | String | Low | Never | No |
| B11-Q062 | Does "Infinity" frighten or inspire you? | Existential mapping. | Enum | Low | Never | No |
| B11-Q063 | What is the "Nature of Consciousness" in your view? | Metaphysical mapping. | String | Low | Never | No |
| B11-Q064 | Is the universe "Finite or Infinite"? | Metaphysical context. | Enum | Low | Never | No |
| B11-Q065 | What is the "Origin of Morality"? | Ethical origin mapping (Book VI). | String | High | Never | No |
| B11-Q066 | Do we live in a "Simulation"? | Perspective on reality. | Boolean | Low | Rarely | No |
| B11-Q067 | What is the "Most Mysterious" thing about yourself? | Core identity mystery. | String | High | Sometimes | Yes |
| B11-Q068 | Is "Nothingness" possible? | Metaphysical limit mapping. | Boolean | Low | Never | No |
| B11-Q069 | What is the role of "Chaos" in the universe? | Systemic perspective mapping. | String | Medium | Rarely | No |
| B11-Q070 | What is "Love" beyond biology? | Transcendent social mapping. | String | Medium | Rarely | Yes |
| B11-Q071 | Why is there "Something" rather than "Nothing"? | The ultimate philosophical question. | String | Low | Never | No |
| B11-Q072 | What is the "Darkest Part" of the human condition? | Worldview mapping. | String | High | Rarely | No |
| B11-Q073 | What is the "Brightest Part" of the human condition? | Worldview mapping. | String | High | Rarely | No |
| B11-Q074 | Is "Perfection" possible? | Ambition/Philosophy filter. | Boolean | Medium | Never | No |
| B11-Q075 | What is the "Mystery" you hope is never solved? | Identifies the value of wonder. | String | Low | Rarely | No |
| B11-Q076 | How do you "Exist" in a moment of pure silence? | Sensory and spiritual mapping. | String | Low | Sometimes | Yes |
| B11-Q077 | What is the "Weight of a Secret"? | Ethical and psychological mapping. | String | Medium | Rarely | Yes |
| B11-Q078 | What is the "Geometry" of your thoughts? | Cognitive structure mapping. | String | Low | Rarely | No |
| B11-Q079 | What is "God" to you if you are an atheist (or vice versa)? | Perspective-shifting mapping. | String | Medium | Rarely | No |
| B11-Q080 | What is the "Final Mystery" you expect to encounter? | End-of-life perspective. | String | High | Rarely | Yes |

### Category: Synthesis & Integration (Q081-Q100)
| ID | Question | Purpose | Type | Priority | Update | Dynamic |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| B11-Q081 | How do all 11 Books "Connect" for you? | Integration of the Knowledge Base. | String | Critical | Rarely | Yes |
| B11-Q082 | What is the "Common Thread" through your life history? | Narrative synthesis. | String | Critical | Sometimes | Yes |
| B11-Q083 | What "Question" from another book is actually an Unknown? | Identifies cross-book dependencies. | String | High | Frequently | Yes |
| B11-Q084 | What is the "Sum of your Knowledge" in one word? | Ultimate intellectual distillation. | String | Medium | Sometimes | Yes |
| B11-Q085 | What is the "Difference" between who you were and who you are? | Growth synthesis. | String | High | Rarely | Yes |
| B11-Q086 | What "Legacy" are you most afraid of leaving? | Negative ambition mapping. | String | High | Sometimes | Yes |
| B11-Q087 | What "Truth" have you found that you wish you hadn't? | Burden of knowledge mapping. | String | Medium | Never | No |
| B11-Q088 | What is the "One Piece of Evidence" that would change everything? | Identifies the ultimate leverage point. | String | Critical | Rarely | Yes |
| B11-Q089 | How do you "Balance" all 11 dimensions of your life? | Systemic optimization strategy. | String | High | Frequently | Yes |
| B11-Q090 | What is the "Mystery" of Knight (Your AI) that you want to solve? | AI-owner relationship mapping. | String | Medium | Sometimes | Yes |
| B11-Q091 | What "Unknown" did you resolve today? | Daily learning metric. | String | Medium | Frequently | Yes |
| B11-Q092 | What is the "Pattern of your Failures" across all books? | Root-cause synthesis. | String | High | Sometimes | Yes |
| B11-Q093 | What is the "Pattern of your Successes"? | Strength synthesis. | String | High | Sometimes | Yes |
| B11-Q094 | What "Question" did I not ask that I should have? | Meta-inquiry to expand the bank. | String | Critical | Frequently | Yes |
| B11-Q095 | What is your "Unifying Theory of Self"? | Ultimate Identity synthesis. | String | Critical | Rarely | Yes |
| B11-Q096 | How "Complete" is this Knowledge Base (1-100%)? | Coverage metric. | Number | High | Frequently | Yes |
| B11-Q097 | What is the "First Thing" we will research tomorrow? | Immediate future research plan. | String | High | Frequently | Yes |
| B11-Q098 | What is the "One Word" that describes your 'Unknown'? | Existential distillation. | String | Medium | Sometimes | Yes |
| B11-Q099 | Are you "Ready" to know everything? | Psychological readiness for total memory. | Boolean | Critical | Rarely | Yes |
| B11-Q100 | What is the "End of Mystery"? | The final conclusion of the Question Bank. | String | Critical | Rarely | Yes |

---

**End of Question Bank.**





