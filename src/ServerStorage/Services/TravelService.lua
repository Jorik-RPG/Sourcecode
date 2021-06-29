--@@ Author Trix

-- Services
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)

local MetaService
local Console

--
local Travel = Knit.CreateService{
	Name = "TravelService";	
	Client = {};
} do

	function Travel:TravelLocation(player, destBaseId)
		local base = MetaService:Get(destBaseId)
		
		print(player, destBaseId)
		
		if not base then Console:Warn("Failed to travel missing place file") return end
		
		--
		if not base.PlaceId then Console:Warn("Failed to travel missing place id") return end
		base.Name = base.Name or "Default name"
		
		--
		local s, e = pcall(function()
			TeleportService:Teleport(base.PlaceId, player)
		end)
		
		--
		if not s then Console:Warn("Failed to travel " .. e) return end

		return
	end
	
	--
	function Travel:KnitStart()
		
		MetaService = Knit.GetService("MetaService")
		Console = Knit.SharedModules.Console.new("service/travelservice")
		
	end
	
	function Travel:KnitInit()
	end
	
	Travel.Client.RequestTravel = Travel.TravelLocation
end

return Travel