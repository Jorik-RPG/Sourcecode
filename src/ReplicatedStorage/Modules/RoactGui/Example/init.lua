--@@ Author Trix

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local function greetPlayer(player)
    return Roact.CreateElement("ScreenGui", {}, {
        TextLabel = Roact.CreateElement("TextLabel", {
            Size = UDim2.fromOffset(400, 300),
            Text = ("Hello %s"):format(player.Name) -- hello trix
        })
    })
end

return function(framework)
    local Roact = framework.Roact

    local example = greetPlayer(Player)

    Roact.mount(example, Player.PlayerGui)

    print("Created :)))")
end