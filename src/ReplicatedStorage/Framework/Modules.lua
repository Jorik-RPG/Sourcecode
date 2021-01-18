--@@ Author Trix

local Modules = {}
Modules.__index = Modules
Modules.ClassName = "Modules"

-- Services
local httpService = game:GetService("HttpService")

--[[ constructor ]]

---@param self table
---@return table
function Modules.new(self)
    return setmetatable(self, Modules)
end

--[[ Local module methods ]]

---@param moduleName string
---@return table
function Modules:GetLocal(moduleName)
    local generatedString = httpService:GenerateGUID(false)
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
function Modules:GetAllLocal(limit)
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
function Modules:GetShared(moduleName)
    if self.Shared == false then
        assert(false, "No shared path was given in the constructor")
    end

    local generatedString = httpService:GenerateGUID(false)
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
                assert(false, "Double instances of module names (Shared modules)")
            end
        end

        moduleFound.Name = moduleName

        return require(moduleFound)
    end

    assert(false, ("Couldn't find module with name %s"):format(moduleName))
end

---@return table
function Modules:GetAllShared(limit)
    limit = limit or 0

    if #self.Shared > 0 then
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
        assert(false, "No modules are registered in shared path")
    end
end

return Modules