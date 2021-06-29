--@@ Author Trix

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs"):WaitForChild("Knit"))

--
local sharedServices = ReplicatedStorage:WaitForChild("SharedServices")
local serverServices = ServerStorage:WaitForChild("Services")

--
Knit.SharedModules = {}
Knit.GlobalSettings = {
	Testing = false;
	CanLoad = true;
}

--
Knit.AddServices(serverServices)

--		
for _, sharedModule in ipairs(sharedServices:GetChildren()) do
	if sharedModule:IsA("ModuleScript") then
		
		local success, result = pcall(function()
			return require(sharedModule)
		end)
		
		if not success or type(result) ~= "table" then warn("Failed to bind " .. sharedModule.Name .. ": " .. (type(result) ~= "table" and success) and "result is not a table" or result); continue end
		
		Knit.SharedModules[result.Name] = result
	end
end

--
if RunService:IsStudio() then warn("Enabling global test mode"); Knit.GlobalSettings.Testing = true end

--
Knit.SharedModules.AssetLibrary.GetAsset("Others.StarterCharacter"):Clone().Parent = game:GetService("StarterPlayer")

--
Knit.Start():Catch(error)

--
local DataService = Knit.GetService("DataService")

for _, player in ipairs(Players:GetPlayers()) do
	DataService:InitializePlayer(player)
end

Players.PlayerAdded:Connect(function(player)
	DataService:InitializePlayer(player)
end)

--
local Console = Knit.SharedModules.Console.new("serverscript/servermain")

Console:Warn("Server loaded (".. game.JobId .. (game.PlaceVersion or "null") ..") 🚀")