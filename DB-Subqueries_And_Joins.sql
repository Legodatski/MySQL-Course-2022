--1
SELECT TOP(5)
       [EmployeeId],
       [JobTitle],
       e.[AddressId],
       a.[AddressText]
  FROM [Employees] AS e
  JOIN [Addresses] AS a ON e.AddressID = a.AddressID
 ORDER BY a.[AddressID]
--1

--2
SELECT TOP(50)
       e.[FirstName],
       e.[LastName],
       t.[Name] AS [Town],
       a.[AddressText]
  FROM [Employees] AS e
  JOIN [Addresses] AS a ON e.[AddressID] = a.[AddressID]
  JOIN [Towns] AS t ON a.[TownID] = t.[TownID]
 ORDER BY e.[FirstName], e.[LastName]
--2

--3
SELECT e.[EmployeeID],
       e.[FirstName],
       e.[LastName],
       d.[Name] AS [DepartmentName]
  FROM [Employees] AS e
  JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
 WHERE d.[Name] = 'Sales'
 ORDER BY e.[EmployeeID]
--3

--4
SELECT TOP(5) 
       e.[EmployeeID],
       e.[FirstName],
       e.[Salary],
       d.[Name] AS [DepartmentName]
  FROM [Employees] AS e
  JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
 WHERE e.[Salary] > 15000
 ORDER BY d.[DepartmentID]
--4

--5
SELECT TOP(3) 
       e.[EmployeeID],
       e.[FirstName]
  FROM [Employees] AS e
  LEFT JOIN [EmployeesProjects] AS ep ON ep.[EmployeeID] = e.[EmployeeID]
 WHERE ep.[ProjectID] IS NULL
 ORDER BY e.[EmployeeID]
--5

--6
SELECT 
       e.[FirstName],
       e.[LastName],
       e.[HireDate],
       d.[Name] AS [DepartmentName]
  FROM [Employees] AS e
  JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
 WHERE YEAR(e.[HireDate]) >= 1999 AND
       d.[Name] IN ('Sales', 'Finance')
 ORDER BY e.[HireDate]
--6

--7
SELECT TOP(5)
       e.[EmployeeID],
       e.[FirstName],
       p.[Name]
  FROM [Employees] AS e
  JOIN [EmployeesProjects] AS ep ON ep.[EmployeeID] = e.[EmployeeID]
  JOIN [Projects] AS p ON ep.[ProjectID] = p.[ProjectID]
 WHERE p.[StartDate] > '08/13/2002' AND
       P.[EndDate] IS NULL
 ORDER BY e.[EmployeeID]
 --7

 --8
SELECT 
       e.[EmployeeID],
       e.[FirstName],
  CASE
       WHEN YEAR(p.[StartDate]) > 2005 OR YEAR(p.[StartDate]) = 2005 THEN NULL
       ELSE p.[Name]
       END AS [ProjectName]
  FROM [Employees] AS e
  JOIN [EmployeesProjects] AS ep ON ep.[EmployeeID] = e.[EmployeeID]
  JOIN [Projects] AS p ON ep.[ProjectID] = p.[ProjectID]
 WHERE e.[EmployeeID] = 24
--8

--9
SELECT e.[EmployeeID],
       e.[FirstName],
       e.[ManagerID],
       m.[FirstName] AS [ManagerName]
  FROM [Employees] AS e
  JOIN [Employees] AS m ON m.[EmployeeID] = e.[ManagerID]
 WHERE e.[ManagerID] IN (3, 7)
 ORDER BY e.[EmployeeID]
--9

--10
SELECT TOP(50)
       e.[EmployeeID],
       CONCAT(e.[FirstName], ' ', e.[LastName]) AS [EmployeeName],
       CONCAT(m.[FirstName], ' ', m.[LastName]) AS [ManagerName],
       d.[Name] AS [DepartmentName]
  FROM [Employees] AS e
  LEFT JOIN [Employees] AS m ON m.[EmployeeID] = e.[ManagerID]
  LEFT JOIN [Departments] AS d ON d.[DepartmentID] = e.[DepartmentID]
 ORDER BY e.[EmployeeID]
--10

--11
SELECT 
      MIN(a.[avgs]) AS [MinAverageSalary]
      FROM (
      SELECT e.[DepartmentID],
             AVG(e.[Salary]) AS avgs
        FROM [Employees] AS e
       GROUP BY e.[DepartmentID]
      ) AS a
--11

USE [Geography]
--12
SELECT 
       mc.[CountryCode],
       m.[MountainRange],
       p.[PeakName],
       p.[Elevation]
  FROM [Peaks] AS p
  JOIN [Mountains] AS m ON p.[MountainId] = m.[Id]
  JOIN [MountainsCountries] AS mc ON mc.[MountainId] = m.[Id]
 WHERE p.[Elevation] > 2835 AND mc.[CountryCode] = 'BG'
 ORDER BY p.[Elevation] DESC
 --12

--13
SELECT c.[CountryCode],
       COUNT(mc.[MountainId])
  FROM [Countries] AS c
  JOIN [MountainsCountries] AS mc ON c.[CountryCode] = mc.[CountryCode]
 WHERE c.[CountryName] IN ('United States', 'Russia', 'Bulgaria')
 GROUP BY c.[CountryCode]
--13

--14
SELECT TOP(5)
       c.[CountryName],
       r.[RiverName]
  FROM [Countries] AS c
  LEFT JOIN [CountriesRivers] AS cr ON cr.[CountryCode] = c.[CountryCode]
  LEFT JOIN [Rivers] AS r ON cr.[RiverId] = r.[Id]
 WHERE c.[ContinentCode] = 'AF'
 ORDER BY c.[CountryName]
--14

--16
SELECT COUNT(c.[CountryName])
  FROM [Countries] AS c
  LEFT JOIN [MountainsCountries] AS mc ON c.[CountryCode] = mc.[CountryCode]
 WHERE mc.[CountryCode] IS NULL
--16