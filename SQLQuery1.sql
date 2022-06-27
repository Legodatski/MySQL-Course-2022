CREATE DATABASE [MINIONS]

USE [Minions]
 
CREATE TABLE [Minions] (
	[ID] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT
)

CREATE TABLE [Towns](
	[ID] INT PRIMARY KEY,
	[Name] NVARCHAR(70) NOT NULL
)

ALTER TABLE [Minions]
	ADD [TownID] INT FOREIGN KEY REFERENCES [Towns]([ID]) NOT NULL


--4--
INSERT INTO [Towns]
	VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

INSERT INTO [Minions]([ID], [Name], [Age], [TownID])
	VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)

--4--

TRUNCATE TABLE [Minions]
DROP TABLE[Minions]
TRUNCATE TABLE [Towns]
DROP TABLE [Towns]


--7--
CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR NOT NULL,
	[Picture] VARBINARY(MAX)
		CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	[Gender] CHAR(1) NOT NULL
		CHECK ([Gender] = 'f' OR [Gender] = 'm'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(max)
)

INSERT INTO [People]([Name], [Gender], [Birthdate])
	VALUES
	('a', 'm', '2006-01-10'),
	('b', 'f', '2007-01-01'),
	('c', 'm', '2005-09-30'),
	('d', 'm', '2005-10-24'),
	('y', 'f', '2006-06-17')

	--7--

	--8--

CREATE TABLE [Users](
	[Id] BIGINT PRIMARY KEY IDENTITY,
	[Username] NVARCHAR(30) NOT NULL,
	[Password] NVARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(max)
		CHECK (DATALENGTH([ProfilePicture]) <= 900000),
	[LastLoginTime] TIME,
	[IsDeleted] BIT
)

INSERT INTO [Users]([Username], [Password], [LastLoginTime])
	VALUES
	('Legodatski', '1234567890', '14:32:12'),
	('pedal', 'GolqmPedal0987654321', '15:12:56'),
	('ALLMightyTrash', 'IamGEY', '07:45:00'),
	('S1lence', 'IreliaMommy123', '01:00:00'),
	('pechkata', 'CATSareSEXY', NULL)


SELECT * FROM [Users]
