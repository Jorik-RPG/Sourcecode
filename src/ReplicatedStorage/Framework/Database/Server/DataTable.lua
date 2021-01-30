--@@ Author Trix

local DataTable = {}
DataTable.ClassName = "DataTable"
DataTable.__index = DataTable

-- Services
local Players = game:GetService("Players")

--[[ Public constructor ]]

function DataTable.new(framework)
    local Modules = framework.Modules.new(framework)
    local ProfileService = Modules:GetPackage("ProfileService")

    local SlotData = Modules:GetLocal("SlotData")
    local ErrorCodes = Modules:GetLocal("ErrorCodes")

    local self = setmetatable(framework, DataTable)

    self.Console = self.Console.new(script)
    self.ErrorCodes = ErrorCodes["DataErrors"]
    self.SlotDefaults = SlotData
    self.Profiles = {}
    self.ProfileStore = ProfileService.GetProfileStore("ProfileData", {})
end

function DataTable:CreateProfileSlot(player)
    for i=1, 3 do
        local profile = self:LoadProfile(player)

        if not profile then break end

        local slot = profile.Data[i]

        if not slot then
            table.insert(profile.Data, i, self.SlotDefaults)

            break
        else
           continue
        end
    end
end

function DataTable:LoadProfile(player)
    if not self.Profiles[player.UserId] then
        local profile = self.ProfileStore:LoadProfileAsync(("Player_%s"):format(player.UserId), "ForceLoad")

        if profile then
            profile:Reconcile()

            -- Profile could've been loaded somewhere else
            profile:ListenToRelease(function()
                self.Profiles[player.UserId] = nil

                player:Kick(("Error: %s \n Code: %s"):format(self.ErrorCode[002], 002))
            end)

            if player:IsDescendantOf(Players) then
                self.Profiles[player.UserId] = profile

                self.Console:Print(("Created [%s] profile"):format(player.UserId))
            else
                profile:Release()
            end
        else
            player:Kick(("Error: %s \n Code: %s"):format(self.ErrorCode[001], 001))
        end
    end

    return self.Profiles[player.UserId]
end

function DataTable:SaveProfile(player)
    if not self.Profiles[player.UserId] then return { Success = false, Error = "Profile is non existent" } end

    
end

return DataTable