-- Script file associated with lesson 4
-- All statements execute in both Oracle and PostgreSQL unless noted.

-- Example 1
-- Order entry tables
-- Association Rules of size 2 with evaluation measures (Support, Confidence, and Lift)
-- WITH keyword defines a Common Table Expression (CTE)
-- 3 CTES (PairsCTE, RulesCTE, CountProductCTE) in this statement followed by a SELECT statement using the CTEs 

-- CTEs
WITH PairsCTE AS (
SELECT OL1.OrdNo, OL1.ProdNo LHSProd, OL2.ProdNo RHSProd
 FROM OrdLine OL1, OrdLine OL2
 WHERE OL1.OrdNo = OL2.OrdNo
   AND OL1.ProdNo <> OL2.ProdNo
),
RulesCTE AS (
SELECT LHSProd || ' -> ' || RHSProd as TheRule, 
       LHSProd, RHSProd, COUNT(*) AS SupportCnt 
 FROM PairsCTE
 GROUP BY LHSProd, RHSProd
),
CountProductCTE AS (
SELECT ProdNo, COUNT(OrdNo) AS ProductCount
 FROM OrdLine
 GROUP BY ProdNo
)
-- SELECT statement using the CTEs
-- Multiply counts by 1.0 so that PostgreSQL returns a real number, not an integer.

SELECT R.TheRule, R.SupportCnt, C1.ProductCount, 
  100.0 * (1.0 * R.SupportCnt / A.NumOrders) AS SupportPercentage,
  100.0 * (1.0 * R.SupportCnt / C1.ProductCount) AS ConfidencePercentage,
   (1.0 * R.SupportCnt / A.NumOrders) / 
  ((1.0 * C1.ProductCount / A.NumOrders) *
   (1.0 * C2.ProductCount / A.NumOrders))  AS Lift
 FROM RulesCTE R INNER JOIN CountProductCTE C1 
   ON R.LHSProd = C1.ProdNo
   INNER JOIN CountProductCTE C2 ON R.RHSProd = C2.ProdNo
   CROSS JOIN 
  ( SELECT COUNT(*) NumOrders FROM OrderTbl ) A
 ORDER BY Lift DESC, ConfidencePercentage DESC;

-- Example 1 alternative
-- Order entry tables
-- Alternative solution with improved formatting of results
-- CTEs identical to Example 1

WITH PairsCTE AS (
SELECT OL1.OrdNo, OL1.ProdNo LHSProd, OL2.ProdNo RHSProd
 FROM OrdLine OL1, OrdLine OL2
 WHERE OL1.OrdNo = OL2.OrdNo
   AND OL1.ProdNo <> OL2.ProdNo
),
RulesCTE AS (
SELECT LHSProd || ' -> ' || RHSProd as TheRule, 
       LHSProd, RHSProd, COUNT(*) AS SupportCnt 
 FROM PairsCTE
 GROUP BY LHSProd, RHSProd
),
CountProductCTE AS (
SELECT ProdNo, COUNT(OrdNo) AS ProductCount
 FROM OrdLine
 GROUP BY ProdNo
)

-- Alternative SELECT statement with improved formatting of evaluation measures
SELECT R.TheRule, R.SupportCnt, 
 Cast(100.00 * (1.0 * R.SupportCnt / A.NumOrders ) AS NUMERIC(5, 2)) AS SupportPercentage,
 Cast(100.00 * (1.0 * R.SupportCnt / C1.ProductCount ) AS NUMERIC(5, 2)) AS ConfidencePercentage,
 Cast((1.0 * R.SupportCnt / A.NumOrders) / ((1.0 * C1.ProductCount / A.NumOrders) *
      (1.0 * C2.ProductCount / A.NumOrders)) As NUMERIC(5, 2)) AS Lift
 FROM RulesCTE R INNER JOIN CountProductCTE C1 ON R.LHSProd = C1.ProdNo
      INNER JOIN CountProductCTE C2 ON R.RHSProd = C2.ProdNo
      CROSS JOIN ( SELECT COUNT(*) NumOrders FROM OrderTbl ) A
 ORDER BY Lift DESC, ConfidencePercentage DESC;