--@@ Author Trix

local SlotHandle = {}
SlotHandle.ClassName = "SlotHandle"
SlotHandle.__index = SlotHandle

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--[[ Public constructor ]]

function SlotHandle.new(framework)
    local Modules = framework.Modules.new(framework)
    local ProfileService = Modules:GetPackage("ProfileService")

    local SlotData = Modules:GetLocal("SlotData")
    local ErrorCodes = Modules:GetLocal("ErrorCodes")

    local self = setmetatable(framework, SlotHandle)

    self.Console = self.Console.new(script)
    self.ErrorCodes = ErrorCodes["DataErrors"]
    self.SlotDefaults = SlotData
    self.Profiles = {}
    self.ProfileStore = ProfileService.GetProfileStore("ProfileData", {})
end

function SlotHandle:CreateProfileSlot(player, callback)
    for i=1, 3 do
        local profile = self:LoadProfile(player)

        if not profile then break end

        local slot = profile.Data[i]

        if not slot then
            table.insert(profile.Data, i, self.SlotDefaults)

            profile.Data[i].Hash = HttpService:GenerateGUID()

            callback{ Success = true }

            break
        else
           continue
        end
    end

    callback{ Success = false, Error = "No slots free to overwrite." } return
end

function SlotHandle:DeleteProfileSlot(player, slotHash, callback)
    console:Assert(slotHash, "Missing paramater 'SlotNumber'")

    local profile = self.Profiles[player.UserId] or self:LoadProfile(player)

    if type(slotHash) == "number" then
        if profile.Data[slotHash] then
            table.remove(profile.Data, slotHash)

            callback{ Success = true } return
        end
    elseif type(slotHash) == "string" then
        for i=1, #profile.Data do
            if profile.Data[i].Hash == slotHash then
                table.remove(profile.Data, i)

                callback{ Success = true } return
            end
        end
    end

    callback{ Success = false, Error = "Slot data doesn't exist." } return
end

function SlotHandle:LoadProfile(player, callback)
    if not self.Profiles[player.UserId] then
        local profile = self.ProfileStore:LoadProfileAsync(("Player_%s"):format(player.UserId), "ForceLoad")

        if profile then
            profile:Reconcile()

            profile:AddMetaTag("Data-1")

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

    callback{ Success = true, Data = self.Profiles[player.UserId] } return
end

function SlotHandle:SaveProfile(player, forcesave, callback)
    local profile = self.Profiles[player.UserId]

    if not profile then callback{ Success = false, Error = "Profile is non existent" } return end

    if profile.Data.LastSaved and profile.Data.LastSaved - DateTime.now() then
        profile.Data.LastSaved = DateTime.now()

        profile:Save()
    elseif forcesave then
        profile.Data.LastSaved = DateTime.now()

        profile:Save()
    elseif not profile.LastSaved then
        profile.Data.LastSaved = DateTime.now()

        profile:Save()
    end
end

return SlotHandle