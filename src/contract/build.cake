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
        var settings = new DotNetCoreTestSettings
        {
            Configuration = configuration
        };
		
        DotNetCoreTest("./", settings);
    });

Task("Default")
    .IsDependentOn("Run-tests");

RunTarget(target);