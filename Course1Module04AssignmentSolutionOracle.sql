-- Course1 Module04 Assignment Answers - Oracle

-- Query Formulation Answers

1.	
-- The DISTINCT keyword is required here because the combination of city, state, and zip is not unique.

SELECT DISTINCT city, state, zip 
 FROM CUSTOMER;

2.	
-- The LIKE comparison operator is necessary when using a pattern matching symbol (%).  
-- The pattern �3-%� matches any text beginning with �3-�.

SELECT empname, department, phone, email FROM employee
WHERE phone LIKE '3-%';

3.	
-- The condition involves a closed interval including the end points.
-- BETWEEN AND operator preferred for compactness
SELECT * FROM resourcetbl
WHERE rate BETWEEN 10 AND 20
ORDER BY rate;

-- Alternative solution with two conditions using the >= and <= comparison operators
SELECT * 
FROM resourcetbl
WHERE rate >= 10 AND rate <= 20
ORDER BY rate;

4.	
--This query can be formulated using the IN comparison operator or the logical OR.  
--You should use parentheses when mixing AND and OR operators.

SELECT eventno, dateauth, status
FROM eventrequest
WHERE dateauth BETWEEN '01-Jul-2022' AND '31-Jul-2022'
  AND status IN ('Approved', 'Denied');

SELECT eventno, dateauth, status
FROM eventrequest
WHERE dateauth BETWEEN '01-Jul-2022' AND '31-Jul-2022' 
  AND (status = 'Approved' OR status = 'Denied');

5.	
-- These solutions demonstrate the cross product, join operator, and Type I nested styles.
-- Use condition on FacName as the problem requires a condition on FacName.
-- The condition on FacName indicates the need for a join of the Facility and Location tables.

SELECT location.locno, locname
FROM facility, location
WHERE facname = 'Basketball arena' 
  AND facility.facno = location.facno;

SELECT location.locno, locname
FROM facility INNER JOIN location ON facility.facno = location.facno
WHERE facname = 'Basketball arena';

SELECT location.locno, locname
FROM location
WHERE location.facno IN 
   ( SELECT facno FROM facility WHERE facname = 'Basketball arena' );


6.
-- The AS keywords are optional.  Aggregrate functions do not need to be renamed.

SELECT planno, COUNT(*) "Number of Lines", SUM(resourcecnt) "Resource Sum"
FROM eventplanline
GROUP BY planno;

7.
-- Using the TO_DATE function to include both date and time values in a constant
-- If time value is omitted, default 00:00 time value omits events starting on the last day

SELECT planno, COUNT(*) "Number of Lines", SUM(resourcecnt) "Resource Sum"
FROM eventplanline
WHERE TimeStart BETWEEN '01-Oct-2022' AND TO_DATE('31-Oct-2022 23:59', 'DD-Mon-YYYY HH24:MI')
GROUP BY planno
HAVING SUM(resourcecnt) >= 10;

