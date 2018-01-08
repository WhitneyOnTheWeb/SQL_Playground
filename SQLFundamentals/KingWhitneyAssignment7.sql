--*  BUSIT 103				Assignment   #7					 DUE DATE :  Consult course calendar
							
/*	You are to develop SQL statements for each task listed. You should type your SQL statements  
	under each task. You are required to use the INNER JOIN syntax to solve each problem. INNER JOIN is 
	ANSI syntax. Even if you have prior experience with joins, you will still use the INNER JOIN  
	syntax and refrain from using any OUTER or FULL joins in modules introducing INNER JOINs. */

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment6.sql). 
	Submit your file to the instructor using through the course site.  */

/*	Ideas for consideration: Run the statement in stages: Write the SELECT and FROM clauses first 
	and run the statement. Add the ORDER BY clause. Then add the WHERE clause; if it is a compound
	WHERE clause, add piece at a time. Lastly perform the CAST or CONVERT. When the statement is 
	created in steps, it is easier to isolate the error. Check the number of records returned 
	to see if it makes sense.*/

/*  When there are multiple versions of a field, such as EnglishCountryRegionName, 
	SpanishCountryRegionName, FrenchCountryRegionName, use the English version of the field.*/

--	Do not remove the USE statement
USE AdventureWorksDW2012; 

--1.a.	(4) List the names and locations of AdventureWorks customers who are male.   
--		Show customer key, first name, last name, state name, and country name. Order the list  
--		by country name, state name, last name, and first name in alphabetical order.
--		Check your results. Did you get 9,351 records? 

SELECT dc.CustomerKey, dc.FirstName, dc.LastName, g.StateProvinceName, 
	   g.EnglishCountryRegionName AS CountryName
FROM dbo.DimCustomer AS dc
	 INNER JOIN dbo.DimGeography AS g
		ON dc.GeographyKey = g.GeographyKey
WHERE dc.Gender = 'M'
ORDER BY g.EnglishCountryRegionName asc, g.StateProvinceName asc, 
		 dc.LastName asc, dc.FirstName asc

-- Yes, there are 9.351 records showing

--1.b.	(2) Copy/paste the statement from 1.a to 1.b. Modify the WHERE clause in 1.b to show only  
--		those AdventureWorks customers who are female and from the US City of Birmingham. 
--		Show customer key, first name, last name, and city name.
--		Change the sort order to list by last name, then first name in alphabetical order.

SELECT dc.CustomerKey, dc.FirstName, dc.LastName, 
	   g.City
FROM dbo.DimCustomer AS dc
	 INNER JOIN dbo.DimGeography AS g
		ON dc.GeographyKey = g.GeographyKey
WHERE dc.Gender = 'F'
	  AND g.EnglishCountryRegionName = 'United States' 
	  AND g.City = 'Birmingham'
ORDER BY dc.LastName asc, dc.FirstName asc

--1.c.	(2) Copy/paste statement from 1.b to 1.c. Modify the WHERE clause in 1.c to list only   
--		AdventureWorks customers from the US city of Seattle who are female and have 2 or more cars. 
--		Show customer key, first name, last name, and total number of cars. 
--		Order the list by number of cars in descending order, then by last name and first name 
--		in alphabetical order.

SELECT dc.CustomerKey, dc.FirstName, dc.LastName, dc.NumberCarsOwned
FROM dbo.DimCustomer AS dc
	 INNER JOIN dbo.DimGeography AS g
		ON dc.GeographyKey = g.GeographyKey
WHERE dc.Gender = 'F'
	  AND g.EnglishCountryRegionName = 'United States' 
	  AND g.City = 'Seattle'
	  AND dc.NumberCarsOwned >= '2'
ORDER BY dc.NumberCarsOwned desc, dc.LastName asc, dc.FirstName asc

--2.a.	(2) Explore the data warehouse using ONLY the DimProduct table. No joins required.
--		Show the English product name, product key, product alternate key, standard cost, list price,
--		and status. Sort on English product name. Notice that some of the products appear to be duplicates. 
--		The name and the alternate key remain the same but the product is added again with a new product  
--		key to track the history of changes to the product attributes. For example, look at AWC Logo Cap. 
--		Notice the history of changes to StandardCost and ListPrice and to the value in the Status field.

SELECT p.EnglishProductName, p.ProductKey, p.ProductAlternateKey, p.StandardCost, p.ListPrice, p.Status
FROM dbo.DimProduct AS p
ORDER BY p.EnglishProductName asc

-- Noted

--2.b.	Write two SELECT statements (no joins required) using the DimProduct table and write down  
--		the row count returned when you run the statement in the place below where you see "List row count..." 
--		1. Show the product key, English product name, and product alternate key for each product only once.
--		Sort on English product name.
--		2. Show the English product name and product alternate key for each product only once. Sort on English product
--		name. Recall terms like “only once”, “one time”, and "unique" all indicate the need for the DISTINCT keyword.
--		(1) List row count for the results set for 1. (606 row(s) affected)
--		(2) List row count for the results set for 2. (504 row(s) affected)

--1
SELECT DISTINCT p.ProductKey, p.EnglishProductName, p.ProductAlternateKey
FROM dbo.DimProduct AS p
ORDER BY p.EnglishProductName asc

--2
SELECT DISTINCT p.EnglishProductName, p.ProductAlternateKey
FROM dbo.DimProduct AS p
ORDER BY p.EnglishProductName asc

--2.c.	(4) Join tables to the product table to also show the category and subcategory name for each product.
--		Show the English category name, English subcategory name, English product name, and product alternate key
--		only once. Sort the results by the English category name, English subcategory name,  
--		and English product name. The record count will decrease to 295. Some products in the product  
--		table are inventory and not for sale. They don't have a value in the ProductSubcategory field and 
--		are removed from the results set by the INNER JOIN. We will explore this more in OUTER JOINs.

SELECT DISTINCT pc.EnglishProductCategoryName, 
				ps.EnglishProductSubcategoryName, 
				p.EnglishProductName, p.ProductAlternateKey
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.DimProductSubCategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 INNER JOIN dbo.DimProductCategory AS pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY pc.EnglishProductCategoryName asc, 
		 ps.EnglishProductSubcategoryName asc, 
		 p.EnglishProductName

--3.a.	(5) List the English name for products purchased over the Internet by customers who indicate education  
--		as high school or partial high school. Show Product key and English Product Name and English Education.   
--		Order the list by English Product name. Show a product only once even if it has been purchased several times.   
--		We are not interested in the customer names because we are looking only at the broad demographics of buyers.

SELECT DISTINCT p.ProductKey, p.EnglishProductName, c.EnglishEducation
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
ORDER BY p.EnglishProductName asc

--This was a little confusing, but after reading your clarifiation on the discussion boards, I believe this is correct.

--3.b.	(3) List the English name for products purchased over the Internet by customers who indicate 
--		high school or partial high school, or partial college. Show Product key and English Product Name   
--		and English Education. Order the list by English Product name and then by English Education.
--		Show a product only once even if it has been purchased several times. 

SELECT DISTINCT p.ProductKey, p.EnglishProductName, 
				c.EnglishEducation
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
WHERE c.EnglishEducation IN ('High School', 'Partial High School', 'Partial College')
ORDER BY p.EnglishProductName asc, 
		 c.EnglishEducation asc

--4.	(5) List the English name for products purchased over the Internet by customers who work in clerical,  
--		manual, or skilled manual occupations. Show Product key and English Product Name and English Occupation. 
--		Add a meaningful sort. Show a product only once even if it has been purchased several times.

SELECT DISTINCT p.ProductKey, p.EnglishProductName, 
				c.EnglishOccupation
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
WHERE c.EnglishOccupation IN ('Clerical', 'Manual', 'Skilled Manual')
ORDER BY p.EnglishProductName asc, 
		 c.EnglishOccupation asc

--	Question 5 contains exploratory questions. You may wish to read all three questions before beginning. 
--	Seeing the purpose of the questions may help understand the requests. 

--5.a.	(6) List customers who have purchased clothing over the Internet.  Show customer first name, 
--		last name, and English product category. If a customer has purchased clothing items more than once,
--		show only one row for that customer. This means that the customer should not appear twice.
--		Order the list by last name, then first name. Did you return 6,839 records in your results set?

SELECT DISTINCT c.FirstName, c.LastName, 
				pc.EnglishProductCategoryName
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
	 INNER JOIN dbo.DimProductSubCategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 INNER JOIN dbo.DimProductCategory AS pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE pc.EnglishProductCategoryName = 'Clothing'
ORDER BY c.LastName asc, c.FirstName asc

-- Yes, (6839 row(s) affected)

--5.b.	(2) Copy/paste 5.a to 5.b and modify 5.b.  Show customer key, first name, last name, and English 
--		product category. If a customer has purchased clothing more than once, show only one row for that customer.
--		This means that the customer should not appear twice. Order the list by last name, then first name. 

SELECT DISTINCT c.CustomerKey, c.FirstName, c.LastName, 
				pc.EnglishProductCategoryName
FROM dbo.DimProduct AS p
	 INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
	 INNER JOIN dbo.DimProductSubCategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 INNER JOIN dbo.DimProductCategory AS pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE pc.EnglishProductCategoryName = 'Clothing'
ORDER BY c.LastName asc, c.FirstName asc

--5.c.	BONUS +2 Why is there a difference between the number of records received in 5a and 5b? 
--		To be eligible for the bonus your answer MUST show as a COMMENT and it must be detailed
--		enough to show that you understand why customers are "missing" from 5a. Be brief. 
--		This is actually a simple answer. 
 
 -- In 5a, customers that have the same name but are different people are treated as the same person (such as Jordan Adams), whereas adding the CustomerKey
 -- ensures that uniqure customers are identified and listed even if they have the same name as someone else.

--6.	(6) List all Internet sales for accessories that occurred during 2008 (Order Date in 2008).  
--		Show Order date, product key, product name, and sales amount for each line item sale.
--		Show the date as mm/dd/yyyy as DateOfOrder. Use CONVERT and look up the style code.
--		Show the list in oldest to newest order by date and alphabetically by product name.
--		21,067 Rows	

SELECT CONVERT(VARCHAR(10),i.OrderDate,101) AS DateOfOrder, i.ProductKey, 
	   p.EnglishProductName,
	   i.SalesAmount
FROM dbo.FactInternetSales AS i
	 INNER JOIN dbo.DimProduct AS p
		ON i.ProductKey = p.ProductKey
WHERE YEAR(i.OrderDate) = '2008'
ORDER BY i.OrderDate asc, p.EnglishProductName asc

--7.	(5) List all Internet sales of clothing to Accessories in Paris, France during 2008.  
--		Show product key, product name, order date as mm/dd/yyyy, SalesAmount, and City for each line item sale. 
--		Show the list in order alphabetically by product name. If you add fields to verify the results
--		be sure to remove or comment out the fields before submitting the homework. 

SELECT i.ProductKey,
	   p.EnglishProductName,
	   CONVERT(VARCHAR(10),i.OrderDate,101) AS DateOfOrder, i.SalesAmount,
	   g.City
FROM dbo.FactInternetSales AS i
	 INNER JOIN dbo.DimProduct AS p
		ON i.ProductKey = p.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
	 INNER JOIN dbo.DimGeography AS g
		ON c.GeographyKey = g.GeographyKey
	 INNER JOIN dbo.DimProductSubcategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 INNER JOIN dbo.DimProductCategory AS pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE YEAR(i.OrderDate) = '2008'
	  AND g.City = 'Paris'
	  AND g.CountryRegionCode = 'FR'
	  AND pc.EnglishProductCategoryName IN ('Clothing', 'Accessories')
ORDER BY p.EnglishProductName asc

--8.	(2) In your own words, write a business question that you can answer by querying the data warehouse.
--		Then write the SQL query using an INNER JOIN that will provide the information that you are seeking.
--		Try it. You get credit for writing a question and trying to answer it. 

-- How many bikes were purchased from Great Britain in 2008?

SELECT i.ProductKey,
	   p.EnglishProductName,
	   CONVERT(VARCHAR(10),i.OrderDate,101) AS DateOfOrder,
	   pc.EnglishProductCategoryName
FROM dbo.FactInternetSales AS i
	 INNER JOIN dbo.DimProduct AS p
		ON i.ProductKey = p.ProductKey
	 INNER JOIN dbo.DimCustomer AS c
		ON i.CustomerKey = c.CustomerKey
	 INNER JOIN dbo.DimGeography AS g
		ON c.GeographyKey = g.GeographyKey
	 INNER JOIN dbo.DimProductSubcategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 INNER JOIN dbo.DimProductCategory AS pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE YEAR(i.OrderDate) = '2008'
	  AND pc.EnglishProductCategoryName = 'Bikes'
	  AND g.CountryRegionCode = 'GB'
ORDER BY i.OrderDate desc

-- (726 row(s) affected)