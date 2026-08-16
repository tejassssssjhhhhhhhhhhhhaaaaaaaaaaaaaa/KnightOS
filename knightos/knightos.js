/**
 * KNIGHTOS v6.0 CORE OPERATING SYSTEM LOGIC
 * Corrected Architecture: Real Excel Bridge + Grounded Gemini + Truthful Engine.
 */

const GEMINI_CONFIG = {
    model: 'gemini-1.5-flash',
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta'
};

const EngineState = {
    IDLE: 'IDLE',
    PREPARING: 'PREPARING',
    SCANNING: 'SCANNING',
    PROCESSING: 'PROCESSING',
    WRITING: 'WRITING',
    VERIFYING: 'VERIFYING',
    COMPLETE: 'COMPLETE',
    ERROR: 'ERROR'
};

let currentEngineState = EngineState.IDLE;
let engineLogs = [];
let pendingIntakeRecord = null;

// Initialization
if (typeof Office !== 'undefined') {
    Office.onReady(() => safeInit());
} else {
    document.addEventListener('DOMContentLoaded', safeInit);
}

function safeInit() {
    try { initDeviceProfile(); } catch(e) { console.error(e); }
    try { initNavigation(); } catch(e) { console.error(e); }
    try { initChat(); } catch(e) { console.error(e); }
    try { initSettings(); } catch(e) { console.error(e); }
    try { initControls(); } catch(e) { console.error(e); }
    try { initEngine(); } catch(e) { console.error(e); }
    try { initPlanning(); } catch(e) { console.error(e); }
    try { loadDashboardData(); } catch(e) { console.error(e); }
    try { initServiceWorker(); } catch(e) { console.error(e); }

    const hash = window.location.hash.substring(1) || 'home';
    switchView(hash);
}

function initApp() { safeInit(); } // Legacy support

function initDeviceProfile() {
    const dp = window.DataProvider;
    const override = dp.getConfig('device_mode') || 'AUTO';
    const width = window.innerWidth;
    let formFactor = (override === 'AUTO') ? (width <= 600 ? "MOBILE" : (width <= 1024 ? "TABLET" : "DESKTOP")) : override;
    document.body.classList.remove('mobile', 'tablet', 'desktop');
    document.body.classList.add(formFactor.toLowerCase());
}

function initNavigation() {
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', () => {
            const target = item.getAttribute('data-view');
            window.location.hash = target;
            switchView(target);
        });
    });
    window.addEventListener('hashchange', () => {
        const target = window.location.hash.substring(1) || 'home';
        switchView(target);
    });
}

function switchView(target) {
    document.querySelectorAll('.nav-item').forEach(i => i.classList.toggle('active', i.getAttribute('data-view') === target));
    document.querySelectorAll('.view').forEach(v => v.classList.toggle('active', v.id === `view-${target}`));

    if (window.DataProvider.getEnvironment() === "EXCEL") {
        const sheetMap = { 'home': '00_COMMAND_CENTER', 'finance': '10_SSOT_STORE', 'brain': '40_KNIGHT_BRAIN', 'settings': '99_CONFIG' };
        if (sheetMap[target]) window.DataProvider.activateSheet(sheetMap[target]);
    }
}

function initSettings() {
    const dp = window.DataProvider;
    const gKey = document.getElementById('setting-gemini-key');
    const btnSave = document.getElementById('btn-save-settings');
    const btnTest = document.getElementById('btn-test-ai');

    if (gKey) gKey.value = dp.getConfig('gemini_key') || '';

    if (btnSave) {
        btnSave.addEventListener('click', () => {
            dp.saveConfig('gemini_key', gKey.value);
            alert("Settings saved.");
            loadDashboardData();
        });
    }

    if (btnTest) {
        btnTest.addEventListener('click', async () => {
            const key = gKey.value;
            if (!key) return alert("Gemini API Key is required for this test.");
            btnTest.innerText = "TESTING...";
            try {
                const res = await callGemini(key, "Say: KNIGHT ONLINE", "System Verification");
                alert("SUCCESS: " + res);
                updateAIStatusUI(true);
            } catch (e) {
                alert("CONNECTION FAILED: " + e.message);
                updateAIStatusUI(false);
            } finally {
                btnTest.innerText = "Test AI Connection";
            }
        });
    }
}

function initControls() {
    const actionSync = document.getElementById('action-sync');
    if (actionSync) actionSync.addEventListener('click', () => startSyncSimulation());

    const actionUpload = document.getElementById('action-upload');
    if (actionUpload) actionUpload.addEventListener('click', () => switchView('engine'));

    const btnIntakeConfirm = document.getElementById('btn-intake-confirm');
    const btnIntakeCancel = document.getElementById('btn-intake-cancel');
    const overlay = document.getElementById('intake-preview-overlay');

    if (btnIntakeConfirm) btnIntakeConfirm.addEventListener('click', async () => {
        overlay.style.display = 'none';
        await performSSoTWrite(pendingIntakeRecord);
    });

    if (btnIntakeCancel) btnIntakeCancel.addEventListener('click', () => {
        overlay.style.display = 'none';
        logEngineEvent("ENGINE", "CANCEL", "User cancelled import.");
        updateEngineState(EngineState.IDLE, "ENGINE", "Ready", 0);
    });
}

function initEngine() {
    const btnUpload = document.getElementById('btn-upload-trigger');
    const fileInput = document.getElementById('file-intake-input');
    const btnClear = document.getElementById('btn-clear-logs');

    if (btnUpload) btnUpload.addEventListener('click', () => fileInput.click());
    if (fileInput) fileInput.addEventListener('change', (e) => handleFileIntake(e.target.files));
    if (btnClear) btnClear.addEventListener('click', () => {
        engineLogs = [];
        renderEngineLogs();
    });
}

function initPlanning() {
    const btnPlanToday = document.getElementById('btn-plan-today');
    if (btnPlanToday) {
        btnPlanToday.addEventListener('click', () => runPlanningEngine('TODAY'));
    }
}

async function handleFileIntake(files) {
    if (!files.length) return;
    switchView('engine');

    const totalFiles = files.length;
    updateEngineState(EngineState.PREPARING, "Intake", `Preparing ${totalFiles} files...`, 0);

    const dp = window.DataProvider;
    const apiKey = dp.getConfig('gemini_key');

    for (let i = 0; i < totalFiles; i++) {
        const file = files[i];
        const overallProgress = Math.round((i / totalFiles) * 100);

        logEngineEvent("LOCAL_FILE", "UPLOAD", `Received: ${file.name}`);
        updateEngineState(EngineState.PROCESSING, "PARSER", `Extracting text from ${file.name}`, overallProgress);

        let content = "";
        try {
            content = await readFileContent(file);
            logEngineEvent("PARSER", "SUCCESS", `Extracted ${content.length} characters from ${file.name}`);
        } catch (e) {
            logEngineEvent("PARSER", "WARNING", `Content extraction limited for ${file.name}: ${e}`);
            content = file.name; // Fallback
        }

        logEngineEvent("CLASSIFIER", "ANALYZING", `Determining domain for ${file.name}`);

        let domain = 'Documents';
        let reason = 'Default fallback';
        let confidence = null;

        if (apiKey) {
            try {
                const prompt = `Classify this file into one of these domains: Finance, Travel, Career, Life, Tasks, Brain. File: ${file.name}. Content: ${content.substring(0, 500)}. Respond with ONLY a JSON object: {"domain": "...", "reason": "...", "confidence": "0.0-1.0"}`;
                const response = await callGemini(apiKey, prompt, "File Intake");
                const result = JSON.parse(response.replace(/```json|```/g, '').trim());
                domain = result.domain || 'Documents';
                reason = result.reason || 'AI Analysis';
                confidence = result.confidence;
            } catch (e) {
                logEngineEvent("CLASSIFIER", "ERROR", `Gemini classification failed for ${file.name}`);
            }
        }

        logEngineEvent("CLASSIFIER", "COMPLETE", `Mapped to ${domain} (Confidence: ${confidence || 'AI classified'})`);

        pendingIntakeRecord = {
            id: 'K-' + Date.now() + '-' + i,
            date: new Date().toISOString(),
            source: 'UPLOAD',
            title: file.name,
            content: content.substring(0, 1000),
            category: domain,
            importance: 'Normal',
            conf: confidence || "0.0"
        };

        showIntakePreview(pendingIntakeRecord, reason);
        return;
    }
}

async function readFileContent(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        if (file.type === "application/pdf") {
            reject("PDF_TEXT_EXTRACTION_UNAVAILABLE");
        } else {
            reader.onload = (e) => resolve(e.target.result);
            reader.onerror = reject;
            reader.readAsText(file);
        }
    });
}

function updateEngineState(state, source, operation, progress = 0) {
    currentEngineState = state;
    const opName = document.getElementById('engine-op-name');
    const opStatus = document.getElementById('engine-op-status');
    const progressContainer = document.getElementById('engine-progress-container');
    const progressBar = document.getElementById('engine-progress-bar');

    if (opName) opName.innerText = state;
    if (opStatus) opStatus.innerText = `${source}: ${operation}`;

    if (progressContainer) {
        progressContainer.style.display = (state === EngineState.IDLE || state === EngineState.COMPLETE) ? 'none' : 'block';
    }
    if (progressBar) {
        progressBar.style.width = `${progress}%`;
    }
}

function logEngineEvent(source, operation, result) {
    const event = {
        time: new Date().toLocaleTimeString(),
        source,
        operation,
        result
    };
    engineLogs.push(event);
    renderEngineLogs();
}

function renderEngineLogs() {
    const list = document.getElementById('engine-log-list');
    if (!list) return;
    list.innerHTML = engineLogs.map(log => `
        <div style="margin-bottom: 8px; border-bottom: 1px solid #222; padding-bottom: 4px;">
            <span style="color: #666; font-size: 9px;">[${log.time}]</span>
            <span style="color: var(--accent-color); font-weight: bold; margin: 0 5px;">${log.source}</span>
            <span style="color: #4CAF50;">${log.operation}</span>
            <span style="color: #DDD; margin-left: 5px;">${log.result}</span>
        </div>
    `).reverse().join('');
}

function showIntakePreview(record, reason) {
    const overlay = document.getElementById('intake-preview-overlay');
    const content = document.getElementById('intake-preview-content');
    if (!overlay || !content) return;

    content.innerHTML = `
        <p><strong>File:</strong> ${record.title}</p>
        <p><strong>Target Domain:</strong> ${record.category}</p>
        <p><strong>Reason:</strong> ${reason}</p>
        <p><strong>Confidence:</strong> ${record.conf !== "0.0" ? record.conf : 'AI classified'}</p>
        <div style="background: var(--surface-secondary); padding: 12px; border-radius: 10px; font-size: 12px; margin-top: 15px; max-height: 150px; overflow-y: auto; color: var(--text-secondary); border: 1px solid var(--border-color);">
            ${record.content.substring(0, 300)}...
        </div>
    `;
    overlay.style.display = 'flex';
}

async function performSSoTWrite(record) {
    updateEngineState(EngineState.WRITING, "SSOT", `Writing to 10_SSOT_STORE...`, 80);
    const dp = window.DataProvider;

    try {
        await dp.createSSoTRecord(record);
        logEngineEvent("SSOT", "WRITE", `Record ${record.id} written successfully.`);

        updateEngineState(EngineState.VERIFYING, "SSOT", `Verifying write...`, 90);
        const verification = await dp.getSSoTRecords({ id: record.id });

        if (verification.length > 0) {
            logEngineEvent("SSOT", "VERIFIED", `Record confirmed in authoritative store.`);
            updateEngineState(EngineState.COMPLETE, "FINISHED", "Operation complete.", 100);
            await dp.logInteraction({ id: 'LOG-' + Date.now(), sender: 'ENGINE', text: `Imported ${record.title} to ${record.category}` });
            loadDashboardData();
        } else {
            throw new Error("WRITE_VERIFICATION_FAILED");
        }
    } catch (e) {
        logEngineEvent("ENGINE", "ERROR", `Failure: ${e.message}`);
        updateEngineState(EngineState.ERROR, "ENGINE", e.message, 0);
    }
}

async function runPlanningEngine(scope) {
    const dp = window.DataProvider;
    const apiKey = dp.getConfig('gemini_key');
    const container = document.getElementById('planning-results');
    if (!container) return;

    if (!apiKey) {
        container.innerHTML = `<div class="card" style="color:var(--status-red)">Planning requires Gemini configuration in Settings.</div>`;
        return;
    }

    container.innerHTML = `<div class="card">Knight is retrieving SSoT data and reasoning...</div>`;

    try {
        const records = await dp.getSSoTRecords();
        const context = records.slice(0, 20).map(r => `[${r.category}] ${r.title}`).join('\n');

        const prompt = `You are the KnightOS Planning Engine. Review the following SSoT context and produce a concise, structured Daily Plan for the user.
        Focus on priorities and suggested next actions.
        Context:\n${context}`;

        const response = await callGemini(apiKey, prompt, "Planning System");

        container.innerHTML = `
            <div class="card fade-in">
                <div class="card-header">DAILY PLAN — GROUNDED IN SSOT</div>
                <div style="font-size: 14px; line-height: 1.6; white-space: pre-wrap;">${response}</div>
                <button class="btn-confirm" id="btn-plan-today" style="width: 100%; margin-top: 15px;">Refresh Plan</button>
            </div>
        `;
        document.getElementById('btn-plan-today').addEventListener('click', () => runPlanningEngine('TODAY'));
    } catch (e) {
        container.innerHTML = `<div class="card" style="color:var(--status-red)">Planning Error: ${e.message}</div>`;
    }
}

function initChat() {
    const orb = document.getElementById('knight-orb');
    const trigger = document.getElementById('action-ask');
    const input = document.getElementById('chat-input');
    const panel = document.getElementById('chat-panel');
    const close = document.getElementById('chat-close');

    const toggle = () => {
        if (!panel) return;
        panel.style.display = panel.style.display === 'flex' ? 'none' : 'flex';
        if (panel.style.display === 'flex' && input) input.focus();
    };

    if (orb) orb.addEventListener('click', toggle);
    if (trigger) trigger.addEventListener('click', toggle);
    if (close) close.addEventListener('click', () => { if(panel) panel.style.display = 'none'; });

    if (input) {
        input.addEventListener('keypress', async (e) => {
            if (e.key === 'Enter' && input.value.trim() !== '') {
                const userMsg = input.value.trim();
                input.value = '';
                await handleUserMessage(userMsg);
            }
        });
    }
}

async function handleUserMessage(text) {
    appendMessage('user', text);
    const dp = window.DataProvider;
    const apiKey = dp.getConfig('gemini_key');

    if (!apiKey) {
        appendMessage('knight', "AI not configured. Using local rule-based fallback.");
        return processIntentLocally(text);
    }

    try {
        appendMessage('system', 'RETRIEVING SSoT CONTEXT...');
        const records = await dp.getSSoTRecords();
        const context = records.slice(0, 10).map(r => `${r.id}: ${r.title}`).join('\n');

        appendMessage('system', 'KNIGHT IS REASONING...');
        const response = await callGemini(apiKey, text, context);
        appendMessage('knight', response);
        await dp.logInteraction({ id: 'AI-'+Date.now(), sender: 'KNIGHT', text: response });
        updateAIStatusUI(true);
    } catch (e) {
        console.error(e);
        appendMessage('knight', "ERROR: Could not connect to Gemini. Verify your API key in Settings.");
        updateAIStatusUI(false);
    }
}

async function callGemini(key, prompt, context) {
    const url = `${GEMINI_CONFIG.baseUrl}/models/${GEMINI_CONFIG.model}:generateContent?key=${key}`;
    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            contents: [{
                parts: [{
                    text: `You are Knight, a personal Data OS. Answer using the provided SSoT context. If info is missing, say you don't know from data.\n\nContext:\n${context}\n\nUser: ${prompt}`
                }]
            }]
        })
    });
    if (!response.ok) {
        const err = await response.json().catch(() => ({}));
        throw new Error(err.error?.message || "API_ERROR");
    }
    const data = await response.json();
    return data.candidates[0].content.parts[0].text;
}

async function loadDashboardData() {
    const dp = window.DataProvider;
    try {
        const health = await dp.getSystemHealth();
        const mHealth = document.getElementById('metric-health');
        const sHealth = document.getElementById('status-health');
        if (mHealth) mHealth.innerText = `${health.overall}%`;
        if (sHealth) {
            sHealth.innerText = `● ${health.status}`;
            sHealth.style.color = (health.status === "HEALTHY" || health.status === "Optimal") ? "var(--status-green)" : "var(--status-red)";
        }

        const brain = await dp.getBrainMetrics();
        const metricBrain = document.getElementById('metric-brain');
        if (metricBrain) metricBrain.innerText = brain.memories;

        const summary = await dp.getDataSummary();
        const metricRecords = document.getElementById('metric-records');
        if (metricRecords) metricRecords.innerText = summary.totalRecords;

        const aiKey = dp.getConfig('gemini_key');
        updateAIStatusUI(!!aiKey);
    } catch (e) { console.warn("Dashboard sync failed", e); }
}

function updateAIStatusUI(active) {
    const status = document.getElementById('ai-status');
    const label = document.getElementById('ai-status-label');
    if (status) status.innerText = active ? "ONLINE" : "OFF";
    if (label) {
        label.innerText = active ? "Intelligence Active" : "Not Configured";
        label.style.color = active ? "var(--status-green)" : "var(--text-secondary)";
    }
}

function appendMessage(sender, text) {
    const container = document.getElementById('chat-messages');
    if (!container) return;
    const div = document.createElement('div');
    div.className = `msg msg-${sender}`;
    div.innerText = text;
    container.appendChild(div);
    container.scrollTop = container.scrollHeight;
}

function processIntentLocally(text) {
    appendMessage('knight', "Local search results for: " + text);
}

function startSyncSimulation() {
    switchView('engine');
    logEngineEvent("DEMO_SYNC", "START", "Beginning demonstration synchronization.");
    updateEngineState(EngineState.SCANNING, "GMAIL [DEMO]", "Scanning messages...");

    setTimeout(() => {
        logEngineEvent("GMAIL [DEMO]", "SCAN", "Found 12 potentially relevant items.");
        updateEngineState(EngineState.PROCESSING, "CLASSIFIER [DEMO]", "Analyzing intent...");
    }, 1500);

    setTimeout(() => {
        logEngineEvent("SSOT [DEMO]", "WRITE", "Mock records imported.");
        updateEngineState(EngineState.COMPLETE, "FINISHED", "Demo sync successful.", 100);
        loadDashboardData();
    }, 3500);
}

function initServiceWorker() {
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('service-worker.js').catch(() => {});
    }
}
