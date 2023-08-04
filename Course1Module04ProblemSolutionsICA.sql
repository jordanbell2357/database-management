SELECT CustNo, CustName, Phone, City
 FROM Customer;
 
SELECT CustNo, CustName, Phone, City
 FROM Customer
 WHERE State = 'CO';

SELECT *
 FROM EventRequest
 WHERE EstCost > 4000
 ORDER BY DateHeld;

SELECT EventNo, DateHeld, Status, EstAudience
 FROM EventRequest
 WHERE (Status = 'Approved' AND EstAudience > 9000)
 OR (Status = 'Pending' AND EstAudience > 7000);

SELECT EventNo, DateHeld, Customer.CustNo, CustName
 FROM EventRequest, Customer
 WHERE City = 'Boulder'
 AND DateHeld BETWEEN '1-Dec-2022' AND '31-Dec-2022'
 AND EventRequest.CustNo = Customer.CustNo;
 
SELECT EventNo, DateHeld, Customer.CustNo, CustName
 FROM EventRequest INNER JOIN Customer
 ON EventRequest.CustNo = Customer.CustNo
 WHERE City = 'Boulder'
 AND DateHeld BETWEEN '1-Dec-2022' AND '31-Dec-2022' ;