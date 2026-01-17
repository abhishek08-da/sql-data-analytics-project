/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - To perform time-series analysis and identify seasonality.
    - To measure growth or decline over specific periods.

PostgreSQL Functions Used:
    - Date Functions: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- ====================================================================
-- Analyse sales performance over time
-- Using EXTRACT() for Year and Month
-- ====================================================================
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY
    order_year,
    order_month;

-- ====================================================================
-- Using DATE_TRUNC() for monthly aggregation
-- ====================================================================
SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    DATE_TRUNC('month', order_date)
ORDER BY
    order_month;

-- ====================================================================
-- Using TO_CHAR() for formatted year-month output
-- ====================================================================
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_period,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY
    order_period;
