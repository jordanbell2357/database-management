-- Module 4 examples for the MERGE and INSERT ALL statements for Oracle only
-- PostgreSQL does not support the MERGE and multiple table INSERT statements.
-- INSERT WITH CONFLICT work with PostgreSQL only

-- The first set of examples require the SSCustomer table.
-- The CREATE TABLE and INSERT statements are provided here for your convenience.

CREATE TABLE SSCustomer
( 	CustId 	        CHAR(8) NOT NULL,
  	CustName	VARCHAR2(30) NOT NULL,
        CustPhone    	VARCHAR2(15) NOT NULL,
	CustStreet	VARCHAR2(50) NOT NULL,
	CustCity	VARCHAR2(30) NOT NULL,
   	CustState	VARCHAR2(20) NOT NULL,
   	CustZip		VARCHAR2(10) NOT NULL,
	CustNation	VARCHAR2(20) NOT NULL,
 CONSTRAINT PKSSCustomer PRIMARY KEY (CustId)  );

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C0954327','Sheri Gordon', '(303)123-1234','336 Hill St.','Littleton','CO','80129-5543','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C1010398','Jim Glussman','(303)321-9876','1432 E. Ravenna','Denver','CO','80111-0033','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C2388597','Beth Taylor','(206)124-9876','2396 Rafter Rd','Seattle','WA','98103-1121','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C3340959','Betty Wise','(206)421-1276','4334 153rd NW','Seattle','WA','98178-3311','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8543321','Ron Thompson','(206)891-7664','789 122nd St.','Renton','WA','98666-1289','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8574932','Wally Jones','(206)391-8564','411 Webber Ave.','Seattle','WA','98105-1093','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8654390','Candy Kendall','(206)561-2264','456 Pine St.','Seattle','WA','98105-3345','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9128574','Jerry Wyatt','(303)821-1234','16212 123rd Ct.','Denver','CO','80222-0022','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9403348','Mike Boren','(303)821-5688','642 Crest Ave.','Englewood','CO','80113-5431','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9432910','Larry Styles','(406)921-7688','9825 S. Crest Lane','Vancouver','BC','98104-2211','Canada');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9543029','Sharon Johnson','(406)921-4468','1223 Meyer Way','Surrey','BC','98222-1123','Canada');

SELECT COUNT(*) FROM SSCustomer;
-- should be 11

-- Create table statement for the first MERGE statement example
-- Non key columns are not required so that only changes are recorded.

CREATE TABLE SSCustomerChanges( 	CustId 	        CHAR(8),
  	CustName	VARCHAR2(30),
        CustPhone    	VARCHAR2(15),
	CustStreet	VARCHAR2(50),
	CustCity	VARCHAR2(30),
   	CustState	VARCHAR2(20),
   	CustZip		VARCHAR2(10),
	CustNation	VARCHAR2(20), CONSTRAINT PKSSCustomerChanges PRIMARY KEY (CustId)  );

-- Change to street and zip code
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C0954327','Sheri Gordon', '(303)123-1234','444 Jump Ave.','Littleton','CO','80128-5443','USA');
-- Change to phone
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C1010398','Jim Glussman','(303)257-4186','1432 E. Ravenna','Denver','CO','80111-0033','USA');
-- Change to name
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C2388597','Beth Taylor-Hines','(206)124-9876','2396 Rafter Rd','Seattle','WA','98103-1121','USA');
-- New customer
insert into SSCustomerChanges
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C8888888','William Wise','(303)421-1276','4334 Alameda Pkwy','Denver','CO','80210-3311','USA');
-- New customer
insert into SSCustomerChanges
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C9999999','Toan Lee','(303)555-1111','7504 Dry Creek Road','Centennial','CO','80112-3311','USA');

-- List SSCustomer rows before MERGE
SELECT * FROM SSCustomer;

-- Example 1 associated with slide 5
-- MERGE statement
-- Insert not matched into SSCustomer
-- Update columns from SSCustomerChanges to corresponding columns in SSCustomer

MERGE INTO SSCustomer Target
USING SSCustomerChanges Source
ON (Target.CustId = Source.CustId)

WHEN MATCHED THEN
UPDATE SET
 Target.CustName = Source.CustName,
 Target.CustPhone = Source.CustPhone,
 Target.CustStreet = Source.CustStreet,
 Target.CustCity = Source.CustCity,
 Target.CustState = Source.CustState,
 Target.CustZip = Source.CustZip,
 Target.CustNation = Source.CustNation

WHEN NOT MATCHED THEN
INSERT (Target.CustId, Target.CustName, Target.CustPhone, Target.CustStreet, Target.CustCity, 
        Target.CustState, Target.CustZip, Target.CustNation)
VALUES (Source.CustId, Source.CustName, Source.CustPhone, Source.CustStreet, Source.CustCity, 
        Source.CustState, Source.CustZip, Source.CustNation);

-- List SSCustomer rows after MERGE
SELECT * FROM SSCustomer;
Rollback;

-- Change table for MERGE example 2
-- Does not have an associated slide

CREATE TABLE SSCustomerChanges2
( 	CustId 	        CHAR(8),
  	CustName	VARCHAR2(30),
        CustPhone    	VARCHAR2(15),
	CustStreet	VARCHAR2(50),
	CustCity	VARCHAR2(30),
   	CustState	VARCHAR2(20),
   	CustZip		VARCHAR2(10),
	CustNation	VARCHAR2(20),
 CONSTRAINT PKSSCustomerChanges2 PRIMARY KEY (CustId)  );

-- Rows for example 2
-- Changed rows only have values for PK and changed columns
-- Change to street and zip code so only values for CustId, CustStreet and CustZip
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C0954327',NULL,NULL,'444 Jump Ave.',NULL ,NULL,'80128-5443',NULL);
-- Change to phone so only values for CustId and CustPhone
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C1010398', NULL,'(303)257-4186', NULL, NULL, NULL, NULL, NULL);
-- Change to name so only values for CustId and CustName columns
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C2388597','Beth Taylor-Hines', NULL, NULL, NULL, NULL, NULL, NULL);
-- New customer so values for all columns
insert into SSCustomerChanges2
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C8888888','William Wise','(303)421-1276','4334 Alameda Pkwy','Denver','CO','80210-3311','USA');
-- New customer so values for all columns
insert into SSCustomerChanges2
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)values ('C9999999','Toan Lee','(303)555-1111','7504 Dry Creek Road','Centennial','CO','80112-3311','USA');

-- List SSCustomer rows before MERGE
SELECT * FROM SSCustomer;

-- Example 2
-- Not shown in slides
-- MERGE statement
-- Insert not matched into SSCustomer
-- Update non null columns from SSCustomerChanges to corresponding columns in SSCustomer
-- Syntax only allows one MATCHED clause. Use DECODE function to substitute non null source values.
-- DECODE(Source.CustName, NULL, Target.CustName, Source.CustName): if Source.CustName is NULL use Target, else Source

MERGE INTO SSCustomer Target
USING SSCustomerChanges2 Source
ON (Target.CustId = Source.CustId)

WHEN MATCHED THEN
UPDATE SET 
  Target.CustName = DECODE(Source.CustName, NULL, Target.CustName, Source.CustName), 
  Target.CustPhone = DECODE(Source.CustPhone, NULL, Target.CustPhone, Source.CustPhone), 
  Target.CustStreet = DECODE(Source.CustStreet, NULL, Target.CustStreet, Source.CustStreet), 
  Target.CustCity = DECODE(Source.CustCity, NULL, Target.CustCity, Source.CustCity), 
  Target.CustState = DECODE(Source.CustState, NULL, Target.CustState, Source.CustState), 
  Target.CustZip = DECODE(Source.CustZip, NULL, Target.CustZip, Source.CustZip), 
  Target.CustNation = DECODE(Source.CustNation, NULL, Target.CustNation, Source.CustNation) 

WHEN NOT MATCHED THEN
INSERT (Target.CustId, Target.CustName, Target.CustPhone, Target.CustStreet, Target.CustCity, 
        Target.CustState, Target.CustZip, Target.CustNation)
VALUES (Source.CustId, Source.CustName, Source.CustPhone, Source.CustStreet, Source.CustCity, 
        Source.CustState, Source.CustZip, Source.CustNation);


-- List SSCustomer rows after MERGE
SELECT * FROM SSCustomer;
Rollback;

DROP TABLE SSCustomerChanges;
DROP TABLE SSCustomerChanges2;

-- Multiple table INSERT examples

-- Create Product Sale table

Create table ProductSale
( Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
Qtr1 int,
Qtr2 int,
Qtr3 int,
Qtr4 int
);

-- Insert records into ProductSales table
INSERT INTO ProductSale VALUES ( 101, 'Television', 'Electronics', 500,4000,200,3000);
INSERT INTO ProductSale VALUES ( 102, 'Laptop', 'Electronics', 400,7000,34,567);
INSERT INTO ProductSale VALUES ( 103, 'Mobile', 'Electronics', 879,56473,44,100);
INSERT INTO ProductSale VALUES ( 104, 'Fiction', 'Books', 500,4000,444,235);
INSERT INTO ProductSale VALUES ( 105, 'Literature', 'Books', 8000,760,500,200);
INSERT INTO ProductSale VALUES ( 106, 'Horror', 'Movies', 400,3000,200,245);
INSERT INTO ProductSale VALUES ( 107, 'Action', 'Movies', 350,5000,489,2000);
INSERT INTO ProductSale VALUES ( 108, 'Thriller', 'Movies', 3090,50,300,450);
INSERT INTO ProductSale VALUES ( 109, 'Family Drama', 'Movies', 6000,300,450,200);


-- Creating tables for INSERT ALL (unconditional)
-- Create QTR1Sale table

Create table QTR1Sale
(
Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
Qtr1 int
);
-- Create QTR2Sale table 
Create table Qtr2Sale
(
Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
Qtr2 int
);

-- Create QTR3Sale table
Create table Qtr3Sale
(
Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
Qtr3 int
);
-- Create QTR4Sale table
Create table Qtr4Sale
(
Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
Qtr4 int
);

-- Corresponds to slide 8
-- INSERT ALL (unconditional)
INSERT ALL
INTO QTR1Sale VALUES (Product_ID,ProductName,ProductCategory,Qtr1 )
INTO QTR2Sale VALUES (Product_ID,ProductName,ProductCategory,Qtr2 )
INTO QTR3Sale VALUES (Product_ID,ProductName,ProductCategory,Qtr3 )
INTO QTR4Sale VALUES (Product_ID,ProductName,ProductCategory,Qtr4 )

SELECT * FROM ProductSale;

-- Checking records in all tablesSelect * from QTR1Sale;
Select * from QTR1Sale;
Select * from QTR2Sale;
Select * from QTR3Sale;
Select * from QTR4Sale; 


-- Creating tables for Conditional Insert ALL
-- Create ElectronicsSale table
Create table ElectronicsSale
(Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
TotalSales int);

-- Create BooksSale table
Create table BooksSale
(Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
TotalSales int);

-- Create MoviesSale table
Create table MoviesSale
(Product_ID int not null,
ProductName varchar2(50),
ProductCategory varchar2(50),
TotalSales int);

-- Conditional Insert FIRST
-- Corresponds to slide 9

INSERT FIRST
WHEN (ProductCategory = 'Electronics') THEN
INTO ElectronicsSale VALUES (Product_ID,ProductName,ProductCategory,(Qtr1+Qtr2+Qtr3+Qtr4) )
WHEN (ProductCategory = 'Movies') THEN
INTO MoviesSale VALUES (Product_ID,ProductName,ProductCategory,(Qtr1+Qtr2+Qtr3+Qtr4) )
WHEN (ProductCategory = 'Books') THEN
INTO BooksSale VALUES (Product_ID,ProductName,ProductCategory,(Qtr1+Qtr2+Qtr3+Qtr4) )

SELECT * FROM ProductSale;

-- Checking records in all tables
Select * from ElectronicsSale;
Select * from MoviesSale;
Select * from BooksSale;

-- Creating tables for Conditional Insert FIRST
-- Not shown in slides
-- Create YEAR_LOW_SALES table
Create table YEAR_LOW_SALES
(Product_ID int not null,
ProductName varchar2(50),
TotalSales int);

-- Create YEAR_MID_SALES table
Create table YEAR_MID_SALES
(Product_ID int not null,
ProductName varchar2(50),
TotalSales int);

-- Create YEAR_HIGH_SALES table
Create table YEAR_HIGH_SALES 
(Product_ID int not null,
ProductName varchar2(50),
TotalSales int);

-- Conditional Insert FIRST
-- Not shown in slides

INSERT FIRST
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 < 4000) THEN
INTO YEAR_LOW_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
WHEN (Qtr1+Qtr2+Qtr3+Qtr4 > 4000 and Qtr1+Qtr2+Qtr3+Qtr4 <= 7000) THEN
INTO YEAR_MID_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )
ELSE
INTO YEAR_HIGH_SALES VALUES (Product_ID, ProductName, Qtr1+Qtr2+Qtr3+Qtr4 )

SELECT Product_ID, ProductName, Qtr1, Qtr2, Qtr3, Qtr4 FROM PRODUCTSALE;

-- Checking records in all tables
select * from YEAR_HIGH_SALES;
select * from YEAR_MID_SALES;
select * from YEAR_LOW_SALES;

Drop table QTR1Sale;
Drop table Qtr2Sale;
Drop table Qtr3Sale;
Drop table Qtr4Sale;

Drop table ElectronicsSale;
Drop table BooksSale;
Drop table MoviesSale;

DROP TABLE YEAR_LOW_SALES;
DROP TABLE YEAR_MID_SALES;
DROP TABLE YEAR_HIGH_SALES;

Drop table ProductSale;

-- Create tables for PostgreSQL example used in slide 11
-- Drop tables if exist
DROP TABLE SSCustomer;
DROP TABLE SSCustomerChanges;

CREATE TABLE SSCustomer

( 	CustId 	        CHAR(8)     NOT NULL,
  	CustName	VARCHAR(30) NOT NULL,
        CustPhone    	VARCHAR(15) NOT NULL,
	CustStreet	VARCHAR(50) NOT NULL,
	CustCity	VARCHAR(30) NOT NULL,
   	CustState	VARCHAR(20) NOT NULL,
   	CustZip		VARCHAR(10) NOT NULL,
	CustNation	VARCHAR(20) NOT NULL,
 CONSTRAINT PKSSCustomer PRIMARY KEY (CustId)  );

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C0954327','Sheri Gordon', '(303)123-1234','336 Hill St.','Littleton','CO','80129-5543','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C1010398','Jim Glussman','(303)321-9876','1432 E. Ravenna','Denver','CO','80111-0033','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C2388597','Beth Taylor','(206)124-9876','2396 Rafter Rd','Seattle','WA','98103-1121','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C3340959','Betty Wise','(206)421-1276','4334 153rd NW','Seattle','WA','98178-3311','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8543321','Ron Thompson','(206)891-7664','789 122nd St.','Renton','WA','98666-1289','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8574932','Wally Jones','(206)391-8564','411 Webber Ave.','Seattle','WA','98105-1093','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8654390','Candy Kendall','(206)561-2264','456 Pine St.','Seattle','WA','98105-3345','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9128574','Jerry Wyatt','(303)821-1234','16212 123rd Ct.','Denver','CO','80222-0022','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9403348','Mike Boren','(303)821-5688','642 Crest Ave.','Englewood','CO','80113-5431','USA');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9432910','Larry Styles','(406)921-7688','9825 S. Crest Lane','Vancouver','BC','98104-2211','Canada');

insert into SSCustomer 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9543029','Sharon Johnson','(406)921-4468','1223 Meyer Way','Surrey','BC','98222-1123','Canada');

SELECT COUNT(*) FROM SSCustomer;  
-- should be 11

CREATE TABLE SSCustomerChanges
( 	CustId 	        CHAR(8),
  	CustName	VARCHAR(30),
        CustPhone    	VARCHAR(15),
	CustStreet	VARCHAR(50),
	CustCity	VARCHAR(30),
   	CustState	VARCHAR(20),
   	CustZip		VARCHAR(10),
	CustNation	VARCHAR(20),
 CONSTRAINT PKSSCustomerChanges PRIMARY KEY (CustId)  );

-- Insert statements for SSCustomerChanges
-- Change to street
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C0954327','Sheri Gordon', '(303)123-1234','444 Jump Ave.','Littleton','CO','80128-5443','USA');

-- Change to phone
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C1010398','Jim Glussman','(303)257-4186','1432 E. Ravenna','Denver','CO','80111-0033','USA');

-- Change to name
insert into SSCustomerChanges 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C2388597','Beth Taylor-Hines','(206)124-9876','2396 Rafter Rd','Seattle','WA','98103-1121','USA');

-- New customer
insert into SSCustomerChanges
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8888888','William Wise','(303)421-1276','4334 Alameda Pkwy','Denver','CO','80210-3311','USA');

-- New customer
insert into SSCustomerChanges
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9999999','Toan Lee','(303)555-1111','7504 Dry Creek Road','Centennial','CO','80112-3311','USA');

SELECT COUNT(*) FROM SSCustomerChanges;
-- should be 5

-- Example used in slide 11

INSERT INTO SSCustomer 
 ( CustId, CustName, CustPhone, CustStreet, CustCity, CustState,
   CustZip, CustNation ) 
   SELECT Change.CustId, Change.CustName, Change.CustPhone, 
          Change.CustStreet, Change.CustCity,  
          Change.CustState, Change.CustZip, Change.CustNation
     FROM 
	  ( SELECT CustId, CustName, CustPhone, CustStreet, CustCity,  
               CustState, CustZip, CustNation 
	    FROM SSCustomerChanges ) Change
 ON CONFLICT (CustId )
 DO UPDATE SET
   CustName = EXCLUDED.CustName,
   CustPhone = EXCLUDED.CustPhone,
   CustStreet = EXCLUDED.CustStreet,
   CustCity = EXCLUDED.CustCity,
   CustState = EXCLUDED.CustState,
   CustZip = EXCLUDED.CustZip,
   CustNation = EXCLUDED.CustNation;

SELECT COUNT(*) FROM SSCustomer;
SELECT * FROM SSCustomer;

-- Only need rollback if auto commit set
ROLLBACK;


-- Change table for extension to the slide 11 example
CREATE TABLE SSCustomerChanges2
( 	CustId 	        CHAR(8),
  	CustName	VARCHAR(30),
        CustPhone    	VARCHAR(15),
	CustStreet	VARCHAR(50),
	CustCity	VARCHAR(30),
   	CustState	VARCHAR(20),
   	CustZip		VARCHAR(10),
	CustNation	VARCHAR(20),
 CONSTRAINT PKSSCustomerChanges2 PRIMARY KEY (CustId)  );

-- Rows for extension to the slide 11 example
-- Changed rows only have values for PK and changed columns
-- Change to street and zip code so only values for CustId, CustStreet and CustZip
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C0954327',NULL,NULL,'444 Jump Ave.',NULL ,NULL,'80128-5443',NULL);

-- Change to phone so only values for CustId and CustPhone
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C1010398', NULL,'(303)257-4186', NULL, NULL, NULL, NULL, NULL);

-- Change to name so only values for CustId and CustName columns
insert into SSCustomerChanges2 
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C2388597','Beth Taylor-Hines', NULL, NULL, NULL, NULL, NULL, NULL);

-- New customer so values for all columns
insert into SSCustomerChanges2
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C8888888','William Wise','(303)421-1276','4334 Alameda Pkwy','Denver','CO','80210-3311','USA');

-- New customer so values for all columns
insert into SSCustomerChanges2
(CustId, CustName, CustPhone, CustStreet, CustCity, CustState, CustZip, CustNation)
values ('C9999999','Toan Lee','(303)555-1111','7504 Dry Creek Road','Centennial','CO','80112-3311','USA');

SELECT COUNT(*) FROM SSCustomerChanges2;
-- should be 5

-- List SSCustomer rows before INSERT ... ON CONFLICT
SELECT * FROM SSCustomer;

-- Extended example for slide 11
-- CASE expression added to accept missing values for non updated columns.

INSERT INTO SSCustomer 
 ( CustId, CustName, CustPhone, CustStreet, CustCity, CustState,
   CustZip, CustNation ) 
   SELECT Change.CustId, Change.CustName, Change.CustPhone, 
          Change.CustStreet, Change.CustCity,  
          Change.CustState, Change.CustZip, Change.CustNation
     FROM 
	  ( SELECT CustId, CustName, CustPhone, CustStreet, CustCity,  
               CustState, CustZip, CustNation 
	    FROM SSCustomerChanges2 ) Change
 ON CONFLICT ( CustId )
 DO UPDATE SET
   CustName = CASE WHEN EXCLUDED.CustName IS NOT NULL THEN EXCLUDED.CustName 
                   ELSE SSCustomer.CustName END,
   CustPhone = CASE WHEN EXCLUDED.CustPhone IS NOT NULL THEN EXCLUDED.CustPhone 
                    ELSE SSCustomer.CustPhone END,
   CustStreet = CASE WHEN EXCLUDED.CustStreet IS NOT NULL THEN EXCLUDED.CustStreet 
                     ELSE SSCustomer.CustStreet END,
   CustCity = CASE WHEN EXCLUDED.CustCity IS NOT NULL THEN EXCLUDED.CustCity 
                   ELSE SSCustomer.CustCity END,
   CustState = CASE WHEN EXCLUDED.CustState IS NOT NULL THEN EXCLUDED.CustState 
                    ELSE SSCustomer.CustState END,
   CustZip = CASE WHEN EXCLUDED.CustZip IS NOT NULL THEN EXCLUDED.CustZip 
                  ELSE SSCustomer.CustZip END,
   CustNation = CASE WHEN EXCLUDED.CustNation IS NOT NULL THEN EXCLUDED.CustNation 
                     ELSE SSCustomer.CustNation END;

SELECT COUNT(*) FROM SSCustomer;
SELECT * FROM SSCustomer;

-- Only need rollback if auto commit set
ROLLBACK;

