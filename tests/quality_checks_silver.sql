/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
  This script checks the data quality of silver layer.

Usage Notes:
  Run this script after loading silver tables.
===============================================================================
*/

SELECT
	cst_id,
    COUNT(*)
FROM silver_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id = 0;

SELECT *
FROM silver_crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT DISTINCT cst_gndr
FROM silver_crm_cust_info;

SELECT * FROM silver_crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

SELECT * FROM silver_crm_prd_info
WHERE prd_start_dt > prd_end_dt;

SELECT
	sls_sales,
    sls_quantity,
    sls_price
FROM silver_crm_sales_details
WHERE (sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * sls_price)
OR (sls_quantity <= 0 OR sls_quantity IS NULL)
OR (sls_price <= 0 OR sls_price IS NULL);

SELECT DISTINCT gen
FROM silver_erp_cust_az12;

SELECT DISTINCT maintenance FROM silver_erp_px_cat_g1v2;
