-- Oracle/PostgreSQL Examples in Lesson 1 of Module 4
-- All SELECT statements execute identically in Oracle and PostgreSQL unless noted.

-- These two statements for the Oracle SQL Developer only

SET LINESIZE 32000;
SET PAGESIZE 60;

-- Use DROP statements only if you want to rerun all examples

DROP VIEW Connex20182020Sales_View;
DROP VIEW Connex20182020SumSales_View;
DROP VIEW ColoradoCustomer2018Sales_View;

-- Lesson 1
-- Example 1
CREATE VIEW Connex20182020Sales_View AS
 SELECT SSItem.ItemId, ItemName, ItemCategory, 
        ItemUnitPrice, SalesNo, SalesUnits, 
        SalesDollar, SalesCost, TimeYear, 
        TimeMonth, TimeDay 
  FROM SSItem, SSSales, SSTimeDim
  WHERE ItemBrand = 'Connex' 
    AND TimeYear BETWEEN 2018 AND 2020
    AND SSItem.ItemId = SSSales.ItemId
    AND SSTimeDim.TimeNo = SSSales.TimeNo;

-- Example 2
-- View with row summaries

CREATE VIEW Connex20182020SumSales_View AS
 SELECT SSItem.ItemId, ItemName, ItemCategory, 
        ItemUnitPrice, TimeYear, TimeMonth,
        SUM(SalesDollar) AS SumSalesDollar,
        SUM(SalesCost) AS SumSalesCost
  FROM SSItem, SSSales, SSTimeDim
  WHERE ItemBrand = 'Connex' 
    AND TimeYear BETWEEN 2018 AND 2020
    AND SSItem.ItemId = SSSales.ItemId
    AND SSTimeDim.TimeNo = SSSales.TimeNo
  GROUP BY SSItem.ItemId, ItemName, ItemCategory, 
        ItemUnitPrice, TimeYear, TimeMonth;

-- Example 3
-- Query using Connex20182020Sales_View 

SELECT ItemName, ItemCategory, ItemUnitPrice, 
        SalesUnits, SalesDollar, SalesCost,
        TimeYear, TimeMonth, TimeDay 
  FROM Connex20182020Sales_View
  WHERE ItemUnitPrice < 100
    AND TimeYear BETWEEN 2019 AND 2020;

-- Example 4
-- Query using Connex20182020SumSales_View 

SELECT ItemName, ItemCategory, ItemUnitPrice, 
        TimeMonth, SumSalesDollar, SumSalesCost 
  FROM Connex20182020SumSales_View
  WHERE TimeYear = 2018;

-- Example 5
-- Modified query using the base tables only

SELECT ItemName, ItemCategory, ItemUnitPrice, 
        SalesUnits, SalesDollar, SalesCost,
        TimeYear, TimeMonth, TimeDay  
  FROM SSItem, SSSales, SSTimeDim
  WHERE ItemUnitPrice < 100
    AND ItemBrand = 'Connex' 
    AND TimeYear BETWEEN 2019 AND 2020
    AND SSItem.ItemId = SSSales.ItemId
    AND SSTimeDim.TimeNo = SSSales.TimeNo;

-- Example 6
-- Additional problem not shown in the notes
-- Colorado customer sales in 2018
-- Display customer, item, and time columns in the result

CREATE VIEW ColoradoCustomer2018Sales_View AS
 SELECT SSCustomer.CustId, CustName, CustCity, CustZip, ItemName, ItemCategory, 
        ItemBrand, ItemUnitPrice, SalesNo, SalesUnits, 
        SalesDollar, SalesCost, TimeMonth, TimeDay    
  FROM SSItem, SSSales, SSTimeDim, SSCustomer
  WHERE CustState = 'CO' 
    AND TimeYear = 2018
    AND SSItem.ItemId = SSSales.ItemId
    AND SSTimeDim.TimeNo = SSSales.TimeNo
    AND SSCustomer.CustId = SSSales.CustId;

-- Example 7
-- Additional problem not shown in the notes
-- Denver sales in second half of 2018
-- Display customer, item number, and time columns

SELECT CustId, CustName, CustZip, ItemName, ItemCategory, 
        ItemBrand, ItemUnitPrice, SalesNo, SalesUnits, 
        SalesDollar, SalesCost, TimeMonth, TimeDay 
  FROM ColoradoCustomer2018Sales_View
  WHERE  CustCity = 'Denver' AND TimeMonth > 6;

-- Example 8
-- Additional problem not shown in the notes
-- Modified query

SELECT SSCustomer.CustId, CustName, CustZip, ItemName, ItemCategory, 
        ItemBrand, ItemUnitPrice, SalesNo, SalesUnits, 
        SalesDollar, SalesCost, TimeMonth, TimeDay 
  FROM SSItem, SSSales, SSTimeDim, SSCustomer
  WHERE CustState = 'CO' AND CustCity = 'Denver'
    AND TimeMonth > 6
    AND TimeYear = 2018
    AND SSItem.ItemId = SSSales.ItemId
    AND SSTimeDim.TimeNo = SSSales.TimeNo
    AND SSCustomer.CustId = SSSales.CustId;