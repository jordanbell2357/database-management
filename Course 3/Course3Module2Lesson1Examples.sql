-- Oracle/PostgreSQL Examples in Lesson 1 of Module 2
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Lesson 1

-- Example 1.
-- Summarize sum of store sales for USA and Canada in 2020 by store zip and month
-- Only include groups with more than one row

SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA','Canada') 
   AND TimeYear = 2020
 GROUP BY StoreZip, TimeMonth
 HAVING COUNT(*) > 1
 ORDER BY StoreZip, TimeMonth;

-- Alternative formulation using OR operator and parentheses

SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND (StoreNation = 'USA' 
     OR StoreNation = 'Canada') 
   AND TimeYear = 2020
 GROUP BY StoreZip, TimeMonth
 HAVING COUNT(*) > 1
 ORDER BY StoreZip, TimeMonth;