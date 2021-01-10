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
                until self._Started

                resolve()
            end
        end)
    end

    return setmetatable(self, Clothing)
end

--[[ Local module methods ]]

---@param moduleName string
---@return table
function Clothing:GetLocal(moduleName)
    local generatedString = httpService:GenerateUUID(false)
    local moduleFound = nil

    for _, module in ipairs(self.Local) do
        if module.Name == moduleName then
            module.Name = generatedString

            moduleFound = module
        end
    end

    if moduleFound then
        for _, module in ipairs(self.Local) do
            if module.Name == moduleName then
                assert(false, "Double instances of module names (Local modules)")
            end
        end

        moduleFound.Name = moduleName

        return require(moduleFound)
    end

    assert(false, ("Couldn't find module with name %s"):format(moduleName))
end

---@return table
function Clothing:GetAllLocal(limit)
    limit = limit or 0

    if #self.Local > 0 then
        local returnTable = {}

        for _, module in ipairs(self.Local) do
            if module:IsA("Module") then
                returnTable[#returnTable + 1] = module
            end

            if limit == #returnTable and limit > 0 then
                break
            end
        end

        return returnTable
    else
        assert(false, "No modules are registered in local path")
    end
end

--[[ Shared module methods ]]

---@param moduleName string
---@return table
function Clothing:GetShared(moduleName)
    if self.Shared == false then
        assert(false, "No shared path was given in the constructor")
    end

    local generatedString = httpService:GenerateUUID(false)
    local moduleFound = nil

    for _, module in ipairs(self.Shared) do
        if module.Name == moduleName then
            module.Name = generatedString

            moduleFound = module
        end
    end

    if moduleFound then
        for _, module in ipairs(self.Shared) do
            if module.Name == moduleName then
                assert(false, "Double instances of module names (Local modules)")
            end
        end

        moduleFound.Name = moduleName

        return require(moduleFound)
    end

    assert(false, ("Couldn't find module with name %s"):format(moduleName))
end

---@return table
function Clothing:GetAllLocal(limit)
    limit = limit or 0

    if #self.Local > 0 then
        local returnTable = {}

        for _, module in ipairs(self.Local) do
            if module:IsA("Module") then
                returnTable[#returnTable + 1] = module
            end

            if limit == #returnTable and limit > 0 then
                break
            end
        end

        return returnTable
    else
        assert(false, "No modules are registered in local path")
    end
end