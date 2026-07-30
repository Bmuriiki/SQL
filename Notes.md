SQL- STRUCTURED QUERY LANGUAGE

# SQL Command Types

SQL (Structured Query Language) is divided into different categories based on the operations performed on a database. Understanding these categories helps you know which commands to use when creating, querying, modifying, securing, and managing data.

There are **five main types of SQL commands**:

1. Data Definition Language (DDL)
2. Data Manipulation Language (DML)
3. Data Query Language (DQL)
4. Data Control Language (DCL)
5. Transaction Control Language (TCL)

---

# 1. Data Definition Language (DDL)

Data Definition Language (DDL) is used to create and modify the structure of database objects such as tables, schemas, indexes, and views.

Changes made using DDL commands are generally permanent.

## Common DDL Commands

| Command | Description |
|----------|-------------|
| `CREATE` | Creates a new database object |
| `ALTER` | Modifies an existing object |
| `DROP` | Deletes an object permanently |
| `TRUNCATE` | Removes all rows from a table while keeping its structure |
| `RENAME` | Renames a database object |

## Example

### Create a Table

```sql
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);
```

### Add a New Column

```sql
ALTER TABLE employees
ADD email VARCHAR(100);
```

### Delete a Table

```sql
DROP TABLE employees;
```

---

# 2. Data Manipulation Language (DML)

Data Manipulation Language (DML) is used to insert, update, and delete records within database tables.

Unlike DDL, DML changes can often be rolled back before committing the transaction.

## Common DML Commands

| Command | Description |
|----------|-------------|
| `INSERT` | Adds new records |
| `UPDATE` | Modifies existing records |
| `DELETE` | Removes records |
| `MERGE` | Inserts, updates, or deletes data based on matching conditions |

## Examples

### Insert Data

```sql
INSERT INTO employees
(employee_id, employee_name, department, salary)
VALUES
(1, 'Brian', 'IT', 85000);
```

### Update Data

```sql
UPDATE employees
SET salary = 90000
WHERE employee_id = 1;
```

### Delete Data

```sql
DELETE FROM employees
WHERE employee_id = 1;
```

---

# 3. Data Query Language (DQL)

Data Query Language (DQL) is used to retrieve information from a database.

The primary DQL command is `SELECT`.

## Example

```sql
SELECT employee_name,
       department,
       salary
FROM employees
WHERE salary > 70000
ORDER BY salary DESC;
```

---

# 4. Data Control Language (DCL)

Data Control Language (DCL) manages user permissions and database security.

## Common DCL Commands

| Command | Description |
|----------|-------------|
| `GRANT` | Gives permissions to users |
| `REVOKE` | Removes permissions from users |

## Examples

### Grant Permission

```sql
GRANT SELECT
ON employees
TO analyst;
```

### Revoke Permission

```sql
REVOKE SELECT
ON employees
FROM analyst;
```

---

# 5. Transaction Control Language (TCL)

Transaction Control Language (TCL) manages database transactions.

Transactions ensure that a group of SQL statements either complete successfully together or are rolled back if an error occurs.

## Common TCL Commands

| Command | Description |
|----------|-------------|
| `COMMIT` | Saves all changes permanently |
| `ROLLBACK` | Undoes changes since the last commit |
| `SAVEPOINT` | Creates a point to roll back to within a transaction |

## Examples

### Commit a Transaction

```sql
BEGIN;

UPDATE employees
SET salary = salary * 1.10;

COMMIT;
```

### Roll Back a Transaction

```sql
BEGIN;

UPDATE employees
SET salary = salary * 1.10;

ROLLBACK;
```

### Using a Savepoint

```sql
BEGIN;

UPDATE employees
SET salary = 90000
WHERE employee_id = 1;

SAVEPOINT salary_update;

DELETE FROM employees
WHERE employee_id = 2;

ROLLBACK TO salary_update;

COMMIT;
```

---

# SQL Command Categories at a Glance

| Category | Full Name | Purpose | Common Commands |
|----------|-----------|---------|-----------------|
| **DDL** | Data Definition Language | Defines database objects | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| **DML** | Data Manipulation Language | Inserts, updates, and deletes data | `INSERT`, `UPDATE`, `DELETE`, `MERGE` |
| **DQL** | Data Query Language | Retrieves data | `SELECT` |
| **DCL** | Data Control Language | Manages permissions | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control Language | Manages transactions | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

---
# SET SEARCH_PATH in PostgreSQL

## Overview

`SET search_path` is a PostgreSQL command used to specify the schema(s) that PostgreSQL should search when you reference database objects such as tables, views, functions, or sequences without explicitly including the schema name.

Instead of writing the schema name every time, PostgreSQL searches the schemas listed in the `search_path` in the order they are specified.

---

## Syntax

```sql
SET search_path TO schema_name;
```

To specify multiple schemas:

```sql
SET search_path TO schema1, schema2;
```

---

## Why Use `SET search_path`?

Using `SET search_path` makes SQL queries shorter and easier to read by eliminating the need to repeatedly specify the schema name.

### Without `SET search_path`

```sql
SELECT *
FROM staging.jobs;
```

```sql
INSERT INTO staging.jobs (
    job_id,
    job_title
)
VALUES (
    1,
    'Data Analyst'
);
```

---

### With `SET search_path`

```sql
SET search_path TO staging;
```

Now the same queries become:

```sql
SELECT *
FROM jobs;
```

```sql
INSERT INTO jobs (
    job_id,
    job_title
)
VALUES (
    1,
    'Data Analyst'
);
```

---

## Example

Suppose your database contains the following schemas:

- `public`
- `staging`
- `production`

If your `jobs` table exists in the `staging` schema:

```sql
SET search_path TO staging;

SELECT *
FROM jobs;
```

PostgreSQL automatically searches the `staging` schema and executes:

```sql
SELECT *
FROM staging.jobs;
```

---

## Using Multiple Schemas

You can configure PostgreSQL to search multiple schemas in order.

```sql
SET search_path TO staging, public;
```

When you query:

```sql
SELECT * FROM jobs;
```

PostgreSQL first looks for the `jobs` table in the `staging` schema.

If it is not found, PostgreSQL then searches the `public` schema.

---

## Viewing the Current Search Path

To display the current search path:

```sql
SHOW search_path;
```

Example output:

```text
"$user", public
```

This means PostgreSQL first searches for a schema matching the current username. If none exists, it searches the `public` schema.

---

## Session Scope

`SET search_path` only affects the current database session.

Once you disconnect from PostgreSQL, the search path returns to its default value unless it has been permanently configured.

---

## Best Practices

- Use `SET search_path` when working extensively within a single schema.
- Include it at the beginning of SQL scripts for better readability.
- Use schema-qualified table names (`schema.table`) when working with multiple schemas to avoid ambiguity.
- Verify the current search path using `SHOW search_path` if queries return unexpected results.

---

## Summary

| Command | Description |
|---------|-------------|
| `SET search_path TO schema_name;` | Sets the default schema for the current session. |
| `SET search_path TO schema1, schema2;` | Searches multiple schemas in the specified order. |
| `SHOW search_path;` | Displays the current search path. |

---

## Example Script

```sql
-- Set the default schema
SET search_path TO staging;

-- Retrieve all jobs
SELECT *
FROM jobs;

-- Insert a new job
INSERT INTO jobs (
    job_id,
    job_title_short,
    job_location
)
VALUES (
    5001,
    'Data Analyst',
    'Nairobi, Kenya'
);

-- Display the current search path
SHOW search_path;
```




# SQL Command Workflow

```text
Create Database Objects
        │
        ▼
      DDL
        │
        ▼
Insert / Update / Delete Data
        │
        ▼
      DML
        │
        ▼
Retrieve Data
        │
        ▼
      DQL
        │
        ▼
Control User Permissions
        │
        ▼
      DCL
        │
        ▼
Manage Transactions
        │
        ▼
      TCL
```

---

# Best Practices

- Use **DDL** only when changing the database structure.
- Use **DML** to manipulate records without affecting the table structure.
- Use **DQL** to retrieve only the data you need by filtering with `WHERE`.
- Grant users only the permissions they require using **DCL** (Principle of Least Privilege).
- Use **TCL** when performing multiple related operations to maintain data integrity.

---

# Summary

| SQL Category | Purpose |
|---------------|---------|
| **DDL** | Defines and modifies database structures |
| **DML** | Manipulates data within tables |
| **DQL** | Retrieves data from tables |
| **DCL** | Controls user access and permissions |
| **TCL** | Manages transactions and ensures data consistency |



# SQL Comparison Operators

SQL comparison operators are used in the `WHERE` clause to filter records based on specific conditions.

## 1. Equal To (`=`)

Returns rows where the specified column matches the given value exactly.

### Syntax
```sql
SELECT *
FROM table_name
WHERE column_name = value;
```

### Example
```sql
SELECT *
FROM jobs
WHERE job_title_short = 'Data Engineer';
```

---

## 2. Not Equal To (`!=` or `<>`)

Returns rows where the column value does **not** match the specified value.

> **Note:** `<>` is the SQL standard and works across all major databases. `!=` is supported by many databases such as PostgreSQL, MySQL, and SQL Server.

### Syntax
```sql
SELECT *
FROM table_name
WHERE column_name <> value;
```

### Example
```sql
SELECT *
FROM jobs
WHERE job_location <> 'United States';
```

---

## 3. Greater Than / Less Than (`>`, `<`, `>=`, `<=`)

Used to compare numeric values, dates, or other comparable data types.

| Operator | Description |
|----------|-------------|
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |

### Example
```sql
SELECT *
FROM jobs
WHERE salary_year_avg >= 65000;
```

---

## 4. BETWEEN

Returns rows where a value falls within a specified range.

The `BETWEEN` operator is **inclusive**, meaning both the lower and upper limits are included.

### Syntax
```sql
SELECT *
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```

### Example
```sql
SELECT *
FROM jobs
WHERE salary_year_avg BETWEEN 50000 AND 75000;
```

Equivalent to:

```sql
WHERE salary_year_avg >= 50000
  AND salary_year_avg <= 75000;
```

---

## 5. IN

Checks whether a value matches **any** value in a list.

This is a cleaner alternative to using multiple `OR` conditions.

### Syntax
```sql
SELECT *
FROM table_name
WHERE column_name IN (value1, value2, value3);
```

### Example
```sql
SELECT *
FROM jobs
WHERE job_title_short IN ('Data Analyst', 'Business Analyst');
```

Equivalent to:

```sql
WHERE job_title_short = 'Data Analyst'
   OR job_title_short = 'Business Analyst';
```

---

## 6. LIKE

Used for pattern matching with text.

### Wildcards

| Wildcard | Meaning |
|----------|---------|
| `%` | Matches zero or more characters |
| `_` | Matches exactly one character |

### Syntax
```sql
SELECT *
FROM table_name
WHERE column_name LIKE 'pattern';
```

### Examples

Find job titles containing "Engineer":

```sql
SELECT *
FROM jobs
WHERE job_title LIKE '%Engineer%';
```

Starts with "Data":

```sql
WHERE job_title LIKE 'Data%';
```

Ends with "Engineer":

```sql
WHERE job_title LIKE '%Engineer';
```

Contains exactly one character after "Data":

```sql
WHERE job_title LIKE 'Data_';
```

---

## 7. IS NULL / IS NOT NULL

Used to check whether a column contains a `NULL` value.

> **Important:** You cannot use `=` or `!=` to compare `NULL` values.

### Check for NULL values

```sql
SELECT *
FROM jobs
WHERE salary_year_avg IS NULL;
```

### Check for non-NULL values

```sql
SELECT *
FROM jobs
WHERE salary_year_avg IS NOT NULL;
```

---

# Summary

| Operator | Purpose | Example |
|----------|---------|---------|
| `=` | Equal to | `job_title_short = 'Data Engineer'` |
| `!=` / `<>` | Not equal to | `job_location <> 'United States'` |
| `>` | Greater than | `salary_year_avg > 65000` |
| `<` | Less than | `salary_year_avg < 65000` |
| `>=` | Greater than or equal to | `salary_year_avg >= 65000` |
| `<=` | Less than or equal to | `salary_year_avg <= 65000` |
| `BETWEEN` | Within a range (inclusive) | `salary_year_avg BETWEEN 50000 AND 75000` |
| `IN` | Matches any value in a list | `job_title_short IN ('Data Analyst', 'Business Analyst')` |
| `LIKE` | Pattern matching | `job_title LIKE '%Engineer%'` |
| `IS NULL` | Checks for NULL values | `salary_year_avg IS NULL` |
| `IS NOT NULL` | Checks for non-NULL values | `salary_year_avg IS NOT NULL` |

---

# SQL WHERE vs HAVING Clause

The `WHERE` and `HAVING` clauses are both used to filter data in SQL, but they serve different purposes and are used at different stages of query execution.

---

# Key Difference

| WHERE | HAVING |
|--------|---------|
| Filters individual rows **before** grouping takes place. | Filters grouped data **after** grouping has taken place. |
| Cannot be used with aggregate functions like `SUM()`, `COUNT()`, `AVG()`, etc. | Primarily used with aggregate functions. |
| Used with `SELECT`, `UPDATE`, and `DELETE` statements. | Used together with the `GROUP BY` clause. |

---

# SQL Query Execution Order

Understanding the order in which SQL executes a query makes it easier to know when to use `WHERE` or `HAVING`.

1. `FROM`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`
6. `ORDER BY`
7. `LIMIT`

Notice that **WHERE is executed before GROUP BY**, while **HAVING is executed after GROUP BY**.

---

# WHERE Clause

The `WHERE` clause filters rows **before** any grouping or aggregation occurs.

Use `WHERE` when you want to filter individual records.

## Syntax

```sql
SELECT column_name
FROM table_name
WHERE condition;
```

## Example

Return all Data Analyst jobs.

```sql
SELECT job_title_short,
       job_location,
       salary_year_avg
FROM jobs
WHERE job_title_short = 'Data Analyst';
```

Only rows where the job title is **Data Analyst** are returned.

---

## Another Example

Return jobs with salaries greater than $100,000.

```sql
SELECT job_title_short,
       salary_year_avg
FROM jobs
WHERE salary_year_avg > 100000;
```

The filtering happens **before** any grouping or calculations.

---

# HAVING Clause

The `HAVING` clause filters **groups** that were created using `GROUP BY`.

It is most commonly used with aggregate functions such as:

- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`

## Syntax

```sql
SELECT column_name,
       AGGREGATE_FUNCTION(column_name)
FROM table_name
GROUP BY column_name
HAVING condition;
```

---

## Example

Return job titles whose average salary is greater than $100,000.

```sql
SELECT job_title_short,
       AVG(salary_year_avg) AS average_salary
FROM jobs
GROUP BY job_title_short
HAVING AVG(salary_year_avg) > 100000;
```

### What happens?

1. SQL groups all rows by `job_title_short`.
2. It calculates the average salary for each group.
3. `HAVING` removes groups where the average salary is less than or equal to $100,000.

---

# WHERE vs HAVING Example

Suppose you want to know which job titles have an average salary greater than $120,000, but only consider jobs located in the United States.

```sql
SELECT job_title_short,
       AVG(salary_year_avg) AS average_salary
FROM jobs
WHERE job_location = 'United States'
GROUP BY job_title_short
HAVING AVG(salary_year_avg) > 120000;
```

### Explanation

The `WHERE` clause:

```sql
WHERE job_location = 'United States'
```

filters individual rows first.

Then SQL groups the remaining rows by job title.

Finally, the `HAVING` clause:

```sql
HAVING AVG(salary_year_avg) > 120000
```

filters the grouped results.

---

# Visual Flow

```text
Original Table
      │
      ▼
WHERE filters rows
      │
      ▼
GROUP BY creates groups
      │
      ▼
Aggregate Functions
(AVG, COUNT, SUM...)
      │
      ▼
HAVING filters groups
      │
      ▼
Final Result
```

---

# Can HAVING Be Used Without GROUP BY?

Yes.

If no `GROUP BY` clause exists, SQL treats the entire result set as a single group.

Example:

```sql
SELECT COUNT(*)
FROM jobs
HAVING COUNT(*) > 1000;
```

This returns the total count only if there are more than 1,000 records.

Although valid, this usage is less common.

---

# Common Mistakes

## ❌ Using aggregate functions in WHERE

```sql
SELECT job_title_short,
       AVG(salary_year_avg)
FROM jobs
WHERE AVG(salary_year_avg) > 100000
GROUP BY job_title_short;
```

This will produce an error because aggregate functions are not available when the `WHERE` clause is executed.

---

## ✅ Correct

```sql
SELECT job_title_short,
       AVG(salary_year_avg)
FROM jobs
GROUP BY job_title_short
HAVING AVG(salary_year_avg) > 100000;
```

---

# Comparison Summary

| Feature | WHERE | HAVING |
|----------|--------|---------|
| Filters | Individual rows | Groups |
| Executed | Before `GROUP BY` | After `GROUP BY` |
| Uses aggregate functions | ❌ No | ✅ Yes |
| Requires `GROUP BY` | ❌ No | Usually |
| Common use | Filter records | Filter aggregated results |

---

# When Should You Use Each?

Use **WHERE** when you want to:

- Filter rows before calculations.
- Reduce the amount of data processed.
- Filter based on column values.

Example:

```sql
WHERE salary_year_avg > 80000
```

---

Use **HAVING** when you want to:

- Filter grouped results.
- Filter based on aggregate calculations.
- Return only groups meeting a specific condition.

Example:

```sql
HAVING COUNT(*) >= 10
```

or

```sql
HAVING AVG(salary_year_avg) > 120000
```

---

# SQL Joins

## Introduction

SQL joins are used to combine data from two or more tables based on a related column, typically a **Primary Key** and a **Foreign Key**. Joins are essential for retrieving meaningful information from relational databases by linking related records.

For example:

- A **customer** can have many **orders**.
- An **employee** belongs to a **department**.
- A **student** enrolls in multiple **courses**.

Without joins, querying related information across multiple tables would be difficult.

---

# Sample Tables

### Customers

| customer_id | customer_name |
|-------------|---------------|
| 1 | Alice |
| 2 | Bob |
| 3 | Carol |
| 4 | David |

### Orders

| order_id | customer_id | product |
|----------|-------------|----------|
| 101 | 1 | Laptop |
| 102 | 2 | Phone |
| 103 | 2 | Mouse |
| 104 | 5 | Tablet |

Notice that:

- Carol and David have not placed any orders.
- Order **104** belongs to customer **5**, who does not exist in the Customers table.

---

# Types of SQL Joins

| Join | Returns | Best Used When |
|------|----------|----------------|
| **INNER JOIN** | Only matching rows from both tables | You only need records that exist in both tables |
| **LEFT JOIN** | All rows from the left table and matching rows from the right table | The left table is your primary table |
| **RIGHT JOIN** | All rows from the right table and matching rows from the left table | The right table is your primary table |
| **FULL OUTER JOIN** | All rows from both tables, matching where possible | You want every record from both tables |
| **CROSS JOIN** | Every possible combination of rows | You need a Cartesian product |
| **SELF JOIN** | A table joined to itself | The table contains hierarchical or recursive relationships |

---

# 1. INNER JOIN

## Description

An **INNER JOIN** returns only the rows that have matching values in both tables.

### Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```

### Result

| customer_name | product |
|--------------|----------|
| Alice | Laptop |
| Bob | Phone |
| Bob | Mouse |

### When to Use

Use an **INNER JOIN** when you only need records that exist in both tables.

Examples:

- Customers who have placed orders
- Employees assigned to departments
- Students enrolled in courses

---

# 2. LEFT JOIN

## Description

A **LEFT JOIN** returns every row from the left table, along with matching rows from the right table. If no match exists, NULL values are returned for the right table.

### Syntax

```sql
SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Result

| customer_name | product |
|--------------|----------|
| Alice | Laptop |
| Bob | Phone |
| Bob | Mouse |
| Carol | NULL |
| David | NULL |

### When to Use

Use a **LEFT JOIN** when the left table contains all the records you want to keep.

Examples:

- All customers, including those without orders
- All employees, even if they are not assigned to a project
- All products, including those never sold

---

# 3. RIGHT JOIN

## Description

A **RIGHT JOIN** returns every row from the right table and matching rows from the left table. If there is no match, NULL values are returned for the left table.

### Syntax

```sql
SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Result

| customer_name | product |
|--------------|----------|
| Alice | Laptop |
| Bob | Phone |
| Bob | Mouse |
| NULL | Tablet |

### When to Use

Use a **RIGHT JOIN** when every row from the right table should be included.

Examples:

- All orders, even if customer information is missing
- All payments, even if the customer record has been deleted

> **Tip:** Most SQL developers prefer using `LEFT JOIN` by reversing the table order instead of using `RIGHT JOIN`.

---

# 4. FULL OUTER JOIN

## Description

A **FULL OUTER JOIN** returns all rows from both tables. Matching rows are combined, while unmatched rows contain NULL values.

### Syntax

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2
ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
FULL OUTER JOIN orders o
ON c.customer_id = o.customer_id;
```

### Result

| customer_name | product |
|--------------|----------|
| Alice | Laptop |
| Bob | Phone |
| Bob | Mouse |
| Carol | NULL |
| David | NULL |
| NULL | Tablet |

### When to Use

Use a **FULL OUTER JOIN** when you want every record from both tables.

Examples:

- Data reconciliation
- Identifying unmatched records
- Comparing datasets after migration

---

# 5. CROSS JOIN

## Description

A **CROSS JOIN** returns the Cartesian product of two tables. Every row from the first table is paired with every row from the second table.

### Syntax

```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

### Example

```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
CROSS JOIN orders o;
```

### Result

| customer_name | product |
|--------------|----------|
| Alice | Laptop |
| Alice | Phone |
| Alice | Mouse |
| Alice | Tablet |
| Bob | Laptop |
| Bob | Phone |
| ... | ... |

With **4 customers** and **4 orders**, the query returns **16 rows**.

### When to Use

Use a **CROSS JOIN** when you need every possible combination of records.

Examples:

- Product and color combinations
- Product and size combinations
- Scheduling
- Test data generation

---

# 6. SELF JOIN

## Description

A **SELF JOIN** joins a table to itself using table aliases.

### Employees Table

| employee_id | employee_name | manager_id |
|-------------|---------------|------------|
| 1 | John | NULL |
| 2 | Mary | 1 |
| 3 | Peter | 1 |
| 4 | James | 2 |

### Example

```sql
SELECT
    e.employee_name AS employee,
    m.employee_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
```

### Result

| employee | manager |
|----------|----------|
| John | NULL |
| Mary | John |
| Peter | John |
| James | Mary |

### When to Use

Use a **SELF JOIN** whenever rows within the same table are related.

Examples:

- Employees and managers
- Categories and parent categories
- Organizational structures
- Comment threads

---

# SQL Join Summary

| Join Type | Returns | Common Use Case |
|-----------|----------|----------------|
| **INNER JOIN** | Matching rows only | Customers with orders |
| **LEFT JOIN** | All rows from the left table | Customers with or without orders |
| **RIGHT JOIN** | All rows from the right table | Orders with or without customers |
| **FULL OUTER JOIN** | All rows from both tables | Finding unmatched records |
| **CROSS JOIN** | Every possible combination | Product variations |
| **SELF JOIN** | A table joined to itself | Employee-manager relationships |

---

# Join Comparison Diagram

```text
              SQL JOINS

          Table A      Table B

INNER JOIN
        A ∩ B

LEFT JOIN
    A + (A ∩ B)

RIGHT JOIN
    (A ∩ B) + B

FULL OUTER JOIN
       A ∪ B

CROSS JOIN
Every row in A × Every row in B

SELF JOIN
Table A joined with itself
```

---

# Key Takeaways

- Use **INNER JOIN** to retrieve only matching records.
- Use **LEFT JOIN** to keep all rows from the left table.
- Use **RIGHT JOIN** to keep all rows from the right table.
- Use **FULL OUTER JOIN** to retrieve every row from both tables.
- Use **CROSS JOIN** to generate all possible combinations.
- Use **SELF JOIN** to query hierarchical relationships within the same table.

# Common Table Expressions (CTEs) in SQL

## Introduction

A **Common Table Expression (CTE)** is a temporary named result set defined using the `WITH` clause. It exists only for the execution of a single SQL statement and is used to simplify complex queries by breaking them into smaller, more manageable parts.

Unlike permanent tables or views, a CTE is not stored in the database. It is created at the start of a query and automatically discarded once the query finishes executing.

---

# Syntax

```sql
WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT *
FROM cte_name;
```

---

# Example

The following example retrieves employees whose salary is greater than KES 100,000.

```sql
WITH HighSalaryEmployees AS (
    SELECT employee_id,
           employee_name,
           salary
    FROM employees
    WHERE salary > 100000
)

SELECT *
FROM HighSalaryEmployees;
```

---

# Why Use a CTE?

Although a CTE often produces the same result as a subquery, it provides several advantages when writing SQL.

## 1. Improves Readability

Complex SQL statements can become difficult to understand when multiple nested subqueries are used. A CTE separates the logic into meaningful steps, making the query easier to read and maintain.

**Without a CTE**

```sql
SELECT department,
       AVG(salary) AS average_salary
FROM (
    SELECT department,
           salary
    FROM employees
    WHERE salary > 50000
) AS employee_data
GROUP BY department;
```

**With a CTE**

```sql
WITH employee_data AS (
    SELECT department,
           salary
    FROM employees
    WHERE salary > 50000
)

SELECT department,
       AVG(salary) AS average_salary
FROM employee_data
GROUP BY department;
```

---

## 2. Eliminates Repeated Logic

If the same dataset is required multiple times within a query, a CTE allows the filtering or transformation logic to be written once and referenced repeatedly.

```sql
WITH high_salary AS (
    SELECT *
    FROM employees
    WHERE salary > 50000
)

SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM high_salary;
```

This reduces duplication and makes future modifications easier.

---

## 3. Simplifies Complex Queries

Multiple CTEs can be chained together to create step-by-step transformations.

```sql
WITH monthly_sales AS (

    SELECT
        month,
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY month

),

ranked_sales AS (

    SELECT
        month,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM monthly_sales

)

SELECT *
FROM ranked_sales
WHERE sales_rank <= 3;
```

Breaking the query into stages makes it much easier to understand and debug.

---

## 4. Supports Recursive Queries

Recursive CTEs are designed to work with hierarchical data such as:

* Employee-manager relationships
* Organizational structures
* Folder hierarchies
* Product categories
* Family trees

Example:

```sql
WITH RECURSIVE numbers AS (

    SELECT 1 AS number

    UNION ALL

    SELECT number + 1
    FROM numbers
    WHERE number < 5

)

SELECT *
FROM numbers;
```

**Result**

| number |
| -----: |
|      1 |
|      2 |
|      3 |
|      4 |
|      5 |

---

# CTE vs. Subquery

| Feature                   | CTE  | Subquery        |
| ------------------------- | ---- | --------------- |
| Readability               | High | Moderate to Low |
| Reusable within the query | Yes  | No              |
| Supports recursion        | Yes  | No              |
| Ideal for complex queries | Yes  | Limited         |
| Temporary                 | Yes  | Yes             |

---

# Performance Considerations

A common misconception is that CTEs automatically improve query performance. In reality, they are primarily a readability and maintainability feature.

Modern database systems such as PostgreSQL, SQL Server, MySQL 8+, and Oracle often optimize CTEs similarly to subqueries. Therefore, choosing between a CTE and a subquery should generally be based on code clarity rather than performance.

For performance tuning, always analyze the query execution plan rather than assuming a CTE will execute faster.

---

# Best Practices

* Use descriptive CTE names that clearly indicate their purpose.
* Keep each CTE focused on a single transformation.
* Chain multiple CTEs to simplify complex business logic.
* Avoid unnecessary CTEs for simple queries.
* Use recursive CTEs only when working with hierarchical or recursive data.

---

# When to Use a CTE

Use a CTE when:

* Simplifying complex SQL queries.
* Reusing the same intermediate result multiple times.
* Organizing queries into logical steps.
* Working with window functions.
* Writing recursive queries.

Avoid using a CTE when a simple `SELECT` statement is sufficient and readability is not improved.

---

# Key Takeaways

* A **Common Table Expression (CTE)** is a temporary named result set created using the `WITH` clause.
* CTEs improve the readability, organization, and maintainability of SQL queries.
* They eliminate repeated query logic by allowing intermediate results to be referenced multiple times.
* Multiple CTEs can be chained together to build complex data transformations in a clear and structured manner.
* Recursive CTEs are the preferred solution for querying hierarchical data.
* CTEs are designed to make SQL easier to write and maintain, not necessarily faster to execute.

> **Interview Tip:** A Common Table Expression (CTE) is a temporary named result set defined with the `WITH` clause that simplifies complex SQL queries by breaking them into logical, reusable steps within a single SQL statement.


# CREATE TABLE AS (CTAS) in SQL

## Introduction

**CREATE TABLE AS (CTAS)** is a SQL statement used to create a new table from the results of a `SELECT` query. The new table is created automatically using the columns returned by the query and is immediately populated with the selected data.

CTAS is widely used in data engineering, data warehousing, and ETL/ELT pipelines to create staging tables, reporting tables, backup tables, and transformed datasets.

Unlike a **Common Table Expression (CTE)**, which is temporary and exists only during query execution, a CTAS table is permanently stored in the database until it is explicitly dropped.

---

# Syntax

```sql
CREATE TABLE new_table AS
SELECT column1, column2, ...
FROM existing_table
WHERE condition;
```

---

# Example

The following query creates a new table containing only Data Engineer job postings located in Kenya.

```sql
CREATE TABLE data_role.data_engineering_jobs_kenya AS
SELECT *
FROM data_role.jobs
WHERE job_title_short = 'Data Engineer'
  AND job_country = 'Kenya';
```

---
# Result

After the query executes successfully, a new permanent table named **`data_role.data_engineering_jobs_kenya`** is created.

The table contains:

* The same columns as the original `jobs` table.
* Only rows where:

  * `job_title_short = 'Data Engineer'`
  * `job_country = 'Kenya'`

You can query the new table like any other table.

```sql
SELECT *
FROM data_role.data_engineering_jobs_kenya;
```

---

# Advantages of CTAS

## 1. Creates and Populates a Table in One Step

CTAS combines table creation and data insertion into a single SQL statement.

---

## 2. Simplifies Data Transformation

Filtered or transformed datasets can be saved as new tables for future analysis.

---

## 3. Improves ETL/ELT Workflows

CTAS is commonly used to create:

* Staging tables
* Intermediate transformation tables
* Reporting tables
* Data marts
* Backup tables

---

## 4. Reduces Repetitive Queries

Instead of repeatedly filtering the same dataset, the filtered results can be stored once and queried whenever needed.

---

# CTAS vs. CTE

| Feature                      | CTAS  | CTE   |
| ---------------------------- | ----- | ----- |
| Creates a new table          | ✅ Yes | ❌ No  |
| Stores data permanently      | ✅ Yes | ❌ No  |
| Uses `CREATE TABLE AS`       | ✅ Yes | ❌ No  |
| Uses `WITH` clause           | ❌ No  | ✅ Yes |
| Exists after query execution | ✅ Yes | ❌ No  |
| Best for data storage        | ✅ Yes | ❌ No  |
| Best for simplifying queries | ❌ No  | ✅ Yes |

---

# Best Practices

* Use meaningful table names that describe the data.
* Select only the required columns instead of using `SELECT *` when possible.
* Apply filters to reduce unnecessary data.
* Add indexes after creating the table if the data will be queried frequently.
* Verify that the destination table does not already exist before executing the statement.

---

# When to Use CTAS

Use CTAS when:

* Creating staging tables for ETL/ELT pipelines.
* Building reporting tables.
* Creating data marts.
* Saving the results of complex queries.
* Creating backup or snapshot tables.
* Materializing transformed datasets for repeated analysis.

Avoid CTAS when:

* You only need a temporary result within a single query. In that case, use a **CTE**.
* You need to define constraints (such as `PRIMARY KEY`, `FOREIGN KEY`, or `CHECK`) during table creation, since many databases do not automatically copy them.

---

# Key Takeaways

* **CTAS (CREATE TABLE AS SELECT)** creates a new table and populates it with data from a `SELECT` query in a single statement.
* The created table is permanently stored in the database until it is dropped.
* CTAS is widely used in data engineering for staging tables, reporting tables, and transformed datasets.
* It simplifies ETL/ELT workflows by materializing query results for reuse.
* Unlike a CTE, which is temporary, a CTAS table persists after the query has finished executing.

> **Interview Tip:** **CREATE TABLE AS (CTAS)** is a SQL statement that creates a new table using the results of a `SELECT` query. It is commonly used in data engineering to materialize filtered or transformed datasets for future analysis and reporting.













































