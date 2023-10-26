CREATE PROCEDURE HR.ListAllDepartments
AS
BEGIN
    SELECT DepartmentID, DepartmentName FROM HR.Department;
END;


CREATE PROCEDURE HR.GetEmployeesByDepartment
    @DepartmentId INT
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, jt.Title AS JobTitle
    FROM HR.Employee e
    JOIN HR.JobTitle jt ON e.JobTitleID = jt.JobTitleID
    JOIN HR.EmployeeDepartment ed ON e.EmployeeID = ed.EmployeeID
    WHERE ed.DepartmentID = @DepartmentId;
END;
