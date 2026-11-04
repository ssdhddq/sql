-- 15. Сколько донатов собрал каждый стример.
-- В ответе все стримеры: без донатов donations = 0 и total_amount = 0.00;
-- team — команда с left_at IS NULL, иначе пусто.
--
-- Колонки: streamer, platform, team, donations, total_amount
-- Порядок: total_amount по убыванию, при равенстве streamer по возрастанию
-- Строк:   40

WITH donation_totals AS (
    SELECT
        st.streamer_id,
        COUNT(d.donation_id) AS donations,
        SUM(d.amount) AS total_amount
    FROM streams st
             JOIN stream_donations d
                  ON st.stream_id = d.stream_id
    GROUP BY st.streamer_id
)
SELECT
    s.nickname AS streamer,
    pl.name AS platform,
    t.name AS team,
    COALESCE(dt.donations, 0) AS donations,
    COALESCE(dt.total_amount, 0.00) AS total_amount
FROM streamers s
         JOIN platforms pl
              ON s.platform_id = pl.platform_id
         LEFT JOIN donation_totals dt
                   ON s.streamer_id = dt.streamer_id
         LEFT JOIN team_members tm
                   ON s.player_id = tm.player_id
                       AND tm.left_at IS NULL
         LEFT JOIN teams t
                   ON tm.team_id = t.team_id
ORDER BY total_amount DESC, streamer ASC;