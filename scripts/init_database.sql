/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates database 'DataWarehouse' after checking whether 'DataWarehouse' has already existed.
    If it has existed, this script will delete and recreate it.
    After that, the script also creates three Schemas using Tables within 'DataWarehouse': 'bronze', 'silver' and 'gold'.

WARNING:
    Running this script will delete existing database 'DataWarehouse' permanently.
    Be careful when you decide to run this script and make sure whether you have proper backups.
*/

-- Drop existed database to recreate the 'DataWarehouse' database
DROP DATABASE IF EXISTS DataWarehouse;

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
USE DataWarehouse;

-- Create Schemas by Tables
CREATE TABLE bronze (
	id INT
);
CREATE TABLE silver (
	id INT
);
CREATE TABLE gold (
	id INT
);
