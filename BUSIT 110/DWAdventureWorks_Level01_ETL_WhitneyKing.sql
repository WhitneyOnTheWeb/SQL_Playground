
--****************** [DWAdventureWorks_Level01] *********************--
-- This file will drop and create the [DWAdventureWorks_Level01]
-- database, with all its objects.
--********************************************************************--
USE [DWAdventureWorks_Level01]
GO

--********************************************************************--
-- Drop Foreign Keys Constaints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] 
	DROP CONSTRAINT [FK_FactSalesOrders_DimCustomers]  
ALTER TABLE [dbo].[FactSalesOrders] 
	DROP CONSTRAINT [FK_FactSalesOrders_DimProducts] 
ALTER TABLE [dbo].[FactSalesOrders] 
	DROP CONSTRAINT [FK_FactSalesOrders_SalesOrderDate] 
GO

--********************************************************************--
-- Clear all tables and reset their Identity Auto Number 
--********************************************************************--
TRUNCATE TABLE [dbo].[DimCustomers]
TRUNCATE TABLE [dbo].[DimProducts]
TRUNCATE TABLE [dbo].[DimDates]
TRUNCATE TABLE [dbo].[FactSalesOrders]
GO


--********************************************************************--
-- Get DimCustomer Data

--********************************************************************--

SELECT 
	[CustomerID] = 
		CAST([CustomerID] AS nchar), 
	[CustomerFullName] = 
		CAST(([FirstName] + ' ' + [LastName]) AS nchar(100)), 
	[CustomerCityName] = 
		CAST([City] AS nchar(50)), 
	[CustomerStateProvinceName] = 
		CAST([StateProvinceName] AS nchar(50)), 
	[CustomerCountryRegionCode] = 
		CAST([CountryRegionCode] AS nchar(50)), 
	[CustomerCountryRegionName] = 
		CAST ([CountryRegionName] AS nchar(50))
FROM [AdventureWorks_Level01].[dbo].[Customer]
GO

--Not loaded into the table, so this statement seems almost closer to a view than data load without further code to load the data.

--********************************************************************--
-- Get DimProducts Data

--********************************************************************--
SELECT
	[ProductID] = 
		CAST([ProductID] AS nchar), 
	[ProductName] = 
		CAST([Products].[Name] AS nchar(50)), 
	[StandardListPrice] = 
		CAST([ListPrice] AS [decimal](18, 4)), 
	[ProductSubcategoryID] = 
		CAST([ProductSubcategory].[ProductSubcategoryID] AS [int]), 
	[ProductSubcategoryName] = 
		CAST([ProductSubcategory].[Name] AS nchar(50)), 
	[ProductCategoryID] = 
		CAST([ProductCategory].[ProductCategoryID] AS [int]), 
	[ProductCategoryName] = 
		CAST([ProductCategory].[Name] AS nchar(50))
FROM [AdventureWorks_Level01].[dbo].[Products]
LEFT JOIN [AdventureWorks_Level01].[dbo].[ProductSubcategory] 
	ON [Products].[ProductSubcategoryID] = [ProductSubcategory].[ProductSubcategoryID] 
LEFT JOIN [AdventureWorks_Level01].[dbo].[ProductCategory]
	ON [ProductSubcategory].[ProductCategoryID] = [ProductCategory].[ProductCategoryID]
GO

--Not loaded into the table, so this statement seems almost closer to a view than data load without further code to load the data.

--********************************************************************--
-- Get DimDates Data
-- I am giving you the code for this one!
--********************************************************************--
-- Since the date table has no associated source table we can fill the data
-- using a SQL script 

-- Delete From DimDates
Set IDENTITY_INSERT [DimDates] ON
--This was giving me errors, so I added this to be able to load some data
INSERT INTO [DimDates] 
( [DateKey], [FullDate], [FullDateName], [MonthID], [MonthName], [YearID], [YearName] )
Values
  ( -1, Cast('01/01/1900' AS datetime), 'Unknown Day', -1, 'Unknown Month', -1 , 'Unknown Year' )
, ( -2, Cast('01/01/1900' AS datetime), 'Corrupt Day', -2, 'Corrupt Month', -2, 'Corrupt Year' )
GO
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
    Cast(Convert(nVarchar(50), @DateInProcess, 112) AS INT) -- [DateKey] = 20050101 to 20101231
  , @DateInProcess -- [FullDate] = '2005-01-01 00:00:00.000'
  , DateName(weekday, @DateInProcess ) + ', ' + DateName(mm, @DateInProcess ) + ' ' +  Convert(nVarchar(50), @DateInProcess, 110) -- [DateKey] = 20050101 to 20101231
  , Month( @DateInProcess ) -- [MonthID]   
  , DateName( month, @DateInProcess ) -- [MonthName]
  , Year( @DateInProcess ) -- [YearID] 
  , Cast( Year(@DateInProcess ) AS nVarchar(50) ) -- [YearName] 
  )  
 -- Add a day and loop again
 SET @DateInProcess = DateAdd(d, 1, @DateInProcess)
 END
 -- Select * from DimDates

 SELECT *
 FROM DimDates
 
--********************************************************************--
-- Get DimFactSalesOrders Data

--********************************************************************--
SELECT 
	[SalesOrderID] = 
		CAST([SalesOrderDetail].[SalesOrderID] AS [int]), 
	[SalesOrderDetailID] = 
		CAST([AdventureWorks_Level01].[dbo].[SalesOrderDetail].[SalesOrderDetailID] AS [int]), 
	--[OrderDate] = CAST([AdventureWorks_Level01].[dbo].[SalesOrderHeader].[OrderDate] AS [int]), 
	--I'm having issue getting ANY information to load into this table, and have some confusion about how to integrate OrderDate/DateKEy with how this hint was worded
	[OrderDateKey] = 
		CAST([DimDates].[DateKey] AS [int]), 
	--[CustomerID] = CAST([AdventureWorks_Level01].[dbo].[SalesOrderHeader].[CustomerID] AS [int]), 
	[CustomerKey] = 
		CAST([DimCustomers].[CustomerKey] AS [int]), 
	--[ProductID] = CAST([AdventureWorks_Level01].[dbo].[SalesOrderDetail].[ProductID] AS [int]), 
	[ProductKey] = 
		CAST([DimProducts].[ProductKey] AS [int]), 
	[OrderOty] = 
		CAST([AdventureWorks_Level01].[dbo].[SalesOrderDetail].[OrderQty] AS [int]), 
	[ActualUnitPrice] = 
		CAST([AdventureWorks_Level01].[dbo].[SalesOrderDetail].[UnitPrice] AS [decimal](18, 4))
FROM [AdventureWorks_Level01].[dbo].[SalesOrderDetail] 
	JOIN [AdventureWorks_Level01].[dbo].[SalesOrderHeader] 
		ON [AdventureWorks_Level01].[dbo].[SalesOrderDetail].[SalesOrderID] = [AdventureWorks_Level01].[dbo].[SalesOrderHeader].[SalesOrderID]
	JOIN [DimDates]
		ON [DimDates].[FullDate] = [AdventureWorks_Level01].[dbo].[SalesOrderHeader].[OrderDate]
	JOIN [DimCustomers]
		ON [DimCustomers].[CustomerID] = [AdventureWorks_Level01].[dbo].[SalesOrderHeader].[CustomerID]
	JOIN [DimProducts]
		ON [DimProducts].[ProductID] = [AdventureWorks_Level01].[dbo].[SalesOrderDetail].[ProductID]
GO


--********************************************************************--
-- Replace Foreign Keys Constaints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers] 
	FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey])
GO
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
	FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey])
GO
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
GO


--********************************************************************--
-- Review the results of this script
--********************************************************************--
SELECT [TableName] = '[dbo].[DimCustomers]' , [RowCount] = Count(*) FROM [dbo].[DimCustomers]
SELECT [TableName] = '[dbo].[DimDates]' , [RowCount] = Count(*) FROM [dbo].[DimDates]
SELECT [TableName] = '[dbo].[DimProducts]' , [RowCount] = Count(*) FROM [dbo].[DimProducts]
SELECT [TableName] = '[dbo].[FactSalesOrders]' , [RowCount] = Count(*) FROM [dbo].[FactSalesOrders]










