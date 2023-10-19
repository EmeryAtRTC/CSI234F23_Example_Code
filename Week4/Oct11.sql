-- INSERT - Creates a new row in a table
-- INSERT INTO schema.table (columns, column2, column3) 
-- VALUES (value1, value2, value3)

-- Dont provide column names, but you have to provide a value FOR EVERY COLUMN
-- INSERT INTO 
-- VALUES (value1, value2, value3)

INSERT INTO SalesLT.Product ([Name], ProductNumber, StandardCost, ListPrice, SellStartDate)
VALUES ('New Product', 'NP-1', 50, 100, GETDATE())
--add a new product

-- SELECT * FROM SalesLT.Product;

-- IMPORTANT - Always Select before you DO!
-- Update the product we just made
SELECT * FROM SalesLT.Product
WHERE NAME = 'New Product';

--Once we have verified that we have the correct row(s)
--No we do the update
-- UPDATE schema.table
-- SET columnname
-- WHERE some criteria
UPDATE SalesLT.Product
SET ListPrice = 150
WHERE NAME = 'New Product';

--DELETE: Make sure you select before you delete
-- DELETE schema.table
-- WHERE some criteria
DELETE FROM SalesLT.Product
WHERE NAME = 'New Product';

-- Aggregations and Group BY
-- The group by clause is used to combine identical data based on a column
SELECT * FROM SalesLT.Product;
-- Group by category and find out how many products in each
SELECT ProductCategoryID, COUNT(*) AS NumberOfProducts
FROM SalesLT.Product
GROUP BY ProductCategoryID

-- Aggregation with a Join
-- WHEN you GROUP BY every Column in the result must either be Aggregate Function
-- OR be present in the Group By
SELECT p.ProductCategoryID, pc.Name, COUNT(*) AS NumberOfProducts
FROM SalesLT.Product AS p 
JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.ProductCategoryID, pc.Name;

-- Aggregation with a having
SELECT ProductCategoryID, COUNT(*) AS NumberOfProducts
FROM SalesLT.Product
GROUP BY ProductCategoryID
HAVING COUNT(*) > 5;

-- Lets see if we can only get the products with more than 25 sales
SELECT p.ProductID, p.Name, SUM(so.OrderQty) AS TotalSalesQuantity
FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS so ON p.ProductID = so.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(so.OrderQty) > 25;

--Views
--A view is a virtual table that is the result of a select stament
--It doesn't directly store data, but it packages it up in a re-usable statement
GO
CREATE VIEW SalesLt.ProductWithHighSales AS
SELECT p.ProductID, p.Name, SUM(so.OrderQty) AS TotalSalesQuantity
FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS so ON p.ProductID = so.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(so.OrderQty) > 25;
GO
-- Calling our view
SELECT * FROM SalesLT.ProductWithHighSales;

-- Stored Procedures
-- Are precompiled collections of one or more SAL statements
-- They can take parameters
-- They can also modify database state
-- CRUD (Create Read Update Delete)

-- Get the products with sale quantity greater than the parameter
GO
CREATE PROCEDURE SalesLt.GetProductsOverSales(@qty INT)
AS
BEGIN
    SELECT p.ProductID, p.Name, SUM(so.OrderQty) AS TotalSalesQuantity
    FROM SalesLT.Product AS p
    JOIN SalesLT.SalesOrderDetail AS so ON p.ProductID = so.ProductID
    GROUP BY p.ProductID, p.Name
    HAVING SUM(so.OrderQty) > @qty;
END;
-- Call a stored procedure EXEC Name parameter
EXEC SalesLT.GetProductsOverSales @qty = 50;

--Functions
-- Similar to stored proecedures however they can return just one value
-- The cannot do any CRUD operations
-- They can abe used as part of other queries

GO
CREATE FUNCTION SalesLT.TotalSalesForProduct(@ProductID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalSales INT
    SELECT @TotalSales = SUM(OrderQty)
    FROM SalesLT.SalesOrderDetail
    WHERE ProductID = @ProductID
    RETURN @TotalSales
END;

GO
--Calling the function
SELECT SalesLT.TotalSalesForProduct(712);
--Where function really get interesting
SELECT ProductID, [Name], SalesLT.TotalSalesForProduct(ProductID) AS TotalSales
FROM SalesLT.Product

-- Indexing
-- An index provides a way for the database to efficiently locate rows based on column values
-- If there is not index you might actually have to scan every row (SLOW)
CREATE INDEX IDX_Product_Name on SalesLT.Product(Name);

-- columns that are frequently searched or filtered on
-- columns used in joins
-- columns used in where clauses, group by, order by

-- There are some downsides
-- indexes slow down INSERT UPDATE and DELETE satements
-- They do take up space (storage)
-- Write peformance vs Read performance

-- Schema
GO
-- CREATE SCHEMA SCHEMANAME
GO
-- ADD a table to a schema
-- CREATE TABLE SchemaName.TableName(columnName Datatype, column2 datatype2)

--We used schemas to logically group objects by pourpose or department
--We use them to manage permissions
--Avoid Naming conflicts
--Object cannot be part of more than once Schema
--Default is dbo