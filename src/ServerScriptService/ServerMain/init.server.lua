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
        local staticClass = require(module)
        if staticClass.Run then
            table.insert(modules, staticClass)
        end
    end

    RunModules()
end

RequireModules()