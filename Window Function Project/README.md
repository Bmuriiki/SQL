# SQL Window Functions – Retail Sales Analysis

## Overview

A project to demonstrate how SQL **Window Functions** can be used to solve real-world business problems using a retail sales dataset in **Google BigQuery**. 
The analysis focuses on employee performance, sales trends, rankings, and cumulative metrics while preserving row-level detail.

## Objectives

- Apply SQL window functions.
- Analyze employee and department sales performance.
- Perform ranking, trend, and cumulative analyses.
- Build clean, production-ready SQL queries.

## Technologies

- SQL (Google BigQuery)
- Google Cloud Platform (BigQuery)

## Concepts Covered

- `OVER()`
- `PARTITION BY`
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `AVG() OVER()`
- `SUM() OVER()`
- Running Totals
- `LAG()`
- `LEAD()`
- `FIRST_VALUE()`
- `LAST_VALUE()`
- Window Frames (`ROWS BETWEEN`)
- Common Table Expressions (CTEs)

## Business Scenarios

This project answers common business questions such as:

- Detect duplicate sales records.
- Compare employees against company and department averages.
- Rank employees by sales performance.
- Identify top performers by department.
- Calculate running sales totals.
- Compare current sales with previous and next transactions.
- Measure performance gaps against the best and lowest performers.
- Build a comprehensive departmental performance report.

## Repository Structure

```
Window Function Project/
│── README.md
│── window_functions.sql
└── retail_sales_dataset.csv
```

## Learning Outcome

Through this project, I gained hands-on experience applying SQL window functions to solve practical business problems, 
improving my ability to write efficient, readable, and production-ready analytical SQL queries.
