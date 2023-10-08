-- Script file associated with lessons 3 and 4
-- All statements execute in both Oracle and PostgreSQL unless noted.
-- Extra examples beyond class slides
-- These extra examples using the store sales tables may be useful for the module 6 assignment.

-- Extra Example 1
-- Item sets of size 2
-- Store sales tables
-- Basket identified by a combination of CustId and TimeNo
-- Only sales for store id 'S0954327'
-- No duplicate combinations

SELECT S1.CustId, S1.TimeNo, 
       S1.ItemId ItemId1, S2.ItemId ItemId2
FROM SSSales S1, SSSales S2 
WHERE S1.CustId = S2.CustId 
  AND S1.TimeNo = S2.TimeNo
  AND S1.StoreId = 'S0954327'
  AND S2.StoreId = 'S0954327'
  AND S1.ItemId < S2.ItemId

ORDER BY S1.CustId, S1.TimeNo, S1.ItemId;

-- Extra Example 2
-- Association rules of size 2
-- 2 rules for each item set
-- Store sales tables
-- Only sales for store id 'S0954327'
-- Basket identified by a combination of CustId and TimeNo
-- No duplicate combinations

SELECT S1.CustId, S1.TimeNo,  
       S1.ItemId ItemId1, S2.ItemId ItemId2
FROM SSSales S1, SSSales S2 
WHERE S1.CustId = S2.CustId 
  AND S1.TimeNo = S2.TimeNo
  AND S1.StoreId = 'S0954327'
  AND S2.StoreId = 'S0954327'
  AND S1.ItemId <> S2.ItemId
ORDER BY S1.CustId, S1.TimeNo, S1.ItemId;

-- Extra Example 3
-- Item sets of size 3
-- Store sales tables
-- Basket identified by a combination of CustId and TimeNo
-- Only sales for store id 'S0954327'
-- < conditions to eliminate permutations for an item set (combination)

SELECT S1.CustId, S1.TimeNo,  
       S1.ItemId ItemId1, S2.ItemId ItemId2, 
       S3.ItemId ItemId3
 FROM SSSales S1, SSSales S2, SSSales S3
 WHERE S1.CustId = S2.CustId
   AND S2.CustId = S3.CustId 
   AND S1.TimeNo = S2.TimeNo
   AND S2.TimeNo = S3.TimeNo
   AND S1.StoreId = 'S0954327'
   AND S2.StoreId = 'S0954327'
   AND S3.StoreId = 'S0954327'
   AND S1.ItemId < S2.ItemId
   AND S2.ItemId < S3.ItemId
 ORDER BY S1.CustId, S1.TimeNo, S1.ItemId, S2.ItemId;

-- Extra Example 4
-- Association rules of size 3
-- 3 rules for each item set
-- Store sales tables
-- Basket identified by a combination of CustId and TimeNo
-- Only sales for store id 'S0954327'
-- < condition to eliminate permutation for a LHS (ItemId1 and ItemId2)
-- <> conditions to allow all columns on the RHS

SELECT S1.CustId, S1.TimeNo, 
       S1.ItemId ItemId1, S2.ItemId ItemId2, 
       S3.ItemId ItemId3
 FROM SSSales S1, SSSales S2, SSSales S3
 WHERE S1.CustId = S2.CustId
   AND S2.CustId = S3.CustId 
   AND S1.TimeNo = S2.TimeNo
   AND S2.TimeNo = S3.TimeNo
   AND S1.StoreId = 'S0954327'
   AND S2.StoreId = 'S0954327'
   AND S3.StoreId = 'S0954327'
   AND S1.ItemId < S2.ItemId
   AND S1.ItemId <> S3.ItemId
   AND S2.ItemId <> S3.ItemId
 ORDER BY S1.CustId, S1.TimeNo, S1.ItemId, S2.ItemId;

-- Extra example 5
-- Store sales tables
-- Basket identified by a combination of CustId and TimeNo
-- Only sales for store id 'S0954327'
-- Association Rules of size 2 with evaluation measures (Support, Confidence, and Lift)
-- WITH keyword defines a Common Table Expression (CTE)
-- 3 CTES (PairsCTE, RulesCTE, CountProductCTE) in this statement followed by a SELECT statement using the CTEs 

-- CTEs
WITH PairsCTE AS (
SELECT S1.CustId, S1.TimeNo,  
       S1.ItemId ItemId1, S2.ItemId ItemId2
FROM SSSales S1, SSSales S2 
WHERE S1.CustId = S2.CustId 
  AND S1.TimeNo = S2.TimeNo
  AND S1.StoreId = 'S0954327'
  AND S2.StoreId = 'S0954327'
  AND S1.ItemId <> S2.ItemId ),

RulesCTE AS (
SELECT ItemId1 || ' -> ' || ItemId2 as TheRule, 
       ItemId1, ItemId2, COUNT(*) AS SupportCnt 
 FROM PairsCTE
 GROUP BY ItemId1, ItemId2 ),

-- Only count item in storeid 'S0954327'
CountProductCTE AS (
SELECT ItemId, COUNT(ItemId) AS ItemCount
 FROM SSSales
 WHERE StoreId = 'S0954327'
 GROUP BY ItemId )

SELECT R.TheRule, R.SupportCnt, C1.ItemCount, A.NumSales,
  100.0 * (1.0 * R.SupportCnt / A.NumSales) AS SupportPercentage,
  100.0 * (1.0 * R.SupportCnt / C1.ItemCount) AS ConfidencePercentage,
   (1.0 * R.SupportCnt / A.NumSales) / 
  ((1.0 * C1.ItemCount / A.NumSales) *
   (1.0 * C2.ItemCount / A.NumSales))  AS Lift
 FROM RulesCTE R INNER JOIN CountProductCTE C1 
   ON R.ItemId1 = C1.ItemId
   INNER JOIN CountProductCTE C2 ON R.ItemId2 = C2.ItemId
   CROSS JOIN 
  ( SELECT COUNT(*) AS NumSales
      FROM ( SELECT DISTINCT CustId, TimeNo 
              FROM SSSales
              WHERE StoreId = 'S0954327') X ) A
 ORDER BY Lift DESC, ConfidencePercentage DESC;