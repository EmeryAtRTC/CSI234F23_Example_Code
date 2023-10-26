CREATE SCHEMA HR;

CREATE TABLE HR.JobTitle (
    JobTitleID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100),
    Description NVARCHAR(255)
);

CREATE TABLE HR.Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Position NVARCHAR(100),
    HireDate DATE,
    JobTitleID INT FOREIGN KEY REFERENCES HR.JobTitle(JobTitleID)
);

CREATE TABLE HR.Department (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100)
);

CREATE TABLE HR.EmployeeDepartment (
    EmployeeDepartmentID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT FOREIGN KEY REFERENCES HR.Employee(EmployeeID),
    DepartmentID INT FOREIGN KEY REFERENCES HR.Department(DepartmentID)
);

INSERT INTO HR.JobTitle (Title, Description)
VALUES ('Manager', 'Oversees and manages a team or department'),
       ('Analyst', 'Analyzes data and provides insights'),
       ('Developer', 'Develops and maintains software applications'),
       ('HR Specialist', 'Manages human resources tasks and policies'),
       ('Sales Representative', 'Handles sales and customer relationships'),
       ('IT Support', 'Provides technical support and assistance'),
       ('Marketing Manager', 'Oversees marketing strategies and campaigns'),
       ('Product Manager', 'Manages product lifecycle and strategy');

INSERT INTO HR.Employee (FirstName, LastName, Position, HireDate, JobTitleID)
VALUES ('John', 'Doe', 'Manager', '2020-01-15', 1),
       ('Jane', 'Smith', 'Analyst', '2019-05-10', 2),
       ('Alice', 'Johnson', 'Developer', '2018-03-20', 3),
       ('Robert', 'Brown', 'HR Specialist', '2021-02-01', 4),
       ('Emily', 'Clark', 'Sales Representative', '2019-11-12', 5),
       ('Michael', 'White', 'IT Support', '2018-07-05', 6),
       ('Sophia', 'Green', 'Marketing Manager', '2020-04-22', 7),
       ('James', 'Black', 'Product Manager', '2017-09-30', 8);

INSERT INTO HR.Department (DepartmentName)
VALUES ('Finance'),
       ('IT'),
       ('Sales'),
       ('Marketing'),
       ('Product Management'),
       ('Customer Support');

INSERT INTO HR.EmployeeDepartment (EmployeeID, DepartmentID)
VALUES (1, 1),  -- John Doe belongs to Finance
       (2, 2),  -- Jane Smith belongs to IT
       (3, 2),  -- Alice Johnson also belongs to IT
       (4, 3),  -- Robert Brown belongs to Sales
       (5, 4),  -- Emily Clark belongs to Marketing
       (6, 2),  -- Michael White belongs to IT
       (7, 4),  -- Sophia Green belongs to Marketing
       (8, 5);  -- James Black belongs to Product Management

