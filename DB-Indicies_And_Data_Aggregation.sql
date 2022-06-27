--1
SELECT COUNT(*)
  FROM [WizzardDeposits]
--1

--2
SELECT TOP(1)
       [MagicWandSize] AS [LongestMagicWand]
  FROM [WizzardDeposits]
 ORDER BY [MagicWandSize] DESC
--2

--3 
SELECT [DepositGroup],
       MAX([MagicWandSize]) AS [LongestMagicWand]
  FROM [WizzardDeposits]
 GROUP BY [DepositGroup]
--3

--5
SELECT [DepositGroup],
       SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
 GROUP BY [DepositGroup]
--5

--6
SELECT [DepositGroup],
       SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
 WHERE [MagicWandCreator] = 'Ollivander family'
 GROUP BY [DepositGroup]
--6

--7
SELECT [DepositGroup],
       SUM([DepositAmount]) AS [TotalSum]
  FROM [WizzardDeposits]
 WHERE [MagicWandCreator] = 'Ollivander family'
 GROUP BY [DepositGroup]
HAVING SUM([DepositAmount]) < 150000
 ORDER BY [TotalSum] DESC

--8
SELECT [DepositGroup],
       [MagicWandCreator],
       MIN([DepositCharge]) AS [MinDepositCharge]
  FROM [WizzardDeposits]
 GROUP BY [DepositGroup], [MagicWandCreator]
 ORDER BY [MagicWandCreator], [DepositGroup]
--8

--9
SELECT [AgeGroup],
       COUNT(*) AS [WizardCount]
  FROM (
       SELECT [Age],
         CASE 
              WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
              WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
              WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
              WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
              WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
              WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
              WHEN [Age] >= 61 THEN '[61+]'
          END AS [AgeGroup]
         FROM [WizzardDeposits]
  ) AS [AgeGrouping]
 GROUP BY [AgeGroup]
--9

--10
SELECT DISTINCT LEFT([FirstName], 1)
  FROM [WizzardDeposits]
 WHERE [DepositGroup] = 'Troll Chest'
 ORDER BY LEFT([FirstName], 1)
--10

--11
SELECT 
       [DepositGroup],
       [IsDepositExpired],
       AVG([DepositInterest]) 
  FROM [WizzardDeposits]
 WHERE YEAR([DepositStartDate]) >= 1985 
 GROUP BY [DepositGroup], [IsDepositExpired]
 ORDER BY [DepositGroup] DESC
--11

--13
SELECT [DepartmentID],
       SUM([Salary])
  FROM [Employees]
 GROUP BY [DepartmentID]
--13

--14
SELECT [DepartmentID],
       MIN([Salary])
  FROM [Employees]
 WHERE YEAR([HireDate]) > 2000
 GROUP BY [DepartmentID]
HAVING [DepartmentID] IN (2, 5, 7)
--14


--16
SELECT [DepartmentID],
       MAX([Salary]) AS [MaxSalary]
  FROM [Employees]
 GROUP BY [DepartmentID]
HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000
--16

--17
SELECT COUNT([Salary]) AS [Count]
  FROM [Employees]
 WHERE [ManagerID] IS NULL
--17