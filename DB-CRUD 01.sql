SELECT * FROM [Departments] --2

SELECT [Name] FROM [Departments] --3

SELECT [FirstName], [LastName], [Salary] --4
	FROM [Employees]
		
SELECT [FirstName], [MiddleName], [LastName] --5
	FROM [Employees]

SELECT [FirstName] + '.' + [LastName] + '@softuni.bg' --6
	AS [Full Email Address]
	FROM [Employees]

SELECT DISTINCT [Salary] --7
	FROM [Employees]

SELECT * FROM [Employees] WHERE [JobTitle] = 'Sales Representative' --8

SELECT [FirstName], [LastName], [JobTitle] --9
	FROM [Employees]
	WHERE [Salary] BETWEEN 20000 AND 30000

SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
    AS [Full Name]
  FROM [Employees]
 WHERE [Salary] IN(25000, 14000, 12500, 23600) --10

SELECT [FirstName], [LastName]
	FROM [Employees]
	WHERE [ManagerID] IS NULL --11

SELECT [FirstName], [LastName], [Salary] --12
	FROM [Employees]
	WHERE [Salary] > 50000
	ORDER BY [Salary] DESC

SELECT TOP(5) [FirstName], [LastName]
	FROM [Employees]
	ORDER BY [Salary] DESC --13

SELECT [FirstName], [LastName]
	FROM [Employees]
	WHERE [DepartmentID] != 4 --14

SELECT *
	FROM [Employees]
	ORDER BY [Salary] DESC
		, [FirstName]
		, [LastName] DESC
		, [MiddleName] --15

GO
CREATE VIEW [V_EmployeesSalaries] 
	 AS
SELECT [FirstName], [LastName], [Salary]
  FROM [Employees]
SELECT * FROM [V_EmployeesSalaries]
GO --16

    GO
CREATE VIEW [V_EmployeeNameJobTitle]
    AS
SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
    AS [FullName],
       [JobTitle]
  FROM [Employees]
    GO

SELECT * FROM [V_EmployeeNameJobTitle] --17

SELECT DISTINCT [JobTitle]
  FROM [Employees] --18

SELECT TOP(10) *
  FROM [Projects]
 ORDER BY [StartDate], [Name] --19

SELECT TOP(7) [FirstName], [LastName], [HireDate]
  FROM [Employees]
 ORDER BY [HireDate] DESC --20

UPDATE [Employees]
   SET [Salary] += [Salary] * 0.12
 WHERE [DepartmentID] IN (1, 2, 4, 11)

SELECT [Salary]
  FROM [Employees]--21