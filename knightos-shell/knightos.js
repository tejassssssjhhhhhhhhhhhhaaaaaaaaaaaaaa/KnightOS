/**
 * KNIGHTOS v6.0 CORE INTERFACE LOGIC
 */

document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    loadDashboardData();
    initAtmosphere();
});

function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    const views = document.querySelectorAll('.view');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const targetView = item.getAttribute('data-view');

            // Update Nav UI
            navItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');

            // Update View UI
            views.forEach(v => {
                v.classList.remove('active');
                if (v.id === `view-${targetView}`) {
                    v.classList.add('active');
                }
            });
        });
    });
}

async function loadDashboardData() {
    if (!window.DataProvider) return;

    // Load Home Data
    const health = await window.DataProvider.getSystemHealth();
    document.getElementById('metric-health').innerText = `${health.overall}%`;

    const brain = await window.DataProvider.getBrainMetrics();
    document.getElementById('metric-memories').innerText = brain.memories;
    document.getElementById('metric-review').innerText = brain.needsReview;
    document.getElementById('brain-health-val').innerText = `${brain.health}%`;

    const summary = await window.DataProvider.getDataSummary();
    document.getElementById('metric-records').innerText = (summary.totalRecords / 1000).toFixed(1) + 'k';

    // Populate Data Pulse
    const pulseList = document.getElementById('data-pulse-list');
    summary.sources.forEach(source => {
        const item = document.createElement('div');
        item.className = 'pulse-item';
        item.innerHTML = `
            <div class="status-dot"></div>
            <div class="pulse-info">
                <div class="pulse-name">${source.name}</div>
                <div class="pulse-time">${source.count} records</div>
            </div>
        `;
        pulseList.appendChild(item);
    });

    // Populate Data Hub
    const hubSources = document.getElementById('hub-source-list');
    health.subsystems.forEach(sub => {
        const div = document.createElement('div');
        div.className = 'pulse-item';
        div.innerHTML = `
            <div class="status-dot" style="background-color: ${sub.status === 'HEALTHY' ? 'var(--status-green)' : 'var(--status-amber)'}"></div>
            <div class="pulse-info">
                <div class="pulse-name">${sub.name}</div>
                <div class="pulse-time">${sub.lastSync}</div>
            </div>
        `;
        hubSources.appendChild(div);
    });

    // Populate Pipeline
    const pipeline = await window.DataProvider.getPipelineStages();
    const pipelineContainer = document.getElementById('hub-pipeline');
    pipeline.forEach(stage => {
        const div = document.createElement('div');
        div.style.padding = '10px';
        div.style.marginBottom = '8px';
        div.style.background = 'rgba(255,255,255,0.02)';
        div.style.borderRadius = '6px';
        div.innerHTML = `
            <div style="display:flex; justify-content: space-between; font-size: 12px;">
                <span>${stage.id}</span>
                <span style="color: var(--accent-color)">${stage.count}</span>
            </div>
            <div style="font-size: 9px; color: var(--text-dim); margin-top: 4px;">STATUS: ${stage.status}</div>
        `;
        pipelineContainer.appendChild(div);
    });

    // Populate SSoT (Simulated)
    const ssotBody = document.getElementById('ssot-body');
    const mockRows = [
        { id: 'K001', source: 'GMAIL', title: 'Invoice: Amazon', conf: '1.0' },
        { id: 'K002', source: 'CAL', title: 'Scrum Meeting', conf: '0.9' },
        { id: 'K003', source: 'DRIVE', title: 'Budget_2026.pdf', conf: '1.0' }
    ];
    mockRows.forEach(row => {
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

function initAtmosphere() {
    // Dynamic Greeting based on time
    const hour = new Date().getHours();
    const greeting = document.getElementById('greeting');
    if (hour < 12) greeting.innerText = "Good morning, Commander";
    else if (hour < 18) greeting.innerText = "Good afternoon, Commander";
    else greeting.innerText = "Good evening, Commander";
}
