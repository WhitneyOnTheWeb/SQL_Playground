/*
Whitney King
PROG 140          Module 9 Assignment   #10		Back to Basics: MORE SQL PRACTICE!
POINTS 50              DUE DATE :  Consult module
							
Develop a SQL statement for each task listed.  This exercise uses the Northwind database.

Please type your SQL statement under each task below.  Ensure your statement works by testing it prior to turning it in
When writing answers for your select statements please keep in mind that there is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your ability, 
in the best way possible to suit their needs. For example, consider the best way to sort, to name columns, etc. 
These are things you must think about on the job!
 
Turn In:

For this exercise you will submit one  WORD documents (instead of a .sql file) in which you have copied and pasted 
your entire work from your .sql file including all assignment questions and your SQL queries. 
The  document should contain your name at the top, assignment title, the date and any difficulties encountered. 


Submit your file to the instructor using the Canvas Assignment tool. 
*/


Use Northwind

/* 5 pts
1. Create a stored procedure that produces a list of all Suppliers in a 
      specified Region.  The procedure should accept 1 input parameter: Region. 
      The supplier list produced by the procedure should list, for each supplier:
      SupplierID, CompanyName, Region, and Country.  The list should be ordered 
      by CompanyName.  The procedure should also provide an OUTPUT parameter that
      returns the number of suppliers in the specified Region. 
	  (Reminder: we covered OUTPUT parameters in Module 5, Stored Procedure Basics, 
	  so if necessary, please review our Module 5 demo file: StoredProcedureBasics.sql)
      Note:  No error handling or commenting is required this time - just basic functionality.   */

IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name= 'uspSupplierRegion')
	DROP PROC uspSupplierRegion
GO

--Begin Sproc
CREATE PROC uspSupplierRegion
	@Region nchar(15),
	@RegionCount int OUTPUT
AS
SELECT SupplierID
	 , CompanyName
	 , Region
	 , Country
FROM Suppliers
WHERE Region = @Region
ORDER BY CompanyName;
SET @RegionCount = @@ROWCOUNT;
RETURN
--End Sproc


/* 2 pts
2.  Execute the above stored procedure for the Québec region. Make sure to display
        the value of the output parameter. You must set up a variable to hold the OUTPUT parameter, execute 
		the procedure and then use a Print statement to display the value of the OUTPUT parameter to the 
		Message window. */
        
 --Call
DECLARE @RegionOut int;
EXEC uspSupplierRegion 
	 @Region = 'Québec',
	 @RegionCount = @RegionOut OUTPUT
PRINT 'Customers in Region: ' + CAST(@RegionOut AS varchar);


/* 5 pts
3.  First: write an insert statement to insert yourself into the Employees table with a hiredate of today's date.
     Second: Write a Select statement that will retrieve all the Employees who were hired after '1/1/1993' 
		that have not ever sold anything (that means they do not have an order in the orders table).
		Hint:  please review left joins as necessary.  

*/

INSERT INTO Employees
	(FirstName, LastName, HireDate)
VALUES('Whitney', 'King', '6/6/2015');
GO

SELECT FirstName
	 , LastName
	 , HireDate
FROM Employees
	 LEFT JOIN Orders 
		ON Employees.EmployeeID = Orders.EmployeeID
WHERE HireDate > '1/1/1993'
	  AND Orders.EmployeeID IS NULL;
GO


/* 2 pts
4. Create a new permanent table called SuppliersTest that has the same schema (same columns, same 
      datatypes) as the Suppliers table.  Populate the new table with a copy of the rows from the existing 
      Suppliers table. When you are finished the data in the SuppliersTest table should be the same as the data 
      in the Suppliers table.  You must accomplish this task using only one single SQL statement. The
	  Create table statement canNOT be used. 

	  Include a statement to drop your table.
*/

IF OBJECT_ID (N'SuppliersTest', N'U') IS NOT NULL
	DROP TABLE  SuppliersTest
GO

SELECT *
INTO SuppliersTest
FROM Suppliers;
GO

/* 5 pts
5. List all orders for the month of December 1997 that do NOT contain a line item for 
      product 59, "Raclette Courdavault". List the Order ID, Order Date, Customer ID 
      and Customer Name for each order.  (Note: Your answer will have 45 rows, assuming you have made
	  no significant, permanent changes to Northwind's Products, Customers and Orders tables.)
*/

SELECT DISTINCT Orders.OrderID
	 , OrderDate
	 , Orders.CustomerID
	 , ContactName
FROM Orders JOIN Customers
	ON Orders.CustomerID = Customers.CustomerID
		JOIN [Order Details] 
			ON Orders.OrderID = [Order Details].OrderID
WHERE (OrderDate BETWEEN '12-1-1997' AND '12-31-1997') AND
	  ([Order Details].OrderID NOT IN (SELECT OrderID
									   FROM [Order Details] 
									   WHERE ProductID LIKE '59'));
GO


/*  5 pts
6.   Your boss gives you an assignment: Find our best selling product.  You ask questions and determine that the boss would
			really like to see the top 5 best selling products and that by "best selling" he means those who have the most number of
			sales (ie., Orders), and not those that have sold the most quantity of products.
*/

SELECT TOP 5 ProductName, COUNT(Orders.OrderID) AS Orders
FROM Orders
	JOIN [Order Details] 
		ON Orders.OrderID = [Order Details].OrderID
	JOIN Products
		ON [Order Details].ProductID = Products.ProductID
GROUP BY ProductName
ORDER BY Orders DESC;
GO


/* 5 pts
7. Consider order # 10248. Write a script below that will:
	* write the select statement to list this order in the Orders table
	* write another separate select statement to list all line items for Order 10248 in the Order Details table. 
	* Write a statement to begin a transaction.  
	* Write statement(s) to delete order 10248 and all its line items.
	* Write two statements: one to commit the transaction (comment that one out) and one to rollback the transaction
   */

SELECT *
FROM Orders
WHERE OrderID = '10248';
GO

SELECT *
FROM [Order Details]
	JOIN Orders
		ON [Order Details].OrderID = Orders.OrderID
WHERE [Order Details].OrderID = '10248';
GO

BEGIN TRANSACTION

DELETE FROM [Order Details]
WHERE OrderID = '10248';
GO

DELETE FROM Orders
WHERE OrderID = '10248';
GO

ROLLBACK TRANSACTION;
--COMMIT TRANSACTION;


/* 8 pts
 8. (You had to know this was coming :-) )
		
		Turn your script in the previous question (#7) into a stored procedure that will take any order number as its parameters and then
		delete and remove any and all associated line items.

		Include a print message that indicates the sproc has completed successfully.

		Include error handling (try-catch blocks) within the procedure to catch the error if the deletes do not succeed. 
		As always include proper commenting.

		Include a call to your sproc that will also use Try-Catch to handle any errors thrown
*/

--Drop Sproc
IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name= 'uspDeleteOrders')
	DROP PROC uspDeleteOrders;
GO

--Begin Sproc
CREATE PROCEDURE uspDeleteOrders
	@OrderID int
AS
	--Attempt delete
	BEGIN TRY
		DELETE FROM [Order Details]
		WHERE OrderID = @OrderID;

		DELETE FROM Orders
		WHERE OrderID = @OrderID;

		PRINT 'Successfully deleted OrderID: ' + CAST(@OrderID AS varchar);
	END TRY
	--Catch delete error
	BEGIN CATCH
		THROW 50001, 'Not a valid OrderID!', 1;
	END CATCH
--End Sproc


--Begin call
BEGIN TRANSACTION

BEGIN TRY
	EXEC uspDeleteOrders '10248'
END TRY
BEGIN CATCH
	PRINT 'There was a problem deleting the record requested. Sproc may not exist.'
END CATCH

ROLLBACK TRANSACTION
--COMMIT TRANSACTION
--End call


/* 3 pts
9.  Create a query that lists customer names together with the first date
			  that they placed an order.  Note:  You only need to include customers who
			  have actually placed orders.   Include CustomerID, CustomerName and first
			  order date as columns in your view. 
*/

SELECT Customers.CustomerID, ContactName, MIN(OrderDate) AS FirstOrderDate
FROM Customers
	JOIN Orders 
		ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, ContactName
ORDER BY ContactName;
GO


/* 3 pts
10.  a) Create a view from the query in question 9.  
        b) Write a simple Select statement that uses this view to retrieve customers placing orders prior to 2-15-1999.
*/

--Drop View
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vFirstOrders')
	DROP VIEW vFirstOrders
GO

--Create View
CREATE VIEW vFirstOrders
AS
SELECT Customers.CustomerID
	 , ContactName
	 , MIN(OrderDate) AS FirstOrderDate
FROM Customers
	JOIN Orders 
		ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, ContactName
GO

SELECT CustomerID, ContactName, FirstOrderDate
FROM vFirstOrders
WHERE FirstOrderDate > '2-15-1999'
GO

/* 2 pts
11. Write a single query that creates a phone list of all Suppliers, Customers, and Employees with
		only two columns:  Name and Phone.  
*/

SELECT ContactName, Phone
FROM Suppliers
UNION
SELECT ContactName, Phone
FROM Customers
UNION
SELECT FirstName + ' ' + LastName AS ContactName, HomePhone AS Phone
FROM Employees;
GO


/* 5 pts
 12.  Write a Select statement that displays all Northwind products.  Use a Case to add an extra column to the output 
        that indicates categories of pricing using the following categorization:

		when UnitPrice < 50.00 then 'small ticket'
		when UnitPrice < 150.00 then 'medium ticket'
		when UnitPrice < 250.00 then 'large ticket'
		else 'big ticket'

		
*/

SELECT ProductID
	 , ProductName
	 , CASE 
		  WHEN UnitPrice < 50.00 THEN 'Small Ticket'
		  WHEN UnitPrice < 150.00 THEN 'Medium Ticket'
		  WHEN UnitPrice < 250.00 THEN 'Large Ticket'
		  ELSE 'Big Ticket'
	   END AS TicketType
FROM Products;
GO









      
      





