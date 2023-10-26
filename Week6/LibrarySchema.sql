--Drop Tables if they exists
--If There is a user create table named Library.Fines
IF OBJECT_ID('Library.Fines', 'U') IS NOT NULL
    DROP TABLE Library.Fines;

IF OBJECT_ID('Library.Borrows', 'U') IS NOT NULL
    DROP TABLE Library.Borrows

IF OBJECT_ID('Library.BorrowRecords', 'U') IS NOT NULL
    DROP TABLE Library.BorrowRecords;

IF OBJECT_ID('Library.BooksAuthors', 'U') IS NOT NULL
    DROP TABLE Library.BooksAuthors;

IF OBJECT_ID('Library.Books', 'U') IS NOT NULL
    DROP TABLE Library.Books;

IF OBJECT_ID('Library.Members', 'U') IS NOT NULL
    DROP TABLE Library.Members;

IF OBJECT_ID('Library.Authors', 'U') IS NOT NULL
    DROP TABLE Library.Authors;

IF OBJECT_ID('Library.Genres', 'U') IS NOT NULL
    DROP TABLE Library.Genres;

--Drop Schema if exists
-- Drop the schema if it exists
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Library')
    DROP SCHEMA Library;

GO
CREATE SCHEMA Library;
GO

CREATE TABLE [Library].[Genres] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [GenreName] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [Library].[Authors] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (100) NOT NULL,
    [LastName]  NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Authors] PRIMARY KEY CLUSTERED ([Id] ASC)
);
CREATE TABLE [Library].[Members] (
    [Id]               INT            NOT NULL,
    [FirstName]        NVARCHAR (100) NOT NULL,
    [LastName]         NVARCHAR (100) NOT NULL,
    [Email]            NVARCHAR (100) NOT NULL,
    [RegistrationDate] DATE           NOT NULL,
    CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_Members_DateNotInFuture] CHECK (RegistrationDate <= GetDate())
);

CREATE TABLE [Library].[Books] (
    [Id]              INT           NOT NULL,
    [GenreId]         INT           NOT NULL,
    [Title]           NVARCHAR (50) NOT NULL,
    [PublicationDate] DATE          NOT NULL,
    [PurchaseDate]    DATE          NOT NULL,
    [ISBN]            NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Books_Genres] FOREIGN KEY ([GenreId]) REFERENCES [Library].[Genres] ([Id])
);

CREATE TABLE [Library].[BooksAuthors] (
    [Id]       INT IDENTITY (1, 1) NOT NULL,
    [AuthorId] INT NOT NULL,
    [BookId]   INT NOT NULL,
    CONSTRAINT [PK_BooksAuthors] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BooksAuthors_Authors] FOREIGN KEY ([AuthorId]) REFERENCES [Library].[Authors] ([Id]),
    CONSTRAINT [FK_BooksAuthors_Books] FOREIGN KEY ([BookId]) REFERENCES [Library].[Books] ([Id])
);
CREATE TABLE [Library].[Borrows] (
    [Id]         INT  IDENTITY (1, 1) NOT NULL,
    [MemberId]   INT  NOT NULL,
    [BookId]     INT  NOT NULL,
    [BorrowDate] DATE NOT NULL,
    [DueDate]    DATE NOT NULL,
    [ReturnDate] DATE NULL,
    CONSTRAINT [PK_Borrows] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Borrows_Books] FOREIGN KEY ([BookId]) REFERENCES [Library].[Books] ([Id]),
    CONSTRAINT [FK_Borrows_Member] FOREIGN KEY ([MemberId]) REFERENCES [Library].[Members] ([Id])
);

CREATE TABLE [Library].[Fines] (
    [Id]       INT   IDENTITY (1, 1) NOT NULL,
    [BorrowId] INT   NOT NULL,
    [Amount]   MONEY NULL,
    [Status] VARCHAR(50)
    CONSTRAINT [PK_Fines] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Fines_Borrows] FOREIGN KEY ([BorrowId]) REFERENCES [Library].[Borrows] ([Id])
);

--Use Alter Table statments to add constraints
--Check constraint on the Amount Column
ALTER TABLE Library.Fines
ADD CONSTRAINT CHK_ValidAmount CHECK (Amount > 0)
--Check that status is one of a given set of values
ALTER Table Library.Fines
ADD CONSTRAINT CHK_StatusVali CHECK ([Status] IN ('Pending', 'Paid', 'Waived'))

--Create Indexes etc...

--Add Test Data

-- Insert sample data into [Library].[Genres]
INSERT INTO [Library].[Genres] ([GenreName])
VALUES ('Science Fiction'), ('Fantasy'), ('Mystery'), ('Romance'), ('Thriller');

-- Insert sample data into [Library].[Authors]
INSERT INTO [Library].[Authors] ([FirstName], [LastName])
VALUES ('J.K.', 'Rowling'), ('George', 'Orwell'), ('Agatha', 'Christie'),
       ('Stephen', 'King'), ('Jane', 'Austen');

-- Insert sample data into [Library].[Members]
INSERT INTO [Library].[Members] ([Id], [FirstName], [LastName], [Email], [RegistrationDate])
VALUES (1, 'John', 'Doe', 'john.doe@example.com', '2023-01-15'),
       (2, 'Alice', 'Smith', 'alice.smith@example.com', '2023-02-20'),
       (3, 'Bob', 'Johnson', 'bob.johnson@example.com', '2023-03-10'),
       (4, 'Emily', 'Wilson', 'emily.wilson@example.com', '2023-04-05');

-- Insert sample data into [Library].[Books]
INSERT INTO [Library].[Books] ([Id], [GenreId], [Title], [PublicationDate], [PurchaseDate], [ISBN])
VALUES (1, 1, '1984', '1949-06-08', '2023-01-10', '978-0451524935'),
       (2, 2, 'Harry Potter and the Philosopher''s Stone', '1997-06-26', '2023-02-15', '978-0747532743'),
       (3, 3, 'Murder on the Orient Express', '1934-01-01', '2023-03-20', '978-0062073501'),
       (4, 4, 'Pride and Prejudice', '1813-01-28', '2023-04-25', '978-0141439518');

-- Insert sample data into [Library].[BooksAuthors]
INSERT INTO [Library].[BooksAuthors] ([AuthorId], [BookId])
VALUES (2, 1), (1, 2), (3, 3), (5, 4);

-- Insert sample data into [Library].[Borrows]
INSERT INTO [Library].[Borrows] ([MemberId], [BookId], [BorrowDate], [DueDate], [ReturnDate])
VALUES (1, 1, '2023-01-20', '2023-02-10', NULL),
       (2, 2, '2023-02-25', '2023-03-17', '2023-03-10'),
       (3, 3, '2023-03-15', '2023-04-05', NULL),
       (4, 4, '2023-04-10', '2023-04-30', NULL);

-- Insert sample data into [Library].[Fines]
INSERT INTO [Library].[Fines] ([BorrowId], [Amount], [Status])
VALUES (1, NULL, 'Unpaid'),
       (2, 5.00, 'Paid'),
       (3, 2.50, 'Unpaid');
