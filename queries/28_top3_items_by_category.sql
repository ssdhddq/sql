-- 28. Три самых дорогих предмета в каждой категории лавки.
-- Категория: 'recipe' при is_recipe, иначе 'assembled' при строках в item_recipe.item_id,
-- иначе 'basic'; place 1-3 по cost убыв., при равной цене по name; purchases — строк match_items, иначе 0.
--
-- Колонки: category, place, name, cost, purchases
-- Порядок: category по возрастанию, затем place по возрастанию
-- Строк:   9

WITH item_categories AS (
    SELECT
        i.item_id,
        i.name,
        i.cost,
        CASE
            WHEN i.is_recipe = TRUE THEN 'recipe'
            WHEN EXISTS (
                SELECT 1
                FROM item_recipe r
                WHERE r.item_id = i.item_id
            ) THEN 'assembled'
            ELSE 'basic'
            END AS category
    FROM items i
),
     item_stats AS (
         SELECT
             ic.category,
             ic.name,
             ic.cost,
             COUNT(mi.item_id) AS purchases
         FROM item_categories ic
                  LEFT JOIN match_items mi
                            ON ic.item_id = mi.item_id
         GROUP BY
             ic.item_id,
             ic.category,
             ic.name,
             ic.cost
     ),
     ranked_items AS (
         SELECT
             category,
             ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY cost DESC, name ASC
        ) AS place,
             name,
             cost,
             purchases
         FROM item_stats
     )
SELECT
    category,
    place,
    name,
    cost,
    purchases
FROM ranked_items
WHERE place <= 3
ORDER BY category ASC, place ASC;