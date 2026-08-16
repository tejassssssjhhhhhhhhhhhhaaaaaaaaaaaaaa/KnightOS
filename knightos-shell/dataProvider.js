/**
 * KNIGHTOS Data Provider Abstraction
 * Handles data retrieval for the visual shell.
 * Currently uses Mock Data for visual validation.
 */

const MockDataProvider = {
    getSystemHealth: async () => {
        return {
            overall: 98,
            status: 'HEALTHY',
            subsystems: [
                { name: 'GMAIL', status: 'HEALTHY', lastSync: '10 mins ago' },
                { name: 'CALENDAR', status: 'HEALTHY', lastSync: '15 mins ago' },
                { name: 'DRIVE', status: 'HEALTHY', lastSync: '1 hour ago' },
                { name: 'TASKS', status: 'WARNING', lastSync: '2 hours ago', error: 'Sync delay' }
            ]
        };
    },

    getDataSummary: async () => {
        return {
            totalRecords: 12482,
            sources: [
                { name: 'Gmail', count: 8421, icon: 'mail' },
                { name: 'Calendar', count: 642, icon: 'calendar' },
                { name: 'Drive', count: 1205, icon: 'file' },
                { name: 'Contacts', count: 854, icon: 'people' },
                { name: 'Tasks', count: 1360, icon: 'task' }
            ]
        };
    },

    getBrainMetrics: async () => {
        return {
            memories: 847,
            confirmed: 124,
            inferred: 652,
            needsReview: 12,
            conflicts: 3,
            gaps: 7,
            health: 92
        };
    },

    getRecentActivity: async () => {
        return [
            { id: 1, type: 'SYNC', source: 'Gmail', detail: '12 records processed', time: '10:32 AM' },
            { id: 2, type: 'UPDATE', source: 'Calendar', detail: '4 new events', time: '09:45 AM' },
            { id: 3, type: 'BRAIN', source: 'Knight', detail: '2 memories updated', time: '08:15 AM' }
        ];
    },

    getPipelineStages: async () => {
        return [
            { id: 'RECEIVED', count: 5240, status: 'COMPLETE' },
            { id: 'CHECKED', count: 5240, status: 'COMPLETE' },
            { id: 'UNDERSTOOD', count: 5198, status: 'COMPLETE' },
            { id: 'DEDUPLICATED', count: 5021, status: 'PROCESSING' },
            { id: 'IMPORTANCE', count: 4990, status: 'PENDING' },
            { id: 'CATEGORIZED', count: 0, status: 'PENDING' },
            { id: 'SAVED', count: 0, status: 'PENDING' }
        ];
    }
};

window.DataProvider = MockDataProvider;
