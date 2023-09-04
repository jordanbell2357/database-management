-- Tables for problems in the Module 4 assignment
-- CREATE TABLE and INSERT statements work for problems 1 to 9 for Oracle although also execute in PostgreSQL
-- CREATE TABLE and INSERT statements work for problems 10 to 12 for PostgreSQL

-- Problem 1 uses SSItem and SSItemChanges1
-- Problem 2 uses SSItem and SSItemChanges2

-- Drop tables if exist
DROP TABLE SSItem;
DROP TABLE SSItemChanges1;
DROP TABLE SSItemChanges2;

CREATE TABLE SSItem
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30) NOT NULL,
	ItemBrand	VARCHAR(30) NOT NULL,
   	ItemCategory	VARCHAR(30) NOT NULL,
  	ItemUnitPrice	DECIMAL(12,2) NOT NULL,
CONSTRAINT PKSSItem PRIMARY KEY (ItemId) );

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','17 inch Color Monitor','ColorMeg, Inc.','Electronics', 169.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 319.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Connex','Printing', 699.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1412138','10 Foot Printer Cable','Ethlite','Computer Accessories', 12.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1445671','8-Outlet Surge Protector','Intersafe','Computer Accessories', 14.99);

insert into SSItem
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1556678','CVP Ink Jet Color Printer','Connex','Printing', 99.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I3455443','Color Ink Jet Cartridge','Connex','Printing', 38.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I4201044','36-Bit Color Scanner','UV Components','Scanning', 199.99);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 25.69);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Battery Back-up System','Cybercx','Computer Accessories', 89.00);

SELECT COUNT(*) FROM SSItem;  
-- should be 10

-- Commit not necessary if auto commit set
COMMIT;

CREATE TABLE SSItemChanges1
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItemChanges1 PRIMARY KEY (ItemId) );

-- new price and item name
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','21 inch Color Monitor','ColorMeg, Inc.','Electronics', 159.00);

-- new price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 329.00);

-- new company
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Conner','Printing', 699.00);

-- New price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 35.69);

-- new item name and price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Rapid Battery Back-up System','Cybercx','Computer Accessories', 129.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I5555555','10 Foot HDMI Cable','Ethlite','Cables', 12.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6666666','2-1 Laptop','Lenova','Computers', 499.99);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I7777777','Solid Ink Color Printer','HT','Printing', 129.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I8888888','Color Ink Jet Cartridge','Xerock','Printing', 38.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9999999','LED Color Printer','HT','Printing', 299.99);

-- List number of SSItemChanges1 rows. Should be 10.
SELECT COUNT(*) FROM SSItemChanges1;

-- Commit not necessary if auto commit set
COMMIT;

-- New table required for problem 2
-- Existing item changes have null values except for PK and changed columnes
-- New table required for problem 14.5
-- Existing item changes have null values except for PK and changed columnes
CREATE TABLE SSItemChanges2
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItemChanges2 PRIMARY KEY (ItemId) );

-- new price and item name
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','21 inch Color Monitor',NULL,NULL, 159.00);

-- new price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577',NULL,NULL,NULL, 329.00);

-- new company
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590',NULL,'Conner',NULL, NULL);

-- New price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900',NULL,NULL,NULL, 35.69);

-- new item name and price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Rapid Battery Back-up System',NULL,NULL, 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I5555555','10 Foot HDMI Cable','Ethlite','Cables', 12.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6666666','2-1 Laptop','Lenova','Computers', 499.99);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I7777777','Solid Ink Color Printer','HT','Printing', 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I8888888','Color Ink Jet Cartridge','Xerock','Printing', 38.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9999999','LED Color Printer','HT','Printing', 299.99);

-- List number of SSItemChanges2 rows. Should be 10.
SELECT COUNT(*) FROM SSItemChanges2;

-- commit changes in both tables
COMMIT;

-- Tables in problems 3 and 4.

-- Drop tables in multiple table INSERT problems

DROP TABLE YEAR_LOW_SALES;
DROP TABLE YEAR_MID_SALES;
DROP TABLE YEAR_HIGH_SALES;

DROP TABLE ProductSales2018;
DROP TABLE ProductSales2019;
DROP TABLE ProductSales2020;
DROP TABLE ProductSales2021;
DROP TABLE ProductSale1;
DROP TABLE ProductSale2;

-- Create table statements for multiple table INSERT statement problems
-- Annual sales for vertical partitioning 

-- Create Product Sale table

CREATE TABLE ProductSale1
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  SalesYear       INTEGER,
  SalesAmt        INTEGER );

-- Insert records into ProductSale table
INSERT INTO ProductSale1 VALUES ( 101, 'Television', 'Electronics', 2018, 500);
INSERT INTO ProductSale1 VALUES ( 102, 'Laptop', 'Electronics', 2018, 400);
INSERT INTO ProductSale1 VALUES ( 103, 'Mobile', 'Electronics', 2019,56473);
INSERT INTO ProductSale1 VALUES ( 104, 'Fiction', 'Books', 2019,4000);
INSERT INTO ProductSale1 VALUES ( 105, 'Literature', 'Books', 2020,760);
INSERT INTO ProductSale1 VALUES ( 106, 'Horror', 'Movies', 2020,3000);
INSERT INTO ProductSale1 VALUES ( 107, 'Action', 'Movies', 2021,5000);
INSERT INTO ProductSale1 VALUES ( 108, 'Thriller', 'Movies', 2021,50);
INSERT INTO ProductSale1 VALUES ( 109, 'Family Drama', 'Movies', 2021,300);

commit;

-- Creating tables for INSERT ALL (unconditional)
-- Create Sales2018 table

CREATE TABLE ProductSales2018
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  SalesAmt        INTEGER );

-- Create ProductSales2019 table 
CREATE TABLE ProductSales2019
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  SalesAmt        INTEGER );

-- Create ProductSales2020 table
CREATE TABLE ProductSales2020
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  SalesAmt        INTEGER );

-- Create ProductSales2021 table
CREATE TABLE ProductSales2021
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  SalesAmt        INTEGER );


-- Tables for problems 5 and 6
CREATE TABLE ProductSale2
( Product_ID      INTEGER NOT NULL,
  ProductName     VARCHAR(50),
  ProductCategory VARCHAR(50),
  Qtr1            INTEGER,
  Qtr2            INTEGER,
  Qtr3            INTEGER,
  Qtr4            INTEGER );

-- Insert records into ProductSale2 table
INSERT INTO ProductSale2 VALUES ( 101, 'Television', 'Electronics', 500,4000,200,3000);
INSERT INTO ProductSale2 VALUES ( 102, 'Laptop', 'Electronics', 400,7000,34,567);
INSERT INTO ProductSale2 VALUES ( 103, 'Mobile', 'Electronics', 879,56473,44,100);
INSERT INTO ProductSale2 VALUES ( 104, 'Fiction', 'Books', 500,4000,444,235);
INSERT INTO ProductSale2 VALUES ( 105, 'Literature', 'Books', 8000,760,500,200);
INSERT INTO ProductSale2 VALUES ( 106, 'Horror', 'Movies', 400,3000,200,245);
INSERT INTO ProductSale2 VALUES ( 107, 'Action', 'Movies', 350,5000,489,2000);
INSERT INTO ProductSale2 VALUES ( 108, 'Thriller', 'Movies', 3090,50,300,450);
INSERT INTO ProductSale2 VALUES ( 109, 'Family Drama', 'Movies', 6000,300,450,200);

-- Create YEAR_LOW_SALES table
CREATE TABLE YEAR_LOW_SALES
( Product_ID  INTEGER NOT NULL,
  ProductName VARCHAR(50),
  TotalSales  INTEGER );

-- Create YEAR_MID_SALES table
CREATE TABLE YEAR_MID_SALES
( Product_ID  INTEGER NOT NULL,
  ProductName VARCHAR(50),
  TotalSales  INTEGER );

-- Create YEAR_HIGH_SALES table
CREATE TABLE YEAR_HIGH_SALES 
( Product_ID  INTEGER NOT NULL,
  ProductName VARCHAR(50),
  TotalSales  INTEGER );

-- Tables for problem 7

CREATE TABLE Mobile_Bill 
( CustID     INTEGER NOT NULL, 
  CurrentAmt DECIMAL(10,2), 
  PastAmt    DECIMAL(10,2),
  CONSTRAINT MBCustId PRIMARY KEY (CustId) );

-- Insert a few existing billing records for old customers.
INSERT INTO Mobile_Bill VALUES (1,0,29.95);
INSERT INTO Mobile_Bill VALUES (2,0,43.50);
INSERT INTO Mobile_Bill VALUES (3,0,99.45);
INSERT INTO Mobile_Bill VALUES (4,0,123.45);
INSERT INTO Mobile_Bill VALUES (5,0,43.50);
INSERT INTO Mobile_Bill VALUES (6,0,29.95);
INSERT INTO Mobile_Bill VALUES (7,0,23.45);
INSERT INTO Mobile_Bill VALUES (8,0,12.34);
INSERT INTO Mobile_Bill VALUES (9,0,29.95);
INSERT INTO Mobile_Bill VALUES (10,0,344.56);

CREATE TABLE Mobile_Usage 
( CustID      INTEGER NOT NULL, 
  MinutesUsed INTEGER  );

INSERT INTO Mobile_Usage VALUES (1,1000);
INSERT INTO Mobile_Usage VALUES (2,1500);
INSERT INTO Mobile_Usage VALUES (3,2000);
INSERT INTO Mobile_Usage VALUES (4,2500);
INSERT INTO Mobile_Usage VALUES (5,1500);
INSERT INTO Mobile_Usage VALUES (6,1000);
INSERT INTO Mobile_Usage VALUES (7,2000);
INSERT INTO Mobile_Usage VALUES (8,2500);
INSERT INTO Mobile_Usage VALUES (9,3000);
INSERT INTO Mobile_Usage VALUES (10,4000);
INSERT INTO Mobile_Usage VALUES (11,5000);
INSERT INTO Mobile_Usage VALUES (12,2000);
INSERT INTO Mobile_Usage VALUES (13,1000);
INSERT INTO Mobile_Usage VALUES (14,2500);
INSERT INTO Mobile_Usage VALUES (15,2500);
INSERT INTO Mobile_Usage VALUES (16,1500);
INSERT INTO Mobile_Usage VALUES (17,1500);
INSERT INTO Mobile_Usage VALUES (18,2000);
INSERT INTO Mobile_Usage VALUES (19,1000);
INSERT INTO Mobile_Usage VALUES (20,2000);
INSERT INTO Mobile_Usage VALUES (21,1500);
INSERT INTO Mobile_Usage VALUES (22,1500);
INSERT INTO Mobile_Usage VALUES (23,2000);
INSERT INTO Mobile_Usage VALUES (24,1000);
INSERT INTO Mobile_Usage VALUES (25,2000);

commit;

-- Tables for problem 8 and 9
CREATE TABLE Mobile_Customer 
( CustID     INTEGER   NOT NULL, 
  CustName   VARCHAR(50) NOT NULL, 
  CustState  VARCHAR(2)  NOT NULL, 
  CustType   VARCHAR(15) NOT NULL,
  CustAge    INTEGER,
  CurrentAmt DECIMAL(10,2),
  CONSTRAINT PK_CustID PRIMARY KEY (CustID) );

INSERT INTO Mobile_Customer VALUES (1,'Mike','CO','Consumer',45, 39.95);
INSERT INTO Mobile_Customer VALUES (2,'Jeff','CO','Business',32, 145.56);
INSERT INTO Mobile_Customer VALUES (3,'Mary','CO','Consumer',43, 110.32);
INSERT INTO Mobile_Customer VALUES (4,'Michael','CO','Business',56, 246.78);
INSERT INTO Mobile_Customer VALUES (5,'Anna','CO','Consumer',42, 55.27);
INSERT INTO Mobile_Customer VALUES (6,'Jane','CO','Business',46, 157.88);
INSERT INTO Mobile_Customer VALUES (7,'Gwen','TX','Consumer',21, 25.99);
INSERT INTO Mobile_Customer VALUES (8,'James','TX','Business',23, 178.37);
INSERT INTO Mobile_Customer VALUES (9,'Nathan','TX','Consumer',21, 69.45);
INSERT INTO Mobile_Customer VALUES (10,'Carolyn','TX','Business',20, 115.25);
INSERT INTO Mobile_Customer VALUES (11,'Jake','TX','Consumer',35, 42.89);
INSERT INTO Mobile_Customer VALUES (12,'Diann','TX','Business',37, 195.60);
INSERT INTO Mobile_Customer VALUES (13,'Kevin','TX','Consumer',38, 105.69);
INSERT INTO Mobile_Customer VALUES (14,'Emma','CA','Business',32, 389.99);
INSERT INTO Mobile_Customer VALUES (15,'Rusty','CA','Consumer',31, 35.45);
INSERT INTO Mobile_Customer VALUES (16,'Yongsoo','CA','Business',35, 117.81);
INSERT INTO Mobile_Customer VALUES (17,'Donghee','CA','Consumer',56, 45.00);
INSERT INTO Mobile_Customer VALUES (18,'Soosun','CA','Business',44, 155.21);
INSERT INTO Mobile_Customer VALUES (19,'Andy','CA','Consumer',14, 47.11);
INSERT INTO Mobile_Customer VALUES (24,'Lou','CA','Business',12, 89.32);
INSERT INTO Mobile_Customer VALUES (20,'Anne','CA','Consumer',34, 29.10);
INSERT INTO Mobile_Customer VALUES (21,'Ryan','WA','Business',34, 135.19);
INSERT INTO Mobile_Customer VALUES (22,'Bob','WA','Consumer',33, 46.07);
INSERT INTO Mobile_Customer VALUES (23,'Jay','WA','Business',33, 195.10);
INSERT INTO Mobile_Customer VALUES (25,'Josh','WA','Consumer',31, 33.05);

-- Should show 25 customers
SELECT COUNT(*) FROM Mobile_Customer;

Commit;

-- Create three summary tables for customers at three different levels: gold, silver, and bronze.        
CREATE TABLE Mobile_Gold 
( CustID     INTEGER    NOT NULL, 
  CustName   VARCHAR(50)  NOT NULL, 
  CustState  VARCHAR(2)   NOT NULL, 
  CustType   VARCHAR(15)  NOT NULL,
  CurrentAmt DECIMAL(10,2) NOT NULL );    

CREATE TABLE Mobile_Silver 
( CustID     INTEGER    NOT NULL, 
  CustName   VARCHAR(50)  NOT NULL, 
  CustState  VARCHAR(2)   NOT NULL, 
  CustType   VARCHAR(15)  NOT NULL,
  CurrentAmt DECIMAL(10,2) NOT NULL );    

CREATE TABLE Mobile_Bronze 
( CustID     INTEGER    NOT NULL, 
  CustName   VARCHAR(50)  NOT NULL, 
  CustState  VARCHAR(2)   NOT NULL, 
  CustType   VARCHAR(15)  NOT NULL,
  CurrentAmt DECIMAL(10,2) NOT NULL );

-- Problem 10 tables: SSItem with NOT NULL constraints and SSItemChanges1
DROP TABLE IF EXISTS SSItem;
DROP TABLE IF EXISTS SSItemChanges1;

CREATE TABLE SSItem
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30) NOT NULL,
	ItemBrand	VARCHAR(30) NOT NULL,
   	ItemCategory	VARCHAR(30) NOT NULL,
  	ItemUnitPrice	DECIMAL(12,2) NOT NULL,
CONSTRAINT PKSSItem PRIMARY KEY (ItemId) );

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','17 inch Color Monitor','ColorMeg, Inc.','Electronics', 169.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 319.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Connex','Printing', 699.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1412138','10 Foot Printer Cable','Ethlite','Computer Accessories', 12.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1445671','8-Outlet Surge Protector','Intersafe','Computer Accessories', 14.99);

insert into SSItem
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1556678','CVP Ink Jet Color Printer','Connex','Printing', 99.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I3455443','Color Ink Jet Cartridge','Connex','Printing', 38.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I4201044','36-Bit Color Scanner','UV Components','Scanning', 199.99);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 25.69);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Battery Back-up System','Cybercx','Computer Accessories', 89.00);

SELECT COUNT(*) FROM SSItem;  
-- should be 10

-- Commit not necessary in PostgreSQL if auto commit is set
Commit;

CREATE TABLE SSItemChanges1
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItemChanges1 PRIMARY KEY (ItemId) );

-- new price and item name
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','21 inch Color Monitor','ColorMeg, Inc.','Electronics', 159.00);

-- new price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 329.00);

-- new company
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Conner','Printing', 699.00);

-- New price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 35.69);

-- new item name and price
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Rapid Battery Back-up System','Cybercx','Computer Accessories', 129.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I5555555','10 Foot HDMI Cable','Ethlite','Cables', 12.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6666666','2-1 Laptop','Lenova','Computers', 499.99);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I7777777','Solid Ink Color Printer','HT','Printing', 129.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I8888888','Color Ink Jet Cartridge','Xerock','Printing', 38.00);

-- new item
insert into SSItemChanges1 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9999999','LED Color Printer','HT','Printing', 299.99);

-- List number of SSItemChanges1 rows. Should be 10.
SELECT COUNT(*) FROM SSItemChanges1;

-- Commit not necessary in PostgreSQL if auto commit is set
Commit;

-- Problem 11 tables: SSItem with no NOT NULL constraints and SSItemChanges2

DROP TABLE IF EXISTS SSItem;
DROP TABLE IF EXISTS SSItemChanges1;
DROP TABLE IF EXISTS SSItemChanges2;

CREATE TABLE SSItem
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItem PRIMARY KEY (ItemId) );

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','17 inch Color Monitor','ColorMeg, Inc.','Electronics', 169.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 319.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Connex','Printing', 699.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1412138','10 Foot Printer Cable','Ethlite','Computer Accessories', 12.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1445671','8-Outlet Surge Protector','Intersafe','Computer Accessories', 14.99);

insert into SSItem
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1556678','CVP Ink Jet Color Printer','Connex','Printing', 99.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I3455443','Color Ink Jet Cartridge','Connex','Printing', 38.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I4201044','36-Bit Color Scanner','UV Components','Scanning', 199.99);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 25.69);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Battery Back-up System','Cybercx','Computer Accessories', 89.00);

SELECT COUNT(*) FROM SSItem;  
-- should be 10

-- Commit not necessary in PostgreSQL if auto commit is set
-- Commit;

CREATE TABLE SSItemChanges2
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItemChanges2 PRIMARY KEY (ItemId) );

-- new price and item name
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','21 inch Color Monitor',NULL,NULL, 159.00);

-- new price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577',NULL,NULL,NULL, 329.00);

-- new company
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590',NULL,'Conner',NULL, NULL);

-- New price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900',NULL,NULL,NULL, 35.69);

-- new item name and price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Rapid Battery Back-up System',NULL,NULL, 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I5555555','10 Foot HDMI Cable','Ethlite','Cables', 12.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6666666','2-1 Laptop','Lenova','Computers', 499.99);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I7777777','Solid Ink Color Printer','HT','Printing', 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I8888888','Color Ink Jet Cartridge','Xerock','Printing', 38.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9999999','LED Color Printer','HT','Printing', 299.99);

-- List number of SSItemChanges2 rows. Should be 10.
SELECT COUNT(*) FROM SSItemChanges2;

-- Commit not necessary in PostgreSQL if auto commit is set
Commit;

-- Problem 12 uses SSItem (NOT NULL constraints) and  SSItemChanges2

-- Drop tables if exist
DROP TABLE IF EXISTS SSItem;
DROP TABLE IF EXISTS SSItemChanges2;

CREATE TABLE SSItem
( 	ItemId 	   	CHAR(8),
  	ItemName	VARCHAR(30) NOT NULL,
	ItemBrand	VARCHAR(30) NOT NULL,
   	ItemCategory	VARCHAR(30) NOT NULL,
  	ItemUnitPrice	DECIMAL(12,2) NOT NULL,
CONSTRAINT PKSSItem PRIMARY KEY (ItemId) );

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','17 inch Color Monitor','ColorMeg, Inc.','Electronics', 169.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','19 inch Color Monitor','ColorMeg, Inc.','Electronics', 319.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','R3000 Color Laser Printer','Connex','Printing', 699.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1412138','10 Foot Printer Cable','Ethlite','Computer Accessories', 12.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1445671','8-Outlet Surge Protector','Intersafe','Computer Accessories', 14.99);

insert into SSItem
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1556678','CVP Ink Jet Color Printer','Connex','Printing', 99.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I3455443','Color Ink Jet Cartridge','Connex','Printing', 38.00);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I4201044','36-Bit Color Scanner','UV Components','Scanning', 199.99);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','Black Ink Jet Cartridge','Connex','Printing', 25.69);

insert into SSItem 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Battery Back-up System','Cybercx','Computer Accessories', 89.00);

SELECT COUNT(*) FROM SSItem;  
-- should be 10

-- Commit not necessary in PostgreSQL if auto commit set
-- COMMIT;

CREATE TABLE SSItemChanges2
( 	ItemId 	   	CHAR(8) NOT NULL,
  	ItemName	VARCHAR(30),
	ItemBrand	VARCHAR(30),
   	ItemCategory	VARCHAR(30),
  	ItemUnitPrice	DECIMAL(12,2),
CONSTRAINT PKSSItemChanges2 PRIMARY KEY (ItemId) );

-- Revised INSERT statements for problem 12
-- 'NV' instead of NULL values for text columns
-- 0 instead of NULL values for numeric column
-- new price and item name
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036566','21 inch Color Monitor','NV','NV', 159.00);

-- new price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I0036577','NV','NV','NV', 329.00);

-- new company
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I1114590','NV','Conner','NV', 0);

-- New price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6677900','NV','NV','NV', 35.69);

-- new item name and price
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9995676','Rapid Battery Back-up System','NV','NV', 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I5555555','10 Foot HDMI Cable','Ethlite','Cables', 12.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I6666666','2-1 Laptop','Lenova','Computers', 499.99);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I7777777','Solid Ink Color Printer','HT','Printing', 129.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I8888888','Color Ink Jet Cartridge','Xerock','Printing', 38.00);

-- new item
insert into SSItemChanges2 
(ItemId, ItemName, ItemBrand, ItemCategory, ItemUnitPrice)
values ('I9999999','LED Color Printer','HT','Printing', 299.99);