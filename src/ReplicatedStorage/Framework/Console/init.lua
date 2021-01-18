--@@ Author Trix

local Console = {}

-- Services
local RunService = game:GetService("RunService")

-- Statics
local IS_STUDIO = RunService:IsStudio()
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = not IS_SERVER

function Console.new(scriptInstance)
    local self = setmetatable({}, Console)

    self.Replication = IS_SERVER or Is_CLIENT
    self.LogName = scriptInstance:GetFullName()

    return self
end

function Console:Print(...)
    print(("[%s][%s] - "):format(self.Replication, self.LogName), ...)
end

function Console:Debug(...)
    if not IS_STUDIO then return end

    local traceback = debug.traceback(nil, 2)
    warn(("[DEBUG][%s][%s] - "):format(self.Replication, self.LogName), ..., "\nTraceback:", traceback)
end

function Console:Warn(...)
    local traceback = debug.traceback(nil, 2)
    warn(("[WARNING][%s][%s] - "):format(self.Replication, self.LogName), ..., "\nTraceback:", traceback)
end

function Console:Error(...)
    local traceback = debug.traceback(nil, 2)
    warn(("[ERROR][%s][%s] - "):format(self.Replication, self.LogName), ..., "\nTraceback:", traceback)
    error("SEE LAST WARN")
end

return Console