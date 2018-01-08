--*  BUSIT 103           Assignment   #9              DUE DATE :  Consult course calendar
							
-- You are to develop SQL statements for each task listed.  
-- You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment9.sql). 
	Submit your file to the instructor using through the course site.  */

--	Do not remove the USE statement.
USE AdventureWorksDW2012;

-- Note 1:  When the task does not specify sort order, it is your responsibility to order the  
-- information so that is easy to interpret and add an alias to any columns without a name.
-- Note 2:  When asked to calculate an average or a count, for example, and then write a statement
-- using that value, be sure you are using the subquery and not hard coding the value.  
-- Note 3:  The questions are numbered. 1.a., 1.b., 2.a., 2.b., etc., to remind you of the steps in 
-- developing and testing your queries/subqueries. The first steps will not require subqueries 
-- unless specified. The last step in every sequence will require a subquery, regardless of
-- whether the result can be created using another method, unless otherwise specified. 

--1.	Read all of the requests for question 1 before beginning. Instructions in later requests
--		may answer questions about earlier requests. The joins are not complex but the WHERE is.

--1.a.	(2) List the ProductKey, ProductAlternateKey, ProductSubcategoryKey, EnglishProductName, 
--		FinishedGoodsFlag, Color, ListPrice, Size, Class, StartDate, EndDate, and Status for all 
--		current products. One table only. Look at the results and pay attention to the values in 
--		the fields. Understanding the data will help you make decisions about your filters in the 
--		following statements. You will want to find simple filters that are sustainable--will still  
--		work when the data set grows. Be sure to add a meaningful sort. Hint: Don't know how 
--		to find current products? Run the statement with the WHERE and look for current.

SELECT p.ProductKey, p.ProductAlternateKey, p.ProductSubcategoryKey, p.EnglishProductName, 
	   p.FinishedGoodsFlag, p.Color, p.ListPrice, p.Size, p.Class, p.StartDate, p.EndDate, p.Status
FROM dbo.DimProduct AS p
WHERE p.Status LIKE 'Current'
ORDER BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

-- 1.b. (1) List the distinct ProductKey for products sold to Resellers. (One table, one field, many rows)
--		No sort needed. Here you need to understand in which table sales to Resellers are stored.

SELECT DISTINCT p.ProductKey
FROM dbo.DimProduct AS p
	INNER JOIN dbo.FactResellerSales AS r
		ON p.ProductKey = r.ProductKey
ORDER BY p.ProductKey --Easier to ensure no duplicates were seen

-- 1.c. (3) Using an Outer Join find current Products that have not been sold to Resellers. Show Product
--		Key and the English Product Name. Add a meaningful sort.

SELECT DISTINCT p.ProductKey, p.EnglishProductName
FROM dbo.DimProduct AS p
	LEFT OUTER JOIN dbo.FactResellerSales AS r
		ON p.ProductKey = r.ProductKey
WHERE r.SalesOrderNumber IS NULL
ORDER BY p.ProductKey asc

--1.d.  (2) Using the Outer Join from 1.c. find all current products have not been sold to Resellers 
--		and are for sale (they are not inventory). Show Product Key, the English Product Name, and the  
--		field(s) you used to find products that are for sale. Add a meaningful sort. Recall that inventory   
--		was talked about in Assignment 7, Question 2c. There are several ways to find products that are   
--		for sale. Pick a method that works and makes sense to you. Include a comment about why 
--		you chose the method you did.  

SELECT DISTINCT p.ProductKey, p.EnglishProductName, p.Status
FROM dbo.DimProduct AS p
	INNER JOIN dbo.DimProductSubcategory AS s
		ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
	LEFT OUTER JOIN dbo.FactResellerSales AS r
		ON p.ProductKey = r.ProductKey
WHERE r.SalesOrderNumber IS NULL
	  AND p.Status LIKE 'Current'
ORDER BY p.ProductKey asc

--I chose this method to do my query, because the information from 2c in Assignment 7 helped me make sense of this problem and newly introduced logic.
--I believe that Status should be the additional included field here, since it seems to tell me if a product is still for sale also.

--1.e.  (3) Rewrite the Outer Join from 1d as a subquery to find all current Products that are for sale and   
--		have not been sold to Resellers. HINT: Review 1a and 1b. There will be no joins in the statement for 1e.  
--		1b will be used as a subquery in the WHERE clause to return a list. You want to find product keys that 
--		are not in that list and are for sale. This statement is likely simpler than you think it should be. 

SELECT DISTINCT p.ProductKey, p.EnglishProductName, p.Status
FROM dbo.DimProduct AS p
WHERE p.ProductKey NOT IN 
	(SELECT DISTINCT p.ProductKey
	 FROM dbo.DimProduct AS p
		LEFT OUTER JOIN dbo.FactResellerSales AS r
			ON p.ProductKey = r.ProductKey
	 WHERE r.SalesOrderNumber IS NOT NULL)
AND p.ProductKey IN 
	(SELECT DISTINCT p.ProductKey
	 FROM dbo.DimProduct AS p
		INNER JOIN dbo.DimProductSubcategory AS s
			ON p.ProductSubcategoryKey = s.ProductSubcategoryKey)
AND p.Status LIKE 'Current'
ORDER BY p.ProductKey asc

-- 2.a.	(4) List the average listprice of accessory items for sale by AdventureWorks. No sort  
--		needed. Remember to provide a column alias. Use the AVG function that was demonstrated 
--		in the Subqueries Demo file.

SELECT CAST(AVG(p.ListPrice) AS DECIMAL(10,2)) AS AveragePrice
FROM dbo.DimProduct AS p
	INNER JOIN dbo.DimProductSubcategory AS s
		ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
	INNER JOIN dbo.DimProductCategory AS c
		ON s.ProductCategoryKey = c.ProductCategoryKey
WHERE c.EnglishProductCategoryName LIKE 'Accessories'

-- 2.b. (3) List the products in the Accessory category that have a listprice higher than the average
--		listprice of Accessory items.  Show product alternate key, product name, and listprice in the
--		results set. Order the information so it is easy to understand. Be sure 
--		to use a subquery; do not enter the actual value from 2.a. into the statement.

SELECT p.ProductAlternateKey, p.EnglishProductName, p.ListPrice 
FROM dbo.DimProduct AS p
WHERE p.ListPrice > (SELECT CAST(AVG(p.ListPrice) AS DECIMAL(10,2)) AS AveragePrice
					 FROM dbo.DimProduct AS p
						INNER JOIN dbo.DimProductSubcategory AS s
							ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
						INNER JOIN dbo.DimProductCategory AS c
							ON s.ProductCategoryKey = c.ProductCategoryKey
					 WHERE c.EnglishProductCategoryName LIKE 'Accessories')
ORDER BY p.ListPrice desc, p.EnglishProductName asc

-- 3.a. (2) Find the average yearly income of all houseowners in the customer table. 

SELECT CAST(AVG(c.YearlyIncome) AS DECIMAL(10,2)) AS HOAvgYearlyIncome
FROM dbo.DimCustomer AS c
WHERE c.HouseOwnerFlag LIKE '1'

-- 3.b. (3) Find all houseowners in the customers table with an income less than or the same as  
--		the average income of all customers. List last name, a comma and space, and first name in 
--		one column, the customer key, and yearly income. There will be three columns in the Results 
--		set. Be sure to use a subquery; do not enter the actual value from 3.a. into the statement.

SELECT (c.LastName + ', ' + c.FirstName) AS Name, c.CustomerKey, c.YearlyIncome
FROM dbo.DimCustomer AS c
WHERE c.YearlyIncome <= (SELECT CAST(AVG(c.YearlyIncome) AS DECIMAL(10,2)) AS HOAvgYearlyIncome
						 FROM dbo.DimCustomer AS c
						 WHERE c.HouseOwnerFlag LIKE '1')
ORDER BY Name asc, c.YearlyIncome desc

-- 4.a.	(2) List the product name and list price for the bike named Road-150 Red, 62

SELECT p.EnglishProductName, p.ListPrice
FROM dbo.DimProduct AS p
WHERE p.EnglishProductName LIKE 'Road-150 Red, 62'

-- 4.b.	(3) List the product name and price for each bike that has a price greater than or equal to
--	    that of the Road-150 Red, 62. Be sure you are using the subquery not an actual value.

SELECT p.EnglishProductName, p.ListPrice
FROM dbo.DimProduct AS p
WHERE p.ListPrice >= (SELECT p.ListPrice
					  FROM dbo.DimProduct AS p
					  WHERE p.EnglishProductName LIKE 'Road-150 Red, 62')
ORDER BY p.EnglishProductName asc, p.ListPrice desc

/*	Questions 5 and 6 ask you to experiment with a few of the Special Predicate Keywords for 
	Subqueries where requested. There are other ways to solve the statements, but use the requested 
	predicate for practice. */

-- 5.a.	(3) List the names of resellers and the product names of products they purchased. 
--      Eliminate duplicate rows. Use an appropriate sort. No special predicate requested.

SELECT DISTINCT r.ResellerName, p.EnglishProductName
FROM dbo.DimReseller AS r
	INNER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
	INNER JOIN dbo.DimProduct AS p
		ON s.ProductKey = p.ProductKey
ORDER BY r.ResellerName asc, p.EnglishProductName asc

-- 5.b.	(3) List the names of all resellers who sold a Road-150 Red, 62. Eliminate duplicate  
--      rows. Use the IN predicate and a subquery to accomplish the task. Use an appropriate  
--		sort. The WHERE clause in this one is similar to, but less complex than, the one in 1.e.  

SELECT DISTINCT r.ResellerName
FROM dbo.DimReseller AS r
	INNER JOIN dbo.FactResellerSales AS s
		ON r.ResellerKey = s.ResellerKey
	INNER JOIN dbo.DimProduct AS p
		ON s.ProductKey = p.ProductKey
WHERE p.EnglishProductName IN (SELECT p.EnglishProductName
							   FROM dbo.DimProduct AS p
                               WHERE p.EnglishProductName LIKE 'Road-150 Red, 62')
ORDER BY r.ResellerName asc

-- 6.a. (1) Show all data from the Survey Response fact table. Use select all. No special predicate.

SELECT *
FROM dbo.FactSurveyResponse AS sr

-- 6.b. (4) Use a subquery and the EXISTS predicate to find customers that respond to surveys. List full
--		name (first, middle, last) and email address (2 columns). Use the CONCAT() function for the name
--		to overcome the NULL issue. You will not see NULL in any row. Refer to the selected solutions demo 
--		in the Module 03 discussion board for help with CONCAT. EXISTS is in the Module 09 demo file.
--		NOTE: Don't overuse EXISTS. It appears easy to use but it may not give the results expected.

SELECT DISTINCT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS Name, c.EmailAddress
FROM dbo.DimCustomer AS c
	INNER JOIN dbo.FactSurveyResponse AS sr
		ON c.CustomerKey = sr.CustomerKey
WHERE EXISTS (SELECT *
			  FROM dbo.FactSurveyResponse)
ORDER BY Name asc, c.EmailAddress asc

-- 6.c. (2) Copy/paste 6.b and use an additional subquery in the WHERE clause in the outer 
--		query to narrow the results of 6.b. to only those customers with a yearly income that  
--		is greater than or the same as the average of all customers.

SELECT DISTINCT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS Name, c.EmailAddress
FROM dbo.DimCustomer AS c
	INNER JOIN dbo.FactSurveyResponse AS sr
		ON c.CustomerKey = sr.CustomerKey
WHERE EXISTS (SELECT *
			  FROM dbo.FactSurveyResponse)
	  AND c.YearlyIncome >= (SELECT CAST(AVG(c.YearlyIncome) AS DECIMAL(10,2)) AS AvgYearlyIncome
							 FROM dbo.DimCustomer AS c)
ORDER BY Name asc, c.EmailAddress asc

-- 6.d. (1) Modify 6.c to find those customers at the income level specified that who do not respond 
--		to surveys. This modification requires the addition of one operator. 

SELECT DISTINCT CONCAT(c.FirstName, ' ', c.MiddleName, ' ', c.LastName) AS Name, c.EmailAddress
FROM dbo.DimCustomer AS c
	LEFT JOIN dbo.FactSurveyResponse AS sr
		ON c.CustomerKey = sr.CustomerKey
WHERE EXISTS (SELECT *
			  FROM dbo.FactSurveyResponse)
	  AND c.YearlyIncome >= (SELECT CAST(AVG(c.YearlyIncome) AS DECIMAL(10,2)) AS AvgYearlyIncome
							 FROM dbo.DimCustomer AS c)
	  AND sr.SurveyResponseKey IS NULL
ORDER BY Name asc, c.EmailAddress asc

-- 7.a.	(1) Find the average of total children for all customers.
--		Use the Average function and provide an appropriate alias. 

SELECT AVG(c.TotalChildren) AS AverageChildren
FROM dbo.DimCustomer AS c

-- 7.b.	(3) Use a correlated subquery to find customers who have more children than the  
--		average for customers in their same occupation. List customer key, last name, 
--		first name, total children, and English occupation. Add a meaningful sort.
--		In a correlated subquery the inner query is dependent on the outer query for its value.
--		There is an example of a similar request in the Subqueries demo file. 

SELECT c1.CustomerKey, c1.LastName, c1.FirstName, c1.TotalChildren, c1.EnglishOccupation
FROM dbo.DimCustomer AS c1
WHERE c1.TotalChildren > (SELECT AVG(c2.TotalChildren) AS AverageChildren
						 FROM dbo.DimCustomer AS c2
						 WHERE c1.EnglishOccupation = c2.EnglishOccupation)
ORDER BY 4 desc, 2 asc, 3 asc, 1 asc, 5 asc

-- 8.	(4) List resellers of any business type who have annual sales above the average  
--		annual sales for resellers whose Business Type is "Warehouse". Show Business type, 
--		Reseller Name, and annual sales. Use appropriate subqueries. 

SELECT r1.BusinessType, r1.ResellerName, r1.AnnualSales
FROM dbo.DimReseller AS r1
WHERE r1.BusinessType LIKE 'Warehouse'
	  AND r1.AnnualSales > (SELECT AVG(r2.AnnualSales) AS AverageSales
							FROM dbo.DimReseller AS r2)
ORDER BY r1.AnnualSales desc, r1.ResellerName asc, r1.BusinessType asc

