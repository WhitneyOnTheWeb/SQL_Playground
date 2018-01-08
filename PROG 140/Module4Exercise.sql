/*  PROG 140          Module 4 Assignment   
POINTS 50              DUE DATE :  Consult course calendar
							
Develop a SQL statement for each task listed.  This exercise uses the Northwind database.

Please type your SQL statement under each task below.  Ensure your statement works by testing it prior to turning it in
When writing answers for your select statements please keep in mind that there is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your 
ability, in the best way possible to suit their needs. For example, consider the best way to sort, to name columns, etc. 
These are things you must think about on the job!
 
Turn In:

For this exercise you will submit two separate WORD documents (instead of a .sql file) in which you have copied and pasted 
your entire work from your .sql files including all assignment questions and your SQL queries. The first file will have the
answers to Questions 1-5 and the second file will be a script as described in Questions 6-10.
The first document should contain your name at the top, assignment title, the date and any difficulties encountered. The
second will be as described in Questions 6-10 below. 

Submit your files together to the instructor using the Canvas Assignment tool. 
 

Author:  Whitney King  |  PROG 140  |  May 6, 2015
 
*/

-- Tasks:  

/*
1.  Declare two variables of type Float. Set their values to 12 and 78, respectively.  Write a SQL statement to multiply these two values together and 
	 then add them to the literal numeric value 80:  12 * 78 + 80.  Your result will be 1016.  Write both a Print and a Select statement to display 
	 the result of your calculation
*/
-- write your sql statements here:

DECLARE @val1 FLOAT = 12,
		@val2 FLOAT = 78;

SELECT CAST(((@val1 * @val2) + 80) AS varchar) AS [Select Result];
PRINT CAST(((@val1 * @val2) + 80) AS varchar);
GO

/*
2.  Declare a table variable that has the same first four columns as the Orders table, ie., OrderID, CustomerID, EmployeeID, OrderDate.  
	 Name it "OrdersCopy". Use a single Insert statement to load this table variable with all Orders that were shipped by "Speedy Express".  Write a select statement
	 to print the contents of this table variable. 
	
*/
-- write your sql statements here:
USE Northwind

DECLARE @Orders TABLE
(OrderID int,
 CustomerID nvarchar(20),
 EmployeeID int,
 OrderDate datetime
)

INSERT INTO @Orders (OrderID, CustomerID, EmployeeID, OrderDate)
	SELECT OrderID, CustomerID, EmployeeID, OrderDate
	FROM Orders
	WHERE ShipVia = 1;

SELECT *
FROM @Orders;

/*
3.  What will be the result of this statement?  
		Declare @x int = 12;
		Print 'Result ' + @x

*/
-- write your answer here:
PRINT 'Msg 245, Level 16, State 1, Line 75';
PRINT 'Conversion failed when converting the varchar value "Result " to data type int.';

/*  
4.  Rewrite the code in Step #3 so that it still uses both a single Declare Statement and a single Print statement but has a correct result. 
*/
-- write your sql statements here:
DECLARE @x int = 12;
PRINT 'Result ' + CAST((@x) AS nvarchar);

/*  
5.  Declare a string variable and set it's value equal to "Tokyo Traders". Write a query that uses your 
		variable and joins the Products and Suppliers table to retrieve all Products for Supplier "Tokyo Traders" but write it 
		so that the query won't run if the supplier "Tokyo Traders" does not exist in the Suppliers table. 
*/
-- write your sql statements here:
DECLARE @Supplier nvarchar(20) = 'Tokyo Traders';

IF EXISTS (SELECT CompanyName FROM Suppliers WHERE CompanyName = @Supplier)
	SELECT *
	FROM Products
		JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
	WHERE CompanyName = @Supplier
ELSE SELECT 'Supplier does not exist'

/*  
6.  through 10.

	Create a SQL script and in this script place all your statements from the last exercise (Module 3 #1-6) for creating and loading your database.
	This script MUST include the following elements:

	*  Your name, date, and a brief description of the contents and purpose of your script SQL comments at the top bracketed by /* */.
	*  A check near the beginning of your script to determine whether the database you're creating exists and if so to drop it.
	*  At least 3-4 "print" statements within the script that include the date and time and that will be executed as the script progresses
	    to demonstrate its progress
	*  Appropriate commenting with organized and neat statements
	*  Simple Try-Catch error handling - similar to what was demonstrated and used in the CreateandLoadTestingDB.sql file included in this module's files. 
*/
-- write your sql statement in a separate file and then copy/paste as usual into a Word doc and submit. You will 
-- be submitting two Word files:  one for questions 1-5 and the other for this script, ie., questions 6-10.  
-- DO NOT place your statements here! 




