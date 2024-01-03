using System.Management.Automation;

class Program
{
    static void Main()
    {
        string jsonString = "{\"name\":\"a01234567\",\"firstname\":\"jane\",\"lastname\":\"doe\",\"objectGUID\":\"86719e9a-7c04-4f80-b802-fe4c82c61f22\"}";

        // Create PowerShell instance
        using (PowerShell PowerShellInstance = PowerShell.Create())
        {
            // Supply the script file and add the parameter
            PowerShellInstance.AddScript(@"C:\Path\To\YourScript.ps1").AddArgument($"-jsonString '{jsonString}'");

            // Invoke execution
            Collection<PSObject> PSOutput = PowerShellInstance.Invoke();

            // Output the results (if any)
            foreach (PSObject outputItem in PSOutput)
            {
                // Access properties/methods of the result
                Console.WriteLine(outputItem.BaseObject.ToString());
            }
        }
    }
}
