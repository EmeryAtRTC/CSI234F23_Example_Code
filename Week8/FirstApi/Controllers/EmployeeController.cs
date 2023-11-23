using Dapper;
using FirstApi.Models;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

namespace FirstApi.Controllers;

[ApiController]
[Route("api/[controller]")]
//now we creat the class
public class EmployeeController : ControllerBase
{
    //initializes the fields
    string connectionString;
    public EmployeeController(IConfiguration configuration)
    {
        connectionString = configuration.GetConnectionString("DefaultConnection");
        //Console.WriteLine(connectionString);
    }
    [HttpGet]
    //I want to return data and a status
    public ActionResult<List<Employee>> GetAllEmployees()
    {
        using SqlConnection connection = new SqlConnection(connectionString);
        //here is where we use dapper
        List<Employee> employees = connection.Query<Employee>("SELECT * FROM HR.EMPLOYEE").ToList();
        return Ok(employees);
    }
    [HttpGet("{id}")]
    //This only get one employee
    public ActionResult<Employee> GetEmployeeById(int id)
    {
        using SqlConnection connection = new SqlConnection(connectionString);
        //what do you want back just 1 employee
        Employee employee = connection.QueryFirstOrDefault<Employee>("SELECT * FROM HR.EMPLOYEE WHERE EMPLOYEEID = @Id", new { Id = id });
        //check if the employee was null
        if (employee == null)
        {
            return NotFound();
        }
        return Ok(employee);
    }
    //To Create an employee we need a JobTitleId AND It has to be valid
    [HttpPost]
    public ActionResult<Employee> CreateEmployee(Employee employee)
    {
        //make sure that I got a JobTitleId
        if(employee.JobTitleId < 1)
        {
            return BadRequest();
        }
        using SqlConnection connection = new SqlConnection(connectionString);
        //next make sure the JobTitleExists
        JobTitle jobTitle = connection.QueryFirstOrDefault<JobTitle>("SELECT * FROM HR.JobTitle " +
            "WHERE JobTitleId = @Id", new { Id = employee.JobTitleId });
        if (jobTitle == null)
        {
            return BadRequest();
        }
        employee.Position = jobTitle.Description;
        try
        {
            //SCOPE_IDENTITY() this gets you the primary key of the newly created object
            Employee newEmployee = connection.QuerySingle<Employee>(
                "INSERT INTO HR.Employee (FirstName, LastName, Position, HireDate, JobTitleId) " +
                "VALUES (@FirstName, @LastName, @Position, @HireDate, @JobTitleId); " +
                "SELECT * FROM HR.Employee WHERE EmployeeId = SCOPE_IDENTITY();", employee);
            return Ok(newEmployee);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
            return BadRequest();
        }
    }
    //Update
    [HttpPut("{id}")]
    public ActionResult<Employee> UpdateEmployee(int id, Employee employee)
    {
        if(id < 1)
        {
            return BadRequest();
        }
        employee.EmployeeId = id;
        using SqlConnection connection = new SqlConnection(connectionString);
        //next make sure the JobTitleExists
        JobTitle jobTitle = connection.QueryFirstOrDefault<JobTitle>("SELECT * FROM HR.JobTitle " +
            "WHERE JobTitleId = @Id", new { Id = employee.JobTitleId });
        if (jobTitle == null)
        {
            return BadRequest();
        }
        employee.Position = jobTitle.Description;
        try
        {
            Employee updatedEmployee = connection.QuerySingle<Employee>(
                "UPDATE HR.Employee SET FirstName = @FirstName, LastName = @LastName, Position = @Position" +
                "HireDate = @HireDate, JobTitleId = @JobTitleId WHERE EmployeeId = @EmployeeId", employee);
            return Ok(updatedEmployee);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
            return BadRequest();
        }


    }
    [HttpDelete("{id}")]
    public ActionResult DeleteEmployee(int id)
    {
        if(id < 1)
        {
            return BadRequest();
        }
        using SqlConnection connection = new SqlConnection(connectionString);
        int rowsAffected = connection.Execute("DELETE FROM HR.Employees WHERE EmployeeId = @Id", new {Id = id});
        if(rowsAffected == 0)
        {
            return NotFound();
        }
        return Ok();
    }

}