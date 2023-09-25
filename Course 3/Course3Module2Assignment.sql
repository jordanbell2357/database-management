-- 1
-- Assignment requires CUBE solution
select CalMonth, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by CUBE(AddrCatCode1, d.calmonth);
-- GROUPING SETS solution
-- Solution not in the problem specification
select CalMonth, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by GROUPING SETS((AddrCatCode1, d.calmonth), AddrCatCode1, d.calmonth,
());

-- 2
-- Assignment requires GROUPING SETS solution
select Name, Zip, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by GROUPING SETS((c.Name, c.Zip, d.CalQuarter), (c.Name, c.Zip),
					    (c.Name, d.CalQuarter), (c.Zip, d.CalQuarter),
 c.Name, c.Zip, d.CalQuarter, ());
-- CUBE solution
-- Solution not in the problem specification
select Name, Zip, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by CUBE(c.Name, Zip, d.CalQuarter);

-- 3
-- Assignment requires ROLLUP solution.
select CompanyName, BPName, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, company_dim cd, branch_plant_dim bp
where TransTypeKey = 2 and
 bp.CompanyKey = cd.CompanyKey and
 i.branchplantkey = bp.branchplantkey
group by ROLLUP(CompanyName, BPName);
-- GROUPING SETS solution
select CompanyName, BPName, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, company_dim cd, branch_plant_dim bp
where TransTypeKey = 2 and
 bp.CompanyKey = cd.CompanyKey and
 i.branchplantkey = bp.branchplantkey
group by GROUPING SETS((CompanyName, BPName), CompanyName, ());

-- 4
-- Assignment requires GROUPING SETS solution
select TransDescription, CompanyName, BPName, sum(ExtCost) as Tot_cost,
 count(*) as Count
from inventory_fact i, trans_type_dim tt, branch_plant_dim bp, company_dim c
where i.TransTypeKey = tt.TransTypeKey and
 i.BranchPlantKey = bp.BranchPlantKey and
 bp.CompanyKey = c.CompanyKey
group by GROUPING SETS((TransDescription, CompanyName, BPName),
(TransDescription, CompanyName), TransDescription, ());
-- ROLLUP solution
select TransDescription, CompanyName, BPName, sum(ExtCost) as Tot_cost,
 count(*) as Count
from inventory_fact i, trans_type_dim tt, branch_plant_dim bp, company_dim c
where i.TransTypeKey = tt.TransTypeKey and
 i.BranchPlantKey = bp.BranchPlantKey and
 bp.CompanyKey = c.CompanyKey
group by ROLLUP(TransDescription, CompanyName, BPName);

-- 5
-- Partial ROLLUP solution
select Name, CalYear, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.CalYear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by c.name, ROLLUP(CalYear, d.CalQuarter);

-- 6
select CalMonth, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.CalYear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by d.calmonth, AddrCatCode1
UNION ALL
select CalMonth, NULL, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
 from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by d.calmonth
UNION ALL
select NULL, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by AddrCatCode1
UNION ALL
select NULL, NULL, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey;
 
-- 7: Rewritten Query 3 without the ROLLUP or GROUPING SETS operators
-- UNION and UNION ALL produce the same result
select CompanyName, BPName, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, company_dim cd, branch_plant_dim bp
where TransTypeKey = 2 and
 bp.CompanyKey = cd.CompanyKey and
 i.branchplantkey = bp.branchplantkey
group by CompanyName, BPName
UNION ALL
select CompanyName, NULL, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, company_dim cd, branch_plant_dim bp
where TransTypeKey = 2 and
 bp.CompanyKey = cd.CompanyKey and
 i.branchplantkey = bp.branchplantkey
group by CompanyName
UNION ALL
select NULL, NULL, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, company_dim cd, branch_plant_dim bp
where TransTypeKey = 2 and
 bp.CompanyKey = cd.CompanyKey and
 i.branchplantkey = bp.branchplantkey;
 
-- 8
-- CUBE with composite columns
select Name, CalYear, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by CUBE(c.Name, (CalYear, d.CalQuarter));

-- 9
-- PostgreSQL solution
select CalMonth, AddrCatCode1,
 GROUPING(AddrCatCode1, d.CalMonth) AS GroupNo,
 sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by CUBE(AddrCatCode1, d.calmonth);

-- 10
-- Nested ROLLUP inside GROUPING SETS operator
select Name, CalYear, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by GROUPING SETS (c.Name, ROLLUP(CalYear, d.CalQuarter));