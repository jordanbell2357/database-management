-- Oracle/PostgreSQL Examples in Lesson 3 of Module 2
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Lesson 3
-- Example 1.
SELECT TimeYear, TimeMonth, 
       SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
 GROUP BY ROLLUP(TimeYear, TimeMonth)
 ORDER BY TimeYear, TimeMonth;

-- Example 2. 
-- Rewrite of query 3 using the UNION operator
-- Only partially shown in the lesson 3 slides (slide 7)
SELECT TimeYear,TimeMonth, 
       SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
GROUP BY TimeYear, TimeMonth
UNION
SELECT TimeYear, NULL, SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
GROUP BY TimeYear
UNION
SELECT NULL, NULL, SUM(SalesDollar) AS SumSales, MIN(SalesDollar) AS MinSales,
       COUNT(*) AS RowCount
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
  ORDER BY 1, 2;

-- Example 3.
-- Not shown in the lesson 3 slides
SELECT TimeYear, TimeQuarter, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
 GROUP BY ROLLUP(TimeYear, TimeQuarter, TimeMonth)
 ORDER BY TimeYear, TimeQuarter, TimeMonth;

-- Example 4.
-- Rewrite of query 3 using the UNION operator
-- Not shown in the lesson 3 slides
SELECT TimeYear, TimeQuarter, TimeMonth, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
GROUP BY TimeYear, TimeQuarter, TimeMonth
UNION
SELECT TimeYear, TimeQuarter, 0, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
GROUP BY TimeYear, TimeQuarter
UNION
SELECT TimeYear, 0, 0, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
GROUP BY TimeYear
UNION
SELECT 0, 0, 0, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear BETWEEN 2020 AND 2021
 ORDER BY 1, 2, 3;
