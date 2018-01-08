/*************************************************************
ETL Final Project: PatientDB
Dev: RRoot
Date:2/20/2017
Desc: This is a poorly designed database used to highlight
	  ETL processing issues.
ChangeLog: (Who, When, What) 
**************************************************************/
Use Master;
go

If Exists (Select * From Sys.databases where Name = 'Patients')
  Begin
   Alter Database Patients set single_user with rollback immediate;
   Drop Database Patients;
  End
go

Create Database Patients;
go

Use Patients;
go

--( Make the Tables )--
Create Table Patients
([ID] int Identity Primary Key
,[FName] varchar(28) 
,[LName] varchar(29)
,[Email] varchar(100)
,[Address] varchar(97)
,[City] varchar(72)
,[State] varchar(50)
,[ZipCode] int
)
go

Create Table Clinics
([ID] int Identity (100,100) Primary Key
,[Name] varchar(50) 
,[Address] varchar(100)
,[City] varchar(50)
)
go

Create Table Doctors
([ID] int Identity Primary Key
,[FName] varchar(28) 
,[LName] varchar(19)
)
go

Create Table Procedures
([ID] int Primary Key Identity
,[Name] varchar(100) 
,[Desc] varchar(1000)
,[Charge] money Null
)
go

Create Table Visits
([ID] int Identity Primary Key
,[Date] Datetime
,[Clinic] int
,[Patient] int
,[Doctor] int
,[Procedure] int 
,[Charge] money
)
go

--( Make the Foreign Key Constraints )--
Alter Table Visits Add Constraint fkClinics
  Foreign Key([Clinic]) References Clinics(ID);
go
Alter Table Visits Add Constraint fkPatients
  Foreign Key([Patient]) References Patients(ID);
go
Alter Table Visits Add Constraint fkDoctors
  Foreign Key([Doctor]) References Doctors(ID);
go
Alter Table Visits Add Constraint fkProcedures
  Foreign Key([Procedure]) References Procedures(ID);
go

--( Add Some Data )--
--<< Run my random DATA generator first! >>-- Select * from TempDB.dbo.RandomData;
Insert Into [dbo].[Patients] (FName, LName, Email, Address, City, State, ZipCode)
Select Top 4321 FirstName, LastName, Email, Address, City, State, Zip From Tempdb.dbo.RandomData;
go
Delete Top(4321) From Tempdb.dbo.RandomData;
go

--<< Run my Create DoctorsSchedules Database first! >>-- Select * from [DoctorsSchedules].[dbo].[Doctors];
Insert Into [dbo].[Doctors] (FName, LName)
Select [FirstName],[LastName]From [DoctorsSchedules].[dbo].[Doctors]
go

--<< Run my Create DoctorsSchedules Database first! >>-- Select * from [DoctorsSchedules].[dbo].[Clinics];
Insert Into [dbo].[Clinics](Name, Address, City)
Select [ClinicName],[Address],[City] From [DoctorsSchedules].[dbo].[Clinics]
go

Insert Into [dbo].[Procedures] ([Desc], Name, Charge) 
Values
 ('Interview and evaluation, described as brief','Brief interview & evalua',188)
,('Interview and evaluation, described as limited','Limited interview/evalua',188)
,('Interview and evaluation, described as comprehensive','Comprehen interview/eval',188)
,('Other interview and evaluation','Interview & evaluat NEC',188)
,('Diagnostic interview and evaluation, not otherwise specified','Interview & evaluat NOS',188)
,('Consultation, described as limited','Limited consultation',288)
,('Consultation, described as comprehensive','Comprehensive consultattation',288)
,('Other consultation','Consultation NEC',288)
,('Consultation, not otherwise specified','Consultation NOS',288)
,('Therapeutic ultrasound of vessels of head and neck','Ther ult head & neck ves',348)
,('Therapeutic ultrasound of heart','Ther ultrasound of heart',438)
,('Therapeutic ultrasound of peripheral vascular vessels','Ther ult peripheral ves',435)
,('Intravascular imaging of extracranial cerebral vessels','IVUS extracran cereb ves',448)
,('Intravascular imaging of intrathoracic vessels','IVUS intrathoracic ves',568)
,('Intravascular imaging of peripheral vessels','IVUS peripheral vessels',488)
,('Intravascular imaging of coronary vessels','IVUS coronary vessels',488)
,('Intravascular imaging of renal vessels','IVUS renal vessels',588)
,('Intravascular imaging, other specified vessel(s)','Intravascul imaging NEC',488)
,('Intravascular imaging, unspecified vessel(s)','Intravascul imaging NOS',488)
,('Diagnostic ultrasound of head and neck','Dx ultrasound-head/neck',488)
,('Diagnostic ultrasound of heart','Dx ultrasound-heart',588)
,('Diagnostic ultrasound of other sites of thorax','Dx ultrasound-thorax NEC',588)
,('Diagnostic ultrasound of digestive system','Dx ultrasound-digestive',388)
,('Diagnostic ultrasound of urinary system','Dx ultrasound-urinary',678)
,('Diagnostic ultrasound of abdomen and retroperitoneum','Dx ultrasound-abdomen',348)
,('Diagnostic ultrasound of peripheral vascular system','Dx ultrasound-vascular',548)
,('Diagnostic ultrasound of gravid uterus','Dx ultrasound-grav uter',652)
,('Other diagnostic ultrasound','Dx ultrasound NEC',345)
,('Ultrasound study of eye','Ultrasound study of eye',423)
,('Other retroperitoneal x-ray','Retroperitoneal xray NEC',234)
,('Other x-ray of abdomen','Abdominal x-ray NEC',342)
,('Skeletal x-ray of shoulder and upper arm','Skl xray-shoulder/up arm',388)
,('Skeletal x-ray of elbow and forearm','Skel xray-elbow/forearm',388)
,('Skeletal x-ray of wrist and hand','Skel xray-wrist & hand',388)
,('Skeletal x-ray of upper limb',' not otherwise specified,Skel xray-upper limb NOS',488)
,('Pelvimetry','Pelvimetry',488)
,('Other skeletal x-ray of pelvis and hip','Skel xray-pelvis/hip NEC',345)
,('"Skeletal x-ray of thigh, knee, and lower leg','Skel xray-thigh/knee/leg',452)
,('Skeletal x-ray of ankle and foot','Skel xray-ankle & foot',345)
,('Skeletal x-ray of lower limb, not otherwise specified','Skel xray-lower limb NOS',538)
,('Skeletal series','Skeletal series x-ray',343)
,('Contrast arthrogram','Contrast arthrogram',238)
,('Other skeletal x-ray','Other skeletal x-ray',788)
,('Lymphangiogram of upper limb','Upper limb lymphangiogrm',348)
,('Other soft tissue x-ray of upper limb','Up limb sft tis xray NEC',788)
,('Lymphangiogram of lower limb','Lower limb lymphangiogrm',258)
,('Other soft tissue x-ray of lower limb','Lo limb sft tis xray NEC',388)
,('Other computerized axial tomography','Other C.A.T. scan',788)
,('X-ray, other and unspecified','X-ray NEC and NOS',188)
go

--<< Run my random EVENTS generator first! >>-- Select * from TempDB.dbo.RandomEvents;

-- Insert Into [dbo].[Visits](Date, Clinic, Patient, Doctor, Procedure, Charge)
Declare
 @CurrentDate datetime = '2005-01-01'
,@ShiftID int
,@ClinicID int
,@ConvertedClinicID int
,@PatientID int
,@DoctorID int
,@ProcedureID int
,@Charge money;

Declare ListOfDates CURSOR  
    For Select FullDate from tempdb.dbo.RandomEvents Order By 1 ;

Open ListOfDates; 
Fetch Next From ListOfDates Into @CurrentDate;
 
While (@@FETCH_STATUS = 0 )
Begin

	With T1 AS -- Get Random Time
	( SELECT TOP .001 PERCENT FullTime From [tempdb].[dbo].[Times] ORDER BY NEWID() )
	 Select  @CurrentDate = @CurrentDate + Cast(T1.FullTime as Datetime) From T1;
	
	With T2	AS  -- Get Shift based on Chosen time
	( Select Case 
		 When Cast(@CurrentDate as Time(0)) > '09:00:00' And Cast(@CurrentDate as Time(0)) <= '13:00:00' Then 1
		 When Cast(@CurrentDate as Time(0)) > '13:00:00' And Cast(@CurrentDate as Time(0)) <= '21:00:00' Then 2
		 Else 3
		 End AS ShiftID )
	 Select @ShiftID = T2.ShiftID From T2;
	
	With T3	AS -- Get Random Clinic
	( SELECT TOP .001 PERCENT ID  From [dbo].[Clinics] ORDER BY NEWID() )
	Select @ClinicID = T3.ID from T3;

	With T4	AS -- Convert Clinic IDs
	( Select Case ID
		 When 100 Then 1
		 When 200 Then 2
		 Else 3
		 End AS ConvertedClinicID
	  From Clinics
	  Where ID = @ClinicID )
	Select @ConvertedClinicID = T4.ConvertedClinicID from T4;

	With T5	AS -- Get Random Patient
	( SELECT TOP .001 PERCENT Patients.ID  From [dbo].[Patients]  ORDER BY NEWID() )
	Select @PatientID = T5.ID from T5;

	With T6 AS -- Lookup Doctor on that day and shift								 
	( SELECT  [DoctorID], D.ShiftDate, D.ShiftID, D.ClinicID  
	  From [DoctorsSchedules].[dbo].[DoctorShifts] as D
	  Where Cast(D.ShiftDate as Date) = Cast(@CurrentDate as Date)
	    And D.[ShiftID] = @ShiftID
	    AND D.ClinicID = @ConvertedClinicID
	) Select @DoctorID = T6.DoctorID from T6;
	
	With T7	AS -- Get Random Procedure
	( SELECT TOP .001 PERCENT ID, Charge From [dbo].[Procedures]  ORDER BY NEWID() )
	Select @ProcedureID = T7.ID, @Charge = Charge from T7;
	
	Insert Into [dbo].[Visits]
	(Date, Clinic, Patient, Doctor, [Procedure], Charge)
	Select 
	 [Date] = @CurrentDate 
	--,[Shift] =  @ShiftID
	,[Clinic] = @ClinicID
	,[Patient] = @PatientID
	,[Doctor] = @DoctorID
	,[Procedure] = @ProcedureID
	,[Charge] = @Charge;

	Fetch Next From ListOfDates Into @CurrentDate;
END

Close ListOfDates;
Deallocate ListOfDates;


Select * from [dbo].[Clinics];
Select * from [dbo].[Doctors];
Select * from [dbo].[Patients];
Select * from [dbo].[Procedures];
Select * from [dbo].[Visits];
