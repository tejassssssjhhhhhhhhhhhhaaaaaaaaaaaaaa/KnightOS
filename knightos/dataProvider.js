/**
 * KNIGHTOS Data Provider Abstraction
 * Supports both standalone Mock mode and live Excel Office.js mode.
 */

const MockDataProvider = {
    getEnvironment: () => "DEMO",
    getSystemHealth: async () => ({
        overall: 98,
        status: 'Optimal',
        subsystems: [
            { name: 'ENGINE', status: 'ONLINE', lastSync: 'Just now' },
            { name: 'BRAIN', status: 'ONLINE', lastSync: '1 min ago' }
        ]
    }),
    getDataSummary: async () => ({
        totalRecords: 12482,
        documents: 624,
        recordsByDomain: { finance: 2184, travel: 143, career: 87, documents: 624 }
    }),
    getBrainMetrics: async () => ({ memories: 847, health: 92, entities: 126, relationships: 314 }),
    getRecentActivity: async () => [
        { id: 1, type: 'SYNC', source: 'Gmail', detail: '12 new financial records identified', time: '12:44 PM' },
        { id: 2, type: 'UPDATE', source: 'Calendar', detail: 'Flight AI-101 confirmed', time: '11:30 AM' }
    ],
    getSSoTRecords: async (filter = {}) => {
        let records = [{ id: 'K001', date: '2026-08-16', source: 'GMAIL', title: 'Invoice: Amazon', category: 'FINANCE', conf: '1.0' }];
        if (filter.id) records = records.filter(r => r.id === filter.id);
        return records;
    },
    activateSheet: async (name) => console.log("MOCK: Activating", name),
    teleportToRecord: async (id) => console.log("MOCK: Teleporting to", id),
    updateRecordMetadata: async (id, field, value) => true,
    logInteraction: async (entry) => console.log("MOCK LOG:", entry),
    getConfig: (key) => localStorage.getItem(`knightos_${key}`),
    saveConfig: (key, val) => localStorage.setItem(`knightos_${key}`, val)
};

const ExcelDataProvider = {
    getEnvironment: () => "EXCEL",
    getSystemHealth: async () => {
        return await Excel.run(async (context) => {
            const sheet = context.workbook.worksheets.getItemOrNullObject("90_DIAGNOSTICS");
            await context.sync();
            if (sheet.isNullObject) return { overall: 0, status: 'OFFLINE' };
            const range = sheet.getUsedRange();
            range.load("values");
            await context.sync();
            const vals = range.values;
            let status = "HEALTHY";
            if (vals && vals.length > 1) {
                for (let i = 1; i < vals.length; i++) {
                    if (vals[i][2] === "CRITICAL") { status = "CRITICAL"; break; }
                }
            }
            return { overall: status === "HEALTHY" ? 100 : 50, status };
        });
    },
    getDataSummary: async () => {
        return await Excel.run(async (context) => {
            const ssot = context.workbook.worksheets.getItem("10_SSOT_STORE");
            const range = ssot.getUsedRange();
            range.load("rowCount");
            await context.sync();
            return { totalRecords: range.rowCount - 1, documents: 0, recordsByDomain: { finance: 0 } };
        });
    },
    getBrainMetrics: async () => {
        return await Excel.run(async (context) => {
            const brain = context.workbook.worksheets.getItem("40_KNIGHT_BRAIN");
            brain.load("rowCount");
            await context.sync();
            return { memories: brain.rowCount - 1, health: 100 };
        });
    },
    getSSoTRecords: async (filter = {}) => {
        return await Excel.run(async (context) => {
            const sheet = context.workbook.worksheets.getItem("10_SSOT_STORE");
            const range = sheet.getUsedRange();
            range.load("values");
            await context.sync();
            const values = range.values;
            if (!values || values.length <= 1) return [];
            let records = values.slice(1).map(r => ({
                id: r[0], date: r[1], source: r[2], title: r[3], content: r[4], category: r[5], importance: r[6], conf: r[7]
            }));
            if (filter.id) records = records.filter(r => r.id === filter.id);
            return records;
        });
    },
    activateSheet: async (name) => {
        await Excel.run(async (context) => {
            context.workbook.worksheets.getItem(name).activate();
            await context.sync();
        });
    },
    teleportToRecord: async (id) => {
        await Excel.run(async (context) => {
            const sheet = context.workbook.worksheets.getItem("10_SSOT_STORE");
            const values = sheet.getUsedRange().load("values");
            await context.sync();
            let rowIdx = -1;
            for(let i=0; i<values.values.length; i++) if(values.values[i][0] === id) { rowIdx = i; break; }
            if (rowIdx !== -1) {
                sheet.activate();
                sheet.getRange(`${rowIdx + 1}:${rowIdx + 1}`).select();
            }
            await context.sync();
        });
    },
    updateRecordMetadata: async (id, field, value) => {
        return await Excel.run(async (context) => {
            const sheet = context.workbook.worksheets.getItem("10_SSOT_STORE");
            const values = sheet.getUsedRange().load("values");
            await context.sync();
            let rowIdx = -1;
            for(let i=0; i<values.values.length; i++) if(values.values[i][0] === id) { rowIdx = i; break; }
            if (rowIdx !== -1) {
                const colMap = { 'category': 5, 'importance': 6 };
                const colIdx = colMap[field];
                if (colIdx !== undefined) {
                    sheet.getCell(rowIdx, colIdx).values = [[value]];
                    await context.sync();
                    return true;
                }
            }
            return false;
        });
    },
    logInteraction: async (entry) => {
        try {
            await Excel.run(async (context) => {
                const sheet = context.workbook.worksheets.getItem("AI_CHAT_LOG");
                const lastRow = sheet.getUsedRange().getLastRow().getOffsetRange(1, 0);
                lastRow.values = [[ entry.id, new Date().toISOString(), entry.sender, entry.text, entry.intent || "", entry.evidenceId || "" ]];
                await context.sync();
            });
        } catch (e) {}
    },
    getConfig: (key) => localStorage.getItem(`knightos_${key}`),
    saveConfig: (key, val) => localStorage.setItem(`knightos_${key}`, val)
};

window.DataProvider = (typeof Office !== 'undefined' && Office.context) ? ExcelDataProvider : MockDataProvider;
