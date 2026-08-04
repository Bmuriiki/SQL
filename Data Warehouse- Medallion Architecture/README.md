# Data Warehouse Development with Medallion Architecture

## Overview

This project demonstrates the design and implementation of a modern SQL data warehouse using 
the **Medallion Architecture (Bronze, Silver, and Gold layers)**. Raw data is ingested into the Bronze layer, transformed and 
standardized in the Silver layer, and modeled into business-ready dimensional tables and fact tables in the Gold layer 
to support analytics and reporting.

## Objectives

- Build a scalable SQL data warehouse.
- Implement the Medallion Architecture.
- Clean and standardize raw data.
- Design analytical data models using star schema principles.
- Create business-ready views for reporting and BI.

## Technologies

- SQL
- Relational Database
- Medallion Architecture
- Star Schema

## Concepts Covered

- Data Warehouse Design
- Bronze, Silver & Gold Layers
- ETL/ELT Pipelines
- Data Cleaning & Standardization
- Data Modeling
- Dimension & Fact Tables
- Surrogate Keys
- Views
- Joins
- Common Table Expressions (CTEs)

## Business Scenarios

This project demonstrates how to:

- Ingest raw data into the Bronze layer.
- Clean and validate data in the Silver layer.
- Build dimension tables for customers and products.
- Create fact tables for sales transactions.
- Develop analytics-ready datasets for business intelligence and reporting.

## Repository Structure

```text
data-warehouse-medallion/
│── README.md
├── 01_bronze_layer.sql
├── 02_silver_layer.sql
├── 03_gold_layer.sql

```

## 🚀 Learning Outcome

Hands-on experience designing and implementing a layered data warehouse using the Medallion Architecture. 
The project strengthened my understanding of data ingestion, transformation, dimensional modeling, and the development 
of analytics-ready datasets for reporting and decision-making.
