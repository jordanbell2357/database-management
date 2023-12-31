-- Oracle/PostgreSQL Examples in Lesson 1 of Module 3
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Lesson 1

-- Example 1: rank products by unit price
SELECT ItemId, ItemBrand, ItemUnitPrice,
  RANK() OVER ( ORDER BY ItemUnitPrice ) AS RankUnitPrice
  FROM SSItem;

-- Example 2: rank customers by descending sum of sales

SELECT CustName, SUM(SalesDollar) AS SumSales,
  RANK() OVER (ORDER BY SUM(SalesDollar) DESC) AS SumSalesRank
  FROM SSSales, SSCustomer
  WHERE SSSales.CUSTID = SSCustomer.CUSTID
 GROUP BY CustName;


-- Example 3
-- Additional problem: statement not shown in the notes
-- Rank brands by average sales in 2020 and 2021
SELECT ItemBrand, AVG(SalesDollar) AS AvgSales,
  RANK() OVER (ORDER BY AVG(SalesDollar) DESC) AS AvgSalesRank
  FROM SSSales, SSItem, SSTimeDim
  WHERE SSSales.ItemID = SSItem.ItemId AND SSSales.TimeNo = SSTimeDim.TimeNo
    AND TimeYear BETWEEN 2020 and 2021
  GROUP BY ItemBrand;

-- Example 4
-- Additional problem: statement not shown in the notes
-- Rank brands by average sales in 2020 and 2021
-- Only include brands with more than 10 sales in 2020 and 2021
SELECT ItemBrand, AVG(SalesDollar) AS AvgSales, COUNT(*) AS RowCount,
  RANK() OVER (ORDER BY AVG(SalesDollar) DESC) AS AvgSalesRank
  FROM SSSales, SSItem, SSTimeDim
  WHERE SSSales.ItemID = SSItem.ItemId AND SSSales.TimeNo = SSTimeDim.TimeNo
    AND TimeYear BETWEEN 2020 and 2021
  GROUP BY ItemBrand
  HAVING COUNT(*) > 10;