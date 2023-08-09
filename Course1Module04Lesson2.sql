--Example 1
SELECT * FROM Faculty;
--Example 2
SELECT *
FROM Faculty
WHERE FacNo = '543-21-0987';
--Example 3
SELECT FacFirstName, FacLastName, FacSalary
FROM Faculty
WHERE FacSalary > 65000 AND FacRank = 'PROF';
--Example 4
SELECT FacCity, FacState
FROM Faculty;
SELECT DISTINCT FacCity, FacState
FROM Faculty;
--Example 5 (Oracle)
SELECT FacFirstName, FacLastName, FacCity,
FacSalary*1.1 AS IncreasedSalary,
FacHireDate
FROM Faculty
WHERE to_number(to_char(FacHireDate, 'YYYY')) > 2008;
--Example 6
SELECT *
FROM Offering
WHERE CourseNo LIKE 'IS%';
--Example 7 (Oracle and PostgreSQL)
SELECT FacFirstName, FacLastName, FacHireDate
FROM Faculty
WHERE FacHireDate BETWEEN '1-Jan-2011'
AND '31-Dec-2012';
--Example 8: Testing for null values
SELECT OfferNo, CourseNo
FROM Offering
WHERE FacNo IS NULL
AND OffTerm = 'SUMMER'
AND OffYear = 2020;
--Example 9: Mixing AND and OR
SELECT OfferNo, CourseNo, FacNo
FROM Offering
WHERE (OffTerm = 'FALL' AND OffYear = 2019)
OR (OffTerm = 'WINTER' AND OffYear = 2020);