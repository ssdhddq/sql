-- 29. Полное дерево сборки Guardian Greaves, Bloodthorn, Harpoon и Hurricane Pike.
-- Строка на каждый путь вниз, сам корень не выводится; lvl с 1, qty — quantity последнего
-- шага, qty_total — произведение quantity по пути, path — имена от корня через ' > '.
--
-- Колонки: root_item, lvl, component, qty, qty_total, path
-- Порядок: root_item по возрастанию, затем path по возрастанию
-- Строк:   34

WITH RECURSIVE item_tree AS (
    SELECT
        i.name AS root_item,
        1 AS lvl,
        c.item_id AS component_id,
        c.name AS component,
        r.quantity AS qty,
        r.quantity AS qty_total,
        (i.name || ' > ' || c.name)::text AS path
    FROM items i
             JOIN item_recipe r
                  ON i.item_id = r.item_id
             JOIN items c
                  ON r.component_id = c.item_id
    WHERE i.name IN (
                     'Guardian Greaves',
                     'Bloodthorn',
                     'Harpoon',
                     'Hurricane Pike'
        )

    UNION ALL

    SELECT
        it.root_item,
        it.lvl + 1,
        c.item_id AS component_id,
        c.name AS component,
        r.quantity AS qty,
        it.qty_total * r.quantity AS qty_total,
        (it.path || ' > ' || c.name)::text AS path
    FROM item_tree it
             JOIN item_recipe r
                  ON it.component_id = r.item_id
             JOIN items c
                  ON r.component_id = c.item_id
)
SELECT
    root_item,
    lvl,
    component,
    qty,
    qty_total,
    path
FROM item_tree
ORDER BY root_item ASC, path ASC;