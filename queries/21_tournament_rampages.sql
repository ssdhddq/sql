-- 21. Турнирные выступления с KDA выше шестикратного среднего.
-- KDA = (kills + assists)::numeric / GREATEST(deaths, 1); порог — строго больше шести
-- средних KDA по всей match_players; только матчи турниров; kda округлить до 2 знаков.
--
-- Колонки: match_id, tournament, player, hero, kda
-- Порядок: kda по убыванию, при равенстве match_id, затем slot
-- Строк:   60

WITH player_kda AS (
    SELECT
        mp.match_id,
        mp.player_id,
        mp.hero_id,
        mp.slot,
        (mp.kills + mp.assists)::numeric
            / GREATEST(mp.deaths, 1) AS kda
    FROM match_players mp
),
     avg_kda AS (
         SELECT AVG(kda) AS average_kda
         FROM player_kda
     )
SELECT
    pk.match_id,
    t.name AS tournament,
    p.nickname AS player,
    h.name AS hero,
    ROUND(pk.kda, 2) AS kda
FROM player_kda pk
         JOIN matches m
              ON pk.match_id = m.match_id
         JOIN tournaments t
              ON m.tournament_id = t.tournament_id
         JOIN players p
              ON pk.player_id = p.player_id
         JOIN heroes h
              ON pk.hero_id = h.hero_id
         CROSS JOIN avg_kda a
WHERE pk.kda > 6 * a.average_kda
ORDER BY kda DESC, pk.match_id ASC, pk.slot ASC;