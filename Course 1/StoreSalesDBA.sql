CREATE TABLE Student
( StdNo 	    CHAR(11)    CONSTRAINT StdNoRequired NOT NULL,
  StdFirstName  VARCHAR(50) CONSTRAINT StdFirstNameRequired NOT NULL,
  StdLastName   VARCHAR(50) CONSTRAINT StdLastNameRequired NOT NULL,
  StdCity	    VARCHAR(50) CONSTRAINT StdCityRequired NOT NULL,
  StdState	    CHAR(2)	    CONSTRAINT StdStateRequired NOT NULL,
  StdZip	    CHAR(10)    CONSTRAINT StdZipRequired NOT NULL,
  StdMajor	    CHAR(6),
  StdClass	    CHAR(6),
  StdGPA	    DECIMAL(3,2) DEFAULT 0,	
  CONSTRAINT PKStudent PRIMARY KEY (StdNo),	
  CONSTRAINT ValidGPA CHECK ( StdGPA BETWEEN 0 AND 4 ),
  CONSTRAINT ValidStdClass CHECK (StdClass IN ('FR','SO', 'JR','SR')),
  CONSTRAINT MajorDeclared CHECK 
               ( StdClass IN ('FR','SO') OR StdMajor IS NOT NULL ) );

CREATE TABLE Faculty (
FacNo		CHAR(11),
FacFirstName	VARCHAR(30) CONSTRAINT FacFirstNameRequired NOT NULL,
FacLastName	VARCHAR(30) CONSTRAINT FacLastNameRequired NOT NULL,
FacCity		VARCHAR(30) CONSTRAINT FacCityRequired NOT NULL,
FacState	CHAR(2) CONSTRAINT FacStateRequired NOT NULL,
FacZipCode	CHAR(10) CONSTRAINT FacZipRequired NOT NULL,
FacRank		CHAR(4),
FacHireDate	DATE,
FacSalary	DECIMAL(10,2),
FacSupervisor	CHAR(11),
FacDept		CHAR(6),
CONSTRAINT FacultyPK PRIMARY KEY (FacNo), 
CONSTRAINT SupervisorFK FOREIGN KEY (FacSupervisor) REFERENCES Faculty );

CREATE TABLE Course (
CourseNo	CHAR(6),
CrsDesc		VARCHAR(50) CONSTRAINT CrsDescRequired NOT NULL,
CrsUnits	INTEGER,
CONSTRAINT CoursePK PRIMARY KEY (CourseNo), 
CONSTRAINT UniqueCrsDesc UNIQUE (CrsDesc)  );

CREATE TABLE Offering (
OfferNo INTEGER,
CourseNo CHAR(6) CONSTRAINT OffCourseNoRequired NOT NULL,
OffTerm CHAR(6) CONSTRAINT OffTermRequired NOT NULL,
OffYear INTEGER DEFAULT 2022 CONSTRAINT OffYearRequired NOT NULL,
OffLocation VARCHAR(30),
OffTime VARCHAR(10),
FacNo CHAR(11),
OffDays CHAR(6) DEFAULT 'MW',
CONSTRAINT OfferingPK PRIMARY KEY (OfferNo),
CONSTRAINT CourseFK FOREIGN KEY (CourseNo) REFERENCES Course,
CONSTRAINT FacultyFK FOREIGN KEY (FacNo) REFERENCES Faculty );

CREATE TABLE Enrollment (
OfferNo		INTEGER,
StdNo		CHAR(11),
EnrGrade	DECIMAL(3,2) DEFAULT 0,
CONSTRAINT EnrollmentPK PRIMARY KEY (OfferNo, StdNo),
CONSTRAINT OfferingFK FOREIGN KEY (OfferNo) REFERENCES Offering ON DELETE CASCADE,
CONSTRAINT StudentFK FOREIGN KEY (StdNo) REFERENCES Student ON DELETE CASCADE );

-- Student table
INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('123-45-6789','HOMER','WELLS','SEATTLE','WA','IS','FR',3.00,'98121-1111');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('124-56-7890','BOB','NORBERT','BOTHELL','WA','FIN','JR',2.70,'98011-2121');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('234-56-7890','CANDY','KENDALL','TACOMA','WA','ACCT','JR',3.50,'99042-3321');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('345-67-8901','WALLY','KENDALL','SEATTLE','WA','IS','SR',2.80,'98123-1141');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('456-78-9012','JOE','ESTRADA','SEATTLE','WA','FIN','SR',3.20,'98121-2333');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('567-89-0123','MARIAH','DODGE','SEATTLE','WA','IS','JR',3.60,'98114-0021');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('678-90-1234','TESS','DODGE','REDMOND','WA','ACCT','SO',3.30,'98116-2344');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('789-01-2345','ROBERTO','MORALES','SEATTLE','WA','FIN','JR',2.50,'98121-2212');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('876-54-3210','CRISTOPHER','COLAN','SEATTLE','WA','IS','SR',4.00,'98114-1332');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('890-12-3456','LUKE','BRAZZI','SEATTLE','WA','IS','SR',2.20,'98116-0021');

INSERT INTO Student
	(StdNo, StdFirstName, StdLastName, StdCity,
	 StdState, StdMajor, StdClass, StdGPA, StdZip)
	VALUES ('901-23-4567','WILLIAM','PILGRIM','BOTHELL','WA','IS','SO',3.80,'98113-1885');
    
-- Faculty table
INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('543-21-0987','VICTORIA','EMMANUEL','BOTHELL','WA','MS','PROF',120000.00,NULL,'2008-04-15','98011-2242');

INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('765-43-2109','NICKI','MACON','BELLEVUE','WA','FIN','PROF',65000.00,NULL,'2009-04-11','98015-9945');

INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('654-32-1098','LEONARD','FIBON','SEATTLE','WA','MS','ASSC',70000.00,'543-21-0987','2006-05-01','98121-0094');

INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('098-76-5432','LEONARD','VINCE','SEATTLE','WA','MS','ASST',35000.00,'654-32-1098','2007-04-10','98111-9921');

INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('876-54-3210','CRISTOPHER','COLAN','SEATTLE','WA','MS','ASST',40000.00,'654-32-1098','2011-03-01','98114-1332');

INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('987-65-4321','JULIA','MILLS','SEATTLE','WA','FIN','ASSC',75000.00,'765-43-2109','2012-03-15','98114-9954');
     
-- Course table
INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ( 'FIN300','FUNDAMENTALS OF FINANCE',4);

INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ( 'FIN450','PRINCIPLES OF INVESTMENTS',4);
	
INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ( 'FIN480','CORPORATE FINANCE',4);
	
INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ('IS320','FUNDAMENTALS OF BUSINESS PROGRAMMING',4 );

INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ( 'IS460','SYSTEMS ANALYSIS',4);
	
INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ( 'IS470','BUSINESS DATA COMMUNICATIONS',4);

INSERT INTO course
	(CourseNo, CrsDesc, CrsUnits)
	VALUES ('IS480','FUNDAMENTALS OF DATABASE MANAGEMENT',4 );
    
-- Offering table
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (1111,'IS320','SUMMER',2020,'BLM302','10:30:00',NULL,'MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (1234,'IS320','FALL',2019,'BLM302','10:30:00','098-76-5432','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (2222,'IS460','SUMMER',2019,'BLM412','13:30:00',NULL,'TTH');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (3333,'IS320','SPRING',2020,'BLM214','08:30:00','098-76-5432','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (4321,'IS320','FALL',2019,'BLM214','15:30:00','098-76-5432','TTH');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (4444,'IS320','WINTER',2020,'BLM302','15:30:00','543-21-0987','TTH');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (5555,'FIN300','WINTER',2020,'BLM207','08:30:00','765-43-2109','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (5678,'IS480','WINTER',2020,'BLM302','10:30:00','987-65-4321','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (5679,'IS480','SPRING',2020,'BLM412','15:30:00','876-54-3210','TTH');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (6666,'FIN450','WINTER',2020,'BLM212','10:30:00','987-65-4321','TTH');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (7777,'FIN480','SPRING',2020,'BLM305','13:30:00','765-43-2109','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (8888,'IS320','SUMMER',2020,'BLM405','13:30:00','654-32-1098','MW');
	
INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (9876,'IS460','SPRING',2020,'BLM307','13:30:00','654-32-1098','TTH');
    
-- Enrollment table
INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'123-45-6789',3.30);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'234-56-7890',3.50);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'345-67-8901',3.20);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'456-78-9012',3.10);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'567-89-0123',3.80);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1234,'678-90-1234',3.40);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'123-45-6789',3.50);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'124-56-7890',3.20);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'789-01-2345',3.50);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'876-54-3210',3.10);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'890-12-3456',3.40);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(4321,'901-23-4567',3.10);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5555,'123-45-6789',3.20);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5555,'124-56-7890',2.70);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5678,'123-45-6789',3.20);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5678,'234-56-7890',2.80);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5678,'345-67-8901',3.30);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5678,'456-78-9012',3.40);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5678,'567-89-0123',2.60);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'123-45-6789',2.00);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'124-56-7890',3.70);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'678-90-1234',3.30);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'789-01-2345',3.80);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'890-12-3456',2.9);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(5679,'901-23-4567',3.1);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(6666,'234-56-7890',3.1);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(6666,'567-89-0123',3.6);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(7777,'876-54-3210',3.4);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(7777,'890-12-3456',3.7);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(7777,'901-23-4567',3.4);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'124-56-7890',3.5);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'234-56-7890',3.2);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'345-67-8901',3.2);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'456-78-9012',3.4);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'567-89-0123',2.6);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'678-90-1234',3.3);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(9876,'901-23-4567',4);

INSERT INTO Enrollment
	(OfferNO, StdNo, EnrGrade)
	VALUES(1111,'901-23-4567',0.0);

-- Count rows in each table
SELECT COUNT(*) FROM Student;
-- Should be 11 Student rows
SELECT COUNT(*) FROM Course;
-- Should be 7 Course rows
SELECT COUNT(*) FROM Faculty;
-- Should be 6 Faculty rows
SELECT COUNT(*) FROM Offering;
-- Should be 13 Offering rows
SELECT COUNT(*) FROM Enrollment;
-- Should be 38 Enrollment rows

-- commit changes if auto commit not set
COMMIT;