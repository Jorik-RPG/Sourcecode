--@@ Author Dyl, Trix

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Framework = require(ReplicatedStorage:WaitForChild("Framework")).new({
    PathToLocal = script.Modules,
    PathToShared = ReplicatedStorage:WaitForChild("Modules"),
    PathToPackages = ReplicatedStorage:WaitForChild("Packages")
})

-- Waiting for the framework to start
Framework.Started():await()

local Console = Framework.Console.new(script)
local Modules = Framework.Modules.new(Framework)

local function RunModule(staticClass)
    Console:Assert(staticClass, "Static Class is non existant")

    staticClass.Run(Framework)
end

local function RequireModules()
    for _, module in ipairs(Modules:GetAllLocal()) do
        if not module:IsA("ModuleScript") then continue end

        Console:Print("Loading ", module.Name)

        local staticClass = require(module)
        RunModule(staticClass)
    end
end

RequireModules()