SQL- STRUCTURED QUERY LANGUAGE

Category
1. Data Query Language(DQL)
2. Data Manipulation Language(DML)
3. Data Definition Language(DDL)

Types of Databases
1. Relational
2. Non-relational

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

# Best Practices

- Use `WHERE` whenever possible because it filters data early, making queries more efficient.
- Use `HAVING` only for filtering aggregated results.
- Avoid using `HAVING` as a replacement for `WHERE`.
- When both are needed, use `WHERE` first to reduce the dataset before grouping.

---

# Quick Reference

| Want to... | Use |
|-------------|-----|
| Filter rows before grouping | `WHERE` |
| Filter grouped results | `HAVING` |
| Filter by salary | `WHERE salary_year_avg > 80000` |
| Filter by average salary | `HAVING AVG(salary_year_avg) > 80000` |
| Filter by count of records | `HAVING COUNT(*) > 10` |
