--*  BUSIT 103                    Assignment   #6                      DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed. You should type your SQL statements under 
--each task. You are required to use INNER JOINs to solve each problem. Even if you know another method 
--that will produce the result, this module is practice in INNER JOINs.

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., GriggsDebiAssignment6.sql). 
	Submit your file to the instructor using through the course site.  */

--NOTE: We are now using a different database. 
USE AdventureWorks2012;

/*  Reminder: You are required to use the INNER JOIN syntax to solve each problem. INNER JOIN is ANSI syntax. 
	It is generally considered more readable, especially when joining many tables. Even if you have prior 
	experience with joins, you will still use the INNER JOIN syntax and refrain from using any OUTER or 
	FULL joins in Modules 6 and 7 covering INNER JOINs. */

--1.a.	(4) List any products that have product reviews.  Show product name, product ID, and comments. 
--		Sort alphabetically on the product name. Don’t over complicate this. A correctly written 
--		INNER JOIN will return only those products that have product reviews; i.e., matching values in 
--		the linking field. Hint:  Use the Production.Product and Production.ProductReview tables.

SELECT p.Name, p.ProductID, pr.Comments
FROM (Production.Product AS p 
	 INNER JOIN Production.ProductReview AS pr
ON p.ProductID = pr.ProductID)
ORDER BY p.Name asc

--1.b.	(2) Copy/paste 1.a. to 1.b. then modify 1.b. to show only records in which the word 'heavy' is 
--		found in the Comments field. Show product ID, product name, and comments. Sort on ProductID. 

SELECT p.Name, p.ProductID, pr.Comments
FROM (Production.Product AS p 
	 INNER JOIN Production.ProductReview AS pr
ON p.ProductID = pr.ProductID)
WHERE pr.Comments LIKE '%heavy%'
ORDER BY p.ProductID asc

--2.a.	(5) List product models with products. Show the product model ID, model name, product ID,
--		product name, standard cost, and class. Round all money values to exactly two decimal places. 
--		Be sure to give any derived fields an alias. Order by standard cost from highest to lowest.
--		Hint: You know you need to use the Product table. Now look for a related table that contains  
--		the information about the product model and inner join it to Product on the linking field.  

SELECT pm.ProductModelID, pm.Name AS ModelName, 
	   p.ProductID, p.Name AS ProductName, CAST(p.StandardCost AS DECIMAL(10,2)) AS StandardCost, p.Class
FROM (Production.Product AS p 
	 INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID)
ORDER BY p.StandardCost desc

--2.b.	(2) Copy/paste 2.a. to 2.b. then modify 2.b. to list only products with a value in the  
--		class field. Do this using NULL appropriately in the WHERE clause. Hint: Remember
--		that nothing is ever equal (on not equal) to NULL; it either is or it isn't NULL.

SELECT pm.ProductModelID, pm.Name AS ModelName, 
	   p.ProductID, p.Name AS ProductName, CAST(p.StandardCost AS DECIMAL(10,2)) AS StandardCost, p.Class
FROM (Production.Product AS p 
	 INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID)
WHERE p.Class IS NOT NULL
ORDER BY p.StandardCost desc

--2.c.	(2) Copy/paste 2.b. to 2.c. then modify 2.c. to list only products that contain a value in 
--		the class field AND contain 'fork' or 'front' in the product model name. Be sure that NULL 
--		does not appear in the Class field by using parentheses appropriately.

SELECT pm.ProductModelID, pm.Name AS ModelName, 
	   p.ProductID, p.Name AS ProductName, CAST(p.StandardCost AS DECIMAL(10,2)) AS StandardCost, p.Class
FROM (Production.Product AS p 
	 INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID)
WHERE (p.Class IS NOT NULL)
	  AND (pm.Name LIKE '%fork%' OR pm.Name LIKE '%front%')
ORDER BY p.StandardCost desc

--3. a.	(6) List Product categories, their subcategories and their products.  Show the category name, 
--		subcategory name, product ID, and product name, in this order. Sort in alphabetical order on 
---		category name, subcategory name, and product name, in this order. Give each Name field a 
--		descriptive alias. For example, the Name field in the Product table will have the alias ProductName.
--		Hint:  To understand the relationships, create a database diagram with the following tables:
--		Production.ProductCategory
--		Production.ProductSubCategory
--		Production.Product

SELECT pc.Name AS CategoryName, 
	   ps.Name AS SubcategoryName, 
	   p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = ps.ProductCategoryID
ORDER By pc.Name asc, ps.Name asc, p.Name asc

--3. b.	(3) Copy/paste 3.a. to 3.b. then modify 3.b. to list only Products in product category 1.  
--		Show the category name, subcategory name, product ID, and product name, in this order. Sort in 
--		alphabetical order on product name, subcategory name, and product name. 
--		Hint: Add product category id field to SELECT clause, make sure your results are correct, then 
--		remove or comment out the field.  Something to consider: Look at the data in the ProductName field. 
--		Could we find bikes by searching for 'bike' in the ProductName field?

SELECT pc.Name AS CategoryName, 
	   ps.Name AS SubcategoryName, 
	   p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE pc.ProductCategoryID = '1'
ORDER By pc.Name asc, ps.Name asc, p.Name asc

--We could not find them by searching in the ProductName column, but it looks like we could find them by searching for 'bike' in the SubcategoryName column.

--3. c.	(2) Copy/paste 3.b. to 3.c. then modify 3.c. to list Products in product category 3. Make no other changes 
--		to the statement. Consider what kinds of products are in category 3. 

SELECT pc.Name AS CategoryName, 
	   ps.Name AS SubcategoryName, 
	   p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE pc.ProductCategoryID = '3'
ORDER By pc.Name asc, ps.Name asc, p.Name asc

--Category 3 appears to be clothing

--4.a.	(5) List Product models, the categories, the subcategories, and the products.  Show the model name, 
--		category name, subcategory name, product ID, and product name in this order. Give each Name field a   
--		descriptive alias. For example, the Name field in the ProductModel table will have the alias ModelName.
--		Sort in alphabetical order by model name.
--		Hint:  To understand the relationships, create a database diagram with the following tables:
--		Production.ProductCategory
--		Production.ProductSubCategory
--		Production.Product
--		Production.ProductModel
--		Choose a path from one table to the next and follow it in a logical order to create the inner joins

SELECT pm.Name AS ModelName, 
	   pc.Name AS CategoryName, 
	   ps.Name AS SubcategoryName, 
	   p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = ps.ProductCategoryID
ORDER BY pm.Name asc

--4. b.	(3) Copy/paste 4.a. to 4.b. then modify 4.b. to list those products in model ID 23 and  
--		contain black in the product name. Modify the sort to order only on Product ID. Hint: Add the 
--		product model id field to the select clause to check your results and then remove or comment it out.

SELECT pm.Name AS ModelName, 
	   pc.Name AS CategoryName, 
	   ps.Name AS SubcategoryName, 
	   p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE (pm.ProductModelID = '23')
	  AND (p.Name LIKE '%black%')
ORDER BY p.ProductID asc

--5.	a. (4) List products ordered by customer id 19670.  Show product name, product number, order quantity,
--		and sales order id.  Sort on product name and sales order id.  If you add customer id to check your results, 
--		be sure to remove or comment it out. Hint:  First create a database diagram with the following tables:
--		Production.Product
--		Sales.SalesOrderHeader
--		Sales.SalesOrderDetail

SELECT p.Name AS ProductName, p.ProductNumber, 
	   sd.OrderQty, 
	   sh.SalesOrderID
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sd
ON p.ProductID = sd.ProductID
INNER JOIN Sales.SalesOrderHeader AS sh
ON sd.SalesOrderID = sh.SalesOrderID
WHERE sh.CustomerID = '19670'
ORDER BY p.Name asc, sh.SalesOrderID asc

--5. b. (4) List the orders and the shipping method for customer id 19670.  We are only concerned with orders
--		that have a shipping method, so don't screen for NULL. Show product name, product number, order quantity,
--		sales order id, and the name of the shipping method. Sort on product name and sales order id.
--		HINT:  You will need to join an additional table. Add it to your database diagram first. 

SELECT p.Name AS ProductName, p.ProductNumber, 
	   sd.OrderQty, 
	   sh.SalesOrderID, 
	   sm.Name AS ShipMethod
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sd
ON p.ProductID = sd.ProductID
INNER JOIN Sales.SalesOrderHeader AS sh
ON sd.SalesOrderID = sh.SalesOrderID
INNER JOIN Purchasing.ShipMethod AS sm
ON sh.ShipMethodID = sm.ShipMethodID
WHERE sh.CustomerID = '19670'
	  AND sm.ShipMethodID IS NOT NULL
ORDER BY p.Name asc, sh.SalesOrderID asc

--6.	(6) List all sales for clothing that were ordered during 2007.  Show sales order id, product ID, 
--		product name, order quantity, and line total for each line item sale. Make certain you are  
--		retrieving only clothing. There are multiple ways to find clothing. Show the results  
--		by sales order id and product name. Hint: Refer to the diagram you created in #5. 

SELECT sd.SalesOrderID, 
	   p.ProductID, p.Name, 
	   sd.OrderQty, CAST(sd.LineTotal AS DECIMAL(10,2)) AS LineTotal
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sd
ON p.ProductID = sd.ProductID
INNER JOIN Sales.SalesOrderHeader AS sh
ON sh.SalesOrderID = sd.SalesOrderID
INNER JOIN Production.ProductSubcategory AS ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE (pc.ProductCategoryID = '3')
	  AND (sh.OrderDate LIKE '%2007%')
ORDER BY sd.SalesOrderID asc, p.Name asc
	
--7.	(2) In your own words, write a business question for AdventureWorks that you will try to answer with a SQL query.
--		Then try to develop the SQL to answer the question using at least one INNER JOIN.
--		You may find that the AdventureWorks database structure is highly normalized and therefore, difficult to work
--		with.  As a result, you may not run into difficulties when developing your SQL.  For this task that is fine.
--		Just show your question and as much SQL as you were able to figure out. 

--Which customers have received special offer discounts on their purchases, and what was the special offer?

SELECT c.CustomerID, CAST(sh.OrderDate AS DATE) AS OrderDate, sd.SpecialOfferID, so.Description
FROM Sales.Customer AS c
INNER JOIN Sales.SalesOrderHeader AS sh
ON c.CustomerID = sh.CustomerID
INNER JOIN Sales.SalesOrderDetail AS sd
ON sd.SalesOrderID = sh.SalesOrderID
INNER JOIN Sales.SpecialOffer AS so
ON sd.SpecialOfferID = so.SpecialOfferID
WHERE so.Description NOT LIKE 'No Discount'
ORDER BY c.CustomerID asc, sh.TotalDue desc, so.Description asc


