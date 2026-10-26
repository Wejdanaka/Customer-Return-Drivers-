# Customer Return Drivers: Why do customers return products, and what should we fix first? (SQL)

This project aims to build a return analysis for a retail business using SQL queries to answer the core business question: Why do customers return products?

---

## Project Overview

### Business Context & Problem
A retail business operates across three regional markets (Central, North, and South) and tracks detailed data on every customer transaction, product category sale, and return case.

### Analytical Approach
This project combines a two-layer analytical structure:
* **SQL:** Executes queries to establish the return baseline and analyze what, when, where, and why customers return products.

### Data Source
* **Dataset:** Provided as part of the Masna3 Tech SQL Analytics Training Program
* **Database Scope:** Comprises 8 relational tables with 5,440+ transaction records across 3 regional markets (Central, North, South).
* **Primary Entity Counts:**
  * Orders: 2,437 records | Order Details: 5,440 items
  * Returns: 249 cases | Customers: 250 profiles
  * Products: 43 items across 8 distinct categories
  * Employees: 12 staff members | Payments: 2,661 transactions

---

### SQL Analysis
* **Tool:** SQL Server Management Studio (SSMS)
* **File:** [Final 2_SQLQuery1.sql](./Final%202_SQLQuery1.sql)

---

### Analysis Steps
I examined the raw data in SQL Server to explore return patterns through the following steps:

1. **Multi-Table Integration:** Used `INNER JOIN` and `LEFT JOIN` queries to merge return records with order details, product catalogs, and customer geographic data.
2. **Exploratory Data Analysis (EDA):** Applied `SELECT`, `COUNT`, `SUM`, `GROUP BY`, `ORDER BY`, and CTEs/subqueries to measure return volumes (records vs. physical units) and total losses.

---

## Key Business Insights and Recommendations

<img width="1196" height="669" alt="image" src="https://github.com/user-attachments/assets/af60dcaf-ee07-4a04-b0eb-15f134cd0160" />

