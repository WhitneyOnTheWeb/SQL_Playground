USE [master]
GO
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DWAdventureWorks_Level01')
  BEGIN
     -- Close connections to the DWNorthwindOrders database 
    ALTER DATABASE [DWAdventureWorks_Level01] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [DWAdventureWorks_Level01]
  END
GO

CREATE DATABASE [DWAdventureWorks_Level01] ON  PRIMARY 
( NAME = N'DWAdventureWorks_Level01'
, FILENAME = N'C:\_BISolutions\AdventureWorks\DWAdventureWorks_Level01.mdf' 
, SIZE = 10MB 
, MAXSIZE = 1GB
, FILEGROWTH = 10MB )
 LOG ON 
( NAME = N'DWAdventureWorks_Level01_log'
, FILENAME = N'C:\_BISolutions\AdventureWorks\DWAdventureWorks_Level01_log.LDF' 
, SIZE = 1MB 
, MAXSIZE = 1GB 
, FILEGROWTH = 10MB)
GO
EXEC [DWAdventureWorks_Level01].dbo.sp_changedbowner @loginame = N'SA', @map = false
GO
ALTER DATABASE [DWAdventureWorks_Level01] SET RECOVERY BULK_LOGGED 
GO

------------------------------------------------------------------------------------------

USE [DWAdventureWorks_Level01]
GO

/****** Create the Fact Tables ******/
--FactSalesOrders
CREATE TABLE [dbo].[FactSalesOrders](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[OrderQty] [int] NOT NULL,
	[ActualUnitPrice] [decimal](18,4) NOT NULL
	CONSTRAINT [PK_FactSalesOrders] PRIMARY KEY
	(
	[SalesOrderID],
	[SalesOrderDetailID],
	[OrderDateKey],
	[CustomerKey],
	[ProductKey]
	)
) 
GO

/****** Create the Dimension Tables ******/
-- DimCustomers 
CREATE TABLE [dbo].[DimCustomers](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CustomerID] [nchar](5) NOT NULL,
	[CustomerFullName] [nvarchar](100) NOT NULL,
	[CustomerCityName] [nvarchar](50) NOT NULL,
	[CustomerStateProvinceName] [nvarchar](50) NOT NULL,
	[CustomerCountryRegionCode] [nvarchar](50) NOT NULL,
	[CustomerCountryRegionName] [nvarchar](50) NOT NULL
) 
GO

--DimProducts
CREATE TABLE [dbo].[DimProducts](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[ProductCategoryName] [nvarchar](100) NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductSubcategoryName] [nvarchar](100) NOT NULL,
	[StandardListPrice] [decimal](18,4) NOT NULL
)
GO

--DimDates
CREATE TABLE [dbo].[DimDates](
	[DateKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[FullDate] [datetime] NOT NULL UNIQUE,
	[FullDateName] [nvarchar](50) NULL,
	[MonthID] [int] NOT NULL,
	[MonthName] [nvarchar](50) NOT NULL,
	[YearID] [int] NOT NULL,
	[YearName] [nvarchar](50) NOT NULL,
)
GO

/****** Add Foreign Keys ******/
ALTER TABLE dbo.FactSalesOrders ADD CONSTRAINT
	FK_FactSalesOrders_DimCustomers FOREIGN KEY
	(CustomerKey) REFERENCES dbo.DimCustomers(CustomerKey) 

ALTER TABLE dbo.FactSalesOrders ADD CONSTRAINT
	FK_FactSalesOrders_DimProducts FOREIGN KEY
	(ProductKey) REFERENCES dbo.DimProducts(ProductKey) 

ALTER TABLE dbo.FactSalesOrders ADD CONSTRAINT
	FK_FactSalesOrders_SalesOrderDate FOREIGN KEY
	(OrderDateKey) REFERENCES dbo.DimDates([DateKey]) 

GO

-----------------------------------------------------------------------

--Backup Database
BACKUP DATABASE [DWAdventureWorks_Level01] 
TO  DISK = 
N'C:\_BISolutions\AdventureWorks\DWAdventureworks\DWAdventureWorks_Level01_BeforeETL.bak'
WITH INIT
GO

--RestoreDatabase
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DWAdventureWorks_Level01')
  BEGIN
    ALTER DATABASE [DWAdventureWorks_Level01] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  END


USE [master]
RESTORE DATABASE [DWAdventureWorks_Level01] 
FROM DISK = 
N'C:\_BISolutions\AdventureWorks\DWAdventureworks\DWAdventureWorks_Level01_BeforeETL.bak'
WITH REPLACE
GO
