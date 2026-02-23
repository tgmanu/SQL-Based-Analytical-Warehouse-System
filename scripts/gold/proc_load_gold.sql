/*
===============================================================================
Stored Procedure: gold.proc_load_gold
===============================================================================
Script Purpose:
    This procedure loads data into the Gold layer tables from the Silver layer.

    Loading Strategy:
        1. Truncate fact table
        2. Truncate dimension tables
        3. Reload dimensions
        4. Reload fact table using surrogate keys

    This ensures:
        - Repeatable ETL process
        - Clean reload capability
        - Production-style modular architecture

Usage:
    EXEC gold.proc_load_gold;
===============================================================================
*/

-- =============================================================================
-- Create or Alter Procedure
-- =============================================================================
CREATE OR ALTER PROCEDURE gold.proc_load_gold
AS
BEGIN

    SET NOCOUNT ON;

    PRINT 'Starting Gold Layer Load...';

    BEGIN TRY

        -- =============================================================
        -- Step 1: Clear Existing Data (Maintain Load Order)
        -- =============================================================
        PRINT 'Truncating Gold Fact Table...';
        TRUNCATE TABLE gold.fact_sales;

        PRINT 'Truncating Gold Dimension Tables...';
        TRUNCATE TABLE gold.dim_products;
        TRUNCATE TABLE gold.dim_customers;


        -- =============================================================
        -- Step 2: Load Dimension - Customers
        -- =============================================================
        PRINT 'Loading gold.dim_customers...';

        INSERT INTO gold.dim_customers (
            customer_id,
            customer_number,
            first_name,
            last_name,
            country,
            marital_status,
            gender,
            birthdate,
            create_date
        )
        SELECT
            ci.cst_id,
            ci.cst_key,
            ci.cst_firstname,
            ci.cst_lastname,
            la.cntry,
            ci.cst_marital_status,
            CASE 
                WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
                ELSE COALESCE(ca.gen, 'n/a')
            END,
            ca.bdate,
            ci.cst_create_date
        FROM silver.crm_cust_info ci
        LEFT JOIN silver.erp_cust_az12 ca
            ON ci.cst_key = ca.cid
        LEFT JOIN silver.erp_loc_a101 la
            ON ci.cst_key = la.cid;


        -- =============================================================
        -- Step 3: Load Dimension - Products
        -- =============================================================
        PRINT 'Loading gold.dim_products...';

        INSERT INTO gold.dim_products (
            product_id,
            product_number,
            product_name,
            category_id,
            category,
            subcategory,
            maintenance,
            cost,
            product_line,
            start_date
        )
        SELECT
            pn.prd_id,
            pn.prd_key,
            pn.prd_nm,
            pn.cat_id,
            pc.cat,
            pc.subcat,
            pc.maintenance,
            pn.prd_cost,
            pn.prd_line,
            pn.prd_start_dt
        FROM silver.crm_prd_info pn
        LEFT JOIN silver.erp_px_cat_g1v2 pc
            ON pn.cat_id = pc.id
        WHERE pn.prd_end_dt IS NULL;


        -- =============================================================
        -- Step 4: Load Fact Table
        -- =============================================================
        PRINT 'Loading gold.fact_sales...';

        INSERT INTO gold.fact_sales (
            order_number,
            product_key,
            customer_key,
            order_date,
            shipping_date,
            due_date,
            sales_amount,
            quantity,
            price
        )
        SELECT
            sd.sls_ord_num,
            pr.product_key,
            cu.customer_key,
            sd.sls_order_dt,
            sd.sls_ship_dt,
            sd.sls_due_dt,
            sd.sls_sales,
            sd.sls_quantity,
            sd.sls_price
        FROM silver.crm_sales_details sd
        LEFT JOIN gold.dim_products pr
            ON sd.sls_prd_key = pr.product_number
        LEFT JOIN gold.dim_customers cu
            ON sd.sls_cust_id = cu.customer_id;


        PRINT 'Gold Layer Load Completed Successfully.';

    END TRY

    BEGIN CATCH

        PRINT 'Error Occurred During Gold Load.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO

/*
===============================================================================
Script: Execute Gold Layer Load
===============================================================================
Purpose:
    Executes the stored procedure responsible for loading data into the 
    Gold layer of the data warehouse.

What This Does:
    - Truncates existing Gold tables
    - Reloads dimension tables (dim_customers, dim_products)
    - Reloads fact table (fact_sales)
    - Rebuilds star schema relationships
    - Ensures data is refreshed from the Silver layer

When To Use:
    - After Silver layer has been loaded
    - After structural changes in Gold tables
    - During development testing
    - Before connecting Power BI dashboards

Execution:
===============================================================================
*/

EXEC gold.proc_load_gold;
GO

/*
===============================================================================
End of Procedure
===============================================================================
*/
