Use TempDB;
GO
If (object_id('Dates') is not null) Drop Table TempDB.dbo.Dates;
If (object_id('Times') is not null) Drop Table TempDB.dbo.Times;
If (object_id('RandomEvents') is not null) Drop Table TempDB.dbo.RandomEvents;
GO
--( Create Some Seed Data ! )--
Create Table TempDB.dbo.Dates (DateID int, FullDate date);
go
DECLARE @StartDate datetime = '01/01/2005', @EndDate datetime = '01/01/2010'; 
DECLARE @DateInProcess datetime = @StartDate;
WHILE @DateInProcess <= @EndDate
 BEGIN
 INSERT INTO TempDB.dbo.Dates ( [DateID], [FullDate] )
 VALUES (Cast(Convert(nVarchar(50), @DateInProcess, 112) as int) , @DateInProcess ); 
 SET @DateInProcess = DateAdd(d, 1, @DateInProcess);
 END
Go
-- Select * from TempDB.dbo.Dates; 

Create Table TempDB.dbo.Times (TimeID int identity, FullTime time)
go
DECLARE @StartTime time(0) = '09:00', @EndTime time(0) = '21:00';
DECLARE @TimeInProcess time = @StartTime; 
WHILE @TimeInProcess <= @EndTime
 BEGIN
 INSERT INTO TempDB.dbo.Times ( [FullTime] ) VALUES ( @TimeInProcess )  
 SET @TimeInProcess = DateAdd(MINUTE, 15, @TimeInProcess)
 END
--Go
-- Select * from TempDB.dbo.Times; 

-- Create a table for the data
Create Table TempDB.dbo.RandomEvents (ID int Identity, FullDate date, FullTime time);
Go

Declare @Counter int = 0;
While (@Counter < (365 * 5 * 22)) -- days - years - events per day
Begin
	With T1	AS
	(SELECT TOP .001 PERCENT FUllDate From TempDB.dbo.Dates  ORDER BY NEWID())
	, T2 AS
	(SELECT TOP .001 PERCENT FUllTime From TempDB.dbo.Times  ORDER BY NEWID()
	)
	Insert into TempDB.dbo.RandomEvents
	Select Distinct FullDate, FullTime From t1 cross join t2 Order By 1
	;
	SET @Counter = @Counter + 1;
END
Go
Select * from TempDB.dbo.Dates;
Select * from TempDB.dbo.Times;
Select * from TempDB.dbo.RandomEvents Order By 2,3; 