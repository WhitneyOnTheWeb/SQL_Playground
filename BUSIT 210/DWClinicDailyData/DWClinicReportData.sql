/***************************************************************************
ETL Final Project: DWClinicReportData
Dev: RRoot
Date:2/21/2017
Desc: This is a Data Warehouse for the Patient and DoctorsSchedule Databases.
	  ETL processing issues.
ChangeLog: (Who, When, What) 
			RRoot, 3/3/17, removed addresses from DimPatients
			RRoot, 3/4/17, removed addresses from DimDoctors and DimClinic
			RRoot, 3/4/17, altered the file description
*****************************************************************************/
Use Master;
go

If Exists (Select * From Sys.databases where Name = 'DWClinicReportData')
  Begin
   Alter Database DWClinicReportData set single_user with rollback immediate;
   Drop Database DWClinicReportData;
  End
go

Create Database DWClinicReportData;
go

Use DWClinicReportData;
go

Create Table DimDates
(DateKey int Identity Primary Key  
,FullDate datetime Not Null
,FullDateName nvarchar (50) Not Null 
,MonthID int Not Null
,[MonthName] nvarchar(50) Not Null
,YearID int Not Null
,YearName nvarchar(50) Not Null
);
go

Create Table DimClinics
(ClinicKey int Identity Primary Key
,ClinicID int Not Null
,ClinicName nvarchar(100) Not Null 
,ClinicCity nvarchar(100) Not Null
,ClinicState nvarchar(100) Not Null 
,ClinicZip nvarchar(5) Not Null 
);
go

Create Table DimDoctors
(DoctorKey int Identity Primary Key
,DoctorID int Not Null  
,DoctorFullName nvarchar(200) Not Null 
,DoctorEmailAddress nvarchar(100) Not Null  
,DoctorCity nvarchar(100) Not Null
,DoctorState nvarchar(100) Not Null
,DoctorZip nvarchar(5) Not Null 
);
go

Create Table DimShifts 
(ShiftKey int Identity Primary Key
,ShiftID int Not Null
,ShiftStart time(0) Not Null
,ShiftEnd time(0) Not Null
);
go

Create Table FactDoctorShifts
(DoctorsShiftID int Not Null
,ShiftDateKey int References DimDates(DateKey) Not Null
,ClinicKey int References DimClinics(ClinicKey) Not Null
,ShiftKey int References DimShifts(ShiftKey) Not Null
,DoctorKey int References DimDoctors(DoctorKey) Not Null
,HoursWorked int
Primary Key(DoctorsShiftID, ShiftDateKey , ClinicKey, ShiftKey, DoctorKey)
);
go

Create Table DimProcedures
(ProcedureKey int Primary Key Identity
,ProcedureID int Not Null
,ProcedureName varchar(100) Not Null
,ProcedureDesc varchar(1000) Not Null
,ProcedureCharge money Not Null 
);
go

Create Table DimPatients
(PatientKey int Identity Primary Key
,PatientID int Not Null
,PatientFullName varchar(100) Not Null
,PatientCity varchar(100) Not Null
,PatientState varchar(100) Not Null
,PatientZipCode int Not Null
);
go

Create Table FactVisits
(VisitKey int Not Null
,DateKey int References DimDates(DateKey) Not Null
,ClinicKey int References DimClinics(ClinicKey) Not Null
,PatientKey int References DimPatients(PatientKey) Not Null
,DoctorKey int References DimDoctors(DoctorKey) Not Null
,ProcedureKey int References DimProcedures(ProcedureKey) Not Null 
,Charge money  Not Null
Primary Key(VisitKey, DateKey, ClinicKey, PatientKey, DoctorKey, ProcedureKey)
);
go


ALTER TABLE [dbo].[FactVisits] ADD CONSTRAINT [FK_FactSalesOrders_DimCustomers] 
	FOREIGN KEY ([CustomerKey]) REFERENCES [dbo].[DimCustomers] ([CustomerKey]);
ALTER TABLE [dbo].[FactVisits] ADD CONSTRAINT [FK_FactSalesOrders_DimProducts]
	FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProducts] ([ProductKey]);
ALTER TABLE [dbo].[FactVisits] ADD CONSTRAINT [FK_FactSalesOrders_DimDates]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey]);
GO