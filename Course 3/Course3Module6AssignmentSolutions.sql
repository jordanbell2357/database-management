--Problem 1: Baskets containing item sets of two items

SELECT IF1.CustVendorKey, IF1.DateKey, IF1.BranchPlantKey,
 IF1.ItemMasterKey ItemId1, IF2.ItemMasterKey ItemId2
FROM Inventory_Fact IF1, Inventory_Fact IF2
WHERE IF1.CustVendorKey = IF2.CustVendorKey
 AND IF1.DateKey = IF2.DateKey
 AND IF1.BranchPlantKey = IF2.BranchPlantKey
 AND IF1.TransTypeKey = 5
 AND IF2.TransTypeKey = 5
 AND IF1.ItemMasterKey < IF2.ItemMasterKey
ORDER BY IF1.CustVendorKey, IF1.DateKey, IF1.BranchPlantKey,
 IF1.ItemMasterKey;
