-- =========================
-- CREATE SILVER DATABASE
-- =========================
CREATE DATABASE IF NOT EXISTS silver;
USE silver;

-- =========================
-- CLEAN START
-- =========================
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS fact_sales;

-- =========================
-- DIM CUSTOMERS
-- =========================
CREATE TABLE dim_customers AS
SELECT
    c.cst_id AS customer_id,
    c.cst_key,

    CONCAT(TRIM(c.cst_firstname), ' ', TRIM(c.cst_lastname)) AS full_name,

    -- Standardize gender
    CASE 
        WHEN LOWER(e.gen) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(e.gen) IN ('f', 'female') THEN 'Female'
        ELSE 'Unknown'
    END AS gender,

    e.bdate AS birthdate,

    l.cntry AS country,

    c.cst_create_date AS created_date

FROM bronze.crm_cust_info c

LEFT JOIN bronze.erp_cust_az12 e
    ON c.cst_key = e.cid

LEFT JOIN bronze.erp_loc l
    ON c.cst_key = l.cid

WHERE c.cst_id IS NOT NULL;

-- =========================
-- DIM PRODUCTS
-- =========================
CREATE TABLE dim_products AS
SELECT
    p.prd_id AS product_id,
    p.prd_key,
    TRIM(p.prd_nm) AS product_name,
    p.prd_cost,
    p.prd_line,

    e.cat AS category,
    e.subcat AS subcategory,
    e.maintenance

FROM bronze.crm_prd_info p

LEFT JOIN bronze.erp_px_cat_g1v2 e
    ON p.prd_key = e.id

WHERE p.prd_id IS NOT NULL;

-- =========================
-- FACT SALES
-- =========================
DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales AS
SELECT
    s.sls_ord_num AS order_id,
    s.sls_prd_key AS product_key,
    s.sls_cust_id AS customer_id,

    -- FINAL SAFE DATE CONVERSION
    CASE 
        WHEN s.sls_order_dt IS NULL 
             OR s.sls_order_dt = 0 
             OR LENGTH(s.sls_order_dt) != 8
        THEN NULL
        ELSE STR_TO_DATE(s.sls_order_dt, '%Y%m%d')
    END AS order_date,

    CASE 
        WHEN s.sls_ship_dt IS NULL 
             OR s.sls_ship_dt = 0 
             OR LENGTH(s.sls_ship_dt) != 8
        THEN NULL
        ELSE STR_TO_DATE(s.sls_ship_dt, '%Y%m%d')
    END AS ship_date,

    CASE 
        WHEN s.sls_due_dt IS NULL 
             OR s.sls_due_dt = 0 
             OR LENGTH(s.sls_due_dt) != 8
        THEN NULL
        ELSE STR_TO_DATE(s.sls_due_dt, '%Y%m%d')
    END AS due_date,

    s.sls_sales AS sales_amount,
    s.sls_quantity,
    s.sls_price

FROM bronze.crm_sales_details s

WHERE s.sls_sales IS NOT NULL;

-- =========================
-- OPTIONAL: REMOVE DUPLICATES
-- =========================
DROP TABLE IF EXISTS dim_customers_clean;

CREATE TABLE dim_customers_clean AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY customer_id) AS rn
    FROM dim_customers
) t
WHERE rn = 1;

-- =========================
-- QUALITY CHECKS
-- =========================

-- Null checks
SELECT COUNT(*) AS null_customers
FROM dim_customers
WHERE customer_id IS NULL;

-- Duplicate check
SELECT customer_id, COUNT(*)
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Date check
SELECT * FROM fact_sales
WHERE order_date IS NULL;

-- Row counts
SELECT 'dim_customers', COUNT(*) FROM dim_customers;
SELECT 'dim_products', COUNT(*) FROM dim_products;
SELECT 'fact_sales', COUNT(*) FROM fact_sales;