CREATE TABLE IF NOT EXISTS location_ids (left_id INT, right_id INT);
\COPY location_ids FROM '../inputs/input' WITH DELIMITER ' ' CSV;

WITH sorted_left AS (
    SELECT left_id,
        ROW_NUMBER() OVER (
            ORDER BY left_id
        ) AS row_num
    FROM location_ids
),
sorted_right AS (
    SELECT right_id,
        ROW_NUMBER() OVER (
            ORDER BY right_id
        ) AS row_num
    FROM location_ids
),
distance AS (
    SELECT SUM(ABS(sorted_left.left_id - sorted_right.right_id)) as dist
    FROM sorted_left
        JOIN sorted_right ON sorted_left.row_num = sorted_right.row_num
),
frequencies AS (
    SELECT location_ids.left_id,
        COUNT(*) AS frequency
    FROM location_ids
        JOIN location_ids AS right_list ON location_ids.left_id = right_list.right_id
    GROUP BY location_ids.left_id
)
SELECT d.dist,
    (
        SELECT SUM(f.left_id * COALESCE(f.frequency, 0))
        FROM frequencies AS f
    ) AS part_2
FROM distance AS d;

DROP TABLE IF EXISTS location_ids;