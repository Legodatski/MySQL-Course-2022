CREATE DATABASE [Zoo]

--1
CREATE TABLE [Owners](
         [Id] INT PRIMARY KEY IDENTITY,
       [Name] VARCHAR(50) NOT NULL,
[PhoneNumber] VARCHAR(15) NOT NULL,
    [Address] VARCHAR(50)
)

CREATE TABLE [AnimalTypes](
        [Id] INT PRIMARY KEY IDENTITY,
[AnimalType] VARCHAR(30) NOT NULL,
)

  CREATE TABLE [Cages](
          [Id] INT PRIMARY KEY IDENTITY,
[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes] ([Id]) NOT NULL
)

  CREATE TABLE [Animals](
          [Id] INT PRIMARY KEY IDENTITY,
        [Name] VARCHAR(30) NOT NULL,
   [BirthDate] DATE NOT NULL,
     [OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
)

CREATE TABLE [AnimalsCages](
    [CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]) NOT NULL,
  [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) NOT NULL
       PRIMARY KEY([CageId], [AnimalId])
)

    CREATE TABLE [VolunteersDepartments](
            [Id] INT PRIMARY KEY IDENTITY,
[DepartmentName] VARCHAR(30) NOT NULL
)

  CREATE TABLE [Volunteers](
          [Id] INT PRIMARY KEY IDENTITY,
        [Name] VARCHAR(50) NOT NULL,
 [PhoneNumber] VARCHAR(15) NOT NULL,
     [Address] VARCHAR(50),
    [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
[DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments] ([Id]) NOT NULL
)
--1
DROP TABLE [Volunteers]

--2
INSERT INTO [Volunteers] ([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
VALUES
('Anita Kostova',	'0896365412', 'Sofia, 5 Rosa str.',	15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.',	18, 8),
('Boryana Mileva', '0888112233',	NULL, 31, 5)

INSERT INTO [Animals]([Name], [BirthDate], [OwnerId], [AnimalTypeId])
VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17',	15, 3),
('Hamadryas Baboon',	'2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)
--2

--3
SELECT * 
  FROM [Owners]

UPDATE [Animals]
   SET [OwnerId] = 4
 WHERE [OwnerId] IS NULL
--3

--4
DELETE
  FROM [Volunteers]
 WHERE [DepartmentId] = 2

DELETE
  FROM [VolunteersDepartments]
 WHERE [DepartmentName] = 'Education program assistant'
--4

--5
  SELECT 
         [Name],
         [PhoneNumber],
         [Address],
         [AnimalId],
         [DepartmentId]
    FROM [Volunteers]
ORDER BY [Name], [AnimalId], [DepartmentId]
--5

--6
  SELECT a.[Name],
         t.[AnimalType],
         FORMAT(BirthDate, 'dd.MM.yyyy') AS [BirthDate]
    FROM [Animals] AS a
    JOIN [AnimalTypes] AS t ON a.[AnimalTypeId] = t.[Id]
ORDER BY a.[Name]
--6

--7
  SELECT TOP(5)
         o.[Name],
         COUNT(a.[Id]) AS [CountOfAnimals]
    FROM [Owners] AS o
    JOIN [Animals] AS a ON a.[OwnerId] = o.[Id]
GROUP BY o.[Name]
ORDER BY [CountOfAnimals] DESC, o.[Name]
--7

--8
  SELECT 
         CONCAT(o.[Name], '-', a.[Name]) AS [OwnersAnimals],
         o.[PhoneNumber],
         c.[CageId]
    FROM [Owners] AS o
    JOIN [Animals] AS a ON o.[Id] = a.[OwnerId]
    JOIN [AnimalsCages] AS c ON c.[AnimalId] = a.[Id]
   WHERE a.[AnimalTypeId] = 1
ORDER BY o.[Name], a.[Name] DESC
--8

--9
  SELECT [Name], 
         [PhoneNumber], 
         SUBSTRING([Address], PATINDEX('%[0-9]%', [Address]) , 30) AS [Address] 
    FROM Volunteers AS v
    JOIN VolunteersDepartments AS vd ON vd.Id = v.[DepartmentId]
   WHERE vd.DepartmentName = 'Education program assistant' and v.[Address] LIKE '%Sofia%'
ORDER BY [Name]
--9

--10
  SELECT 
         a.[Name],
         YEAR(a.[BirthDate]) AS [BirthYear],
         t.[AnimalType]
    FROM [Animals] AS a
    JOIN [AnimalTypes] AS t ON t.[Id] = a.[AnimalTypeId]
   WHERE DATEDIFF(YEAR, [BirthDate], '01/01/2022') < 5 AND [AnimalTypeId] != 3 AND [OwnerId] IS NULL
ORDER BY a.[Name]


--11
CREATE FUNCTION [udf_GetVolunteersCountFromADepartment]
(@VolunteersDepartment VARCHAR(30))
RETURNS INT
BEGIN 
    DECLARE @count INT
    SET @count = (
          SELECT 
                 COUNT(v.[Id])
            FROM [VolunteersDepartments] AS d
            JOIN [Volunteers] AS v ON v.[DepartmentId] = d.[Id]
           WHERE d.[DepartmentName] = @VolunteersDepartment
        GROUP BY d.[DepartmentName]
    )
    RETURN @count
END
--11

--12
CREATE PROC usp_AnimalsWithOwnersOrNot
(@AnimalName VARCHAR(30))
AS
BEGIN
       SELECT a.[Name],
              CASE 
                   WHEN a.[OwnerId] IS NULL THEN 'For adoption'
                   ELSE o.[Name] 
              END AS [OwnersName]
         FROM [Animals] AS a
    LEFT JOIN [Owners] AS o ON a.[OwnerId] = o.[Id]
        WHERE a.[Name] = @AnimalName
END


EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'