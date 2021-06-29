local Player = game.Players.LocalPlayer
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
local PlayerScripts = Player:WaitForChild("PlayerScripts")

local Connections = {}

repeat wait(0.1) until game:IsLoaded()

function EnsureReplicated(container, target)
	if Connections[container] == nil then
		Connections[container] = container.ChildAdded:Connect(function()
			EnsureReplicated(container, target)
		end)
	end

	for _, child in ipairs(container:GetChildren()) do
		if target:FindFirstChild(child.Name) == nil and child.Archivable then
			child:Clone().Parent = target
		end
	end
end

EnsureReplicated(StarterPlayerScripts, PlayerScripts)