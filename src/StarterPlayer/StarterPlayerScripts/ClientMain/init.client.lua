--@@ Author Trix

if not game:IsLoaded() then game.Loaded:Wait() end

print("Loaded")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)
local Loader = require(Knit.Util.Loader)
local Thread = require(Knit.Util.Thread)
local Component = require(Knit.Util.Component)

--
local player = Players.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local sharedServices = ReplicatedStorage:WaitForChild("SharedServices")

--
Knit.SharedModules = {}

Knit.AddControllers(ReplicatedStorage.Controllers)

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
repeat wait(); until CollectionService:HasTag(player, "Loaded")

--
Knit.Start():Catch(warn)

--
for _, module in ipairs(playerScripts:WaitForChild("ClientScripts"):GetChildren()) do
	if module:IsA("ModuleScript") then
		
		Thread.Spawn(function()
			require(module)
		end)
		
	end
end

--
local CharacterService = Knit.GetService("CharacterService")
local Console = Knit.SharedModules.Console.new("player/clientmain")
local DataController = Knit.GetController("DataController")
local DataService = Knit.GetService("DataService")
local ReplicaController = Knit.GetController("ReplicaController")

--
DataController:Initialize()
ReplicaController.RequestData()

if not CollectionService:HasTag(player, "ReceivedData") then
	CollectionService:GetInstanceAddedSignal("ReceivedData"):Wait()
end

--
local slotTable = DataController:GetValue({"Slots"})

if #slotTable < 1 then DataService:CreateSlot(player, 1) end

--
CharacterService.RequestLoad(player)

if game.PlaceId == 5618351453 then
	require(script.MainMenu)()

	Console:Log("Menu loaded")

	Console:Warn("Client loaded (".. player.UserId ..") 🚀")

	return
end

Console:Warn("Client loaded (".. player.UserId ..") 🚀")