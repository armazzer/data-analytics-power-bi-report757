
/* List all tables schemas, names and types */
SELECT 
    table_schema, 
    table_name,
    table_type
FROM 
    information_schema.TABLES
ORDER BY
    table_name ASC;


/* List selected tables names based on specified schema and type */
SELECT
    table_schema,
    table_name,
    table_type
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    table_schema = 'public'
AND
    table_type = 'BASE TABLE'
ORDER BY
    table_name ASC;


/* List all column names in the 'orders' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_schema = 'public'
AND
    table_name = 'orders';


/* List all column names in the 'country_region' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_schema = 'public'
AND
    table_name = 'country_region';


/* List all column names in the 'dim_customer' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_schema = 'public'
AND
    table_name = 'dim_customer';


/* List all column names in the 'dim_date' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_schema = 'public'
AND
    table_name = 'dim_date';


/* List all column names in the 'dim_product' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_name = 'dim_product';


/* List all column names in the 'dim_store' table */
SELECT
    column_name
FROM 
    INFORMATION_SCHEMA.columns
WHERE 
    table_name = 'dim_store';