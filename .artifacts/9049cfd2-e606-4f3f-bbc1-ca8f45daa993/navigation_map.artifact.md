# KNIGHT OS — NAVIGATION MAP

```mermaid
graph TD
    Launch[Splash Screen] --> Home[Home Screen]

    subgraph Shell [Knight Shell]
        Home
        Hub[Hub Screen]
        Assistant[Knight AI Chat]
        Profile[Profile & Settings]
    end

    Home -- "Search" --> Search[Search Screen]
    Home -- "Settings Icon" --> Profile

    Hub -- "Data Hub" --> DataHub[Data Hub Screen]
    Hub -- "Life Atlas" --> Atlas[Life Atlas Screen]
    Hub -- "Planner" --> Planner[Planner Screen]
    Hub -- "Knowledge" --> Knowledge[Knowledge Vault]
    Hub -- "Finance" --> Finance[Finance Screen]
    Hub -- "Health" --> Health[Health Screen]
    Hub -- "Travel" --> Travel[Travel Screen]
    Hub -- "Career" --> Career[Career Dashboard]

    Assistant -- "Settings" --> Profile

    DataHub -- "Diagnostics" --> ImportCenter[Import Center]
    DataHub -- "Brain" --> KnightBrain[My Knight Brain]
```

## Verified Routes
- `/` -> SplashScreen
- `/home` -> HomeScreen
- `/dashboard` -> HubScreen
- `/knight` -> KnightChat
- `/data-hub` -> DataHub
- `/planner` -> PlannerHomeScreen
- `/knowledge-vault` -> KnowledgeVaultScreen
- `/finance` -> FinanceTrackerScreen
- `/health` -> HealthDashboardScreen
- `/travel` -> TravelHomeScreen
- `/career` -> CareerDashboardScreen (Crashes)
- `/profile` -> ProfileScreen
