/* Which month in 2022 has had the highest revenue? */


/* View some data in the orders table */
SELECT
    product_code,
    product_quantity,
    order_date,
    shipping_date,
    total_orders
FROM
    orders    
WHERE
    order_date BETWEEN '2021-12-31 23:59:59' AND '2022-12-31 23:59:59';


/* View some data in the forquerying2 table */
SELECT 
    product_quantity,
    dates,
    month_name,
    sale_price
FROM
    forquerying2
WHERE 
    dates BETWEEN '2021-12-31 23:59:59' AND '2022-12-31 23:59:59';


/* Run query to find month with highest revenue */
SELECT
    month_name,
    SUM(product_quantity * sale_price) AS sum_sales_amount
FROM
    forquerying2
WHERE 
    dates BETWEEN '2021-12-31 23:59:59' AND '2022-12-31 23:59:59'
GROUP BY 
    month_name
ORDER BY
    sum_sales_amount DESC;


/* The month with the highest revenue in the year 2022 was August. */

