/*
===============================================================================
DDL Script: Create Gold Tables
===============================================================================
Script Purpose:
    This script creates physical tables for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Unlike views, these are materialized tables designed for:
        - Performance optimization
        - Indexing strategy
        - Power BI integration
        - Production-style analytics workloads

    This script also creates necessary indexes to improve query performance.

Usage:
    - Execute after Silver layer is created.
    - Data loading should be handled via stored procedure (proc_load_gold.sql).
===============================================================================
*/

-- =============================================================================
-- Drop Existing Objects (If Any)
-- =============================================================================

IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO

IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO


-- =============================================================================
-- Create Dimension Table: gold.dim_customers
-- =============================================================================
CREATE TABLE gold.dim_customers (
    customer_key     INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key
    customer_id      INT,
    customer_number  NVARCHAR(50),
    first_name       NVARCHAR(100),
    last_name        NVARCHAR(100),
    country          NVARCHAR(100),
    marital_status   NVARCHAR(50),
    gender           NVARCHAR(10),
    birthdate        DATE,
    create_date      DATE
);
GO


-- =============================================================================
-- Create Dimension Table: gold.dim_products
-- =============================================================================
CREATE TABLE gold.dim_products (
    product_key     INT IDENTITY(1,1) PRIMARY KEY,    -- Surrogate Key
    product_id      INT,
    product_number  NVARCHAR(50),
    product_name    NVARCHAR(100),
    category_id     NVARCHAR(50),
    category        NVARCHAR(100),
    subcategory     NVARCHAR(100),
    maintenance     NVARCHAR(50),
    cost            DECIMAL(10,2),
    product_line    NVARCHAR(50),
    start_date      DATE
);
GO


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
CREATE TABLE gold.fact_sales (
    order_number   NVARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   DECIMAL(18,2),
    quantity       INT,
    price          DECIMAL(18,2)
);
GO


-- =============================================================================
-- Create Foreign Key Constraints
-- =============================================================================
ALTER TABLE gold.fact_sales
ADD CONSTRAINT fk_fact_customer
FOREIGN KEY (customer_key)
REFERENCES gold.dim_customers(customer_key);
GO

ALTER TABLE gold.fact_sales
ADD CONSTRAINT fk_fact_product
FOREIGN KEY (product_key)
REFERENCES gold.dim_products(product_key);
GO


-- =============================================================================
-- Create Indexes on Fact Table
-- =============================================================================

-- Index on foreign keys
CREATE INDEX idx_fact_customer
ON gold.fact_sales(customer_key);
GO

CREATE INDEX idx_fact_product
ON gold.fact_sales(product_key);
GO

-- Index on date column
CREATE INDEX idx_fact_order_date
ON gold.fact_sales(order_date);
GO

-- Covering Index for analytical queries
CREATE INDEX idx_orderdate_cover
ON gold.fact_sales(order_date)
INCLUDE (sales_amount, quantity, price, product_key, customer_key);
GO

/*
===============================================================================
End of Gold Layer DDL Script
===============================================================================
*/
