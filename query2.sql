SELECT  DATE_TRUNC('month', p.payment_date) payment_month,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(p.payment_id),
        SUM(p.amount),
        SUM(p.amount) - LAG(SUM(p.amount),1) OVER (PARTITION BY c.customer_id ORDER BY DATE_TRUNC('month', p.payment_date)) AS monthly_diff
FROM    payment p
JOIN    customer c
  ON    c.customer_id = p.customer_id
 AND    c.customer_id IN    (SELECT  c.customer_id
                            FROM    customer c
                            JOIN    payment p
                              ON    p.customer_id = c.customer_id
                            GROUP   BY 1
                            ORDER   BY SUM(p.amount) DESC
                            LIMIT   10)
GROUP   BY  1,
            2,
            c.customer_id
ORDER   BY  1,
            2
;