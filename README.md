# GATI — Indian Global Mobility Dashboard

## 1. Project Overview

Interactive data dashboard tracking Indian nationals living and working abroad across 10 countries, benchmarked against each country's total foreign-national numbers. Covers three pillars: all-purpose migration (population), employment, and healthcare (nurses). Built as a static HTML/CSS/JavaScript site with live data from Google Sheets.

**Live dashboard:** https://indians-working-abroad.netlify.app/

**Repository:** https://github.com/ashutosh-gati/Indians-Working-Abroad-

---

## 2. Technology Stack

| Technology | Usage |
|---|---|
| HTML5 | Page structure (no framework, no build step) |
| CSS3 | Styling via CSS custom properties, fully inline in each HTML file |
| JavaScript (ES6+) | All logic — data fetching, parsing, chart rendering, filters, state |
| Chart.js 4.4.4 | Charts (loaded from CDN) |
| Google Fonts — Poppins | Typography |
| Google Sheets | Data source (published as CSV / JSON API) |
| Google Apps Script | JSON API endpoint for Germany data |
| Netlify | Static hosting with auto-deploy from GitHub |
| GitHub | Version control, single `main` branch |

No `package.json`, no build tools, no npm, no backend, no database.

---

## 3. Project Structure

| File | Purpose |
|---|---|
| `index.html` | **Main overview dashboard.** Contains all HTML structure, inline CSS, data-loading script (CSV fetch + parse), and boots `app.js`. Covers all 10 countries across 4 tabs. |
| `app.js` | **Main dashboard logic.** Chart registry, chart renderers (trend, share, snapshot, trend-share), per-chart filter UI builder, KPI calculations, tab navigation, localStorage state persistence. |
| `germany.html` | **Germany country dashboard.** Standalone deep-dive page with 5 tabs (Population, Migration Flows, Employment, Healthcare, Key Insights). Contains inline CSS and data loader that fetches from Google Apps Script JSON API. |
| `germany-app.js` | **Germany dashboard logic.** Processes 7 JSON worksheets, renders 18+ charts, executive KPIs, CAGR calculations, and auto-generated insight cards. |
| `japan.html` | **Japan country dashboard.** Standalone deep-dive page with 4 tabs (Overview, Workforce, Healthcare, Key Insights). Contains inline CSS and CSV data loader. |
| `japan-app.js` | **Japan dashboard logic.** Processes ISA residence-status CSV data, renders charts across 17 employment residence categories. Data period: June 2021–June 2025. |
| `data_notes.html` | **Standalone data notes page.** Full methodology reference with stock vs flow definitions, counting methods, source links. Separate from the embedded Data Notes tab in `index.html`. |
| `gati logo final.png` | GATI Foundation logo displayed in the site header. |
| `clean_combined.xlsx` | **Reference/source Excel file.** Contains the cleaned source data across 3 sheets (All Reasons, Employment, Healthcare). Not used at runtime — the dashboard fetches live data from Google Sheets. |
| `read_excel.ps1` | PowerShell utility script for inspecting the Excel file locally. Not used at runtime. |
| `PROJECT_SUMMARY.md` | Internal project documentation (detailed architecture notes). |

---

## 4. Data Architecture

```
Google Sheets (3 spreadsheets for Overview, 1 for Germany, 1 for Japan)
        │
        ▼
Published as CSV endpoints / Google Apps Script JSON API
        │
        ▼
Browser fetches CSV/JSON on page load (no backend)
        │
        ▼
JavaScript parses → builds DATA tables → renders KPIs + Chart.js charts
        │
        ▼
Static files served from Netlify (auto-deployed from GitHub main branch)
```

### How it works

1. **No backend.** Everything runs client-side in the browser.
2. **No database.** All data is fetched live from Google Sheets on every page load.
3. **No build step.** HTML files are served directly.

### Data flow per page

| Page | Data Source | Fetch Method | Loader Location |
|---|---|---|---|
| `index.html` (Overview) | 3 Google Sheets (CSV) | `fetch()` → custom RFC 4180 CSV parser | Inline `<script>` in `index.html` (lines ~710–925) |
| `germany.html` | Google Apps Script JSON API | `fetch()` → `response.json()` | Inline `<script>` in `germany.html` (lines ~475–530) |
| `japan.html` | 1 Google Sheet (CSV) | `fetch()` → custom CSV parser | Inline `<script>` in `japan.html` (lines ~411–520) |

### Overview page DATA tables

The overview page parses 3 CSV feeds into these internal tables (built in `buildDataTables()` in `index.html`):

| Internal Table | Source Sheet | Filter |
|---|---|---|
| `AllReasons_Stock` | allReasons CSV | `Type === 'Stock'`, excludes USA, France, Poland |
| `AllReasons_Flow_A` | allReasons CSV | `Type === 'Flow'`, countries: Germany, UK, South Korea |
| `AllReasons_Flow_B` | allReasons CSV | `Type === 'Flow'`, countries: France, Poland, Spain, Italy |
| `Employment_Stock` | employment CSV | `Type === 'Stock'`, excludes USA |
| `Employment_Flow` | employment CSV | `Type === 'Flow'`, excludes USA |
| `Healthcare_Nurses_Stock` | healthcare CSV | `Type === 'Stock'`, excludes USA |
| `Healthcare_Nurses_Flow` | healthcare CSV | `Type === 'Flow'`, excludes USA |

### Germany page data store

The Germany JSON API returns 7 worksheets, stored in the `DE` global object:

| Key | Worksheet |
|---|---|
| `DE.masterAnnual` | `Master_Annual` |
| `DE.masterMonthly` | `Master_Monthly` |
| `DE.eurostat` | `employment_Eurostat` |
| `DE.labour` | `germany_foreignLabour status` |
| `DE.healthcare` | `Healthcare` |
| `DE.nursingRank` | `top_10_nursing` |
| `DE.dictionary` | `Data_Dictionary` |

---

## 5. Data Sources

| Source | Purpose | Used By | Access Method |
|---|---|---|---|
| Google Sheet — All Reasons | Population stock & flow data (10 countries) | `index.html` | Published CSV |
| Google Sheet — Employment | Employment stock & flow data (10 countries) | `index.html` | Published CSV |
| Google Sheet — Healthcare | Nurse stock & flow data (10 countries) | `index.html` | Published CSV |
| Google Sheet — Germany | 7 worksheets: population, migration, employment, healthcare, nursing rankings | `germany.html` | Google Apps Script JSON API |
| Google Sheet — Japan | ISA residence-status data (Jun 2021–Jun 2025) | `japan.html` | Published CSV |

---

## 6. Google Sheets → Dashboard Configuration

### CSV Endpoint URLs (embedded in frontend code)

**Overview page** (`index.html`, lines 716–719):
```
allReasons:  https://docs.google.com/spreadsheets/d/e/2PACX-1vTMjDuUhxNxoUHGYkcu8p8l5ohc-Vn9eEkc9ZTBHXlFCAXVCXQWZK4zcD6VCs2Xx9caJeh1rrUb2PYb/pub?output=csv
employment:  https://docs.google.com/spreadsheets/d/e/2PACX-1vR8e6qyXZRRc-S6Zy2fYk6GvXIHHMO6wtDHmSFmgkm2XKW7cpCSMViK0YvgeJnlURDQKEXx1Qrwlgz4/pub?output=csv
healthcare:  https://docs.google.com/spreadsheets/d/e/2PACX-1vT-1jih6IP86hYWFzkyNGQu4p3a62MlIKdEH-UzpARUlHRD9RpiDb-E9_OBnJ6nDCic59I-tuIWddW8/pub?output=csv
```

**Japan page** (`japan.html`, line 415):
```
https://docs.google.com/spreadsheets/d/e/2PACX-1vS7T13wstWcJwnGebTYEJvdyEimXypaJqgYqEBBRU8x8H5oc0t8-8NRy41YEjGHAwzCUP4jNKvpB6KT/pub?output=csv
```

**Germany page** (`germany.html`, line 479) — uses Google Apps Script:
```
https://script.google.com/macros/s/AKfycbyBrI9A912Wg8vp7DXhOcgIXj6NzbS7A-MAZGvgMKQ8up1pxzMTepSiwTHWMCHrBqGigw/exec
```

### Expected CSV Column Structure (Overview sheets)

Each of the 3 overview CSV sheets uses the same wide-format layout:

| Column | Content |
|---|---|
| Column 0 | Theme (e.g., "Population", "Employment", "Healthcare") |
| Column 1 | Type — must be exactly `Stock` or `Flow` |
| Column 2 | Nationality — must be `Indians` or `Total foreigners` |
| Column 3 | Year (integer, e.g., `2024`) |
| Columns 4+ | Country value columns — headers must match: `Germany`, `Japan`, `Italy`, `Spain`, `USA`, `UK`, `South Korea`, `France`, `Canada`, `Poland` |

**Critical formatting rules:**
- Column headers for countries must match the names in the `COUNTRY_HEADERS` array exactly (case-insensitive, whitespace-insensitive).
- Nationality values must contain either `Indian`/`Indians` or text starting with `Total foreign`.
- Numbers can use comma grouping (e.g., `3,71,773` or `155,310`). Commas are stripped during parsing.
- Empty cells or `N/A` values are treated as null and skipped.
- Renaming or removing a country column will cause that country to silently disappear from charts.
- Renaming `Stock`/`Flow` in the Type column will break the stock/flow split.

---

## 7. Data Update Procedure

### Updating Overview Dashboard Data

1. Open the relevant Google Sheet (All Reasons, Employment, or Healthcare).
2. Add or modify rows. Preserve the column structure exactly.
3. Ensure the sheet is still published to the web as CSV (File → Share → Publish to web → CSV).
4. Open the live dashboard and hard-refresh (`Ctrl+Shift+R`) to verify updated values in KPIs and charts.
5. No code change or redeployment is needed for data-only updates — the dashboard fetches live from Google Sheets.

### Updating Germany or Japan Data

- **Germany:** Update the source Google Sheet. The Google Apps Script endpoint reads from it automatically.
- **Japan:** Update the source Google Sheet. Ensure it remains published as CSV.

### If Code Changes Are Needed

1. Modify the relevant `.html` or `.js` file locally.
2. Test locally (see Section 9).
3. `git add .` → `git commit -m "description"` → `git push origin main`
4. Netlify auto-deploys within ~1 minute.
5. Verify at https://indians-working-abroad.netlify.app/

---

## 8. Local Development

### Prerequisites

- A modern web browser
- A local HTTP server (required because `fetch()` does not work with `file://` protocol)

### Running Locally

```bash
# Navigate to the repository root
cd Indians-Working-Abroad-

# Start a local server (any of these work):
python -m http.server 8080
# or
npx serve .

# Open in browser:
http://localhost:8080/
```

There is no `package.json`, no `npm install`, no build step. The files are served as-is.

---

## 9. Code Modification Guide

| Task | File(s) to Modify |
|---|---|
| Change overview chart titles | `index.html` — `<h3>` elements inside `chart-card` divs |
| Change overview KPI labels | `index.html` — `.kpi-label` elements |
| Change overview KPI logic / data source | `app.js` — `renderKPIs()`, `renderFixedYearKPI()`, `renderFixedYearShareKPI()` |
| Add/remove/reorder overview charts | `app.js` — `CHARTS` registry (line ~15) and `TABS_CHARTS` (line ~508); `index.html` — add/remove `chart-card` HTML |
| Change chart rendering (colors, options) | `app.js` — `renderTrendChart()`, `renderShareChart()`, `renderSnapshotChart()`, `lineOptions()`, `barOptions()` |
| Change per-chart filters | `app.js` — `buildChartFilters()` |
| Change which countries are excluded | `index.html` — `buildDataTables()` function (line ~817) |
| Change flow chart country grouping | `index.html` — `FLOW_GROUP_A` and `FLOW_GROUP_B` arrays in `buildDataTables()` |
| Change CSV data source URLs | `index.html` — `CSV_URLS` object (line ~716) |
| Change overview styling | `index.html` — `<style>` block (lines 10–303) |
| Change Germany dashboard | `germany.html` (HTML/CSS/data loader) + `germany-app.js` (logic/charts) |
| Change Japan dashboard | `japan.html` (HTML/CSS/data loader) + `japan-app.js` (logic/charts) |
| Add a new country profile | Create `country.html` + `country-app.js`; add navigation link in all HTML files' `.country-nav-menu` |
| Change data notes content | `index.html` — Data Notes tab panel (`#tab-notes`); also `data_notes.html` (standalone page) |
| Change site header / logo | All HTML files — `.site-header` section; replace `gati logo final.png` |

---

## 10. Dashboard Pages

| File | Page | JavaScript | Data Source |
|---|---|---|---|
| `index.html` | Multi-country overview (4 tabs: All-purpose migration, Employment, Healthcare, Data Notes) | `app.js` | 3 Google Sheets (CSV) |
| `germany.html` | Germany deep-dive (5 tabs: Population, Migration Flows, Employment, Healthcare, Key Insights) | `germany-app.js` | Google Apps Script JSON API |
| `japan.html` | Japan deep-dive (4 tabs: Overview, Workforce, Healthcare, Key Insights) | `japan-app.js` | Google Sheet (CSV) |
| `data_notes.html` | Standalone methodology reference page | None | Static content |

---

## 11. Key Calculations in Code

### Overview Dashboard (`app.js`)

| Calculation | Function | Logic |
|---|---|---|
| KPI totals (Indian count, Foreign count) | `renderFixedYearKPI()` | Sums all `Value` for matching `Year`, `Nationality`, and available countries |
| KPI share (%) | `renderFixedYearShareKPI()` | For each country: `Indian ÷ Total Foreigners × 100`, then averages across countries (unweighted) |
| Healthcare growth KPI | `renderHealthGrowthKPI()` | `((lastYear - firstYear) / firstYear) × 100` per country, then averaged |
| Share bar chart | `renderShareChart()` → `shareRowsForYear()` | Per-country: `Indian ÷ Total Foreigners × 100` for a single year |
| Trend-share chart (nurses) | `renderTrendShareChart()` | Per-country share computed for each year, plotted as time series |

### Important data assumptions encoded in code

- **USA is excluded** from all tables after parsing (`buildDataTables()` in `index.html`).
- **France and Poland are excluded** from `AllReasons_Stock` (population stock) — they use Eurostat permit data, not population registers.
- **Flow data is split** into Group A (Germany, UK, South Korea — national sources) and Group B (France, Poland, Spain, Italy — Eurostat/Istat).
- **Share KPIs** use simple unweighted averages of per-country shares — not a pooled global percentage.
- **Filter state** is persisted to `localStorage` (key: `gati_cState`) so user selections survive page refreshes.

---

## 12. Deployment — Netlify

| Setting | Value |
|---|---|
| Hosting | Netlify (static site) |
| Connected repository | `ashutosh-gati/Indians-Working-Abroad-` on GitHub |
| Production branch | `main` |
| Build command | None (static files, no build step) |
| Publish directory | `/` (repository root) |
| Auto-deploy | Yes — every push to `main` triggers automatic deployment |
| Netlify config files | None (`netlify.toml`, `_redirects`, `_headers` are not present) |

---

## 13. GitHub Workflow

```
1. Make changes locally
2. Test in browser via local server
3. git status                    # review changes
4. git add .                     # stage changes
5. git commit -m "description"   # commit
6. git push origin main          # push to GitHub
7. Netlify auto-deploys (~1 min)
8. Verify at https://indians-working-abroad.netlify.app/
```

- Single branch: `main`
- Remote: `origin` → `https://github.com/ashutosh-gati/Indians-Working-Abroad-.git`

---

## 14. Environment Variables & Secrets

No environment variables, API keys, tokens, or backend secrets are required by the application. All data source URLs are public Google Sheets CSV endpoints and a public Google Apps Script web app URL, embedded directly in the frontend code.

---

## 15. Troubleshooting

| Issue | Possible Cause | Check / Fix |
|---|---|---|
| Dashboard shows spinner indefinitely | Google Sheets CSV endpoint unreachable | Check internet connection; verify the Google Sheet is still published to web (File → Share → Publish to web) |
| KPIs show "—" or "No data available" | Data missing for the expected year (2024) or nationality | Check Google Sheet has rows with `Year=2024` and correct `Nationality` values |
| A country disappeared from charts | Country column header renamed in Google Sheet | Verify header matches `COUNTRY_HEADERS` array in `index.html` |
| Charts render but with wrong numbers | Number formatting issue in Google Sheet | Ensure numbers don't have extra spaces; commas are OK |
| Germany page fails to load | Google Apps Script URL expired or was redeployed | Re-deploy the Apps Script web app and update `DE_API_URL` in `germany.html` |
| Works locally but not on Netlify | Likely a file path case-sensitivity issue | Netlify uses Linux (case-sensitive); check filenames match exactly |
| Filters reset on every visit | `localStorage` cleared or browser in private mode | Expected behavior if localStorage is unavailable |
| New data rows not appearing | Google Sheets caching | Wait a few minutes; Google's CSV publish endpoint can cache for ~5 minutes |

---

## 16. Known Limitations

- **Manual data updates** — data is updated by editing Google Sheets manually; there is no automated data pipeline or scraper.
- **No backend** — fully static; no server-side processing, authentication, or access control.
- **Google Sheets dependency** — if the Google Sheets are unpublished, deleted, or the Google account loses access, the dashboard will fail to load data.
- **Column name sensitivity** — renaming columns in Google Sheets will silently break parsing; there is no validation or error message for structural mismatches.
- **No automated data validation** — incorrect data types or formats in the spreadsheet will produce wrong numbers without warning.
- **Google Apps Script quotas** — the Germany JSON endpoint is subject to Google Apps Script execution quotas.

---

## 17. Known Issues

No known unresolved issues are documented at the time of handover.

---

## 18. Backup / Important Files

| File | Type | Notes |
|---|---|---|
| `clean_combined.xlsx` | Reference/source | Cleaned source dataset (3 sheets). Not used at runtime — preserved as backup of the original data. |
| `data_notes.html` | Documentation | Standalone methodology page with source citations and definitions. |
| `PROJECT_SUMMARY.md` | Documentation | Detailed internal project architecture notes. |
| `read_excel.ps1` | Utility | PowerShell script for inspecting the Excel file. Development tool only. |
| Google Sheets (5 spreadsheets) | Live data source | These are the actual runtime data sources — must be preserved and kept published. |

---

## 19. Access & Ownership

The following accounts/services require organizational access for ongoing maintenance:

| Service | What to Transfer |
|---|---|
| **GitHub** | Repository: `ashutosh-gati/Indians-Working-Abroad-` — collaborator or ownership transfer |
| **Netlify** | Project connected to the GitHub repository — team access or ownership transfer |
| **Google Sheets** (5 spreadsheets) | Editor access to all 5 source spreadsheets — transfer ownership or share with the organization account |
| **Google Apps Script** | The Apps Script project serving the Germany JSON API — editor access needed to redeploy if the endpoint changes |

> **Note:** Ensure the incoming maintainer has edit access to all Google Sheets and the Apps Script project before handover is complete.
