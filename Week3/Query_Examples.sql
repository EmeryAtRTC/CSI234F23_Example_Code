-- Query 1: Basic Select Statement
-- Retrieve all columns from the SalesLT.Product table.
SELECT * FROM SalesLT.Product;
-- In plain terms: This query is fetching all the records and columns from the Product table in the SalesLT schema.

-- Query 2: Select Specific Columns
-- Retrieve the Name and ListPrice columns from the SalesLT.Product table.
SELECT [Name], ListPrice FROM SalesLT.Product;
-- In plain terms: We are getting the Name and ListPrice of each product from the Product table.

-- Query 3: Aliasing
-- Retrieve the Name as ProductName and ListPrice as Price from the SalesLT.Product table.
SELECT [Name] AS ProductName, ListPrice AS Price FROM SalesLT.Product;
-- In plain terms: We are renaming the Name and ListPrice columns to ProductName and Price respectively in the output.
-- Aliasing a table name is also possible. For example
SELECT * FROM SalesLT.Product P;
-- We do this to avoid ambiguity when joining multiple tables.


-- Query 4: Inner Join
-- Retrieve the Product Name and its Category Name.
SELECT P.Name AS ProductName, C.Name AS CategoryName
FROM SalesLT.Product P
INNER JOIN SalesLT.ProductCategory C ON P.ProductCategoryID = C.ProductCategoryID;
-- In plain terms: We are matching each product with its category and displaying their names.

-- Query 5: Inner Join with Multiple Tables
-- Retrieve the Product Name, Category Name, and the Order Quantity.
SELECT P.Name AS ProductName, C.Name AS CategoryName, OD.OrderQty
FROM SalesLT.Product P
INNER JOIN SalesLT.ProductCategory C ON P.ProductCategoryID = C.ProductCategoryID
INNER JOIN SalesLT.SalesOrderDetail OD ON P.ProductID = OD.ProductID;
-- In plain terms: We are matching products with their categories and order details to display the product name, category name, and order quantity.

-- Query 6: Left Join
-- Retrieve all customers and their orders, if any.
SELECT C.CustomerID, C.FirstName, C.LastName, O.SalesOrderID
FROM SalesLT.Customer C
LEFT JOIN SalesLT.SalesOrderHeader O ON C.CustomerID = O.CustomerID;
-- In plain terms: We are listing all customers and their orders, including customers who haven't placed any orders, displaying NULL for their order information.

-- Query 7: Right Join
-- Retrieve all orders and their customers, if any.
SELECT C.CustomerID, C.FirstName, C.LastName, O.SalesOrderID
FROM SalesLT.Customer C
RIGHT JOIN SalesLT.SalesOrderHeader O ON C.CustomerID = O.CustomerID;
-- In plain terms: We are listing all orders and the customers who placed them, including orders that are not associated with any customer, displaying NULL for customer information.

-- Query 8: Full Outer Join
-- Retrieve all customers and all orders, matching where possible.
SELECT C.CustomerID, C.FirstName, C.LastName, O.SalesOrderID
FROM SalesLT.Customer C
FULL OUTER JOIN SalesLT.SalesOrderHeader O ON C.CustomerID = O.CustomerID;
-- In plain terms: We are listing all customers and all orders, matching them where possible, and displaying NULL for non-matching rows.

-- Query 9: Filtering with WHERE
-- Retrieve all products with a ListPrice greater than 100.
SELECT * FROM SalesLT.Product
WHERE ListPrice > 100;
-- In plain terms: We are fetching all products that have a list price greater than 100.

-- Query 10: Filtering with Multiple Conditions
-- Retrieve all red products with a ListPrice greater than 100.
SELECT * FROM SalesLT.Product
WHERE ListPrice > 100 AND Color = 'Red';
-- In plain terms: We are fetching all red products that have a list price greater than 100.

-- Query 11: Subquery in WHERE Clause
-- Retrieve customers who have placed more than 5 orders.
SELECT * FROM SalesLT.Customer
WHERE CustomerID IN (SELECT CustomerID FROM SalesLT.SalesOrderHeader GROUP BY CustomerID HAVING COUNT(SalesOrderID) > 5);
-- In plain terms: We are identifying customers who have placed more than five orders.

-- Query 12: Subquery in SELECT Clause
-- Retrieve the Product Name and its total Order Quantity.
SELECT Name, (SELECT SUM(OrderQty) FROM SalesLT.SalesOrderDetail WHERE ProductID = P.ProductID) AS TotalOrderQty
FROM SalesLT.Product P;
-- In plain terms: For each product, we are calculating the total quantity ordered and displaying it along with the product name.

-- Query 13: Common Table Expressions (CTE)
-- Using a CTE to find the total quantity of each product ordered.
WITH ProductQuantity AS (
    SELECT ProductID, SUM(OrderQty) AS TotalQuantity
    FROM SalesLT.SalesOrderDetail
    GROUP BY ProductID
)
SELECT P.Name, PQ.TotalQuantity
FROM SalesLT.Product P
JOIN ProductQuantity PQ ON P.ProductID = PQ.ProductID;
-- In plain terms: We are calculating the total quantity ordered for each product and displaying it along with the product name.

-- Query 14: Recursive CTE
-- Retrieve the hierarchy of product categories.
WITH CategoryHierarchy AS (
    SELECT ProductCategoryID, Name, ParentProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE ParentProductCategoryID IS NULL
    UNION ALL
    SELECT C.ProductCategoryID, C.Name, C.ParentProductCategoryID
    FROM SalesLT.ProductCategory C
    INNER JOIN CategoryHierarchy CH ON C.ParentProductCategoryID = CH.ProductCategoryID
)
SELECT * FROM CategoryHierarchy;
-- In plain terms: We are building and displaying the hierarchy of product categories using a recursive CTE.

-- Query 15: Insert Statement
-- Insert a new product into the SalesLT.Product table.
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, SellStartDate)
VALUES ('New Product', 'NP-001', 50, 100, GETDATE());
-- In plain terms: We are adding a new product with specified details to the Product table.

-- Query 16: Update Statement
-- Update the ListPrice of the newly added product.
UPDATE SalesLT.Product
SET ListPrice = 120
WHERE Name = 'New Product';
-- In plain terms: We are updating the list price of the newly added product to 120.

-- Query 17: Delete Statement
-- Delete the newly added product.
DELETE FROM SalesLT.Product
WHERE Name = 'New Product';
-- In plain terms: We are removing the newly added product from the Product table.

-- Query 18: Aggregations with GROUP BY
-- Find the total number of products in each category.
SELECT ProductCategoryID, COUNT(*) AS NumberOfProducts
FROM SalesLT.Product
GROUP BY ProductCategoryID;
-- In plain terms: We are counting the total number of products in each category and displaying the results.

-- Query 19: Aggregations with HAVING
-- Retrieve categories with more than 5 products.
SELECT ProductCategoryID, COUNT(*) AS NumberOfProducts
FROM SalesLT.Product
GROUP BY ProductCategoryID
HAVING COUNT(*) > 5;
-- In plain terms: We are finding the categories that have more than five products and displaying the results.

-- Query 23: Dynamic SQL
-- Execute a dynamic SQL query to retrieve all products.
DECLARE @SQLQuery AS NVARCHAR(MAX)
SET @SQLQuery = 'SELECT * FROM SalesLT.Product'
EXEC sp_executesql @SQLQuery;
-- In plain terms: We are constructing a SQL query as a string and then executing it to retrieve all products.

-- Query 24: Stored Procedure
-- Create a stored procedure to retrieve products by category.
-- CREATE PROCEDURE GetProductsByCategory @CategoryID INT AS
-- BEGIN
    --SELECT * FROM SalesLT.Product
    --WHERE ProductCategoryID = @CategoryID;
--END;
-- In plain terms: We are creating a stored procedure that takes a category ID as a parameter and retrieves all products in that category.

-- Query 25: Execute Stored Procedure
-- Execute the stored procedure to retrieve products in a specific category.
-- EXEC GetProductsByCategory @CategoryID = 1;
-- In plain terms: We are executing the stored procedure we created to retrieve all products in the specified category.

-- Query 26: Function
-- Create a function to calculate the total price of an order.
-- CREATE FUNCTION CalculateTotalPrice (@OrderID INT) RETURNS MONEY AS
-- BEGIN
--     DECLARE @TotalPrice MONEY
--     SELECT @TotalPrice = SUM(UnitPrice * OrderQty) FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID
--     RETURN @TotalPrice
-- END;
-- In plain terms: We are creating a function that takes an order ID as a parameter and calculates the total price of that order.

-- Query 27: Use Function
-- Use the function to calculate the total price of a specific order.
-- SELECT dbo.CalculateTotalPrice(1) AS TotalPrice;
-- In plain terms: We are using the function we created to calculate the total price of the specified order.

-- Query 28: Index
-- Create an index on the ProductCategoryID column of the SalesLT.Product table.
CREATE INDEX IX_Product_ProductCategoryID ON SalesLT.Product(ProductCategoryID);
-- In plain terms: We are creating an index on the ProductCategoryID column to improve the performance of queries that filter or sort by this column.

-- Query 29: View
-- Create a view to retrieve the Product Name and its Category Name.
-- CREATE VIEW ProductWithCategory AS
-- SELECT P.Name AS ProductName, C.Name AS CategoryName
-- FROM SalesLT.Product P
-- JOIN SalesLT.ProductCategory C ON P.ProductCategoryID = C.ProductCategoryID;
-- In plain terms: We are creating a view that joins the Product and ProductCategory tables and retrieves the Product Name and its Category Name.

-- Query 30: Use View
-- Retrieve the Product Name and its Category Name from the view.
-- SELECT * FROM ProductWithCategory;
-- In plain terms: We are using the view we created to easily retrieve the Product Name and its Category Name without writing the join query again.
