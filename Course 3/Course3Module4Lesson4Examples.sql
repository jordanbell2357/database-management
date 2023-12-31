-- Oracle/PostgreSQL Examples in Lesson 4 of Module 4
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Use DROP statements only if you want to rerun all examples

-- DROP MATERIALIZED VIEW SalesCostMV1;
-- DROP MATERIALIZED VIEW SalesCostMV2;
-- DROP MATERIALIZED VIEW SalesCostMV3;

-- Need to create MV1, MV2, and MV3 from lesson 2

-- Lesson 4

-- Example 1
-- Data warehouse query

SELECT StoreState, TimeYear, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA','Canada')
   AND TimeYear = 2020
 GROUP BY StoreState, TimeYear;

-- Query Rewrite: replace SSSales and SSTimeDim tables with MV1
-- Join MV1 and SSStore
-- Assumes creation of MV1 in lesson 2

SELECT DISTINCT MV1.StoreState, TimeYear, SumDollar1
FROM MV1, SSStore
WHERE MV1.StoreState = SSStore.StoreState
  AND TimeYear = 2020
  AND StoreNation IN ('USA','Canada');

-- Example 2
-- Data warehouse query
SELECT StoreState, TimeYear, SUM(SalesDollar)
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA','Canada')
   AND TimeYear BETWEEN 2018 and 2021
 GROUP BY StoreState, TimeYear;

-- Query Rewrite
-- Using union of MV1, MV2, and MV3
-- Assumes that StoreCity -> StoreNation
-- Assumes creation of MV1, MV2, and MV3 in lesson 2

SELECT DISTINCT MV1.StoreState, TimeYear, SumDollar1 AS StoreSales
FROM MV1, SSStore
WHERE MV1.StoreState = SSStore.StoreState
  AND TimeYear <= 2021
  AND StoreNation IN ('USA','Canada')
UNION
SELECT StoreState, TimeYear, SUM(SumDollar2) as StoreSales
FROM MV2
WHERE TimeYear = 2018
GROUP BY StoreState, TimeYear
UNION
SELECT DISTINCT StoreState, TimeYear, SUM(SumDollar3) as StoreSales
FROM MV3, SSStore
WHERE MV3.StoreCity = SSStore.StoreCity
  AND TimeYear = 2018 AND StoreNation = 'Canada'
GROUP BY StoreState, TimeYear;

-- Example 2 revised
-- Adds CUBE to Example 2
-- Data warehouse query
SELECT StoreState, TimeYear, SUM(SalesDollar)
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA','Canada')
   AND TimeYear BETWEEN 2018 and 2021
 GROUP BY CUBE(StoreState, TimeYear);

-- Query Rewrite
-- Using union of MV1, MV2, and MV3
-- CUBE after union operations
-- Assumes that StoreCity -> StoreNation
-- Note that the PostgreSQL statement needs the alias (X) for the subquery

SELECT StoreState, TimeYear, SUM(StoreSales) as SumStoreSales
 FROM (
  SELECT DISTINCT MV1.StoreState, TimeYear, SumDollar1 AS StoreSales
   FROM MV1, SSStore
   WHERE MV1.StoreState = SSStore.StoreState
     AND TimeYear <= 2021
     AND StoreNation IN ('USA','Canada')
 UNION
  SELECT StoreState, TimeYear, SUM(SumDollar2) as StoreSales
   FROM MV2
   WHERE TimeYear = 2018
   GROUP BY StoreState, TimeYear
 UNION
  SELECT DISTINCT StoreState, TimeYear, SUM(SumDollar3) as StoreSales
   FROM MV3, SSStore
   WHERE MV3.StoreCity = SSStore.StoreCity
     AND TimeYear = 2018 AND StoreNation = 'Canada' 
   GROUP BY StoreState, TimeYear ) X
GROUP BY CUBE(StoreState, TimeYear);

-- Example 3
-- Additional problem not shown in slides

-- 2020 cost of store sales
-- Oracle MV creation

CREATE MATERIALIZED VIEW SalesCostMV1
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT CustZip, TimeYear, SUM(SalesUnits) AS SumUnits1, 
       SUM(SalesCost) AS SumCost1
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear <= 2020
 GROUP BY CustZip, TimeYear;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses

CREATE MATERIALIZED VIEW SalesCostMV1 AS
SELECT CustZip, TimeYear, SUM(SalesUnits) AS SumUnits1, 
       SUM(SalesCost) AS SumCost1
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear <= 2020
 GROUP BY CustZip, TimeYear;

-- USA cost of store sales.
-- Oracle MV creation

CREATE MATERIALIZED VIEW SalesCostMV2
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT CustZip, TimeYear, TimeQuarter, SUM(SalesUnits) AS SumUnits2, 
       SUM(SalesCost) AS SumCost2
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND CustNation = 'USA'
 GROUP BY CustZip, TimeYear, TimeQuarter;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses

CREATE MATERIALIZED VIEW SalesCostMV2 AS
SELECT CustZip, TimeYear, TimeQuarter, SUM(SalesUnits) AS SumUnits2, 
       SUM(SalesCost) AS SumCost2
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND CustNation = 'USA'
 GROUP BY CustZip, TimeYear, TimeQuarter;

-- After 2019 average cost of store sales
-- If you are using the Oracle standard edition, you need to remove the query rewrite clause.
-- Remove ENABLE QUERY REWRITE from all CREATE MATERIALIZED VIEW statememts.
-- Oracle MV creation

CREATE MATERIALIZED VIEW SalesCostMV3
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
SELECT CustZip, TimeYear, SUM(SalesUnits) AS SumUnits3, 
       SUM(SalesCost) AS SumCost3
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND CustNation = 'Canada'
   AND TimeYear > 2019
 GROUP BY CustZip, TimeYear;

--PostgreSQL solution
-- Remove BUILD, REFRESH and ENABLE clauses

CREATE MATERIALIZED VIEW SalesCostMV3 AS
SELECT CustZip, TimeYear, SUM(SalesUnits) AS SumUnits3, 
       SUM(SalesCost) AS SumCost3
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND CustNation = 'Canada'
   AND TimeYear > 2019
 GROUP BY CustZip, TimeYear;

-- Example 4
-- Additional problem not shown in slides
-- Data warehouse query

SELECT CustZip, TimeYear, 
       SUM(SalesCost)/SUM(SalesUnits) AS SumUnitCost 
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear = 2020
   AND CustNation IN ('USA','Canada')
GROUP BY CustZip, TimeYear;

-- Query Rewrite: replace Sales and Time tables with SalesCostMV1
-- Rewrite using SalesCostMV1
-- Assumes that CustZip -> CustNation

SELECT DISTINCT SMV1.CustZip, TimeYear, 
       SumCost1/SumUnits1 AS SumUnitCost
FROM SalesCostMV1 SMV1, SSCustomer
WHERE SMV1.CustZip = SSCustomer.CustZip
  AND TimeYear = 2020
  AND CustNation IN ('USA','Canada');

-- Example 5
-- Additional problem not shown in slides

-- Data warehouse query
SELECT CustZip, TimeYear,
       SUM(SalesCost)/SUM(SalesUnits) AS SumUnitCost 
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear > 2019
   AND CustNation IN ('USA','Canada')
GROUP BY CustZip, TimeYear;

-- Query Rewrite using all three MVs
-- Assumes that CustZip -> CustNation in first part of the rewritten query
-- Need GROUP BY in second subquery to rollup totals from quarters to years.

SELECT SMV1.CustZip, TimeYear, 
       SumCost1/SumUnits1 AS SumUnitCost
 FROM SalesCostMV1 SMV1, SSCustomer
 WHERE SMV1.CustZip = SSCustomer.CustZip
   AND TimeYear = 2020
 AND CustNation IN ('USA','Canada')
UNION
SELECT SMV2.CustZip, TimeYear,
       SUM(SumCost2)/SUM(SumUnits2) AS SumUnitCost
 FROM SalesCostMV2 SMV2, SSCustomer
 WHERE SMV2.CustZip = SSCustomer.CustZip
   AND TimeYear > 2020
 GROUP BY SMV2.CustZip, TimeYear
UNION
SELECT SMV3.CustZip, TimeYear,
       SumCost3/SumUnits3 AS SumUnitCost
 FROM SalesCostMV3 SMV3
 WHERE TimeYear > 2020;

-- Example 6
-- Additional problem not shown in slides
-- Variation of example 5 with a cube operation

-- Data warehouse query
SELECT CustZip, TimeYear,
       SUM(SalesCost)/SUM(SalesUnits) AS SumUnitCost 
 FROM SSSales, SSCustomer, SSTimeDim
 WHERE SSSales.CustId = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear > 2019
   AND CustNation IN ('USA','Canada')
GROUP BY CUBE(CustZip, TimeYear);

-- Query Rewrite using all three MVs
-- Assumes that CustZip -> CustNation in first part of the rewritten query
-- Since original query generates the unit cost, the subqueries must generate
-- components (sum of costs) and sum of units. The outer query then applies cube operator.
-- PostgreSQL requires the alias (X) after the subquery.

SELECT CustZip, TimeYear, SUM(SumCost)/SUM(SumUnits) AS SumUnitCost
FROM 
(
SELECT SMV1.CustZip, TimeYear, 
       SumCost1 AS SumCost, SumUnits1 AS SumUnits
 FROM SalesCostMV1 SMV1, SSCustomer
 WHERE SMV1.CustZip = SSCustomer.CustZip
   AND TimeYear = 2020
 AND CustNation IN ('USA','Canada')
UNION
SELECT SMV2.CustZip, TimeYear,
       SUM(SumCost2) AS SumCost, SUM(SumUnits2) AS SumUnits
 FROM SalesCostMV2 SMV2, SSCustomer
 WHERE SMV2.CustZip = SSCustomer.CustZip
   AND TimeYear > 2020
 GROUP BY SMV2.CustZip, TimeYear
UNION
SELECT SMV3.CustZip, TimeYear,
       SumCost3 AS SumCost, SumUnits3 AS SumUnits
 FROM SalesCostMV3 SMV3
 WHERE TimeYear > 2020
) X
GROUP BY CUBE(CustZip, TimeYear);