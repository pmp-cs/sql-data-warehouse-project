/*
===============================================================================
Procedure Script: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This procedure script loads data into the 'silver' schema from bronze tables. 
    It performs the following actions:
    - Truncates the silver tables before loading data.
    - Insert transformed and cleaned data from bronze tables to silver tables.
    - Insert time of loading each tables and messages into silver_load_logs table.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Caution:
    CALL load_silver();
===============================================================================
*/

DELIMITER //
	DROP PROCEDURE IF EXISTS load_silver //
    
    CREATE PROCEDURE load_silver()
	BEGIN
		DECLARE start_time DATETIME;
        DECLARE end_time DATETIME;
        DECLARE batch_start_time DATETIME;
        DECLARE batch_end_time DATETIME;
        
        DECLARE msg TEXT;
        DECLARE errno INT;
        DECLARE state TEXT;
        
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			GET DIAGNOSTICS CONDITION 1
				msg = MESSAGE_TEXT,
                errno = MYSQL_ERRNO,
                state = RETURNED_SQLSTATE;
			SELECT msg, errno, state;
        END;
        
        SET batch_start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('=============================================');
		INSERT INTO silver_load_logs (message) VALUES ('Loading Silver Layer');
		INSERT INTO silver_load_logs (message) VALUES ('=============================================');

		INSERT INTO silver_load_logs (message) VALUES ('Loading CRM Tables');

		SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_crm_cust_info');
		TRUNCATE TABLE silver_crm_cust_info;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_crm_cust_info');
		INSERT INTO silver_crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)

		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				ELSE 'n/a'
			END AS cst_marital_status,
			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END AS cst_gndr,
			cst_create_date
		FROM (
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze_crm_cust_info
			WHERE cst_id != 0
		) t WHERE flag_last = 1;
		SET end_time = NOW();
        INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_crm_cust_info;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_crm_cust_info Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));

        SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_crm_prd_info');
		TRUNCATE TABLE silver_crm_prd_info;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_crm_prd_info');
		INSERT INTO silver_crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
			prd_nm,
			prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line,
			prd_start_dt,
			DATE_SUB(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS prd_end_dt
		FROM bronze_crm_prd_info;
        SET end_time = NOW();
		INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_crm_prd_info;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_crm_prd_info Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));

		SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_crm_sales_details');
		TRUNCATE TABLE silver_crm_sales_details;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_crm_sales_details');
		INSERT INTO silver_crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
				ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
				ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
				ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
			END AS sls_due_dt,
			CASE
				WHEN sls_sales = 0 OR (sls_sales != sls_quantity * ABS(sls_price) AND sls_price != 0) THEN sls_quantity * ABS(sls_price)
				WHEN sls_sales < 0 THEN ABS(sls_sales)
			ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price < 0 THEN ABS(sls_price)
				WHEN sls_price = 0 THEN ROUND(sls_sales / NULLIF(sls_quantity, 0), 0)
			ELSE sls_price
			END AS sls_price
		FROM bronze_crm_sales_details;
        SET end_time = NOW();
        INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_crm_sales_details;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_crm_sales_details Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));

		INSERT INTO silver_load_logs (message) VALUES ('Loading ERP Tables');

		SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_erp_cust_az12');
		TRUNCATE TABLE silver_erp_cust_az12;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_erp_cust_az12');
		INSERT INTO silver_erp_cust_az12 (cid, bdate, gen)

		SELECT
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) 
			ELSE cid
			END AS cid,
			CASE WHEN bdate > current_date() THEN NULL
			ELSE bdate
			END AS bdate,
			CASE 
				WHEN UPPER(TRIM(gen)) in ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) in ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen
		FROM bronze_erp_cust_az12;
		SET end_time = NOW();
        INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_erp_cust_az12;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_erp_cust_az12 Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));

		SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_erp_loc_a101');
		TRUNCATE TABLE silver_erp_loc_a101;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_erp_loc_a101');
		INSERT INTO silver_erp_loc_a101 (cid, cntry)

		SELECT 
			REPLACE(cid, '-', '') AS cid,
			CASE 
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry
		FROM bronze_erp_loc_a101;
        SET end_time = NOW();
        INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_erp_loc_a101;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_erp_loc_a101 Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));

		SET start_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('>> Truncating Table: silver_erp_px_cat_g1v2');
		TRUNCATE TABLE silver_erp_px_cat_g1v2;
        INSERT INTO silver_load_logs (message) VALUES ('>> Inserting Data Into: silver_erp_px_cat_g1v2');
		INSERT INTO silver_erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)

		SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM bronze_erp_px_cat_g1v2;
        SET end_time = NOW();
        INSERT INTO silver_load_logs (message) SELECT CONCAT('>> Loaded: ', COUNT(*), ' rows') FROM silver_erp_px_cat_g1v2;
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('>> Load silver_erp_px_cat_g1v2 Completed', TIMESTAMPDIFF(SECOND, start_time, end_time));
        
        SET batch_end_time = NOW();
        INSERT INTO silver_load_logs (message) VALUES ('=============================================');
		INSERT INTO silver_load_logs (message) VALUES ('Loading Silver Layer is Completed');
		INSERT INTO silver_load_logs (message, duration_sec) VALUES ('Total Load Duration', TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time));
		INSERT INTO silver_load_logs (message) VALUES ('=============================================');
	END //
DELIMITER ;
