/*  
Name:  Whitney King
Date:  4/11/2015

PROG 140          Module 1 Assignment   
POINTS 50         DUE DATE :  Consult course calendar
							
Do not attempt this assignment until you have either attended the lecture (on-campus course) or
watched the videos (online course) for this module and also have read and studied the appropriate section in our text!

Develop a SQL statement for each task listed.  This exercise uses the Northwind database.
You must create and use a database diagram for the Northwind database.  You do not have to turn in the diagram. 

Please type your SQL statement under each task below.  Ensure your statement works by testing it prior to turning it in
When writing answers for your select statements please keep in mind that there often is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your 
ability, in the best way possible to suit their needs. For example, consider the best way to sort, to name columns, etc. 
Please state any special assumptions you may have made in your decisions if you feel these are relevant. 
These are things you must think about on the job! 
 
Turn In:

For this exercise you will submit one  WORD documents (instead of a .sql file) in which you have copied and pasted 
your entire work from your .sql file including all assignment questions and your SQL queries. 
The  document should contain your name at the top, assignment title, the date and any difficulties encountered. 

Submit your file to the instructor using the Canvas Assignment tool.  
 
*/

Use Northwind
-- Tasks:  

/*
1.  Retrieve the customers from Mexico, Madrid and Sao Paulo. The list should include only
the company name, company contact person, and phone. Rename the columns in the output 
so that they are more readable to a business user.
*/
-- write your sql statement here:

-- Students: I will answer this first one for you as an example of how I would like you to answer questions in our assignments!  -- Mary
-- please notice that in the following answer:
-- 1) all of the columns are well-named using aliasing
-- 2) the query uses an Order by clause to sort the result set
-- 3) the query itself is easy to read because it is nicely formatted rather than all on one line and messy :-)

SELECT c.CompanyName AS [Company]
, c.ContactName AS [Contact Name]
, c.Phone AS [Phone Number]
FROM Customers c 
WHERE c.Country = 'Mexico' or c.City = 'Sao Paulo' or c.City = 'Madrid'
ORDER BY c.CompanyName

-- it is also important to note that the customer mixed both cities and countries in his/her request.  It is up to the 
-- developer (you) to know the data well enough to give the user the correct result set!  Now the rest of the answers are up to you!

/*
2.  A business user from a team you support asks you:

"Can you please get me a list of our current Products that are priced between 20 and 25 dollars?
I need to know how many of each of these are in stock and how many are on order. "

Write two queries to perform this.  One using a range query with comparison operators and the other using "between"


*/
-- write your sql statements here:

SELECT p.ProductName AS [Product Name]
, p.UnitPrice AS [Unit Price]
, p. UnitsInStock AS [# in Stock]
, p.UnitsOnOrder [# on Order]
FROM Products AS p
WHERE p.UnitPrice >= 20 
	  AND p.UnitPrice <= 25
ORDER BY p.ProductName

SELECT p.ProductName AS [Product Name]
, p.UnitPrice AS [Unit Price]
, p. UnitsInStock AS [# in Stock]
, p.UnitsOnOrder [# on Order]
FROM Products AS p
WHERE p.UnitPrice BETWEEN 20 AND 25
ORDER BY p.ProductName

/*
3.  
a)
	Create a table called Recycle in the Northwind database using the following criteria for the columns:

	RecycleID: primary key, integer, 
	RecycleType: nchar(10), nulls not allowed
	RecycleDescription nvarchar(100), null allowed

b)
	Write insert statements so that the table is loaded with the following values:

	RecycleID:  1
	RecycleType: Compost
	RecycleDescription:  Product is compostable, instructions included in packaging

	RecycleID: 2
	RecycleType:  Return
	RecycleDescription:  Product is returnable to company for 100% reuse

	RecycleID: 3
	RecycleType: Scrap
	RecycleDescription:  Product is returnable and will be reclaimed and reprocessed

	RecycleID: 4
	RecycleType: None
	RecycleDescription: Product is not recycleable

c) Ensure that you have inserted data correctly by writing the SQL statement to retrieve all data (all columns and all rows) from this table. 
d) Write a statement to remove (drop) the table from the database
*/
-- write your sql statements here:

DROP TABLE Recycle
GO

CREATE TABLE Recycle
	(RecycleID int IDENTITY(1,1)
		CONSTRAINT PK_Recycling PRIMARY KEY,
	 RecycleType nchar(10) NOT NULL,
	 RecycleDescription nvarchar(100))

INSERT INTO Recycle
	(RecycleType, RecycleDescription)
VALUES ('Compost', 'Product is compostable, instructions included in packaging')

INSERT INTO Recycle
	(RecycleType, RecycleDescription)
VALUES ('Return', 'Product is returnable to company for 100% reuse')

INSERT INTO Recycle
	(RecycleType, RecycleDescription)
VALUES ('Scrap', 'Product is returnable and will be reclaimed and reprocessed')

INSERT INTO Recycle
	(RecycleType, RecycleDescription)
VALUES ('None', 'Product is not recycleable')

SELECT *
FROM Recycle

--------------------------------------------------------
-- Joins and Unions
--------------------------------------------------------

/*  
4.  Starting with the query from question 1 add the OrderDate and ShippedDate
columns from the Orders table (Note: this will require a two table join. Also don't be surprised that you will  
have more rows in the result set now because you will have added information for the Customers orders!)
*/
-- write your sql statement here:

SELECT c.CompanyName AS [Company]
, c.ContactName AS [Contact Name]
, c.Phone AS [Phone Number]
, o.OrderDate AS [Order Date]
, o.ShippedDate AS [Ship Date]
FROM Customers AS c 
	JOIN Orders AS o 
		ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Mexico' or c.City = 'Sao Paulo' or c.City = 'Madrid'
ORDER BY c.CompanyName

/*  
5.  Starting with the query from question 4 add the Shippers ID and Shippers name
columns from the Shippers table (Note: this will NOT add more rows to your result set). 
*/
-- write your sql statement here:

SELECT c.CompanyName AS [Company]
, c.ContactName AS [Contact Name]
, c.Phone AS [Phone Number]
, o.OrderDate AS [Order Date]
, o.ShippedDate AS [Ship Date]
, s.ShipperID AS [Shipper ID]
, s.CompanyName AS [Shipper Name]
FROM Customers AS c 
	JOIN Orders AS o 
		ON c.CustomerID = o.CustomerID
	JOIN Shippers AS s
		ON o.ShipVia = s.ShipperID
WHERE c.Country = 'Mexico' or c.City = 'Sao Paulo' or c.City = 'Madrid'
ORDER BY c.CompanyName

/*  
6.  Starting with the query from question 1 write a query that counts the total
     Orders for each company.  You will need only the columns from question 1.
	 (Hint: This will require a two table join. You will use the Count aggregate, and you will
	 group by company name, contactname and phone.)
*/
-- write your sql statement here:

SELECT c.CompanyName AS [Company]
, c.ContactName AS [Contact Name]
, c.Phone AS [Phone Number]
FROM Customers AS c 
WHERE c.Country = 'Mexico' or c.City = 'Sao Paulo' or c.City = 'Madrid'
ORDER BY c.CompanyName

/*  
7.  Your boss asks you if we have any customers that have not ever
actually purchased anything as yet and if so to give her a list of them. 
Please write a query to answer this question. 
(Hint: This will be a two-table Left join!!)
*/
-- write your sql statement here:

SELECT c.CompanyName AS [Company]
, c.ContactName AS [Contact Name]
, c.Phone AS [Phone Number]
FROM Customers AS c
	LEFT JOIN Orders AS o
		ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL

/*  
8.  Your team needs a phone list of Shippers and Suppliers. Write a single
query for this. Include only the Shipper and Supplier IDs and their names and phone numbers
Therefore, your list will have a total of 3 columns. (Hint:  Union!)
*/
-- write your sql statement here:

SELECT s.CompanyName AS [Company Name]
, s.Phone AS [Phone Number]
FROM Shippers AS s
UNION
SELECT s.CompanyName AS [Company Name]
, s.Phone AS [Phone Number]
FROM Suppliers AS s
ORDER BY [Company Name]

/*  
9.  Consider the following SQL statement:

select * from SalesDetail;

Assume this statement is syntactically correct and that there is a database and table 
that this will run correctly against. Assume this database is for a very successful store with 
hundreds of thousands of daily sales.  Do you have any thoughts or issues with running this 
query regularly?

*/
-- write your answer here (please write in a comment delimited by /*  and */):

/*  If I were working in operations for a large retailer, I do not believe it would be a good idea to run 
the above query to select all rows from a Sales Detail table. This type of table would contain millions
upon millions of rows, as I would assume the granularity of this type of table to be one item per row, 
instead of something like a Sales Header table, which would contain one order per row. In either case, 
in a giant corporate retailer, either of these table would have potentially millions of rows, so it 
would be a good idea to get a better understand of what you are trying to query for specifically to 
filter down the results to something less processor intensive. Running it infrequently might not hurt 
in the long run (still not a great idea), but it's defintiely not something that anyone with access to 
the tables would want to run regularly. */

/*  
10.  Consider the following SQL statement:

SELECT VendorName, AccountDescription, COUNT(*) AS LineItemCount,
       SUM(InvoiceLineItemAmount) AS LineItemSum
FROM Vendors JOIN Invoices
   ON Vendors.VendorID = Invoices.VendorID
 JOIN InvoiceLineItems
   ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID
 JOIN GLAccounts
   ON InvoiceLineItems.AccountNo = GLAccounts.AccountNo
GROUP BY VendorName, AccountDescription
ORDER BY VendorName, AccountDescription;

Please do your best explain in your own words what this query does. Explain as though you are talking to a 
co-worker who is a non-technical member of your team.  You DO NOT need to run this query!  Try to explain
by analyzing the sql code alone. 

*/
-- write your answer here (please write in a comment delimited by /*  and */):

/*  This query is taking information from three different subject areas that are all tied together through
being related to our vendor invoice process. We're taking information about our vendors, joining it to descr-
iptive information about the account, and then joining that to details about the specific invoices that have
been generated in relation to that vendor.

In addition to pulling the vendor name and account description directly from the tables in the database, 
we're using aggregate functions in order to obtain a count of how many items that vendor has purchased, as
well as the total summed dollar amount of the items purchased by the vendor.

Finally, we're grouping and sorting the output information by vendor name and account description, which will
ensure that the aggregated count and sum are specific to each individual vendor, and that the information is 
displayed in alphabetical order by vendor.

*/