--****************** [DWAdventureWorks_Level01] *********************--
-- This file will drop and create the [DWAdventureWorks_Level01]
-- database, with all its objects. 
--****************** Instructors Version ***************************--

USE [master]
GO
If Exists (Select * from Sysdatabases Where Name = 'DWAdventureWorks_Level01')
	Begin 
		ALTER DATABASE [DWAdventureWorks_Level01] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [DWAdventureWorks_Level01]
	End
GO
Create Database [DWAdventureWorks_Level01]
Go

--********************************************************************--
-- Create the Tables
--********************************************************************--
USE [DWAdventureWorks_Level01]
Go

/****** [dbo].[DimProducts] ******/
CREATE TABLE [dbo].[DimProducts](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[StandardListPrice] [decimal](18, 4) NOT NULL,
	[ProductSubCategoryID] [int] NOT NULL,
	[ProductSubCategoryName] [nvarchar](50) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[ProductCategoryName] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_DimProducts] PRIMARY KEY CLUSTERED
	([ProductKey])
) 
Go

/****** [dbo].[DimCustomers] ******/
CREATE TABLE [dbo].[DimCustomers](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CustomerFullName] [nvarchar](100) NOT NULL,
	[CustomerCityName] [nvarchar](50) NOT NULL,
	[CustomerStateProvinceName] [nvarchar](50) NOT NULL,
	[CustomerCountryRegionCode] [nvarchar](50) NOT NULL,
	[CustomerCountryRegionName] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_DimCustomers] PRIMARY KEY CLUSTERED
	([CustomerKey] ASC )
)
Go

/****** [dbo].[FactSalesOrders] ******/
CREATE TABLE [dbo].[FactSalesOrders](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[OrderQty] [int] NOT NULL,
	[ActualUnitPrice] [decimal](18, 4) NOT NULL,
	CONSTRAINT [PK_FactSalesOrders] PRIMARY KEY CLUSTERED 
	([SalesOrderID],[SalesOrderDetailID],[OrderDateKey],[CustomerKey],[ProductKey])
) ON [PRIMARY]
Go

/****** [dbo].[DimDates] ******/
CREATE TABLE [dbo].[DimDates](
	[DateKey] [int],
	[FullDate] [datetime] NOT NULL,
	[FullDateName] [nvarchar](50) NULL,
	[MonthID] [int] NOT NULL,
	[MonthName] [nvarchar](50) NOT NULL,
	[YearID] [int] NOT NULL,
	[YearName] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_DimDates] PRIMARY KEY CLUSTERED
	([DateKey] )
)
Go

--********************************************************************--
-- Create the FOREIGN KEY CONSTRAINTS
--********************************************************************--

ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers] 
	FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey])
Go
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
	FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey])
Go
ALTER TABLE [dbo].[FactSalesOrders] ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
Go


--********************************************************************--
-- Review the results of this script
--********************************************************************--
Select 'Database Created'
Select Name, xType, CrDate from SysObjects 
Where xType in ('u', 'PK', 'F')
Order By xType desc, Name

