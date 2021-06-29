--@@ Author Trix

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)

local DataService
local MetaService

--
local spawnGroupParts = workspace:WaitForChild("Spawns", 15):WaitForChild("Player", 15) and workspace.Spawns.Player:GetChildren() or { Instance.new("Part") }

--
local Character = Knit.CreateService{
	Name = "CharacterService";
	Client = {};
} do
	
	local function RequestSpawn()
		return Knit.GlobalSettings.CanLoad
	end
	
	local function RemoveApperance(player)
		local character = player.Character
		
		for _, obj in ipairs(character:GetDescendants()) do
			if not obj:IsA("Accessory") or not obj:IsA("Shirt") or not obj:IsA("Pants") or not obj:IsA("Decal") or not obj:IsA("BodyColors") then continue end
			
			obj:Destory()
		end
	end
	
	--
	function Character:LoadApperance(player)
		
		RemoveApperance(player)
		
		local outfit = DataService:GetValue(player, { "SlotData", "CharacterAppearance", "Outfit" })
		
		outfit = MetaService:Get(outfit)
		
		--
		local shirtInstance = Instance.new("Shirt")
		local pantInstance = Instance.new("Pants")
		
		shirtInstance.ShirtTemplate = "rbxassetid://" .. outfit.ShirtId
		pantInstance.PantsTemplate = "rbxassetid://" .. outfit.PantId
		
		shirtInstance.Name = outfit.Name
		pantInstance.Name = outfit.Name
		
		shirtInstance.Parent = player.Character
		pantInstance.Parent = player.Character
		
		ContentProvider:PreloadAsync({ shirtInstance, pantInstance })
		
		--
		
		
	end
	
	function Character:Load(player)
		assert(player)
	
		if RequestSpawn() then		
			
			local spawnArea = spawnGroupParts[#spawnGroupParts > 1 and math.random(1, #spawnGroupParts) or 1]
			
			if workspace.StreamingEnabled then player:RequestStreamAroundAsync(spawnArea.Position, 15) end
			
			--
			player:LoadCharacter()
			
			--
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			
			self:LoadApperance(player)
			
			--
			character:SetPrimaryPartCFrame(spawnArea.CFrame * CFrame.new(math.random(1, 4), 2, math.random(1, 4)))
		end
		
	end
	
	function Character:UnLoad(player)
		
		player.Character = nil
		
	end
	
	function Character:LoadAll()
		
	end
	
	function Character:TakeDamage(player)
		
	end
	
	--
	Character.Client.RequestLoad = function(_, player)
		Character:Load(player)
	end
		
	--
	function Character:KnitStart()
		
		DataService = Knit.GetService("DataService")
		MetaService = Knit.GetService("MetaService")
		
	end
	
	function Character:KnitInit()
	end
	
end

return Character