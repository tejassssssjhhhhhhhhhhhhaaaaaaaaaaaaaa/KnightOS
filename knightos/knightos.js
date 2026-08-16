/**
 * KNIGHTOS v6.0 CORE INTERFACE LOGIC
 */

let currentConversation = [];
let pendingAction = null;

const GEMINI_CONFIG = {
    model: 'gemini-1.5-flash',
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta'
};

// Office.js Initialization
if (typeof Office !== 'undefined') {
    Office.onReady(() => initApp());
} else {
    document.addEventListener('DOMContentLoaded', initApp);
}

// Service Worker Registration for PWA
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('service-worker.js')
            .then(reg => console.log('KnightOS: Service Worker registered.'))
            .catch(err => console.log('KnightOS: Service Worker registration failed.', err));
    });
}

function initApp() {
    initDeviceProfile();
    initNavigation();
    initChat();
    initSettings();
    loadDashboardData();
    initAtmosphere();
    checkAIHealth();
}

function initDeviceProfile() {
    const dp = window.DataProvider;
    const override = dp.getConfig('device_mode') || 'AUTO';
    const width = window.innerWidth;

    let type = "BROWSER";
    let formFactor = (override === 'AUTO') ? "DESKTOP" : override;

    if (override === 'AUTO') {
        if (width <= 600) formFactor = "MOBILE";
        else if (width <= 1024) formFactor = "TABLET";
    }

    if (navigator.userAgent.includes("Windows")) type = "WINDOWS";
    else if (navigator.userAgent.includes("Macintosh")) type = "MACOS";
    else if (navigator.userAgent.includes("Android")) type = "ANDROID";
    else if (navigator.userAgent.includes("iPhone") || navigator.userAgent.includes("iPad")) type = "IOS";

    window.DeviceProfile = { type, formFactor, width, height: window.innerHeight };

    // Apply initial layout class to body
    document.body.classList.remove('mobile', 'tablet', 'desktop');
    document.body.classList.add(formFactor.toLowerCase());
}

function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    const views = document.querySelectorAll('.view');
    navItems.forEach(item => {
        item.addEventListener('click', () => switchView(item.getAttribute('data-view')));
    });
}

function switchView(target) {
    document.querySelectorAll('.nav-item').forEach(i => i.classList.toggle('active', i.getAttribute('data-view') === target));
    document.querySelectorAll('.view').forEach(v => v.classList.toggle('active', v.id === `view-${target}`));
    if (window.DataProvider.getEnvironment() === "EXCEL") {
        const sheetMap = { 'home': '00_COMMAND_CENTER', 'ssot': '10_SSOT_STORE', 'brain': '40_KNIGHT_BRAIN', 'config': '99_CONFIG' };
        if (sheetMap[target]) window.DataProvider.activateSheet(sheetMap[target]);
    }
}

function initSettings() {
    const dp = window.DataProvider;
    const gKey = document.getElementById('cfg-gemini-key');
    const gId = document.getElementById('cfg-google-id');
    const dMode = document.getElementById('cfg-device-mode');
    const btn = document.getElementById('btn-save-config');
    const btnTest = document.getElementById('btn-test-ai');

    if (gKey) gKey.value = dp.getConfig('gemini_key') || '';
    if (gId) gId.value = dp.getConfig('google_id') || '';
    if (dMode) dMode.value = dp.getConfig('device_mode') || 'AUTO';

    btn.addEventListener('click', () => {
        dp.saveConfig('gemini_key', gKey.value);
        dp.saveConfig('google_id', gId.value);
        dp.saveConfig('device_mode', dMode.value);
        alert("Configuration Saved.");
        initDeviceProfile(); // Re-detect or apply override
        loadDashboardData();
    });

    // Update info labels
    const prof = window.DeviceProfile;
    document.getElementById('info-detected').innerText = prof.type;
    document.getElementById('info-form').innerText = prof.formFactor;

    if (btnTest) {
        btnTest.addEventListener('click', async () => {
            const key = gKey.value;
            if (!key) { alert("Please enter an API key first."); return; }
            btnTest.innerText = "Testing...";
            try {
                const res = await callGemini(key, "Say only: KNIGHT ONLINE", "Test Connection");
                alert("Success: " + res);
                updateAIStatusUI(true);
            } catch (e) {
                alert("Connection Failed: " + e.message);
                updateAIStatusUI(false);
            } finally {
                btnTest.innerText = "Test AI Connection";
            }
        });
    }
}

function initChat() {
    const orb = document.getElementById('knight-orb');
    const panel = document.getElementById('chat-panel');
    const trigger = document.getElementById('orb-trigger');
    const input = document.getElementById('chat-input');

    [orb, trigger].forEach(el => el && el.addEventListener('click', () => {
        panel.style.display = panel.style.display === 'flex' ? 'none' : 'flex';
        input.focus();
    }));

    document.getElementById('chat-close').addEventListener('click', () => panel.style.display = 'none');
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
        appendMessage('knight', "I am currently in Rule-Based mode. Please provide a Gemini API Key in Settings for full intelligence.");
        await processIntentLocally(text);
        return;
    }

    // REAL AI LOGIC (Targeted context retrieval)
    appendMessage('system', 'Retrieved Context...');
    const records = await dp.getSSoTRecords();
    const context = records.length > 0
        ? records.slice(0, 10).map(r => `${r.id}: ${r.title} (${r.category})`).join('\n')
        : "No records found in SSoT.";

    try {
        appendMessage('system', 'Knight is Thinking...');
        const response = await callGemini(apiKey, text, context);
        appendMessage('knight', response);
        await dp.logInteraction({ id: 'AI-'+Date.now(), sender: 'KNIGHT', text: response, intent: 'AI_REASONING' });

        // Success! Ensure status is updated
        updateAIStatusUI(true);
    } catch (e) {
        console.error("Gemini Connection Error:", e);
        appendMessage('knight', `I encountered an error connecting to Gemini (${e.message}). Falling back to local rules.`);
        await processIntentLocally(text);
        updateAIStatusUI(false);
    }
}

async function checkAIHealth() {
    const dp = window.DataProvider;
    const key = dp.getConfig('gemini_key');
    if (!key) {
        updateAIStatusUI(false);
        return;
    }

    try {
        // Minimal ping test
        await callGemini(key, "PING", "Health Check");
        updateAIStatusUI(true);
    } catch (e) {
        console.warn("AI Health Check Failed:", e);
        updateAIStatusUI(false);
    }
}

async function callGemini(key, prompt, context) {
    const url = `${GEMINI_CONFIG.baseUrl}/models/${GEMINI_CONFIG.model}:generateContent?key=${key}`;
    const response = await fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            contents: [{
                parts: [{
                    text: `You are Knight, a futuristic personal Data OS assistant. You are grounded, calm, and intelligent.
Use the following context from the user's Excel SSoT (Single Source of Truth) to answer their question.
If the information is not in the context, say you don't know based on the provided data.
DO NOT invent facts about the user.

Context:
${context}

User: ${prompt}`
                }]
            }]
        })
    });

    if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.error?.message || `HTTP ${response.status}`);
    }

    const data = await response.json();
    if (data.candidates && data.candidates[0]?.content?.parts[0]?.text) {
        return data.candidates[0].content.parts[0].text;
    } else {
        throw new Error("Invalid response format from Gemini API");
    }
}

async function processIntentLocally(text) {
    const dp = window.DataProvider;
    const t = text.toLowerCase();
    if (t.includes('show') || t.includes('find')) {
        const records = await dp.getSSoTRecords();
        const matches = records.filter(r => r.title.toLowerCase().includes(t));
        if (matches.length > 0) appendMessage('knight', `Found local match: "${matches[0].title}".`);
        else appendMessage('knight', "No local matches found.");
    }
}

function appendMessage(sender, text) {
    const container = document.getElementById('chat-messages');
    const div = document.createElement('div');
    div.className = `msg msg-${sender}`;
    div.innerText = text;
    container.appendChild(div);
    container.scrollTop = container.scrollHeight;
}

async function loadDashboardData() {
    const dp = window.DataProvider;

    // 1. System Health
    try {
        const health = await dp.getSystemHealth();
        document.getElementById('metric-health').innerText = `${health.overall}%`;
        document.getElementById('status-health').innerText = `● ${health.status}`;
    } catch (e) { console.warn("Health load failed", e); }

    // 2. Brain Metrics
    try {
        const brain = await dp.getBrainMetrics();
        document.getElementById('metric-memories').innerText = brain.memories;
    } catch (e) { console.warn("Brain metrics load failed", e); }

    // 3. Data Summary
    try {
        const summary = await dp.getDataSummary();
        document.getElementById('metric-records').innerText = summary.totalRecords;
    } catch (e) { console.warn("Summary load failed", e); }

    // 4. AI Status
    const aiKey = dp.getConfig('gemini_key');
    updateAIStatusUI(!!aiKey);

    // 5. SSoT Table
    try {
        const ssotBody = document.getElementById('ssot-body');
        if (ssotBody) {
            ssotBody.innerHTML = '';
            const records = await dp.getSSoTRecords();
            records.forEach(row => {
                const tr = document.createElement('tr');
                tr.style.borderBottom = '1px solid rgba(255,255,255,0.05)';
                tr.innerHTML = `
                    <td style="padding: 10px; color: var(--accent-color)">${row.id}</td>
                    <td style="padding: 10px;">${row.source}</td>
                    <td style="padding: 10px;">${row.title}</td>
                    <td style="padding: 10px;">${row.conf}</td>
                `;
                ssotBody.appendChild(tr);
            });
        }
    } catch (e) { console.warn("SSoT load failed", e); }
}

function updateAIStatusUI(connected) {
    const statusEl = document.getElementById('ai-status');
    const labelEl = document.getElementById('ai-status-label');
    if (statusEl) statusEl.innerText = connected ? "ONLINE" : "OFF";
    if (labelEl) {
        labelEl.innerText = connected ? "Intelligence Active" : "Not Configured";
        labelEl.style.color = connected ? "var(--status-green)" : "var(--text-secondary)";
    }
}

function initAtmosphere() {
    const hour = new Date().getHours();
    const greeting = document.getElementById('greeting');
    if (!greeting) return;
    if (hour < 12) greeting.innerText = "Good morning, Commander";
    else if (hour < 18) greeting.innerText = "Good afternoon, Commander";
    else greeting.innerText = "Good evening, Commander";
}
