/* Which German store type had the highest revenue for 2022? */

/* View some data in the forquerying2 table */
SELECT 
    country,
    full_region,
    store_type,
    product_quantity,
    dates,
    sale_price
FROM
    forquerying2
WHERE 
    dates BETWEEN '2021-12-31 23:59:59' AND '2022-12-31 23:59:59'
    AND
    country = 'Germany';


/* Create query to summarize the data and answer question 3 */
SELECT 
    store_type,
    SUM(product_quantity * sale_price) AS sum_sales_amount
FROM
    forquerying2
WHERE 
    dates BETWEEN '2021-12-31 23:59:59' AND '2022-12-31 23:59:59'
    AND
    country = 'Germany'
GROUP BY 
    store_type
ORDER BY
    sum_sales_amount DESC;


/* In Germany, the store type with the highest revenue in the year 2022 was 'Local'. */