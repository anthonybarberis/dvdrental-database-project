WITH    duration_quartiles
        AS (SELECT  f.title,
                    c.name category,
                    f.rental_duration,
                    'Quartile ' || NTILE(4) OVER (ORDER BY f.rental_duration) AS rental_duration_quartile
            FROM    film f
            JOIN    film_category fc
              ON    f.film_id = fc.film_id
            JOIN    category c
              ON    fc.category_id = c.category_id
             AND    c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
            ORDER   BY  4)
SELECT  category,
        rental_duration_quartile,
        COUNT(title)
FROM    duration_quartiles
GROUP   BY  1,
            2
ORDER   BY  1,
            2,
            3
;