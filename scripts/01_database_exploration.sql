/*
===============================================================================
Database Exploration (PostgreSQL)
===============================================================================
Purpose:
    - Explore database structure using INFORMATION_SCHEMA
    - Identify schemas, tables, and views
    - Inspect column-level metadata for dimensional tables

Database:
    - PostgreSQL
===============================================================================
*/

-- List all tables and views in the database
SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');


-- Inspect column details for dim_customers table
SELECT
    column_name,
    data_type,
    is_nullable,
    character_maximum_length,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_schema = 'gold'
  AND table_name = 'dim_customers';

