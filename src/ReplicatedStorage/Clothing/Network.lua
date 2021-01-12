--@@ Author Trix

local Clothing = {}
Clothing.__index = Clothing
Clothing.ClassName = "ClothingNetwork"

-- Services
local runService = game:GetService("RunService")

-- Objects
local comunicationFolder = script:FindFirstChild("Comunication")
local eventFolder = script:FindFirstChild("Events")
local functionFolder = script:FindFirstChild("Functions")

--[[ constructor ]]--

function Clothing.new()
    local self = {
        _Queue = {},
        _Type = runService:IsServer() and 0 or runService:IsClient() and 1,
        _Events = eventFolder or Instance.new("Folder"),
        _Functions = functionFolder or Instance.new("Folder"),
        _Comunication = comunicationFolder or Instance.new("Folder"),

        _Started = false
    }

    if self._Events.Name == "Events" and self._Functions.Name == "Functions" then
        self._Started = true
    else
        self._Events.Name = "Events"
        self._Functions.Name = "Functions"
        self._Comunication.Name = "Comunication"

        self._Events.Parent = self._Comunication
        self._Functions.Parent = self._Comunication
    end

    return setmetatable(self, Clothing)
end

function Clothing:AddToQueue(network, arguments)
    assert(arguments and type(arguments) == "table", "Arguments not provided")
    assert(network and (network:IsA("RemoteEvent") or network:IsA("RemoteEvent") or network:IsA("BindableEvent") or network:IsA("BindableFunction")), "Network not provided")

    self._Queue[#self._Queue+1] = { Remote = network, Arguments = arguments }

    return #self._Queue
end

function Clothing:CreateEvent(eventName)
    assert(self._Type == 0, "Must be on server")
    assert(eventName and type(eventName) == "string")

    
end

function Clothing:GetEvent(eventName)
    assert(eventName and type(eventName) == "string", "Event name is not provided")

    for _, event in ipairs(self.)
end