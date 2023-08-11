-- Module 12 practice problems
-- PostgreSQL and Oracle execution
-- These practice problems use the University database of Module 12.
-- You should attempt each problem before reviewing the solution.
-- See other course document for the solutions.

-- Lesson 2, Part 2 practice problems
-- Example 1
-- List offerings of summer 2020 courses. 
-- The result should include the offer number, course number, faculty number, faculty first name, and
-- faculty last name. Include an offering even if a faculty is not assigned to teach the offering.
-- Use LEFT JOIN keywords

-- Example 2
-- List the 2020 information systems course offerings taken by information system (IS) students.
-- The result should include the student number, student name (first and last), offer number, course number, 
-- faculty number, faculty first name, and course description. Include offering even if a faculty is not 
-- assigned to teach the offering. Order the result by last name and first name of a student.
-- Perform the outer join first in the FROM clause.

-- Example 3
-- Same requirements as Example 2 except perform the outer join last in the FROM clause.

-- Practice problems for Lesson 2

-- Example 1
-- Retrieve details (faculty number, first name, last name, and rank) of faculty teaching in Winter 2020.
-- Use a type I nested query as the join style.
-- Eliminate duplicates in the result.

-- Example 2
-- Retrieve the offering number, offering location, offering time, course number, and course description of
-- offerings taught in winter 2020 by finance (FIN) faculty.
-- Use a type I nested query as the join style for the Faculty table.

-- Example 3
-- Retrieve the name, city, and grade of students who have a high grade (>= 3.5) in a course offered in fall 2019 
-- taught by Leonard Vince. Use a nested query inside a nested query for this problem for the Offering
-- and Faculty tables.

-- Insert rows for extra examples 4 and 5
INSERT INTO Faculty
	(FacNo, FacFirstName, FacLastName, FacCity, FacState,
	 FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
	 VALUES ('123-49-6789','CLAUDIA','TAPIAN','PARKER','CO','MGMT','PROF',95000.00,NULL,'27-Jul-2020','80134-9954');

INSERT INTO Offering
	(OfferNo, CourseNo, OffTerm, OffYear, OffLocation, OffTime, FacNo, OffDays)
	VALUES (9997,'IS460','SPRING',2021,'BLM320','10:30:00','123-49-6789','MW');

-- Use commit in Oracle
-- COMMIT;

-- Example 4
-- Delete offerings taught by Claudia Tapian.

-- Example 5
-- Update the location of offerings taught by Judy Chan.
-- Insert Offering row first because it was deleted in 

-- Delete new rows

DELETE FROM Offering WHERE OfferNo = 9997;
DELETE FROM Faculty WHERE FacNo = '123-49-6789';

-- Use commit in Oracle
-- COMMIT;

-- Example 6
-- Retrieve the course number, course description, count of offerings, and average course grade
-- across offerings. Compute the average grade in an offering as the average of enrollment grade among students.
-- Compute the average course grade across offerings as the average of the average offering grade.
 
-- Lesson 3
-- Practice problems

-- Example 1
-- List offerings without any students
-- The result should contain the offer number, course number, offering term, and offering year

-- Example 2
-- List offerings without any students
-- The result should contain the offer number, course number, course description, offering term, and offering year

-- Example 3
-- Retrieve faculty not teaching in winter 2020
-- The result should contain faculty number and name (first and last)

-- Example 4
-- Difference Problem for independent tables using first and last names
-- Retrieve the faculty number, name (first and last), department, and salary of faculty who are not students.
-- Demonstrates NOT IN nested query using a comparison on multiple columns.
-- Surround multiple columns in parentheses in comma separated list for left hand side of NOT IN

-- Example 5
-- List the student number and name (first and last) of students who only take offerings on TTH days. 
-- Membership exception about students only taking classes on Tuesday/Thursday (TTH) days
-- Advanced problem

- Lesson 4, part 2

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

-- New row for practice problems
INSERT INTO stdclub
	(StdNo, ClubNo )
	VALUES('S3','C1');

-- COMMIT statement
-- Not necessary in PostgreSQL if using Auto Commit
-- COMMIT;

-- Example 1
-- Using extended tables (Student1, Club, StdClub)
-- List club numbers of clubs with all students. The result should contain the student number.
-- Basic problem

-- Example 2
-- Using extended tables (Student1, Club, StdClub)
-- List the club numbers of clubs that have all Seattle students as members.
-- Extended problem

-- Example 3
-- Advanced problem using the original university database tables
-- List faculty who have taught all information system offerings in fall 2019.
-- The result should contain faculty number and name (first and last).

-- Example 4
-- Advanced problem using the original university database tables
-- List faculty who have taught all seniors in their fall 2019 information systems offerings.
-- The result should contain faculty number and name (first and last).

-- Example 5
-- Advanced problem using the original university database tables
-- List the unique number and name (first and last) of students who have enrolled in classes with
-- faculty of all ranks (ASST, ASSC, and PROF).
-- This problem involves an extension to count unique faculty rank values for students.

-- Drop new tables if desired
DROP TABLE StdClub;
DROP TABLE Student1;
DROP TABLE Club;