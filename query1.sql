WITH    outstanding_debts 
        AS  (SELECT r.rental_id,
                    r.rental_date,
                    r.return_date,
                    p.payment_id,
                    CASE
                    WHEN p.payment_date IS NULL THEN 'No Payment'
                    WHEN r.return_date IS NULL THEN 'Not Returned'
                    END debt_type,
                    CASE
                    WHEN p.payment_date IS NULL THEN f.rental_rate
                    WHEN r.return_date IS NULL THEN f.replacement_cost
                    END amount_owed
            FROM    rental r
            LEFT    JOIN payment p
              ON    r.rental_id = p.rental_id
            JOIN    inventory i
              ON    i.inventory_id = r.inventory_id
            JOIN    film f
              ON    f.film_id = i.inventory_id
            WHERE   r.return_date IS NULL OR p.payment_id IS NULL)
SELECT  DISTINCT(debt_type),
        COUNT(amount_owed) OVER debt_type units,
        SUM(amount_owed) OVER debt_type total_due
FROM    outstanding_debts
WINDOW  debt_type AS (PARTITION BY debt_type)
;