--@@ Author Trix

local Database = {}

-- Services
local RunService = game:GetService("RunService")

-- Statics
local IS_STUDIO = RunService:IsStudio()
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = not IS_SERVER

function Database.new(self)
    if IS_STUDIO then return self end

    self = metatable(self, Database)

    ---replicate function "Update"
    if IS_SERVER then

    else

    end

    return self
end

return


