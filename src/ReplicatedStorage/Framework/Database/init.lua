--@@ Author Trix

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

    ---replicate function "Update"
    if IS_SERVER then

    else

    end

    return self
end

return Database