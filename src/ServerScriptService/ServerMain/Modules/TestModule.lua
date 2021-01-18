return {
    ClassName = "TestModule";
    Run = function(framework)
        local Console = framework.Console.new(script)

        Console:Print("Loaded")
    end;
}