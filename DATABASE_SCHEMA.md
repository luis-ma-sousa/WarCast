# WarCast Database Schema

## Overview

SQLite relational database containing historical battle data integrated with socioeconomic indicators spanning multiple centuries. The database enables complex analytical queries linking warfare patterns with economic, political, and demographic contexts.

**Database file:** `Data/Database/warcast.db`

---

## Data Sources & Citations

### Battle Data
**Source:** Wikipedia  
**Retrieved:** 2025  
**URLs:** 
- List of battles pages (various)
- Individual battle infobox pages

**Citation:**
```
Wikipedia contributors. Various battle articles. Wikipedia, The Free Encyclopedia.
Retrieved 2025.
```

**License:** [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)

---

### GDP Data
**Source:** World Bank  
**File:** `GDP per country_1988-2022.xlsx`  
**Temporal Coverage:** 1988-2022

**Citation:**
```
World Bank. World Development Indicators. GDP (current US$).
https://data.worldbank.org/
```

---

### Political Regime Data
**Source:** V-Dem Institute via Our World in Data  
**File:** `political-regime.csv`  
**Temporal Coverage:** 1789-2024  
**Last Updated:** March 17, 2025  
**Next Update:** March 2026

**Full Citation:**
```
V-Dem (2025) — processed by Our World in Data. "Political regime" [dataset]. 
V-Dem, "Democracy report v15" [original data].
Source: V-Dem (2025) — processed by Our World In Data
```

**In-line Citation:**
```
V-Dem (2025) — processed by Our World in Data
```

**Retrieved from:** https://ourworldindata.org/grapher/political-regime  
**Original source:** https://v-dem.net/data/the-v-dem-dataset/

**Methodology:**
- Uses the Regimes of the World classification by Anna Lührmann, Marcus Tannenberg, and Staffan Lindberg
- Classification: closed autocracies (0), electoral autocracies (1), electoral democracies (2), liberal democracies (3)
- Data expanded by Our World in Data to include historical non-sovereign territories

**License:** [V-Dem License](https://v-dem.net/data/the-v-dem-dataset/)

---

### Population Data
**Source:** Multiple sources via Our World in Data  
**File:** `population.csv`  
**Temporal Coverage:** 10,000 BCE - 2023 CE  
**Last Updated:** July 15, 2024  
**Next Update:** July 2026

**Full Citation:**
```
HYDE (2023); Gapminder (2022); UN WPP (2024) — with major processing by Our World in Data. 
"Population (historical)" [dataset]. 
PBL Netherlands Environmental Assessment Agency, "History Database of the Global Environment 3.3"; 
Gapminder, "Population v7"; United Nations, "World Population Prospects"; 
Gapminder, "Systema Globalis" [original data].
Source: HYDE (2023); Gapminder (2022); UN WPP (2024) — with major processing by Our World In Data
```

**In-line Citation:**
```
HYDE (2023); Gapminder (2022); UN WPP (2024) — with major processing by Our World in Data
```

**Data Construction:**
- **10,000 BCE - 1799:** Historical estimates by HYDE (v3.3)
- **1800 - 1949:** Historical estimates by Gapminder (v7)
- **1950 - 2023:** Population records by UN World Population Prospects (2024 revision)

**Original Sources:**
- **HYDE:** https://doi.org/10.24416/UU01-AEZZIT (Retrieved: 2024-01-02)
- **Gapminder Population:** http://gapm.io/dpop (Retrieved: 2023-03-31)
- **UN WPP:** https://population.un.org/wpp/Download/ (Retrieved: 2024-07-11)
- **Gapminder Systema Globalis:** https://github.com/open-numbers/ddf--gapminder--systema_globalis (Retrieved: 2023-03-31)

**Retrieved from:** https://ourworldindata.org/grapher/population

---

### Corruption Perception Index (CPI)
**Source:** Transparency International  
**File:** `CPI2020_GlobalTablesTS_210125.xlsx`  
**Temporal Coverage:** Varies by country (typically 1995-2020)  
**Last Updated:** January 25, 2021

**Citation:**
```
Transparency International. Corruption Perceptions Index 2020. 
Berlin: Transparency International, 2021.
https://www.transparency.org/
```

**Methodology:**
- CPI scores range from 0 (highly corrupt) to 100 (very clean)
- Based on expert assessments and opinion surveys

**License:** [Transparency International Terms of Use](https://www.transparency.org/en/terms-of-use)

---

### Military Expenditure Data
**Source:** World Bank via Stockholm International Peace Research Institute (SIPRI)  
**File:** `API_MS.MIL.XPND.GD.ZS_DS2_en_csv_v2_26302.csv`  
**Indicator Code:** MS.MIL.XPND.GD.ZS  
**Indicator Name:** Military expenditure (% of GDP)

**Citation:**
```
World Bank. World Development Indicators. Military expenditure (% of GDP).
Source: Stockholm International Peace Research Institute (SIPRI), Yearbook: Armaments, 
Disarmament and International Security.
https://data.worldbank.org/
```

**Metadata Files:**
- `Metadata_Country_API_MS.MIL.XPND.GD.ZS_DS2_en_csv_v2_26302.csv`
- `Metadata_Indicator_API_MS.MIL.XPND.GD.ZS_DS2_en_csv_v2_26302.csv`

---

## License & Attribution

This database integrates data from multiple sources, each with its own license:

- **Wikipedia:** CC BY-SA 3.0
- **Our World in Data:** CC BY 4.0
- **World Bank:** CC BY 4.0
- **V-Dem:** Custom academic license (cite as specified above)
- **Transparency International:** Custom terms of use

**When using this database, you must:**
1. Credit all original data sources as specified above
2. Adhere to each source's license terms
3. Clearly indicate any transformations or processing applied to the data

**Recommended citation for this database:**
```
Sousa, L. (2025). WarCast: Historical Battle Data Pipeline & Analysis [Database]. 
Integrating data from Wikipedia, World Bank, V-Dem, Our World in Data, 
Transparency International, and SIPRI. GitHub: https://github.com/luismasousa/WarCast
```

---

## Tables

### 1. `battles`

Core battle metadata extracted from Wikipedia.

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `battle_id` | INTEGER | PRIMARY KEY | Unique battle identifier | 1 |
| `battle_name` | TEXT | NOT NULL | Official name of the battle | "Battle of Waterloo" |
| `year` | INTEGER | | Year battle occurred | 1815 |
| `conflict` | TEXT | | Parent war or conflict | "Napoleonic Wars" |

**Data Source:** Wikipedia  
**Key Relationships:**
- One-to-many with `battle_info` (via `battle_id`)

**Indexes:**
- Primary key on `battle_id`
- Recommended index on `year` for temporal queries
- Recommended index on `conflict` for conflict-based aggregations

---

### 2. `battle_info`

Detailed battle statistics, outcomes, and participant information. Multiple rows per battle (one per participating country/side).

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `battle_id` | INTEGER | FOREIGN KEY | References `battles.battle_id` | 1 |
| `country` | TEXT | | Participating country (standardized) | "France" |
| `city_battle_location` | TEXT | | City where battle occurred | "Waterloo" |
| `country_battle_location` | TEXT | | Country where battle occurred | "Belgium" |
| `troops` | INTEGER | | Number of troops deployed | 72000 |
| `deaths` | INTEGER | | Number of casualties | 25000 |
| `result` | TEXT | | Outcome for this participant | "loser" |

**Data Source:** Wikipedia  
**Key Relationships:**
- Many-to-one with `battles` (via `battle_id`)

**Possible Values:**
- `result`: "winner", "loser", or NULL

**Data Quality Notes:**
- `troops` and `deaths` may be NULL when data unavailable
- Country names standardized to match socioeconomic datasets
- Geographic locations cleaned and separated into city/country

---

### 3. `gdp`

Economic indicators by country and year (World Bank data).

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `country` | TEXT | NOT NULL | Country name (standardized) | "United States" |
| `year` | INTEGER | NOT NULL | Year | 2020 |
| `gdp` | REAL | | GDP in current USD | 21427700000000.0 |

**Data Source:** World Bank World Development Indicators  
**Temporal Coverage:** 1988-2022

**Key Relationships:**
- Can be joined with `battle_info` via `country`
- Can be joined with other socioeconomic tables via `country` + `year`

---

### 4. `political_regime`

Government type classifications over time.

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `country` | TEXT | NOT NULL | Country name (standardized) | "France" |
| `year` | INTEGER | NOT NULL | Year | 2020 |
| `regime_type` | TEXT | | Type of political system | "liberal democracy" |

**Data Source:** V-Dem Institute via Our World in Data  
**Temporal Coverage:** 1789-2024

**Possible Values for `regime_type`:**
- `"liberal democracy"` (score 3) — Democratic with strong civil liberties and minority rights
- `"electoral democracy"` (score 2) — Meaningful, free and fair multi-party elections
- `"electoral autocracy"` (score 1) — Elections present but lacking freedoms (association, expression)
- `"closed autocracy"` (score 0) — No meaningful multi-party elections

**Definitions:**
- **Closed autocracies:** Citizens cannot choose chief executive or legislature through multi-party elections
- **Electoral autocracies:** Multi-party elections exist but lack freedoms making them meaningful/free/fair
- **Electoral democracies:** Citizens participate in meaningful, free, fair multi-party elections
- **Liberal democracies:** Electoral democracy + individual/minority rights + equality before law + executive constraints

**Key Relationships:**
- Joins with other tables via `country` + `year`

---

### 5. `population`

Historical population data by country.

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `country` | TEXT | NOT NULL | Country name (standardized) | "China" |
| `year` | INTEGER | NOT NULL | Year | 2020 |
| `Population` | INTEGER | | Total population | 1439323776 |

**Data Source:** HYDE (10,000 BCE-1799), Gapminder (1800-1949), UN WPP (1950-2023) via Our World in Data  
**Temporal Coverage:** 10,000 BCE - 2023 CE

**Key Relationships:**
- Joins with other tables via `country` + `year`

---

### 6. `cpi`

Corruption Perception Index scores (Transparency International).

| Column | Type | Constraints | Description | Range |
|--------|------|-------------|-------------|-------|
| `country` | TEXT | NOT NULL | Country name (standardized) | - |
| `year` | INTEGER | NOT NULL | Year | - |
| `cpi_score` | REAL | | Corruption perception score | 0-100 |

**Data Source:** Transparency International  
**Temporal Coverage:** Varies by country (typically 1995-2020)

**Score Interpretation:**
- **0-40:** High corruption
- **40-60:** Moderate corruption
- **60-100:** Low corruption (higher score = less corrupt)

**Key Relationships:**
- Joins with other tables via `country` + `year`

---

### 7. `gdp_military`

Military spending as percentage of GDP.

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `country` | TEXT | NOT NULL | Country name (standardized) | "United States" |
| `year` | INTEGER | NOT NULL | Year | 2020 |
| `military_percent_gdp` | REAL | | Defense spending (% of GDP) | 3.7 |

**Data Source:** World Bank / SIPRI  
**Indicator:** MS.MIL.XPND.GD.ZS

**Key Relationships:**
- Joins with other tables via `country` + `year`

**Data Quality Notes:**
- Values typically range from 0.5% to 15%
- NULL values indicate missing data for that country/year

---

## Entity-Relationship Diagram
```
                    battles (1) ──────< (M) battle_info
                       │                        │
                       │                    country
                       │                        │
                       └────────────┬───────────┘
                                    │
                    (joined via country + year)
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
      gdp                   political_regime            population
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                  cpi                        gdp_military
```

---

## Common Join Patterns

### Join battles with socioeconomic data:
```sql
SELECT 
    b.battle_name,
    b.year,
    bi.country,
    g.gdp,
    pr.regime_type,
    p.Population
FROM battles b
JOIN battle_info bi ON b.battle_id = bi.battle_id
LEFT JOIN gdp g ON bi.country = g.country AND b.year = g.year
LEFT JOIN political_regime pr ON bi.country = pr.country AND b.year = pr.year
LEFT JOIN population p ON bi.country = p.country AND b.year = p.year;
```

### Aggregate battles by country with economic context:
```sql
SELECT 
    bi.country,
    COUNT(DISTINCT b.battle_id) AS num_battles,
    SUM(bi.deaths) AS total_casualties,
    AVG(gm.military_percent_gdp) AS avg_military_spending
FROM battle_info bi
JOIN battles b ON bi.battle_id = b.battle_id
LEFT JOIN gdp_military gm ON bi.country = gm.country AND b.year = gm.year
GROUP BY bi.country
ORDER BY num_battles DESC;
```

---

## Data Quality & Cleaning Notes

### Country Name Standardization
All country names have been normalized across tables using custom cleaning functions:
- Removed coordinate patterns (e.g., "[23°N 45°E]")
- Removed geographic terms (e.g., "Kingdom of", "Republic of")
- Standardized historical names (e.g., "USSR" → "Soviet Union")
- Handled special cases (e.g., "UK" → "United Kingdom")

### Missing Data Handling
- **NULL values:** Present where data unavailable from sources
- **Queries:** Use `COALESCE()` or `NULLIF()` for safe aggregations
- **Joins:** Use `LEFT JOIN` when socioeconomic data may be missing

### Temporal Alignment
- **Battle data:** Spans multiple centuries (historical)
- **Socioeconomic data:** Modern era (varies by dataset, primarily 1980s-2020s)
- **Queries:** Filter by year range when joining to ensure valid comparisons

### Duplicate Prevention
- Primary keys enforced on `battle_id`
- Composite uniqueness expected on `(country, year)` for socioeconomic tables
- Deduplication performed during ETL pipeline

---

## Performance Recommendations

### Suggested Indexes
```sql
-- For temporal queries
CREATE INDEX idx_battles_year ON battles(year);
CREATE INDEX idx_gdp_year ON gdp(year);

-- For join performance
CREATE INDEX idx_battle_info_country ON battle_info(country);
CREATE INDEX idx_gdp_country_year ON gdp(country, year);
CREATE INDEX idx_political_regime_country_year ON political_regime(country, year);

-- For conflict analysis
CREATE INDEX idx_battles_conflict ON battles(conflict);
```

---

## Sample Analytical Queries

Full production queries available in `/sql/` directory:

- **`Battles.sql`** — Century-by-century battle frequency analysis
- **`Country_City_battles.sql`** — Geographic warfare patterns and hotspots
- **`Country_bellicism.sql`** — Belligerence rankings by conflict
- **`Most_controversal_batles.sql`** — Multi-national conflict analysis
- **`Politics_corruption_and_military_gdp.sql`** — Geopolitical correlations

---

## Schema Version

**Version:** 1.0  
**Last Updated:** 2025  
**Database Engine:** SQLite 3.x

---

## Questions or Issues?

For questions about the schema, data sources, or data quality, please contact the project maintainer or open an issue in the repository.

---

## Disclaimer

This database is compiled for educational and research purposes. While care has been taken to ensure accuracy, users should:
- Verify data against original sources for critical applications
- Understand the limitations and biases inherent in historical data
- Respect the licenses and terms of use of all original data providers
- Cite all sources appropriately in any derived work
