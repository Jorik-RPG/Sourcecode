--@@ Author Trix

local Framework = {}
Framework.__index = Framework
Framework.ClassName = "FrameworkNetwork"

-- Services
local runService = game:GetService("RunService")

-- Objects
local comunicationFolder = script:FindFirstChild("Comunication")
local eventFolder = script:FindFirstChild("Events")
local functionFolder = script:FindFirstChild("Functions")

--[[ constructor ]]--

function Framework.new()
    local self = setmetatable({
        _Queue = {},
        _Type = runService:IsServer() and 0 or runService:IsClient() and 1,
        _Events = eventFolder or Instance.new("Folder"),
        _Functions = functionFolder or Instance.new("Folder"),
        _Comunication = comunicationFolder or Instance.new("Folder"),

        _Started = false
    }, Framework)

    if self._Events.Name == "Events" and self._Functions.Name == "Functions" then
        self._Started = true
    else
        self._Events.Name = "Events"
        self._Functions.Name = "Functions"
        self._Comunication.Name = "Comunication"

        self._Events.Parent = self._Comunication
        self._Functions.Parent = self._Comunication
    end

    return self
end

function Framework:CreateEvent(eventName)
    eventName = eventName and type(eventName) == "string" and self._Type == 0 or error("Not on server, name missing")

    local remoteInstance = Instance.new("RemoteEvent")
    remoteInstance.Name = eventName
    remoteInstance.Parent = self._Events

    return remoteInstance
end

function Framework:GetEvent(eventName)
    eventName = eventName and type(eventName) == "string" or error("Event name is not provided")

    local returnInstance = nil

    for _, event in ipairs(self._Events:GetChildren()) do
        event = event and event:IsA("RemoteEvent") and event.Name == eventName or false

        if event then
            returnInstance = event
        end
    end

    if returnInstance then
        return { Success = true, Data = returnInstance }
    else
        return { Success = false, Error = "Couldn't find remote event" }
    end
end

return Framework