-- Oracle/PostgreSQL Examples in Lesson 4 of Module 2
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Lesson 4

-- Example 1.
-- Summarize sum of store sales for USA and Canada in 2020 by store zip code and month
-- Generate partial subtotals by store zip code and month

SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS((StoreZip, TimeMonth), StoreZip, TimeMonth, ())
 ORDER BY StoreZip, TimeMonth;

-- Example 2.
-- Summarize sum of store sales for USA and Canada in 2020 by store zip and month
-- Generate only subtotals for store zip, month and grand total without combinations of store zip and month

SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS(StoreZip, TimeMonth, ())
 ORDER BY StoreZip, TimeMonth;

-- Example 3.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT TimeYear, TimeMonth, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY ROLLUP(TimeYear, TimeMonth)
 ORDER BY TimeYear, TimeMonth;

-- Example 4.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT TimeYear, TimeMonth, SUM(SalesDollar)  AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS ((TimeYear, TimeMonth), TimeYear, ())
 ORDER BY TimeYear, TimeMonth;

-- Example 5.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT TimeYear, TimeMonth, TimeDay, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY ROLLUP(TimeYear, TimeMonth, TimeDay)
 ORDER BY TimeYear, TimeMonth, TimeDay;

-- Example 6.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT TimeYear, TimeMonth, TimeDay, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS ((TimeYear, TimeMonth, TimeDay), (TimeYear, TimeMonth), TimeYear, ())
 ORDER BY TimeYear, TimeMonth, TimeDay;

-- Example 7.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY CUBE (StoreZip, TimeMonth)
 ORDER BY StoreZip, TimeMonth;

-- Example 8.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT StoreZip, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS ((StoreZip, TimeMonth), StoreZip, TimeMonth,())
 ORDER BY StoreZip, TimeMonth;

-- Exmaple 9.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT StoreZip, TimeMonth, DivId,
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY CUBE (StoreZip, TimeMonth, DivId)
 ORDER BY StoreZip, TimeMonth, DivId;

-- Example 10.
-- Only shown partially in the slides
-- ORDER BY makes subtotal groups easier to identify
SELECT StoreZip, TimeMonth, DivId,
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS ((StoreZip,TimeMonth,DivId), (StoreZip,TimeMonth), (StoreZip,DivId), 
     (TimeMonth,DivId), StoreZip, TimeMonth, DivId,())
 ORDER BY StoreZip, TimeMonth, DivId;