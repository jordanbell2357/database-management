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
 AND DateHeld BETWEEN '2022-12-01' AND '2022-12-31'
 AND EventRequest.CustNo = Customer.CustNo;
 
SELECT EventNo, DateHeld, Customer.CustNo, CustName
 FROM EventRequest INNER JOIN Customer
 ON EventRequest.CustNo = Customer.CustNo
 WHERE City = 'Boulder'
 AND DateHeld BETWEEN '2022-12-01' AND '2022-12-31';