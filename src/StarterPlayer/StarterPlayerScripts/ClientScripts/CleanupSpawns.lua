--@@ Author Trix

--
local spawnFolder = workspace:WaitForChild("Spawns", 15) or error("No spawn folder cancelling cleanup")

--
for _, obj in ipairs(spawnFolder:GetDescendants()) do
	
	if obj:IsA("Part") and obj:FindFirstChildWhichIsA("SelectionBox") then
		obj:FindFirstChildWhichIsA("SelectionBox"):Destroy()
	end
	
end

return true