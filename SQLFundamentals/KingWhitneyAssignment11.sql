--*  BUSIT 103           Assignment   #11              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsAssignment11.sql). 
	Submit your file to the instructor using through the course site.  */

--  It is your responsibility to provide a meaningful column name for the return value of the function 
--  and use an appropriate sort order. All joins are to use the ANSI standard syntax.

USE AdventureWorksDW2012;

--1.	AdventureWorks wants geographic information about its resellers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias.

--1a.	(2) First check to determine if there are resellers without geography info.

SELECT r.ResellerKey, r.GeographyKey
FROM dbo.DimReseller AS r
WHERE r.GeographyKey IS NULL

--No, all resellers appear to have Geography Info. After reviewing just the Resellers table as a check, I believe this to be true.

--1b.	(4) Display a count of resellers in each Country.
--		Show country name and the count of resellers.

SELECT g.EnglishCountryRegionName, COUNT(r.ResellerKey) AS Resellers
FROM dbo.DimReseller AS r
	LEFT OUTER JOIN dbo.DimGeography AS g
		ON r.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY Resellers desc

--1c.	(3) Display a count of resellers in each City. 
--		Show count of resellers, City name, State name, and Country name.
 
SELECT COUNT(r.ResellerKey) AS Resellers, 
	   g.City, g.StateProvinceName, 
	   g.EnglishCountryRegionName
FROM dbo.DimReseller AS r
	LEFT OUTER JOIN dbo.DimGeography AS g
		ON r.GeographyKey = g.GeographyKey
GROUP BY g.City, 
		 g.StateProvinceName, 
		 g.EnglishCountryRegionName
ORDER BY g.EnglishCountryRegionName asc, 
		 g.StateProvinceName asc, 
		 g.City asc,
		 Resellers desc

--2.	AdventureWorks wants banking and historical information about its resellers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias. 

--2a. 	(2) Check to see if there are any resellers without a value in the bank name field.

SELECT r.ResellerKey, r.BankName
FROM dbo.DimReseller AS r
WHERE r.BankName IS NULL

--No, all resellers appear to have Bank Names. After reviewing just the Resellers table as a check, I believe this to be true.

--2b.	(2) List the name of each bank and the number of resellers using that bank.

SELECT r.BankName, COUNT(r.ResellerKey) AS Resellers
FROM dbo.DimReseller AS r
GROUP BY r.BankName
ORDER BY Resellers desc, r.BankName asc

--2c.	(2) List the year opened and the number of resellers opening in that year.

SELECT r.YearOpened, COUNT(r.ResellerKey) AS Resellers
FROM dbo.DimReseller AS r
GROUP BY r.YearOpened
ORDER BY r.YearOpened desc, Resellers desc

--2d.	(2) List the order frequency and the number of resellers with that order frequency.

SELECT r.OrderFrequency, COUNT(r.ResellerKey) AS Resellers
FROM dbo.DimReseller AS r
GROUP BY r.OrderFrequency
ORDER BY Resellers desc, r.OrderFrequency asc

--2e.	(2) List the average number of employees in each of the three business types.

SELECT r.BusinessType, AVG(r.NumberEmployees) AS AvgNumberEmployees
FROM dbo.DimReseller AS r
GROUP BY r.BusinessType
ORDER BY AvgNumberEmployees desc, r.BusinessType asc

--2f.	(4) List business type, the count of resellers in that type, and average of Annual Revenue 
--		in that business type. 
--		+2 Bonus Look up the Format function for Transact SQL. Find the function that will show the
--		money values in this format: $64,395.07.  FORMAT(AVG(YearlyIncome), 'c', 'en-us')

SELECT r.BusinessType, 
	   COUNT(r.ResellerKey) AS Resellers, 
	   FORMAT(AVG(r.AnnualRevenue), 'c', 'en-us') AS AvgAnnualRevenue
FROM dbo.DimReseller AS r
GROUP BY r.BusinessType
ORDER BY AvgAnnualRevenue asc, 
		 Resellers asc, 
		 r.BusinessType asc

--3.	AdventureWorks wants information about sales to its resellers. Be sure to add a 
--		meaningful sort and give each derived column an alias. Remember that Annual Revenue 
--		is a measure of the size of the business and is NOT the total of the AdventureWorks 
--		products sold to the reseller. Be sure to use SalesAmount when total sales are 
--		requested.

--3a. 	(3) List the name of any reseller to which AdventureWorks has not sold a product. 
--		Hint: Use a join.

SELECT r.ResellerName--, s.SalesOrderNumber
FROM dbo.DimReseller AS r
	LEFT OUTER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
WHERE s.SalesOrderNumber IS NULL
ORDER BY r.ResellerName

--3b.	(4) List ALL resellers and total of sales amount to each reseller. Show Reseller 
--		name, business type, and total sales with the sales showing two decimal places. 		
--		Be sure to include resellers for which there were no sales. NULL will appear.

SELECT r.ResellerName, 
	   FORMAT(SUM(s.SalesAmount), 'c', 'en-us') AS TotalSales
FROM dbo.DimReseller AS r
	LEFT OUTER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
WHERE s.SalesOrderNumber IS NOT NULL
GROUP BY r.ResellerName
ORDER BY TotalSales desc, r.ResellerName asc

--Is there a want to change text sorting to numerical sorting in the order by clause so the numbers sort highest to lowest?
--CAST doesn't seem to play nicely with FORMAT.


--3c.	BONUS +2 AdventureWorks management wants to see 0.00 instead of NULL for resellers without a 
--		value in the total of SalesAmount field. A technique to do this was demonstrated in the demo of 
--		selected answers posted to the Module 03 discussion board. NOTE: Be wary of performing this conversion.
--		You know that NULL and 0 are not the same thing and replacing NULL with 0 will impact calculations.
--		This exercise is to show you how the conversion is done and is not an endorsement of doing it. 
--		Don't perform this conversion elsewhere in this assignment. 

SELECT r.ResellerName, 
	   FORMAT(COALESCE(SUM(s.SalesAmount), 0.00), 'c', 'en-us') AS TotalSales --ISNULL would also do this here
FROM dbo.DimReseller AS r
	LEFT OUTER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
GROUP BY r.ResellerName
ORDER BY TotalSales desc, r.ResellerName asc

--3d.	(3) List resellers and total sales to each.  Show reseller name, business type, and total sales 
--		with the sales showing two decimal places. Limit the results to resellers to which 
--		total sales are less than $500 and greater than $500,000.

SELECT r.ResellerName, 
	   r.BusinessType, 
	   FORMAT(SUM(s.SalesAmount), 'c', 'en-us') AS TotalSales
FROM dbo.DimReseller AS r
	INNER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
HAVING (SUM(s.SalesAmount) < 500) OR (SUM(s.SalesAmount) > 500000)
ORDER BY TotalSales desc, r.ResellerName asc

--3e.	(4) List resellers and total sales to each for 2008.  
--		Show Reseller name, business type, and total sales with the sales showing two decimal places.
--		Limit the results to resellers to which total sales are between $5,000 and $7,500 and between 
--		$50,000 and $75,000

SELECT r.ResellerName, 
	   r.BusinessType, 
	   FORMAT(SUM(s.SalesAmount), 'c', 'en-us') AS TotalSales
FROM dbo.DimReseller AS r
	INNER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
WHERE CONVERT(nvarchar(10),s.OrderDate, 101)  LIKE '%2008'
GROUP BY r.ResellerName, r.BusinessType
HAVING ((SUM(s.SalesAmount) > 5000) AND (SUM(s.SalesAmount) < 7500))
	      OR ((SUM(s.SalesAmount) > 50000) AND (SUM(s.SalesAmount) < 75000))
ORDER BY TotalSales desc, r.BusinessType asc, r.ResellerName asc

--4.	AdventureWorks wants information about the demographics of its customers.
--		Be sure to add a meaningful sort as appropriate and give each derived column an alias. 

--4a.	(2) List customer education level (use EnglishEducation) and the number of customers reporting
--		each level of education.

SELECT c.EnglishEducation, COUNT(c.CustomerKey) AS Customers
FROM dbo.DimCustomer AS c
GROUP BY c.EnglishEducation
ORDER BY Customers desc

--4b.	(3) List customer education level (use EnglishEducation), the number of customers reporting
--		each level of education, and the average yearly income for each level of education.
--		Show the average income rounded to two (2) decimal places. 

SELECT c.EnglishEducation, 
	   COUNT(c.CustomerKey) AS Customers, 
	   FORMAT(AVG(c.YearlyIncome), 'c', 'en-us') AS AvgYearlyIncome
FROM dbo.DimCustomer AS c
GROUP BY c.EnglishEducation
ORDER BY Customers desc

--5.	(6) List all customers and the most recent date on which they placed an order (2 fields). Show the  
--		customer's first name, middle name, and last name in one column with a space between each part of the  
--		name. No name should show NULL. Show the date of the most recent order as mm/dd/yyyy. 
--		It is your responsibility to make sure you do not miss any customers. If you need to add one
--		more field to the SELECT or the GROUP BY clause, do it. Just don't add more than one. 

SELECT (c.FirstName + ' ' + c.MiddleName + ' ' + c.LastName) AS CustomerName,
		CONVERT(nvarchar(10),MAX(s.OrderDate), 101) AS OrderDate
FROM dbo.DimCustomer AS c
	INNER JOIN dbo.FactInternetSales AS s
		ON c.CustomerKey = s.CustomerKey
WHERE c.FirstName IS NOT NULL
	  AND c.MiddleName IS NOT NULL
	  AND c.LastName IS NOT NULL
GROUP BY c.FirstName, c.MiddleName, c.LastName
ORDER BY CustomerName asc

--6.	(2) In your own words, write a business question that you can answer by querying the data warehouse
--		and using an aggregate function with the having clause.
--		Then write the complete SQL query that will provide the information that you are seeking.

--Which items in inventory have we sold to customers more than 1000 times?

SELECT p.EnglishProductName, COUNT(p.ProductKey) As ProductsSold
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactInternetSales AS s
		ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName
HAVING COUNT(p.ProductKey) > 1000
ORDER BY ProductsSold desc




