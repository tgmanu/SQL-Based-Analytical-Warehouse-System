# 📊 SQL-Based Analytical Warehouse System

## 📌 Project Overview

This project implements a structured, multi-layer SQL-based Data Warehouse system using a Bronze → Silver → Gold architecture.

The system is designed to simulate a real-world analytical data warehouse used for business intelligence and reporting.

---

## 🏗 Architecture

### 🔹 Bronze Layer
- Raw source data ingestion
- Minimal transformations
- Serves as staging layer

### 🔹 Silver Layer
- Cleaned and standardized data
- Business rule application
- Stored procedures used for controlled loading

### 🔹 Gold Layer (Star Schema)
- Materialized dimension and fact tables
- Optimized for analytics and BI tools
- Indexed for performance optimization

---

## ⭐ Gold Layer Design

The Gold layer follows a **Star Schema architecture**:

- `dim_customers`
- `dim_products`
- `fact_sales`

### Key Improvements Made:

✔ Converted views into physical tables  
✔ Implemented surrogate keys using IDENTITY  
✔ Added foreign key constraints  
✔ Created non-clustered indexes on:
  - customer_key
  - product_key
  - order_date  
✔ Implemented covering index for analytical queries  
✔ Validated performance using Execution Plans  

---

## ⚡ Performance Optimization

Performance was tested using:

- `SET STATISTICS IO ON`
- `SET STATISTICS TIME ON`
- Execution Plan Analysis

### Observations:
- Initial queries resulted in Table Scans
- After indexing, selective queries used **Index Seek**
- Covering index eliminated key lookups for analytical workloads

---

## 🔄 ETL Design

Each layer includes:

- DDL scripts
- Stored procedures for loading
- Re-runnable architecture

Gold layer is loaded using:

```sql
EXEC gold.proc_load_gold;
