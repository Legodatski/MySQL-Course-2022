CREATE DATABASE [BitBucket]
USE [BitBucket]

--1
CREATE TABLE [Users](
       [Id] INT PRIMARY KEY IDENTITY,
       [Username] VARCHAR(30) NOT NULL,
       [Password] VARCHAR(30) NOT NULL,
       [Email] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Repositories](
       [Id] INT PRIMARY KEY IDENTITY,
       [Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE [RepositoriesContributors](
       [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
       [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
       PRIMARY KEY ([RepositoryId], [ContributorId])
)


CREATE TABLE [Issues](
       [Id] INT PRIMARY KEY IDENTITY,
       [Title] VARCHAR(255) NOT NULL,
       [IssueStatus] VARCHAR(6) NOT NULL,
       [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
       [AssigneeId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Commits](
       [Id] INT PRIMARY KEY IDENTITY,
       [Message] VARCHAR(255) NOT NULL,
       [IssueId] INT FOREIGN KEY REFERENCES [Issues]([Id]),
       [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
       [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Files](
       [Id] INT PRIMARY KEY IDENTITY,
       [Name] VARCHAR(100) NOT NULL,
       [Size] DECIMAL(10, 2) NOT NULL,
       [ParentId] INT FOREIGN KEY REFERENCES [Files]([Id]),
       [CommitId] INT FOREIGN KEY REFERENCES [Commits]([Id]) NOT NULL
)
--2

--2
INSERT INTO [Files]([Name], [Size], [ParentId], [CommitId])
VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)

INSERT INTO [Issues]([Title], [IssueStatus], [RepositoryId], [AssigneeId])
VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)
--2

--3
UPDATE [Issues]
   SET [IssueStatus] = 'closed'
 WHERE [AssigneeId] = 6
--3

--4
DELETE FROM [RepositoriesContributors]
 WHERE [RepositoryId] = 3

DELETE FROM [Issues]
 WHERE [RepositoryId] = 3
--4

--5
SELECT 
       [Id],
       [Message],
       [RepositoryId],
       [ContributorId]
  FROM [Commits]
 ORDER BY [Id], [Message], [RepositoryId], [ContributorId]
--5

--6
SELECT 
       [Id],
       [Name],
       [Size]
  FROM [Files]
 WHERE [Size] > 1000 AND
       [Name] LIKE '%html'
 ORDER BY [Size] DESC, [Id], [Name]
--6

--7
SELECT 
      I.[Id],
      CONCAT(a.[Username], ' : ', i.[Title])
 FROM [Issues] AS i
 JOIN [Users] AS a ON i.[AssigneeId] = a.[Id]
ORDER BY i.[Id] DESC, a.[Id]
--7

--8
SELECT 
       p.[Id],
       p.[Name],
       CONCAT(p.[Size], 'KB') AS [Size]
  FROM [Files] AS p
  LEFT JOIN [Files] AS f ON p.[Id] = f.[ParentId]
 WHERE f.[Id] IS NULL
 ORDER BY p.[Id], p.[Name], p.[Size] DESC
--8

--9 BROKEN
SELECT TOP(5)
       r.[Id],
       r.[Name],
       COUNT(rc.[ContributorId]) AS [Commits]
  FROM [Repositories] AS r
  JOIN [Commits] AS c ON c.[RepositoryId] = r.[Id]
  JOIN [RepositoriesContributors] AS rc ON rc.[RepositoryId] = r.[Id]
 GROUP BY r.[Id], r.[Name]
 ORDER BY COUNT(rc.[ContributorId]) DESC, r.[Id], r.[Name]
--9

--10
SELECT
       u.[Username],
       AVG(f.[Size]) AS [Size]
  FROM [Commits] AS c
  JOIN [Users] AS u ON c.[ContributorId] = u.[Id]
  JOIN [Files] AS f ON f.[CommitId] = c.[Id]
 GROUP BY u.[Username]
 ORDER BY AVG(f.[Size]) DESC, u.[Username]
--10

--11
CREATE OR ALTER FUNCTION [udf_AllUserCommits]
(@username VARCHAR(30)) 
RETURNS INT
BEGIN
    DECLARE @userId INT = (
                           SELECT [Id] 
                             FROM [Users]
                            WHERE [Username] = @username)

    DECLARE @count INT = (
                          SELECT COUNT([Id])
                            FROM [Commits]
                           WHERE [ContributorId] = @userId
                         )

    RETURN @count
END
--11

--12
CREATE OR ALTER PROC [usp_SearchForFiles]
(@fileExtension VARCHAR(10))
AS
BEGIN
    SELECT 
           [Id],
           [Name],
           CONCAT([Size], 'KB') AS [Size]
      FROM [Files]
     WHERE [Name] LIKE '%.' + @fileExtension
END

EXEC usp_SearchForFiles 'txt'