-- 10. Все роли героев, которые умеют быть керри.
-- Только герои с ролью 'carry'; у каждого выводятся все его роли, по строке на роль.
--
-- Колонки: name, primary_attr, attack_type, role
-- Порядок: name по возрастанию, внутри героя role по возрастанию
-- Строк:   47

SELECT
    h.name,
    h.primary_attr,
    h.attack_type,
    hr.role
FROM heroes h
         JOIN hero_roles hr ON h.hero_id = hr.hero_id
WHERE EXISTS (
    SELECT 1
    FROM hero_roles cr
    WHERE cr.hero_id = h.hero_id
      AND cr.role = 'carry'
)
ORDER BY h.name ASC, hr.role ASC;