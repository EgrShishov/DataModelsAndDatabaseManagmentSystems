/*Services */
SELECT
    s.service_name,
    sc.category_name
FROM Services AS s
         JOIN ServiceCategory AS sc ON (sc.service_category_id=s.service_category_id)
WHERE s.is_active = true;

SELECT
    s.service_name,
    sc.category_name
FROM Services AS s
         JOIN ServiceCategory AS sc ON (sc.service_category_id=s.service_category_id)
WHERE s.service_id = 1;