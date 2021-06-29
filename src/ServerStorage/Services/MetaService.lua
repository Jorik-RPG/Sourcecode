--@@ Author TrixRoBX

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)

--
local metaFolder = ReplicatedStorage:WaitForChild("SharedData"):GetDescendants()

--
local MetaService = Knit.CreateService{
	Name = "MetaService";
} do

	for iter, obj in ipairs(metaFolder) do
		local inst = obj
		metaFolder[iter] = nil
		metaFolder[obj.Name] = obj
	end

	function MetaService:Get(key)

		key = string.gsub(key, "_", " ")

		return ((key and metaFolder[key]) and metaFolder[key]:IsA("ModuleScript")) and require(metaFolder[key]) or nil

	end

end

return MetaService