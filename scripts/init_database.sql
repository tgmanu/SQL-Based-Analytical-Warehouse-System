/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script initializes the Data Warehouse environment.

    It performs the following operations:
    1. Checks if the 'DataWarehouse' database already exists
    2. Drops the database if it exists
    3. Creates a fresh 'DataWarehouse' database
    4. Creates three schemas representing the warehouse layers:
           - bronze : raw ingested data
           - silver : cleaned and transformed data
           - gold   : analytical and reporting tables

WARNING:
    Running this script will permanently delete the existing 
    'DataWarehouse' database along with all stored data.
    Execute only in development or when a full reset is required.
=============================================================
*/

-- Switch to system database
USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END
GO

-- Create database
CREATE DATABASE DataWarehouse;
GO

-- Switch to new database
USE DataWarehouse;
GO

-- Create schemas (layered architecture)
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
