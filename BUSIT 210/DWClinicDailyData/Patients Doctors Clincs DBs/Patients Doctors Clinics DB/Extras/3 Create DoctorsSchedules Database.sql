/*************************************************************
ETL Final Project: DoctorsSchedules
Dev: RRoot
Date:2/20/2017
Desc: This is a poorly designed database used to highlight
	  ETL processing issues.
ChangeLog: (Who, When, What) 
**************************************************************/
Use Master;
go

If Exists (Select * From Sys.databases where Name = 'DoctorsSchedules')
  Begin
   Alter Database DoctorsSchedules set single_user with rollback immediate;
   Drop Database DoctorsSchedules;
  End
go

Create Database DoctorsSchedules;
go

Use DoctorsSchedules;
go

--( Make the Tables )--
Create Table Clinics
(ClinicID int Identity Primary Key
,ClinicName nvarchar(100) 
,Address nvarchar(100)
,City nvarchar(100)
,State nvarchar(100) 
,Zip nvarchar(5) 
);
go

Create Table Doctors
(DoctorID int Identity Primary Key
,FirstName nvarchar(100) 
,LastName nvarchar(100) 
,EmailAddress nvarchar(100)  
,Address nvarchar(100)
,City nvarchar(100)
,State nvarchar(100)
,Zip nvarchar(5) 
);
go

Create Table Shifts 
(ShiftID int identity Primary Key
,ShiftStart time(0)
,ShiftEnd time(0)
);
go

Create Table DoctorShifts
(DoctorsShiftID int Identity Primary Key
,ShiftDate Datetime
,ClinicID int 
,ShiftID int
,DoctorID int
);
go

--( Make the Foreign Key Constraints )--
Alter Table DoctorShifts Add Constraint fkDoctorShiftsToClinic
  Foreign Key(ClinicID) References Clinics(ClinicID);
go
Alter Table DoctorShifts Add Constraint fkDoctorShiftsToDoctors
  Foreign Key(DoctorID) References Doctors(DoctorID);
go
Alter Table DoctorShifts Add Constraint fkDoctorShiftsToShifts
  Foreign Key(ShiftID) References Shifts(ShiftID);
go



--( Add Some Data to Tables ) --
Insert Into [dbo].[Clinics]
(ClinicName, Address, City, State, Zip)
Values ('Bellevue','123 Main Street', 'Bellevue', 'WA', '98004')
	  ,('Kirkland','789 Lake Street', 'Kirkland', 'WA','98033')
	  ,('Redmond','999 Availability Ave', 'Redmond', 'WA', '98008') 
go

Insert Into Shifts 
(ShiftStart, ShiftEnd) 
Values ('9:00','5:00'),('1:00','21:00'),('21:00','9:00')
Go

--<< Run my random DATA generator first! >>-- Select * from TempDB.dbo.RandomData;
Insert Into [dbo].[Doctors] -- With this BAD schedule doctors can be scheduled at 1, 2, or 3 clinics at the same time!
(FirstName, LastName, EmailAddress, Address, City, State, Zip)
Select Top 13 * From Tempdb.dbo.RandomData;
go
Delete Top(13) From Tempdb.dbo.RandomData;
Go

Declare @CurrentDate datetime;
Declare ListOfDates CURSOR  
    For Select FullDate From TempDB.dbo.Dates ;

Open ListOfDates; 
Fetch Next From ListOfDates Into @CurrentDate;
 
While (@@FETCH_STATUS = 0 )
Begin
	With T1	AS
	(SELECT TOP .001 PERCENT DoctorID, 1 as Clinic,1 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic, Shift FROM T1;

	With T2	AS								 
	(SELECT TOP .001 PERCENT DoctorID, 1 as Clinic,2 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic, Shift FROM T2;

	With T3	AS								 
	(SELECT TOP .001 PERCENT DoctorID, 2 as Clinic,1 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic, Shift FROM T3;

	With T4	AS								 
	(SELECT TOP .001 PERCENT DoctorID, 2 as Clinic,2 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic, Shift FROM T4;
		
	With T5	AS								 
	(SELECT TOP .001 PERCENT DoctorID, 3 as Clinic,1 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic,Shift FROM T5;
		
	With T6	AS								
	(SELECT TOP .001 PERCENT DoctorID, 3 as Clinic,2 as Shift From [dbo].[Doctors] ORDER BY NEWID())
	Insert Into [dbo].[DoctorShifts] (ShiftDate, DoctorID, ClinicID, ShiftID)
	SELECT @CurrentDate, DoctorID, Clinic, Shift FROM T6;

	Fetch Next From ListOfDates Into @CurrentDate;
END

Close ListOfDates;
Deallocate ListOfDates;
Go

Select * From [dbo].[Clinics];
Select * From [dbo].[Doctors];
Select * From [dbo].[Shifts];
Select * From [dbo].[DoctorShifts] ORDER BY 1, 2,3,4;
