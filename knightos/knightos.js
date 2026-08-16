/**
 * KNIGHTOS v6.0 CORE OPERATING SYSTEM LOGIC
 * Restored Architecture: Real Excel Bridge + Grounded Gemini + Mobile UX.
 */

const GEMINI_CONFIG = {
    model: 'gemini-1.5-flash',
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta'
};

// Initialization
if (typeof Office !== 'undefined') {
    Office.onReady(() => initApp());
} else {
    document.addEventListener('DOMContentLoaded', initApp);
}

function initApp() {
    initDeviceProfile();
    initNavigation();
    initChat();
    initSettings();
    initControls();
    loadDashboardData();
    initServiceWorker();

    const hash = window.location.hash.substring(1) || 'home';
    switchView(hash);
}

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
}

function initChat() {
    const orb = document.getElementById('knight-orb');
    const trigger = document.getElementById('action-ask');
    const input = document.getElementById('chat-input');
    const panel = document.getElementById('chat-panel');
    const close = document.getElementById('chat-close');

    const toggle = () => {
        panel.style.display = panel.style.display === 'flex' ? 'none' : 'flex';
        if (panel.style.display === 'flex') input.focus();
    };

    if (orb) orb.addEventListener('click', toggle);
    if (trigger) trigger.addEventListener('click', toggle);
    if (close) close.addEventListener('click', () => panel.style.display = 'none');

    input.addEventListener('keypress', async (e) => {
        if (e.key === 'Enter' && input.value.trim() !== '') {
            const userMsg = input.value.trim();
            input.value = '';
            await handleUserMessage(userMsg);
        }
    });
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
        const context = records.length > 0
            ? records.slice(0, 10).map(r => `${r.id}: ${r.title}`).join('\n')
            : "No records found in SSoT.";

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
        if (mHealth) mHealth.innerText = `${health.overall}%`;

        const metricActivity = document.getElementById('metric-activity');
        if (metricActivity) metricActivity.innerText = health.status;

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
    const logList = document.getElementById('engine-log-list');
    const metricActivity = document.getElementById('metric-activity');
    if (!logList) return;

    metricActivity.innerText = "PROCESSING";
    logList.innerHTML = '<div style="color:var(--accent-color)">[SIMULATION] Starting Capture Engine...</div>';

    setTimeout(() => {
        const p = document.createElement('div');
        p.innerText = `[${new Date().toLocaleTimeString()}] [SIMULATION] Connected to Mock Source.`;
        logList.prepend(p);
    }, 1000);

    setTimeout(() => {
        metricActivity.innerText = "OPTIMAL";
        const p = document.createElement('div');
        p.innerText = `[${new Date().toLocaleTimeString()}] [SIMULATION] Sync complete.`;
        logList.prepend(p);
        loadDashboardData();
    }, 3000);
}

function initServiceWorker() {
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('service-worker.js').catch(() => {});
    }
}

function initAtmosphere() {}
