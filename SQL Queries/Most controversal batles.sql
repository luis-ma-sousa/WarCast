WITH battle_country_counts AS (
    SELECT
        b.battle_id,
        b.battle_name,
        b.year,
        b.conflict,
        COUNT(DISTINCT bi.country) AS num_countries,
        SUM(bi.deaths) AS total_deaths
    FROM battles b
    JOIN battle_info bi ON b.battle_id = bi.battle_id
    GROUP BY b.battle_id, b.battle_name, b.year, b.conflict
),
top_5_battles AS (
    SELECT *
    FROM battle_country_counts
    ORDER BY num_countries DESC, total_deaths DESC
    LIMIT 5
),
battle_countries AS (
    SELECT 
        bi.battle_id,
        GROUP_CONCAT(DISTINCT bi.country) AS countries
    FROM battle_info bi
    GROUP BY bi.battle_id
),
battle_locations AS (
    SELECT bi.battle_id, bi.country_battle_location AS location_country
    FROM battle_info bi
    WHERE bi.country_battle_location IS NOT NULL
      AND TRIM(bi.country_battle_location) != ''
    GROUP BY bi.battle_id
)
SELECT 
    t.battle_name,
    t.year,
    t.conflict,
    t.num_countries,
    t.total_deaths,
    bc.countries,
    bl.location_country
FROM top_5_battles t
LEFT JOIN battle_countries bc ON t.battle_id = bc.battle_id
LEFT JOIN battle_locations bl ON t.battle_id = bl.battle_id
ORDER BY t.num_countries DESC, t.total_deaths DESC;
