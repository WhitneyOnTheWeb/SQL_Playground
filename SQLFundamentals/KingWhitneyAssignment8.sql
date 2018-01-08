--*  BUSIT 103           Assignment   #8              DUE DATE:  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment8.sql). 
	Submit your file to the instructor using through the course site.  */

/*	Ideas for consideration: Run the statement in stages: Write the SELECT and FROM clauses first 
	and run the statement. Add the ORDER BY clause. Then add the WHERE clause; if it is a compound
	WHERE clause, add piece at a time. Remember that the order in which the joins are processed does make 
	a difference with OUTER JOINs. 
	You will not use Cross-Joins, Full Outer Joins, or Unions in the required exercises. All are to be 
	accomplished with outer joins or a combination of outer and inner joins using ANSI standard Join syntax. */

--	Do not remove the USE statement
USE AdventureWorksDW2012; 

--NOTE:	When the task does not specify sort order, it is your responsibility to order the information
--		so that is easy to interpret. 

--1.	(4) List the name of ALL products and the name of the product subcategory to which the
--		product belongs. Sort on product subcategory name and product name. 

SELECT p.EnglishProductName, ps.EnglishProductSubcategoryName
FROM dbo.DimProduct AS p
	LEFT OUTER JOIN dbo.DimProductSubcategory AS ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
ORDER BY ps.EnglishProductSubcategoryName asc, p.EnglishProductName asc


--2.	(4) List the name of all Sales Reasons that have not been associated with a sale. Add a meaningful 
--		sort. Explanation: AdventureWorks has a prepopulated list of reasons why customers purchase their 
--		products. You are finding the reasons on the list that have not been selected by a customer buying 
--		over the Internet. Hint:  Use DimSalesReason and FactInternetSalesReason FactInternetSalesReason 
--		and test for null in the matching field in the fact table.  

SELECT d.SalesReasonName
FROM dbo.DimSalesReason AS d
	LEFT OUTER JOIN dbo.FactInternetSalesReason AS r
		ON d.SalesReasonKey = r.SalesReasonKey
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON r.SalesOrderNumber = s.SalesOrderNumber
WHERE r.SalesOrderLineNumber IS NULL
ORDER BY d.SalesReasonName asc

--3.	(4) List all internet sales that do not have a sales reason associated. List SalesOrderNumber, 
--		SalesOrderLineNumber and the order date. Add a meaningful sort.
--		Explanation: Now we are looking at sales reasons from another angle. Above we wanted to know which 
--		sales reasons had not been used, so we wanted the reason name. Now we are looking at which sales do not 
--		have a reason associated with the sale. Since we are looking at the sales, we don't need the reason name 
--		and the corresponding link to that table. Hint:  Use FactInternetSales and FactInternetSalesReason. 

SELECT s.SalesOrderNumber, s.SalesOrderLineNumber, s.OrderDate
FROM dbo.FactInternetSalesReason AS r
	RIGHT OUTER JOIN dbo.FactInternetSales AS s
		ON r.SalesOrderNumber = s.SalesOrderNumber
WHERE r.SalesReasonKey IS NULL
ORDER BY s.SalesOrderNumber asc, s.SalesOrderLineNumber asc, s.OrderDate asc

--4.a.	(4) List all promotions that have not been associated with a reseller sale. Show only
--		the English promotion name in alphabetical order.
--		Hint: Recall that details about sales to resellers are recorded in the FactResellerSales table.

SELECT p.EnglishPromotionName
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactResellerSales AS r
		ON p.PromotionKey = r.PromotionKey
WHERE r.ResellerKey IS NULL
ORDER BY p.EnglishPromotionName asc

--4.b.	(3) List all promotions that have not been associated with an internet sale. Show only
--		the English promotion name in alphabetical order.
--		Hint: Recall that details about sales to customers are recorded in the FactInternetSales table.

SELECT p.EnglishPromotionName
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON p.PromotionKey = s.PromotionKey
WHERE s.SalesOrderNumber IS NULL
ORDER BY p.EnglishPromotionName asc

--4.c.	+3 Bonus. Write an INTERSECT to show the name of promotions that have not been associated 
--		with either a reseller sale or an internet sale. HINT: This can be done with 
--		copy/paste from 4a and b, dropping one order by clause, and the addition of one keyword.

SELECT p.EnglishPromotionName
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactResellerSales AS r
		ON p.PromotionKey = r.PromotionKey
WHERE r.ResellerKey IS NULL
	INTERSECT
SELECT p.EnglishPromotionName
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON p.PromotionKey = s.PromotionKey
WHERE s.SalesOrderNumber IS NULL
ORDER BY p.EnglishPromotionName asc

--5.a.	(4) Find any PostalCodes in which AdventureWorks has no internet customers.
--		List Postal Code and the English country/region name.
--		List each Postal Code only one time. Sort by country and postal code.

SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM dbo.DimGeography AS g
	LEFT OUTER JOIN dbo.DimCustomer AS c
		ON c.GeographyKey = g.GeographyKey
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON s.CustomerKey = c.CustomerKey
WHERE s.CustomerKey IS NULL
ORDER BY g.EnglishCountryRegionName asc, g.PostalCode asc

--5.b	(3) Find any PostalCodes in which AdventureWorks has no resellers.
--		List Postal Code and the English country/region name.
--		List each Postal Code only one time. Sort by country and postal code.

SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM dbo.DimGeography AS g
	LEFT OUTER JOIN dbo.DimReseller AS r
		ON r.GeographyKey = g.GeographyKey
WHERE r.ResellerKey IS NULL
ORDER BY g.EnglishCountryRegionName asc, g.PostalCode asc

--5.c.	+2 Bonus. Write an INTERSECT to show Postal Codes in which AdventureWorks has neither  
--		Internet customers nor resellers. 

SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM dbo.DimGeography AS g
	LEFT OUTER JOIN dbo.DimCustomer AS c
		ON c.GeographyKey = g.GeographyKey
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON s.CustomerKey = c.CustomerKey
WHERE s.CustomerKey IS NULL
	INTERSECT
SELECT DISTINCT g.PostalCode, g.EnglishCountryRegionName
FROM dbo.DimGeography AS g
	LEFT OUTER JOIN dbo.DimReseller AS r
		ON r.GeographyKey = g.GeographyKey
WHERE r.ResellerKey IS NULL
ORDER BY g.EnglishCountryRegionName asc, g.PostalCode asc

--6.a.	(4) List the name of all currencies and the name of each organization that uses that currency.
--		You will use an Outer Join to list the name of each currency in the Currency table regardless if
--		it has a matching value in the Organization table. You will see NULL in many rows. Add a 
--		meaningful sort. Hint: Use DimCurrency and DimOrganization. 

SELECT c.CurrencyName,
	   o.OrganizationName
FROM dbo.DimCurrency AS c
	LEFT OUTER JOIN dbo.DimOrganization AS o
		ON c.CurrencyKey = o.CurrencyKey
ORDER BY c.CurrencyName asc, o.OrganizationName asc

--6.b. (2) List the name of all currencies that are NOT used by any organization. In this situation 
--		we are using the statement from 1.a. and making a few modifications. We want to find the
--		currencies that do not have a match in the common field in the Organization table. 
--		Sort ascending on currency name. 

SELECT c.CurrencyName
FROM dbo.DimCurrency AS c
	LEFT OUTER JOIN dbo.DimOrganization AS o
		ON c.CurrencyKey = o.CurrencyKey
WHERE o.OrganizationName IS NULL
ORDER BY c.CurrencyName asc

--7.a.	(3) List the unique name of all currencies and the CustomerKey of customers that use that 
--		currency. You will list the name of each currency in the Currency table regardless if
--		it has a matching value in the Internet Sales table. You will see some currencies are repeated
--		because more than one customer uses the currency. You may see the CustomerKey repeated because
--		a customer may buy in more than one currency. You will see NULL in a few rows. Add a 
--		meaningful sort. Hint: This will be all customers, with some duplicated, and the unused
--		currencies; 18,983 rows. 

SELECT DISTINCT m.CurrencyName, c.CustomerKey
FROM dbo.DimCurrency AS m
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON m.CurrencyKey = s.CurrencyKey
	LEFT OUTER JOIN dbo.DimCustomer AS c
		ON s.CustomerKey = c.CustomerKey
ORDER BY c.CustomerKey asc, m.CurrencyName asc

--7.b.	(2) Copy/paste 7.a. to 7.b. Modify 7.b. to list only the unique name of currencies that are not used 
--		by any internet customer. Add a meaningful sort. This will be a small number--just unused currencies.
		
SELECT DISTINCT m.CurrencyName
FROM dbo.DimCurrency AS m
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON m.CurrencyKey = s.CurrencyKey
	LEFT OUTER JOIN dbo.DimCustomer AS c
		ON s.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL
ORDER BY m.CurrencyName asc

--7.c.	(4) This question is a variation on 7.a. You will need to join to an additional table.
--		List the unique name of all currencies, the last name, first name, and the CustomerKey 
--		of customers that use that currency. You will list the name of each currency in the Currency table 
--		regardless if it has a matching value in the Internet Sales table. Same number of rows as 7.a.

SELECT DISTINCT m.CurrencyName, c.LastName, c.FirstName, c.CustomerKey
FROM dbo.DimCurrency AS m
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON m.CurrencyKey = s.CurrencyKey
	LEFT OUTER JOIN dbo.DimCustomer AS c
		ON s.CustomerKey = c.CustomerKey
ORDER BY m.CurrencyName asc, c.LastName, c.FirstName, c.CustomerKey

--		READ 8.a. and 8.b. BEFORE beginning the syntax.  Hint: Refer to the Outer Joins Demo 
--		and look at the example where a query is used in place of table for one possible method 
--		of answering these two questions. They can also be done with multiple joins.  NULL will 
--		show in the ResellerName and OrderDate for a few records. We are showing ALL promotions.

--8.a.	(4) Find all promotions and any related reseller sales. List unique instances of the 
--		English promotion name, reseller name, and the order date. Show the OrderDate as mm/dd/yyyy. 
--		Sort by the promotion name. Be sure to list all promotion names even if there is no related sale.

SELECT DISTINCT p.EnglishPromotionName, 
				r.ResellerName, 
				CONVERT(VARCHAR(10),s.OrderDate,101) AS OrderDate
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactResellerSales AS s
		ON p.PromotionKey = s.PromotionKey
	LEFT OUTER JOIN dbo.DimReseller AS r
		ON s.ResellerKey = r.ResellerKey
ORDER BY p.EnglishPromotionName

--8.b.	(3) Copy, paste, and modify 8.a. "No Discount" is not a promotion; eliminate those sales 
--		without a promotion from your results set. Show the OrderDate as mm/dd/yyyy.
--		Look for ways to double-check your results.

SELECT DISTINCT p.EnglishPromotionName, 
				r.ResellerName, 
				CONVERT(VARCHAR(10),s.OrderDate,101) AS OrderDate
FROM dbo.DimPromotion AS p
	LEFT OUTER JOIN dbo.FactResellerSales AS s
		ON p.PromotionKey = s.PromotionKey
	LEFT OUTER JOIN dbo.DimReseller AS r
		ON s.ResellerKey = r.ResellerKey
WHERE p.EnglishPromotionName NOT LIKE 'No Discount'
ORDER BY p.EnglishPromotionName

--9.	(2) In your own words, write a business question that you can answer by querying the data warehouse 
--		and using an outer join. Be sure that your business question appears as a comment (all green)
--		Then write the SQL query that will provide the information that you are seeking.

-- Show all products that have not been sold online.

SELECT DISTINCT p.EnglishProductName
FROM dbo.DimProduct AS p
	LEFT OUTER JOIN dbo.FactInternetSales AS s
		ON p.ProductKey = s.ProductKey
WHERE s.SalesOrderNumber IS NULL
ORDER BY p.EnglishProductName

