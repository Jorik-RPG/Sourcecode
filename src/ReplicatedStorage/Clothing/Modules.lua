--@@ Author Trix

local Clothing = {}
Clothing.__index = Clothing
Clothing.ClassName = "ClothingModules"

-- Services
local httpService = game:GetService("HttpService")

--[[ constructor ]]

---@param self table
---@return table
function Clothing.new(self)
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
                assert(false, "Double instances of module names (Shared modules)")
            end
        end

        moduleFound.Name = moduleName

        return require(moduleFound)
    end

    assert(false, ("Couldn't find module with name %s"):format(moduleName))
end

---@return table
function Clothing:GetAllShared(limit)
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