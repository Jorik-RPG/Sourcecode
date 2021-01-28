--@@ Author Trix

local Network     = {}
Network.__index   = Network
Network.ClassName = "Network"

-- Services
local RunService = game:GetService("RunService")

-- Objects
local comunicationFolder = script:FindFirstChild("Comunication")
local eventFolder        = script:FindFirstChild("Events")
local functionFolder     = script:FindFirstChild("Functions")

-- Statics
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = not IS_SERVER

--[[ constructor ]]--

function Network.new(framework)
    local self = setmetatable(framework, Network)
    self._Events       = eventFolder or Instance.new("Folder")
    self._Functions    = functionFolder or Instance.new("Folder")
    self._Comunication = comunicationFolder or Instance.new("Folder")
    self._Started      = false

    -- Referenced modules
    self.Console = framework.Console.new(script)

    if self._Events.Name == "Events" and self._Functions.Name == "Functions" then
        self._Started = true
    else
        self._Events.Name         = "Events"
        self._Functions.Name      = "Functions"
        self._Comunication.Name   = "Comunication"

        self._Comunication.Parent = script
        self._Events.Parent       = self._Comunication
        self._Functions.Parent    = self._Comunication
    end

    return self
end

function Network:CreateEvent(eventName)
    self.Console:Assert(eventName and type(eventName) == "string", "Event name is not provided")
    self.Console:Assert(IS_SERVER, "Must be running on the server")

    local remoteInstance = Instance.new("RemoteEvent")
    remoteInstance.Name = eventName
    remoteInstance.Parent = self._Events

    return remoteInstance
end

function Network:CreateFunction(functionName)
    self.Console:Assert(functionName and type(functionName) == "string", "Function name is not provided")
    self.Console:Assert(IS_SERVER, "Must be running on the server")
end

function Network:GetEvent(eventName)
    self.Console:Assert(eventName and type(eventName) == "string", "Event name is not provided")

    local returnInstance = nil

    for _, event in ipairs(self._Events:GetChildren()) do
        if not event:IsA("RemoteEvent") and event.Name ~= eventName then continue end

        if event then
            returnInstance = event

            break
        end
    end
    
    -- this will have a less cognitive complexity but obviously this won't lower your cyclomatic complexity
    return ( returnInstance and { Success = true, Data = returnInstance } ) or { Success = false, Error = "Couldn't find remote event" };
end

return Network








