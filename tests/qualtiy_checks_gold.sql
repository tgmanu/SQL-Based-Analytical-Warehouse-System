/*
===============================================================================
Script: Gold Layer Post-Load Validation
===============================================================================
Purpose:
    Validates data quality, integrity, and performance after loading the
    Gold layer using gold.proc_load_gold.

Usage:
    Run this script immediately after:
        EXEC gold.proc_load_gold;

    This ensures:
        - Data loaded correctly
        - No referential integrity issues
        - No unexpected NULL keys
        - No duplicate surrogate keys
        - Aggregation sanity checks pass
===============================================================================
*/

PRINT '================ GOLD LAYER VALIDATION STARTED ================';

-- ============================================================================
-- 1️⃣ Row Count Validation
-- ============================================================================
PRINT 'Checking Row Counts...';

SELECT 'dim_customers' AS table_name, COUNT(*) AS total_rows
FROM gold.dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*)
FROM gold.dim_products
UNION ALL
SELECT 'fact_sales', COUNT(*)
FROM gold.fact_sales;


-- ============================================================================
-- 2️⃣ NULL Foreign Key Check (Fact Table)
-- ============================================================================
PRINT 'Checking NULL Foreign Keys in fact_sales...';

SELECT COUNT(*) AS null_customer_keys
FROM gold.fact_sales
WHERE customer_key IS NULL;

SELECT COUNT(*) AS null_product_keys
FROM gold.fact_sales
WHERE product_key IS NULL;


-- ============================================================================
-- 3️⃣ Referential Integrity Check
-- ============================================================================
PRINT 'Checking Referential Integrity...';

-- Missing customers
SELECT COUNT(*) AS unmatched_customers
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers d
    ON f.customer_key = d.customer_key
WHERE d.customer_key IS NULL;

-- Missing products
SELECT COUNT(*) AS unmatched_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;


-- ============================================================================
-- 4️⃣ Duplicate Surrogate Key Check
-- ============================================================================
PRINT 'Checking Duplicate Surrogate Keys...';

SELECT customer_key, COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

SELECT product_key, COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- 5️⃣ Business Logic Sanity Check
-- ============================================================================
PRINT 'Checking Sales Aggregation Consistency...';

-- Total Sales in Gold
SELECT SUM(sales_amount) AS total_sales_gold
FROM gold.fact_sales;

-- Compare with Silver Source
SELECT SUM(sls_sales) AS total_sales_silver
FROM silver.crm_sales_details;


-- ============================================================================
-- 6️⃣ Date Distribution Check
-- ============================================================================
PRINT 'Checking Date Distribution...';

SELECT MIN(order_date) AS earliest_order,
       MAX(order_date) AS latest_order,
       COUNT(DISTINCT order_date) AS distinct_dates
FROM gold.fact_sales;


-- ============================================================================
-- 7️⃣ Index Verification
-- ============================================================================
PRINT 'Checking Indexes on fact_sales...';

EXEC sp_helpindex 'gold.fact_sales';


-- ============================================================================
-- 8️⃣ Performance Sample Test
-- ============================================================================
PRINT 'Running Sample Performance Test...';

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT *
FROM gold.fact_sales
WHERE order_date = (
    SELECT TOP 1 order_date
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

PRINT '================ GOLD LAYER VALIDATION COMPLETED ================';
