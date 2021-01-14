--@@ Author Trix

local Database = {}

-- Services
local RunService = game:GetService("RunService")

-- Variables
local FileSystem = nil

-- Statics
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

function Database.new(self)
    self = metatable(self, Database)

    if IS_SERVER then
        local ModuleTable = {}

        for _, module in ipairs(script.Server:GetChildren()) do
            if module:IsA("Module") then
                ModuleTable[module.Name] = require(module)
            end
        end

        for _, module in ipairs(script.Client:GetChildren()) do
            if module:IsA("Module") then
                ModuleTable[module.Name] = require(module)
            end
        end

        FileSystem = ModuleTable

        for index, key in pairs(ModuleTable) do
            key = key and type(key) == "Table" or error("Something isn't a table in Module table")

            for functionName, funct in pairs(key) do
                if typeof(funct) == "Function" then
                    self.Network:GetEvent(("%s-%s"):format(index, functionName)):Connect(funct)
                end
            end
        end
    elseif IS_CLIENT then
        script.Server:Destroy()
    end

    return self
end