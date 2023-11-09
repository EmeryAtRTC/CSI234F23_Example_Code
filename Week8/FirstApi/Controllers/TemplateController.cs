using Microsoft.AspNetCore.Mvc;

namespace FirstApi.Controllers;

//What is a controller
//its just a clas that inherits from ControllerBase
//What route will hit this controller
//We will hit this controller with an request that goes to api/Template
[Route("api/[controller]")]
[ApiController]
public class TemplateController : ControllerBase
{
    //Constructor
    public TemplateController()
    {

    }
    //methods that fire based on requests
    //GET: /api/template
    [HttpGet]
    public string Get()
    {
        return "Hello World";
    }
    //Get request with parameter
    //GET /api/template/1
    //This 1 is many times a primary key id
    //Select * from Students Where ID = 1
    [HttpGet("{id}")]
    public string Get(int id)
    {
        return $"Value: {id}";
    }
    //Post
    //Post is used to create a new record OR send sensitive
    //Insert into student(Name, Grade) values ("Hannah", 100)
    [HttpPost]
    public void Post([FromBody] string value)
    {
        Console.WriteLine("Post");
    }
    //Put /api/Template/1
    //This is used to update
    //You need an ID and we need data from the body
    //Update Students set Name = "Kristyn" where id = 1
    [HttpPut("{id}")]
    public void Put(int id, [FromBody] string value)
    {
        Console.WriteLine("Put Request");
    }
    //Delete : /api/template/1
    //delete from students where id = 1
    [HttpDelete("{id}")]
    public void Delete(int id)
    {
        Console.WriteLine("Delete Request");
    }
}