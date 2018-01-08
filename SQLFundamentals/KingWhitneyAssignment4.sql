--*  BUSIT 103           Assignment   #4              DUE DATE:  Consult course calendar
							
/*	You are to develop SQL statements for each task listed. You should type your SQL statements under each task. 
	You should test each SQL statement using the database shown in the USE statement. The SQL statement should 
	execute against that database without errors. */

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment4.sql). 
	Submit your file to the instructor using through the course site.  Do not zip the file. */

--Do not remove the USE statement
USE AdventureWorksLT2012;

--1.  (4) Use the SalesLT.Address table to list addresses in the United States. Select the address1, 
--    city, state/province, country/region and postal code. Sort by state/province and city.

SELECT AddressLine1,  
	   City, 
	   StateProvince, 
	   CountryRegion, 
	   PostalCode
FROM SalesLT.Address
WHERE CountryRegion='United States'
ORDER BY StateProvince asc, City asc

--2.  (5) Use the SalesLT.Address table to list addresses in the US states of Idaho or Illinois. 
--    Select the address1, city, state/province, country/region and postal code. Sort by state/province and city.

SELECT AddressLine1,  
	   City, 
	   StateProvince, 
	   CountryRegion, 
	   PostalCode
FROM SalesLT.Address
WHERE StateProvince IN ('Idaho', 'Illinois')
ORDER BY StateProvince asc, City asc

--3.	(4) Use the SalesLT.Address table to list addresses in the cities of Victoria or Vancouver. 
--		Select the address1, city, state/province, country/region and postal code.
--		Order the list by city.

SELECT AddressLine1,  
	   City, 
	   StateProvince, 
	   CountryRegion, 
	   PostalCode
FROM SalesLT.Address
WHERE City IN ('Victoria', 'Vancouver')
ORDER BY City asc

--4.	(5) Use the SalesLT.Address table to list addresses in the cities of Victoria or Vancouver in the 
--		Canadian province of British Columbia. Select the address1, city, state/province, country/region 
--		and postal code. Order the list by city.

SELECT AddressLine1,  
	   City, 
	   StateProvince, 
	   CountryRegion, 
	   PostalCode
FROM SalesLT.Address
WHERE StateProvince='British Columbia'
	  AND City IN ('Victoria', 'Vancouver')
ORDER BY City asc

--5.	(4) List the company name and phone for those customers whose phone number contains the following sequence: 34.
--		Order the list by phone number in ascending order. "Contains" means that the sequence exists within the phone number.

SELECT CompanyName, 
	   Phone
FROM SalesLT.Customer
WHERE Phone LIKE '%34%'
ORDER BY Phone asc

--6.	(4) List the name, product number, size, standard cost, and list price in alphabetical order by name 
--		for Products whose standard cost is $1500 or more. Show all money values at exactly two decimal places. 
--		Be sure to give each derived column an alias.

SELECT Name,
	   ProductNumber,
	   Size,
	   '$  ' + CAST(CAST(StandardCost AS DECIMAL(10,2)) AS CHARACTER) AS StandardCost,
	   '$  ' + CAST(CAST(ListPrice AS DECIMAL(10,2)) AS CHARACTER) AS ListPrice
FROM SalesLT.Product
WHERE StandardCost >= '1500'
ORDER BY Name asc

--7.	(4) List the name, product number, size, standard cost, and list price in alphabetical order by name 
--		for Products whose list price is $100 or less and standard cost is $40 or more.

SELECT Name,
	   ProductNumber,
	   Size,
	   '$  ' + CAST(CAST(StandardCost AS DECIMAL(10,2)) AS CHARACTER) AS StandardCost,
	   '$  ' + CAST(CAST(ListPrice AS DECIMAL(10,2)) AS CHARACTER) AS ListPrice
FROM SalesLT.Product
WHERE StandardCost >= '40'
	  AND ListPrice <= '100'
ORDER BY Name asc

--8.	(4) List the name, standard cost, list price, and size for products whose size is one of the 
--		following:  XS, S, M, L, XL. Show all money values at exactly two decimal places. Be sure to 
--		give each derived column an alias. Order the list by name in alphabetical order.

SELECT Name,
	   '$  ' + CAST(CAST(StandardCost AS DECIMAL(10,2)) AS CHARACTER) AS StandardCost,
	   '$  ' + CAST(CAST(ListPrice AS DECIMAL(10,2)) AS CHARACTER) AS ListPrice,
	   Size
FROM SalesLT.Product
WHERE Size IN('XS', 'S', 'M', 'L', 'XL')
ORDER BY Name asc

--9.	(4) List the name, product number, and sell end date for all products in the Product table
--		that are not currently sold. Sort by the sell end date from most recent to oldest date. Show   
--		only the date (no time) in the sell end date field. Be sure to give each derived column an alias.

SELECT Name,
	   ProductNumber,
	   CAST(SellEndDate AS DATE) AS SellEndDate
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL
ORDER BY SellEndDate desc, ProductNumber asc, Name asc

--10.  (6) List the name, product number, standard cost, list price, and weight for products whose standard cost  
--    is less than $50, list price is greater than $100, and weight is greater than 1,000. Round money values 
--    to exactly 2 decimal places and give each derived column a meaningful alias. Sort by weight.

SELECT Name,
	   ProductNumber,
	   '$  ' + CAST(CAST(StandardCost AS DECIMAL(10,2)) AS CHARACTER) AS StandardCost,
	   '$  ' + CAST(CAST(ListPrice AS DECIMAL(10,2)) AS CHARACTER) AS ListPrice,
	   Weight
FROM SalesLT.Product
WHERE StandardCost < '50'
	  AND ListPrice > '100'
	  AND Weight > '1000'
ORDER BY Weight asc

--11. In a and b below, explore the data to better understand how to locate products. 

--a.  (3) List the name, product number, and product category ID for all products in the Product 
--    table that include 'bike' in the name. Sort by the name. 
--    Something to consider: How many of these products are actually bikes?

SELECT Name,
	   ProductNumber,
	   ProductCategoryID
FROM SalesLT.Product
WHERE Name LIKE '%bike%'
ORDER BY Name asc

--// None of these products actually appear to be bikes - WK

--b.  (3) List the name and product category id, and parent id for all categories in the product category   
--    table that include 'bike' in the name. Sort by the parent product category id. 
--    Something to consider: How many of these product categories are actually bikes? What is the  
--	  ProductCategoryID for Bikes? 
	
SELECT (Name + ' - ' + CAST(ProductCategoryID AS CHAR)) AS ProductID,
	   ParentProductCategoryID
FROM SalesLT.ProductCategory
WHERE Name LIKE '%bike%'
ORDER BY ParentProductCategoryID asc

--// There are three bikes and the Bike Category Listed, which is ParentProductCategoryID 1 - WK


--//Export Query:  
SELECT ProductID,
	   CAST(Name AS CHAR(50)) AS ProductName,
	   CAST(StandardCost AS DECIMAL(10,2)) AS StandardCost,
	   CAST(ListPrice AS DECIMAL(10,2)) AS ListPrice
FROM SalesLT.Product
WHERE ListPrice > '2000'
ORDER BY ListPrice desc