# KNIGHTOS v6.0 — EXCEL EDITION (Web Shell)

This directory contains the graphical interface for KNIGHTOS v6.0. It is designed to run as an Office Add-in inside Microsoft Excel, but can also operate as a standalone Progressive Web App (PWA).

## Features
- **Cross-Device Universal Experience**: Automatically adapts to Mobile, Tablet, and Desktop form factors.
- **PWA Ready**: Can be installed to the home screen on Android, iOS, and Windows.
- **Excel Bridge**: Deep integration with Excel SSoT and Brain using Office.js.
- **Grounded AI**: Knight AI reasoning is strictly linked to workbook evidence.

## Deployment to GitHub Pages (₹0 Cost)
1. Push this directory to a GitHub repository.
2. Enable GitHub Pages in the repository settings, pointing to the `root` or `/docs` directory.
3. Update the `manifest.xml` and `manifest.webmanifest` with your final GitHub Pages URL.

## Local Configuration
Open the **Settings** (Gear icon) in the app to configure:
- **Gemini API Key**: Required for intelligent reasoning.
- **Google Client ID**: Required for live data ingestion (Gmail, Calendar, etc.).
- **Device Mode**: Force a specific layout (Mobile/Tablet/Desktop).

## Security
- No API keys or secrets are stored in this repository.
- User configuration is stored locally in the browser's `localStorage`.
- Data is processed locally whenever possible.
