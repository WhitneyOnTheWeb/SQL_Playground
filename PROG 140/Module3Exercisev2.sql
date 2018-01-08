/*  PROG 140          Module 3 Assignment  
POINTS 50              DUE DATE :  Consult course calendar
							
Develop a SQL statement for each task listed.  This exercise uses the Northwind database.

Please type your SQL statement under each task below.  Ensure your statement works by testing it prior to turning it in
When writing answers for your select statements please keep in mind that there is more than one way to write a query. 
Please do your best to write a query that not only returns the information the questions asks for but to the best of your 
ability, in the best way possible to suit their needs. For example, consider the best way to sort, to name columns, etc. 
These are things you must think about on the job!
 
Turn In:

A WORD document (instead of a .sql file) in which you have copied and pasted your entire work from your .sql file including 
all assignment questions and your SQL queries. (Unfortunately, it turns out that pasting the file directly into the tool doesn't  
work well so please upload the Word document only. Please do not upload a zip file. Thanks for your understanding!)  The Word  
document should contain your name at the top, assignment title, the date and any difficulties encountered. 

Submit your file to the instructor using the Canvas Assignment tool.  
 
*/
-- Whitney King   |   PROG 140   |   4/30/2015 
-- Tasks:  

/*
1.  Create database and table statements: 
	 Create a brand new 3-4 table database of your choosing.  Each table in the database must include a primary key column
	 and multiple other columns as appropriate to implement your design, but keep it simple and add only approximate 3-5 columns per table.
	 (Use the demo file example of the Testing database as a guide to the size.) 
	 
	 Design each column in your tables with appropriate data types and good naming conventions. Create Table statements should specify the primary key
	 and the null or not null column constraint for each column. If you choose to have an identity column for any of your tables, please specify this in the Create 
	 statement as well. Please do not use the Create table statement to specify Foreign key, check and default constraints.  Create these as instructed in 
	 step #2 below.

	 Note: after the Create Database statement  you will need to include a line with only the word "go" on it.  (this indicates a batch -- we'll cover this in scripting)

2.  Alter table statements:  Alter the tables in your database (use the Alter table statement) to add Foreign key constraints and Check and Default constraints.  
	 Your database MUST include at least 2 check constraints, at least 2 default constraints and at least two foreign key constraints. 

3.  Create Index Statements:  Create appropriate indexes on your database in addition to the Primary Key index that will have been created in the
	 Create table statements in #1.  There should be at least 1 additional index on each table.  This index may be a composite index, unique index 
	 or a simple one column index.  

	 NOTE: Think carefully before you choose which column will be the clustered index on each table and explain your decision in comments. Keep in mind that:
	 * there can be only one clustered index on a table and it is not always true that the best choice is the primary key
	 * although a clustered index is created by default when you create a primary key, you can use the keyword "nonclustered" in the primary key constraint 
	    so that it is not the clustered index on the table. 

4.  Insert statements:  Write 3-4 insert statements per table in  your database to test your design and ensure it is solid. 

5.  Select statements:  Write a select statement for each table in your database to print all columns and all rows for all of your tables

6.  sp_Help statements:  Execute an sp_help statement for each table.

*/
-- write all of your sql statements here to create and load your database with all tables, constraints and indexes as specified above. Be sure to include the Create database statement 
-- so that the instructor can simply copy and execute all of your statements to create and load your database. You may NOT use the SSMS script tool to script out your data
-- base!  You must include statements you wrote yourself here and please format it cleanly and use good organization and commenting (minimal). Please test this out 
-- prior to submission by creating and dropping your whole database more than once!  

/*
6.  through 10.

	Create a SQL script and in this script place all your statements from the last exercise (Module 3 #1-6) for creating and loading your database.
	This script MUST include the following elements:

	*  Your name, date, and a brief description of the contents and purpose of your script SQL comments at the top bracketed by /* */.
	*  A check near the beginning of your script to determine whether the database you're creating exists and if so to drop it.
	*  At least 3-4 "print" statements within the script that include the date and time and that will be executed as the script progresses
	    to demonstrate its progress
	*  Appropriate commenting with organized and neat statements
	*  Simple Try-Catch error handling - similar to what was demonstrated and used in the CreateandLoadTestingDB.sql file included in this module's files. 
*/
-- write your sql statement in a separate file and then copy/paste as usual into a Word doc and submit. You will 
-- be submitting two Word files:  one for questions 1-5 and the other for this script, ie., questions 6-10.  

/*	
	Author: Whitney King	|	PROG 140	|	May 6, 2015	 
	
	This script will check if a HobbyStore database has already been made, and if so it will drop it, starting from a clean slate.
	Additionally, it will have print scripts that show the date progress as the batches are processed, and will use a try/catch 
	statement for error handling.
*/

--Create Database

BEGIN TRY 

PRINT 'Begin Database Creation and Load: ' + CAST(GETDATE() AS NVARCHAR(20))

IF DB_ID('HobbyStore') IS NOT NULL
	DROP DATABASE HobbyStore;

CREATE DATABASE HobbyStore;

--Create Tables
USE HobbyStore;

PRINT 'Begin Table Creation: '+ CAST(GETDATE() AS NVARCHAR(20))  

--DROP TABLE Employees;
CREATE TABLE Employees
	(EmpID int NOT NULL IDENTITY(1,1)
		CONSTRAINT PK_Employees PRIMARY KEY,
	 EmpFirstName nvarchar(50) NOT NULL,
	 EmpLastName nvarchar(50) NOT NULL,
	 EmpHireDate datetime NULL,
	 City nvarchar(50) NULL);

--DROP TABLE Customers;
CREATE TABLE Customers
	(CustID int NOT NULL IDENTITY(1,1)
		CONSTRAINT PK_Customers PRIMARY KEY,
	 CustFirstName nvarchar(50) NOT NULL,
	 CustLastName nvarchar(50) NOT NULL,
	 CustPhone nvarchar(20) NULL);

--DROP TABLE Products;
CREATE TABLE Products
	(ProdID int NOT NULL IDENTITY(1,1)
		CONSTRAINT PK_Products PRIMARY KEY,
	 ProdName nvarchar(50) NOT NULL,
	 UnitPrice money NULL,
	 UnitsInStock smallint NULL);

--DROP TABLE Orders;
CREATE TABLE Orders
	(OrderID int NOT NULL IDENTITY(1,1)
		CONSTRAINT PK_Orders PRIMARY KEY,
	 EmpID int NOT NULL,
	 CustID int NOT NULL,
	 ProdID int NOT NULL);

--Apply Constaints
ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(EmpID) REFERENCES Employees (EmpID)
ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_Customers
	FOREIGN KEY(CustID) REFERENCES Customers (CustID)
ALTER TABLE Orders WITH CHECK ADD CONSTRAINT FK_Orders_Products
	FOREIGN KEY(ProdID) REFERENCES Products (ProdID);

ALTER TABLE Employees ADD CONSTRAINT DF_HireDate
	DEFAULT GETDATE() FOR EmpHireDate
ALTER TABLE Products ADD CONSTRAINT DF_UnitsInStock 
	DEFAULT 0 FOR UnitsInStock;

--Insert Indexes
CREATE NONCLUSTERED INDEX IX_HireDate
	ON Employees (EmpHireDate DESC, EmpLastName);

CREATE NONCLUSTERED INDEX IX_CustomerLastName
	ON Customers (CustLastName ASC);

CREATE NONCLUSTERED INDEX IX_ProductRestock
	ON Products (UnitsInStock DESC, ProdName)
WHERE UnitsInStock <= 2;

CREATE NONCLUSTERED INDEX IX_HighValueCustomers
	ON Orders (CustID DESC)
WHERE ProdID = 6;

PRINT 'Tables Created: '+ CAST(GETDATE() AS NVARCHAR(20))  

--Insert Data
PRINT 'Begin Data Insertion: '+ CAST(GETDATE() AS NVARCHAR(20))  

INSERT INTO Employees
	(EmpFirstName, EmpLastName, City)
VALUES('Whitney', 'King', 'SeaTac'),
	  ('Loxie', 'Howe', 'Auburn'),
	  ('Gloria', 'Procella', 'Covington'),
	  ('James', 'Gordon', 'Gotham'),
	  ('Max', 'Power', 'Fantasyland');

UPDATE Employees
SET EmpHireDate = '2012-10-22'
WHERE EmpID = '1';

INSERT INTO Employees
	(EmpFirstName, EmpLastName)
VALUES('Chewbacca', 'Norbert');

INSERT INTO Customers
	(CustFirstName, CustLastName, CustPhone)
VALUES('Sean', 'Vargas', '555-555-1234'),
	  ('Courtney', 'Whalen', '555-555-2345'),
	  ('Sarah', 'Willmes', '555-555-3456'),
	  ('Han', 'Solo', '555-555-4567'),
	  ('Bernie', 'Sanders', '555-555-5678');

INSERT INTO Products
	(ProdName, UnitPrice, UnitsInStock)
VALUES('Super Comic #1', '3.00', '10'),
	  ('Danger Canyon Adventure', '24.99', '5'),
	  ('Furry Feline Ears', '12.00', '4'),
	  ('Robot Friend Arduino Kit', '99.99', '1'),
	  ('Build-Your-Own T.A.R.D.I.S.', '57.50', '3');

INSERT INTO Products
	(ProdName, UnitPrice)
VALUES('Derp-Master 5000', '599.99');

INSERT INTO Orders
	(EmpID, CustID, ProdID)
VALUES('1', '2', '3'),
	  ('1', '4', '2'),
	  ('3', '5', '5'),
	  ('2', '1', '3'),
	  ('5', '3', '1');

PRINT 'Data Inserted: '+ CAST(GETDATE() AS NVARCHAR(20))  

--Display Data
SELECT *
From Employees;

SELECT *
FROM Customers;

SELECT *
FROM Products;

SELECT *
FROM Orders;

PRINT 'Database Creation and Load Complete: ' + CAST(GETDATE() AS NVARCHAR(20))

END TRY

BEGIN CATCH
  PRINT 'There was a problem!' 

  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity int
  SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY()
  RAISERROR(@ErrorMessage, @ErrorSeverity, 1)

END CATCH

--sp_help Statements

EXEC sp_help [Employees];
GO

EXEC sp_help [Customers];
GO

EXEC sp_help [Products];
GO

EXEC sp_help [Orders];
GO

Select count(*) from Employees;

Select count(City) from Employees; 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following questions all use the Northwind database
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Northwind
/*  
7.  Write the sql statement that will add a TaxRate column to the Order Details table.  This column should have a default value of zero.	
    
 Write an update statement to update all values for the taxrate in the Order Details table to  .10.
*/
-- write your sql statements here:

ALTER TABLE [Order Details]
ADD TaxRate float DEFAULT 0;
GO

UPDATE [Order Details]
SET TaxRate = .10;
GO

/*  
8.  Write  an Update statement to update the TaxRate in the Order Details table to .08 percent but only for only rows with Products
	 made by UK suppliers.  Hint: you will either need to write an Update statement that uses a join or a subquery!

*/
-- write your sql statement here:

UPDATE o
SET TaxRate = .08
FROM [Order Details] AS o
	JOIN Products AS p ON p.ProductID = o.ProductID
WHERE SupplierID IN (SELECT SupplierID FROM Suppliers WHERE Country = 'UK');
GO


/*  
9.  Create a table that is a clone (all the same columns and datatypes) of the Suppliers table and name it SuppliersCopy. 
     Load this table with only those Suppliers whose postal code is numeric.  (Note: to "load" means to add data - 
	 it's a common industry term)
*/
-- write your sql statement here:

SELECT *
INTO SuppliersCopy
FROM Suppliers
WHERE ISNUMERIC(PostalCode) = 1;
GO

/*  
10.   If you had to delete information from the Orders table for only a specific employee, could you use
        the truncate statement?  Why or why not?

		If you needed to quickly remove all of the data from the [Order Details] table which would you choose
		the Truncate statement or the Delete statement?
*/
-- write your answers here:

/*
No, Truncate would not be the appropriate choice to delete values for a specific employe in a table, because it's made to be a more
efficient way to delete all rows in a table, not a selection of rows. Since it doesn't support the WHERE clause and we don't want to
delete all employees in the employee table, it wouldn't be a good choice here.

Conversely, if we wanted to delete all of the rows in a table without actually deleting the table itself, using TRUNCATE would be a
better choice than using the DELETE statement, since it's more efficient. This type of application seems to be exactly what the
truncate statement was designed for.
*/
