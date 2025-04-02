WITH conflict_counts AS (
    SELECT
        CAST(((year - 1) / 100) + 1 AS INTEGER) AS century,
        LOWER(TRIM(conflict)) AS conflict,
        COUNT(DISTINCT battle_id) AS conflict_count
    FROM battles
    WHERE year IS NOT NULL AND conflict IS NOT NULL
    GROUP BY century, conflict
),

top_conflict_per_century AS (
    SELECT 
        century,
        conflict AS most_frequent_conflict,
        conflict_count AS most_frequent_conflict_battle_count,
        RANK() OVER (PARTITION BY century ORDER BY conflict_count DESC) AS rnk
    FROM conflict_counts
),

total_battles_per_century AS (
    SELECT
        CAST(((year - 1) / 100) + 1 AS INTEGER) AS century,
        COUNT(DISTINCT battle_id) AS total_battle_count
    FROM battles
    WHERE year IS NOT NULL
    GROUP BY century
)

SELECT
    t.century,
    t.total_battle_count,
    f.most_frequent_conflict,
    f.most_frequent_conflict_battle_count,
    ROUND(
        100.0 * f.most_frequent_conflict_battle_count / t.total_battle_count,
        1
    ) AS most_frequent_conflict_percent
FROM total_battles_per_century t
LEFT JOIN top_conflict_per_century f 
  ON f.century = t.century AND f.rnk = 1
ORDER BY t.total_battle_count DESC
LIMIT 10;


----

