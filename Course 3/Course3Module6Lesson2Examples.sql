-- Script file associated with lesson 2
-- All statements execute in both Oracle and PostgreSQL unless noted.

-- Example 1
-- Item sets of 2 items
-- Order entry tables
-- < condition to eliminate permutations of combinations

SELECT OL1.OrdNo, OL1.ProdNo ProdNo1, 
       OL2.ProdNo ProdNo2
 FROM OrdLine OL1, OrdLine OL2 
 WHERE OL1.OrdNo = OL2.OrdNo 
   AND OL1.ProdNo < OL2.ProdNo
 ORDER BY OL1.OrdNo, OL1.ProdNo;

-- Example 2
-- Asscoiation rules of 2 items
-- Order entry tables
-- <> condition to generate permutations
-- 2 rules for each item set

SELECT OL1.OrdNo, OL1.ProdNo ProdNoLHS, 
       OL2.ProdNo ProdNoRHS
 FROM OrdLine OL1, OrdLine OL2 
 WHERE OL1.OrdNo = OL2.OrdNo 
   AND OL1.ProdNo <> OL2.ProdNo
 ORDER BY OL1.OrdNo, OL1.ProdNo;

-- Example 3
-- Item sets of size 2
-- Store sales tables
-- Basket identified by a combination of CustId, TimeNo, and StoreId
-- No duplicate combinations

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       S1.ItemId ItemId1, S2.ItemId ItemId2
FROM SSSales S1, SSSales S2 
WHERE S1.CustId = S2.CustId 
  AND S1.TimeNo = S2.TimeNo
  AND S1.StoreId = S2.StoreId
  AND S1.ItemId < S2.ItemId
ORDER BY S1.CustId, S1.TimeNo, S1.StoreId, S1.ItemId;

-- Example 4
-- Association rules of size 2
-- 2 rules for each item set
-- Store sales tables
-- Basket identified by a combination of CustId, TimeNo, and StoreId
-- No duplicate combinations

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       S1.ItemId ItemIdLHS, S2.ItemId ItemIdRHS
FROM SSSales S1, SSSales S2 
WHERE S1.CustId = S2.CustId 
  AND S1.TimeNo = S2.TimeNo
  AND S1.StoreId = S2.StoreId
  AND S1.ItemId <> S2.ItemId
ORDER BY S1.CustId, S1.TimeNo, S1.StoreId, S1.ItemId;