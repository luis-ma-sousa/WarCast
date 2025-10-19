# WarCast — Historical Battle Data Pipeline & Analysis

## 🎯 Project Overview

**WarCast** is an end-to-end data engineering and analytics project that extracts, cleans, and analyzes historical battle data from Wikipedia. The project demonstrates a complete ETL (Extract, Transform, Load) workflow combined with advanced SQL analytics, integrating multiple socioeconomic datasets to enable rich historical conflict analysis.

The pipeline processes information from hundreds of historical battles (from multiple centuries), enriching them with contextual data including GDP, population, political regimes, corruption indices, and military expenditure to uncover patterns in warfare, belligerence, and geopolitical dynamics.

---

## 🔄 Pipeline Architecture

The project consists of three main stages:

### 1️⃣ **Web Scraping Pipeline** (`Webscrapping pipeline.ipynb`)
Automated extraction of battle data from Wikipedia using requests and BeautifulSoup.

**Data Sources:**
- Wikipedia list pages (e.g., "List of battles by casualties", "List of wars by death toll")
- Individual battle pages with detailed infoboxes

**Extracted Fields:**
- Battle names and dates
- Conflict/war context
- Participating countries and commanders
- Battle locations (cities, countries)
- Battle results and outcomes (winner/loser)
- Casualties and force strengths (troops, deaths)

**Key Features:**
- Intelligent HTML parsing with fallback strategies
- Handles missing data and malformed infoboxes
- Rate limiting and error handling for stable scraping
- Extracts structured data from unstructured Wikipedia tables
- Processes alternate page formats automatically

---

### 2️⃣ **Data Cleaning & Database Creation** (`DataClean and DatabaseCreation pipeline.ipynb`)
Transforms raw scraped data into a structured SQLite database with normalized schemas.

**Cleaning Operations:**
- **Battles data:** Year extraction, conflict name standardization, location parsing
- **Battle info:** Country/city separation, result classification, troop/casualty validation
- **GDP data:** Multi-year economic indicators by country (1988-2022)
- **Political regime data:** Government type classifications over time
- **Population data:** Historical population figures by country
- **Corruption Perception Index (CPI):** Transparency scores by country
- **Military investment:** Defense spending as % of GDP

**Database Schema:**
- Normalized relational tables with primary/foreign keys
- Type casting and deduplication
- Geospatial data cleaning (city/country separation)
- Temporal alignment across datasets

*Full schema documentation available in [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)*

---

### 3️⃣ **SQL Analytics** (`.sql` files)
Advanced analytical queries exploring patterns in warfare, geopolitics, and conflict dynamics.

**Analysis Modules:**

📊 **Battles Analysis** (`Battles.sql`)
- Century-by-century battle frequency
- Most frequent conflicts per century
- Temporal trends in warfare intensity

🌍 **Country & City Analysis** (`Country_City_battles.sql`)
- Countries ranked by battle frequency and casualties
- Most frequent conflicts per country
- Deadliest cities within conflicts
- Deadliest battles and their outcomes
- Geographic concentration of warfare

🏴 **Country Belligerence** (`Country bellicism.sql`)
- Most belligerent countries per conflict
- Most frequent winners/losers by conflict
- Countries involved across centuries
- Total troops and casualties by conflict

💥 **Controversial Battles** (`Most controversal batles.sql`)
- Battles with the highest number of participating countries
- Multi-national conflicts ranked by complexity
- Geographic locations of major battles

🏛️ **Geopolitical Context** (`Politics corruption and military gdp.sql`)
- Correlation between political regime and military spending
- Corruption levels vs. defense expenditure
- Regime type distribution over time (electoral democracy, autocracy, etc.)
- Population dynamics and military investment

---

## 📊 Key Findings & Insights

Through SQL analytics, the project reveals:

- **Temporal patterns:** Which centuries saw the most battles
- **Geographic hotspots:** Countries and cities most affected by warfare
- **Belligerence rankings:** Most frequently warring nations per conflict
- **Victory patterns:** Countries with highest win/loss ratios
- **Geopolitical correlations:** Relationships between regime type, corruption, GDP, and military spending
- **Conflict complexity:** Battles involving the most countries (multinational warfare)

---

## 📊 Datasets Integrated

| Dataset | Source | Purpose |
|---------|--------|---------|
| **Battles List** | Wikipedia | Core battle metadata (name, year, conflict) |
| **Battle Info** | Wikipedia | Detailed statistics (troops, deaths, results, locations) |
| **GDP** | Excel (World Bank) | Economic context (1988-2022) |
| **Political Regime** | CSV | Government type indicators |
| **Population** | CSV | Demographic context |
| **CPI Scores** | CSV | Corruption levels |
| **Military Investment** | CSV | Defense spending trends (% GDP) |

---

## 🛠️ Technical Stack

- **Language:** Python 3.9+, SQL
- **Web Scraping:** requests, BeautifulSoup4, urllib
- **Data Processing:** pandas, NumPy, re
- **Database:** SQLite3
- **Analytics:** Advanced SQL (CTEs, Window Functions, Aggregations)
- **Error Handling:** traceback, time, random (rate limiting)
- **Environment:** Jupyter Notebooks

---

## 🔑 Key Features

- **Robust scraping:** Handles pagination, timeouts, and missing fields gracefully
- **Data normalization:** Standardizes country names, dates, and geographic terms across sources
- **Advanced SQL analytics:** Complex queries with CTEs, window functions, and multi-table joins
- **Modular functions:** Reusable helpers for cleaning, parsing, and validation
- **Automated ETL:** Single-run pipeline from raw HTML to queryable database
- **Multi-source integration:** Joins battle data with economic, political, and demographic indicators
- **Scalable design:** Easily extendable to additional Wikipedia lists or external datasets

---

## 📁 Repository Structure
```
WarCast/
├── Data/
│   ├── Raw/                    # Original CSV/Excel files
│   ├── Pre_clean/              # Scraped data before processing
│   ├── Clean/                  # Processed CSVs ready for analysis
│   └── Database/
│       └── warcast.db          # SQLite database
├── notebooks/
│   ├── Webscrapping_pipeline.ipynb
│   └── DataClean_and_DatabaseCreation_pipeline.ipynb
├── sql/
│   ├── Battles.sql             # Century & conflict frequency analysis
│   ├── Country_City_battles.sql # Geographic warfare patterns
│   ├── Country_bellicism.sql   # Belligerence rankings
│   ├── Most_controversal_batles.sql # Multi-national conflicts
│   └── Politics_corruption_and_military_gdp.sql # Geopolitical analysis
├── DATABASE_SCHEMA.md          # Database schema documentation
└── README.md
```

---

## 🚀 Workflow
```
Wikipedia Pages
      ↓
[Web Scraping] → battles_list.csv, battle_info.csv
      ↓
[Data Cleaning] → clean_battles.csv, clean_battle_info.csv
      ↓
[Database Load] → warcast.db (SQLite)
      ↓
[SQL Analytics] → Insights & Visualizations
```

---

## 📌 Status

⚠️ **Work in Progress** — This project is under active development.

**Completed:**
- ✅ Web scraping pipeline with error handling
- ✅ Data cleaning and standardization
- ✅ SQLite database creation
- ✅ Multi-dataset integration
- ✅ Advanced SQL analytics (5 analysis modules)

**In Progress:**
- 🚧 Exploratory data analysis (EDA) with visualizations
- 🚧 Statistical modeling

**Planned:**
- 📋 Machine learning classification models (battle outcome prediction)
- 📋 Interactive dashboard (Plotly/Dash)
- 📋 Geospatial visualizations (map-based conflict analysis)
- 📋 Time-series analysis (warfare trends over centuries)

---

## 💡 Potential Applications

- Historical conflict pattern analysis across centuries
- Geopolitical risk modeling based on economic/political factors
- Correlation studies between military spending, corruption, and war frequency
- Temporal trends in warfare (casualty rates, battle durations, conflict intensity)
- Geospatial clustering of historical conflicts
- Predictive modeling of battle outcomes using socioeconomic indicators

---

## 🧰 Notable Custom Functions

**Web Scraping:**
- `scrape_battles_from_page()` — Extracts battle lists from Wikipedia tables
- `extract_infobox_data()` — Parses structured data from battle infoboxes
- `determine_battle_result()` — Classifies outcomes from text descriptions
- `get_alternate_battle_pages()` — Handles redirect and disambiguation pages

**Data Cleaning:**
- `clean_battles_csv()` — Standardizes battle metadata
- `extract_city_country()` — Parses location strings into structured fields
- `standardize_country_name()` — Normalizes country names across datasets
- `clean_cpi_scores()` — Processes corruption index data
- `insert_clean_csv_to_sqlite()` — Batch uploads cleaned data to database

**SQL Analytics:**
- Complex CTEs for multi-level aggregations
- Window functions (RANK, ROW_NUMBER) for top-N analyses
- Multi-table joins across temporal and geospatial dimensions
- Percentage calculations and statistical summaries

---

## 👨‍💻 Author

Luís Sousa — [LinkedIn](https://www.linkedin.com/in/luis-ma-sousa31) | [GitHub](https://github.com/luismasousa)

---

## 🔗 Related Projects

- **[DeepWalk](https://github.com/luismasousa/DeepWalk)** — ML classification of Parkinson's motor deficits using gait data
- **[BehaviourInSight](https://github.com/luismasousa/BehaviourInSight)** — Automated analysis of rodent behavioral tests
