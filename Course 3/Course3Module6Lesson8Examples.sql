-- SQL statements for classification problems that use a limited history of events and event weight in a feature list. 
-- For the order entry tables, OrdLine provides Qty as a weight. 
-- Qty * ProdPrice is another weight choice combining OrdLine and Product tables.
-- For the store sales tables, the SSSales table provides several columns to evaluate sales:
-- SalesUnits, SalesCost, and SalesDollar.
-- Some examples shown in the the lesson notes. Some examples not shown in the lesson notes.
-- All statements execute in both Oracle and PostgreSQL except where noted.

-- Example 1
-- Order entry tables
-- Compute rank using ROW_NUMBER analytic function for each
-- Customers with only 1 product
-- SELECT statement to retrieve all details of the CTE

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, ProdNo, Qty,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty DESC) AS QtyRank
 FROM Customer, OrderTbl, OrdLine 
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo )
SELECT * FROM CTERankedProducts;

-- Example 2
-- Store sales tables
-- CTE and SELECT statement using the CTE
-- Entity is a combination of customer and day

WITH CTERankedSales AS (
SELECT TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY TimeNo, SSSales.CustId  ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales ON SSCustomer.CustId = SSSales.CustId )
SELECT * FROM CTERankedSales;

-- Example 3
-- Order entry tables
-- Compute rank using ROW_NUMBER analytic function for each
-- Customers with only 1 product

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, ProdNo, Qty,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty DESC) AS QtyRank
 FROM Customer, OrderTbl, OrdLine 
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo )

SELECT CustNo, CustZip, CustBal, ProdNo AS ProdNo1, Qty AS Qty1, NULL AS ProdNo2, 0 AS Qty2, 
       NULL AS ProdNo3, 0 AS Qty3
 FROM CTERankedProducts CTE1
 WHERE CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) = 1 )
-- ORDER BY optional. Removed in final, combined query 
 ORDER BY CustNo;

-- Example 4
-- Order entry tables
-- Customers with only 2 products

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, ProdNo, Qty,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty DESC) AS QtyRank
 FROM Customer, OrderTbl, OrdLine 
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo )

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,         
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.Qty ELSE CTE2.Qty END AS Qty1,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.Qty ELSE CTE2.Qty END AS Qty2,
       NULL AS ProdNo3, 0 AS Qty3
 FROM CTERankedProducts CTE1, CTERankedProducts CTE2
 WHERE CTE1.CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) = 2 )
   AND CTE1.CustNo = CTE2.CustNo
   AND CTE1.ProdNo < CTE2.ProdNo
-- ORDER BY optional. Removed in final, combined query 
   ORDER BY CustNo;

-- Can also use column name after CASE and value after WHEN

       CASE CTE1.QtyRank WHEN 1 THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo1,
       CASE CTE1.QtyRank WHEN 1 THEN CTE1.Qty ELSE CTE2.Qty END AS Qty1,
       CASE CTE1.QtyRank WHEN 2 THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo2,
       CASE CTE1.QtyRank WHEN 2 THEN CTE1.Qty ELSE CTE2.Qty END AS Qty2,
       NULL AS ProdNo3, 0 AS Qty3

-- Example 5
-- Order entry tables
-- Customers with 3 or more products with 3 as the maximum number of products in an order considered by a classifier
-- Only the top 3 products are used for customers with more than 3 products
-- Not shown in the lesson notes

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, ProdNo, Qty,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty DESC) AS QtyRank
 FROM Customer, OrderTbl, OrdLine 
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo )

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,        
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty1,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.Qty THEN CTE2.Qty ELSE CTE3.Qty END AS Qty2,
       CASE 3 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo3,
       CASE 3 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty3
 FROM CTERankedProducts CTE1, CTERankedProducts CTE2, CTERankedProducts CTE3
 WHERE CTE1.CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) >= 3 )
   AND CTE1.CustNo = CTE2.CustNo
   AND CTE2.CustNo = CTE3.CustNo
   AND CTE1.ProdNo < CTE2.ProdNo
   AND CTE2.ProdNo < CTE3.ProdNo
   AND CTE1.QtyRank < 4
   AND CTE2.QtyRank < 4
   AND CTE3.QtyRank < 4
-- ORDER BY optional. Removed in final, combined query 
 ORDER BY CustNo;

-- Can also use column name after CASE and value after WHEN
       CASE CTE1.QtyRank WHEN 1 THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo1,
       CASE CTE1.QtyRank WHEN 1 THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty1,
       CASE CTE1.QtyRank WHEN 2 THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo2,
       CASE CTE1.QtyRank WHEN 2 THEN CTE1.Qty WHEN CTE2.Qty THEN CTE2.Qty ELSE CTE3.Qty END AS Qty2,
       CASE CTE1.QtyRank WHEN 3 THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo3,
       CASE CTE1.QtyRank WHEN 3 THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty3

-- Example 6
-- Order entry tables
-- Complete query with union of subqueries. One subquery each for orders with 1 product, 2 products, and 3 products.
-- For PostgreSQL, must use 0 instead of NULL for Qty missing values. NULL usage causes a type conversion error.
-- NULL does not cause a data type error for Oracle
-- Not shown in the lesson notes

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, ProdNo, Qty,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty DESC) AS QtyRank
 FROM Customer, OrderTbl, OrdLine 
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo )

SELECT CustNo, CustZip, CustBal, ProdNo AS ProdNo1, Qty AS Qty1, NULL AS ProdNo2, 0 AS Qty2, NULL AS ProdNo3, 0 AS Qty3
FROM CTERankedProducts CTE1
WHERE CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) = 1 )

UNION

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,        
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.Qty ELSE CTE2.Qty END AS Qty1,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.Qty ELSE CTE2.Qty END AS Qty2,
       NULL AS ProdNo3, 0 AS Qty3
FROM CTERankedProducts CTE1, CTERankedProducts CTE2
WHERE CTE1.CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) = 2 )
  AND CTE1.CustNo = CTE2.CustNo
  AND CTE1.ProdNo < CTE2.ProdNo

UNION

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,        
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty1,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty2,
       CASE 3 WHEN CTE1.QtyRank THEN CTE1.ProdNo WHEN CTE2.QtyRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo3,
       CASE 3 WHEN CTE1.QtyRank THEN CTE1.Qty WHEN CTE2.QtyRank THEN CTE2.Qty ELSE CTE3.Qty END AS Qty3
 FROM CTERankedProducts CTE1, CTERankedProducts CTE2, CTERankedProducts CTE3
 WHERE CTE1.CustNo IN
 ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(QtyRank) >= 3 )
   AND CTE1.CustNo = CTE2.CustNo
   AND CTE2.CustNo = CTE3.CustNo
   AND CTE1.ProdNo < CTE2.ProdNo
   AND CTE2.ProdNo < CTE3.ProdNo
   AND CTE1.QtyRank < 4
   AND CTE2.QtyRank < 4
   AND CTE3.QtyRank < 4
-- Optional ORDER BY clause to see ordered results
 ORDER BY CustNo;

-- Example 7
-- Not shown in the notes
-- Same as example 6 except using a derived weight column
-- Using amount (Qty * ProdPrice) as the weight. Requires a join with the Product table.

WITH CTERankedProducts AS (
SELECT Customer.CustNo, CustZip, CustBal, OrdLine.ProdNo, Qty*ProdPrice as Amt,
 ROW_NUMBER() OVER ( PARTITION BY Customer.CustNo ORDER BY Qty*ProdPrice DESC) AS AmtRank
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE Customer.CustNo = OrderTbl.CustNo 
   AND OrdLine.OrdNo = OrderTbl.OrdNo
   AND OrdLine.ProdNo = Product.ProdNo )

SELECT CustNo, CustZip, CustBal, ProdNo AS ProdNo1, Amt AS Amt1, NULL AS ProdNo2, 0 AS Amt2, 
       NULL AS ProdNo3, 0 AS Amt3
 FROM CTERankedProducts
 WHERE CustNo IN
  ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(AmtRank) = 1 )

UNION

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,        
       CASE 1 WHEN CTE1.AmtRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.AmtRank THEN CTE1.Amt ELSE CTE2.Amt END AS Amt1,
       CASE 2 WHEN CTE1.AmtRank THEN CTE1.ProdNo ELSE CTE2.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.AmtRank THEN CTE1.Amt ELSE CTE2.Amt END AS Amt2,
       NULL AS ProdNo3, 0 AS Amt3
 FROM CTERankedProducts CTE1, CTERankedProducts CTE2
 WHERE CTE1.CustNo IN
  ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(AmtRank) = 2 )
   AND CTE1.CustNo = CTE2.CustNo
   AND CTE1.ProdNo < CTE2.ProdNo

UNION

SELECT CTE1.CustNo, CTE1.CustZip, CTE1.CustBal,        
       CASE 1 WHEN CTE1.AmtRank THEN CTE1.ProdNo WHEN CTE2.AmtRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo1,
       CASE 1 WHEN CTE1.AmtRank THEN CTE1.Amt WHEN CTE2.AmtRank THEN CTE2.Amt ELSE CTE3.Amt END AS Amt1,
       CASE 2 WHEN CTE1.AmtRank THEN CTE1.ProdNo WHEN CTE2.AmtRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo2,
       CASE 2 WHEN CTE1.AmtRank THEN CTE1.Amt WHEN CTE2.AmtRank THEN CTE2.Amt ELSE CTE3.Amt END AS Amt2,
       CASE 3 WHEN CTE1.AmtRank THEN CTE1.ProdNo WHEN CTE2.AmtRank THEN CTE2.ProdNo ELSE CTE3.ProdNo END AS ProdNo3,
       CASE 3 WHEN CTE1.AmtRank THEN CTE1.Amt WHEN CTE2.AmtRank THEN CTE2.Amt ELSE CTE3.Amt END AS Amt3
 FROM CTERankedProducts CTE1, CTERankedProducts CTE2, CTERankedProducts CTE3
 WHERE CTE1.CustNo IN
  ( SELECT CustNo
     FROM CTERankedProducts
     GROUP BY CustNo
     HAVING MAX(AmtRank) >= 3 )
   AND CTE1.CustNo = CTE2.CustNo
   AND CTE2.CustNo = CTE3.CustNo
   AND CTE1.ProdNo < CTE2.ProdNo
   AND CTE2.ProdNo < CTE3.ProdNo
   AND CTE1.AmtRank < 4
   AND CTE2.AmtRank < 4
   AND CTE3.AmtRank < 4
-- Optional ORDER BY clause to see ordered results
 ORDER BY CustNo;

-- Example 8
-- Store sales tables
-- Not shown in the lesson notes
-- Compute rank using ROW_NUMBER analytic function for each
-- Customers with only 1 sale
-- Rank sales by SalesDollar.
-- Entity is a combination of customer and day
-- No combinations of day and customer with only 1 sale

WITH CTERankedSales AS (
SELECT TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY TimeNo, SSSales.CustId  ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales ON SSCustomer.CustId = SSSales.CustId )

SELECT TimeNo, CustId, CustState, CustZip, ItemId AS Item1, SalesDollar AS SalesDollar1, 
       NULL AS Item2, 0 AS SalesDollar2, NULL AS Item3, 0 AS SalesDollar3
 FROM CTERankedSales
 WHERE CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) = 1 )
-- Optional ORDER BY clause to see ordered results
ORDER BY TimeNo, CustId;

-- Example 9
-- Not shown in the notes
-- Store sales tables
-- Customers with only 2 sales
-- Entity is a combination of customer and day

WITH CTERankedSales AS (
SELECT TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY TimeNo, SSSales.CustId ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales ON SSCustomer.CustId = SSSales.CustId )

SELECT CTE1.TimeNo, CTE1.CustId, CTE1.CustState, CTE1.CustZip, 
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item1,
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar1,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item2,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar2,
       NULL AS ItemId3, 0 AS SalesDollar3
 FROM CTERankedSales CTE1, CTERankedSales CTE2
 WHERE CTE1.CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) = 2 )
   AND CTE1.CustId = CTE2.CustId
   AND CTE1.TimeNo = CTE2.TimeNo
   AND CTE1.ItemId < CTE2.ItemId
-- Optional ORDER BY clause to see ordered results
 ORDER BY CTE1.TimeNo, CTE1.CustId;

-- Example 10
-- Not shown in the lesson notes
-- Customers with 3 or more products with 3 as the maximum number of products in an order considered by a classifier
-- Only the top 3 products are used for customers with more than 3 products
-- Store sales tables
-- Entity is a combination of customer and day

WITH CTERankedSales AS (
SELECT TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY TimeNo, SSSales.CustId ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales ON SSCustomer.CustId = SSSales.CustId )

SELECT CTE1.TimeNo, CTE1.CustId, CTE1.CustState, CTE1.CustZip,        
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item1,
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar1,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item2,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar2,
       CASE 3 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId WHEN CTE2.SalesDollarRank THEN CTE2.ItemId ELSE CTE3.ItemId END AS Item3,
       CASE 3 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar WHEN CTE2.SalesDollarRank THEN CTE2.SalesDollar ELSE CTE3.SalesDollar END AS SalesDollar3
 FROM CTERankedSales CTE1, CTERankedSales CTE2, CTERankedSales CTE3
 WHERE CTE1.CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) >= 3 )
   AND CTE1.CustId = CTE2.CustId
   AND CTE1.TimeNo = CTE2.TimeNo
   AND CTE1.ItemId < CTE2.ItemId
   AND CTE2.CustId = CTE3.CustId
   AND CTE2.TimeNo = CTE3.TimeNo
   AND CTE2.ItemId < CTE3.ItemId
   AND CTE1.SalesDollarRank < 4
   AND CTE2.SalesDollarRank < 4
   AND CTE3.SalesDollarRank < 4
-- Optional ORDER BY clause to see ordered results
 ORDER BY CTE1.TimeNo, CTE1.CustId;

-- Example 11
-- Store sales tables
-- Not shown in the lesson notes
-- Final query with union of subqueries. One subquery each for sales with 1 item, 2 items, and 3 items.
-- Must use 0 instead of NULL for SalesDollar missing values. NULL usage causes a type conversion error.

WITH CTERankedSales AS (
SELECT TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY TimeNo, SSSales.CustId ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales ON SSCustomer.CustId = SSSales.CustId )

SELECT TimeNo, CustId, CustState, CustZip, ItemId AS Item1, SalesDollar AS SalesDollar1, 
       NULL AS Item2, 0 AS SalesDollar2, NULL AS Item3, 0 AS SalesDollar3
 FROM CTERankedSales
 WHERE CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) = 1 )

UNION

SELECT CTE1.TimeNo, CTE1.CustId, CTE1.CustState, CTE1.CustZip, 
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item1,
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar1,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item2,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar2,
       NULL AS ItemId3, 0 AS SalesDollar3
 FROM CTERankedSales CTE1, CTERankedSales CTE2
 WHERE CTE1.CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) = 2 )
   AND CTE1.CustId = CTE2.CustId
   AND CTE1.TimeNo = CTE2.TimeNo
   AND CTE1.ItemId < CTE2.ItemId

UNION

SELECT CTE1.TimeNo, CTE1.CustId, CTE1.CustState, CTE1.CustZip,        
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item1,
       CASE 1 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar1,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId ELSE CTE2.ItemId END AS Item2,
       CASE 2 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar ELSE CTE2.SalesDollar END AS SalesDollar2,
       CASE 3 WHEN CTE1.SalesDollarRank THEN CTE1.ItemId WHEN CTE2.SalesDollarRank THEN CTE2.ItemId ELSE CTE3.ItemId END AS Item3,
       CASE 3 WHEN CTE1.SalesDollarRank THEN CTE1.SalesDollar WHEN CTE2.SalesDollarRank THEN CTE2.SalesDollar ELSE CTE3.SalesDollar END AS SalesDollar3
 FROM CTERankedSales CTE1, CTERankedSales CTE2, CTERankedSales CTE3
 WHERE CTE1.CustId IN
  ( SELECT CustId
     FROM CTERankedSales
     GROUP BY CustId
     HAVING MAX(SalesDollarRank) >= 3 )
   AND CTE1.CustId = CTE2.CustId
   AND CTE1.TimeNo = CTE2.TimeNo
   AND CTE1.ItemId < CTE2.ItemId
   AND CTE2.CustId = CTE3.CustId
   AND CTE2.TimeNo = CTE3.TimeNo
   AND CTE2.ItemId < CTE3.ItemId
   AND CTE1.SalesDollarRank < 4
   AND CTE2.SalesDollarRank < 4
   AND CTE3.SalesDollarRank < 4
-- Optional ORDER BY clause cannot qualify TimeNo and CustNo
ORDER BY TimeNo, CustId;

