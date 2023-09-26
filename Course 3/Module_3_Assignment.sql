-- Query 1: Ranking within the entire result
SELECT c.Name, SUM(ExtCost) AS SumExtCost,
 RANK() OVER (ORDER BY SUM(ExtCost) DESC) ExtCostRank
 FROM inventory_fact i, cust_vendor_dim c
 WHERE i.CustVendorKey = c.CustVendorKey AND TransTypeKey = 5 AND c.State = 'CA'
GROUP BY c.Name;

-- Query 2: Ranking within a partition
SELECT c.State, c.Name, SUM(ExtCost) AS SumExtCost,
 RANK() OVER (PARTITION BY c.State ORDER BY SUM(ExtCost) DESC) ExtCostRank
 FROM inventory_fact i, cust_vendor_dim c
 WHERE i.CustVendorKey = c.CustVendorKey AND TransTypeKey = 5
GROUP BY c.State, c.Name
ORDER BY c.State;

-- Query 3: Ranking and dense ranking
SELECT c.Name, COUNT(*) AS ShipmentCount,
 RANK() OVER (ORDER BY COUNT(*) DESC) ShipmentCounttRank,
 DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) ShipmentCounttDenseRank
 FROM inventory_fact i, cust_vendor_dim c
 WHERE i.CustVendorKey = c.CustVendorKey AND TransTypeKey = 5
GROUP BY c.Name;

-- Query 4: Cumulative external costs for the entire result
select C.Zip, CalYear, CalMonth, sum(ExtCost) as tot_cost,
 SUM(SUM(ExtCost)) OVER (ORDER BY C.Zip, CalYear, CalMonth
 ROWS UNBOUNDED PRECEDING) AS CumSumExtCost
FROM inventory_fact i, cust_vendor_dim c, date_dim d
 WHERE i.CustVendorKey = c.CustVendorKey
 AND TransTypeKey = 5 AND i.DateKey = d.DateKey
group by c.Zip, CalYear, CalMonth;

-- Query 5: Cumulative external costs for a partition
select C.Zip, CalYear, CalMonth, sum(ExtCost) as tot_cost,
 SUM(SUM(ExtCost)) OVER (PARTITION BY C.Zip, CalYear
 ORDER BY C.Zip, CalYear, CalMonth ROWS UNBOUNDED PRECEDING) AS
CumSumExtCost
FROM inventory_fact i, cust_vendor_dim c, date_dim d
 WHERE i.CustVendorKey = c.CustVendorKey
 AND TransTypeKey = 5 AND i.DateKey = d.DateKey
 AND c.Zip = '02162'
 AND calmonth = 6
group by c.Zip, CalYear, CalMonth;

-- Query 6: Ratio to report applied to the entire result
SELECT SECONDITEMID, SUM(EXTCOST) AS TOTAL_COST, (SUM(EXTCOST) /
SUM(SUM(EXTCOST)) OVER ()) AS RATIO_TO_REPORT
FROM INVENTORY_FACT F, ITEM_MASTER_DIM I
WHERE TRANSTYPEKEY = 1
 AND F.ItemMasterKey = I.ItemMasterKey
GROUP BY SECONDITEMID
ORDER BY TOTAL_COST DESC;

-- Not using analytic functions
SELECT X1.seconditemid, ItemExtCost, ItemExtCost/SumExtCost AS ItemExtCostRatio
FROM
 ( SELECT seconditemid, CAST(SUM(extcost) AS NUMERIC) AS ItemExtCost
 FROM inventory_fact, item_master_dim
 WHERE item_master_dim.itemmasterkey = inventory_fact.itemmasterkey
AND transtypekey = 1
 GROUP BY seconditemid) X1,
 ( SELECT CAST(SUM(extcost) AS NUMERIC) AS SumExtCost
 FROM inventory_fact, item_master_dim
 WHERE item_master_dim.itemmasterkey = inventory_fact.itemmasterkey
 AND transtypekey = 1) X2
ORDER BY ItemExtCost DESC;

-- Query 7: Ratio to report applied to a partition
SELECT CalYear, SECONDITEMID, SUM(EXTCOST) AS TOTAL_COST,
(SUM(EXTCOST) / SUM(SUM(EXTCOST)) OVER (PARTITION BY CalYear)) AS
RATIO_TO_REPORT
FROM INVENTORY_FACT F, ITEM_MASTER_DIM I, Date_Dim D
WHERE TRANSTYPEKEY = 1
 AND F.ItemMasterKey = I.ItemMasterKey
 AND F.DateKey = D.DateKey
GROUP BY CalYear, SECONDITEMID
ORDER BY CalYear, TOTAL_COST DESC;

-- Not using analytic functions
SELECT X1.CalYear, X1.seconditemid, ItemExtCost,
 ItemExtCost/SumExtCost AS ItemExtCostRatio
FROM
 ( SELECT D.CalYear, seconditemid, CAST(SUM(extcost) AS NUMERIC) AS ItemExtCost
 FROM inventory_fact F, item_master_dim I, Date_Dim D
 WHERE I.itemmasterkey = F.itemmasterkey
 AND F.DateKey = D.DateKey
 AND transtypekey = 1
 GROUP BY CalYear, seconditemid) X1,
 ( SELECT D2.CalYear, CAST(SUM(extcost) AS NUMERIC) AS SumExtCost
 FROM inventory_fact F2, item_master_dim I2, Date_Dim D2
 WHERE I2.itemmasterkey = F2.itemmasterkey
 AND F2.DateKey = D2.DateKey
 AND transtypekey = 1
 GROUP BY CalYear) X2
WHERE X1.CalYear = X2.CalYear
ORDER BY X1.CalYear, ItemExtCost DESC;

-- Query 8: Cumulative distribution functions for carrying cost of
-- branch plants

SELECT BPName, CompanyKey, CarryingCost,
 RANK() OVER (ORDER BY CarryingCost) As RankCarryCost,
 PERCENT_RANK() OVER (ORDER BY CarryingCost) As PercentRankCarryCost,
 CUME_DIST() OVER (ORDER BY CarryingCost) As CumDistCarryCost
FROM branch_plant_dim;

-- Query 9: Determine worst performing plants
SELECT BPName, CompanyKey, CarryingCost, CumDistCarryCost
FROM ( SELECT BPName, CompanyKey, CarryingCost,
 CUME_DIST() OVER (ORDER BY CarryingCost) As CumDistCarryCost
FROM branch_plant_dim ) X
WHERE CumDistCarryCost >= 0.85;

-- Query 10: Cumulative distribution of external cost for Colorado
-- inventory

SELECT DISTINCT ExtCost,
 CUME_DIST() OVER (ORDER BY ExtCost) As CumDistExtCost
FROM cust_vendor_dim cvd, inventory_fact if
WHERE cvd.CustVendorKey = if.CustVendorKey AND State = 'CO'
ORDER BY ExtCost;