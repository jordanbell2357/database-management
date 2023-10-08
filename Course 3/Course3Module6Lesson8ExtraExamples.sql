-- SQL statements for classification problems that use a limited history of events and event weight in a feature list. 
-- Extra examples beyond slides for lesson 8
-- These extended examples using the store sales tables may be useful on the module 6 assignment.
-- None of these examples appear in the lesson notes.
-- All statements execute in both Oracle and PostgreSQL except where noted.

-- Example 1
-- Store sales tables
-- Sales by WA state customers in 2020 to 2021
-- Compute rank using ROW_NUMBER analytic function for each
-- Rank sales by SalesDollar.
-- Entity is a combination of customer and day

-- CTE with simple usage
WITH CTERankedSales AS (
SELECT SSSales.TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY SSSales.TimeNo, SSSales.CustId  
					 ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales 
      ON SSCustomer.CustId = SSSales.CustId
	  INNER JOIN SSTimeDim ON SSSales.TimeNo = SSTimeDim.TimeNo
 WHERE CustState = 'WA'
   AND TimeYear BETWEEN 2020 AND 2021 )
-- Simple SELECT statement using the CTE
SELECT * FROM CTERankedSales;

-- Example 2
-- WA state customers with only 2 sales in 2021 to 2022
-- No combinations of day and customer with only 1 sale

WITH CTERankedSales AS (
SELECT SSSales.TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY SSSales.TimeNo, SSSales.CustId  
					 ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales 
      ON SSCustomer.CustId = SSSales.CustId
	  INNER JOIN SSTimeDim ON SSSales.TimeNo = SSTimeDim.TimeNo
 WHERE CustState = 'WA'
   AND TimeYear BETWEEN 2020 AND 2021 )

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

-- Example 3
-- WA state customers with only 2 sales in 2021 to 2022
-- Entity is a combination of customer and day

WITH CTERankedSales AS (
SELECT SSSales.TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY SSSales.TimeNo, SSSales.CustId  
					 ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales 
      ON SSCustomer.CustId = SSSales.CustId
	  INNER JOIN SSTimeDim ON SSSales.TimeNo = SSTimeDim.TimeNo
 WHERE CustState = 'WA'
   AND TimeYear BETWEEN 2020 AND 2021 )

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

-- Example 4
-- WA state customers with only 3 or more sales in 2021 to 2022
-- The SELECT statement only uses the top 3 sales of WA customers with more than 3 sales.
-- Store sales tables
-- Entity is a combination of customer and day

WITH CTERankedSales AS (
SELECT SSSales.TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY SSSales.TimeNo, SSSales.CustId  
					 ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales 
      ON SSCustomer.CustId = SSSales.CustId
	  INNER JOIN SSTimeDim ON SSSales.TimeNo = SSTimeDim.TimeNo
 WHERE CustState = 'WA'
   AND TimeYear BETWEEN 2020 AND 2021 )

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

-- Example 5
-- Final query with union of subqueries. One subquery each for sales with 1 item, 2 items, and 3 items.
-- WA state customers with only 3 or more sales in 2021 to 2022
-- For PostgreSQL, Must use 0 instead of NULL for SalesDollar missing values. 
-- NULL usage causes a type conversion error.
-- NULL can be used for both columns with Oracle.

WITH CTERankedSales AS (
SELECT SSSales.TimeNo, SSSales.CustId, CustState, CustZip, ItemId, SalesDollar,
 ROW_NUMBER() OVER ( PARTITION BY SSSales.TimeNo, SSSales.CustId  
					 ORDER BY SalesDollar DESC) AS SalesDollarRank
 FROM SSCustomer INNER JOIN SSSales 
      ON SSCustomer.CustId = SSSales.CustId
	  INNER JOIN SSTimeDim ON SSSales.TimeNo = SSTimeDim.TimeNo
 WHERE CustState = 'WA'
   AND TimeYear BETWEEN 2020 AND 2021 )

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