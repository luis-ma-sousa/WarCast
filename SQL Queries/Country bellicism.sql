WITH conflict_century AS (
    SELECT 
        conflict,
        MIN(year) AS first_year
    FROM battles
    WHERE conflict IS NOT NULL AND year IS NOT NULL
    GROUP BY conflict
),

top_country_per_conflict AS (
    SELECT 
        b.conflict,
        bi.country,
        COUNT(DISTINCT b.battle_id) AS country_battle_count,
        RANK() OVER (
            PARTITION BY b.conflict 
            ORDER BY COUNT(DISTINCT b.battle_id) DESC
        ) AS rnk
    FROM battles b
    JOIN battle_info bi ON b.battle_id = bi.battle_id
    WHERE b.conflict IS NOT NULL
    GROUP BY b.conflict, bi.country
),

top_winner_per_conflict AS (
    SELECT 
        b.conflict,
        bi.country,
        COUNT(*) AS win_count,
        RANK() OVER (
            PARTITION BY b.conflict 
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM battles b
    JOIN battle_info bi ON b.battle_id = bi.battle_id
    WHERE LOWER(TRIM(bi.result)) = 'winner'
      AND b.conflict IS NOT NULL
    GROUP BY b.conflict, bi.country
),

top_loser_per_conflict AS (
    SELECT 
        b.conflict,
        bi.country,
        COUNT(*) AS lose_count,
        RANK() OVER (
            PARTITION BY b.conflict 
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM battles b
    JOIN battle_info bi ON b.battle_id = bi.battle_id
    WHERE LOWER(TRIM(bi.result)) = 'loser'
      AND b.conflict IS NOT NULL
    GROUP BY b.conflict, bi.country
)

SELECT 
    b.conflict,
    CAST((cc.first_year - 1) / 100 + 1 AS INTEGER) AS century,
    COUNT(DISTINCT bi.country) AS num_countries_involved,
    SUM(bi.troops) AS total_troops_involved,
    SUM(bi.deaths) AS total_deaths,
    tc.country AS most_frequent_country,
    tw.country AS most_frequent_winner,
    tl.country AS most_frequent_loser

FROM battles b
JOIN battle_info bi ON b.battle_id = bi.battle_id
JOIN conflict_century cc ON b.conflict = cc.conflict
LEFT JOIN top_country_per_conflict tc ON b.conflict = tc.conflict AND tc.rnk = 1
LEFT JOIN top_winner_per_conflict tw ON b.conflict = tw.conflict AND tw.rnk = 1
LEFT JOIN top_loser_per_conflict tl ON b.conflict = tl.conflict AND tl.rnk = 1

WHERE b.conflict IS NOT NULL

GROUP BY 
    b.conflict, century, 
    tc.country, tw.country, tl.country


ORDER BY 
    num_countries_involved DESC 
    
LIMIT 5;


