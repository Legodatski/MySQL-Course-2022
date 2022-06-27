--13--
--CREATE DATABASE [Movies]
USE [Movies]

CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY IDENTITY,
	[DirectorName] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(max)
)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(max)
)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(max)
)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] NVARCHAR(50) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]),
	[CopyrightYear] SMALLINT
		CHECK([CopyrightYear] >= 1000) NOT NULL,
	[Length] DECIMAL(3, 2) NOT NULL,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]),
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]),
	[Rating] DECIMAL(3,1)
		CHECK([Rating] <= 10.0),
	[Notes] NVARCHAR(max)
)

INSERT INTO [Directors]([DirectorName])
	VALUES 
	('John'),
	('Mike'),
	('Ivan'),
	('Paul'),
	('Gosho')

INSERT INTO [Genres]([GenreName])
	VALUES
	('ACTION'),
	('COMEDY'),
	('ROMANCE'),
	('REALITY'),
	('ANIMATION')

INSERT INTO [Categories]([CategoryName])
	VALUES
	('StarWars'),
	('ForKids'),
	('HarryPoter'),
	('LordOfTheRings'),
	('ForStudying')

INSERT INTO [Movies]
([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId])
	VALUES
	('MeAndYourMom', 1, 2005, 6.90, 4, 2),
	('HornyPotter', 2, 1969, 3.20, 5, 3),
	('BRUH', 2, 2005, 2, 1, 3),
	('FastAndFurious', 4, 2069, 3.40, 4, 5),
	('MeAndMF', 3, 2022, 1.20, 4, 4)

SELECT * FROM [Categories]
SELECT * FROM [Directors]
SELECT * FROM [Genres]
SELECT * FROM [Movies]

--13--

--14--
CREATE DATABASE [CarRental]
USE [CarRental]

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] VARCHAR(50) NOT NULL,
	[DailyRate] DECIMAL(2, 1),
	[WeeklyRate] DECIMAL(2, 1),
	[MonthlyRate] DECIMAL(2, 1),
	[WeekendRate] DECIMAL(2, 1)
)

CREATE TABLE [Cars](
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] INT NOT NULL
		CHECK ((DATALENGTH([PlateNumber])) = 4), 
	[Manufacturer] NVARCHAR(10) NOT NULL,
	[Model] NVARCHAR(15) NOT NULL,
	[CarYear] INT NOT NULL
		CHECK ([CarYear] >= 1886),
	[CategoryId] INT FOREIGN KEY REFERENCES[Categories]([Id]) NOT NULL,
	[Doors] TINYINT
		CHECK ([Doors] >= 1 AND [DOORS] <= 6),
	[Picture] VARBINARY(max)
		CHECK (DATALENGTH([Picture]) <= 900000),
	[Condition] NVARCHAR(max),
	[Available] BIT NOT NULL
)

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(10) NOT NULL,
	[LastName] NVARCHAR(15) NOT NULL,
	[Title] VARCHAR(15) NOT NULL,
	[Notes] VARCHAR(max)
)

CREATE TABLE [Customers](
	[Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] INT NOT NULL
		CHECK(DATALENGTH([DriverLicenceNumber]) = 9),
	[FullName] NVARCHAR(35) NOT NULL,
	[Address] VARCHAR(40) NOT NULL,
	[City] VARCHAR(35) NOT NULL,
	[ZIPCode] CHAR(5),
	[Notes] VARCHAR(max)
)

CREATE TABLE [RentalOrders](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES[Employees]([Id]) NOT NULL,
	[CustomerId] INT FOREIGN KEY REFERENCES[Customers]([Id]) NOT NULL,
	[CarId] INT FOREIGN KEY REFERENCES[Cars]([Id]) NOT NULL,
	[TankLevel] INT,
	[KilometrageStart] INT,
	[KilometrageEnd] INT,
	[TotalKilometrage] INT,
	[StartDate] DATE NOT NULL,
	[EndDate] DATE NOT NULL,
	[RateApplied] DECIMAL(3,2),
	[TaxRate] DECIMAL(3,2),
	[OrderStatus] VARCHAR(20),
	[Notes] VARCHAR(max)
)

INSERT INTO[Categories]([CategoryName])
	VALUES
	('sport'),
	('JDM'),
	('classic')

INSERT INTO[CARS]
([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Available])
	VALUES
	(6969, 'Nissan', 'Skyline', 1999, 2, 1),
	(1234, 'Ferrari', '488', 2018, 1, 0),
	(4321, 'Ford', 'Mustang', 1969, 3, 1)

INSERT INTO [Employees]([FirstName], [LastName], [Title])
	VALUES
	('Pesho', 'Golemiq', 'shefa'),
	('Mitko', 'Golemiq', 'grugiq shef'),
	('Gosho', 'Malkiq', 'rabotnik')

INSERT INTO [Customers] ([DriverLicenceNumber], [FullName], [Address], [City])
	VALUES
	(111222333, 'Georgi Petrov', 'Simeon Veliki 5', 'Veliko Tarnovo'),
	(444555666, 'Ivo Nedev', 'Krakov 9', 'Veliko Tarnovo'),
	(777888999, 'idk', 'ulica', 'Sofia')

INSERT INTO [RentalOrders]([CustomerId], [EmployeeId], [CarId], [StartDate], [EndDate])
	VALUES
	(2, 1, 1, '2022-05-05', '2022-06-05'),
	(3, 2, 1, '2022-04-17', '2022-10-14'),
	(1, 3, 2, '2022-12-05', '2022-12-21')

