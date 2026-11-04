-- 25. Место стримера-профессионала в рейтинге своей страны.
-- Только стримеры с player_id и действующей записью в team_members; место по mmr
-- по убыванию и country_players считаются по всей players; player — ник из players.
--
-- Колонки: player, country, mmr, country_rank, country_players, team_tag, platform
-- Порядок: country по возрастанию, внутри страны country_rank по возрастанию
-- Строк:   16

WITH player_ranking AS (
    SELECT
        player_id,
        nickname,
        country,
        mmr,
        RANK() OVER (
            PARTITION BY country
            ORDER BY mmr DESC
        ) AS country_rank,
        COUNT(*) OVER (
            PARTITION BY country
        ) AS country_players
    FROM players
)
SELECT
    p.nickname AS player,
    p.country,
    p.mmr,
    p.country_rank,
    p.country_players,
    t.tag AS team_tag,
    pl.name AS platform
FROM player_ranking p
         JOIN streamers s
              ON p.player_id = s.player_id
         JOIN platforms pl
              ON s.platform_id = pl.platform_id
         JOIN team_members tm
              ON p.player_id = tm.player_id
                  AND tm.left_at IS NULL
         JOIN teams t
              ON tm.team_id = t.team_id
ORDER BY p.country ASC, p.country_rank ASC;