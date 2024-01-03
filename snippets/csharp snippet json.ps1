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
