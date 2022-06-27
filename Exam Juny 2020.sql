CREATE DATABASE [TripService]
USE [TripService]

--1
 CREATE TABLE [Cities](
         [Id] INT PRIMARY KEY IDENTITY,
       [Name] NVARCHAR(20) NOT NULL,
[CountryCode] CHAR(2) NOT NULL
)

   CREATE TABLE [Hotels](
           [Id] INT PRIMARY KEY IDENTITY,
         [Name] NVARCHAR(30) NOT NULL,
       [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
[EmployeeCount] INT NOT NULL,
     [BaseRate] DECIMAL(6, 2)
)

CREATE TABLE [Rooms](
        [Id] INT PRIMARY KEY IDENTITY,
     [Price] DECIMAL(6, 2) NOT NULL,
      [Type] NVARCHAR(20) NOT NULL,
      [Beds] INT NOT NULL,
   [HotelId] INT FOREIGN KEY REFERENCES [Hotels]([Id])
)

 CREATE TABLE [Trips](
         [Id] INT PRIMARY KEY IDENTITY,
     [RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id]) NOT NULL,
   [BookDate] DATE NOT NULL,
[ArrivalDate] DATE NOT NULL,
 [ReturnDate] DATE NOT NULL, 
 [CancelDate] DATE,
   CONSTRAINT [bd_before_ad] CHECK ([BookDate] < [ArrivalDate]),
   CONSTRAINT [ad_before_rd] CHECK([ArrivalDate] < [ReturnDate])
)

CREATE TABLE [Accounts](
        [Id] INT PRIMARY KEY IDENTITY,
 [FirstName] NVARCHAR(50) NOT NULL,
[MiddleName] NVARCHAR(20),
  [LastName] NVARCHAR(50) NOT NULL,
    [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
 [BirthDate] DATE NOT NULL,
     [Email] VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE [AccountsTrips](
 [AccountId] INT FOREIGN KEY REFERENCES [Accounts]([Id]) NOT NULL,
    [TripId] INT FOREIGN KEY REFERENCES [Trips]([Id]) NOT NULL,
   [Luggage] INT NOT NULL
             CHECK([Luggage] >= 0 ) 
             PRIMARY KEY([AccountId], [TripId])
)
--1

--2
INSERT INTO [Accounts]
([FirstName], [MiddleName], [LastName], [CityId], [BirthDate], [Email])
VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO [Trips]
([RoomId], [BookDate], [ArrivalDate], [ReturnDate], [CancelDate])
VALUES
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)
--2

--3
UPDATE [Rooms]
   SET [Price] -= [Price] * 0.14
 WHERE [HotelId] IN (5, 7, 9)
--3

--4
DELETE
  FROM [AccountsTrips]
 WHERE [AccountId] = 47

DELETE FROM [Trips]
WHERE [Id] IN (17, 254, 268, 368, 650, 764, 831)
--4

--5
   SELECT a.[FirstName],
          a.[LastName],
          CONVERT(VARCHAR, a.[BirthDate], 110) AS [BirthDate],
          c.[Name],
          a.[Email]
     FROM [Accounts] AS a
     JOIN [Cities] AS c ON c.[Id] = a.[CityId]
    WHERE LEFT(a.[Email], 1) = 'e'
 ORDER BY c.[Name]
--5

--6
  SELECT c.[Name],
         COUNT(h.[Id]) AS [Hotels]
    FROM [Hotels] AS h
    JOIN [Cities] AS c ON c.[Id] = h.[CityId]
GROUP BY c.[Name]
ORDER BY COUNT(h.[Id]) DESC, c.[Name]
--6

--7
  SELECT 
         a.[Id],
         CONCAT(a.[FirstName], ' ', a.[LastName]) AS [FullName],
         MAX(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [LongestTrip],
         MIN(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [ShortestTrip]
    FROM [Accounts] AS a
    JOIN [AccountsTrips] AS ac ON ac.[AccountId] = a.[Id]
    JOIN [Trips] AS t ON t.[Id] = ac.[TripId]
WHERE a.[MiddleName] IS NULL AND t.[CancelDate] IS NULL
GROUP BY a.[Id], CONCAT(a.[FirstName], ' ', a.[LastName])
ORDER BY [LongestTrip] DESC, [ShortestTrip]
--7

--8
  SELECT TOP(10)
         c.[Id],
         c.[Name],
         c.[CountryCode],
         COUNT(a.[Id]) AS [Accounts]
    FROM [Cities] AS c
    JOIN [Accounts] AS a ON c.[Id] = a.[CityId]
GROUP BY c.[Id], c.[Name], c.[CountryCode]
ORDER BY COUNT(a.[Id]) DESC
--8

--9
  SELECT 
         a.[Id],
         a.[Email],
         c.[Name],
         COUNT(h.[Id]) AS [Trips]
    FROM [Accounts] a 
    JOIN [AccountsTrips] AS ac ON ac.[AccountId] = a.[Id]
    JOIN [Trips] AS t ON ac.[TripId] = t.[Id]
    JOIN [Rooms] AS r ON r.[Id] = t.[RoomId]
    JOIN [Hotels] AS h ON h.[Id] = r.[HotelId]
    JOIN [Cities] AS c ON c.[Id] = a.[CityId]
   WHERE h.[CityId] = a.[CityId]
GROUP BY a.[Email], a.[Id], c.[Name]
ORDER BY  COUNT(h.[Id]) DESC, a.[Id]
--9

--10 NOT WORKING
  SELECT 
         t.[Id],
         CONCAT(a.[FirstName], ' ', a.[MiddleName], ' ', a.[LastName]) AS [FullName],
         ac.[Name] AS [From],
         c.[Name] AS [To],
         CASE
              WHEN t.[CancelDate] IS NOT NULL THEN 'Canceled'
              ELSE CONCAT(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate]), ' days')
         END AS [Duration]
    FROM [Trips] AS t
    JOIN [AccountsTrips] AS act ON act.[TripId] = t.[Id]
    JOIN [Accounts] AS a ON act.[AccountId] = a.[Id]
    JOIN [Rooms] AS r ON r.[Id] = t.[RoomId]
    JOIN [Hotels] AS h ON h.[Id] = r.[HotelId]
    JOIN [Cities] AS c ON c.[Id] = h.[CityId]
    JOIN [Cities] AS ac ON ac.[Id] = a.[CityId]
ORDER BY [FullName], t.[Id]
--10

--11
CREATE FUNCTION udf_GetAvailableRoom
(@HotelId INT, @Date DATE, @People INT)
RETURNS VARCHAR(50)
BEGIN  
    
END