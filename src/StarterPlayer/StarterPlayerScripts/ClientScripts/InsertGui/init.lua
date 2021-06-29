--@@ Author Trix

-- Services
local Players = game:GetService("Players")

--
local player = Players.LocalPlayer

--
local gui = script:GetChildren()

--
for _, obj in ipairs(gui) do
	if obj:IsA("ScreenGui") then
		obj.Parent = player:WaitForChild("PlayerGui") 
	end
end

return true