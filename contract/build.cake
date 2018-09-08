var configuration = Argument("configuration", "Release");

var target = Argument("target", "Default");

Task("Run-tests")
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