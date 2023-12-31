-- Oracle/PostgreSQL Examples in Lesson 2 of Module 4
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Use DROP statements only if you want to rerun all examples
DROP MATERIALIZED VIEW MV1;
DROP MATERIALIZED VIEW MV2;
DROP MATERIALIZED VIEW MV3;

-- Lesson 2

-- Example 1
-- Additional problem not shown in the notes
-- MV for store sales after 2018 store sales by state and year
-- If you are using the Oracle standard edition, you need to remove the query rewrite clause.
-- Remove ENABLE QUERY REWRITE from all CREATE MATERIALIZED VIEW statememts.
-- Oracle solution

CREATE MATERIALIZED VIEW MV1
 BUILD IMMEDIATE
 REFRESH COMPLETE ON DEMAND
 ENABLE QUERY REWRITE AS
 SELECT StoreState, TimeYear, 
        SUM(SalesDollar) AS SUMDollar1
  FROM SSSales, SSStore, SSTimeDim
  WHERE SSSales.StoreId = SSStore.StoreId 
       AND SSSales.TimeNo = SSTimeDim.TimeNo
       AND TimeYear > 2018
  GROUP BY StoreState, TimeYear;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses
CREATE MATERIALIZED VIEW MV1 AS
 SELECT StoreState, TimeYear, 
        SUM(SalesDollar) AS SUMDollar1
  FROM SSSales, SSStore, SSTimeDim
  WHERE SSSales.StoreId = SSStore.StoreId 
       AND SSSales.TimeNo = SSTimeDim.TimeNo
       AND TimeYear > 2018
  GROUP BY StoreState, TimeYear;

-- Example 2
-- Additional problem not shown in the notes
-- USA store sales by store state, year, and month
-- Sum of dollar sales 
-- If you are using the Oracle standard edition, you need to remove the query rewrite clause.
-- Remove ENABLE QUERY REWRITE from all CREATE MATERIALIZED VIEW statememts.

CREATE MATERIALIZED VIEW MV2
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT StoreState, TimeYear, TimeMonth, 
       SUM(SalesDollar) AS SUMDollar2
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation = 'USA'
 GROUP BY StoreState, TimeYear, TimeMonth;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses

CREATE MATERIALIZED VIEW MV2 AS
SELECT StoreState, TimeYear, TimeMonth, 
       SUM(SalesDollar) AS SUMDollar2
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation = 'USA'
 GROUP BY StoreState, TimeYear, TimeMonth;

-- Example 3
-- Additional problem not shown in the notes
-- Canadian store sales before 2019 by store city, year, and month
-- Sum of dollar sales 
-- If you are using the Oracle standard edition, you need to remove the query rewrite clause.
-- Remove ENABLE QUERY REWRITE from all CREATE MATERIALIZED VIEW statememts.
-- Oracle solution

CREATE MATERIALIZED VIEW MV3
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT StoreCity, TimeYear, TimeMonth, 
       SUM(SalesDollar) AS SUMDollar3
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation ='Canada'
   AND TimeYear < 2019
 GROUP BY StoreCity, TimeYear, TimeMonth;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses

CREATE MATERIALIZED VIEW MV3 AS
SELECT StoreCity, TimeYear, TimeMonth, 
       SUM(SalesDollar) AS SUMDollar3
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation ='Canada'
   AND TimeYear < 2019
 GROUP BY StoreCity, TimeYear, TimeMonth;