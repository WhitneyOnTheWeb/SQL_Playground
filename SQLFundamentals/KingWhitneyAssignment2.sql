--*  BUSIT 103           Assignment   #2              DUE DATE:  Consult course calendar
							
/*	You are to develop SQL statements for each task listed. You should type your SQL statements under each task.
	The fields' names are written as if a person is asking you for the report. You will need to look at the data
	and understand that list price is in the ListPrice field, for example.
	Add comments to describe your reasoning when you are in doubt about something. 
	To find the tables that contain the fields that are requested, consider creating a Database Diagram
	that includes only the tables from the SalesLT schema and referring to it. */

/*	Submit your .sql file named with your last name and first name and assignment # (e.g., GriggsDebiAssignment2.sql). 
	Submit your file to the instructor using through the course site.  */

--		Do not remove the USE statement. 
USE AdventureWorksLT2012;

--1.	(2) List all customers.  Include all data about each customer. "All data" means to include all
--		the fields. Use * in this statement. 

SELECT *
FROM SalesLT.Customer;

--2.	(4) List the company name, first name, and last name of each customer in alphabetical order by company name. 

SELECT CompanyName, FirstName, LastName
FROM SalesLT.Customer
ORDER BY CompanyName;

--3.	(4) List the company name, first name, last name, and sales person for each customer in alphabetical order 
--		by last name, then by first name, and then by company.  Hint: There will be one SELECT statement 
--		with three fields in the ORDER BY clause. Do not change the order of the fields in the SELECT clause. 

SELECT CompanyName, FirstName, LastName, SalesPerson
FROM SalesLT.Customer
ORDER BY LastName, FirstName, CompanyName;

--4.	(3) List only the sales person and show each sales person only one time. 

SELECT DISTINCT SalesPerson
FROM SalesLT.Customer;

--5.	(3) List all products by product number.  Include all data about each product. 
--		"All data" means to include all the fields. 

SELECT *
FROM SalesLT.Product
ORDER BY ProductNumber;

--6.	(4) List all products showing product ID, product name, product number, product model id,
--		product category ID. Sort by product category Id and then by product number. Do not change
--		the order of the fields in the SELECT clause.

SELECT ProductID, Name, ProductNumber, ProductModelID, ProductCategoryID
FROM SalesLT.Product
ORDER BY ProductCategoryID;

--7.	(4) List all products showing product ID, product name, color, standard cost and list price 
--		ordered by highest to lowest list price. 
 
 SELECT ProductID, Name, Color, StandardCost, ListPrice
 FROM SalesLT.Product
 ORDER BY ListPrice desc;

--8.	(4) List the product models of AdventureWorks products.  List each model id only once 
--		and sort in order from lowest to highest. Note: AdventureWorks is the name of the business
--		for which we are creating these SELECT statements; AdventureWorks owns the database.

SELECT DISTINCT ProductModelID
FROM SalesLT.Product
ORDER BY ProductModelID;

--9.  	(4) List the colors of AdventureWorks products.  List each color only once and in alphabetical order. 
--		We will learn to deal with NULL in the next module, so NULL will show in the list of colors.

SELECT DISTINCT Color
FROM SalesLT.Product
ORDER BY Color;

--10.	(3) List all addresses by country.  Include all data about each address. "All data" means to 
--		include all the fields. 

SELECT *
FROM SalesLT.Address
ORDER BY CountryRegion;

--11.	(4) List the unique city, state/province, country/region, and postal code and sort alphabetically by 
--		country/region, state/province and city. Note: Write this in one SELECT statement and do not change
--		the order of the fields in the SELECT clause. Note: Unique means to show one time. When there is more
--		than one field, each combination of fields (each row) will be unique (will not be repeated). 

SELECT DISTINCT City, StateProvince, CountryRegion, PostalCode
FROM SalesLT.Address
ORDER BY CountryRegion, StateProvince;

--12.	List the unique state/province and country/region and order alphabetically by country/region and
--		state/province. (4) Note: Write this in one SELECT statement and do not change
--		the order of the fields in the SELECT clause.

SELECT DISTINCT StateProvince, CountryRegion
FROM SalesLT.Address
ORDER BY CountryRegion, StateProvince;

--13.	(3) List all orders from the SalesLT.SalesOrderDetail table from highest to lowest   
--		on order quantity. Include all data related to each order. 

SELECT *
FROM SalesLT.SalesOrderDetail
ORDER BY OrderQty desc;

--14.	(4) List customer IDs for all customers that have placed orders with AdventureWorks.
--		Hint: The customer id will show in the SalesOrderHeader table ONLY if the customer
--		has placed an order. Use the SalesLT.SalesOrderHeader table and show each customer ID
--		only once even if the customer has placed multiple orders. Sort by customer id.
--		Recall that the order of the results is not guaranteed without a Order By clause.

SELECT DISTINCT CustomerID 
FROM SalesLT.SalesOrderHeader
ORDER BY CustomerID;