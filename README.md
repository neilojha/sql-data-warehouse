 
# 🏗️ SQL Data Warehouse Project

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Project Type](https://img.shields.io/badge/Project-Data%20Engineering-green)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-orange)

---

## 📌 Overview

This project demonstrates the design and implementation of a **SQL-based Data Warehouse** using real-world concepts.

It integrates data from multiple sources (**CRM & ERP systems**) and transforms it into structured layers for analytics.

---

## 🏗️ Architecture (Medallion Model)

```
        ┌──────────────┐
        │  Source Data │
        │ CRM / ERP    │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │   Bronze     │  → Raw data ingestion
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │   Silver     │  → Data cleaning & transformation
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │    Gold      │  → Business-ready data
        └──────────────┘
```

---

## 📂 Project Structure

```
project_7/
│
├── source_crm/
│   ├── cust_info.csv
│   ├── prd_info.csv
│   └── sales_details.csv
│
├── source_erp/
│   ├── CUST_AZ12.csv
│   ├── LOC_A101.csv
│   └── PX_CAT_G1V2.csv
│
├── sql/
│   ├── bronze.sql
│   ├── silver.sql
│   └── gold.sql
│
└── README.md
```

---

## 🔄 Data Pipeline

### 🔹 Bronze Layer

* Raw data loaded from CRM and ERP CSV files
* No transformations applied

### 🔹 Silver Layer

* Data cleaning (null handling, formatting)
* Standardization of fields
* Joins across datasets

### 🔹 Gold Layer

* Business-level aggregations
* KPIs and analytics-ready tables

---

## 🛠️ Tech Stack

* **MySQL**
* **SQL**
* **CSV Data Sources**
* **Git & GitHub**

---

## 🚀 Key Highlights

* Built an **end-to-end data pipeline**
* Applied **Medallion Architecture (Bronze → Silver → Gold)**
* Performed **data cleaning, transformation, and aggregation**
* Structured project like a **real-world data warehouse**

---

## 📊 Future Improvements

* Add Power BI / Tableau dashboard
* Automate pipeline using Python
* Deploy on cloud (AWS / Azure)

---

## 👨‍💻 Author

**Neil Ojha**
