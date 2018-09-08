var target = Argument("target", "Default");

Task("Default")
    .Does(() => 
    {
        Information("Cake hello world\r\n");
    });

RunTarget(target);