-- =========================
-- DATABASE
-- =========================
CREATE DATABASE IF NOT EXISTS bronze;
USE bronze;

-- =========================
-- CLEAN START
-- =========================
DROP TABLE IF EXISTS crm_cust_info;
DROP TABLE IF EXISTS crm_prd_info;
DROP TABLE IF EXISTS crm_sales_details;
DROP TABLE IF EXISTS erp_loc;
DROP TABLE IF EXISTS erp_cust_az12;
DROP TABLE IF EXISTS erp_px_cat_g1v2;

-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE erp_loc (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);

-- =========================
-- LOAD DATA (FIXED VERSION)
-- =========================

-- 🔹 CRM CUSTOMER
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @fname, @lname, @marital, @gndr, @create_date)
SET
cst_id = NULLIF(@cst_id, ''),
cst_key = @cst_key,
cst_firstname = @fname,
cst_lastname = @lname,
cst_marital_status = @marital,
cst_gndr = @gndr,
cst_create_date = NULLIF(@create_date, '');

-- 🔹 CRM PRODUCT
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start, @prd_end)
SET
prd_id = NULLIF(@prd_id, ''),
prd_key = @prd_key,
prd_nm = @prd_nm,
prd_cost = NULLIF(@prd_cost, ''),
prd_line = @prd_line,
prd_start_dt = NULLIF(@prd_start, ''),
prd_end_dt = NULLIF(@prd_end, '');

-- 🔹 CRM SALES (IMPORTANT)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@sls_ord_num,
 @sls_prd_key,
 @sls_cust_id,
 @sls_order_dt,
 @sls_ship_dt,
 @sls_due_dt,
 @sls_sales,
 @sls_quantity,
 @sls_price)
SET
sls_ord_num  = @sls_ord_num,
sls_prd_key  = @sls_prd_key,
sls_cust_id  = NULLIF(@sls_cust_id, ''),
sls_order_dt = NULLIF(@sls_order_dt, ''),
sls_ship_dt  = NULLIF(@sls_ship_dt, ''),
sls_due_dt   = NULLIF(@sls_due_dt, ''),
sls_sales    = NULLIF(@sls_sales, ''),
sls_quantity = NULLIF(@sls_quantity, ''),
sls_price    = NULLIF(@sls_price, '');

-- 🔹 ERP LOCATION
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
INTO TABLE erp_loc
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET
cid = nullif(@cid,''),
cntry = nullif(@cntry,'');

-- 🔹 ERP CUSTOMER
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET
cid =nullif(@cid,''),
bdate = NULLIF(@bdate, ''),
gen = nullif(@gen,'');

-- 🔹 ERP PRODUCT CATEGORY
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id, @cat, @subcat, @maintenance)
SET
id = nullif(@id,''),
cat = nullif(@cat,''),
subcat = nullif(@subcat,''),
maintenance = nullif(@maintenance,'');

-- =========================
-- VALIDATION
-- =========================

SELECT 'crm_cust_info', COUNT(*) FROM crm_cust_info;
SELECT 'crm_prd_info', COUNT(*) FROM crm_prd_info;
SELECT 'crm_sales_details', COUNT(*) FROM crm_sales_details;
SELECT 'erp_loc', COUNT(*) FROM erp_loc;
SELECT 'erp_cust_az12', COUNT(*) FROM erp_cust_az12;
SELECT 'erp_px_cat_g1v2', COUNT(*) FROM erp_px_cat_g1v2;