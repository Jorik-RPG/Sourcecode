---@Author Trix

local Database = {}

-- Services
local RunService = game:GetService("RunService")

-- Statics
local IS_STUDIO = RunService:IsStudio()
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = not IS_SERVER

function Database.new(framework)
    if IS_STUDIO then return self end

    local self = metatable(framework, Database)

    if IS_SERVER then
        self.Replicator = Instance.new("RemoteFunction")
        self.Replicator.Name = "Replicator"
        self.Replicator.Parent = script
        self.Replicator.OnServerInvoke = function(functionName, ...)
            if not Database[functionName] then return nil end
            Database[functionName](self, ...)
        end

        local apiChildren = script:WaitForChild("Api"):GetChildren()

        for i=1, #apiChildren do
            local module = apiChildren[i]

            if module:IsA("Module") then
                if not self.ModuleCache then
                    self.ModuleCache = {}
                end

                self.ModuleCache[#self.ModuleCache + 1] = require(module)
            end
        end

        self.Console.new(script):Warn("Loaded database")
    elseif not IS_STUDIO and IS_CLIENT then
        self.Replicator = script:WaitForChild("Replicator") or self.Console.new(script):Error("Server didn't replicate function in time")
    end

    return self
end

---@param value string
---@param newValue string
---@param forceRecolide boolean
function Database:Update(value, newValue, forceRecolide)
    self.Console:Assert(value and type(value) == "string", "Invalid type for 'value'; a string is expected")
    self.Console:Assert(newValue, "Invalid type for 'value'; a data type is expected")
    self.Console:Assert(not forceRecolide or forceRecolide, "Invalid type for 'forceRecolide'; a boolean is expected")

    
end

return Database