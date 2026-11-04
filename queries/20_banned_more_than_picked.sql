-- 20. Герои, которых на патче банили чаще, чем брали.
-- Патч — matches.patch_id; в ответе пары с bans строго больше picks, diff = bans - picks.
--
-- Колонки: version, hero, bans, picks, diff
-- Порядок: diff по убыванию, затем hero по возрастанию, затем version по возрастанию
-- Строк:   99

WITH bans AS (
    SELECT
        m.patch_id,
        mb.hero_id,
        COUNT(*) AS bans
    FROM match_bans mb
             JOIN matches m
                  ON mb.match_id = m.match_id
    GROUP BY m.patch_id, mb.hero_id
),
     picks AS (
         SELECT
             m.patch_id,
             mp.hero_id,
             COUNT(*) AS picks
         FROM match_players mp
                  JOIN matches m
                       ON mp.match_id = m.match_id
         GROUP BY m.patch_id, mp.hero_id
     )
SELECT
    p.version,
    h.name AS hero,
    COALESCE(b.bans, 0) AS bans,
    COALESCE(pk.picks, 0) AS picks,
    COALESCE(b.bans, 0) - COALESCE(pk.picks, 0) AS diff
FROM bans b
         FULL JOIN picks pk
                   ON b.patch_id = pk.patch_id
                       AND b.hero_id = pk.hero_id
         JOIN patches p
              ON p.patch_id = COALESCE(b.patch_id, pk.patch_id)
         JOIN heroes h
              ON h.hero_id = COALESCE(b.hero_id, pk.hero_id)
WHERE COALESCE(b.bans, 0) > COALESCE(pk.picks, 0)
ORDER BY diff DESC, hero ASC, version ASC;