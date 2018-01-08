--*  BUSIT 103				Assignment   #10				DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment10.sql). 
	Submit your file to the instructor using through the course site.  */

--  It is your responsibility to provide a meaningful column name for the return value of the function.
--  These statements will NOT use GROUP BY or HAVING. Those keywords are introduced in the next module. One cell 
--	results sets (one column and one row) do not need to have an ORDER BY clause.

--	Recall that sales to resellers are stored in the FactResellerSales table and sales to customers are stored in
--	the FactInternetSales table. 

--	Do not remove the USE statement
USE AdventureWorksDW2012;

-- 1.a.	(3) Find the count of customers who are married. Be sure give each derived field 
--		an appropriate alias.

SELECT COUNT(*) AS 'Married Customers'
FROM dbo.DimCustomer AS c
WHERE c.MaritalStatus LIKE 'M'

--1.b.	(2) Check your result. Write queries to determine if the answer to 1.a. is correct.
--		You should be writing proofs for all of your statements.

SELECT *
FROM dbo.DimCustomer AS c
WHERE c.MaritalStatus LIKE 'M'

--1.c.	(3) Find the total children (sum) and the total cars owned (sum) for customers who are married.

SELECT SUM(c.TotalChildren) AS 'Total Children', SUM(c.NumberCarsOwned) AS 'Total Cars Owned'
FROM dbo.DimCustomer AS c
WHERE c.MaritalStatus LIKE 'M'
   
--1.d.	(2) Find the total children, total cars owned, and average yearly income for customers who are married.

SELECT SUM(c.TotalChildren) AS 'Total Children', SUM(c.NumberCarsOwned) AS 'Total Cars Owned', 
	   CAST(AVG(c.YearlyIncome) AS DECIMAL(10,2)) AS 'Avg. Yearly Income'
FROM dbo.DimCustomer AS c
WHERE c.MaritalStatus LIKE 'M'

--2.a.	(2) List the total dollar amount (SalesAmount) for sales to Resellers. Round to two decimal places.

SELECT CAST(SUM(r.SalesAmount) AS DECIMAL(12,2)) AS 'Total Reseller Sales'
FROM dbo.FactResellerSales AS r

--Proof:

SELECT CAST(r.SalesAmount AS DECIMAL(10,2)) AS 'SalesAmount'
FROM dbo.FactResellerSales AS r
ORDER BY r.SalesAmount desc

--2.b.	(3) List the total dollar amount (SalesAmount) for 2008 sales to resellers in Germany.
--		Show only the total sales--one row, one column--rounded to two decimal places. 

SELECT CAST(SUM(r.SalesAmount) AS DECIMAL(12,2)) AS 'Total Reseller Sales'
FROM dbo.FactResellerSales AS r
WHERE r.OrderDateKey LIKE '2008%'
	  AND r.SalesTerritoryKey = '8'

--Proof:

SELECT CAST(r.SalesAmount AS DECIMAL(10,2)) AS 'SalesAmount'
FROM dbo.FactResellerSales AS r
WHERE r.OrderDateKey LIKE '2008%'
	  AND r.SalesTerritoryKey = '8'
ORDER BY r.SalesAmount desc

--3.a.	(2) List the total dollar amount (SalesAmount) for sales to Customers. Round to two decimal places.

SELECT CAST(SUM(i.SalesAmount) AS DECIMAL(12,2)) AS 'Total Customer Sales'
FROM dbo.FactInternetSales AS i

--Proof:

SELECT CAST(i.SalesAmount AS DECIMAL(10,2)) AS 'SalesAmount'
FROM dbo.FactInternetSales AS i

--3.b.  (3) List the total dollar amount (SalesAmount) for 2005 sales to customers located in the 
--		United Kingdom. Show only the total sales--one row, one column--rounded to two decimal places. 

SELECT CAST(SUM(i.SalesAmount) AS DECIMAL(12,2)) AS 'Total Customer Sales'
FROM dbo.FactInternetSales AS i
WHERE i.OrderDateKey LIKE '2005%'
	  AND i.SalesTerritoryKey = '10'

--Proof:

SELECT CAST(i.SalesAmount AS DECIMAL(10,2)) AS 'SalesAmount'
FROM dbo.FactInternetSales AS i
WHERE i.OrderDateKey LIKE '2005%'
	  AND i.SalesTerritoryKey = '10'
ORDER BY i.SalesAmount desc

--4.	(4) List the average unit price for a touring bike sold to customers. Round to
--		two decimal places.

SELECT CAST(AVG(i.UnitPrice) AS DECIMAL(10,2)) AS 'Avg. Touring Bike Price'
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
WHERE p.ProductSubcategoryKey = '3'

--Proof:

SELECT CAST(i.UnitPrice AS DECIMAL(10,2)) AS 'UnitPrice'
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
WHERE p.ProductSubcategoryKey = '3'
ORDER BY i.UnitPrice desc

--5.	(5) List bikes that have a list price less than the average list price for all bikes.
--		Show product key, English product name, and list price.
--		Order descending by list price.

SELECT DISTINCT p.ProductKey, p.EnglishProductName, CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice'
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
WHERE p.ProductSubcategoryKey IN ('1', '2', '3')
	  AND p.ListPrice < (SELECT AVG(p.ListPrice) FROM dbo.DimProduct AS P)
ORDER BY ListPrice desc

--Proof:

SELECT CAST(AVG(p.ListPrice) AS DECIMAL(10,2)) AS 'Avg. Bike List Price'
FROM dbo.DimProduct AS P
WHERE p.ProductSubcategoryKey IN ('1', '2', '3')

--6.	(4) List the lowest list price, the average list price, the highest list price, and product count for road bikes.

SELECT CAST(MIN(p.ListPrice) AS DECIMAL(10,2)) AS 'Lowest Price', 
	   CAST(AVG(p.ListPrice) AS DECIMAL(10,2)) AS 'Avg. Price', 
	   CAST(MAX(p.ListPrice) AS DECIMAL(10,2)) AS 'Highest Price',
	   COUNT(*) AS 'Total Road Bikes'
FROM dbo.DimProduct AS p
WHERE p.ProductSubcategoryKey = '2'

--Proof:

SELECT p.EnglishProductName, CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice'
FROM dbo.DimProduct AS p
WHERE p.ProductSubcategoryKey = '2'
ORDER BY ListPrice desc

-- 7.	(4) List the product alternate key, product name, and list price for the product(s) 
--		with the lowest List Price. There can be multiple products with the lowest list price.

SELECT p.ProductAlternateKey, p.EnglishProductName, CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice'
FROM dbo.DimProduct AS p
WHERE ListPrice = (SELECT MIN(p.ListPrice) FROM dbo.DimProduct AS p)

--Proof:

SELECT p.EnglishProductName, CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice'
FROM dbo.DimProduct AS p
WHERE ListPrice IS NOT NULL
ORDER BY ListPrice asc

-- 8.a.	(4) List the product alternate key, product name, list price, dealer price, and the 
--		difference (calculated field) for all product(s). Show all money values to 2 decimal places.
--		Sort on difference from highest to lowest.

SELECT p.ProductAlternateKey, p.EnglishProductName, 
	   CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice',
	   CAST(p.DealerPrice AS DECIMAL(10,2)) AS 'DealerPrice',
	   CAST((ListPrice - DealerPrice) AS DECIMAL(10,2)) AS 'PriceDifference'
FROM dbo.DimProduct AS p
ORDER BY PriceDifference desc

-- 8.b.	(3) Use the statement from 8.a. and modify to find the product(s) with the largest difference 
--		between the list price and the dealer price. Show all money values to 2 decimal places.

SELECT p.ProductAlternateKey, p.EnglishProductName, 
	   CAST(p.ListPrice AS DECIMAL(10,2)) AS 'ListPrice',
	   CAST(p.DealerPrice AS DECIMAL(10,2)) AS 'DealerPrice',
	   CAST((ListPrice - DealerPrice) AS DECIMAL(10,2)) AS 'PriceDifference'
FROM dbo.DimProduct AS p
WHERE (ListPrice - DealerPrice) = (SELECT MAX(p.ListPrice - p.DealerPrice) FROM dbo.DimProduct AS p)
ORDER BY PriceDifference desc

-- 9.	(4) List total Internet sales for product BK-M82S-44 using two methods: Total the sales amount field
--		and calculate the total amount using unit price and quantity. Place both calculations in different 
--		columns in the SAME Select statement. There will be one results set with two columns and one row. 
--		Show all money values to 2 decimal places. The values should be the same.

SELECT CAST(SUM(i.SalesAmount) AS DECIMAL(10,2)) AS 'Sales Amount',
	   CAST(SUM(i.UnitPrice * i.OrderQuantity) AS DECIMAL(10,2)) AS 'Unit * Quantity'
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactInternetSales AS i
		ON p.ProductKey = i.ProductKey
WHERE p.ProductAlternateKey = 'BK-M82S-44'

--10.	(2) In your own words, write a business question that you can answer by querying the data warehouse
--		and using an aggregate function.
--		Then write the complete SQL query that will provide the information that you are seeking.


--How many new customer accounts were there in 2008 in the United States?

SELECT COUNT(c.FirstName) AS 'New US Customers 2008'
FROM dbo.DimCustomer AS c
	INNER JOIN dbo.FactInternetSales AS i
		ON c.CustomerKey = i.CustomerKey
WHERE c.DateFirstPurchase LIKE '2008%'
	  AND i.SalesTerritoryKey IN ('1', '2', '3', '4', '5')
