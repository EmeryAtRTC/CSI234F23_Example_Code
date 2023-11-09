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
}