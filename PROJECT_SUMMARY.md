# GATI — Indian Global Mobility Dashboard

**Full Project Summary**

---

## 1. What Is This Project?

The **GATI Indian Global Mobility Dashboard** is an interactive, data-driven web dashboard built by the **GATI Foundation** (Global Access to Talent from India). It visualizes the presence, employment, and healthcare workforce of **Indian nationals living and working abroad** across **10 countries**:

| # | Country      | # | Country      |
|---|-------------|---|-------------|
| 1 | Canada       | 6 | Poland       |
| 2 | France       | 7 | South Korea  |
| 3 | Germany      | 8 | Spain        |
| 4 | Italy        | 9 | United Kingdom |
| 5 | Japan        | 10| United States |

The dashboard benchmarks Indian numbers against each country's **total foreign population** to show India's share, growth trends, and relative position.

---

## 2. What Does It Track?

The dashboard is organized into **three thematic pillars**:

### 2.1 All-Purpose Migration (Population)
- **Indian population abroad** — total Indians resident in each country for any purpose (work, study, family, etc.)
- **Total foreign population** — each country's total foreigners for comparison
- **India's share** — what percentage of all foreigners are Indian
- Both **stock** (point-in-time totals) and **flow** (new arrivals per year) data

### 2.2 Employment
- **Indian workers formally employed** (or holding work permits) in each country
- **Total foreign workforce** for comparison
- **India's share of each country's foreign workforce**
- Stock trends and annual new-worker inflows

### 2.3 Healthcare (Nurses)
- **Indian nurses working abroad** — stock counts and annual inflows
- **India's share of foreign nurses** in each country
- **Growth trends** — how fast the Indian nurse population is growing
- **Top destinations** for Indian nurses

---

## 3. Dashboard Pages

The project has **3 main pages** plus a standalone data-notes page:

### 3.1 Overview Dashboard (`index.html` + `app.js`)
The main multi-country comparison page. Contains:
- **4 tab sections**: All-Purpose Migration, Employment, Healthcare, Data Notes
- **KPI cards** at the top of each section (Indian count, total foreign count, India's share %)
- **14 interactive charts** across all tabs including:
  - Trend lines (Indian population/employment/nurses over multiple years)
  - Share bar charts (India's % of foreign population by country)
  - Snapshot comparisons (latest-year bar charts across countries)
  - Flow charts (new arrivals per year)
- **Per-chart filters**: Each chart has its own country toggle pills and year-range selectors
- **Data Notes tab**: Full methodology section with sourcing details, counting definitions, and source links

### 3.2 Germany Country Dashboard (`germany.html` + `germany-app.js`)
A deep-dive into Germany with **5 tabs**:
- **Population** — Indian & foreign population stock trends, Eurostat employment permits
- **Migration Flows** — Annual arrivals/departures/net migration + monthly trends
- **Employment** — Federal Employment Agency (BA) data, foreign labour by status
- **Healthcare** — Indian physicians, nurse inflows, OECD healthcare workforce data
- **Key Insights** — Auto-generated insight cards summarizing key findings

Features executive KPI cards showing Indian count, CAGR (compound annual growth rate), total foreign count, and India's share for each pillar.

Data sources: **Destatis** (Federal Statistics), **BA** (Federal Employment Agency), **Eurostat**, **OECD**, **Bundesärztekammer** (physician data).

### 3.3 Japan Country Dashboard (`japan.html` + `japan-app.js`)
A deep-dive into Japan with **4 tabs**:
- **Overview** — Indian & foreign population trends, top residence categories
- **Workforce** — Detailed breakdown across Japan's 17 employment residence categories (Engineer/Specialist, Highly Skilled Professional, Technical Intern Training, Specified Skilled Worker, etc.)
- **Healthcare** — Medical and Caregiver (Nursing Care) residence categories
- **Key Insights** — Auto-generated insight cards

Data period: **June 2021 – June 2025** (using June snapshots for consistency).
Data source: **ISA** (Immigration Services Agency of Japan).

### 3.4 Data Notes (`data_notes.html`)
Standalone reference page explaining:
- Stock vs flow definitions
- Counting methodologies (citizenship, country of birth, work permits vs actual employment)
- Year/reference-date conventions per country
- Source links for all 10 countries

---

## 4. How Does the Data Work?

### 4.1 Overview Page — Google Sheets → CSV Pipeline
The main dashboard pulls live data from **3 published Google Sheets** (one per theme):

| Sheet | What It Contains |
|-------|-----------------|
| `allReasons` | Population data — Indian & total foreign, stock & flow, for all 10 countries |
| `employment` | Employment data — Indian & total foreign workers, stock & flow |
| `healthcare` | Healthcare (nurse) data — Indian & total foreign nurses, stock & flow |

**How it works:**
1. Each Google Sheet is published as CSV via a public URL
2. On page load, `index.html` fetches all 3 CSVs in parallel
3. A custom RFC 4180 CSV parser converts the wide-format spreadsheet into row objects
4. Rows are split into 6 data tables: `AllReasons_Stock`, `AllReasons_Flow`, `Employment_Stock`, `Employment_Flow`, `Healthcare_Nurses_Stock`, `Healthcare_Nurses_Flow`
5. `app.js` reads these tables and renders all KPIs + charts

### 4.2 Germany Page — Google Sheets JSON API
The Germany dashboard fetches **7 worksheets** from a Google Sheet via JSON API:
- `Master_Annual` — Annual population/migration stock & flow
- `Master_Monthly` — Monthly migration data
- `employment_Eurostat` — Eurostat employment permit data
- `germany_foreignLabour` — Foreign labour by employment status
- `Healthcare` — Physician and nurse data
- `top_10_nursing` — Top 10 nursing nationality rankings
- `Data_Dictionary` — Metadata definitions

### 4.3 Japan Page — Google Sheets CSV
The Japan dashboard fetches a single CSV of **residence status data** from Japan's ISA, structured as wide-format with paired columns (Total, India) for each semi-annual snapshot (Jun and Dec of each year).

### 4.4 Key Data Concepts

| Concept | Meaning |
|---------|---------|
| **Stock** | Point-in-time total (e.g., total Indians resident as of year-end) |
| **Flow** | New arrivals or entries during a calendar year |
| **Share** | Indian count ÷ same country's total foreigners × 100 |
| **CAGR** | Compound Annual Growth Rate — used in country dashboards |

> **Important**: Stock and flow are never combined on the same chart. Each share calculation uses Indian and total-foreigner numbers from the same source and same year.

---

## 5. Tech Stack

| Component | Technology |
|-----------|-----------|
| **Structure** | Plain HTML5 (no framework, no build step) |
| **Styling** | Vanilla CSS with CSS custom properties (design tokens) |
| **Charts** | Chart.js 4.4.4 (CDN) |
| **Typography** | Google Fonts — Poppins (400, 500, 600, 700, 800) |
| **Data Source** | Google Sheets published as CSV / JSON |
| **Backend** | None — fully static, client-side rendering |
| **State Persistence** | localStorage (saves filter states and active tab between sessions) |

---

## 6. File Structure

```
Indians-Working-Abroad-/
├── index.html              # Main overview dashboard (920 lines, ~45 KB)
├── app.js                  # Overview page logic — charts, KPIs, filters (647 lines, ~28 KB)
├── germany.html            # Germany country deep-dive (549 lines, ~25 KB)
├── germany-app.js          # Germany page logic — 18+ charts, insights (943 lines, ~41 KB)
├── japan.html              # Japan country deep-dive (526 lines, ~23 KB)
├── japan-app.js            # Japan page logic — residence status analysis (743 lines, ~29 KB)
├── data_notes.html         # Standalone methodology & data notes page (316 lines, ~16 KB)
├── clean_combined.xlsx     # Source Excel data file (~229 KB)
├── gati logo final.png     # GATI Foundation logo (~127 KB)
├── read_excel.ps1          # PowerShell helper script for Excel parsing
└── .git/                   # Git version control
```

---

## 7. Design & UI

- **Color scheme**: Teal (`#006B76`) + Gold (`#E5A812`) — the GATI brand palette
- **Layout**: Card-based grid layout with tab navigation
- **KPI cards**: Gold-topped metric cards showing key numbers at a glance
- **Charts**: 2-column grid, individual filter controls per chart (country pills + year selectors)
- **Responsive**: Media queries for screens below 900px — single column, smaller fonts
- **Navigation**: Dropdown "Country Profiles" menu in the header to switch between Overview, Japan, and Germany

---

## 8. Key Features

- **Live data**: Charts update automatically when the underlying Google Sheets are updated — no redeployment needed
- **Per-chart filtering**: Each chart has independent country toggle pills and year-range selectors
- **State persistence**: Filter settings and active tab are saved to localStorage and restored on next visit
- **Auto-generated insights**: Country dashboards (Germany, Japan) generate insight cards programmatically from the data
- **CAGR calculations**: Country pages compute compound annual growth rates for key metrics
- **Comprehensive data notes**: Full methodology documentation built into the dashboard itself

---

## 9. Data Sources (All Official)

### International Organizations
| Source | Used For |
|--------|----------|
| **OECD** (IMD, HWMI) | International migration data, healthcare workforce |
| **Eurostat** | European residence permits, migration |
| **UN DESA** | Population estimates |

### National Sources (by Country)
| Country | Sources |
|---------|---------|
| **Canada** | Statistics Canada, IRCC |
| **France** | INSEE, Ministry of Interior (AGDREF/DSED) |
| **Germany** | Destatis, Federal Employment Agency (BA), Bundesärztekammer |
| **Italy** | ISTAT |
| **Japan** | ISA (Immigration Services Agency) |
| **Poland** | Statistics Poland (GUS), Social Insurance (ZUS) |
| **South Korea** | KOSTAT, Ministry of Justice |
| **Spain** | INE, Social Security (Seguridad Social) |
| **United Kingdom** | ONS, Home Office |
| **United States** | US Census Bureau (ACS PUMS), BLS, State Department, MPI |

---

## 10. How to Run

1. Simply open `index.html` in a browser — no server or build step required
2. The page will automatically fetch live data from the Google Sheets and render the dashboard
3. Requires an **internet connection** for:
   - Loading data from Google Sheets
   - Google Fonts (Poppins)
   - Chart.js CDN

---

## 11. One-Liner Summary

> **The GATI Indian Global Mobility Dashboard is a static, interactive web dashboard that visualizes how many Indians are living, working, and serving as healthcare workers across 10 major countries — using official government data pulled live from Google Sheets and rendered with Chart.js.**
