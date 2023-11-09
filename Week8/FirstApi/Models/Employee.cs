namespace FirstApi.Models;

//Models are just C# representation of a table in a database
public class Employee
{
    public int EmployeeId { get; set; }
    //prop tab
    public string FirstName { get; set; }
    //prop tab datatype tab tab type the columnname
    public string LastName { get; set; }
    public string Position { get; set; }
    public DateTime HireDate { get; set; }
    public int JobTitleId { get; set; }
}