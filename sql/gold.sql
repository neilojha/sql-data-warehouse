CREATE DATABASE IF NOT EXISTS gold;
USE gold;
CREATE TABLE dim_customers AS
SELECT
    customer_id,
    full_name,
    gender,
    country,
    created_date
FROM silver.dim_customers;
CREATE TABLE dim_products AS
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    maintenance
FROM silver.dim_products;
CREATE TABLE fact_sales AS
SELECT
    f.order_id,
    f.customer_id,
    p.product_id,

    f.order_date,
    f.ship_date,
    f.due_date,

    f.sales_amount,
    f.sls_quantity AS quantity,
    f.sls_price AS price

FROM silver.fact_sales f

LEFT JOIN silver.dim_products p
    ON f.product_key = p.prd_key;
    SELECT
    c.full_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
ON f.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    p.product_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY month
ORDER BY month;
SELECT
    customer_id,
    SUM(sales_amount) AS total_spent,
    CASE
        WHEN SUM(sales_amount) > 10000 THEN 'High Value'
        WHEN SUM(sales_amount) > 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS segment
FROM gold.fact_sales
GROUP BY customer_id;