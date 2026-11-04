-- 30. Стоимость сборки из базовых составляющих против собственной цены предмета.
-- Берутся предметы со строками в item_recipe, сборка раскрывается до базовых (тех, у кого
-- строк в item_recipe нет, свитки тоже), количества по пути перемножаются; diff = parts_cost - cost.
--
-- Колонки: name, cost, parts_cost, base_parts, diff
-- Порядок: diff по убыванию, при равенстве name по возрастанию
-- Строк:   77

WITH RECURSIVE item_tree AS (
    SELECT
        i.item_id AS root_id,
        r.component_id,
        r.quantity AS qty_total
    FROM items i
             JOIN item_recipe r
                  ON i.item_id = r.item_id

    UNION ALL

    SELECT
        it.root_id,
        r.component_id,
        it.qty_total * r.quantity AS qty_total
    FROM item_tree it
             JOIN item_recipe r
                  ON it.component_id = r.item_id
),
               base_components AS (

                      SELECT
                       it.root_id,
                       it.component_id,
                       it.qty_total,
                       i.cost
                   FROM item_tree it
                            JOIN items i
                                 ON it.component_id = i.item_id
                   WHERE NOT EXISTS (
                       SELECT 1
                       FROM item_recipe r
                       WHERE r.item_id = it.component_id
                   )
               )
SELECT
    i.name,
    i.cost,
    SUM(b.qty_total * b.cost) AS parts_cost,
    SUM(b.qty_total) AS base_parts,
    SUM(b.qty_total * b.cost) - i.cost AS diff
FROM base_components b
         JOIN items i
              ON b.root_id = i.item_id
GROUP BY i.item_id, i.name, i.cost
ORDER BY diff DESC, i.name ASC;