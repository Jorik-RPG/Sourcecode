--@@ Author Trix

local BAR_TWEEN = TweenInfo.new(1, Enum.EasingStyle.Linear)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")

local container = script.Parent:WaitForChild("Container")

local characterHeadshot = container:WaitForChild("CharacterHeadshot")

local healthFrame = container:WaitForChild("HealthFrame")
local magicFrame = container:WaitForChild("MagicFrame")
local staminaFrame = container:WaitForChild("StaminaFrame")

--
local lastHealth = 0

--		
local function int(current, target)
	current, target = math.floor(current), math.floor(target)
	
	return current + math.sign(target - current) * (10 ^ math.max(math.floor(math.log10(math.abs(target - current))) - 1, 0))
end

local function ChangeHealthBar(min, max)
	
	local start = lastHealth
	local finish = min
		
	local n = start
		
	while (n ~= finish) do
		n = int(n, finish)
			
		healthFrame.Frame.Label.Text = "HP " .. n .. " / " .. finish
		
		local tween = TweenService:Create(healthFrame.Frame.Fill, BAR_TWEEN, { Size = UDim2.fromScale(n/max, 1) })
		tween:Play()
		
		game["Run Service"].Stepped:Wait()
	end	
	

	
	lastHealth = min
end

--
humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	ChangeHealthBar(humanoid.Health, humanoid.MaxHealth)
end)

humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
	ChangeHealthBar(humanoid.Health, humanoid.MaxHealth)
end)

ChangeHealthBar(humanoid.Health, humanoid.MaxHealth)

--
local thumbnail = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)

characterHeadshot.ImageLabel.Image = thumbnail