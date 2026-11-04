-- 09. Кто из стримеров за какую команду выступает сейчас.
-- Только действующие составы; стримеры без player_id не выводятся.
--
-- Колонки: streamer, platform, player, team, tag, followers
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

SELECT
    s.nickname AS streamer,
    pl.name AS platform,
    p.nickname AS player,
    t.name AS team,
    t.tag,
    s.followers
FROM streamers s
         JOIN platforms pl
              ON s.platform_id = pl.platform_id
         JOIN players p
              ON s.player_id = p.player_id
         JOIN team_members tm
              ON p.player_id = tm.player_id
         JOIN teams t
              ON tm.team_id = t.team_id
WHERE tm.left_at IS NULL
ORDER BY s.followers DESC, streamer ASC;