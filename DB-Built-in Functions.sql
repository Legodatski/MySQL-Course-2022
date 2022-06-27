--1
SELECT [FirstName], [LastName]
  FROM [Employees]
--WHERE LEFT([FirstName], 2) = 'Sa'
WHERE [FirstName] LIKE 'Sa%'
--1

--2
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE [LastName] LIKE '%ei%'
--2

--3
SELECT [FirstName]
  FROM [Employees]
 WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005
 --3

 --4
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE [JobTitle] NOT LIKE '%engineer%'
 --4
 SELECT * FROM [Employees]

 --5
SELECT [Name] 
  FROM [Towns]
 WHERE LEN([Name]) IN (6, 5)
 ORDER BY [Name]
 --5

 --6
SELECT *
  FROM [Towns]
 WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
 ORDER BY [Name]
 --6

 --7
 SELECT *
  FROM [Towns]
 WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
 ORDER BY [Name]
 --7

 --8
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE YEAR([HireDate]) > 2000 

SELECT * FROM [V_EmployeesHiredAfter2000]
--8

--9
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE LEN(LastName) = 5
 --9

 --10
SELECT [EmployeeID], [FirstName], [LastName], [Salary],
       DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY[EmployeeID]) AS [Rank]
  FROM [Employees]
 WHERE [Salary] BETWEEN 10000 AND 50000
 ORDER BY [Salary] DESC
 --10

 --11
SELECT *
  FROM (   
         SELECT [EmployeeID], [FirstName], [LastName], [Salary],
                DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY[EmployeeID]) AS [Rank]
           FROM [Employees]
          WHERE [Salary] BETWEEN 10000 AND 50000
 )
   AS [Ranking]
WHERE [Rank] = 2
ORDER BY [Salary] DESC
--11

--12
SELECT [CountryName], [ISOCode] 
  FROM [Countries]
 WHERE LOWER([CountryName]) LIKE '%a%a%a%'
 ORDER BY [IsoCode]
 --12

 --13
SELECT [PeakName],
       [RiverName],
       LOWER(CONCAT(LEFT([p].[PeakName], LEN([p].[PeakName]) -1), [r].[RiverName]))
       AS [Mix]
  FROM [Peaks] AS [p],
       [Rivers] AS [r]
 WHERE RIGHT([p].[PeakName], 1) = LEFT([r].[RiverName], 1)
 ORDER BY [Mix]
 --13

 --14
SELECT TOP(50)
        [Name],
        CAST([Start] AS DATE)
  FROM [Games]
 WHERE YEAR([Start]) BETWEEN 2011 AND 2012
 ORDER BY [Start], [Name]
 --14

 --15
SELECT [Username],
        SUBSTRING([Email], CHARINDEX('@', Email) + 1, LEN([EmaiL])) AS [Email Provider]
  FROM [Users]
 ORDER BY [Email Provider], [Username]
--15

--16
SELECT [Username],
       [IpAddress]
  FROM [Users]
 WHERE [IpAddress] LIKE '___.1_%._%.___'
 ORDER BY [Username]
--16

--17
SELECT [Name],
  CASE
       WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
       WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'       
       WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
   END AS [Part of the Day],
  CASE
       WHEN [Duration] <= 3 THEN 'Extra Short'
       WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
       WHEN [Duration] > 6 THEN 'Long'
       ELSE 'Extra Long'
   END AS [Duration]
  FROM [Games]
 ORDER BY [Name], [Duration], [Part of the Day]
--17