local ModulesDirectory = script.Modules

local modules = {}

local function RunModules()
    for _, staticClass in ipairs(modules) do
        if staticClass.Run then
            staticClass.Run(modules)
        end
    end
end

local function RequireModules()
    for _, module in ipairs(ModulesDirectory:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end

        local staticClass = require(module)
        table.insert(modules, staticClass)
    end

    RunModules()
end

RequireModules()