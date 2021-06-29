--@@ Author TrixRoBX

-- Services
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)

--
local AudioController = Knit.CreateController{
	Name = "AudioController";
} do
	
	function AudioController.new(soundId, volume, looped)
		
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. soundId
		sound.Looped = looped or false
		sound.Volume = volume or 1.5
		sound.Parent = SoundService
		
		ContentProvider:PreloadAsync({ sound })
		
		return setmetatable({
			
			Sound = sound
			
		}, AudioController)
		
	end
	
	function AudioController:Play()
		
		self.Sound:Play()
		
	end
	
	function AudioController:Stop()
		
		self.Sound:Stop()
		
	end
	
	function AudioController:Repeat()
		
		self.Sound.Looped = true
		
		self:Play()

	end
	
	function AudioController:Destroy()
		
		self.Sound:Destroy()
		
	end
	

end

return AudioController