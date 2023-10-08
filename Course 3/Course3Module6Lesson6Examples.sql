-- Script file associated with lesson 6
-- All statements execute in both Oracle and PostgreSQL unless noted.

-- Example 1
-- Generate a nested list of product numbers for each order number. 
-- Some association rule mining algorithms use this input format.

-- PostgreSQL using ARRAY constructor
-- The ARRAY constructor with a subquery only works with a single column in the result so other values for each product cannot be added.
-- This limitation can be overcome using a type constructor in which the subquery casts multiple columns into a composite type
-- Association rule mining algorithms only use the product number so the additional product details are not needed.

-- Order Entry tables
-- PostgreSQL only
-- Using ARRAY_AGG aggregate function to generate an array of values
-- Optional ORDER BY clause inside ARRAY_AGG orders ProdNo values in the array

SELECT OrdNo, ARRAY_AGG(ProdNo ORDER BY ProdNo) AS ProdNos
 FROM OrdLine
 GROUP BY OrdNo
 ORDER BY OrdNo;

-- Example 2
-- Store Sales tables
-- Using ARRAY_AGG aggregate function to generate an array of values
-- DISTINCT needed because combination of CustId, TimeNo, and StoreId is not unique.

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       ARRAY_AGG( DISTINCT ItemId ORDER BY ItemId ) AS ItemIds
 FROM SSSales S1
 GROUP BY S1.CustId, S1.TimeNo, S1.StoreId
 ORDER BY S1.CustId, S1.TimeNo, S1.StoreId;

-- Example 3
-- PostgreSQL only
-- HAVING clause to remove baskets (OrdNos) with only 1 item

SELECT OrdNo, ARRAY_AGG(ProdNo ORDER BY ProdNo) AS ProdNos
 FROM OrdLine
 GROUP BY OrdNo
 HAVING COUNT(*) > 1
 ORDER BY OrdNo;

-- Example 4
-- Order entry tables
-- Oracle only
-- LISTAGG aggregate function
-- LISTAGG can be used as an aggregate or analytic function
-- ORDER BY clause in LISTAGG is optional to order values in the result array
-- The argument after the column is a separator.
-- HAVING clause eliminates orders with only 1 product.

SELECT OrdNo, LISTAGG(ProdNo, ', ') WITHIN GROUP (ORDER BY ProdNo) AS ProdNos
 FROM OrdLine
 GROUP BY OrdNo
 HAVING COUNT(*) > 1
 ORDER BY OrdNo;

-- Example 5
-- Store sales tables
-- Oracle only
-- DISTINCT inside LISTAGG because combination of CustId, TimeNo, StoreId is not unique.
-- HAVING clause eliminates baskets with only 1 item.

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       LISTAGG( DISTINCT ItemId, ', ') WITHIN GROUP (ORDER BY ItemId) AS ItemIds
 FROM SSSales S1
 GROUP BY S1.CustId, S1.TimeNo, S1.StoreId
 HAVING COUNT(DISTINCT ItemId) > 1
 ORDER BY S1.CustId, S1.TimeNo, S1.StoreId;

-- Example 6
-- Store Sales tables
-- Not shown in the notes
-- PostgreSQL only
-- HAVING clause to remove baskets (combinations of CustId, TimeNo, and StoreId) with only 1 item

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       ARRAY_AGG( DISTINCT ItemId ORDER BY ItemId ) AS ItemIds
 FROM SSSales S1
 GROUP BY S1.CustId, S1.TimeNo, S1.StoreId
 HAVING COUNT(DISTINCT ItemId) > 1
 ORDER BY S1.CustId, S1.TimeNo, S1.StoreId;