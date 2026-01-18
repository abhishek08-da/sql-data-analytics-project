/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To identify which product categories contribute the most to total sales.
    - To calculate each category’s share (%) of overall sales.
    - Useful for category performance comparison and portfolio analysis.

SQL Functions Used:
    - SUM(): Aggregate sales
    - Window Function: SUM() OVER() for total sales
    - ROUND(): Percentage formatting
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Overall sales across all categories
    SUM(total_sales) OVER () AS overall_sales,

    -- Category contribution percentage
    ROUND((total_sales::numeric / SUM(total_sales) OVER ()) * 100,2) AS percentage_of_total

FROM category_sales
ORDER BY total_sales DESC;
