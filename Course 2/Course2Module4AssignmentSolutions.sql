-- Solutions for problems 1 to 9 involve Oracle SQL.
-- Solutions for problems 10 to 12 only work with PostgreSQL.
-- CREATE TABLE and INSERT statements work with Oracle and PostgreSQL.
-- An associated document in the same part of the website contains table definition statements.

-- Problem 1 solution (Oracle only)
-- MERGE statement
-- Insert not matched into SSItem
-- Update columns from SSItemChanges1 to corresponding columns in SSItem

MERGE INTO SSItem Target
USING SSItemChanges1 Source
ON (Target.ItemId = Source.ItemId)

WHEN MATCHED THEN
UPDATE SET
 Target.ItemName = Source.ItemName,
 Target.ItemBrand = Source.ItemBrand,
 Target.ItemCategory = Source.ItemCategory,
 Target.ItemUnitPrice = Source.ItemUnitPrice

WHEN NOT MATCHED THEN
INSERT ( Target.ItemId, Target.ItemName, Target.ItemBrand, Target.ItemCategory, Target.ItemUnitPrice )
VALUES ( Source.ItemId, Source.ItemName, Source.ItemBrand, Source.ItemCategory, Source.ItemUnitPrice );

-- List SSItem rows after MERGE
SELECT * FROM SSItem;
SELECT COUNT(*) FROM SSItem;  
-- should be 15

Rollback;

-- Problem 2 solution (Oracle only)
-- Insert not matched into SSItem
-- Update non null columns from SSItemChanges2 to corresponding columns in SSItem
-- Syntax only allows one MATCHED clause. Use DECODE function to substitute non null source values.
-- DECODE(Source.ItemName, NULL, Target.ItemName, Source.ItemName): if Source.ItemName is NULL use Target, else Source

MERGE INTO SSItem Target
USING SSItemChanges2 Source
ON (Target.ItemId = Source.ItemId)
WHEN MATCHED THEN
UPDATE SET 
  Target.ItemName = DECODE(Source.ItemName, NULL, Target.ItemName, Source.ItemName), 
  Target.ItemBrand = DECODE(Source.ItemBrand, NULL, Target.ItemBrand, Source.ItemBrand), 
  Target.ItemCategory = DECODE(Source.ItemCategory, NULL, Target.ItemCategory, Source.ItemCategory), 
  Target.ItemUnitPrice = DECODE(Source.ItemUnitPrice, NULL, Target.ItemUnitPrice, Source.ItemUnitPrice)

WHEN NOT MATCHED THEN
INSERT ( Target.ItemId, Target.ItemName, Target.ItemBrand, Target.ItemCategory, Target.ItemUnitPrice )
VALUES ( Source.ItemId, Source.ItemName, Source.ItemBrand, Source.ItemCategory, Source.ItemUnitPrice );

-- List SSItem rows after MERGE
SELECT * FROM SSItem;
SELECT COUNT(*) FROM SSItem;  
-- should be 15
Rollback;

-- Cleanup tables
DROP TABLE SSItemChanges1;
DROP TABLE SSItemChanges2;
DROP TABLE SSItem;


-- Problem 3 solution (Oracle only)
-- INSERT ALL (Conditional)
INSERT ALL
WHEN ( SalesYear = 2018 ) THEN
INTO ProductSales2018 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2019 ) THEN
INTO ProductSales2019 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2020 ) THEN
INTO ProductSales2020 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2021 ) THEN
INTO ProductSales2021 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
SELECT * FROM ProductSale1;

-- Checking records in all tables
Select * from ProductSales2018;
Select * from ProductSales2019;
Select * from ProductSales2020;
Select * from ProductSales2021;
ROLLBACK;

-- Problem 4 solution (Oracle only)
-- INSERT FIRST (Conditional)
-- Same answer as INSERT ALL as conditions are mutually exclusive
INSERT FIRST
WHEN ( SalesYear = 2018 ) THEN
INTO ProductSales2018 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2019 ) THEN
INTO ProductSales2019 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2020 ) THEN
INTO ProductSales2020 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
WHEN ( SalesYear = 2021 ) THEN
INTO ProductSales2021 VALUES (Product_ID,ProductName,ProductCategory, SalesAmt )
SELECT * FROM ProductSale1;

-- Checking records in all tables
Select * from ProductSales2018;
Select * from ProductSales2019;
Select * from ProductSales2020;
Select * from ProductSales2021;
ROLLBACK;

-- Problem 5 solution (Oracle only)
-- Conditional INSERT FIRST

INSERT FIRST
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 < 4000) THEN
INTO YEAR_LOW_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 >= 4000 and Qtr1+Qtr2+Qtr3+Qtr4 < 7000) THEN
INTO YEAR_MID_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
ELSE
INTO YEAR_HIGH_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
SELECT Product_ID, ProductName, Qtr1, Qtr2, Qtr3, Qtr4 FROM ProductSale2;

-- Checking rows in all tables
select * from YEAR_HIGH_SALES;
select * from YEAR_MID_SALES;
select * from YEAR_LOW_SALES;

ROLLBACK;

-- Problem 6 solution (Oracle only)
-- Conditional INSERT ALL
-- Same result INSERT FIRST as condtions are mutually exclusive
-- Different result if conditions are not written as mutually exclusive
-- < 4000, < 7000, and ELSE
-- < 7000 conditions matches rows in first WHEN clause also

INSERT ALL
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 < 4000) THEN
INTO YEAR_LOW_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 >= 4000 and Qtr1+Qtr2+Qtr3+Qtr4 < 7000) THEN
INTO YEAR_MID_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
ELSE
INTO YEAR_HIGH_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
SELECT Product_ID, ProductName, Qtr1, Qtr2, Qtr3, Qtr4 FROM ProductSale2;

-- Checking records in all tables
select * from YEAR_HIGH_SALES;
select * from YEAR_MID_SALES;
select * from YEAR_LOW_SALES;

ROLLBACK;

-- Drop tables in multiple table INSERT problems (5 and 6)

DROP TABLE YEAR_LOW_SALES;
DROP TABLE YEAR_MID_SALES;
DROP TABLE YEAR_HIGH_SALES;

DROP TABLE ProductSales2018;
DROP TABLE ProductSales2019;
DROP TABLE ProductSales2020;
DROP TABLE ProductSales2021;
DROP TABLE ProductSale1;
DROP TABLE ProductSale2;

-- Problem 7 solution (Oracle only)
-- If the customer has an existing billing record, current usage will be added to the past bill.
-- Usage will be billed at $0.05/minute for the current period.
MERGE INTO Mobile_Bill
USING Mobile_Usage ON (Mobile_Bill.CustID = Mobile_Usage.CustID) 
      WHEN MATCHED THEN UPDATE SET 
        PastAmt = CurrentAmt + PastAmt,
        CurrentAmt = Mobile_USAGE.MINUTESUSED * 0.05
      WHEN NOT MATCHED THEN 
       INSERT VALUES (Mobile_Usage.CustID, Mobile_USAGE.MINUTESUSED * 0.05, 0);

-- Review rows in target table
-- Should be 25 rows in Mobile_Bill
SELECT COUNT(*) FROM Mobile_Bill;
SELECT * FROM Mobile_Bill;

ROLLBACK;

-- Problem 8 solution (Oracle only)
-- Based on a customer's current monthly revenue, they will be inserted into the
-- gold, silver or bronze category. A customer can only join one category.

INSERT FIRST 
WHEN CurrentAmt >= 150 THEN
		INTO Mobile_GOLD 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
WHEN CurrentAmt >= 100 THEN
		INTO Mobile_Silver 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
ELSE
		INTO Mobile_Bronze 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
SELECT Mobile_Customer.CustId, CustName, CustState, CustType, CurrentAmt
  FROM Mobile_Customer;

-- Should show 7 rows
SELECT COUNT(*) FROM Mobile_Gold;
-- Should show 6 rows
SELECT COUNT(*) FROM Mobile_Silver;
-- Should show 12 rows
SELECT COUNT(*) FROM Mobile_Bronze;
ROLLBACK;

-- Problem 9 solution (Oracle only)
-- First two WHEN clauses are not mutually exclusive so some rows
-- inserted into both silver and gold tables.
-- INSERT ALL inserts rows >= 100 including rows
-- >= 150 into Mobile_Silver and rows >= 150 into Mobile_Gold, and
-- rows < 100 into Mobile_Bronze.

INSERT ALL
WHEN CurrentAmt >= 150 THEN
		INTO Mobile_GOLD 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
WHEN CurrentAmt >= 100 THEN
		INTO Mobile_Silver 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
ELSE
		INTO Mobile_Bronze 
		VALUES (CustId, CustName, CustState, CustType, CurrentAmt) 	
SELECT Mobile_Customer.CustId, CustName, CustState, CustType, CurrentAmt
  FROM Mobile_Customer;

-- Should show 7 rows
SELECT COUNT(*) FROM Mobile_Gold;
-- Should show 13 rows
SELECT COUNT(*) FROM Mobile_Silver;
-- Should show 12 rows
SELECT COUNT(*) FROM Mobile_Bronze;
ROLLBACK;

-- Cleanup after problems 8 to 9
DROP TABLE Mobile_Bill;
DROP TABLE Mobile_Usage;
DROP TABLE Mobile_Gold;
DROP TABLE Mobile_Bronze;
DROP TABLE Mobile_Silver;
DROP TABLE Mobile_Customer;

-- Problem 10 solution
-- PostgreSQL only
-- INSERT .. CONFLICT ON statement
-- Insert not matched into SSItem
-- Update columns from SSItemChanges1 to corresponding columns in SSItem
-- Assumes change and target tables created and populated
-- Create and populate the same tables as for problems 1 and 2

INSERT INTO SSItem 
 ( ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice )
   SELECT Change.ItemId, Change.ItemName, Change.ItemBrand, Change.ItemCategory, Change.ItemUnitPrice
     FROM 
	  ( SELECT ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice  
	    FROM SSItemChanges1 ) Change
 ON CONFLICT ( ItemId )
 DO UPDATE SET
   ItemName = EXCLUDED.ItemName,
   ItemBrand = EXCLUDED.ItemBrand,
   ItemCategory = EXCLUDED.ItemCategory,
   ItemUnitPrice = EXCLUDED.ItemUnitPrice;

-- List SSItem rows after INSERT .... CONFLICT ON
SELECT * FROM SSItem;
SELECT COUNT(*) FROM SSItem;  
-- should be 15

--Problem 11 solution
-- PostgreSQL only
-- INSERT .. CONFLICT ON statement
-- Insert not matched into SSItem
-- Update columns from SSItemChanges1 to corresponding columns in SSItem
-- Change table only has NULL values for non changing columns.
-- Assumes change and target tables created and populated
-- Create and populate the same tables as for problems 1 and 2

INSERT INTO SSItem 
 ( ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice )
   SELECT Change.ItemId, Change.ItemName, Change.ItemBrand, Change.ItemCategory, Change.ItemUnitPrice
     FROM 
	  ( SELECT ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice  
	    FROM SSItemChanges2 ) Change
 ON CONFLICT ( ItemId )
 DO UPDATE SET
   ItemName = CASE WHEN EXCLUDED.ItemName IS NOT NULL 
     THEN EXCLUDED.ItemName 
     ELSE SSItem.ItemName END,
   ItemBrand = CASE WHEN EXCLUDED.ItemBrand IS NOT NULL 
     THEN EXCLUDED.ItemBrand 
     ELSE SSItem.ItemBrand END,
   ItemCategory = CASE WHEN EXCLUDED.ItemCategory IS NOT NULL 
     THEN EXCLUDED.ItemCategory 
     ELSE SSItem.ItemCategory END,
   ItemUnitPrice = CASE WHEN EXCLUDED.ItemUnitPrice IS NOT NULL 
     THEN EXCLUDED.ItemUnitPrice 
     ELSE SSItem.ItemUnitPrice END;

SELECT * FROM SSItem;
SELECT COUNT(*) FROM SSItem;  
-- should be 15

-- Problem 12 solution
-- PostgreSQL only
-- See script to drop and create tables for problem 12

INSERT INTO SSItem 
 ( ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice )
   SELECT Change.ItemId, Change.ItemName, Change.ItemBrand, Change.ItemCategory, Change.ItemUnitPrice
     FROM 
	  ( SELECT ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice  
	    FROM SSItemChanges2 ) Change
 ON CONFLICT ( ItemId )
 DO UPDATE SET
   ItemName = CASE WHEN EXCLUDED.ItemName <> 'NV' 
     THEN EXCLUDED.ItemName 
     ELSE SSItem.ItemName END,
   ItemBrand = CASE WHEN EXCLUDED.ItemBrand <> 'NV' 
     THEN EXCLUDED.ItemBrand 
     ELSE SSItem.ItemBrand END,
   ItemCategory = CASE WHEN EXCLUDED.ItemCategory <> 'NV' 
     THEN EXCLUDED.ItemCategory 
     ELSE SSItem.ItemCategory END,
   ItemUnitPrice = CASE WHEN EXCLUDED.ItemUnitPrice <> 0 
     THEN EXCLUDED.ItemUnitPrice 
     ELSE SSItem.ItemUnitPrice END;

SELECT * FROM SSItem;
SELECT COUNT(*) FROM SSItem;  
-- should be 15

-- Drop tables if exist
-- IF EXISTS only executes for PostgreSQL
DROP TABLE IF EXISTS SSItem;
DROP TABLE IF EXISTS SSItemChanges1;
DROP TABLE IF EXISTS SSItemChanges2;