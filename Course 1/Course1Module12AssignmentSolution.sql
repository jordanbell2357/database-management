-- Solutions for Module 12 assignment for PostgreSQL and Oracle
-- Except where noted, all solutions work for both Oracle and PostgreSQL

-- Problem 1
-- Problem type: membership exception
-- Words matching the text pattern: the event request has been approved but there is not an event plan

SELECT eventrequest.eventno, custname, contact, dateauth
FROM eventrequest, customer
WHERE eventrequest.custno = customer.custno 
  AND status = 'Approved'
  AND eventno NOT IN
    ( SELECT eventno FROM eventplan );

-- Problem 2
-- Problem type: one-sided outer join
-- Words matching the text pattern: Include a row in the result even if there is no supervising 
-- employee for the event plan. 

-- One-sided outer join first
SELECT eventplan.eventno, eventrequest.datereq, dateauth, planno, 
       workdate, empname
FROM EventPlan LEFT JOIN employee ON EventPlan.empno = employee.empno
     INNER JOIN EventRequest ON EventRequest.eventno = EventPlan.eventno     
WHERE eventrequest.datereq BETWEEN '01-Jul-2022'  AND '31-Jul-2022'
  AND dateauth BETWEEN '01-Jul-2022'  AND '31-Jul-2022'
  AND status = 'Approved';

-- Join first
SELECT eventplan.eventno, eventrequest.datereq, dateauth, planno, 
       workdate, empname
FROM EventRequest INNER JOIN EventPlan 
        ON EventRequest.eventno = EventPlan.eventno
      LEFT JOIN employee ON EventPlan.empno = employee.empno
WHERE eventrequest.datereq BETWEEN '01-Jul-2022'  AND '31-Jul-2022'
  AND dateauth BETWEEN '01-Jul-2022'  AND '31-Jul-2022'
  AND status = 'Approved';

-- Problem 3
-- Problem type: one-sided outer join
-- Words matching the text pattern: Include an event plan in the result even if the event plan 
-- does not have a supervising employee. 

SELECT EventPlan.PlanNo, WorkDate, EventPlan.EmpNo, EmpName,
       COUNT(*) AS EvtPlanLineCnt,
       COUNT(DISTINCT ResNo) AS ResourceCnt
FROM EventPlan INNER JOIN EventPlanLine ON EventPlan.PlanNo = EventPlanLine.PlanNo 
     LEFT JOIN Employee ON EventPlan.EmpNo = Employee.EmpNo
WHERE WorkDate BETWEEN '01-Dec-2022' AND '31-Dec-2022'
GROUP BY EventPlan.PlanNo, WorkDate, EventPlan.EmpNo, EmpName
HAVING COUNT(DISTINCT ResNo) > 1
ORDER BY EventPlan.PlanNo;

-- Problem 4
-- Problem type: membership exception
-- Words matching the text pattern: customers who have not submitted event requests

SELECT CustNo, CustName, Contact
FROM Customer
WHERE CustNo NOT IN 
 ( SELECT CustNo 
    FROM EventRequest );

-- Problem 5
-- Problem type: membership exception
-- Words matching the text pattern: employees who do not manage an event plan with a work date in October 2022.

SELECT EmpNo, EmpName, Email
FROM Employee
WHERE EmpNo NOT IN 
  ( SELECT EmpNo 
      FROM EventPlan 
      WHERE WorkDate BETWEEN '01-Oct-2022' AND '31-Oct-2022' );

-- Problem 6
-- Problem type: nested aggregate function

-- All joins in the nested query
SELECT EmpName, Email, AVG(SumResCost)
 FROM ( SELECT EmpName, Email, EventPlan.PlanNo, SUM(ResourceCnt * Rate) AS SumResCost
         FROM EventPlan, Employee, EventPlanLine, ResourceTbl
         WHERE EventPlan.EmpNo = Employee.EmpNo
           AND EventPlan.PlanNo = EventPlanLine.PlanNo
           AND EventPlanLine.ResNo = ResourceTbl.ResNo 
         GROUP BY EmpName, Email, EventPlan.PlanNo) X
 GROUP BY EmpName, Email;

-- Alternative solution with joins in both the outer query and nested query
SELECT EmpName, Email, AVG(SumResCost)
 FROM ( SELECT PlanNo, SUM(ResourceCnt * Rate) AS SumResCost
         FROM EventPlanLine, ResourceTbl
         WHERE EventPlanLine.ResNo = ResourceTbl.ResNo 
         GROUP BY PlanNo) X, EventPlan, Employee
  WHERE X.PlanNo = EventPlan.PlanNo
    AND EventPlan.EmpNo = Employee.EmpNo
 GROUP BY EmpName, Email;

-- Problem 7
-- Problem type: containment exception
-- Words matching the text pattern: the plan uses all resources with a rate greater than 15

SELECT eventplan.planno, workdate, activity
FROM eventplan, eventplanline, resourcetbl
WHERE eventplan.planno = eventplanline.planno 
  AND eventplanline.resno = resourcetbl.resno
  AND workdate BETWEEN '01-Dec-2022' AND '31-Dec-2022' 
  AND rate > 15
GROUP BY eventplan.planno, workdate, activity
HAVING COUNT(DISTINCT resourcetbl.resno) =
  ( SELECT COUNT(*) 
     FROM resourcetbl 
     WHERE rate > 15 );

-- This formulation contains a SELECT statement in the FROM clause.

SELECT planno, activity, workdate
FROM (SELECT DISTINCT eventplan.planno, workdate, activity, resourcetbl.resno
    FROM eventplan, eventplanline, resourcetbl
    WHERE eventplan.planno = eventplanline.planno 
      AND eventplanline.resno = resourcetbl.resno
      AND workdate BETWEEN '01-Dec-2022' AND '31-Dec-2022' 
      AND rate > 15) X
GROUP BY planno, activity, workdate
HAVING COUNT(*) = 
  ( SELECT COUNT(*) 
     FROM resourcetbl 
     WHERE rate > 15 );

-- Problem 8
-- The result does not contain columns from the Facility table so a Type I nested query can be used.

SELECT eventplan.planno, eventrequest.eventno, workdate, activity
FROM eventrequest, eventplan
WHERE eventplan.workdate BETWEEN '01-Dec-2022' AND '31-Dec-2022'
  AND eventrequest.eventno = eventplan.eventno 
  AND facno IN
     ( SELECT facno 
        FROM Facility 
        WHERE facname = 'Basketball arena' );

-- Problem 9
-- The result does not contain columns from the Facility and Employee tables so Type I nested queries can be used.

SELECT DISTINCT eventrequest.eventno, dateheld, status, estcost
FROM eventrequest, eventplan
WHERE dateheld BETWEEN '01-Dec-2022' AND '31-Dec-2022'
  AND eventrequest.eventno = eventplan.eventno 
  AND facno IN
      ( SELECT facno 
         FROM facility 
         WHERE facname = 'Basketball arena' )
  AND empno IN
      ( SELECT empno 
         FROM employee 
         WHERE empname = 'Mary Manager' );

-- INSERT statements for problems 10.1 and 10.2
INSERT INTO Facility ( FacNo, FacName )
VALUES ('F107', 'Swimming Pool');

INSERT INTO Location ( LocNo, FacNo, LocName )
VALUES ('L107', 'F107', 'Gate');

INSERT INTO Location ( LocNo, FacNo, LocName )
VALUES ('L108', 'F107', 'Locker Room');

-- Problem 10.1
UPDATE Location SET LocName = 'Door'
WHERE FacNo IN 
   ( SELECT FacNo 
        FROM Facility
        WHERE FacName = 'Swimming Pool' );

-- Problem 10.2
-- First part
DELETE FROM Location
WHERE FacNo IN 
   ( SELECT FacNo 
       FROM Facility
       WHERE FacName = 'Swimming Pool' );

-- Second part
DELETE FROM Facility
WHERE FacName = 'Swimming Pool';

-- Use COMMIT statement if auto commit is not set
COMMIT

-- 11.
-- Problem type: containment exception
-- Words matching text pattern: who manage event plans with all activities (setup, operation, and cleanup)

SELECT Employee.EmpNo, EmpName
 FROM Employee, EventPlan
 WHERE Employee.EmpNo = EventPlan.EmpNo
 GROUP BY Employee.EmpNo, EmpName
 HAVING COUNT(DISTINCT Activity) = 
  ( SELECT COUNT(DISTINCT Activity)
     FROM EventPlan );
 
-- 12.
-- This problem does not involve advanced query formulation.
-- This problem involve joins of 5 or 6 tables.

-- Two variations of the first solution
-- First solution uses the join from location to facility to ensure
-- that the event is held in the basketball arena
-- This formulation assumes that all locations for an event plan
-- are in the same facility.

-- Cross product style
SELECT eventplan.planno, lineno, locname, resname, ResourceCnt, timestart, timeend
FROM facility, eventplan, eventplanline, resourcetbl, location
WHERE eventplan.planno = eventplanline.planno 
  AND location.facno = facility.facno
  AND eventplanline.resno = resourcetbl.resno
  AND location.locno = eventplanline.locno 
  AND facname = 'Basketball arena'
  AND eventplan.workdate BETWEEN '01-Oct-2022' AND '31-Dec-2022' 
  AND eventplan.activity = 'Operation';

-- Join operator style

SELECT eventplan.planno, lineno, locname, resname, ResourceCnt, timestart, timeend
FROM EventPlan INNER JOIN EventPlanLine ON eventplan.planno = eventplanline.planno
     INNER JOIN ResourceTbl ON eventplanline.resno = resourcetbl.resno
     INNER JOIN Location ON location.locno = eventplanline.locno
     INNER JOIN Facility ON location.facno = facility.facno   facility eventplan, eventplanline, resourcetbl, location
WHERE facname = 'Basketball arena'
  AND eventplan.workdate BETWEEN '01-Oct-2022' AND '31-Dec-2022' 
  AND eventplan.activity = 'Operation';

-- Second solution assumes that join between event request and facility tables
-- is necessary to check the condition for the event held at the basketball arena.
-- The second formulation allows an event to use locations at different
-- facilities than the facility connected to the event request.

-- Cross product style
SELECT eventplan.planno, lineno, locname, resname, ResourceCnt, timestart, timeend
FROM eventrequest, facility, eventplan, eventplanline, resourcetbl, location
WHERE eventplan.planno = eventplanline.planno 
  AND eventrequest.facno = facility.facno
  AND eventplanline.resno = resourcetbl.resno
  AND eventrequest.eventno = eventplan.eventno 
  AND location.locno = eventplanline.locno 
  AND facname = 'Basketball arena' 
  AND eventplan.workdate BETWEEN ''01-Oct-2022' AND '31-Dec-2022'
  AND eventplan.activity = 'Operation';

-- Join operator style

SELECT eventplan.planno, lineno, locname, resname, ResourceCnt, timestart, timeend
FROM EventPlan INNER JOIN EventPlanLine ON eventplan.planno = eventplanline.planno
     INNER JOIN ResourceTbl ON eventplanline.resno = resourcetbl.resno
     INNER JOIN Location ON location.locno = eventplanline.locno
     INNER JOIN EventRequest ON eventrequest.eventno = eventplan.eventno
     INNER JOIN Facility ON EventRequest.facno = Facility.facno  
WHERE facname = 'Basketball arena'
  AND eventplan.workdate BETWEEN '01-Oct-2022' AND '31-Dec-2022' 
  AND eventplan.activity = 'Operation';
