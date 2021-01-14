--@@ Author Dyl, Trix

local modules = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Framework = require(ReplicatedStorage:WaitForChild("Framework")).new({
    PathToLocal = script.Modules,
    PathToShared = ReplicatedStorage:WaitForChild("Modules"),
    PathToPackages = ReplicatedStorage:WaitForChild("Packages")
})

local function RunModule(staticClass)
    staticClass = staticClass and type(staticClass) == "table" and staticClass.Run or error("Missing static class")

    staticClass.Run(Framework)
end

local function RequireModules()
    for _, module in ipairs(script.Modules:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end

        local staticClass = require(module)
        RunModule(staticClass)
    end
end

RequireModules()