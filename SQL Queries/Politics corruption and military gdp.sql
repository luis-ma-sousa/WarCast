WITH all_data AS (
    SELECT
        c.country as country,
        c.year as year,
        c.cpi_score as cpi_score,
        g.gdp as gdp_dollar,
        gm.military_percent_gdp as gdp_military_perc,
        pr.regime_type as regime_type
    FROM
        cpi c
    JOIN gdp g ON c.country = g.country AND c.year = g.year
    LEFT JOIN gdp_military gm ON gm.country = c.country AND gm.year = c.year
    LEFT JOIN political_regime pr ON pr.country = c.country AND pr.year = c.year
    WHERE gm.military_percent_gdp IS NOT NULL
)
SELECT
    country,
    year,
    MAX(COALESCE(cpi_score,0)) as highest_corruption,
    gdp_military_perc,
    regime_type
FROM all_data
GROUP BY country
ORDER BY highest_corruption ASC;

-----

WITH all_data AS (
    SELECT
        c.country as country,
        c.year as year,
        c.cpi_score as cpi_score,
        g.gdp as gdp_dollar,
        gm.military_percent_gdp as gdp_military_perc,
        pr.regime_type as regime_type
    FROM
        cpi c
    JOIN gdp g ON c.country = g.country AND c.year = g.year
    LEFT JOIN gdp_military gm ON gm.country = c.country AND gm.year = c.year
    LEFT JOIN political_regime pr ON pr.country = c.country AND pr.year = c.year
    WHERE gm.military_percent_gdp IS NOT NULL
)
SELECT
    year,
    ROUND(100.0 * SUM(CASE WHEN regime_type = 'electoral democracy' THEN 1 ELSE 0 END) / COUNT(*), 2) as Electoral_Democracy_Pct,
    ROUND(100.0 * SUM(CASE WHEN regime_type = 'electoral autocracy' THEN 1 ELSE 0 END) / COUNT(*), 2) as Electoral_Autocracy_Pct,
    ROUND(100.0 * SUM(CASE WHEN regime_type = 'liberal democracy' THEN 1 ELSE 0 END) / COUNT(*), 2) as Liberal_Democracy_Pct,
    ROUND(100.0 * SUM(CASE WHEN regime_type = 'closed autocracy' THEN 1 ELSE 0 END) / COUNT(*), 2) as Closed_Autocracy_Pct,
    COUNT(*) as Total_Countries
FROM
    all_data
WHERE regime_type IS NOT NULL
GROUP BY year
ORDER BY year ASC;


----

SELECT
    p.Population,
    p.country,
    p.year,
    pr.regime_type as regime_type,
    gm.military_percent_gdp as gdp_military_perc
FROM population p
RIGHT JOIN political_regime pr ON p.country = pr.country AND p.year = pr.year
RIGHT JOIN gdp_military gm ON gm.country = pr.country AND gm.year = pr.year
WHERE p.country IS NOT NULL AND pr.country IS NOT NULL 
      AND p.year IS NOT NULL AND pr.year IS NOT NULL AND gm.military_percent_gdp IS NOT NULL
GROUP BY p.country, p.Population, pr.regime_type, p.year, gm.military_percent_gdp
ORDER BY p.Population ASC, p.year ASC, gdp_military_perc ASC;
	
