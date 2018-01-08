
--****************** [DWAdventureWorks_Level01] *********************--
-- This file will drop and create the [DWAdventureWorks_Level01]
-- database, with all its objects.
--********************************************************************--
USE [DWAdventureWorks_Level01]
--Go

--********************************************************************--
-- Drop Foreign Keys Constraints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimProducts]
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimDates]
ALTER TABLE [dbo].[FactSalesOrders] DROP CONSTRAINT [FK_FactSalesOrders_DimCustomers]
--Go

--********************************************************************--
-- Clear all tables and reset their Identity Auto Number 
--********************************************************************--
Truncate Table [dbo].[FactSalesOrders]
Truncate Table [dbo].[DimProducts]
Truncate Table [dbo].[DimDates]
Truncate Table [dbo].[DimCustomers]
--Go

--********************************************************************--
-- Get DimCusomter Data
--********************************************************************--
		--Insert Into DimCustomers
		--(CustomerId, CustomerFullName, CustomerCityName, CustomerStateProvinceName, CustomerCountryRegionCode, CustomerCountryRegionName)
Select 
  CustomerID
, CustomerFullName = Cast((FirstName + ' ' + LastName) as nVarchar(100))
, CustomerCityName = City
, CustomerStateProvinceName = StateProvinceName
, CustomerCountryRegionCode = CountryRegionCode
, CustomerCountryRegionName = CountryRegionName 
From [AdventureWorks_Level01].[dbo].[Customer]
--Go


--********************************************************************--
-- Get DimProducts Data
--********************************************************************--
		 --Insert Into DimProducts
		 --( ProductID, ProductName, StandardListPrice, ProductSubCategoryID, ProductSubCategoryName, ProductCategoryID, ProductCategoryName )
Select 
  ProductID
, ProductName = Products.Name
, StandardListPrice = Cast(ListPrice as decimal(18,4))
, ProductSubCategoryID = IsNull(ProductSubcategory.ProductSubcategoryID, -1)
, ProductSubCategoryName = IsNull(ProductSubcategory.Name, 'NA')
, ProductCategoryID = IsNull(ProductCategory.ProductCategoryID, -1)
, ProductCategoryName = IsNull(ProductCategory.Name, 'NA') 
From [AdventureWorks_Level01].[dbo].[Products]
Left Join [AdventureWorks_Level01].[dbo].[ProductSubcategory] 
On [Products].[ProductSubcategoryID] = [ProductSubcategory].[ProductSubcategoryID] 
Left Join [AdventureWorks_Level01].[dbo].[ProductCategory]
On [ProductSubcategory].[ProductCategoryID] = [ProductCategory].[ProductCategoryID]
--Go

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
--Go
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
--Go
 -- Select * from DimDates
 
 
--********************************************************************--
-- Get FactSalesOrders Data
--********************************************************************--
		--Insert Into [dbo].[FactSalesOrders]
		--(SalesOrderID, SalesOrderDetailID, OrderDateKey, CustomerKey, ProductKey, OrderQty, ActualUnitPrice)
Select 
	  SalesOrderID = [AdventureWorks_Level01].dbo.SalesOrderDetail.SalesOrderID
	, SalesOrderDetailID = [AdventureWorks_Level01].dbo.SalesOrderDetail.SalesOrderDetailID
	--, [AdventureWorks_Level01].dbo.SalesOrderHeader.OrderDate
	, OrderDateKey = DimDates.DateKey
	--, [AdventureWorks_Level01].dbo.SalesOrderHeader.CustomerID
	, CustomerKey = DimCustomers.CustomerKey
	--, [AdventureWorks_Level01].dbo.SalesOrderDetail.ProductID
	, ProductKey  = DimProducts.ProductKey
	, OrderQty = [AdventureWorks_Level01].dbo.SalesOrderDetail.OrderQty
	, ActualUnitPrice  = Cast([AdventureWorks_Level01].dbo.SalesOrderDetail.UnitPrice as decimal(18,4))
From [AdventureWorks_Level01].dbo.SalesOrderDetail 
Join [AdventureWorks_Level01].dbo.SalesOrderHeader 
	On [AdventureWorks_Level01].dbo.SalesOrderDetail.SalesOrderID = [AdventureWorks_Level01].dbo.SalesOrderHeader.SalesOrderID
Join DimDates
	On DimDates.FullDate = [AdventureWorks_Level01].dbo.SalesOrderHeader.OrderDate
Join DimCustomers
	On DimCustomers.CustomerID = [AdventureWorks_Level01].dbo.SalesOrderHeader.CustomerID
Join DimProducts
	On DimProducts.ProductID = [AdventureWorks_Level01].dbo.SalesOrderDetail.ProductID
--Go

--********************************************************************--
-- Replace Foreign Keys Constraints
--********************************************************************--
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers] 
	FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey])
--Go
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
	FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey])
--Go
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
--Go

--********************************************************************--
-- Review the results of this script
--********************************************************************--
--Select 'Database Filled'
--Select [TableName] = '[dbo].[DimCustomers]' , [RowCount] = Count(*) from [dbo].[DimCustomers]
--Select [TableName] = '[dbo].[DimDates]' , [RowCount] = Count(*) from [dbo].[DimDates]
--Select [TableName] = '[dbo].[DimProducts]' , [RowCount] = Count(*) from [dbo].[DimProducts]
--Select [TableName] = '[dbo].[FactSalesOrders]' , [RowCount] = Count(*) from [dbo].[FactSalesOrders]










