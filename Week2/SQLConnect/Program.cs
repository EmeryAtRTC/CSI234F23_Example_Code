// Import the necessary namespace
using Microsoft.Data.SqlClient;
using System.Data;

// Replace with your actual connection string
string connectionString = "Server=tcp:csi234sqlserver10.database.windows.net,1433;Database=csi234sampledb;User Id=webAPI;Password=abc@123456;";

// Create a SqlConnection object using the connection string
SqlConnection connection = new SqlConnection(connectionString);

try
{
    // Open the connection to the database
    connection.Open();
    Console.WriteLine("Connection to the database is successful!");

    // Create a SqlCommand object to execute a simple query
    //SqlCommand command = new SqlCommand("SELECT TOP 5 CustomerId, FirstName, LastName, EmailAddress FROM SalesLT.Customer", connection);
    // Create a SqlCommand object to execute the stored procedure
    SqlCommand command = new SqlCommand("SalesLT.GetTop5Customers", connection);
    command.CommandType = CommandType.StoredProcedure;
    try
    {
        // Execute the command and read the results
        SqlDataReader reader = command.ExecuteReader();

        try
        {
            while (reader.Read())
            {
                // Print the values of each column in the current row
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    Console.Write(reader.GetValue(i) + "\t");
                }
                Console.WriteLine();
            }
        }
        finally
        {
            // Always call Close when done reading.
            reader.Close();
        }
    }
    finally
    {
        // Always dispose of the command object when done.
        command.Dispose();
    }
}
finally
{
    // Close the connection
    connection.Close();
}

Console.ReadLine();
