/*
===============================================================================
Loading Script: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA LOCAL` command to load data from csv Files to bronze tables.
    - Inserts time of loading each tables and messages into load_logs table.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Caution:
    When using MySQL Workbench, please add OPT_LOCAL_INFILE=1 in
    Connection->Advanced->Others.
===============================================================================
*/

SET GLOBAL local_infile = 1;

TRUNCATE TABLE load_logs;

SET @batch_start_time = NOW();
INSERT INTO load_logs (message) VALUES ('=============================================');
INSERT INTO load_logs (message) VALUES ('Loading Bronze Layer');
INSERT INTO load_logs (message) VALUES ('=============================================');

INSERT INTO load_logs (message) VALUES ('Loading CRM Tables');

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_crm_cust_info');
TRUNCATE TABLE bronze_crm_cust_info;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_crm_cust_info');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_crm_cust_info;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_crm_cust_info Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_crm_prd_info');
TRUNCATE TABLE bronze_crm_prd_info;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_crm_prd_info');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_crm_prd_info;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_crm_prd_info Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_crm_sales_details');
TRUNCATE TABLE bronze_crm_sales_details;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_crm_sales_details');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_crm_sales_details;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_crm_sales_details Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

INSERT INTO load_logs (message) VALUES ('Loading ERP Tables');

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_erp_cust_az12');
TRUNCATE TABLE bronze_erp_cust_az12;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_erp_cust_az12');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_erp/cust_az12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_erp_cust_az12;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_erp_cust_az12 Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_erp_loc_a101');
TRUNCATE TABLE bronze_erp_loc_a101;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_erp_loc_a101');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_erp/loc_a101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_erp_loc_a101;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_erp_loc_a101 Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

SET @start_time = NOW();
INSERT INTO load_logs (message) VALUES ('>> Truncating Table: bronze_erp_px_cat_g1v2');
TRUNCATE TABLE bronze_erp_px_cat_g1v2;

INSERT INTO load_logs (message) VALUES ('>> Inserting Data Into: bronze_erp_px_cat_g1v2');
LOAD DATA LOCAL INFILE 'C:/Users/mmj01/OneDrive/Desktop/projects/data_engineer/DWH_project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
INSERT INTO load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM bronze_erp_px_cat_g1v2;
INSERT INTO load_logs (message, duration_sec) VALUES ('>> Load bronze_erp_px_cat_g1v2 Completed', TIMESTAMPDIFF(SECOND, @start_time, @end_time));

SET @batch_end_time = NOW();
INSERT INTO load_logs (message) VALUES ('=============================================');
INSERT INTO load_logs (message) VALUES ('Loading Bronze Layer is Completed');
INSERT INTO load_logs (message, duration_sec) VALUES ('Total Load Duration', TIMESTAMPDIFF(SECOND, @batch_start_time, @batch_end_time));
INSERT INTO load_logs (message) VALUES ('=============================================');

SELECT * FROM load_logs;
