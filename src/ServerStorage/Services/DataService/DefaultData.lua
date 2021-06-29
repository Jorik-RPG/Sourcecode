local Default = {}

Default.DatastoreKey = "U6TlwU9hRa"

Default.SlotData = { -- data isolated to each character
	["Level"] = 1,
	["XP"] = 0,
	["MaxXP"] = 100,
	["Inventory"] = {
		{
			Type = "Sword",
			Name = "Test Sword",
			Equipped = true,
		}
	},
	["Quest"] = {},
	["Coins"] = 0,
	["Kills"] = 0,
	["LastWorld"] = "Game_Menu",
	["CharacterAppearance"] = {
		["Finalized"] = false,
		["Face"] = "Annoyed",
		["SkinTone"] = 2,
		["Hair"] = "Bangs",
		["HairColor"] = "Brown",
		["Outfit"] = "Civil Clothing",
	},
}


Default.SharedData = { -- data that is shared across all character slots
	["Banned"] = false,
	["PremiumCurrency"] = 0,
	["CurrentSlot"] = 0,
	["Gamepasses"] = {},
	["DevProducts"] = {},
	["Settings"] = {
		["ColorScheme"] = "Default",
	},
	["Slots"] = {},
}

Default.NumCharSlots = 4

Default.RawData = {}

function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function BuildRawData()

	for k,v in pairs(Default.SharedData) do
		local value = nil
		if typeof(v) == "table" then
			value = deepCopy(v)
		else
			value = v
		end
		Default.RawData[k] = value
	end

end

BuildRawData()

return Default