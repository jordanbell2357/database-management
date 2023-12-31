-- This document contains solutions for the extended practice problems as well as the module 3 assignment.
-- For completeness, all CREATE TABLE statements are shown including DROP statements if tables
-- were previously created. Note that COMMENT statements in the script are not required as part of the grading.

--DROP statements if needed
DROP TABLE EVENTPLANLINE;
DROP TABLE EVENTPLAN;
DROP TABLE EVENTREQUEST;
DROP TABLE LOCATION;
DROP TABLE FACILITY;
DROP TABLE RESOURCETBL;
DROP TABLE CUSTOMER;
DROP TABLE EMPLOYEE;

-- Extended practice problems
-- CREATE TABLE statements for Customer, Facility, and Location

-------------------- CUSTOMER --------------------------------

  CREATE TABLE Customer 
   (CustNo VARCHAR(8), 
    CustName VARCHAR(30) CONSTRAINT CustNameNotNull NOT NULL, 
    Address VARCHAR(50) CONSTRAINT AddressNotNull NOT NULL, 
    Internal CHAR(1) CONSTRAINT InternalNotNull NOT NULL, 
    Contact VARCHAR(35) CONSTRAINT ContractNotNull NOT NULL, 
    Phone VARCHAR(11) CONSTRAINT CPhoneNotNull NOT NULL, 
    City VARCHAR(30) CONSTRAINT CityNotNull NOT NULL,
    State VARCHAR(2) CONSTRAINT StateNotNull NOT NULL, 
    Zip VARCHAR(10) CONSTRAINT zipNotNull NOT NULL,
    CONSTRAINT PK_CUSTOMER PRIMARY KEY (CustNo) ) ;

  COMMENT ON COLUMN CUSTOMER.CUSTNO IS 'Customer DECIMAL'; 
  COMMENT ON COLUMN CUSTOMER.CUSTNAME IS 'Customer name';   
  COMMENT ON COLUMN CUSTOMER.ADDRESS IS 'Customer address';
  COMMENT ON COLUMN CUSTOMER.INTERNAL IS 'Customer type (Yes if internal, No otherwise)';
  COMMENT ON COLUMN CUSTOMER.CONTACT IS 'Contact person'; 
  COMMENT ON COLUMN CUSTOMER.PHONE IS 'Contact phone DECIMAL'; 
  COMMENT ON COLUMN CUSTOMER.CITY IS 'City';
  COMMENT ON COLUMN CUSTOMER.STATE IS 'State'; 
  COMMENT ON COLUMN CUSTOMER.ZIP IS 'Zip code';

-------------------- FACILITY --------------------------------

  CREATE TABLE Facility
  (FacNo VARCHAR(8), 
   FacName VARCHAR(30) CONSTRAINT FacNameNotNull NOT NULL,
   CONSTRAINT PK_FACILITY PRIMARY KEY (FacNo) );  

   COMMENT ON COLUMN FACILITY. FACNO IS 'Facility DECIMAL';
   COMMENT ON COLUMN FACILITY.FACNAME IS 'Facility name';

-------------------- LOCATION --------------------------------

  CREATE TABLE Location
  (LocNo VARCHAR(8), 
   FacNo VARCHAR(8) CONSTRAINT FacNoFKNotNull NOT NULL, 
   LocName VARCHAR(30) CONSTRAINT LocNameNotNull NOT NULL,
   CONSTRAINT PK_LOCATION PRIMARY KEY (LocNo),
   CONSTRAINT FK_FACNO FOREIGN KEY (FacNo) REFERENCES FACILITY (FacNo) );

  COMMENT ON COLUMN LOCATION.LOCNO IS 'Location DECIMAL';
  COMMENT ON COLUMN LOCATION.FACNO IS 'Facility DECIMAL';
  COMMENT ON COLUMN LOCATION.LOCNAME IS 'Location name';

-------------------- EMPLOYEE --------------------------------
-- Problem 1 solution

 CREATE TABLE Employee 
  (EmpNo VARCHAR(8), 
   EmpName VARCHAR(35) CONSTRAINT EmpNameNotNull NOT NULL, 
   Department VARCHAR(25) CONSTRAINT DepartmetnNotNull NOT NULL, 
   Email VARCHAR(30) CONSTRAINT EmailNotNull NOT NULL, 
   Phone VARCHAR(10) CONSTRAINT EPhoneNotNull NOT NULL, 
   CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EmpNo) ) ;

 COMMENT ON COLUMN EMPLOYEE.EMPNO IS 'Employee DECIMAL';
 COMMENT ON COLUMN EMPLOYEE.EMPNAME IS 'Employee name';
 COMMENT ON COLUMN EMPLOYEE.DEPARTMENT IS 'Department';
 COMMENT ON COLUMN EMPLOYEE.EMAIL IS 'electronic mail address';

-------------------- RESOURCETBL --------------------------------
-- Problem 2 solution

  CREATE TABLE ResourceTbl
  (ResNo VARCHAR(8), 
   ResName VARCHAR(30) CONSTRAINT ResNameNotNull NOT NULL, 
   Rate DECIMAL(15,4) CONSTRAINT RateNotNull NOT NULL,
   CONSTRAINT RatePositive CHECK (Rate > 0), 
   CONSTRAINT PK_RESOURCE PRIMARY KEY (ResNo) );

   COMMENT ON TABLE RESOURCETBL  IS 'ORIGINAL NAME:Resource';

-------------------- EVENTREQUEST --------------------------------
-- Problem 3 solution

  CREATE TABLE EventRequest
  (EventNo VARCHAR(8), 
   DateHeld DATE CONSTRAINT DateheldNotNull NOT NULL, 
   DateReq DATE CONSTRAINT DateReqNotNull NOT NULL, 
   CustNo VARCHAR(8) CONSTRAINT CustNoFKNotNull NOT NULL, 
   FacNo VARCHAR(8) CONSTRAINT FacNoFK2NotNull NOT NULL, 
   DateAuth DATE, 
   Status VARCHAR(20) CONSTRAINT StatusNotNull NOT NULL, 
   EstCost DECIMAL(15,4) CONSTRAINT EstCostNotNull NOT NULL, 
   EstAudience INTEGER CONSTRAINT EstAudienceNotNull NOT NULL, 
   BudNo VARCHAR(8),
   CONSTRAINT ValidStatus CHECK (Status IN ('Pending', 'Denied', 'Approved')),
   CONSTRAINT EstAudiencePositive CHECK (EstAudience > 0),
   CONSTRAINT PK_EVENTREQUEST PRIMARY KEY (EventNo),
   CONSTRAINT FK_EVENT_FACNO FOREIGN KEY (FacNo) REFERENCES FACILITY (FacNo),
   CONSTRAINT FK_CUSTNO FOREIGN KEY (CustNo) REFERENCES CUSTOMER (CustNo) ); 

  COMMENT ON COLUMN EVENTREQUEST.EVENTNO IS 'Event number';
  COMMENT ON COLUMN EVENTREQUEST.DATEHELD IS 'Event date';
  COMMENT ON COLUMN EVENTREQUEST.DATEREQ IS 'Date requested';
  COMMENT ON COLUMN EVENTREQUEST.CUSTNO IS 'Customer number';
  COMMENT ON COLUMN EVENTREQUEST.FACNO IS 'Facility number';
  COMMENT ON COLUMN EVENTREQUEST.DATEAUTH IS 'Date authorized';
  COMMENT ON COLUMN EVENTREQUEST.STATUS IS 'Status of event request';
  COMMENT ON COLUMN EVENTREQUEST.ESTCOST IS 'Estimated cost';
  COMMENT ON COLUMN EVENTREQUEST.ESTAUDIENCE IS 'Estimated audience';
  COMMENT ON COLUMN EVENTREQUEST.BUDNO IS 'Budget number';

-------------------- EVENTPLAN --------------------------------
-- Problem 4 solution

  CREATE TABLE EventPlan
  (PlanNo VARCHAR(8), 
   EventNo VARCHAR(8) CONSTRAINT EventNoFKNotNull NOT NULL, 
   WorkDate DATE CONSTRAINT WorkDateNotNull NOT NULL, 
   Notes VARCHAR(50), 
   Activity VARCHAR(50) CONSTRAINT ActivityNotNull NOT NULL, 
   EmpNo VARCHAR(8),
   CONSTRAINT PK_EVENTPLAN PRIMARY KEY (PlanNo), 
   CONSTRAINT FK_EMPNO FOREIGN KEY (EmpNo) REFERENCES EMPLOYEE (EmpNo),
   CONSTRAINT FK_EVENTNO FOREIGN KEY (EventNo) REFERENCES EVENTREQUEST (EventNo) ); 

  COMMENT ON COLUMN EVENTPLAN.PLANNO IS 'Event plan number';
  COMMENT ON COLUMN EVENTPLAN.EVENTNO IS 'Event number';
  COMMENT ON COLUMN EVENTPLAN.WORKDATE IS 'Work date';

-------------------- EVENTPLANLINE --------------------------------
-- Problem 5 solution

  CREATE TABLE EventPlanLine
  (PlanNo VARCHAR(8), 
   LineNo INTEGER CONSTRAINT LineNoNotNull NOT NULL, 
   TimeStart DATE CONSTRAINT TimeStartNotNull NOT NULL, 
   TimeEnd DATE CONSTRAINT TimeEndNotNull NOT NULL, 
   ResourceCnt INTEGER CONSTRAINT NumberFldNotNull NOT NULL, 
   LocNo VARCHAR(8) CONSTRAINT LocNoFKNotNull NOT NULL, 
   ResNo VARCHAR(8) CONSTRAINT ResNoFKNotNull NOT NULL,
   CONSTRAINT TimeStartEndRelationship CHECK (TimeStart < TimeEnd), 
   CONSTRAINT PK_EVENTPLANLINE PRIMARY KEY (PlanNo, LineNo),
   CONSTRAINT FK_LOCNO FOREIGN KEY (LocNo) REFERENCES LOCATION (LocNo), 
   CONSTRAINT FK_RESNO FOREIGN KEY (ResNo) REFERENCES RESOURCETBL (ResNo), 
   CONSTRAINT FK_PLANNO FOREIGN KEY (PlanNo) REFERENCES EVENTPLAN (PlanNo) ON DELETE CASCADE ); 

  COMMENT ON COLUMN EVENTPLANLINE.PLANNO IS 'Event Event plan number';
  COMMENT ON COLUMN EVENTPLANLINE.LINENO IS 'line number';
  COMMENT ON COLUMN EVENTPLANLINE.TIMESTART IS 'Time start';
  COMMENT ON COLUMN EVENTPLANLINE.TIMEEND IS 'Time end';
  COMMENT ON COLUMN EVENTPLANLINE.RESOURCECNT IS 'count of resources needed';