using System.Diagnostics;

class Program
{
    static void Main()
    {
        // Your JSON string
        string jsonString = "{\"Name\":\"John Doe\",\"Age\":30}";

        // Use PowerShell to execute the script with the JSON string as a parameter
        using (var process = new Process())
        {
            process.StartInfo.FileName = "powershell.exe";
            process.StartInfo.Arguments = $"-File \"C:\\Path\\To\\Your\\Script.ps1\" -userjson '{jsonString}'";
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.CreateNoWindow = true;

            process.Start();

            // Do something with the output if needed
            string output = process.StandardOutput.ReadToEnd();
            Console.WriteLine(output);

            process.WaitForExit();
        }
    }
}


#===========================================================
When invoking PowerShell commands from C# and passing JSON strings, it's crucial to ensure that the string is formatted correctly and reaches PowerShell as expected. Let's refine the C# code to handle this more precisely.

Assuming you are using System.Management.Automation for running PowerShell commands from C#, here's an example:

csharp
Copy code
using System.Management.Automation;

class Program
{
    static void Main()
    {
        // Your JSON string
        string jsonString = "{\"name\":\"a01234567\",\"firstname\":\"jane\",\"lastname\":\"doe\",\"objectGUID\":\"86719e9a-7c04-4f80-b802-fe4c82c61f22\"}";

        // Create PowerShell instance
        using (PowerShell PowerShellInstance = PowerShell.Create())
        {
            // Use AddScript to add your PowerShell commands
            PowerShellInstance.AddScript("$userjson = $args[0] | ConvertFrom-Json; $userjson");

            // Pass the JSON string as a parameter
            Collection<PSObject> PSOutput = PowerShellInstance.Invoke(new object[] { jsonString });

            // Iterate through the results
            foreach (PSObject outputItem in PSOutput)
            {
                // Access properties as needed
                string name = outputItem.Members["name"].Value.ToString();
                string firstName = outputItem.Members["firstname"].Value.ToString();
                string lastName = outputItem.Members["lastname"].Value.ToString();
                string objectGUID = outputItem.Members["objectGUID"].Value.ToString();

                // Now you can work with the properties
                Console.WriteLine($"Name: {name}, First Name: {firstName}, Last Name: {lastName}, Object GUID: {objectGUID}");
            }
        }
    }
}
This example explicitly sets the $userjson variable using $args[0] to pass the JSON string to the PowerShell script. It then outputs the result, which you can access and process in C#.

Make sure your C# code reflects the correct structure and property names. If the issue persists, check for any error messages or exceptions thrown during the PowerShell script execution. Let me know if you need further assistance!
