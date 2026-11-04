-- 16. Десятка самых банимых героев.
-- bans — строки match_bans, picks — строки match_players, bans_per_pick =
-- round(bans::numeric / picks, 2); первые десять берутся после сортировки.
--
-- Колонки: hero, bans, picks, bans_per_pick
-- Порядок: bans по убыванию, при равенстве hero по возрастанию
-- Строк:   10

WITH bans_count AS (
    SELECT
        hero_id,
        COUNT(*) AS bans
    FROM match_bans
    GROUP BY hero_id
),
     picks_count AS (
         SELECT
             hero_id,
             COUNT(*) AS picks
         FROM match_players
         GROUP BY hero_id
     )
SELECT
    h.name AS hero,
    b.bans,
    COALESCE(p.picks, 0) AS picks,
    ROUND(
            b.bans::numeric / NULLIF(p.picks, 0),
            2
    ) AS bans_per_pick
FROM bans_count b
         JOIN heroes h
              ON b.hero_id = h.hero_id
         LEFT JOIN picks_count p
                   ON b.hero_id = p.hero_id
ORDER BY b.bans DESC, hero ASC
    LIMIT 10;
