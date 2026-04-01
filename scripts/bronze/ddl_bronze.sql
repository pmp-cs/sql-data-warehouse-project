*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema and drops table if they
    have already existed. It also creates a Table for printing logs to show the
    details of loading Tables.
    Running this script to re-define the DDL structure of 'bronze' Tables.
===============================================================================
*/

DROP TABLE IF EXISTS bronze_crm_cust_info;
CREATE TABLE bronze_crm_cust_info (
	cst_id INT,
    cst_key VARCHAR(50) CHARACTER SET utf8mb4,
    cst_firstname VARCHAR(50) CHARACTER SET utf8mb4,
    cst_lastname VARCHAR(50) CHARACTER SET utf8mb4,
    cst_marital_status VARCHAR(50) CHARACTER SET utf8mb4,
    cst_gndr VARCHAR(50) CHARACTER SET utf8mb4,
    cst_create_date DATE
);

DROP TABLE IF EXISTS bronze_crm_prd_info;
CREATE TABLE bronze_crm_prd_info (
	prd_id INT,
    prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    prd_nm VARCHAR(50) CHARACTER SET utf8mb4,
    prd_cost INT,
    prd_line VARCHAR(50) CHARACTER SET utf8mb4,
    prd_start_dt DATE,
    prd_end_dt DATE
);

DROP TABLE IF EXISTS bronze_crm_sales_details;
CREATE TABLE bronze_crm_sales_details (
	sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

DROP TABLE IF EXISTS bronze_erp_cust_az12;
CREATE TABLE bronze_erp_cust_az12 (
	cid VARCHAR(50) CHARACTER SET utf8mb4,
    bdate DATE,
    gen VARCHAR(50) CHARACTER SET utf8mb4
);

DROP TABLE IF EXISTS bronze_erp_loc_a101;
CREATE TABLE bronze_erp_loc_a101 (
	cid VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4
);

DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
CREATE TABLE bronze_erp_px_cat_g1v2 (
	id VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintenance VARCHAR(50) CHARACTER SET utf8mb4
);

DROP TABLE IF EXISTS load_logs;
CREATE TABLE load_logs (
	step_id INT AUTO_INCREMENT PRIMARY KEY,
	message VARCHAR(255),
	duration_sec INT
);
