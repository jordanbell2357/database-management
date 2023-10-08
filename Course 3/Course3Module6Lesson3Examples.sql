-- Script file associated with lesson 3
-- All statements execute in both Oracle and PostgreSQL unless noted.

-- Example 1
-- Item sets of 3 items
-- Order entry tables
-- < conditions ensure no permutations of a combination

SELECT OL1.OrdNo, OL1.ProdNo ProdNo1, 
       OL2.ProdNo ProdNo2, OL3.ProdNo ProdNo3
 FROM OrdLine OL1, OrdLine OL2, OrdLine OL3
 WHERE OL1.OrdNo = OL2.OrdNo 
   AND OL2.OrdNo = OL3.OrdNo 
   AND OL1.ProdNo < OL2.ProdNo
   AND OL2.ProdNo < OL3.ProdNo
 ORDER BY OL1.OrdNo, OL1.ProdNo, OL2.ProdNo;

-- Example 2
-- Association rules of 3 items
-- 3 rules for each item set
-- One < condition to ensure no permutations of LHS
-- Two <> conditions to ensure usage of all columns use in the RHS
-- Order entry tables

SELECT OL1.OrdNo, OL1.ProdNo ProdNo1, 
       OL2.ProdNo ProdNo2, OL3.ProdNo ProdNo3
 FROM OrdLine OL1, OrdLine OL2, OrdLine OL3
 WHERE OL1.OrdNo = OL2.OrdNo 
   AND OL2.OrdNo = OL3.OrdNo 
   AND OL1.ProdNo < OL2.ProdNo
   AND OL1.ProdNo <> OL3.ProdNo
   AND OL2.ProdNo <> OL3.ProdNo
 ORDER BY OL1.OrdNo, OL1.ProdNo, OL2.ProdNo;

-- Example 3
-- Item sets of size 3
-- Store sales tables
-- Basket identified by a combination of CustId, TimeNo, and StoreId
-- < condition to eliminate permutations for an item set (combination)

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       S1.ItemId ItemId1, S2.ItemId ItemId2, 
       S3.ItemId ItemId3
 FROM SSSales S1, SSSales S2, SSSales S3
 WHERE S1.CustId = S2.CustId
   AND S2.CustId = S3.CustId 
   AND S1.TimeNo = S2.TimeNo
   AND S2.TimeNo = S3.TimeNo
   AND S1.StoreId = S2.StoreId
   AND S2.StoreId = S3.StoreId
   AND S1.ItemId < S2.ItemId
   AND S2.ItemId < S3.ItemId
 ORDER BY S1.CustId, S1.TimeNo, S1.StoreId, S1.ItemId, S2.ItemId;

-- Example 4
-- Association rules of size 3
-- 3 rules for each item set
-- Store sales tables
-- Basket identified by a combination of CustId, TimeNo, and StoreId
-- < condition to eliminate permutation for a LHS (ItemId1 and ItemId2)
-- <> conditions to allow all columns on the RHS

SELECT S1.CustId, S1.TimeNo, S1.StoreId, 
       S1.ItemId ItemId1, S2.ItemId ItemId2, 
       S3.ItemId ItemId3
 FROM SSSales S1, SSSales S2, SSSales S3
 WHERE S1.CustId = S2.CustId
   AND S2.CustId = S3.CustId 
   AND S1.TimeNo = S2.TimeNo
   AND S2.TimeNo = S3.TimeNo
   AND S1.StoreId = S2.StoreId
   AND S2.StoreId = S3.StoreId
   AND S1.ItemId < S2.ItemId
   AND S1.ItemId <> S3.ItemId
   AND S2.ItemId <> S3.ItemId
 ORDER BY S1.CustId, S1.TimeNo, S1.StoreId, S1.ItemId, S2.ItemId;