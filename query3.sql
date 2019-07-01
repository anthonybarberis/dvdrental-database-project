SELECT  f.title,
        c.name category,
        COUNT(r.rental_id)
FROM    film f
JOIN    film_category fc
  ON    f.film_id = fc.film_id
JOIN    category c
  ON    fc.category_id = c.category_id
 AND    c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
JOIN    inventory i
  ON    i.film_id = f.film_id
JOIN    rental r
  ON    r.inventory_id = i.inventory_id
GROUP   BY  1,
            2
ORDER   BY  2,
            3 DESC
;