WITH country_conflict_stats AS (
    SELECT
        bi.country_battle_location AS country,
        b.conflict,
        COUNT(DISTINCT bi.battle_id) AS conflict_battle_count,
        SUM(COALESCE(bi.deaths, 0)) AS conflict_deaths
    FROM battle_info bi
    JOIN battles b ON bi.battle_id = b.battle_id
    WHERE bi.country_battle_location IS NOT NULL
      AND TRIM(bi.country_battle_location) != ''
      AND b.conflict IS NOT NULL
      AND TRIM(b.conflict) != ''
    GROUP BY bi.country_battle_location, b.conflict
),
most_frequent_conflict_per_country AS (
    SELECT 
        country,
        conflict,
        conflict_battle_count,
        conflict_deaths,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY conflict_battle_count DESC
        ) AS row_num
    FROM country_conflict_stats
),
base_country_stats AS (
    SELECT
        bi.country_battle_location AS country,
        COUNT(DISTINCT bi.battle_id) AS num_battles,
        SUM(COALESCE(bi.deaths, 0)) AS total_deaths
    FROM battle_info bi
    WHERE bi.country_battle_location IS NOT NULL
      AND TRIM(bi.country_battle_location) != ''
    GROUP BY bi.country_battle_location
),
average_conflict_year AS (
    SELECT 
        bi.country_battle_location AS country,
        b.conflict,
        CAST(ROUND(AVG(b.year)) AS INTEGER) AS avg_year
    FROM battle_info bi
    JOIN battles b ON bi.battle_id = b.battle_id
    WHERE bi.country_battle_location IS NOT NULL
      AND TRIM(bi.country_battle_location) != ''
      AND b.conflict IS NOT NULL
      AND TRIM(b.conflict) != ''
      AND b.year IS NOT NULL
    GROUP BY bi.country_battle_location, b.conflict
),
city_stats_within_conflict AS (
    SELECT 
        bi.country_battle_location AS country,
        b.conflict,
        bi.city_battle_location AS city,
        COUNT(DISTINCT bi.battle_id) AS battle_count,
        SUM(COALESCE(bi.deaths, 0)) AS deaths
    FROM battle_info bi
    JOIN battles b ON bi.battle_id = b.battle_id
    WHERE bi.country_battle_location IS NOT NULL
      AND TRIM(bi.country_battle_location) != ''
      AND bi.city_battle_location IS NOT NULL
      AND TRIM(bi.city_battle_location) != ''
      AND b.conflict IS NOT NULL
      AND TRIM(b.conflict) != ''
    GROUP BY bi.country_battle_location, b.conflict, bi.city_battle_location
),
top_city_per_country_conflict AS (
    SELECT 
        country,
        conflict,
        city,
        battle_count,
        deaths,
        ROW_NUMBER() OVER (
            PARTITION BY country, conflict
            ORDER BY battle_count DESC, deaths DESC
        ) AS row_num
    FROM city_stats_within_conflict
),
deadliest_battle_per_city_conflict AS (
    SELECT 
        bi.country_battle_location AS country,
        b.conflict,
        bi.city_battle_location AS city,
        b.battle_name,
        bi.battle_id,
        MAX(COALESCE(bi.deaths, 0)) AS battle_deaths,
        bi.result AS battle_result
    FROM battle_info bi
    JOIN battles b ON bi.battle_id = b.battle_id
    WHERE bi.country_battle_location IS NOT NULL
      AND bi.city_battle_location IS NOT NULL
      AND b.conflict IS NOT NULL
    GROUP BY bi.country_battle_location, b.conflict, bi.city_battle_location, b.battle_name, bi.battle_id, bi.result
),
deadliest_battle_ranked AS (
    SELECT 
        country,
        conflict,
        city,
        battle_name,
        battle_id,
        battle_deaths,
        battle_result,
        ROW_NUMBER() OVER (
            PARTITION BY country, conflict, city
            ORDER BY battle_deaths DESC
        ) AS row_num
    FROM deadliest_battle_per_city_conflict
)

SELECT 
    base.country,
    base.num_battles,
    base.total_deaths,
    
    mfc.conflict AS most_frequent_conflict,
    mfc.conflict_battle_count AS most_frequent_conflict_battles,
    mfc.conflict_deaths AS most_frequent_conflict_deaths,
    ROUND(100.0 * mfc.conflict_deaths / NULLIF(base.total_deaths, 0), 2) AS conflict_deaths_percentage,
    
    acy.avg_year AS average_conflict_date,

    tc.city AS most_frequent_city,
    tc.battle_count AS most_frequent_city_battles,
    tc.deaths AS most_frequent_city_deaths,
    ROUND(100.0 * tc.deaths / NULLIF(base.total_deaths, 0), 2) AS most_frequent_city_deaths_percentage,

    dbc.battle_name AS deadliest_battle_name,
    dbc.battle_deaths AS deadliest_battle_deaths,
    ROUND(100.0 * dbc.battle_deaths / NULLIF(mfc.conflict_deaths, 0), 2) AS deadliest_battle_deaths_percent,
    dbc.battle_result AS deadliest_battle_result

FROM base_country_stats base
JOIN most_frequent_conflict_per_country mfc
  ON base.country = mfc.country AND mfc.row_num = 1
LEFT JOIN average_conflict_year acy
  ON acy.country = mfc.country AND acy.conflict = mfc.conflict
LEFT JOIN top_city_per_country_conflict tc
  ON tc.country = mfc.country AND tc.conflict = mfc.conflict AND tc.row_num = 1
LEFT JOIN deadliest_battle_ranked dbc
  ON dbc.country = mfc.country AND dbc.conflict = mfc.conflict AND dbc.city = tc.city AND dbc.row_num = 1

ORDER BY base.num_battles DESC, base.total_deaths DESC
LIMIT 10;