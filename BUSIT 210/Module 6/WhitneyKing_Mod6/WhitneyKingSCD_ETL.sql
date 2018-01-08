USE [DWAdventureWorks_Basics];
GO

IF (OBJECT_ID('FactSalesOrders') IS NOT NULL) 
BEGIN
	ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimCustomers];
	ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimProducts];
	ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimDates];
	TRUNCATE TABLE [dbo].[FactSalesOrders];
END;
GO

IF (OBJECT_ID('DimDates') IS NOT NULL) TRUNCATE TABLE DimDates;
GO

--Create Dimentions---------------------------------------------------------------------------------------
IF (OBJECT_ID('DimCustomers') IS NOT NULL) DROP TABLE DimCustomers;
CREATE TABLE dbo.DimCustomers
( CustomerKey int NOT NULL IDENTITY (1, 1) Primary Key
, CustomerId int NOT NULL
, CustomerFullName nvarchar(100) NOT NULL
, CustomerCityName nvarchar(50) NOT NULL
, CustomerStateProvinceName nvarchar(50) NOT NULL
, CustomerCountryRegionCode nvarchar(50) NOT NULL
, CustomerCountryRegionName nvarchar(50) NOT NULL
, StartDate datetime NOT NULL -- Added This
, EndDate datetime NULL -- Added This
, IsCurrent int NOT NULL Default (1) -- Added This
);
GO

IF (OBJECT_ID('DimProducts') IS NOT NULL) DROP TABLE DimProducts;
CREATE TABLE dbo.DimProducts
( ProductKey int NOT NULL IDENTITY (1, 1) PRIMARY KEY
, ProductID int NOT NULL
, ProductName nvarchar(100) NOT NULL
, StandardListPrice decimal(34,2) NOT NULL
, ProductSubCategoryID nvarchar(50) NOT NULL
, ProductSubCategoryName nvarchar(50) NOT NULL
, ProductCategoryID nvarchar(50) NOT NULL
, ProductCategoryName nvarchar(50) NOT NULL
, StartDate datetime NOT NULL -- Added This
, EndDate datetime NULL -- Added This
, IsCurrent int NOT NULL DEFAULT (1) -- Added This
);
GO

--Fill Dimensions------------------------------------------------------------------------------------------

--Insert Customers-----------------------------------------------------------------------------------------
WITH ChangedCustomers -- This creates a CTE we can refer back to in our code.
AS
(	-- Find any fields with customer data that have changed and insert them as a new row
	SELECT  CustomerID
		  , CustomerFullName = ([FirstName] + ' ' + [LastName])
		  , CustomerCityName = [City]
		  , CustomerStateProvinceName = [StateProvinceName]
		  , CustomerCountryRegionCode = [CountryRegionCode]
		  , CustomerCountryRegionName = [CountryRegionName]
	FROM [AdventureWorks_Basics].dbo.Customer
		EXCEPT
	SELECT  CustomerID
		  , CustomerFullName
		  , CustomerCityName
		  , CustomerStateProvinceName
		  , CustomerCountryRegionCode
		  , CustomerCountryRegionName
	FROM DimCustomers
)
INSERT INTO DimCustomers
		( CustomerId, CustomerFullName, CustomerCityName, CustomerStateProvinceName, CustomerCountryRegionCode, CustomerCountryRegionName, StartDate, EndDate, IsCurrent )
	SELECT  CustomerID
		  , CustomerFullName = Cast(([FirstName] + ' ' + [LastName]) AS nVarchar(100))
		  , CustomerCityName = Cast([City] AS nVarchar(50))
		  , CustomerStateProvinceName = Cast([StateProvinceName] AS nVarchar(50))
		  , CustomerCountryRegionCode = Cast([CountryRegionCode] AS nVarchar(50))
		  , CustomerCountryRegionName = Cast([CountryRegionName] AS nVarchar(50))
		  , StartDate = GetDate(), [EndDate] = Null, [IsCurrent] = 1
	  FROM [AdventureWorks_Basics].[dbo].[Customer]
	  WHERE CustomerID IN (SELECT CustomerID FROM ChangedCustomers);

	/*-- Compare
	SELECT * FROM [AdventureWorks_Basics].dbo.Customer;
	SELECT * FROM [DWAdventureWorks_Basics].dbo.DimCustomers;
	GO*/

--Insert Products--------------------------------------------------------------------------------------------
WITH ChangedProducts -- This creates a CTE we can refer back to in our code.
AS
(	-- Find any fields with product information that has changed, and insert a new row
	SELECT ProductID
		 , P.Name AS ProductName
		 , P.ListPrice AS StandardListPrice
		 , PSC.ProductSubcategoryID AS ProductSubCategoryID
		 , PSC.Name AS ProductSubCategoryName
		 , PC.ProductCategoryID AS ProductCategoryID
		 , PC.Name AS ProductCategoryName
	FROM [AdventureWorks_Basics].dbo.Products AS P
		INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
			ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
		INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
			ON PSC.ProductCategoryID = PC.ProductCategoryID
		EXCEPT
	SELECT ProductID
		 , ProductName
		 , StandardListPrice
		 , ProductSubCategoryID
		 , ProductSubCategoryName
		 , ProductCategoryID
		 , ProductCategoryName
	FROM DimProducts
)
INSERT INTO DimProducts
		( ProductID, ProductName, StandardListPrice, ProductSubCategoryID, ProductSubCategoryName, ProductCategoryID, ProductCategoryName, StartDate, EndDate, IsCurrent  )
	SELECT	ProductID
		  , ProductName = Cast(P.Name as nVarchar(100))
		  , StandardListPrice = Cast(P.ListPrice as decimal(34,2))
		  , ProductSubCategoryID = Cast(PSC.ProductSubcategoryID as nVarchar(50))
		  , ProductSubCategoryName = Cast(PSC.Name as nVarchar(50))
		  , ProductCategoryID = Cast(PC.ProductCategoryID as nVarchar(50))
		  , ProductCategoryName = Cast(PC.Name as nVarchar(50))
		  , StartDate = GetDate(), [EndDate] = Null, [IsCurrent] = 1
	  FROM [AdventureWorks_Basics].dbo.Products AS P
		INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
			ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
		INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
			ON PSC.ProductCategoryID = PC.ProductCategoryID
	  WHERE ProductID in (SELECT ProductID FROM ChangedProducts);

	/*-- Compare
	SELECT * FROM [AdventureWorks_Basics].dbo.Products AS P
	INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
				ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
			INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
				ON PSC.ProductCategoryID = PC.ProductCategoryID;
	SELECT * FROM [DWAdventureWorks_Basics].dbo.DimProducts;
	GO*/

--Fill Dates-------------------------------------------------------------------------------------------------
-- Create variables to hold the start and end date
DECLARE @StartDate datetime = '01/01/2005';
DECLARE @EndDate datetime = '12/31/2010'; 

-- Use a while loop to add dates to the table
DECLARE @DateInProcess datetime;
SET @DateInProcess = @StartDate;

WHILE @DateInProcess <= @EndDate
 BEGIN
	 -- Add a row into the date dimension table for this date
	 INSERT INTO DimDates
	 ([DateKey], FullDate, FullDateName, MonthID, MonthName, YearID, YearName )
	 VALUES (
		Cast(Convert(nVarchar(50),@DateInProcess,112) AS int) -- DateKey
	  , @DateInProcess -- FullDate
	  , DateName(weekday,@DateInProcess) + ',' + Cast(Year(@DateInProcess) AS nVarchar(50)) -- FullDateName
	  , Month(@DateInProcess ) -- MonthID  
	  , DateName(month, @DateInProcess) -- MonthName
	  , Year(@DateInProcess) -- YearID
	  , Cast(Year(@DateInProcess) AS nVarchar(50)) -- YearName
	  )  
	 -- Add a day and loop again
	 SET @DateInProcess = DateAdd(d, 1, @DateInProcess)
 END

-- Add additional lookup values to DimDates
SET @DateInProcess = '01/01/1900';
INSERT INTO [DimDates] 
	 ([DateKey], FullDate, FullDateName, MonthID, MonthName, YearID, YearName )
	 VALUES (
		-1 -- DateKey
	  , @DateInProcess -- FullDate
	  , 'NA' -- FullDateName
	  , Month(@DateInProcess ) -- MonthID  
	  , DateName(month, @DateInProcess) -- MonthName
	  , Year(@DateInProcess) -- YearID
	  , Cast(Year(@DateInProcess) AS nVarchar(50)) -- YearName
	  );
	    
SET @DateInProcess = '01/02/1900';
INSERT INTO [DimDates] 
	 ([DateKey], FullDate, FullDateName, MonthID, MonthName, YearID, YearName )
	 VALUES (
		-2 -- DateKey
	  , @DateInProcess -- FullDate
	  , 'Corrupt'
	  , Month(@DateInProcess ) -- MonthID  
	  , DateName(month, @DateInProcess) -- MonthName
	  , Year(@DateInProcess) -- YearID
	  , Cast(Year(@DateInProcess) AS nVarchar(50)) -- YearName
	  ); 
GO

--Fill FactSalesOrders--------------------------------------------------------------------------------
INSERT INTO [dbo].[FactSalesOrders]
	(SalesOrderID, SalesOrderDetailID, OrderDateKey, CustomerKey, ProductKey, OrderQty, ActualUnitPrice)
	SELECT [SalesOrderID] = SOH.SalesOrderID
		  ,[SalesOrderDetailID] = SOD.SalesOrderDetailID
		  ,[OrderDateKey] =  DD.DateKey
		--, SOH.OrderDate
		  ,[CustomerKey] = DC.CustomerKey
		  --,SOH.CustomerID
		  ,[ProductKey] = DP.ProductKey
		  --,SOD.ProductID
	  	  ,[OrderQty] = SOD.OrderQty
		  ,[ActualUnitPrice] = SOD.UnitPrice
	FROM [AdventureWorks_Basics].dbo.SalesOrderDetail AS SOD
		INNER JOIN [AdventureWorks_Basics].dbo.SalesOrderHeader AS SOH 
			ON SOD.SalesOrderID = SOH.SalesOrderID 
				JOIN [dbo].[DimDates] AS DD
			ON DD.FullDate = SOH.OrderDate
				JOIN [dbo].[DimProducts] AS DP
			ON DP.ProductID = SOD.ProductID
				JOIN [dbo].[DimCustomers] AS DC
			ON DC.CustomerId = SOH.CustomerID;

ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers] 
	FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey]);
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
	FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey]);
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey]);
GO

--Update Customers---------------------------------------------------------------------------------
WITH ChangedCustomers
AS
(	
	SELECT  CustomerID
		  , CustomerFullName = ([FirstName] + ' ' + [LastName])
		  , CustomerCityName = [City]
		  , CustomerStateProvinceName = [StateProvinceName]
		  , CustomerCountryRegionCode = [CountryRegionCode]
		  , CustomerCountryRegionName = [CountryRegionName]
	FROM [AdventureWorks_Basics].dbo.Customer
		EXCEPT
	SELECT  CustomerID
		  , CustomerFullName
		  , CustomerCityName
		  , CustomerStateProvinceName
		  , CustomerCountryRegionCode
		  , CustomerCountryRegionName
	FROM DimCustomers
	WHERE IsCurrent = 1 --Only update rows that are current
)
UPDATE DimCustomers
	SET EndDate = GetDate(),
		IsCurrent = 0
	WHERE CustomerId IN (SELECT CustomerId FROM ChangedCustomers);

--Update Products---------------------------------------------------------------------------------
WITH ChangedProducts -- This creates a CTE we can refer back to in our code.
AS
(	
	SELECT ProductID
		 , P.Name AS ProductName
		 , P.ListPrice AS StandardListPrice
		 , PSC.ProductSubcategoryID AS ProductSubCategoryID
		 , PSC.Name AS ProductSubCategoryName
		 , PC.ProductCategoryID AS ProductCategoryID
		 , PC.Name AS ProductCategoryName
	FROM [AdventureWorks_Basics].dbo.Products AS P
		INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
			ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
		INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
			ON PSC.ProductCategoryID = PC.ProductCategoryID
		EXCEPT
	SELECT ProductID
		 , ProductName
		 , StandardListPrice
		 , ProductSubCategoryID
		 , ProductSubCategoryName
		 , ProductCategoryID
		 , ProductCategoryName
	FROM DimProducts
	WHERE IsCurrent = 1 --Only update rows that are current
)
UPDATE DimProducts
	SET EndDate = GetDate(),
		IsCurrent = 0
	WHERE ProductID IN (SELECT ProductID FROM ChangedProducts);

--Stored Procedures------------------------------------------------------------------------
IF (OBJECT_ID('pETLInsDimCustomers') IS NOT NULL) DROP PROCEDURE pETLInsDimCustomers;
GO
CREATE PROCEDURE pETLInsDimCustomers
 /* 
  Dev: Whitney King
  Desc: Insert Customer data into DimCustomers
  Changelog: 2/8/2017 - Created new stored procedure
 */
  AS 
  BEGIN 
    DECLARE @ReturnCode int
	--( add validation code here )--
    BEGIN TRY
		WITH ChangedCustomers -- This creates a CTE we can refer back to in our code.
		AS
		(	-- Find any fields with customer data that have changed and insert them as a new row
			SELECT  CustomerID
				  , CustomerFullName = ([FirstName] + ' ' + [LastName])
				  , CustomerCityName = [City]
				  , CustomerStateProvinceName = [StateProvinceName]
				  , CustomerCountryRegionCode = [CountryRegionCode]
				  , CustomerCountryRegionName = [CountryRegionName]
			FROM [AdventureWorks_Basics].dbo.Customer
				EXCEPT
			SELECT  CustomerID
				  , CustomerFullName
				  , CustomerCityName
				  , CustomerStateProvinceName
				  , CustomerCountryRegionCode
				  , CustomerCountryRegionName
			FROM DimCustomers
		)
		INSERT INTO DimCustomers
				( CustomerId, CustomerFullName, CustomerCityName, CustomerStateProvinceName, CustomerCountryRegionCode, CustomerCountryRegionName, StartDate, EndDate, IsCurrent  )
		SELECT  CustomerID
			  , CustomerFullName = Cast(([FirstName] + ' ' + [LastName]) AS nVarchar(100))
			  , CustomerCityName = Cast([City] AS nVarchar(50))
			  , CustomerStateProvinceName = Cast([StateProvinceName] AS nVarchar(50))
			  , CustomerCountryRegionCode = Cast([CountryRegionCode] AS nVarchar(50))
			  , CustomerCountryRegionName = Cast([CountryRegionName] AS nVarchar(50))
			  , StartDate = GetDate(), [EndDate] = Null, [IsCurrent] = 1
		FROM [AdventureWorks_Basics].[dbo].[Customer]
		WHERE CustomerID IN (SELECT CustomerID FROM ChangedCustomers);
	SET @ReturnCode = 100 -- success code
	END TRY
	BEGIN CATCH
	--( add error handling code here )--
	SET @ReturnCode = -100 -- fail code
	END CATCH
	RETURN @ReturnCode
  END;
GO

IF (object_id('pETLUpdDimCustomers') IS NOT NULL) DROP PROCEDURE pETLUpdDimCustomers;
GO
CREATE PROCEDURE pETLUpdDimCustomers
 /* 
  Dev: Whitney King
  Desc: Insert Customer data into DimProducts
  Changelog: 2/8/2017 - Created new stored procedure
			 2/9/2017 - Insert update DimCustomers CTE
 */
  AS 
  BEGIN 
    DECLARE @ReturnCode int
	--( add validation code here )--
    BEGIN TRY
		WITH ChangedCustomers
		AS
		(	
			SELECT  CustomerID
				  , CustomerFullName = ([FirstName] + ' ' + [LastName])
				  , CustomerCityName = [City]
				  , CustomerStateProvinceName = [StateProvinceName]
				  , CustomerCountryRegionCode = [CountryRegionCode]
				  , CustomerCountryRegionName = [CountryRegionName]
			FROM [AdventureWorks_Basics].dbo.Customer
				EXCEPT
			SELECT  CustomerID
				  , CustomerFullName
				  , CustomerCityName
				  , CustomerStateProvinceName
				  , CustomerCountryRegionCode
				  , CustomerCountryRegionName
			FROM DimCustomers
			WHERE IsCurrent = 1 --Only update rows that are current
		)
		UPDATE DimCustomers
			SET EndDate = GetDate(),
				IsCurrent = 0
			WHERE CustomerId IN (SELECT CustomerId FROM ChangedCustomers);
	SET @ReturnCode = 100 -- success code
	END TRY
	BEGIN CATCH
	--( add error handling code here )--
	SET @ReturnCode = -100 -- fail code
	END CATCH
	RETURN @ReturnCode
  END;
GO


IF (OBJECT_ID('pETLInsDimProducts') IS NOT NULL) DROP PROCEDURE pETLInsDimProducts;
GO
CREATE PROCEDURE pETLInsDimProducts
 /* 
  Dev: Whitney King
  Desc: Insert product data into DimProducts
  Changelog: 2/9/2017 - Created new stored procedure
 */
  AS 
  BEGIN 
    DECLARE @ReturnCode int
	--( add validation code here )--
    BEGIN TRY
		WITH ChangedProducts -- This creates a CTE we can refer back to in our code.
		AS
		(	-- Find any fields with product information that has changed, and insert a new row
			SELECT ProductID
				 , P.Name AS ProductName
				 , P.ListPrice AS StandardListPrice
				 , PSC.ProductSubcategoryID AS ProductSubCategoryID
				 , PSC.Name AS ProductSubCategoryName
				 , PC.ProductCategoryID AS ProductCategoryID
				 , PC.Name AS ProductCategoryName
			FROM [AdventureWorks_Basics].dbo.Products AS P
				INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
					ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
				INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
					ON PSC.ProductCategoryID = PC.ProductCategoryID
				EXCEPT
			SELECT ProductID
				 , ProductName
				 , StandardListPrice
				 , ProductSubCategoryID
				 , ProductSubCategoryName
				 , ProductCategoryID
				 , ProductCategoryName
			FROM DimProducts
		)
		INSERT INTO DimProducts
				( ProductID, ProductName, StandardListPrice, ProductSubCategoryID, ProductSubCategoryName, ProductCategoryID, ProductCategoryName, StartDate, EndDate, IsCurrent  )
			SELECT	ProductID
				  , ProductName = Cast(P.Name as nVarchar(100))
				  , StandardListPrice = Cast(P.ListPrice as decimal(34,2))
				  , ProductSubCategoryID = Cast(PSC.ProductSubcategoryID as nVarchar(50))
				  , ProductSubCategoryName = Cast(PSC.Name as nVarchar(50))
				  , ProductCategoryID = Cast(PC.ProductCategoryID as nVarchar(50))
				  , ProductCategoryName = Cast(PC.Name as nVarchar(50))
				  , StartDate = GetDate(), [EndDate] = Null, [IsCurrent] = 1
			  FROM [AdventureWorks_Basics].dbo.Products AS P
				INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
					ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
				INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
					ON PSC.ProductCategoryID = PC.ProductCategoryID
			  WHERE ProductID in (SELECT ProductID FROM ChangedProducts);
	SET @ReturnCode = 100 -- success code
	END TRY
	BEGIN CATCH
	--( add error handling code here )--
	SET @ReturnCode = -100 -- fail code
	END CATCH
	RETURN @ReturnCode
  END;
GO

IF (object_id('pETLUpdDimProducts') IS NOT NULL) DROP PROCEDURE pETLUpdDimProducts;
GO
CREATE PROCEDURE pETLUpdDimProducts
 /* 
  Dev: Whitney King
  Desc: Update product data in DimProducts
  Changelog: 2/9/2017 - Created new stored procedure
 */
  AS 
  BEGIN 
    DECLARE @ReturnCode int
	--( add validation code here )--
    BEGIN TRY
		WITH ChangedProducts -- This creates a CTE we can refer back to in our code.
		AS
		(	
			SELECT ProductID
				 , P.Name AS ProductName
				 , P.ListPrice AS StandardListPrice
				 , PSC.ProductSubcategoryID AS ProductSubCategoryID
				 , PSC.Name AS ProductSubCategoryName
				 , PC.ProductCategoryID AS ProductCategoryID
				 , PC.Name AS ProductCategoryName
			FROM [AdventureWorks_Basics].dbo.Products AS P
				INNER JOIN [AdventureWorks_Basics].dbo.ProductSubcategory  AS PSC
					ON P.ProductSubcategoryID = PSC.ProductSubcategoryID 
				INNER JOIN [AdventureWorks_Basics].dbo.ProductCategory AS PC
					ON PSC.ProductCategoryID = PC.ProductCategoryID
				EXCEPT
			SELECT ProductID
				 , ProductName
				 , StandardListPrice
				 , ProductSubCategoryID
				 , ProductSubCategoryName
				 , ProductCategoryID
				 , ProductCategoryName
			FROM DimProducts
			WHERE IsCurrent = 1 --Only update rows that are current
		)
		UPDATE DimProducts
			SET EndDate = GetDate(),
				IsCurrent = 0
			WHERE ProductID IN (SELECT ProductID FROM ChangedProducts);
	SET @ReturnCode = 100 -- success code
	END TRY
	BEGIN CATCH
	--( add error handling code here )--
	SET @ReturnCode = -100 -- fail code
	END CATCH
	RETURN @ReturnCode
  END;
GO

--Master Procedures-------------------------------------------------------------------------------

IF (OBJECT_ID('pETLDimensionInsertUpdate') IS NOT NULL) DROP PROCEDURE pETLDimensionInsertUpdate;
GO
CREATE -- DROP 
PROCEDURE pETLDimensionInsertUpdate
 /* 
  Dev: Whitney King
  Desc: Execute insert/update stored procedures for DimCustomers
  Changelog: 2/9/2017 - Created new stored procedure
 */
  AS 
  BEGIN 
    DECLARE @ReturnCode int
	--( add validation code here )--
    BEGIN TRY
		--EXECUTE pETLUpdDimCustomers; --Added an update execution prior to insert in order to check for changes and make updates before inserting the new records.
		EXECUTE pETLInsDimCustomers;
		EXECUTE pETLUpdDimCustomers;
		EXECUTE pETLInsDimProducts;
		EXECUTE pETLUpdDimProducts;
		--Delete stored procedure not included since this is a Type 2 SCD with historical records
	SET @ReturnCode = 100 -- success code
	END TRY
	BEGIN CATCH
	--( add error handling code here )--
	SET @ReturnCode = -100 -- fail code
	END CATCH
	RETURN @ReturnCode
  END;
GO