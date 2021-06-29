local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Libs").Knit)

local DataController = Knit.CreateController { Name = "DataController" }


local LocalPlayer = Players.LocalPlayer


local function ModifyPathToGetSlotData(path : table)
	if path[1] == "SlotData" then
		path[1] = "Slots"
		table.insert(path, 2, ((DataController:GetValue({"CurrentSlot"}) > 0) and DataController:GetValue({"CurrentSlot"}) ) or 1) 
	end
	return path
end


function DataController:Initialize()
	local ReplicaController = Knit.GetController("ReplicaController")

	ReplicaController.ReplicaOfClassCreated("PlayerData", function(replica)
		self._playerDataReplica = replica
		CollectionService:AddTag(LocalPlayer, "ReceivedData")
	end)
end

function DataController:ListenToValueChanged(path, listener)
	path = ModifyPathToGetSlotData(path)
	return self._playerDataReplica:ListenToChange(path, listener)
end

function DataController:ListenToElementAdded(path, listener)
	path = ModifyPathToGetSlotData(path)
	return self._playerDataReplica:ListenToArrayInsert(path, listener)
end

function DataController:ListenToElementRemoved(path, listener)
	path = ModifyPathToGetSlotData(path)
	return self._playerDataReplica:ListenToArrayRemove(path, listener)
end

function DataController:GetValue(path)
	path = ModifyPathToGetSlotData(path)
	return self._playerDataReplica:GetValue(path)
end

return DataController