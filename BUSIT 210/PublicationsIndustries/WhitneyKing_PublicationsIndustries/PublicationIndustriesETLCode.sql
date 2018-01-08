
--****************** [DWAdventureWorks_Basics] *********************--
-- This file will drop and create the [DWAdventureWorks_Basics]
-- database, with all its objects.
--********************************************************************--
USE [DWAdventureWorks_Basics]
GO

--********************************************************************--
-- Drop Foreign Keys Constaints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimCustomers]
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimDates]
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimProducts]
GO

--********************************************************************--
-- Clear all tables and reset their Identity Auto Number 
--********************************************************************--
TRUNCATE TABLE [dbo].[DimCustomers]
TRUNCATE TABLE [dbo].[DimDates]
TRUNCATE TABLE [dbo].[DimProducts]
TRUNCATE TABLE [dbo].[FactSalesOrders]
GO

--********************************************************************--
-- Get DimCustomer Data
	/* HINT:
		Select 
		  CustomerID
		, FirstName 
		, LastName
		, City
		, StateProvinceName
		, CountryRegionCode
		, CountryRegionName 
		From [AdventureWorks_Basics].[dbo].[Customer]
	*/
--********************************************************************--
-- Insert into DimCustomers -- Use this to test your select statment!
INSERT INTO [DWAdventureWorks_Basics].[dbo].[DimCustomers]
	( [CustomerID], [CustomerFullName], [CustomerCityName], [CustomerStateProvinceName], [CustomerCountryRegionCode], [CustomerCountryRegionName] )
	SELECT
		  [CustomerID] = [CustomerID]
		, [CustomerFullName] = CAST ([FirstName] + ' ' + [LastName] AS nvarChar(100))
		, [CustomerCityName] = CAST ([City] AS nvarChar(50))
		, [CustomerStateProvinceName] = CAST ([StateProvinceName] AS nvarChar(50))
		, [CustomerCountryRegionCode] = CAST ([CountryRegionCode] AS nvarChar(50))
		, [CustomerCountryRegionName] = CAST ([CountryRegionName] AS nvarChar(50))
	FROM [AdventureWorks_Basics].[dbo].[Customer]

--********************************************************************--
-- Get DimProducts Data
	/* HINT:
		 Select 
		   ProductID
		 , Products.Name
		 , ListPrice
		 , ProductSubcategory.ProductSubcategoryID
		 , ProductSubcategory.Name
		 , ProductCategory.ProductCategoryID
		 , ProductCategory.Name
		 From [AdventureWorks_Basics].[dbo].[Products]
		 Left Join [AdventureWorks_Basics].[dbo].[ProductSubcategory] 
			On [Products].[ProductSubcategoryID] = [ProductSubcategory].[ProductSubcategoryID] 
		 Left Join [AdventureWorks_Basics].[dbo].[ProductCategory]
			On [ProductSubcategory].[ProductCategoryID] = [ProductCategory].[ProductCategoryID]
	*/
--********************************************************************--
-- Insert into DimProducts -- Use this to test your select statment!
INSERT INTO [DWAdventureWorks_Basics].[dbo].[DimProducts]
	( [ProductID], [ProductName], [StandardListPrice], [ProductSubCategoryID], [ProductSubCategoryName], [ProductCategoryID], [ProductCategoryName] )
	Select 
		   [ProductID] = [ProductID]
		 , [ProductName] = CAST([Products].[Name] AS nvarChar(50))
		 , [StandardListPrice] = CAST(ListPrice AS decimal(18,4))
		 , [ProductSubCategoryID] = isNull([ProductSubcategory].[ProductSubcategoryID], '-1')
		 , [ProductSubCategoryName] = CAST(isNull([ProductSubcategory].[Name], 'NA') AS nvarChar(50))
		 , [ProductCategoryID] = isNull([ProductCategory].[ProductCategoryID], '-1')
		 , [ProductCategoryName] = CAST(isNull([ProductCategory].[Name], 'NA') AS nvarChar(50))
	FROM [AdventureWorks_Basics].[dbo].[Products]
		LEFT JOIN [AdventureWorks_Basics].[dbo].[ProductSubcategory] 
			ON [Products].[ProductSubcategoryID] = [ProductSubcategory].[ProductSubcategoryID] 
		LEFT JOIN [AdventureWorks_Basics].[dbo].[ProductCategory]
			ON [ProductSubcategory].[ProductCategoryID] = [ProductCategory].[ProductCategoryID]

--********************************************************************--
-- Get DimDates Data
-- I am giving you the code for this one!
--********************************************************************--
-- Since the date table has no associated source table we can fill the data
-- using a SQL script 

-- Delete From DimDates
INSERT INTO [DimDates] 
( [DateKey], [FullDate], [FullDateName], [MonthID], [MonthName], [YearID], [YearName] )
Values
  ( -1, Cast('01/01/1900' as datetime), 'Unknown Day', -1, 'Unknown Month', -1 , 'Unknown Year' )
, ( -2, Cast('01/01/1900' as datetime), 'Corrupt Day', -2, 'Corrupt Month', -2, 'Corrupt Year' )
Go
-- Create variables to hold the start and end date
DECLARE @StartDate datetime = '01/01/2005'
DECLARE @EndDate datetime = '01/01/2010' 

-- Use a while loop to add dates to the table
DECLARE @DateInProcess datetime
SET @DateInProcess = @StartDate

WHILE @DateInProcess <= @EndDate
 BEGIN
 -- Add a row into the date dimension table for this date
 INSERT INTO DimDates 
 ( [DateKey], [FullDate], [FullDateName], [MonthID], [MonthName], [YearID], [YearName] )
 VALUES (
    Cast(Convert(nVarchar(50), @DateInProcess, 112) as int) -- [DateKey] = 20050101 to 20101231
  , @DateInProcess -- [FullDate] = '2005-01-01 00:00:00.000'
  , DateName(weekday, @DateInProcess ) + ', ' + DateName(mm, @DateInProcess ) + ' ' +  Convert(nVarchar(50), @DateInProcess, 110) -- [DateKey] = 20050101 to 20101231
  , Month( @DateInProcess ) -- [MonthID]   
  , DateName( month, @DateInProcess ) -- [MonthName]
  , Year( @DateInProcess ) -- [YearID] 
  , Cast( Year(@DateInProcess ) as nVarchar(50) ) -- [YearName] 
  )  
 -- Add a day and loop again
 SET @DateInProcess = DateAdd(d, 1, @DateInProcess)
 END
GO
 -- SELECT * FROM [DimDates]

 
--********************************************************************--
-- Get FactSalesOrders Data
	/* HINT:
		Select 
			  [AdventureWorks_Basics].dbo.SalesOrderDetail.SalesOrderID
			, [AdventureWorks_Basics].dbo.SalesOrderDetail.SalesOrderDetailID
			, [AdventureWorks_Basics].dbo.SalesOrderHeader.OrderDate
			, [OrderDateKey] = DimDates.DateKey
			, [AdventureWorks_Basics].dbo.SalesOrderHeader.CustomerID
			, DimCustomers.CustomerKey
			, [AdventureWorks_Basics].dbo.SalesOrderDetail.ProductID
			, DimProducts.ProductKey
			, [AdventureWorks_Basics].dbo.SalesOrderDetail.OrderQty
			, [AdventureWorks_Basics].dbo.SalesOrderDetail.UnitPrice
		From [AdventureWorks_Basics].dbo.SalesOrderDetail 
		Join [AdventureWorks_Basics].dbo.SalesOrderHeader 
			On [AdventureWorks_Basics].dbo.SalesOrderDetail.SalesOrderID = [AdventureWorks_Basics].dbo.SalesOrderHeader.SalesOrderID
		Join DimDates
			On DimDates.FullDate = [AdventureWorks_Basics].dbo.SalesOrderHeader.OrderDate
		Join DimCustomers
			On DimCustomers.CustomerID = [AdventureWorks_Basics].dbo.SalesOrderHeader.CustomerID
		Join DimProducts
			On DimProducts.ProductID = [AdventureWorks_Basics].dbo.SalesOrderDetail.ProductID
  */
--********************************************************************--
-- Insert into FactSalesOrders -- Use this to test your select statment!
INSERT INTO [DWAdventureWorks_Basics].[dbo].[FactSalesOrders]
	( [SalesOrderID], [SalesOrderDetailID], [OrderDateKey], [CustomerKey], [ProductKey], [OrderQty], [ActualUnitPrice] )
	SELECT 
			  [SalesOrderID] = [AdventureWorks_Basics].[dbo].[SalesOrderDetail].[SalesOrderID]
			, [SalesOrderDetailID] = [AdventureWorks_Basics].[dbo].[SalesOrderDetail].[SalesOrderDetailID]
			, [OrderDateKey] = CAST([DimDates].[DateKey] AS int) --DateKey used here and joined to dbo.SalesOrderHeader.OrderDate to return the correct date
			, [CustomerKey] = [DimCustomers].[CustomerKey] --CustomerID from dbo.SalesOrderHeader joined here for key lookup
			, [ProductKey] = [DimProducts].[ProductKey] --ProductID from dbo.SalesOrderDetail joined here for key lookup
			, [OrderQty] = CAST([AdventureWorks_Basics].[dbo].[SalesOrderDetail].[OrderQty] AS int)
			, [ActualUnitPrice] = CAST([AdventureWorks_Basics].[dbo].[SalesOrderDetail].[UnitPrice] AS decimal(18,4))
	FROM [AdventureWorks_Basics].[dbo].[SalesOrderDetail]
		JOIN [AdventureWorks_Basics].[dbo].[SalesOrderHeader] 
			ON [AdventureWorks_Basics].[dbo].[SalesOrderDetail].[SalesOrderID] = [AdventureWorks_Basics].[dbo].[SalesOrderHeader].[SalesOrderID]
		JOIN [DimDates] --Surrogate lookup for [OrderDateKey]
			ON [DimDates].[FullDate] = [AdventureWorks_Basics].[dbo].[SalesOrderHeader].[OrderDate]
		JOIN [DimCustomers] --Surrogate lookup for [CustomerKey]
			ON [DimCustomers].[CustomerID] = [AdventureWorks_Basics].[dbo].[SalesOrderHeader].[CustomerID]
		JOIN [DimProducts] --Surrogate lookup for [ProductKey]
			ON [DimProducts].[ProductID] = [AdventureWorks_Basics].[dbo].[SalesOrderDetail].[ProductID]
GO

--********************************************************************--
-- Replace Foreign Keys Constaints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] WITH CHECK ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers]
FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey])

ALTER TABLE [dbo].[FactSalesOrders] WITH CHECK ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])

ALTER TABLE [dbo].[FactSalesOrders] WITH CHECK ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey])

GO

--********************************************************************--
-- Review the results of this script
--********************************************************************--
SELECT 'Database Filled'
SELECT [TableName] = '[dbo].[DimCustomers]' , [RowCount] = Count(*) FROM [dbo].[DimCustomers]
SELECT [TableName] = '[dbo].[DimDates]' , [RowCount] = Count(*) FROM [dbo].[DimDates]
SELECT [TableName] = '[dbo].[DimProducts]' , [RowCount] = Count(*) FROM [dbo].[DimProducts]
SELECT [TableName] = '[dbo].[FactSalesOrders]' , [RowCount] = Count(*) FROM [dbo].[FactSalesOrders]










