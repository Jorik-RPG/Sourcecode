
local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Libs").Knit)

local Run = function()
	
	local MetaController = Knit.GetController("MetaController")
	local AudioController = Knit.GetController("AudioController")
	
	local audioPlaylist = MetaController:Get("Audio_" .. tostring(game.PlaceId))
	
	if not audioPlaylist then
		audioPlaylist = MetaController:Get("Audio_0")
	end
	
	local loadedAudios = {}
	
	print(audioPlaylist)
	
	for _, audioId in ipairs(audioPlaylist) do
		loadedAudios[#loadedAudios + 1] = AudioController.new(audioId)
	end
	
	print(loadedAudios)
	
	--
	while true do
		local audio = loadedAudios[math.random(1, #loadedAudios)].Sound

		audio:Play()

		wait(audio.TimeLength)

		audio:Stop()
	end
end

coroutine.wrap(Run)()

return true