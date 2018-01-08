/*
Whitney King
PROG 140          Module 8 Assignment   
POINTS 50         DUE DATE :  Consult module
							
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

/*
12 pts
1.  From our video (and PPT) on Performance, list 3 QUERY Performance tips and give query examples and explanations 
     of how/why they will help performance:

*/
-- list your answers here:

/*		~ Use TRUNCATE instead of DELETE when clearing data out of a table. This will keep the table structure, but wipe the data clean
		  while being minimally logged in the system, which saves system resources and execution time.

		  Use Northwind
		  TRUNCATE TABLE Customers
		  GO


		~ When selecting all of the data from a particular table, it is more efficient and faster to select rows from the system indexes
		  than it is to use the conventional SELECT COUNT(*) FROM TABLE query style. This works better because it's only looking at the metadata
		  for the table count instead of running a query against all of the rows and calculating the count.

		  USE Northwind
		  SELECT rows
		  FROM sysindexes
		  WHERE id= OBJECT_ID('Customers') AND indid < 2


		~ Use JOIN instead of subqueries whenever you're able to (and it's a good idea to go a step further and also limit nesting as well). 
		  Subqueries are a powerful tool, but can end up causing a lot of additional resources during the query execution process when executing
		  separate queries and then marrying the data together. SQL Servers optimization engine is tuned best for joins, and this type of query
		  formatting runs inherently better.

		  SELECT Customers.CustomerID, OrderID
		  FROM Customers 
			JOIN Orders 
				ON Customers.CustomerID = Orders.CustomerID

*/

/*
15 pts
2.  Consider the following 4-table-join query (we looked at this in Module 1!):

		select s.ShipperID, s.CompanyName, o.OrderID, o.ShippedDate,
					e.EmployeeID, e.Lastname, o.CustomerID, c.CompanyName
		from Shippers s 
			join Orders o on s.ShipperID = o.ShipVia
			join Employees e on e.EmployeeID = o.EmployeeID
			join Customers c on c.Customerid = o.Customerid
		Order by ShipperID, ShippedDate desc

		Perform the following steps:
		1)  Display an estimated execution plan (Highlight the query, go to your Query menu, select "Display Estimated Execution Plan")
		2)  Study the execution plan - write it down, make a screenshot, look up what the icons mean, so that you understand this as much as you can.  
		3)  Execute the following code to create an index:
		
					CREATE NONCLUSTERED INDEX idxOrdersShipVia
						ON [dbo].[Orders] ([ShipVia])
						INCLUDE ([OrderID],[CustomerID],[EmployeeID],[ShippedDate])

		4)  Do step #1 again, ie., display the estimated execution plan 
		5)  Discuss below how the index changed (or did not change) the execution plan for the query.  Discuss whether or not you 
		     think this index should be permanently implemented on the Northwind database. Use the course discussion area for this module 
		     to get input from other students. 
*/
-- list your answers here:

/*
			In the first execution plan, the query was executed by merging the clustered PK Indexes  of Shippers and Orderson a hash match, then using nonclustered indexes to match in
			hashes for Employees (last name) and Customers (company name). Once the data is married together, the sorting is processed and the select is displayed.

			In the second execution plan, all of the indexes were nonclustered. Instead of using the primary key of the Orders table as an index, the new index we created idxOrdersShipVia
			was used, and they were matched through a nested loop instead of a hash match. This seems to use less processing for the beginning of the query, but towards the end, the hash
			matches and sorting of the data take up more of the process.

			In this case, I think the first execution plan works for our purposes just fine, and the new index isn't absolutely necessary, but depending on where you want to allocate
			resources, it might not hurt as an alternative in the future.  Northwind is fairly small, so I don't really think it requires more complicated indexes than it currenly
			has, but something large scale, maybe this type of reindexing would prove valuable.
*/

/*
15 pts
3.  Write code below using the Northwind database that will:
	
		a)  Create a transaction
		b)  Write a query to perform an update on the [order details] table that will add 10% to all 
			  unit prices. 
		c)  Create a save point after the query in b)
		d)  Write a query to to perform an update on the Products table that will add $2.00 to all unit prices
		e)  Write the statement to rollback to the save point
		f)   Right under the statement in e), Write a statement that rolls back to the beginning of the 
		      Transaction. 

*/
-- list your answers here:
USE Northwind

BEGIN TRANSACTION

SELECT * FROM [Order Details]
GO

UPDATE [Order Details]
SET UnitPrice = UnitPrice * 1.1
GO

SAVE TRANSACTION derp
GO

SELECT * FROM Products
GO

UPDATE Products
SET UnitPrice = UnitPrice + 2
GO

ROLLBACK TRANSACTION derp
GO

SELECT * FROM [Order Details]

ROLLBACK
GO

/*
8 pts
4.
You have a colleague that is executing some work in a transaction on the 
Customers table. She is running her transaction with an isolation level of Serializable.
You need to run a quick query for your boss that groups and counts all customers by their 
Country.  Write the query below that will execute (and not be blocked):
*/
-- list your answers here:

USE Northwind
SELECT Country, COUNT(CustomerID) AS [Customer Count] 
FROM Customers WITH (NoLOCK)
GROUP BY Country
ORDER BY [Customer Count] DESC
GO