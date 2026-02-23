# SQL BASED ANALYTICAL WAREHOUSE SYSTEM

An end-to-end SQL Data Warehouse project that transforms raw business data into structured analytical data for decision-making.

This project demonstrates real-world data engineering concepts such as ETL processing, layered architecture, dimensional modeling, and analytical querying using SQL.

---

## 🎯 Project Goal

The primary goal of this project was to design and implement a structured, production-style SQL Data Warehouse system that simulates real-world analytical environments.

Specifically, this project aimed to:

- Understand and implement a multi-layer Bronze → Silver → Gold architecture  
- Design a Star Schema suitable for analytical workloads  
- Build modular and re-runnable ETL stored procedures  
- Convert logical views into materialized tables for performance optimization  
- Implement indexing strategies to improve query efficiency  
- Analyze execution plans to validate performance improvements  
- Prepare the warehouse for downstream Business Intelligence tools such as Power BI  

---

## 🏗️ Architecture

The warehouse follows a **multi-layer architecture**:

### 1️⃣ Raw Layer (Bronze)
- Stores source data without modification
- Acts as historical backup
- Used for traceability

### 2️⃣ Processed Layer (Silver)
- Data cleaning and transformation
- Handles null values, duplicates, formatting
- Standardizes columns and data types

### 3️⃣ Analytics Layer (Gold)
- Optimized for reporting
- Fact and Dimension tables created
- Ready for business intelligence queries

---

## 🧰 Technologies Used
- SQL (MySQL / SQL Server / PostgreSQL)
- Data Modeling
- ETL Techniques
- Relational Database Concepts

---

## 📊 Example Insights
- Top selling products
- Monthly revenue trends
- Customer purchasing patterns
- Category performance analysis
- Sales contribution by region

---
### Design Improvements Implemented

Unlike the reference implementation which used views, this version includes:

- Conversion of views into physical tables
- Surrogate keys implemented using `IDENTITY`
- Foreign key constraints for referential integrity
- Non-clustered indexes on:
  - `customer_key`
  - `product_key`
  - `order_date`
- Covering index on `order_date` to optimize analytical queries
- Execution plan validation (Index Seek vs Table Scan analysis)
- Dedicated validation script for post-load testing  

---

## ⚡ Performance Engineering

Query performance was analyzed using:
- SET STATISTICS IO ON;
- SET STATISTICS TIME ON;

---
### 🧩 Skills Gained & Demonstrated

Through the design and enhancement of this SQL-Based Analytical Warehouse System, I gained hands-on experience in the following areas:

### 🏗 Data Warehouse Architecture
- Designed and implemented a multi-layer Bronze → Silver → Gold architecture
- Understood the purpose of staging, transformation, and presentation layers
- Applied real-world warehouse structuring principles

### ⭐ Star Schema Modeling
- Designed dimension and fact tables
- Implemented surrogate keys using IDENTITY
- Established foreign key relationships
- Understood fact-to-dimension join strategies

### 🔄 ETL Development
- Built modular stored procedures for controlled data loading
- Implemented re-runnable ETL processes using TRUNCATE + INSERT strategy
- Maintained proper loading order (Dimensions before Facts)
- Structured scripts for maintainability and automation readiness

### ⚡ SQL Performance Optimization
- Created non-clustered indexes on foreign keys and filter columns
- Designed and implemented a covering index
- Compared Table Scan vs Index Seek behavior
- Used Execution Plans for performance validation
- Applied `SET STATISTICS IO` and `SET STATISTICS TIME` for benchmarking

### 🔍 Query Analysis & Debugging
- Diagnosed datatype mismatches during table materialization
- Validated data integrity after transformations
- Performed referential integrity checks
- Implemented post-load validation scripts

### 📊 Data Validation & Quality Assurance
- Verified row counts between layers
- Checked for NULL foreign keys
- Validated aggregation consistency between Silver and Gold
- Ensured uniqueness of surrogate keys

### 🧠 Analytical Thinking
- Understood how warehouse design impacts BI performance
- Optimized schema for analytical workloads
- Prepared dataset structure for Power BI integration
- Considered scalability (indexing strategy, future enhancements)

---
## 🚀 Future Enhancements
- Incremental load implementation
- ETL logging & auditing framework
- Columnstore indexing
- Partitioning strategy for large fact tables

---
Power BI integration for dashboarding
## 🎯 Purpose of the Project
This project was built as a hands-on learning exercise to understand practical data engineering workflows and strengthen SQL skills required for data analytics and data engineering roles.

---

## 📌 Note
Inspired by learning resources from the **DataWithBaraa** YouTube channel.  
The implementation, structure, and documentation were written independently for educational purposes.

---

## 👨‍💻 Author
Manu TG  
Aspiring Data Analyst | Learning SQL, Python & Data Analytics
