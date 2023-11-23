using Dapper;
using FirstApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

namespace FirstApi.Controllers
{
    //we get to this controller with /api/jobtitle
    [Route("api/[controller]")]
    [ApiController]
    public class JobTitleController : ControllerBase
    {
        string connectionString;
        public JobTitleController(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }
        //get
        // api/jobtitle
        [HttpGet]
        public ActionResult<List<JobTitle>> GetAllJobTitle()
        {
            using SqlConnection connection = new SqlConnection(connectionString);
            List<JobTitle> jobTitles = connection.Query<JobTitle>("Select * from HR.JobTitle").ToList();
            return Ok(jobTitles);
        }
        //get with an id
        //api/jobtitle/id
        [HttpGet("{id}")]
        public ActionResult<JobTitle> GetJobTitle(int id)
        {
            if(id < 1)
            {
                return BadRequest();
            }
            using SqlConnection connection = new SqlConnection(connectionString);
            JobTitle jobTitle = connection.QueryFirstOrDefault<JobTitle>("SELECT * FROM HR.JobTitle WHERE JobTitleId = @Id", new {Id = id});
            if(jobTitle == null)
            {
                return NotFound();
            }
            return Ok(jobTitle);
        }
        //POST - Create
        //Put - Update
        //Delete - Delete
        [HttpPost]
        public ActionResult<JobTitle> CreateJobTitle(JobTitle jobTitle)
        {
            using SqlConnection connection = new SqlConnection(connectionString);
            //return Ok(jobTitle);
            //int rowsAffected = connection.Execute("INSERT INTO HR.JobTitle (Title, Description) VALUES (@Title, @Description)", jobTitle);
            //if(rowsAffected == 0)
            //{
            //    return BadRequest();
            //}
            //return Ok(jobTitle);
            try
            {
                //SCOPE_IDENTITY() this gets you the primary key of the newly created object
                JobTitle newJobTitle = connection.QuerySingle<JobTitle>(
                    "INSERT INTO HR.JobTitle (Title, Description) VALUES (@Title, @Description); " +
                    "SELECT * FROM HR.JobTitle WHERE JobTitleId = SCOPE_IDENTITY();", jobTitle);
                return Ok(newJobTitle);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return BadRequest();
            }
        }
        //PUT api/jobtitle/id
        [HttpPut("{id}")]
        public ActionResult<JobTitle> UpdateJobTitle(int id, JobTitle jobTitle)
        {
            if(id < 1)
            {
                return NotFound();
            }
            jobTitle.JobTitleId = id;
            using SqlConnection connection = new SqlConnection(connectionString);
            //Put - You have to send ALL of the information whether it changed or not
            int rowsAffected = connection.Execute("UPDATE HR.JobTitle " +
                "SET Title = @Title, Description = @Description " +
                "WHERE JobTitleId = @JobTitleId", jobTitle);
            if(rowsAffected == 0)
            {
                return BadRequest();
            }
            return Ok(jobTitle);
        }
        //Delete is a sensitive operation
        [HttpDelete("{id}")]
        public ActionResult DeleteJobTitle(int id)
        {
            if (id < 1)
            {
                return NotFound();
            }
            using SqlConnection connection = new SqlConnection(connectionString);
            int rowsAffected = connection.Execute("DELETE FROM HR.JobTitle WHERE JobTitleId = @Id", new { Id = id });
            if(rowsAffected == 0)
            {
                return BadRequest();
            }
            return Ok();
        }
    }
}
