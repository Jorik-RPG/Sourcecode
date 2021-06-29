--[[
	This module is used to insert your game. Feel free to edit it below to fit your needs.
	
	Game Module maker can operate in two modes:
		InsertService
			If the module is named "GameModule", then your game can be loaded and ran via InsertService. This is the most
			secure option because it has no possibility of exposing your server code to a third party, but it can only work
			with models that are uploaded to the same owner as the game you are inserting them into.
			
			In all places that will receive this game's code, make a single script in ServerScriptService with the source:
				require(game:GetService("InsertService"):LoadAsset(12345).GameModule) -- Where 12345 is your model's asset ID
				
		Private Modules
			If the module is named "MainModule", then it is compatible with private modules which can be loaded in any game,
			even if this module isn't published under the same owner as the game it is loaded in. However, it is less secure.
			Ensure that you enable the extra precautions that are commented out below to lessen the chance of leaking code.  
			Scripts that error can be gotten ahold of with ScriptContext.Error. Use pcall!
			
			In all places that will receive this game's code, make a single script in ServerScriptService with the source:
				require(12345) -- Where 12345 is your model's asset ID
]]

local Children = script:GetChildren()
local StarterPlayer = game:GetService("StarterPlayer")
local ServerScriptService = game:GetService("ServerScriptService")


-- Insert the full game into this place

for _, child in ipairs(Children) do
	if child.Name ~= "ServerScriptService" then
		local service
		if game:GetService(child.Name) then
			service = game:GetService(child.Name)
		elseif StarterPlayer:FindFirstChild(child.Name) then
			service = StarterPlayer[child.Name]
		end

		if service then
			for _, child in ipairs(child:GetChildren()) do
				child.Parent = service
			end
		end
	end
end

for i,v in ipairs(script.ServerScriptService:GetChildren()) do
	--if v.Name ~= "ServerMain" and v.Name ~= "EnsureReplication" and v.Name ~= "BetterEnsureReplication" then
	--	v.Parent = ServerScriptService
	--end
	
	v.Parent = ServerScriptService
end
--script.ServerScriptService.ServerMain.Parent = ServerScriptService
--script.ServerScriptService.BetterEnsureReplication.Parent = ServerScriptService

wait()

_G.FinishedLoading = true

return nil
--end