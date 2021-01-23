--@@ Author Trix

-- Services
local Players = game:GetService("Players")

-- Object references
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local function Setup(framework)
    local Roact = framework.Roact

    local app = Roact.createElement("ScreenGui", {}, {
        ChangeLog = Roact.createElement("Frame", {
            Size = UDim2.fromScale(.2,.4),
            Position = UDim2.fromScale(.8,.2)
        }, {
            HelloWorld = Roact.createElement("TextLabel", {
                Size = UDim2.fromScale(1,1),
                Text = "Hello, Roact!"
            })
        })
    })

    Roact.mount(app, playerGui)
end

return {
    Run = Setup
}