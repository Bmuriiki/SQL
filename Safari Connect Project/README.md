# 🚌 Safari Connect — Bus & Matatu Booking Analytics

## 📌 Project Overview

**Safari Connect** is a Nairobi-based bus and matatu booking platform that allows passengers to book seats online, select travel routes, and pay using M-Pesa or card.

The company has been operating since 2024 and has accumulated hundreds of booking records. However, the booking data was stored in a shared Excel file and contained numerous data quality issues.

This project simulates a real-world data analyst engagement where the objective is to transform the company's raw booking data into reliable, actionable business insights.

The complete workflow covers:

**Raw CSV → Data Cleaning → PostgreSQL → SQL Analysis → Power BI Dashboard**

The project focuses on answering key business questions around revenue, routes, drivers, passengers, cancellations, and operational performance.

---

## 🎯 Business Problem

Safari Connect's Operations Director needs better visibility into the company's performance.

The key questions the business wants answered are:

1. **Which routes are the most profitable and popular?**
2. **Which drivers are performing best?**
3. **How is revenue changing month by month?**
4. **Where do passengers come from and what are their preferences?**
5. **How much revenue is being lost through cancellations?**
6. **When are the busiest travel days and times?**

The analysis is intended to support operational decision-making and provide management with clear, data-driven recommendations.

---

## 🛠️ Tools & Technologies

| Tool                 | Purpose                                           |
| -------------------- | ------------------------------------------------- |
| **Python / CSV**     | Initial data inspection and source data           |
| **PostgreSQL**       | Data storage, cleaning and transformation         |
| **SQL**              | Data cleaning, analysis and business intelligence |
| **Power BI**         | Data visualization and dashboard development      |
| **GitHub**           | Project documentation and version control         |

---

## 📂 Project Structure

```text
safari-connect-analytics/
│
├── README.md
│
├── data_cleaning/
│   └── data_cleaning.sql
│
├── analysis/
│   └── analysis.sql
│
├── power_bi/
│   └── Safari_Connect_Dashboard.pbix
│
└── data/
    └── safari_connect_dirty.csv
```

> The exact filenames and folder structure can be adjusted depending on how the final project is organized.

---

# 🧹 1. Data Cleaning

The source dataset, `safari_connect_dirty.csv`, contains approximately **290 booking records** and intentionally includes real-world data quality problems.

The cleaning process was performed using PostgreSQL.

### Data Quality Issues

The dataset contains issues including:

* Uppercase and lowercase passenger names
* Leading and trailing whitespace
* Phone numbers containing dashes
* Kenyan phone numbers using the `+254` format
* Missing phone numbers
* Multiple date formats
* Inconsistent city capitalization
* Missing passenger cities
* Inconsistent gender values
* Inconsistent payment methods
* Inconsistent booking statuses
* Currency values stored as text
* Seat class inconsistencies and abbreviations
* Inconsistent driver names
* Invalid trip ratings
* Negative seat quantities
* Duplicate booking IDs

These issues were identified and corrected using SQL transformations.

### Cleaning Techniques

Examples of techniques used include:

```sql
INITCAP(TRIM(passenger_name))
```

for standardizing names,

```sql
REGEXP_REPLACE(passenger_phone, '[^0-9]', '', 'g')
```

for cleaning phone numbers,

```sql
TO_DATE(date_column, 'DD/MM/YYYY')
```

for converting text dates,

and:

```sql
REGEXP_REPLACE(total_fare, '[^0-9.]', '', 'g')::NUMERIC
```

for converting currency values stored as text into numeric values.

Invalid ratings were converted to `NULL`, negative seat bookings were removed, and duplicate booking records were identified and removed.


# 📊 2. Business Analysis

After cleaning the data, SQL was used to answer six core business questions.

## 2.1 Route Analysis

### Business Question

> Which routes earn the most, which are most popular, and which are most efficient per seat sold?

The analysis evaluates:

* Total revenue by route
* Number of bookings
* Seats sold
* Revenue per seat
* Route performance
* Top-performing routes
* Underperforming routes

The objective is to identify the most profitable route and highlight routes requiring operational attention.

---

## 2.2 Driver Performance

### Business Question

> Who are the best-performing drivers, and does driver rating affect passenger satisfaction?

The analysis evaluates:

* Driver revenue
* Number of trips/bookings
* Driver rating
* Passenger trip ratings
* Driver performance comparisons

The results are used to identify high-performing drivers and support data-driven promotion recommendations.

---

## 2.3 Revenue Trends

### Business Question

> How is revenue changing month by month?

The analysis examines:

* Monthly revenue
* Month-over-month revenue changes
* Percentage growth
* Best-performing months
* Worst-performing months
* Overall revenue direction

Window functions are used to calculate month-over-month changes and identify revenue trends.

---

## 2.4 Passenger Insights

### Business Question

> Where do passengers come from, what seat classes do they prefer, and how satisfied are they?

The analysis examines:

* Passenger cities
* Gender distribution
* Seat class preferences
* Passenger satisfaction
* Trip ratings
* Passenger demographics

This helps Safari Connect understand its customer base and identify passenger preferences.

---

## 2.5 Cancellation Analysis

### Business Question

> What is the cancellation rate per route, and how much revenue is being lost?

The analysis evaluates:

* Cancellation rate
* Cancellations by route
* Lost revenue
* Routes with the highest cancellation rates
* Financial impact of cancellations

The findings are used to recommend potential cancellation-management policies.

---

## 2.6 Operational Patterns

### Business Question

> What are the busiest travel days and times?

The analysis identifies:

* Busiest days
* Busiest departure times
* Booking volumes
* Revenue by travel period
* Peak operational periods

These insights can help management determine when additional vehicles should be deployed.

---

# 📈 3. Power BI Visualization

The cleaned analytical data is connected to **Power BI** to create an interactive business dashboard.

Power BI connects to the PostgreSQL database and uses the cleaned analytical views rather than the raw or staging tables.

### Dashboard Objectives

The dashboard is designed to provide management with a single view of:

* Revenue performance
* Route performance
* Driver performance
* Passenger demographics
* Cancellation performance
* Travel patterns

The project brief requires at least **five visuals** in the dashboard.

### Recommended Dashboard Sections

#### Executive Overview

Key Performance Indicators:

* Total Revenue
* Total Bookings
* Completed Bookings
* Cancellation Rate
* Total Seats Sold
* Average Driver Rating

#### Revenue Analysis

Visuals can include:

* Monthly revenue trend
* Revenue by route
* Revenue by seat class
* Month-over-month growth

#### Route Performance

Visuals can include:

* Revenue by route
* Bookings by route
* Seats sold by route
* Cancellation rate by route

#### Driver Performance

Visuals can include:

* Revenue by driver
* Driver rating
* Passenger satisfaction
* Driver performance ranking

#### Passenger Insights

Visuals can include:

* Passenger distribution by city
* Gender distribution
* Seat class preference
* Trip satisfaction

#### Operations

Visuals can include:

* Bookings by day
* Bookings by departure time
* Revenue by departure period
* Peak travel periods

---

# 🗄️ Data Architecture

The project follows a simple analytical data flow:

```text
                    ┌─────────────────────┐
                    │  Dirty CSV Dataset  │
                    │ safari_connect_     │
                    │ dirty.csv           │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   PostgreSQL        │
                    │                     │
                    │ Data Cleaning       │
                    │ Transformation      │
                    │ Validation          │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ Analytical Views    │
                    │                     │
                    │ v_... views         │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │     Power BI        │
                    │                     │
                    │ Dashboard &         │
                    │ Visualization       │
                    └─────────────────────┘
```

Power BI is intentionally connected to the cleaned views rather than directly to the raw/staging tables.



# 💡 Business Recommendations

The final recommendations should be based on the actual analytical results rather than assumptions.

Potential areas for recommendations include:

### Route Optimization

Prioritize high-revenue and high-demand routes while investigating underperforming routes.

### Driver Management

Recognize and reward high-performing drivers based on revenue, ratings and passenger satisfaction.

### Cancellation Management

Investigate routes with unusually high cancellation rates and introduce appropriate cancellation policies.

### Fleet Planning

Deploy additional vehicles during identified peak travel periods.

### Customer Experience

Use passenger city, seat class and satisfaction data to improve service offerings.

---

# 📌 Project Deliverables

The completed project consists of:

### 1. Data Cleaning

A PostgreSQL SQL script documenting the identification and correction of all data quality issues.

### 2. Analysis

SQL queries answering all six business questions, including documented results and business insights.

### 3. Power BI Visualization

An interactive Power BI dashboard presenting the project's key findings.

### 4. Documentation

A GitHub repository documenting the complete analytical workflow, methodology and findings.

---

