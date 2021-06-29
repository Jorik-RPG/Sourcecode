local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Libs").Knit)

local DataService = Knit.CreateService {
	Name = "DataService";
	Client = {};
}


local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local DefaultData = require(script.DefaultData)
local ProfileService = require(script.ProfileService)
local Maid = require(Knit.Util.Maid)

local Maids = {}
local Profiles = {}
local Replicas = {}
local ProfileStore
local ReplicaService
local ReplicaClassToken

local DATA_KEY = DefaultData.DatastoreKey
local DEFAULT_DATA = DefaultData.RawData
local DEFAULT_SLOT_DATA = DefaultData.SlotData


--
local function GetPlayerId(player: number | Player)
	if typeof(player) == "number" then return player end

	return player.UserId
end

local function GetPlayerInstance(player: number | Player)
	if typeof(player) == "Instance" then return player end

	return Players:GetPlayerByUserId(player)
end

local function GetPlayerMaid(player)
	local playerKey = GetPlayerId(player)
	local maid = Maids[playerKey]

	return maid
end

local function CreatePlayerMaid(player)
	local playerKey = GetPlayerId(player)

	local playerMaid = Maid.new()
	Maids[playerKey] = playerMaid
	return true
end

local function DestroyPlayerMaid(player)
	local playerKey = GetPlayerId(player)

	local playerMaid = Maids[playerKey]
	if not playerMaid then return false end

	playerMaid:Destroy()
	Maids[playerKey] = nil

	return true
end

local function GetReplica(player)
	local playerKey = GetPlayerId(player)
	local replica = Replicas[playerKey]
	return replica
end

local function ClearProfileCache(player)
	local playerKey = GetPlayerId(player)

	Profiles[playerKey] = nil
end

local function GetPlayerProfile(player)
	local playerKey = GetPlayerId(player)
	local profile = Profiles[playerKey]

	return profile
end

local function LoadPlayerProfile(player)
	local playerKey = GetPlayerId(player)

	local profile = ProfileStore:LoadProfileAsync(
		"Player_" .. playerKey,
		"ForceLoad"
	)

	if profile == nil then return false end

	profile:Reconcile()

	Profiles[player] = profile

	return profile
end

local function UnloadPlayerProfile(player)
	local profile = GetPlayerProfile(player)
	if profile ~= nil then
		profile:Release()
	end
end

local function LoadDataForUser(player)

	CreatePlayerMaid(player)
	local profile = LoadPlayerProfile(player)

	if not profile then return false end

	profile:ListenToRelease(function()
		ClearProfileCache(player)
	end)

	return profile
end

local function RemovePlayerReplica(player)
	local playerKey = GetPlayerId(player)

	Replicas[playerKey] = nil
end

local function ClearDataForUser(player)
	DestroyPlayerMaid(player)
	RemovePlayerReplica(player)
	UnloadPlayerProfile(player)
end

local function PlayerIsReady(player, profile)
	local playerInstance = GetPlayerInstance(player)

	if not playerInstance:IsDescendantOf(Players) then
		UnloadPlayerProfile(player)
		return false
	elseif profile == nil then
		player:Kick("Data was unable to be loaded")
		return false
	end

	return true
end

local function SetUpReplica(player, profile)
	local playerKey = GetPlayerId(player)

	local playerDataReplica = ReplicaService.NewReplica({
		ClassToken = ReplicaClassToken,
		Tags = {playerKey},
		Data = profile.Data,
		Replication = player
	})

	Replicas[playerKey] = playerDataReplica
	GetPlayerMaid(player):GiveTask(playerDataReplica)
end

local function OnPlayerAdded(player)
	local profile = LoadDataForUser(player)
	if PlayerIsReady(player, profile) then
		SetUpReplica(player, profile)
	end
	CollectionService:AddTag(player, "Loaded")
end

local function OnPlayerRemoving(player)
	ClearDataForUser(player)
end

local function ModifyPathToGetSlotData(player : Player, path : table)
	if #path > 0 and path[1] == "SlotData" then
		path[1] = "Slots"
		table.insert(path, 2, DataService:GetValue(player, {"CurrentSlot"}) > 0 or 1)
	end
	return path
end

--
function DataService:GetValue(player, path)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	return replica:GetValue(path)
end

function DataService:SetValue(player, path, value)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	return replica:SetValue(path, value)
end

function DataService:InsertElement(player, path, value)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	return replica:ArrayInsert(path, value)
end

function DataService:RemoveElement(player, path, index)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	return replica:ArrayRemove(path, index)
end

function DataService:IncrementValue(player, path, amount)
	local current = DataService:GetValue(player, path)
	if not current then return end

	assert(typeof(current) == "number", "Cannot increment a non-number")

	local newValue = current + amount
	return DataService:SetValue(player, path, newValue)
end

function DataService:ListenToValueChanged(player, path, listener)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	local playerMaid = GetPlayerMaid(player)
	if not playerMaid then return end

	local connection = replica:ListenToChange(path, listener)
	playerMaid:GiveTask(connection)

	return connection
end

function DataService:ListenToElementAdded(player, path, listener)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	local playerMaid = GetPlayerMaid(player)
	if not playerMaid then return end

	local connection = replica:ListenToArrayInsert(path, listener)
	playerMaid:GiveTask(connection)

	return connection
end

function DataService:ListenToElementRemoved(player, path, listener)
	local replica = GetReplica(player)
	path = ModifyPathToGetSlotData(player, path)

	local playerMaid = GetPlayerMaid(player)
	if not playerMaid then return end

	local connection = replica:ListenToArrayRemove(path, listener)
	playerMaid:GiveTask(connection)

	return connection
end


function DataService:KnitInit()
	ProfileStore = ProfileService.GetProfileStore(
		DATA_KEY,
		DEFAULT_DATA
	)

	ReplicaService = Knit.GetService("ReplicaService")

	ReplicaClassToken = ReplicaService.NewClassToken("PlayerData")

	Players.PlayerRemoving:Connect(OnPlayerRemoving)
end

function DataService:InitializePlayer(player)
	OnPlayerAdded(player)
end

function DataService:UnloadPlayer(player)
	OnPlayerRemoving(player)
end

local function DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function DataService:CreateSlot(player)
	return DataService:InsertElement(player, {"Slots"}, DeepCopy(DEFAULT_SLOT_DATA))
end

function DataService.Client:CreateSlot(player)
	local currentSlotCount = #(DataService:GetValue(player, {"Slots"}))
	if not (currentSlotCount < DefaultData.NumCharSlots) then return end

	return DataService:CreateSlot(player)
end

function DataService.Client:ChangeSlot(player, newSlot)
	if not typeof(newSlot) == "number" then return end
	if not (newSlot > 0 and newSlot < DefaultData.NumCharSlots) then return end

	return DataService:SetValue(player, {"CurrentSlot"}, newSlot)
end

function DataService:ClearData(player)
	local profile = GetPlayerProfile(player)

	if profile then
		profile:WipeProfileAsync()
		ClearDataForUser(player)
	end
end

return DataService