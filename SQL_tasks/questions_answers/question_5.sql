/* Which product category generated the most profit for the "Wiltshire, UK" region in 2021? */

/* WORKING/TEST BLOCKS */

/* Create a basic query to calculate the profit as a new column and display relevant columns and rows */

SELECT
    full_region,
    category,
    order_date,
    product_quantity,
    sale_price,
    cost_price,
    (product_quantity * (sale_price - cost_price)) AS profit
FROM
    forview
WHERE 
    full_region = 'Wiltshire, UK'
    AND order_date BETWEEN '2020-12-31 23:59:59' AND '2021-12-31 23:59:59'
ORDER BY
    order_date ASC;

/* The profit column looks good, and results are in within the correct region and date range */



/* FINAL BLOCK */

/* Remove columns that aren't needed, aggreagate the profit column (SUM) and GROUP BY category
ORDER BY sum_profit */

SELECT
    category,
    SUM(product_quantity * (sale_price - cost_price)) AS sum_profit
FROM
    forview
WHERE 
    full_region = 'Wiltshire, UK'
    AND order_date BETWEEN '2020-12-31 23:59:59' AND '2021-12-31 23:59:59'
GROUP BY
    category
ORDER BY
    sum_profit DESC;

/* Result looks good. In the Wiltshire, UK region in 2021, the product category 'homeware' generated the most profit. */