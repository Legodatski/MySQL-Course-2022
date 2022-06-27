--1
CREATE PROC [usp_GetEmployeesSalaryAbove35000]
AS
BEGIN
    SELECT [FirstName],
           [LastName]
      FROM [Employees]
     WHERE [Salary] > 35000
END
--1

--2
CREATE OR ALTER PROCEDURE [usp_GetEmployeesSalaryAboveNumber]
@MinSalary DECIMAL (18, 4)
AS 
BEGIN
    SELECT [FirstName],
           [LastName]
      FROM [Employees]
     WHERE [Salary] >= @MinSalary
END

EXECUTE [dbo].[usp_GetEmployeesSalaryAboveNumber] 48100
--2

--3
CREATE OR ALTER PROC [usp_GetTownsStartingWith] 
@startLetter VARCHAR(10)
AS
BEGIN
    SELECT [Name]
      FROM [Towns]
     WHERE LEFT([Name], LEN(@startLetter)) = @startLetter
END

EXEC [dbo].[usp_GetTownsStartingWith] 'be'
--3

--4
CREATE PROC [usp_GetEmployeesFromTowN]
@TownName NVARCHAR(50)
AS
BEGIN 
     SELECT [FirstName],
            [LastName]
       FROM [Employees] AS e
       JOIN [Addresses] AS a ON a.[AddressID] = e.[AddressID]
       JOIN [Towns] AS t ON t.[TownID] = a.[TownID]
      WHERE t.[Name] = @TownName
END
--4

--5
 CREATE OR ALTER FUNCTION [ufn_GetSalaryLevel] (@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
BEGIN
    DECLARE @salaryLevel VARCHAR(8);
         IF @salary < 30000
            SET @salaryLevel = 'Low'
         IF @salary BETWEEN 30000 AND 50000
            SET @salaryLevel = 'Average'
         IF @salary > 50000
            SET @salaryLevel = 'High'
     RETURN @salaryLevel
END
--5

--6
CREATE OR ALTER PROC [usp_EmployeesBySalaryLevel]
(@SalaryInput VARCHAR(8))
AS
BEGIN
    SELECT [FirstName],
           [LastName]
      FROM [Employees]
     WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @SalaryInput
END

EXEC [dbo].[usp_EmployeesBySalaryLevel] 'high'
--6

--9
CREATE PROC [usp_GetHoldersFullName]
AS
BEGIN
    SELECT CONCAT([FirstName], ' ', [LastName]) AS [Full Name]
      FROM [AccountHolders]
END
--9

--10
CREATE PROC [usp_GetHoldersWithBalanceHigherThan]
(@minMoney)
AS
BEGIN
    SELECT * 
      FROM [Accounts], [AccountHolders]
END