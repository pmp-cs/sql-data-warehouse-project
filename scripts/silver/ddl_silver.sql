/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema and drops table if they
    have already existed. It also creates a Table for printing logs to show the
    details of loading Tables.
    Running this script to re-define the DDL structure of 'silver' Tables.
===============================================================================
*/

DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
	cst_id INT,
    cst_key VARCHAR(50) CHARACTER SET utf8mb4,
    cst_firstname VARCHAR(50) CHARACTER SET utf8mb4,
    cst_lastname VARCHAR(50) CHARACTER SET utf8mb4,
    cst_marital_status VARCHAR(50) CHARACTER SET utf8mb4,
    cst_gndr VARCHAR(50) CHARACTER SET utf8mb4,
    cst_create_date DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info (
	prd_id INT,
    cat_id VARCHAR(50) CHARACTER SET utf8mb4,
    prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    prd_nm VARCHAR(50) CHARACTER SET utf8mb4,
    prd_cost INT,
    prd_line VARCHAR(50) CHARACTER SET utf8mb4,
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
	sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_cust_az12;
CREATE TABLE silver_erp_cust_az12 (
	cid VARCHAR(50) CHARACTER SET utf8mb4,
    bdate DATE,
    gen VARCHAR(50) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_loc_a101;
CREATE TABLE silver_erp_loc_a101 (
	cid VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2 (
	id VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintenance VARCHAR(50) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_load_logs;
CREATE TABLE silver_load_logs (
	step_id INT AUTO_INCREMENT PRIMARY KEY,
	message VARCHAR(255),
	duration_sec INT
);
