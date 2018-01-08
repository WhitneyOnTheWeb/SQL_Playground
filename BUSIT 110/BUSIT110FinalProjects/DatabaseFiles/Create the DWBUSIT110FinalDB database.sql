--****************** [DWBUSIT110FinalDB] *****************************************--
-- This file will drop and create the [DWBUSIT110FinalDB]
-- database, with all its objects. 
--****************** Instructors Version + Whitney King***************************--

USE master
If Exists (Select Name from SysDatabases Where Name = 'DWBUSIT110FinalDB')
  Begin
   ALTER DATABASE DWBUSIT110FinalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
   DROP DATABASE DWBUSIT110FinalDB
  End
Go
Create Database DWBUSIT110FinalDB;
Go
USE DWBUSIT110FinalDB;
Go

--********************************************************************--
-- Create the Tables
--********************************************************************--
/****** [dbo].[DimStudents] ******/
CREATE TABLE DimStudents(
	StudentKey int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	StudentID int NOT NULL,
	StudentFullName nVarchar(100) NOT NULL,
	StudentEmail nVarchar(100) NOT NULL
)
GO

/****** [dbo].[DimClasses] ******/
CREATE TABLE DimClasses(
	ClassKey int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ClassID int NOT NULL,
	ClassName nVarchar(100) NOT NULL,
	CurrentClassPrice decimal(18,2) NOT NULL
)
GO

/****** [dbo].[DimDates] ******/
CREATE TABLE DimDates(
	DateKey int,
	FullDate datetime NOT NULL,
	FullDateName nvarchar(50) NULL,
	MonthID int NOT NULL,
	MonthName nvarchar(50) NOT NULL,
	YearID int NOT NULL,
	YearName nvarchar(50) NOT NULL,
	PRIMARY KEY (DateKey)
)
Go

/****** [dbo].[FactEnrollments] ******/
CREATE TABLE FactEnrollments(
	EnrollmentID int NOT NULL,
	EnrollmentDateKey int NOT NULL,
	StudentKey int NOT NULL,
	ClassKey int NOT NULL,
	ActualEnrollmentPrice decimal(18,2) NOT NULL
	CONSTRAINT PK_FactEnrollments PRIMARY KEY(
		EnrollmentID,
		EnrollmentDateKey,
		StudentKey,
		ClassKey
	)
)
GO

--********************************************************************--
-- Create the FOREIGN KEY CONSTRAINTS
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

GO

--********************************************************************--
-- Create Reporting Views
--********************************************************************--
Go
Create View StudentEnrollments
AS
SELECT  
  FactEnrollments.EnrollmentID
, DimDates.FullDate
, DimStudents.StudentFullName
, DimClasses.ClassName
, DimClasses.CurrentClassPrice
, FactEnrollments.ActualEnrollmentPrice
FROM DimClasses 
INNER JOIN FactEnrollments 
  ON DimClasses.ClassKey = FactEnrollments.ClassKey 
INNER JOIN DimDates 
  ON FactEnrollments.EnrollmentDateKey = DimDates.DateKey 
INNER JOIN DimStudents 
  ON FactEnrollments.StudentKey = DimStudents.StudentKey
Go

--********************************************************************--
-- Review the results of this script
--********************************************************************--
Select 'Database Created'
Select Name, xType, CrDate from SysObjects 
Where xType in ('u', 'PK', 'F')
Order By xType desc, Name


