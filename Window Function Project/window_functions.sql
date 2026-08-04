--CODE
--Query data
SELECT * 
FROM `sixth-impulse-391307.window.retail_sales`;

--Checking duplicate
WITH duplicate_check AS(SELECT sale_id,
       employee_name,
       ROW_NUMBER() OVER(PARTITION BY (sale_id) ) AS rn
FROM `sixth-impulse-391307.window.retail_sales`)

SELECT *
FROM duplicate_check
WHERE rn>1;

--OVER()
--Company average sales using OVER()
SELECT sale_id,
       employee_name,
       department,
       sales,
       AVG(sales) OVER () AS company_average
FROM `sixth-impulse-391307.window.retail_sales`

--How far each sale is from the company average?
SELECT
    sale_id,
    employee_name,
    department,
    sales,
    CEIL(AVG(sales) OVER ()) AS company_average,
    sales - CEIL(AVG(sales) OVER ()) AS difference_from_average
FROM `sixth-impulse-391307.window.retail_sales`;

--Department average sales using OVER() PARTITION BY()
SELECT
    sale_id,
    employee_name,
    department,
    sales,
    ROUND(AVG(sales) OVER (PARTITION BY department),2) AS department_average
FROM `sixth-impulse-391307.window.retail_sales`;

--How far each sale is above or below its department average.
SELECT
    sale_id,
    employee_name,
    department,
    sales,
    ROUND(AVG(sales) OVER (PARTITION BY department),2) AS department_average,
    ROUND(sales-AVG(sales) OVER (PARTITION BY department),2) as difference_from_department_average,
    CASE
    WHEN sales > ROUND(AVG(sales) OVER (PARTITION BY department),2) THEN 'Above Average'
    WHEN sales < ROUND(AVG(sales) OVER (PARTITION BY department),2) THEN 'Below Average'
    ELSE 'Average'
    END AS average_sale_category
FROM `sixth-impulse-391307.window.retail_sales`;

--Sales transaction ordered from the highest sale to the lowest.
SELECT
    employee_name,
    department,
    sales,
    ROW_NUMBER() OVER (ORDER BY sales DESC) AS sales_position
FROM `sixth-impulse-391307.window.retail_sales`;

--Rank()
--Assign rank where there is ties. Skip numbers
SELECT
    employee_name,
    department,
    sales,
    RANK() OVER (ORDER BY sales DESC, employee_name ASC) AS sales_rank
FROM `sixth-impulse-391307.window.retail_sales`;

--DENSE RANK
--Assign rank where there is ties without skipping numbers
SELECT
    employee_name,
    department,
    sales,
    DENSE_RANK() OVER (ORDER BY sales DESC, employee_name ASC) AS sales_rank
FROM `sixth-impulse-391307.window.retail_sales`;


--Top employees in each department
WITH top_employees AS(
    SELECT
    employee_name,
    department,
    sales,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY sales DESC) AS department_top_employee
FROM `sixth-impulse-391307.window.retail_sales`)

SELECT *
FROM top_employees
WHERE department_top_employee=1;


--Runing total for days
SELECT sale_date,
       employee_name,
       sales,
       SUM(sales) OVER(ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_company_sales
FROM `sixth-impulse-391307.window.retail_sales`;

--LAG()
--Comparing sale to previous
SELECT sale_date,
       employee_name,
       sales,
       LAG(sales) OVER(ORDER BY sale_date) AS previous_sale,
       sales- LAG(sales) OVER(ORDER BY sale_date) as difference
FROM `sixth-impulse-391307.window.retail_sales`;

--OR
WITH sales_history AS (
    SELECT
        sale_date,
        employee_name,
        sales,
        LAG(sales) OVER (
            ORDER BY sale_date, employee_name
        ) AS previous_sale
    FROM `sixth-impulse-391307.window.retail_sales`;
)

SELECT *,
       sales - previous_sale AS difference
FROM sales_history;

--LEAD()
WITH next_sale_value AS (
    SELECT
        sale_date,
        employee_name,
        sales,
        LEAD(sales) OVER (
            ORDER BY sale_date, employee_name
        ) AS next_sale
    FROM `sixth-impulse-391307.window.retail_sales`
)

SELECT
    *,
    next_sale - sales AS expected_change
FROM next_sale_value;


--Compare every employee against the best sale made within their department.
SELECT 
       employee_name,
       department,
       sales,
       FIRST_VALUE(sales) OVER(PARTITION BY department ORDER BY sales DESC) AS best_department_sale,
       sales- FIRST_VALUE(sales) OVER(PARTITION BY department ORDER BY sales DESC) AS gap_to_best
FROM `sixth-impulse-391307.window.retail_sales`;

WITH department_best_sales AS(
        SELECT 
              employee_name,
              department,
              sales,
              FIRST_VALUE(sales) OVER(PARTITION BY department ORDER BY sales DESC) AS best_department_sale
        FROM `sixth-impulse-391307.window.retail_sales`)

SELECT *,
       sales-best_department_sale AS gap_to_best
FROM department_best_sales

--Lowest department sale
WITH least_dept_sales AS(
        SELECT 
            employee_name,
            department,
            sales,
            LAST_VALUE(sales) OVER(PARTITION BY department ORDER BY sales DESC ROWS BETWEEN UNBOUNDED PRECEDING
              AND UNBOUNDED FOLLOWING ) AS lowest_department_sale
        FROM `sixth-impulse-391307.window.retail_sales`
)
SELECT *,
       sales- lowest_department_sale AS gap_from_lowest
FROM least_dept_sales

--Combining Subqueries
WITH department_summary AS (
    SELECT
        employee_name,
        department,
        sales,
        AVG(sales) OVER (
            PARTITION BY department
        ) AS department_average,

        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY sales DESC
        ) AS department_rank,

        FIRST_VALUE(sales) OVER (
            PARTITION BY department
            ORDER BY sales DESC
        ) AS best_department_sale
    FROM `sixth-impulse-391307.window.retail_sales`
)

SELECT
    *,
    best_department_sale - sales AS gap_to_best
FROM department_summary;


































