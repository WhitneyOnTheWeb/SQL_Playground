
--****************** [DWBUSIT110FinalDB] *********************--
-- This file contains code used to clear and fill 
-- the [DWBUSIT110FinalDB]database tables.
--********************************************************************--
USE DWBUSIT110FinalDB
--GO

--********************************************************************--
-- Drop Foreign Keys Constraints
--********************************************************************--
ALTER TABLE FactEnrollments
	DROP CONSTRAINT FK_FactEnrollments_DimDates
ALTER TABLE FactEnrollments
	DROP CONSTRAINT FK_FactEnrollments_DimStudents
ALTER TABLE FactEnrollments
	DROP CONSTRAINT FK_FactEnrollments_DimClasses
--GO

--********************************************************************--
-- Clear all tables and reset their Identity Auto Number 
--********************************************************************--
TRUNCATE TABLE DimClasses
TRUNCATE TABLE DimStudents
TRUNCATE TABLE DimDates
TRUNCATE TABLE FactEnrollments
--GO

--********************************************************************--
-- Get DimStudents Data
--********************************************************************--

SELECT
	StudentID = 
		CAST(StudentID AS int),
	StudentFullName = 
		CAST((StudentFirstName + ' ' + StudentLastName) AS nVarchar(100)),
	StudentEmail = 
		CAST(StudentEmail AS nVarchar(100))
FROM BUSIT110FinalDB.dbo.Students
--GO

--********************************************************************--
-- Get DimClasses Data
--********************************************************************--
SELECT 
	ClassID = 
		CAST(ClassID AS int),
	ClassName = 
		CAST(ClassName AS nVarchar(100)),
	CurrentClassPrice = 
		CAST(CurrentClassPrice AS decimal(18,2))
FROM BUSIT110FinalDB.dbo.Classes
--GO

--********************************************************************--
-- Get DimDates Data
--********************************************************************--
-- Since the date table has no associated source table we can fill the data
-- using a SQL script 

-- Delete From DimDates
INSERT INTO [DimDates] 
( [DateKey], [FullDate], [FullDateName], [MonthID], [MonthName], [YearID], [YearName] )
Values
  ( -1, Cast('01/01/1900' as datetime), 'Unknown Day', -1, 'Unknown Month', -1 , 'Unknown Year' )
, ( -2, Cast('01/02/1900' as datetime), 'Corrupt Day', -2, 'Corrupt Month', -2, 'Corrupt Year' )
--Go
-- Create variables to hold the start and end date
DECLARE @StartDate datetime = '01/01/2012'
DECLARE @EndDate datetime = '12/31/2013' 

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
  , Month( @DateInProcess ) + (Year(@DateInProcess ) * 100)  -- [MonthID]   
  , DateName( month, @DateInProcess ) + ' ' + Cast( Year(@DateInProcess ) as nVarchar(50) ) -- [MonthName]
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
--Insert Into [dbo].[FactEnrollments]
--(EnrollmentID, EnrollmentDateKey, StudentKey, ClassKey, ActualEnrollmentPrice)
SELECT        
	EnrollmentID = 
		BUSIT110FinalDB.dbo.Enrollments.EnrollmentID,
--, Enrollments.EnrollmentDate
	EnrollmentDateKey =
		DimDates.DateKey,
--, Enrollments.StudentID
	StudentKey = 
		DimStudents.StudentKey,
--, Enrollments.ClassID
	ClassKey = 
		DimClasses.ClassKey,
	ActualEnrollmentPrice = 
		BUSIT110FinalDB.dbo.Enrollments.ActualEnrollmentPrice
FROM BUSIT110FinalDB.dbo.Enrollments
INNER JOIN DimDates 
  ON dbo.DimDates.FullDate = BUSIT110FinalDB.dbo.Enrollments.EnrollmentDate
INNER JOIN DimClasses 
  ON DWBUSIT110FinalDB.dbo.DimClasses.ClassID = BUSIT110FinalDB.dbo.Enrollments.ClassID 
INNER JOIN DimStudents 
  ON DWBUSIT110FinalDB.dbo.DimStudents.StudentID = BUSIT110FinalDB.dbo.Enrollments.StudentID
--Go

--**************************************************************** ****--
-- Replace Foreign Keys Constraints
--********************************************************************--
ALTER TABLE dbo.FactEnrollments ADD CONSTRAINT
	FK_FactEnrollments_DimDates FOREIGN KEY
	(EnrollmentDateKey) REFERENCES dbo.DimDates(DateKey)

ALTER TABLE dbo.FactEnrollments ADD CONSTRAINT
	FK_FactEnrollments_DimStudents FOREIGN KEY
	(StudentKey) REFERENCES dbo.DimStudents(StudentKey)

ALTER TABLE dbo.FactEnrollments ADD CONSTRAINT
	FK_FactEnrollments_DimClasses FOREIGN KEY
	(ClassKey) REFERENCES dbo.DimClasses(ClassKey)
--GO

--********************************************************************--
-- Review the results of this script
--********************************************************************--
Select 'Database Filled'
Select [TableName] = '[dbo].[DimClasses]' , [RowCount] = Count(*) from [dbo].[DimClasses]
Select [TableName] = '[dbo].[DimDates]' , [RowCount] = Count(*) from [dbo].[DimDates]
Select [TableName] = '[dbo].[DimStudents]' , [RowCount] = Count(*) from [dbo].[DimStudents]
Select [TableName] = '[dbo].[FactEnrollments]' , [RowCount] = Count(*) from [dbo].[FactEnrollments]










