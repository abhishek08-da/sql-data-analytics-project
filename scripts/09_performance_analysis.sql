/*
===============================================================================
Performance Analysis (Year-over-Year, Product Benchmarking)
===============================================================================
Purpose:
    - To analyze yearly product performance.
    - To compare product sales against:
        1. Product’s average sales
        2. Previous year sales (YoY analysis)
    - To identify trends, growth, and decline patterns.

SQL Functions Used:
    - EXTRACT(): Extracts year from date
    - LAG(): Accesses previous year’s sales
    - AVG() OVER(): Calculates average sales per product
    - CASE: Categorizes performance trends
===============================================================================
*/


WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM f.order_date),
        p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,

    -- Average sales of the product across all years
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,

    -- Difference from average
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

    -- Above / Below Average indicator
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year sales (YoY)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,

    -- Year-over-Year difference
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,

    -- YoY trend indicator
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;
