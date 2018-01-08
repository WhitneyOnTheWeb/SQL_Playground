Use TempDB;
GO
If (object_id('Numbers') is not null) Drop Table TempDB.dbo.Numbers;
If (object_id('EmailDomains') is not null) Drop Table TempDB.dbo.EmailDomains;
If (object_id('CityStates') is not null) Drop Table TempDB.dbo.CityStates;
If (object_id('RandomData') is not null) Drop Table TempDB.dbo.RandomData;
If (object_id('vSeedData') is not null) Drop View vSeedData
GO

--( Create a view to gather Seed data ! )--
CREATE VIEW vSeedData
AS
SELECT        
  C.FirstName
, C.LastName
, A.AddressLine1
FROM AdventureWorksLT2012.SalesLT.Address as A
INNER JOIN AdventureWorksLT2012.SalesLT.CustomerAddress as CA
	ON A.AddressID = CA.AddressID 
INNER JOIN AdventureWorksLT2012.SalesLT.Customer as C
ON CA.CustomerID = C.CustomerID
GO


-- (Random Names and Address) --
Create -- Drop
table TempDB.dbo.Numbers (Number nvarchar(100));
Go
Declare @Counter int = 1;
While (@Counter < 1000)
Begin
	Insert Into TempDB.dbo.Numbers Values(@Counter)
	SET @Counter = @Counter + 1;
END
Go
-- Select * From TempDB.dbo.Numbers

Create -- Drop
table TempDB.dbo.EmailDomains (Domain nvarchar(100));
Go
Insert into TempDB.dbo.EmailDomains 
 Values
	 ('@MyCo.com')
	,('@YayYou.com')
	,('@GSale.com')
	,('@WarmMail.com');
Go

Create -- Drop
table TempDB.dbo.CityStates (City nvarchar(100), State nvarchar(100), Zip nvarchar(5));
Go
Insert into TempDB.dbo.CityStates 
 Values
	 ('Seattle','WA', '98101' ),('Seattle','WA', '98101'),('Seattle','WA', '98101'),('Seattle','WA', '98101'),('Seattle','WA', '98101')
	,('Bellevue','WA', '98004'),('Bellevue','WA', '98004'),('Bellevue','WA', '98004'),('Bellevue','WA', '98004')
	,('Redmond','WA', '98008'),('Redmond','WA', '98008'),('Redmond','WA', '98008')
	,('Lynnwood','WA', '98036'),('Lynnwood','WA', '98036')
	,('Woodnville','WA', '98072')
	,('Bothell','WA', '98011')
	,('Mill Creek','WA', '98012')
;
Go
-- Select * From TempDB.dbo.CityStates

Create -- Drop
table TempDB.dbo.RandomData 
( FirstName nvarchar(100)
, LastName nvarchar(100)
, Email nvarchar(100)
, Address nvarchar(100)
, City nvarchar(100)
, State nvarchar(100)
, Zip nvarchar(5)
);
Go

Declare @Counter int = 0;
While (@Counter < 999)
Begin
	With T1
	AS
	(
	SELECT TOP .001 PERCENT FirstName
	  From TempDB.dbo.vSeedData -- Set this to a DB with seed data
	  ORDER BY NEWID()
	)
	, T2
	AS
	(
	SELECT TOP .001 PERCENT LastName
	  From TempDB.dbo.vSeedData -- Set this to a DB with seed data
	  ORDER BY NEWID()
	)
	, T3
	AS
	(
	SELECT TOP .001 PERCENT Domain
	  From TempDB.dbo.EmailDomains
	  ORDER BY NEWID()
	)
	, T4
	AS
	(
	SELECT TOP .001 PERCENT StreeNumber = Number
	  From TempDB.dbo.Numbers
	  ORDER BY NEWID()
	)
	, T5
	AS
	(
	SELECT TOP .001 PERCENT [Address] = SUBSTRING(AddressLine1,PatIndex('% %',AddressLine1), 100)
	  From TempDB.dbo.vSeedData
	  ORDER BY NEWID()
	)
	, T6
	AS
	(
	SELECT TOP .001 PERCENT City, State, Zip
	  From TempDB.dbo.CityStates
	  --  Using the Where Clause instead of Order By is faster on very Large datasets!
	  --  https://msdn.microsoft.com/en-us/library/cc441928.aspx
	  --  WHERE (ABS(CAST( (BINARY_CHECKSUM(*) * RAND()) as int)) % 100) < 10 
	  ORDER BY NEWID()
	)
	Insert into TempDB.dbo.RandomData
	Select Distinct 
	  FirstName 
	, LastName
	, Email = Left(FirstName,1) + LastName + Domain
	, [Address] = StreeNumber + Address -- Will have bad data!! Good of ETL classes.
	, City
	, State
	, Zip 
	From t1 cross join t2 cross join t3 cross join t4 cross join t5 cross join t6
	Order By 1
	;
	SET @Counter = @Counter + 1;
END
Go

Select Top 50 * 
 From Tempdb.dbo.RandomData Order by 5,6;
Go
Select City, State, [TimesInTable] = Count(City) 
 From Tempdb.dbo.RandomData 
 Group by City, State 
 Order By 2,3




-- --- You can export data to a CSV file and use this Code for Inserts --
--Select Top 50 FirstName, LastName, Email, Address, City, State
--From Tempdb.dbo.RandomData

--USE [tempdb]
--GO
--CREATE TABLE [dbo].[ImportTest](
--	[FirstName] [nvarchar](100) NULL,
--	[LastName] [nvarchar](100) NULL,
--	[Email] [nvarchar](100) NULL,
--	[Address] [nvarchar](100) NULL,
--	[City] [nvarchar](100) NULL,
--	[State] [nvarchar](100) NULL
--) ON [PRIMARY];
--GO


