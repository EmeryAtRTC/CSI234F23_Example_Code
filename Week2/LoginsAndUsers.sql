-- Run on master
--the master database is where the logins are stored
--you can query all of the logins with the following query
SELECT * FROM sys.sql_logins
CREATE LOGIN Student WITH PASSWORD = 'abc@123456789';

-- RUN on the database that you want the user to access
CREATE USER Student
FROM LOGIN Student
-- Add the roles that you want the user to have
-- list of roles: https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver16
ALTER ROLE db_datareader ADD MEMBER Student

--Lets pretend that we have a console application that needs to access the database
--This console app only ever reads one table
--In this case we need to grant permissions because a role does not exist for this

--Run on master
CREATE LOGIN consoleApp1 WITH PASSWORD = 'p@ssw0rd!1234';

-- Run on the database that you want the user to access
CREATE USER consoleApp1 FOR LOGIN consoleApp1;
-- We now have created a user
-- We can now grant permissions to the user
-- GRANT PERMISSION ON <object> TO <user>
-- COMMON PERMISSIONS: SELECT, INSERT, UPDATE, DELETE, EXECUTE
GRANT SELECT ON SalesLT.Customer TO consoleApp1;

-- Lets pretend that we have a web application that needs to access the database
-- This web app needs to read and write to the database
-- lets use a role for this
-- Run on master
CREATE LOGIN consoleApp2 WITH PASSWORD = 'p@ssw0rd!1234';
-- Run on the database that you want the user to access
CREATE USER consoleApp2 FOR LOGIN consoleApp2;
-- Add the roles that you want the user to have
ALTER ROLE db_datareader ADD MEMBER consoleApp2;
ALTER ROLE db_datawriter ADD MEMBER consoleApp2;

-- Lets pretend that we have a web application that needs to access the database
-- This web app needs access only to stored procedures
-- lets use a role for this
-- Run on master
CREATE LOGIN webAPI WITH PASSWORD = 'p@ssw0rd!1234';
-- Run on the database that you want the user to access
CREATE USER webAPI FOR LOGIN webAPI;

--lets make a simple stored procedure
CREATE PROCEDURE SalesLT.GetTop5Customers
AS
BEGIN
    SELECT TOP 5 CustomerId, FirstName, LastName, EmailAddress
    FROM SalesLT.Customer;
END;

--lets grant execute permissions to the webAPI user
GRANT EXECUTE ON SalesLT.GetTop5Customers TO webAPI;
