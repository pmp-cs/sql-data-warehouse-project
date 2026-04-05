/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
  This script checks the data quality of gold layer.

Usage Notes:
  Run this script after creating gold views.
===============================================================================
*/

SELECT DISTINCT gender FROM gold_dim_customers;

SELECT * FROM gold_dim_customers;

SELECT * FROM gold_dim_products;

SELECT *
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
on f.product_key = p.product_key
WHERE p.product_key IS NULL;

SELECT *
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c
on f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
