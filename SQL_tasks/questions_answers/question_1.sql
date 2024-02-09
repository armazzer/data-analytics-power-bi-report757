/* Question: How many staff are there in all of the UK stores? */

/* View selected columns for context */
SELECT
    store_code,
    staff_numbers,
    country_code,
    region,
    country_region,
    country
FROM 
    dim_store
ORDER BY
    country DESC;

/* Run target query */
SELECT
    SUM(staff_numbers) AS total_staff_uk
FROM
    dim_store
WHERE
    country = 'UK';

/* Run comparative query for sense-check */
SELECT
    SUM(staff_numbers) AS total_staff
FROM
    dim_store;


/* Result makes sense. There are 13273 staff across all UK stores. */