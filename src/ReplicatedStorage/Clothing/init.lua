--@@ Author Trix; Modified by 4thAxis

local Clothing = {}
Clothing.__index = Clothing

-- Services
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

-- Modules
local Promise = require(script.Parent.Packages.Promise)

function Clothing.new(settings)
    settings = settings or error("Clothing.new: Didn't provide settings argument")

    local self = setmetatable({
        Roact = require(script.Parent),
        Local = ( settings.PathToLocal and settings.PathToLocal:GetDesendants() ) or error("Local modules path needed"),
        Shared = settings.PathToLocal and settings.PathToShared:GetDesendants() or false,
        Packages = settings.PathToPackages and settings.PathToPackages:GetDesendants() or false,

        _Started = false
    }, Clothing)

    self.Started = function()
        return Promise.new(function(resolve)
            if self._Started then resolve() else
                repeat runService.Heartbeat:Wait() until self._Started and resolve() 
            end
        end)
    end

    self.Modules = require(script.Modules).new(self)
    self.Network = require(script.Network).new()

    self._Started = true

    return self
end

--