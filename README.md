# retail-E-Commerce
An end-to-end e-commerce sales, seasonality, and operations dashboard built with SQL and Power BI.
# 📊 E-Commerce Sales & Operations Analytics Dashboard

An end-to-end data analytics portfolio project showcasing data cleaning, relational modeling, advanced DAX, and interactive business intelligence reporting.

---

## 🚀 Project Overview
This project simulates an international e-commerce operation, analyzing millions in revenue, customer purchasing behaviors, seasonal trends, and inventory/shipping risks. The goal was to transform raw transactional data into a professional 3-page executive Power BI dashboard.

## 🛠️ Tech Stack & Skills Demonstrated
* **Database & Data Cleaning:** SQL (Joins, aggregations, data integrity checks).
* **Data Modeling:** Star Schema architecture, establishing clean `1-to-N` dimension relationships.
* **Data Visualization & DAX:** Power BI Desktop, custom measures, time-intelligence functions, and dynamic slicers.

---

## 📑 Dashboard Pages & Structure

### 1. Executive Overview
* **KPI Cards:** Total Revenue, Total Orders, and Average Order Value (AOV).
* **Visuals:** Revenue growth over time, Top 10 Customers by Spend, and regional market breakdowns.

### 2. Time-Series & Seasonality
* **Visuals:** Monthly revenue trends filtered by seasonal slicers (Spring, Summer, Fall, Winter).
* **Advanced Measure:** Implemented a **3-Month Rolling Average** to smooth out seasonal volatility and reveal true baseline growth.

### 3. Operations & Inventory Health
* **Visuals:** Order fulfillment status tracking (Shipped, Pending, Delivered, Processing).
* **Inventory Alerts:** Stock level monitoring (`UnitsInStock <= ReorderLevel`) to prevent stockouts.

---

## 📂 Repository Structure
- `dashboard.pbix` - The complete Power BI report file.
- `data/` - Raw CSV files (`orders2.csv`, `customers2.csv`, `product.csv`, `calendar2.csv`).
- `queries.sql` - SQL scripts used for initial data exploration and extraction.
