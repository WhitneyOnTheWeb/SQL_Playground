Set NoCount On; -- Turns off the annoying "One Row affected" messages 

-- 1) Make the database
USE [master];
GO
If Exists (Select * from Sys.databases Where Name = 'DWSimpleSales')
	Begin 
		ALTER DATABASE [DWSimpleSales] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE [DWSimpleSales];
	End
GO
 
CREATE DATABASE [DWSimpleSales];
GO

USE [DWSimpleSales];
GO

-- 2) Make the tables
CREATE TABLE [dbo].[DimProducts]
(
	[ProductId] [int] NOT NULL PRIMARY KEY,
	[ProductName] [varchar](100) NOT NULL
);
GO

CREATE TABLE [dbo].[FactSales]
(
	[SalesId] [int] NOT NULL,
	[SalesLineItemId] [int] NOT NULL,
	[SalesDate] [date] NOT NULL,
	[ProductId] [int] NOT NULL,
	[SalesDollars] [decimal](18,2) NULL,
	[SalesUnits] [int] NULL,	
	CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED ([SalesId] ASC, [SalesLineItemId] ASC, [SalesDate] ASC, [ProductId] ASC)
);
GO

-- 3) Fill the tables with test data
-- Add two test Products
Insert into [dbo].[DimProducts] Values (1, 'Prod1');
Insert into [dbo].[DimProducts] Values (2, 'Prod2');
GO

GO
-- Add four test Sales 
Insert into [dbo].[FactSales] Values (1,1,'1/1/' + Cast(Year(Getdate()) as varchar(4)),1,9.95,2);
Insert into [dbo].[FactSales] Values (1,2,'1/1/' + Cast(Year(Getdate()) as varchar(4)),2,21.99,1);
Insert into [dbo].[FactSales] Values (2,1,'2/1/' + Cast(Year(Getdate()) as varchar(4)),1,9.95,3);
Insert into [dbo].[FactSales] Values (3,1,'2/1/' + Cast(Year(Getdate()) as varchar(4)),2,9.95,1);
GO

-- 4) Review everything you have so far
Select * From [dbo].[DimProducts];
Select * From [dbo].[FactSales];
GO


-- 5) Demonstrate a Derived Measure
SELECT
  FactSales.SalesId
, FactSales.SalesLineItemId
, FactSales.SalesDate
, FactSales.ProductId
, DimProducts.ProductName
, FactSales.SalesDollars
, FactSales.SalesUnits
, FactSales.SalesDollars * SalesUnits AS DerivedTotalSalesPrice
-- ^ This is called a "Derived Measure" when it is create in an SSAS Data Source View  
FROM DimProducts 
INNER JOIN FactSales 
ON DimProducts.ProductId = FactSales.ProductId;