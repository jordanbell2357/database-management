-- Oracle/PostgreSQL Examples in Lesson 5 of Module 3
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

Lesson 5

-- Example 1
-- Compute contribution ratio on sum of dollar sales by year and customer city with partitioning on year
-- Order result by year and descending sum of sales

SELECT TimeYear, CustCity, SUM(SalesDollar) AS SumSales,
       RATIO_TO_REPORT(SUM(SalesDollar)) 
         OVER (PARTITION BY TimeYear) AS SumSalesRatio 
 FROM SSCustomer, SSSales, SSTimeDim
 WHERE SSSales.CustID = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
 GROUP BY TimeYear, CustCity
 ORDER BY TimeYear, SUM(SalesDollar) DESC;

-- PostgreSQL does not support RATIO_TO_REPORT
-- Query pattern 1 using SUM analytic function to compute denominators and SUM
-- aggregate function to compute numerators.
-- SUM(SalesDollar) is aggregate function.
-- Outer SUM in SUM( SUM(SalesDollar) OVER ... ) is analytic function.

SELECT TimeYear, CustCity, SUM(SalesDollar) AS SumSales,
       SUM(SalesDollar) / SUM ( SUM(SalesDollar) )  
         OVER (PARTITION BY TimeYear) AS SumSalesRatio 
 FROM SSCustomer, SSSales, SSTimeDim
 WHERE SSSales.CustID = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
 GROUP BY TimeYear, CustCity
 ORDER BY TimeYear, SumSales DESC;

-- Query pattern 2 using FROM clause with two subqueries. Aggregate functions only.
-- Subquery 1 calculates numerators in ratios with grouping on all columns (TimeMonth, ItemBrand)
-- Subquery 2 calculates denominators in ratios with grouping on partitioning columns if any.
-- Outer query has a join condition matching partitioning column (TimeMonth) in each subquery.
-- Compute ratios using numerators from subquery 1 with matching denominators from subquery 2.

SELECT X1.TimeYear, CustCity, SumSales, SumSales/SumYearSales AS SumSalesRatio
 FROM
 ( SELECT SSTimeDim.TimeYear, CustCity, SUM(SalesDollar) AS SumSales
    FROM SSCustomer, SSSales, SSTimeDim
    WHERE SSSales.CustID = SSCustomer.CustId 
      AND SSSales.TimeNo = SSTimeDim.TimeNo
    GROUP BY SSTimeDim.TimeYear, CustCity ) X1, 
 ( SELECT TimeYear, SUM(SalesDollar) as SumYearSales
     FROM SSSales, SSTimeDim
     WHERE SSSales.TimeNo = SSTimeDim.TimeNo
     GROUP BY TimeYear) X2
 WHERE X1.TimeYear = X2.TimeYear
 ORDER BY X1.TimeYear, SumSales DESC;

-- Example 2
-- Cumulative distribution functions on item unit price
-- Display item name, rank, percent rank, and cumulative distribution

SELECT ItemName, ItemUnitPrice,
  RANK() OVER (ORDER BY ItemUnitPrice) As RankUnitPrice,     
  PERCENT_RANK() 
    OVER (ORDER BY ItemUnitPrice) As PercentRankUnitPrice,
  ROW_NUMBER() 
    OVER (ORDER BY ItemUnitPrice) As RowNumUnitPrice,
  CUME_DIST() 
    OVER (ORDER BY ItemUnitPrice) As CumDistUnitPrice
 FROM SSItem;

-- Example 3
-- Demonstrate treatment of equal values
-- Cumulative distribution functions on sum of sales units by customer name
-- Display customer name, rank, percent rank, and cumulative distribution

SELECT CustName, SUM(SalesUnits) AS SumSalesUnits,
  RANK() OVER (ORDER BY SUM(SalesUnits) ) AS RankSalesUnits,
  PERCENT_RANK() OVER (ORDER BY SUM(SalesUnits) ) 
   AS PerRankSalesUnits,
  ROW_NUMBER() 
    OVER (ORDER BY SUM(SalesUnits)) As RowNumSalesUnits,
  CUME_DIST() OVER (ORDER BY SUM(SalesUnits) ) AS CumDistSalesUnits
 FROM SSSales, SSCustomer
 WHERE SSSales.CUSTID = SSCustomer.CUSTID
 GROUP BY CustName;

-- Example 4
-- Demonstrate top performers
-- Oracle only
SELECT ItemName, ItemBrand, ItemUnitPrice, CumDistUnitPrice
 FROM ( SELECT ItemId, ItemName, ItemBrand, ItemUnitPrice,
          CUME_DIST() 
  OVER (ORDER BY ItemUnitPrice DESC) As CumDistUnitPrice
  FROM SSItem )
 WHERE CumDistUnitPrice <= 0.3;

-- Note that PostgreSQL requires an alias name for a subquery while Oracle does not.
-- ASC is default for ordering criteria
-- Table alias necessary for subquery in FROM clause in PostgreSQL
-- but not necessary in Oracle SQL.

SELECT ItemName, ItemBrand, ItemUnitPrice, CumDistUnitPrice
 FROM ( SELECT ItemName, ItemBrand, ItemUnitPrice,
          CUME_DIST() 
  OVER (ORDER BY ItemUnitPrice) As CumDistUnitPrice
  FROM SSItem ) X
 WHERE CumDistUnitPrice >= 0.7;

-- Example 5
-- Additional problem not shown in slides
-- Cumulative distribution of dollar sales in Colorado (CO)
-- Remove duplicates
-- Display dollar sales and cumulative distribution

SELECT DISTINCT SalesDollar,
    CUME_DIST() OVER (ORDER BY SalesDollar) 
      As CumDistSalesDollar
FROM SSCustomer, SSSales
WHERE SSCustomer.CustId = SSSales.CustId 
  AND CustState = 'CO'
ORDER BY SalesDollar;

-- Example 6
-- Additional problem: statement not shown in the notes
-- Top performing (30%) store zip codes on sum of dollar sales
-- Partition by year
-- Display year, store city, sum of dollar sales, and cumulative distribution

-- SELECT statement to determine entire distribution
SELECT TimeYear, CustZip, SUM(SalesDollar) AS SumDollarSales,
    CUME_DIST() OVER (PARTITION BY TimeYear ORDER BY SUM(SalesDollar) ) As CumDistSalesDollar
 FROM SSCustomer, SSSales, SSTimeDim
 WHERE SSSales.CustID = SSCustomer.CustId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
 GROUP BY TimeYear, CustZip;

-- Note that PostgreSQL requires an alias name for a subquery while Oracle does not.
-- The following statement executes in both Oracle and PostgreSQL.
SELECT TimeYear, CustZip, SumDollarSales, CumDistSalesDollar
 FROM ( 
   SELECT TimeYear, Custzip, SUM(SalesDollar) AS SumDollarSales,
       CUME_DIST() OVER (PARTITION BY TimeYear ORDER BY SUM(SalesDollar) ) As CumDistSalesDollar
    FROM SSCustomer, SSSales, SSTimeDim
   WHERE SSSales.CustID = SSCustomer.CustId 
     AND SSSales.TimeNo = SSTimeDim.TimeNo
   GROUP BY TimeYear, CustZip ) X
 WHERE CumDistSalesDollar >= 0.7
 ORDER BY TimeYear, CumDistSalesDollar;

-- Example 7
-- Additional problem in extra notes for PostgreSQL
-- Contribution ratio on sum of 2021 unit sales by month and item brand
-- Partition on month
-- Order result by month and descending sum of unit sales
-- Display month, item brand, number of sales, sum of unit sales, and contribution ratio

-- Oracle solution with RATIO_TO_REPORT function
SELECT TimeMonth, ItemBrand, SUM(SalesUnits) AS SumUnits,
       RATIO_TO_REPORT(SUM(SalesUnits)) OVER (PARTITION BY TimeMonth) AS SumUnitsRatio 
 FROM SSItem, SSSales, SSTimeDim
 WHERE SSSales.ItemID = SSitem.ItemId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo
   AND TimeYear = 2021
 GROUP BY TimeMonth, ItemBrand
 ORDER BY TimeMonth, SUM(SalesUnits) DESC;

-- PostgreSQL does not support RATIO_TO_REPORT
-- Query pattern 1 using SUM analytic function to compute denominators and SUM
-- aggregate function to compute numerators.
-- SUM(SalesDollar) is aggregate function.
-- Outer SUM in SUM(SUM(SalesDollar) ) is analytic function.

SELECT TimeMonth, ItemBrand, SUM(SalesUnits) AS SumUnits,
       SUM(SalesUnits) / SUM ( SUM(SalesUnits) ) 
         OVER (PARTITION BY TimeMonth) AS SumUnitsRatio
 FROM SSItem, SSSales, SSTimeDim
 WHERE SSSales.ItemID = SSitem.ItemId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
 GROUP BY TimeMonth, ItemBrand
 ORDER BY TimeMonth, SumUnits DESC;

-- Query pattern 2 using FROM clause with two subqueries. Aggregate functions only.
-- Subquery 1 calculates numerators in ratios with grouping on all columns (TimeMonth, ItemBrand)
-- Subquery 2 calculates denominators in ratios with no grouping.
-- No join condition in outer query because only 1 row in subquery 2.
-- Compute ratios using numerators from subquery 1 with matching denominators from subquery 2.

SELECT X1.TimeMonth, ItemBrand, X1.SumUnits, 
       SumUnits/SumMonthUnits AS SumUnitRatio
 FROM
 ( SELECT SSTimeDim.TimeMonth, ItemBrand, 
          CAST(SUM(SalesUnits) AS NUMERIC) AS SumUnits
    FROM SSItem, SSSales, SSTimeDim
    WHERE SSSales.ItemId = SSitem.ItemId 
      AND SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
    GROUP BY SSTimeDim.TimeMonth, ItemBrand ) X1, 
 ( SELECT SSTimeDim.TimeMonth, 
          CAST(SUM(SalesUnits) AS NUMERIC) AS SumMonthUnits
     FROM SSSales, SSTimeDim
     WHERE SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
     GROUP BY TimeMonth) X2
 WHERE X1.TimeMonth = X2.TimeMonth
 ORDER BY X1.TimeMonth, SumUnits DESC;

-- Example 8
-- Additional problem in extra notes for PostgreSQL
-- Contribution ratio on sum of 2021 unit sales by item brand
-- No partitioning
-- Order result by descending sum of unit sales
-- Display item brand, number of sales, sum of unit sales, and contribution ratio

-- Oracle solution with RATIO_TO_REPORT function
SELECT ItemBrand, SUM(SalesUnits) AS SumBrandUnits,
       RATIO_TO_REPORT(SUM(SalesUnits)) OVER () AS SumBrandUnitRatio 
 FROM SSItem, SSSales, SSTimeDim
 WHERE SSSales.ItemID = SSitem.ItemId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
 GROUP BY ItemBrand
 ORDER BY SUM(SalesUnits) DESC;

-- PostgreSQL does not support RATIO_TO_REPORT
-- Query pattern 1 using SUM analytic function to compute denominators and SUM
-- aggregate function to compute numerators.
-- SUM(SalesDollar) is aggregate function.
-- Outer SUM in SUM(SUM(SalesDollar) ) is analytic function.

SELECT ItemBrand, SUM(SalesUnits) AS SumBrandUnits,
       SUM(SalesUnits) / SUM ( SUM(SalesUnits) ) 
         OVER () AS SumBrandUnitRatio 
 FROM SSItem, SSSales, SSTimeDim
 WHERE SSSales.ItemID = SSitem.ItemId 
   AND SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
 GROUP BY ItemBrand
 ORDER BY SumBrandUnits DESC;

-- Query pattern 2 using FROM clause with two subqueries. Aggregate functions only.
-- Subquery 1 calculates numerators in ratios with grouping on all columns (TimeMonth, ItemBrand)
-- Subquery 2 calculates denominators in ratios with no grouping.
-- No join condition in outer query because only 1 row in subquery 2.
-- Compute ratios using numerators from subquery 1 with matching denominators from subquery 2.

SELECT ItemBrand, X1.SumBrandUnits, 
       SumBrandUnits/SumTotUnits AS SumBrandUnitRatio
 FROM
 ( SELECT ItemBrand, CAST(SUM(SalesUnits) AS NUMERIC) AS SumBrandUnits
    FROM SSItem, SSSales, SSTimeDim
    WHERE SSSales.ItemId = SSitem.ItemId 
      AND SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021
    GROUP BY ItemBrand ) X1, 
 ( SELECT CAST(SUM(SalesUnits) AS NUMERIC) AS SumTotUnits
     FROM SSSales, SSTimeDim
     WHERE SSSales.TimeNo = SSTimeDim.TimeNo AND TimeYear = 2021 ) X2
 ORDER BY SumBrandUnits DESC;