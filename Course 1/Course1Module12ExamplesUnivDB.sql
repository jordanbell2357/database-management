-- Module 12 example problems
-- PostgreSQL and Oracle execution
-- These examples appear in the lecture notes of Module 12.

-- Lesson 2, Part 2 examples
-- Example 1
-- List offerings of information system (IS) courses. 
-- The result should include the offer number, course number, faculty number, faculty first name, and
-- faculty last name. Include an offering even if a faculty is not assigned to teach the offering.
-- Use LEFT JOIN keywords

SELECT OfferNo, CourseNo, Offering.FacNo,  
       FacFirstName, FacLastName
 FROM Offering LEFT JOIN Faculty 
      ON Offering.FacNo = Faculty.FacNo
 WHERE CourseNo LIKE 'IS%';

-- Example 2
-- List offerings of information system (IS) courses. 
-- The result should include the offer number, course number, faculty number, faculty first name, and
-- faculty last name. Include an offering even if a faculty is not assigned to teach the offering.
-- Use RIGHT JOIN keywords

SELECT OfferNo, CourseNo, Offering.FacNo, 
       FacFirstName, FacLastName
 FROM Faculty RIGHT JOIN Offering 
      ON Offering.FacNo = Faculty.FacNo
 WHERE CourseNo LIKE 'IS%';

-- Example 3
-- Perform full outer join on faculty and student tables.
-- Compare faculty and student on faculty number to student number.
-- The result should contain the faculty number, faculty first name, faculty last name, faculty salary
-- student number, student first name, student last name, and student GPA.

SELECT FacNo, FacFirstName, FacLastName, FacSalary,
       StdNo, StdFirstName, StdLastName, StdGPA
 FROM Faculty FULL JOIN Student 
      ON Student.StdNo = Faculty.FacNo;

-- Example 4
-- List 2020 offerings of information system (IS) courses. 
-- The result should include the offer number, course number, faculty number, faculty first name, 
-- faculty last name, course description. Include offering even if a faculty is not assigned to teach the offering.
-- Parentheses are not needed in either statement.

-- LEFT JOIN formulation

SELECT OfferNo, Offering.CourseNo, OffTerm, CrsDesc,
       Faculty.FacNo, FacFirstName, FacLastName
 FROM Offering LEFT JOIN Faculty
      ON Offering.FacNo = Faculty.FacNo 
   INNER JOIN Course 
      ON Course.CourseNo = Offering.CourseNo
 WHERE Course.CourseNo LIKE 'IS%' 
   AND OffYear = 2020;

-- RIGHT JOIN formulation

SELECT OfferNo, Offering.CourseNo, OffTerm, CrsDesc,
       Faculty.FacNo, FacFirstName, FacLastName
 FROM  Faculty RIGHT JOIN Offering 
      ON Offering.FacNo = Faculty.FacNo
   INNER JOIN Course 
      ON Course.CourseNo = Offering.CourseNo
 WHERE Course.CourseNo LIKE 'IS%' 
   AND OffYear = 2020;

-- Example 5
-- List the rows of the Offering table with at least one student enrolled, in addition to the requirements of 
-- Example 4. Remove duplicate rows in the result.

SELECT DISTINCT Offering.OfferNo, Offering.CourseNo,
       OffTerm, CrsDesc, Faculty.FacNo, FacFirstName,
       FacLastName
 FROM Faculty RIGHT JOIN Offering 
        ON Offering.FacNo = Faculty.FacNo 
	INNER JOIN Course 
        ON Course.CourseNo = Offering.CourseNo 
	INNER JOIN Enrollment 
        ON Offering.OfferNo = Enrollment.OfferNo
 WHERE Offering.CourseNo LIKE 'IS%' 
   AND OffYear = 2020;

-- Example 6
-- List the rows of the Offering table with at least one student enrolled, in addition to the requirements of 
-- Example 4. Remove duplicate rows in the result.

SELECT DISTINCT Offering.OfferNo, Offering.CourseNo,
       OffTerm, CrsDesc, Faculty.FacNo, FacFirstName,
       FacLastName
 FROM Course INNER JOIN Offering
     ON Course.CourseNo = Offering.CourseNo 
  INNER JOIN Enrollment 
     ON Offering.OfferNo = Enrollment.OfferNo 
  LEFT JOIN Faculty
     ON Offering.FacNo = Faculty.FacNo
 WHERE Offering.CourseNo LIKE 'IS%' 
   AND OffYear = 2020;

-- Lesson 2

-- Example 1
-- Retrieve details of students with a high grade (>= 3.5)

SELECT StdNo, StdFirstName, StdLastName, StdMajor
 FROM Student
 WHERE Student.StdNo IN
  ( SELECT StdNo FROM Enrollment 
     WHERE EnrGrade >= 3.5  );

-- Example 2
-- Student details and grade with a high grade in a fall 2019 offering

SELECT StdFirstName, StdLastName, StdCity, EnrGrade
 FROM Student INNER JOIN Enrollment 
	   ON Student.StdNo = Enrollment.StdNo
 WHERE EnrGrade >= 3.5 
   AND Enrollment.OfferNo IN
  ( SELECT OfferNo FROM Offering 
     WHERE OffTerm = 'FALL' 
       AND OffYear = 2019 );

-- Insert rows for examples 3 and 4
INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('123-45-6789','JUDY','CHAN','PARKER','CO','MGMT','PROF',95000.00,NULL,'15-Mar-2020','80138-9954');

INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (9997,'IS460','SPRING',2020,'BLM307','13:30:00','123-45-6789','TTH');

-- Use commit in Oracle
-- COMMIT;

-- Example 3 
-- Delete offerings taught by Judy Chan.

DELETE FROM Offering
  WHERE Offering.FacNo IN 
   ( SELECT FacNo FROM Faculty 
      WHERE FacFirstName = 'JUDY' 
        AND FacLastName = 'CHAN' );

-- Example 4
-- Update the location of offerings taught by Judy Chan.
-- Insert Offering row first because it was deleted in 

INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (9997,'IS460','SPRING',2020,'BLM307','13:30:00','123-45-6789','TTH');

 UPDATE Offering 
  SET OffLocation = 'BLM412’
  WHERE OffYear = 2020 
    AND FacNo IN
  ( SELECT FacNo FROM Faculty 
     WHERE FacFirstName = 'JUDY' 
       AND FacLastName = 'CHAN');

-- Delete new rows

DELETE FROM Offering WHERE OfferNo = 9998;
DELETE FROM Faculty WHERE FacNo = '123-45-6789';

-- Use commit in Oracle
-- COMMIT;

-- Example 5
-- Retrieve the course number, course description, count of offerings, and average enrollment 
-- across offerings.
 
SELECT T.CourseNo, T.CrsDesc, 
       COUNT(*) AS NumOfferings, Avg(T.EnrollCount) AS AvgEnroll
  FROM 
   ( SELECT Course.CourseNo, CrsDesc, 
            Offering.OfferNo, 
            COUNT(*) AS EnrollCount
     FROM Offering, Enrollment, Course
     WHERE Offering.OfferNo = Enrollment.OfferNo
       AND Course.CourseNo = Offering.CourseNo
     GROUP BY Course.CourseNo, CrsDesc, Offering.OfferNo ) T    
  GROUP BY T.CourseNo, T.CrsDesc;

-- Lesson 3

-- Example 1
-- Retrieve courses not offered

SELECT CourseNo, CrsDesc, CrsUnits
  FROM Course
  WHERE CourseNo NOT IN
  ( SELECT CourseNo FROM Offering );

-- Example 2
-- Retrieve finance courses not offered in summer 2019

SELECT CourseNo, CrsDesc, CrsUnits
  FROM Course
  WHERE CourseNo LIKE 'FIN%'
    AND CourseNo NOT IN
  ( SELECT CourseNo 
     FROM Offering 
      WHERE OffTerm = 'SUMMER' 
        AND OffYear = 2019 );

-- Example 3
-- Retrieve courses only taught in winter terms.
-- The result should contain the course number, course description, and units

SELECT DISTINCT Course.CourseNo, CrsDesc, CrsUnits
 FROM Course, Offering
 WHERE Course.CourseNo = Offering.CourseNo
   AND OffTerm = 'WINTER'
   AND Course.CourseNo NOT IN
  ( SELECT CourseNo FROM Offering 
      WHERE OffTerm <> 'WINTER' );

-- Lesson 4, part 2
-- Containment exception problems

-- Example 10
-- Create and populate new tables (Student1, StdClub, and Club)

create table Club (
ClubNo		char(6) not null,
CName		varchar(10) not null,
CPurpose	varchar(10) not null,
CBudget		DECIMAL(10,2),
CActual		DECIMAL(10,2),
CONSTRAINT ClubPk PRIMARY KEY (ClubNo) );

INSERT INTO club
	(ClubNo, CName, CPurpose, CBudget, CActual )
	VALUES('C1','DELTA','SOCIAL',1000.00,1200.00);


INSERT INTO club
	(ClubNo, CName, CPurpose, CBudget, CActual )
	VALUES('C2','BITS','ACADEMIC',500.00,350.00);

INSERT INTO club
	(ClubNo, CName, CPurpose, CBudget, CActual )
	VALUES('C3','HELPS','SERVICE',300.00,330.00);

INSERT INTO club
	(ClubNo, CName, CPurpose, CBudget, CActual )
	VALUES('C4','SIGMA','SOCIAL',NULL,150.00);

create table Student1 (
StdNo		char(6) not null,
SName		varchar(10) not null,
SCity		varchar(10) not null,
CONSTRAINT Student1Pk PRIMARY KEY (StdNo) );

INSERT INTO student1
	(StdNo, SName, SCity )
	VALUES('S1','JOE','SEATTLE');

INSERT INTO student1
	(StdNo, SName, SCity )
	VALUES('S2','SALLY','SEATTLE');

INSERT INTO student1
	(StdNo, SName, SCity )
	VALUES('S3','SUE','PORTLAND');

create table StdClub (
ClubNo		char(6) not null,
StdNo		char(6) not null,
CONSTRAINT StdClubPk PRIMARY KEY (ClubNo,StdNo),
CONSTRAINT ClubFK FOREIGN KEY (ClubNo) REFERENCES Club,
CONSTRAINT Student2FK FOREIGN KEY (StdNo) REFERENCES Student1 );

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S1','C1');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S1','C2');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S1','C3');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S1','C4');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S2','C1');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S2','C4');

INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S3','C3');

-- Oracle COMMIT statement
-- Not necessary in PostgreSQL if using Auto Commit

-- COMMIT;
-- Example 1

SELECT StdNo 
  FROM StdClub
  GROUP BY StdNo
  HAVING COUNT(*) = 
   ( SELECT COUNT(*) FROM Club );

-- Example 2

SELECT Student1.StdNo, SName 
  FROM StdClub, Club, Student1
  WHERE StdClub.ClubNo = Club.ClubNo 
    AND Student1.StdNo = StdClub.StdNo
    AND CPurpose = 'SOCIAL'
  GROUP BY Student1.StdNo, SName
  HAVING COUNT(*) = 
   ( SELECT COUNT(*) FROM Club 
      WHERE CPurpose = 'SOCIAL' );

-- Example 3
-- Advanced problem using the original university database tables
-- List the number and the name of faculty who teach at least one section of all of the fall 2019, IS courses.
-- COUNT(DISTINCT ...) in HAVING clause to eliminate duplicates

SELECT Faculty.FacNo, FacFirstName, 
       FacLastName 
 FROM Faculty, Offering
 WHERE Faculty.FacNo = Offering.FacNo 
   AND OffTerm = 'FALL' AND CourseNo LIKE 'IS%'
   AND OffYear = 2019
 GROUP BY Faculty.FacNo, FacFirstName, 
          FacLastName
 HAVING COUNT(DISTINCT CourseNo) =
  ( SELECT COUNT(DISTINCT CourseNo) 
     FROM Offering
     WHERE OffTerm = 'FALL' AND OffYear = 2019 
       AND CourseNo LIKE 'IS%' );

-- Drop new tables if desired
DROP TABLE StdClub;
DROP TABLE Student1;
DROP TABLE Club;