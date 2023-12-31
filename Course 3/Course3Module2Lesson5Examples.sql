-- Oracle/PostgreSQL Examples in Lesson 5 of Module 2
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only
SET LINESIZE 32000;
SET PAGESIZE 60;

-- Lesson 5

-- Example 1.
-- Partial CUBE
SELECT TimeMonth, DivId, StoreZip, 
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY TimeMonth, CUBE(DivId, StoreZip)
 ORDER BY TimeMonth, DivId, StoreZip;

-- Example 2.
-- Partial ROLLUP
SELECT StoreState, TimeMonth, TimeDay,
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY StoreState, ROLLUP(TimeMonth, TimeDay)
 ORDER BY StoreState, TimeMonth, TimeDay;

-- Example 3.
-- Composite column in ROLLUP
-- No subtotals for StoreState
SELECT StoreNation, StoreState, StoreCity,
       SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear = 2020
 GROUP BY ROLLUP(StoreNation, (StoreState, StoreCity))
 ORDER BY StoreNation, StoreState, StoreCity;

-- Example 4.
-- Nested rollup
-- TimeMonth does not combine with ROLLUP.
-- No grand total
SELECT TimeMonth, StoreNation, StoreState, StoreCity, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS(TimeMonth, ROLLUP(StoreNation, (StoreState, StoreCity) ) )
 ORDER BY TimeMonth, StoreNation, StoreState, StoreCity;

-- Example 5.
-- GROUPING_ID function generates the hierarchical group number for each result row.
-- One value per set of subtotals.
-- 0 for the finest level group
-- Grouping id is incremented for each set of subtotals.
-- Max grouping id is the grand total (2^n) where n is the number of grouping columns.

-- Oracle solution
SELECT StoreZip, TimeMonth, DivId,
       SUM(SalesDollar) AS SumSales, GROUPING_ID(StoreZip, TimeMonth,DivId) AS Group_Level
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY CUBE (StoreZip, TimeMonth, DivId)
 ORDER BY Group_Level;

-- PostgreSQL solution with GROUPING function instead of GROUPING_ID function

SELECT StoreZip, TimeMonth, DivId,
       SUM(SalesDollar) AS SumSales, GROUPING(StoreZip, TimeMonth,DivId) AS Group_Level
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY CUBE (StoreZip, TimeMonth, DivId)
 ORDER BY Group_Level;

-- Additional problems for lesson 5 in slide 9

-- Variation problem 1
-- Partial CUBE on (ItemBrand, StoreState) along with grouping on TimeMonth
-- Subtotal groups: <TimeMonth,ItemBrand,StoreState>, <TimeMonth,ItemBrand>, <TimeMonth,StoreState>, <TimeMonth>

SELECT TimeMonth, ItemBrand, StoreState, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim, SSItem
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.ItemId = SSItem.ItemId
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY TimeMonth, CUBE (ItemBrand, StoreState)
 ORDER BY TimeMonth, ItemBrand, StoreState;

-- Variation problem 2
-- Partial ROLLUP on (TimeQuarter, TimeMonth, TimeDay) along with grouping on ItemBrand
-- Subtotal groups: <ItemBrand,TimeQuarter,TimeMonth,TimeDay>, <ItemBrand,TimeQuarter,TimeMonth>, 
-- <ItemBrand,TimeQuarter>, <ItemBrand>

SELECT ItemBrand, TimeQuarter, TimeMonth, TimeDay, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim, SSItem
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.ItemId = SSItem.ItemId
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY ItemBrand, ROLLUP(TimeQuarter, TimeMonth, TimeDay)
 ORDER BY ItemBrand, TimeQuarter, TimeMonth, TimeDay;

-- Variation problem 3
-- Composite column for ROLLUP ((TimeYear, TimeQuarter), TImeMonth, TimeDay) but no condition on TimeYear
-- Subtotal groups: <TimeYear,TimeQuarter,TimeMonth,TimeDay>,<TimeYear,TimeQuarter,TimeMonth>,
-- <TimeYear,TimeQuarter>, <>

SELECT TimeYear, TimeQuarter, TimeMonth, TimeDay, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
 GROUP BY ROLLUP((TimeYear,TimeQuarter),TimeMonth,TimeDay)
 ORDER BY TimeYear,TimeQuarter,TimeMonth,TimeDay;

-- Variation problem 4
-- GROUPING SETS on ItemBrand, StoreState, and ROLLUP(TimeMonth, TimeDay)
-- Subtotal groups: <ItemBrand>,<StoreState>,<TimeMonth,TimeDay>,<TimeMonth>, <>

SELECT ItemBrand,StoreState,TimeMonth,TimeDay, SUM(SalesDollar) AS SumSales
 FROM SSSales, SSStore, SSTimeDim, SSItem
 WHERE SSSales.StoreId = SSStore.StoreId 
   AND SSSales.ItemId = SSItem.ItemId
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND StoreNation IN ('USA', 'Canada') 
   AND TimeYear = 2020
 GROUP BY GROUPING SETS(ItemBrand,StoreState, ROLLUP(TimeMonth,TimeDay))
 ORDER BY ItemBrand,StoreState,TimeMonth,TimeDay;