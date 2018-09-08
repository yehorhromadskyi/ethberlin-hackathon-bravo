#addin Cake.Npm

var configuration = Argument("configuration", "Release");

var target = Argument("target", "Default");

Task("Install-packages")
    .Does(() =>
    {
		if (IsRunningOnWindows())
		{
			Information("Windows");
		}
		
		if (IsRunningOnUnix())
		{
			Information("Unix");
		}
		
		Information("\r\nInstalling solidity compiler\r\n");
        NpmInstall("solc");
    });

Task("Clean")
	.IsDependentOn("Install-packages")
    .Does(() =>
    {
        var settings = new DotNetCoreCleanSettings
        {
            Configuration = configuration
        };

        DotNetCoreClean("./", settings);
        CleanDirectory(Directory("bin"));
        CleanDirectory(Directory("obj"));
    });

Task("Compile-contract")
    .IsDependentOn("Clean")
    .Does(() => 
    {
        Information("Run compile.js\r\n");

        StartProcess("powershell", new ProcessSettings 
        {
            Arguments = new ProcessArgumentBuilder()
                .Append(@"node compile.js")
        });
    });

Task("Run-tests")
    .IsDependentOn("Compile-contract")
    .Does(() => 
    {
        var startInfo = new System.Diagnostics.ProcessStartInfo
        {
            FileName = "powershell.exe",
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };
        
        var process = new System.Diagnostics.Process { StartInfo = startInfo };
        process.Start();
        
        var testchainDir = MakeAbsolute(Directory("./testchain"));
        
        process.StandardInput.WriteLine("cd " + testchainDir);
        
        var startgeth = testchainDir + "/startgeth.bat";
        Information("Running geth: " + startgeth + "\r\n");
        
        process.StandardInput.WriteLine(startgeth);
		
        var settings = new DotNetCoreTestSettings
        {
            Configuration = configuration
        };
		
        DotNetCoreTest("./", settings);
		
		// exit geth
        process.StandardInput.WriteLine("exit");
        // exit powershell
        process.StandardInput.WriteLine("exit");
        process.WaitForExit();
    });

Task("Default")
    .IsDependentOn("Run-tests");

RunTarget(target);