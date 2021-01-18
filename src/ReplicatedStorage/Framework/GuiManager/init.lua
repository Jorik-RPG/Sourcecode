--[[
Get this shit done so I can do roact
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

local RoactGui = Modules:WaitForChild("RoactGui")

local RoactModules = {}

local function RequireModules()
    for _, module in ipairs(RoactModules) do
        if module:IsA("ModuleScript") then
            table.insert(RoactModules, require(module))
        end
    end
end

local function RunModules(framework)
    
end

return function(framework)
    RequireModules()
    RunModules(framework)
end