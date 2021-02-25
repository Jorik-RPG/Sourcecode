--@@ Author Trix; Modified by 4thAxis

local Framework = {}
Framework.__index   = Framework
Framework.ClassName = "Framework"

-- Services
local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")

-- Modules
local Promise = require(script.Parent.Packages.Promise)

--[[
    {
        PathToLocal = "Folder",
        PathToShared = "Folder" or nil,
        PathToPackages = "Folder" or nil
    }
]]
function Framework.new(settings)
    settings = settings or error("Framework.new: Didn't provide settings argument")

    local self = setmetatable({
        Roact    = require(script.Parent.Packages.Roact),
        Local    = ( settings.PathToLocal    and settings.PathToLocal:GetDescendants() )    or error("Local modules path needed"),
        Shared   = ( settings.PathToShared   and settings.PathToShared:GetDescendants() )   or false,
        Packages = ( settings.PathToPackages and settings.PathToPackages:GetDescendants() ) or false,

        _Started = false
    }, Framework)

    self.Started = function()
        return Promise.fromEvent(RunService.PreRender, function(resolve)
            return self._Started
        end)
    end

    -- Referenced built in modules
    self.Console  = require(script:WaitForChild("Console"))
    self.Modules  = require(script:WaitForChild("Modules"))
    self.Network  = require(script:WaitForChild("Network")).new(self)
    self.Database = require(script:WaitForChild("Database")).new(self)

    self._Started = true

    return self
end

return Framework