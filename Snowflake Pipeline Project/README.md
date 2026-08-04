# Snowflake Medallion Architecture – Hotel Booking Data Pipeline

## 📌 Overview

This project demonstrates how to build an end-to-end **ETL pipeline in Snowflake** using the 
**Medallion Architecture (Bronze, Silver, and Gold layers)**. The pipeline ingests raw hotel booking data, performs data cleaning 
and validation, and creates analytical views for reporting and business intelligence.

## Objectives

- Build a Medallion Architecture data pipeline in Snowflake.
- Ingest CSV data into the Bronze layer.
- Clean, validate, and standardize data in the Silver layer.
- Create Gold views for business reporting and analytics.
- Generate insights on bookings, revenue, cancellations, and room performance.

## Technologies

- Snowflake
- SQL
- Medallion Architecture (Bronze, Silver, Gold)

## Concepts Covered

- Database, Stage & File Format Creation
- Data Loading (`COPY INTO`)
- Data Cleaning & Transformation
- Duplicate Detection (`ROW_NUMBER()` & `QUALIFY`)
- Data Validation (`TRY_TO_DATE`, `TRY_TO_NUMBER`)
- Common Table Expressions (CTEs)
- Views
- Aggregations (`COUNT`, `SUM`)
- Business Reporting

## Business Scenarios

This project answers key business questions such as:

- How many bookings are made each month?
- What is the monthly revenue by currency?
- Which months experience the most cancellations?
- What are the most booked room types?
- How do booking statuses vary across room types?
- How can raw booking data be transformed into analytics-ready datasets?

## Repository Structure

```text
snowflake-hotel-booking-pipeline/
│── README.md
└── hotel_booking_pipeline.sql
```

## Learning Outcome

Building a modern data pipeline in Snowflake, implementing the Medallion Architecture, performing data cleaning and transformation, and 
creating analytics-ready datasets to support business reporting and decision-making.
