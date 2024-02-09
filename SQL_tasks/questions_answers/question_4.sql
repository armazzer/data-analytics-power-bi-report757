/* Create a view where the rows are the store types and 
the columns are the total sales, percentage of total sales and the count of orders */


/* WORKING/TEST BLOCKS */

/* Create a basic query to calculate the sales amount as a new column */
SELECT
    store_type,
    product_quantity,
    sale_price,
    percentage_of_sales,
    (product_quantity * sale_price) AS sales_amount
FROM
    forview;

/* The calculated column looks good. */



/* Remove columns that arean't needed, include COUNT(*) for the count of orders, and use the PARTITION BY and OVER clauses */
SELECT
    store_type,
    SUM(product_quantity * sale_price) 
        OVER(PARTITION BY store_type) AS sum_sales_amount,
    percentage_of_sales,
    COUNT(*)
        OVER(PARTITION BY store_type) AS order_count
FROM
    forview;

/* The calculated results look okay, but we want to group by store_type. 
It's not clear whether the content of the percentage_of_sales column is valid, 
because each order would represent a very small percentage of sales */



/* Use GROUP BY instead of PARTITION BY and OVER clauses*/
SELECT
    store_type,
    SUM(product_quantity * sale_price) AS sum_sales_amount,
    percentage_of_sales,
    COUNT(*) AS order_count
FROM
    forview
GROUP BY
    store_type,
    percentage_of_sales
ORDER BY
    sum_sales_amount DESC;

/* The grouped results look good, but the percentage_of_sales column appears to be empty/incorrect. 
We will have to calculate 'percentage of sales' */



/* Use GROUP BY but remove percentage_of_sales column to check calculated values are the same */
SELECT
    store_type,
    SUM(product_quantity * sale_price) AS sum_sales_amount,
    COUNT(*) AS order_count
FROM
    forview
GROUP BY
    store_type
ORDER BY
    sum_sales_amount DESC;

/* The SUM and COUNT values are the same as in the result of the previous block. */



/* FINAL BLOCK */

/* A sub-clause inside a CROSS JOIN statement calculates the total_sales value in the view 'total' and adds it to every row of the main 'forview' table.
The new total_sales column is then used in the calculation of percentage_of_sales in the main SELECT clause.
We then group by store type, and also by total.total sales, since this column is still attached the table. 
Since every value in the total.total_sales is the same, it is eliminated when the query is run. */

SELECT
    store_type,
    SUM(product_quantity * sale_price) AS sum_sales_amount,
    (SUM(product_quantity * sale_price) / total_sales * 100) AS percentage_of_sales,
    COUNT(*) AS order_count
FROM
    forview
CROSS JOIN
    (SELECT SUM(product_quantity * sale_price) AS total_sales FROM forview) AS total
GROUP BY
    store_type,
    total.total_sales
ORDER BY
    sum_sales_amount DESC;

/* The result looks good! */