--@@ Author Trix

local Clothing = {}
Clothing.__index = Clothing

-- Services
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

-- Modules
local Promise = require(script.Parent.Packages.Promise)

function Clothing.new(settings)
    local self = {
        Roact = require(script.Roact),
        Local = settings.PathToLocal and { unpack(settings.PathToLocal:GetDesendants()) } or assert(false, "Local modules path needed"),
        Shared = settings.PathToLocal and { unpack(settings.PathToShared:GetDesendants()) } or false,
        Packages = settings.PathToPackages and { unpack(settings.PathToPackages:GetDesendants()) } or false,

        _Started = false
    }

    self.Started = function()
        return Promise.new(function(resolve)
            if self._Started then
                resolve()
            else
                repeat
                    runService.Heartbeat:Wait()
                until self._Started == true

                resolve()
            end
        end)
    end

    self.Modules = require(script.Modules).new(self)
    self.Network = require(script.Network).new()

    self._Started = true

    return setmetatable(self, Clothing)
end