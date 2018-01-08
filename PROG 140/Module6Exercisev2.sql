/*
PROG 140          Module 6 Assignment   
POINTS 50              DUE DATE :  Consult module
							
Develop a SQL statement for each task listed.  This exercise uses the Northwind database.

Please type your SQL statement under each task below.  Ensure your statement works by testing it prior to turning it in
When writing answers for your select statements please keep in mind that there is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your ability, 
in the best way possible to suit their needs. For example, consider the best way to sort, to name columns, etc. 
These are things you must think about on the job!

***As always, if you have any questions about this assignment please double-check the discussion areas first! Please send an e-mail
or call the instructor if you still need clarification.  If you are unable to get something working after trying your best and attempting
to get help, then please note your difficulty and indicate that you know your answer doesn't work and what your issues were.***
 
Turn In:

For this exercise you will submit one  WORD documents (instead of a .sql file) in which you have copied and pasted 
your entire work from your .sql file including all assignment questions and your SQL queries. 
The  document should contain your name at the top, assignment title, the date and any difficulties encountered. 


Submit your file to the instructor using the Canvas Assignment tool. 
*/

-- Tasks:  

/*
1.  Using the uspInsertOrder stored procedure from our demo file, Sprocs_UDFS.sql, as a 
	 model, write a stored procedure to UPDATE an order in the Northwind database. Your sproc should update
	 only one row each time it is called. Add approriate documentation at the top of your stored procedure as you've 
	 done in earlier assignments and any additional comments inside the sproc as you feel are needed for clarity. 

	 Also include the following statements AFTER your sproc:
	 * write the call to the stored procedure 
	 * include a drop statement 
	 * include a statement to retrieve and display the row updated by the sproc 
*/
-- write your SQL statements here: 

/* Description: Handles Insertion of new invoices into the NW database 
	Author: Whitney King
	Created: 5/21/2015
	Modified:

	Input Objects:	Tables: Orders
	Objects Modified:  [Orders] table

	Return Value(s):  OrderID

*/
USE Northwind

-- drop statement
DROP PROC uspUpdateOrder

-- begin sproc
CREATE PROC uspUpdateOrder
	@OrderID int OUTPUT,
	@CustomerID nchar(5),
	@EmployeeID [int] = NULL,
	@OrderDate datetime = NULL,
	@RequiredDate datetime = NULL,
	@ShippedDate datetime = NULL,
	@ShipVia int = 1,  -- may have a primary shipper
	@Freight money = NULL,
	@ShipName nvarchar(40) = NULL,
	@ShipAddress nvarchar(60) =NULL,
	@ShipCity nvarchar(15) = NULL,
	@ShipRegion nvarchar(15) =NULL,
	@ShipPostalCode nvarchar(10) =NULL,
	@ShipCountry nvarchar(15) =NULL

AS
	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
		THROW 50001, 'Invalid Order Number Provided', 1;
	IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
		THROW 50002, 'Invalid Customer Provided', 1;
	
	IF EXISTS(SELECT 1 FROM Orders WHERE OrderID = @OrderID)
		UPDATE Orders
		SET CustomerID = IsNull(@CustomerID, CustomerID), 
			EmployeeID = IsNull(@EmployeeID, EmployeeID), 
			OrderDate = IsNull(@OrderDate, OrderDate),
			RequiredDate = IsNull(@RequiredDate, RequiredDate), 
			ShippedDate = IsNull(@ShippedDate, ShippedDate), 
			ShipVia = IsNull(@ShipVia, ShipVia),
			Freight = IsNull(@Freight, Freight), 
			ShipName = IsNull(@ShipName, ShipName), 
			ShipAddress = IsNull(@ShipAddress, ShipAddress), 
			ShipCity = IsNull(@ShipCity, ShipCity), 
			ShipRegion = IsNull(@ShipRegion, ShipRegion), 
			ShipPostalCode = IsNull(@ShipPostalCode, ShipPostalCode), 
			ShipCountry = IsNull(@ShipCountry, ShipCountry)
		WHERE OrderID = @OrderID
-- end sproc

-- the call:

DECLARE @Order int = 11077;
EXEC uspUpdateOrder
	 @CustomerID = 'RATTC',
	 @EmployeeID = 4,
	 @Freight = 10.65,
	 @ShipAddress = '21422 29th Ave S',
	 @OrderID = @Order OUTPUT;
	 SELECT * FROM Orders WHERE OrderID = @Order;

/*
2.  Using the uspInsertOrder stored procedure from our demo file, Sprocs_UDFS.sql, as a 
	 model, write a stored procedure to Insert a new row into a child table, ie., the "many" table
	 in a 1-many relationship, in YOUR database, ie., the db you've submitted in previous exercises.  

	 Also include the following statements AFTER your sproc:
	 * write the call to the stored procedure 
	 * include a drop statement 
	 * include a statement to retrieve and display the row updated by the sproc 

	 Note: please include a "use databasename" statement so that I can identify your database
	 from a previous exercise.  If I can use your sproc easily in your last submission of your 
	 database, then you can send only the code for the Insert sproc you will create above.
	 If not, please contact me and/or send a separate file with a script of your database that I can use in order to test this sproc. 

*/
-- write your SQL statements here: 

USE HobbyStore

-- drop statement
DROP PROC uspInsertOrder


-- begin sproc
CREATE PROC uspInsertOrder
	@EmpID int,
	@CustID int,
	@ProdID int
AS
	IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmpID = @EmpID)
		THROW 50001, 'Invalid Employee ID Provided', 1;
	IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustID = @CustID)
		THROW 50002, 'Invalid Customer ID Provided', 1;
	IF NOT EXISTS(SELECT 1 FROM Products WHERE ProdID = @ProdID)
		THROW 50002, 'Invalid Product ID Provided', 1;
	
	INSERT Orders (EmpID, CustID, ProdID)
	VALUES (@EmpID, @CustID, @ProdID)
	RETURN @@Identity
-- end sproc


-- the call:
Declare @Ret int
EXEC  @Ret = uspInsertOrder 2, 1, 2;
If @ret = 0 
	print 'ERROR!';
else 
	print 'OrderID Entered: ' + cast(@ret as varchar);
	SELECT * FROM Orders WHERE OrderID = @Ret;

/*
3. Write a Scalar UDF, called fnYearMonth that will take any date as an input parameter and return
    that same date in the following format:  YYYY-MMM  example:  2012-Dec  (4 digits for the year, a hyphen, and 3 characters for the Month)
	Note:  the Return will be in varchar format, NOT date format
	Hint: there is a similar example in our module's demo file

	Include at least 3 statements to test this new UDF with different dates
*/
-- write your SQL statements here: 

DROP FUNCTION fnYearMonth

--begin function
CREATE FUNCTION fnYearMonth (
	-- parameteres
	@InputDate date
)
RETURNS varchar(8)
AS
BEGIN
	-- return variable
	DECLARE @RetDate varchar(8)

	-- T-SQL statements to compute the return value 
	SET @RetDate = DateName(yy, @InputDate) + '-' + LEFT(DateName(mm, @InputDate), 3);

	-- Return the result of the function
	RETURN @RetDate
END
GO
--end function

-- f(x) statements

-- 1

DECLARE @Date varchar(8)
SET @Date = dbo.fnYearMonth('12/21/2015')
PRINT @Date;
GO

DECLARE @Date varchar(8)
SET @Date = dbo.fnYearMonth('1/1/1999')
PRINT @Date;
GO

--2

SELECT EmpLastName, 
	   EmpFirstName, 
	   EmpHireDate, 
	   dbo.fnYearMonth(EmpHireDate) AS HireDateYearMonth
FROM Employees;
GO

--3

SELECT EmpLastName, 
	   EmpHireDate, 
	   dbo.fnYearMonth(EmpHireDate) AS HireDateYearMonth
FROM Employees
Order By HireDateYearMonth, EmpLastName;
GO

/*
4. Consider the following actual view in the Northwind database:

 ------------------------
create view [dbo].[Sales by Category] AS
SELECT Categories.CategoryID, Categories.CategoryName, Products.ProductName, 
	Sum("Order Details Extended".ExtendedPrice) AS ProductSales
FROM 	Categories INNER JOIN 
		(Products INNER JOIN 
			(Orders INNER JOIN "Order Details Extended" 
			ON Orders.OrderID = "Order Details Extended".OrderID) 
		ON Products.ProductID = "Order Details Extended".ProductID) 
	ON Categories.CategoryID = Products.CategoryID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GROUP BY Categories.CategoryID, Categories.CategoryName, Products.ProductName
-----------------------

a) Describe what this view does as though you are speaking to a technical member of your team. Include a description of the "Order details Extended" object.

	------------------------------------------------------------------------------------------------------------------------------------------------------------
	This will create a view to select and display sales date by category. Specifically it will take the CategoryID, CategoryName, ProductName and the sum of
	the extended price from another view (Order Details Extended, which displays the price extended for each individual item sold) for all orders placed in 1997.

	It then groups the results by category ID, category name and product name, resulting in a sum of sales for each product sold, as well as the category name
	and ID it  belongs to.
	-------------------------------------------------------------------------------------------------------------------------------------------------------------

b) Rewrite this view as a simple table-valued function (NOT a multi-statement) and give it the
	name fnSalesbyCategory.  This function will have a single parameter to provide a Category that will allow you
	to parameterize the call like this:
		Select * from dbo.fnSalesbyCategory('Seafood');
c) Include at least two statements that call this function.

*/
-- write your SQL statements here: 

USE Northwind

-- drop function
DROP FUNCTION fnSalesbyCategory

-- begin function
CREATE FUNCTION fnSalesByCategory (
	@ProductCategory nvarchar(15)
)
RETURNS TABLE
RETURN (
	SELECT Categories.CategoryID, 
		   Categories.CategoryName, 
		   Products.ProductName, 
		   Sum("Order Details Extended".ExtendedPrice) AS ProductSales
	FROM   Categories INNER JOIN 
			 (Products INNER JOIN 
			    (Orders INNER JOIN "Order Details Extended" 
				   ON Orders.OrderID = "Order Details Extended".OrderID) 
			    ON Products.ProductID = "Order Details Extended".ProductID) 
			 ON Categories.CategoryID = Products.CategoryID
	WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
		  AND @ProductCategory = Categories.CategoryName
	GROUP BY Categories.CategoryID, 
			 Categories.CategoryName, 
			 Products.ProductName
)
-- end function

-- f(x) statements

SELECT * 
FROM dbo.fnSalesbyCategory('Seafood');
GO

--1

SELECT SUM(ProductSales) AS ProductSales 
FROM dbo.fnSalesbyCategory('Beverages');
GO

--2

SELECT ProductName, 
	   SUM(ProductSales) AS ProductSales 
FROM dbo.fnSalesbyCategory('Condiments')
GROUP BY ProductName;
GO

/*
5.  Review and then execute the following query: 

	select lastname, employees.employeeid, count(*) TotalOrders
	from employees join orders
	on employees.employeeid = orders.employeeid
	group by lastname, employees.employeeid

	select count (*) from orders
	select top 100 * from orders

	Using the Pivot example from the end of our module's demo sql file as a guide, 
	pivot this result set so that the lastnames are the columns
*/
-- write your SQL statements here: 

-- I found the instructions for this questions to be very vague and a little bit confusing, but I believe this is along the lines of what you're looking for.
-- I did note that another field like OrderDate could be included toi break down the numbers further, but that didn't seem to be necessary for this portion.

USE Northwind

-- drop temp table (if needed)

DROP TABLE #EmployeeSalesTemp

-- begin CTE
WITH EmployeeSalesCTE AS (
	SELECT LastName,  
		   CustomerID
	FROM Employees JOIN Orders
	ON employees.employeeid = orders.employeeid
)
SELECT * INTO #EmployeeSalesTemp
FROM EmployeeSalesCTE

-- begin pivot
SELECT * FROM #EmployeeSalesTemp
PIVOT (
	Count(CustomerID)
	FOR LastName IN ([Leverling], [Peacock])
)
AS p


/* OPTIONAL extra credit:
    from #2 above add both uspDeleteXXXX and uspUpdateXXXX routines for 3 points each to YOUR database. (where XXXX represents
	a table in your database). 
	
	Attempt this extra credit ONLY if you are sure that all of the #1-5 answers you've provided are correct 
	to the best of your ability and you have tested them to the best of your ability.
	Extra credit will not be given if you have not fully tested the first 5 to ensure they work correctly.

*/
-- write your SQL statements here: 

-- delete

	USE HobbyStore

	-- drop statement
	DROP PROC uspDeleteOrder

	-- begin sproc
	CREATE PROC uspDeleteOrder
		@OrderID int
	AS
		IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
			THROW 50001, 'Invalid Order ID Provided', 1;
	
		DELETE FROM Orders
		WHERE OrderID = @OrderID
		RETURN @@Identity
	-- end sproc


	-- the call:
	Declare @Ret int
	EXEC  @Ret = uspDeleteOrder 6
	If @ret = 0 
		PRINT 'ERROR!';
	ELSE 
		PRINT 'OrderID Deleted: ' + CAST(@ret as varchar);
	
	SELECT * FROM Orders WHERE OrderID = @Ret;
	SELECT * FROM Orders;

-- update

	USE HobbyStore

	-- drop statement
	DROP PROC uspUpdateOrder


	-- begin sproc
	CREATE PROC uspUpdateOrder
		@OrderID int OUTPUT,
		@EmpID int,
		@CustID int,
		@ProdID int
	AS
		IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmpID = @EmpID)
			THROW 50001, 'Invalid Employee ID Provided', 1;
		IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustID = @CustID)
			THROW 50002, 'Invalid Customer ID Provided', 1;
		IF NOT EXISTS(SELECT 1 FROM Products WHERE ProdID = @ProdID)
			THROW 50002, 'Invalid Product ID Provided', 1;
	
		UPDATE Orders
		SET EmpID = ISNULL(@EmpID, EmpID),
		    CustID = ISNULL(@CustID, CustID),
			ProdID = ISNULL(@ProdID, ProdID)
		WHERE OrderID = @OrderID
	-- end sproc

	-- the call:
	DECLARE @Order int = 2;
	SELECT * FROM Orders WHERE OrderID = @Order;
	EXEC uspUpdateOrder
		 @EmpID = 2,
	     @CustID = 2,
		 @ProdID = 2,
		 @OrderID = @Order OUTPUT;
	SELECT * FROM Orders WHERE OrderID = @Order;