/*  PROG 140          Module 2 Assignment #2


SQL PRACTICE
							
Develop a SQL statement for each task listed.  This exercise uses the Northwind database.

Please type your SQL statement(s) under each task below.  
When writing answers for your Select statements please keep in mind that there is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your 
ability, in the best way possible to suit the needs of the customer. For example, consider the best way to sort, to name columns, etc. 

 
Turn In:

You will NOT turn in this assignment. Instead, please:
1) FIRST study all the module materials including the readings and watching all videos. 
2) Then study the questions below and then carefully and attempt to answer all of these on your own 
3) Then look at the answers file provided within the module (Module2ExerciseAnswers.sql) to see examples of how these could be 
	 answered keeping in  mind that there is often more than one way to get the same answer so if your answer retrieved the exact 
	 same results then yours may or may not be better!
	 Use the Discussion area to compare answers with your colleagues in our course, ie., other students and your instructor!
4) Only after you have fully studied by doing all of the above then take the QUIZ for this module and you should do well! 
 
*/
Use Northwind
-- Tasks:  

/*
1.  
Consider the following summary query (aggregate) that returns the Average Unit Price
for a Product in the Products table: 

			Select avg(unitprice) from Products


	a.	Create a query that lists all products in the Products table and has the following columns:
		ProductName, SupplierID, UnitPrice, and a column containing the Average Unit price 
		that uses the query above as a subquery. In other words you will  use the query above to create a column that is a
		standard (non-correlated) subquery in the column list of your Select clause. Be sure to name this column something
		appropriate and be sure to order your query appropriately.


*/
-- write your sql statement here:

SELECT ProductName
, SupplierID
, UnitPrice
, (SELECT CONVERT(DECIMAL(10,2), AVG(UnitPrice)) 
   FROM Products) AS AvgUnitPrice
FROM Products
ORDER BY  UnitPrice desc, ProductName asc

/*
2.  
	Write a query will find all the products that have a unitprice that is less than the 
	average unitprice of all products.  
	Hint: this query should use a non-correlated subquery within the 
	where clause. 
	Second Hint: The same summary query from step 1 should be the subquery in the where clause.  
*/
-- write your sql statements here:

SELECT ProductName
, UnitPrice
, (SELECT CONVERT(DECIMAL(10,2), AVG(UnitPrice)) 
   FROM Products) AS AvgUnitPrice
FROM Products
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM Products)
ORDER BY  UnitPrice DESC, ProductName ASC

/*
3.  Write a query that returns a single column. The query should return the EmployeeID's 
     of all Employees that live in the UK
*/
-- write your sql statement here:

SELECT EmployeeID 
FROM Employees 
WHERE Country = 'UK'
ORDER BY EmployeeID ASC

/*  
4.  Write a query that uses the query from question 3 in a subquery within the Where clause
	 to answer the following question:
	 "Which Orders were sold by Employees from the UK?".  For your answer you need only 
	 provide the OrderID for orders that qualify. 
	 Hint:  Use the IN operator in your Where clause.
*/
-- write your sql statement here:

SELECT OrderID
FROM Orders
WHERE EmployeeID IN 
	(SELECT EmployeeID 
	 FROM Employees 
	 WHERE Country = 'UK')
ORDER BY OrderID ASC

/*  
5.  Rewrite your answer to #4 as an inner join between the Employees and Orders table, however in this answer 
add the following columns:
		Employee ID, Employee's Last name,  OrderID, and  Order date
 (Hint: Be sure to double-check that your query returns the same number of rows as #4)
*/
-- write your sql statement here:

SELECT Employees.EmployeeID
, LastName
, FirstName
, OrderID
, OrderDate
FROM Orders
	JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
WHERE Employees.Country = 'UK'
ORDER BY OrderID ASC, LastName ASC, EmployeeID ASC

/*  
6.  Write a query that retrieves the lastname, birthdate and hiredate of all of the employees 
		and removes the time stamp so that only the date shows for both the birthdate and hiredate columns.
*/
-- write your sql statement here:

SELECT LastName
, CAST(BirthDate AS Date) AS BirthDate
, CAST(HireDate AS Date) AS HireDate
FROM Employees
ORDER BY LastName ASC

/*  
7.  a) Write the code to create a simple View that is a subset of the Employees table and that does not include  
	       columns that contain personal information such as address info, phone and birthdate.
	 b)  Include a select statement (using a filter and sort of your choosing) that uses this view.
	 c)  Include code to drop the view you created in 7a.
*/
-- write your sql statements here:

--DROP VIEW SecureEmployeeView
--CREATE VIEW SecureEmployeeView AS
	--SELECT EmployeeID
	--, FirstName
	--, LastName
	--, Title
	--, HireDate
	--FROM Employees

SELECT LastName
, Title
FROM SecureEmployeeView
WHERE Title LIKE 'Sales%'
ORDER BY LastName ASC

/*  
8.   a) What is a temp table in SQL?  (Please use your own words to describe it in comments below) then,
      A table made by a query in order to help provide data needed to pass for another part of another query, which is stored in the TempDB
	  b) Write a Select-Into statement that creates a temp table that is a subset of the Employees table and 
		  that does not include  columns that contain personal information including all address info, phone and birthdate 
		  (yes the same query, essentially that you used for the view in question 7). 
	  c) Include a Select statement to retrieve data from the temp table from step 8b with a sort and filter of your choosing. 
	  d) Write the code to drop the temp table you created in 8b. 
*/
-- write your answer and sql statement here:

SELECT EmployeeID
, FirstName
, LastName
, Title
, HireDate
INTO #TempSecureEmployeeView
FROM Employees

SELECT LastName
, Title
FROM #TempSecureEmployeeView
WHERE Title LIKE 'Sales%'
ORDER BY LastName ASC

DROP TABLE #TempSecureEmployeeView;
/*  
9.  Explain what the following query does -- consider that you are speaking to 
		a new member of your team who is a sql programmer:

		with USSuppliersCTE
		as 
		(
		select ProductID, ProductName, Suppliers.Country, suppliers.Supplierid, Suppliers.CompanyName
		from Products join Suppliers on Products.SupplierID = Suppliers.SupplierID
		where Suppliers.Country = 'USA'
		)
		Select CompanyName, count(ProductID) as ProductCount
		from USSuppliersCTE
		Group by CompanyName
		Order by ProductCount desc


		-- write your answer here:

*/
WITH USSuppliersCTE
	AS 
	(
	SELECT ProductID
	, ProductName
	, Suppliers.Country
	, suppliers.SupplierID
	, Suppliers.CompanyName
	FROM Products 
		JOIN Suppliers 
			ON Products.SupplierID = Suppliers.SupplierID
	WHERE Suppliers.Country = 'USA'
	)
SELECT CompanyName
, COUNT(ProductID) AS ProductCount
FROM USSuppliersCTE
GROUP BY CompanyName
ORDER BY ProductCount DESC;
 -- This query is first pulling a list of all suppliers in the USA, and then using that information to provide us information about
 -- the number of products sold by each company specific to the US.
/*  
10.  Rewrite the CTE from question 9 so that it lists companies and their product counts for companies that are
		NOT US Suppliers.
*/
-- write your sql statement here:

