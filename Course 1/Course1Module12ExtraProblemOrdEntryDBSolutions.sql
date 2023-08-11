-- Module 12 extra problem solutions
-- PostgreSQL execution using the Order Entry tables
-- Work problems before viewing solutions
-- Problem order does not match problem type. Problem types are mixed in the document.

-- Problem 1
-- List details of orders and employees in January 2021. Show an order even if no employee exists for the order.
-- The result should contain the order number, order date, employee number, and employee name (first and last).
-- Use LEFT JOIN keywords to refer to the table to preserve.

SELECT OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName
 FROM OrderTbl LEFT JOIN Employee ON Employee.EmpNo = OrderTbl.EmpNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021';

-- Problem 2
-- List details of orders and employees in January 2021. Show an order even if no employee exists for the order.
-- The result should contain the order number, order date, employee number, and employee name (first and last).
-- Use RIGHT JOIN keywords to refer to the table to preserve.

SELECT OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName
 FROM Employee RIGHT JOIN OrderTbl ON Employee.EmpNo = OrderTbl.EmpNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021';

-- Problem 3
-- List the customer number and name of Washington state customers who have not placed orders.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Insert a new customer without orders for this problem.

INSERT INTO customer
	(CustNo, CustFirstName, CustLastName, CustStreet, CustCity,
 	CustState, CustZip, CustBal) 
	VALUES('C9999999','Henry','Sanders','1500 S. Hill Rd.','Fife','WA','98222-2258',1000.00);

-- Membership exception
-- Words matching text pattern: Washington state customers who have not placed orders

SELECT Customer.CustNo, CustFirstName, CustLastName 
  FROM Customer 
  WHERE CustState = 'WA' AND CustNo NOT IN
   ( SELECT CustNo
      FROM OrderTbl );

-- Remove new customer row

DELETE FROM Customer WHERE CustNo = 'C9999999'

-- Problem 4
-- List the customer number and name of Colorado customers who have not placed orders in February 2021.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Membership exception
-- Words matching text pattern: Colorado customers who have not placed orders in February 2021

SELECT Customer.CustNo, CustFirstName, CustLastName 
  FROM Customer 
  WHERE CustState = 'CO' AND CustNo NOT IN
   ( SELECT CustNo
      FROM OrderTbl 
      WHERE OrdDate BETWEEN '1-Feb-2021' AND '28-Feb-2021' );

-- Problem 5
-- The result should contain the order number, order date, employee number, and employee name (first and last),
-- customer number, and customer name (first and last).
-- Show details of order, employee, and customer of orders with and without employees
-- Identify the problem type and words in the problem statement matching the text pattern.

-- One-sided outer join
-- Words matching text pattern:
-- Show details of order, employee, and customer of orders with and without employees

-- Outer join before join

SELECT OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName,
       OrderTbl.CustNo, CustFirstName, CustLastName
 FROM OrderTbl LEFT JOIN Employee ON Employee.EmpNo = OrderTbl.EmpNo
              INNER JOIN Customer ON Customer.CustNo = OrderTbl.CustNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021';

-- Join before outer join
SELECT OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName,
       OrderTbl.CustNo, CustFirstName, CustLastName
 FROM  OrderTbl INNER JOIN Customer ON Customer.CustNo = OrderTbl.CustNo 
               LEFT JOIN Employee ON Employee.EmpNo = OrderTbl.EmpNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021';

-- Problem 6
-- List the order number and order date of orders containing every product with the words Ink Jet in the 
-- product description.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Containment exception
-- Words matching text pattern: orders containing every product with the words Ink Jet
-- This problem requires a division operation because the problem statement involves orders containing 
-- every Ink Jet product, not just any Ink Jet product.

SELECT OrderTbl.OrdNo, OrdDate
  FROM OrderTbl, OrdLine, Product  
  WHERE OrderTbl.OrdNo = OrdLine.OrdNo 
        AND OrdLine.ProdNo = Product.ProdNo
        AND ProdName LIKE '%Ink Jet%'
  GROUP BY OrderTbl.OrdNo, OrdDate
  HAVING COUNT(*) =
      ( SELECT COUNT(*)
         FROM Product
         WHERE ProdName LIKE '%Ink Jet%' );

-- Problem 7
-- List order number, order date, employee number and name, order line number, product number, name, and
-- manufacturer of orders placed in January 2021. Order the result by order number and product number.
-- Show an order even if the employee does not exist.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- One-sided outer join problem
-- Words matching text pattern: Show an order even if the employee does not exist.

-- Outer join before joins
SELECT OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, 
       EmpFirstName, EmpLastName, Qty, Product.ProdNo, ProdPrice, ProdMfg
 FROM OrderTbl INNER JOIN OrdLine
   ON OrdLine.OrdNo = OrderTbl.OrdNo 
      LEFT JOIN Employee 
   ON Employee.EmpNo = OrderTbl.EmpNo 
   INNER JOIN Product ON Product.ProdNo = OrdLine.ProdNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
 ORDER BY OrderTbl.OrdNo, OrdLine.ProdNo;

-- Joins before outer join
SELECT OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, 
       EmpFirstName, EmpLastName, Qty, Product.ProdNo, ProdPrice, ProdMfg
 FROM OrderTbl INNER JOIN OrdLine ON OrdLine.OrdNo = OrderTbl.OrdNo 
   INNER JOIN Product ON Product.ProdNo = OrdLine.ProdNo
   LEFT JOIN Employee ON Employee.EmpNo = OrderTbl.EmpNo 
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
 ORDER BY OrderTbl.OrdNo, OrdLine.ProdNo;

-- Problem 8
-- For Colorado customers, compute the average amount of their orders and order count. The average amount of a 
-- customer�s orders is the sum of the amount (quantity ordered times the product price) on each order divided by 
-- the number of orders. The result should include the customer number, customer last name, average order amount, 
-- and count of orders.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- This problem requires a nested query in the FROM clause because nested aggregates are involved.
-- Words on problem statement matching text pattern: 
-- average amount of their order
-- average amount of a customer�s orders is the sum of the amount (quantity ordered times the product price)

-- Alias for subquery (X) required in PostgreSQL but not in Oracle
-- Grouping on OrdNo in the subquery is necessary to sum the amounts for an order
-- The main query eliminates grouping on OrdNo to calculate the averages across orders for each customer.

SELECT CustNo, CustLastName, AVG(OrdAmt) AS AvgOrdAmt, COUNT(*) AS OrderCount
  FROM 
    ( SELECT Customer.CustNo, CustLastName, OrderTbl.OrdNo, 
             SUM(Qty*ProdPrice) AS OrdAmt
       FROM OrderTbl, Customer, OrdLine, Product
       WHERE OrderTbl.CustNo = Customer.CustNo
         AND OrderTbl.OrdNo = OrdLine.OrdNo
         AND OrdLine.ProdNo = Product.ProdNo
         AND CustState = 'CO' 
        GROUP BY Customer.CustNo, CustLastName, OrderTbl.OrdNo ) X
   GROUP BY CustNo, CustLastName;

-- Problem 9
-- List the customer number and name (first and last) of customers who have ordered products only manufactured 
-- by Connex. Only include customers who have ordered at least one product manufactured by Connex. Remove duplicate 
-- rows from the result.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Membership exception
-- Words matching text pattern: 
-- customers who have ordered products only manufactured by Connex

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName
  FROM Customer, OrderTbl, OrdLine, Product  
  WHERE OrderTbl.OrdNo = OrdLine.OrdNo 
    AND OrdLine.ProdNo = Product.ProdNo
    AND Customer.CustNo = OrderTbl.CustNo
    AND ProdMfg = 'Connex' AND Customer.CustNo NOT IN
      ( SELECT Customer.CustNo
         FROM Customer, OrderTbl, OrdLine, Product
         WHERE OrdLine.ProdNo = Product.ProdNo
           AND Customer.CustNo = OrderTbl.CustNo
           AND OrderTbl.OrdNo = OrdLine.OrdNo
           AND ProdMfg <> 'Connex' );

-- Problem 10
-- List the product number and name of products contained on every order placed on January 7, 2021 through 
-- January 9, 2021.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Containment exception
-- Words matching text pattern: products contained on every order

SELECT Product.ProdNo, ProdName
  FROM OrderTbl, OrdLine, Product  
  WHERE OrderTbl.OrdNo = OrdLine.OrdNo 
        AND OrdLine.ProdNo = Product.ProdNo
        AND OrdDate BETWEEN '7-Jan-2021' AND '9-Jan-2021'
  GROUP BY Product.ProdNo, ProdName
  HAVING COUNT(*) =
      ( SELECT COUNT(*)
         FROM OrderTbl
         WHERE OrdDate BETWEEN '7-Jan-2021' AND '9-Jan-2021' );

-- Problem 11
-- List all the people in the database. The resulting table should have all columns of the Customer and Employee tables. 
-- Match the Customer and Employee tables on first and last names. If a customer does not match any employees, 
-- the columns pertaining to the Employee table will be blank. Similarly for an employee who does not match any 
-- customers, the columns pertaining to the Customer table will be blank.

-- Full outer join

SELECT *
  FROM Customer FULL JOIN Employee 
    ON Customer.CustFirstName = Employee.EmpFirstName 
   AND Customer.CustLastName = Employee.EmpLastName;

-- Problem 12
-- Show order number and date, employee number and name, total order amount, and 
-- count of order lines of orders placed in January 2021. Total order amount computed as the sum of quantity 
-- times product price of products on lines of an order.
-- Show an order even if the employee does not exist.
-- Order the result by order number.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- One-sided outer join
-- Words matching text pattern: Show an order even if the employee does not exist.

-- One-sided outer join before joins
SELECT OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName,
       SUM(Qty * ProdPrice) AS OrderTotal, COUNT(*) AS OrdLineCount
 FROM OrderTbl INNER JOIN OrdLine
   ON OrdLine.OrdNo = OrderTbl.OrdNo 
      LEFT JOIN Employee 
   ON Employee.EmpNo = OrderTbl.EmpNo 
   INNER JOIN Product ON Product.ProdNo = OrdLine.ProdNo
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
 GROUP BY OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName
 ORDER BY OrderTbl.OrdNo;

-- Joins before one-sided outer join

SELECT OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName,
       SUM(Qty * ProdPrice) AS OrderTotal, COUNT(*) AS OrdLineCount
 FROM OrderTbl INNER JOIN OrdLine ON OrdLine.OrdNo = OrderTbl.OrdNo 
   INNER JOIN Product ON Product.ProdNo = OrdLine.ProdNo
   LEFT JOIN Employee ON Employee.EmpNo = OrderTbl.EmpNo 
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
 GROUP BY OrderTbl.OrdNo, OrdDate, OrderTbl.EmpNo, EmpFirstName, EmpLastName
 ORDER BY OrderTbl.OrdNo;

-- Problem 13
-- List customer details and product number for ColorMeg products ordered in January 2021.
-- Remove duplicate rows in the result.
-- The result should contain customer number customer name (first and last), and product number.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- This problem does not involve advanced query formulation.

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName, Product.ProdNo
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE ProdMfg = 'ColorMeg, Inc.' 
       AND OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
       AND Customer.CustNo = OrderTbl.CustNo
       AND OrderTbl.OrdNo = OrdLine.OrdNo
       AND Product.ProdNo = OrdLine.ProdNo;

-- Problem 14
-- List the customer number and name (first and last) of customers who have ordered every product manufactured 
-- by ColorMeg, Inc. in January 2021.
-- Identify the problem type and words in the problem statement matching the text pattern.

-- Containment exception
-- Words matching text pattern: customers who have ordered every

-- Break problem into major parts
-- List customer details and product number for ColorMeg products ordered in January 2021.
-- Remove duplicate rows in the result

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName, Product.ProdNo
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE ProdMfg = 'ColorMeg, Inc.' 
       AND OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
       AND Customer.CustNo = OrderTbl.CustNo
       AND OrderTbl.OrdNo = OrdLine.OrdNo
       AND Product.ProdNo = OrdLine.ProdNo;

-- List count of Color Meg products.

SELECT COUNT(*) 
 FROM Product 
 WHERE ProdMfg = 'ColorMeg, Inc.';

-- Put both parts together for the division operation.
-- COUNT template for division problem: compare counts in HAVING clause
-- DISTINCT in COUNT to eliminate same product ordered more than one time.

SELECT Customer.CustNo, CustFirstName, CustLastName 
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE ProdMfg = 'ColorMeg, Inc.' 
       AND OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
       AND Customer.CustNo = OrderTbl.CustNo
       AND OrderTbl.OrdNo = OrdLine.OrdNo
       AND Product.ProdNo = OrdLine.ProdNo
   GROUP BY Customer.CustNo, CustFirstName, CustLastName
   HAVING COUNT(DISTINCT Product.ProdNo) = 
     ( SELECT COUNT(*) 
          FROM Product 
          WHERE ProdMfg = 'ColorMeg, Inc.' );

-- Problem 15
-- Rewrite the following SELECT statement to use a Type I nested query for the Product table.
-- Why can a Type I nested query be used for the Product table?

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE ProdMfg = 'ColorMeg, Inc.' 
       AND OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
       AND Customer.CustNo = OrderTbl.CustNo
       AND OrderTbl.OrdNo = OrdLine.OrdNo
       AND Product.ProdNo = OrdLine.ProdNo;

-- Since no columns from the Product table appear in the result, a Type I nested query can be used 
-- on the Product table.

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName
 FROM Customer, OrderTbl, OrdLine
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
   AND Customer.CustNo = OrderTbl.CustNo
   AND OrderTbl.OrdNo = OrdLine.OrdNo
   AND  OrdLine.ProdNo IN
    ( SELECT ProdNo 
       FROM Product 
       WHERE ProdMfg = 'ColorMeg, Inc.' );

-- Problem 16
-- Analyze the following SELECT statement to see if a Typle I nested query can be used for the Product table.

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName, Product.ProdNo
 FROM Customer, OrderTbl, OrdLine, Product
 WHERE ProdMfg = 'ColorMeg, Inc.' 
       AND OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
       AND Customer.CustNo = OrderTbl.CustNo
       AND OrderTbl.OrdNo = OrdLine.OrdNo
       AND Product.ProdNo = OrdLine.ProdNo;

-- Since Product.ProdNo appears in the result, a Type I nested query cannot be used for the Product table.
-- However, if OrdLine.ProdNo appears in the result instead of Product.ProdNo, a Type I nested query
-- on the Product table can be used.

SELECT DISTINCT Customer.CustNo, CustFirstName, CustLastName, OrdLine.ProdNo
 FROM Customer, OrderTbl, OrdLine
 WHERE OrdDate BETWEEN '1-Jan-2021' AND '31-Jan-2021'
   AND Customer.CustNo = OrderTbl.CustNo
   AND OrderTbl.OrdNo = OrdLine.OrdNo
   AND  OrdLine.ProdNo IN
    ( SELECT ProdNo 
       FROM Product 
       WHERE ProdMfg = 'ColorMeg, Inc.' );
