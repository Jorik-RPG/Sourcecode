--@@ Author Trix

local SLIDE_FRAME = TweenInfo.new(.3, Enum.EasingStyle.Bounce)

-- Services
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--
--local GuiBind = require(ReplicatedStorage:WaitForChild("Libs"):WaitForChild("FirstParty").GuiBinding)

--
local button = script.Parent

local frame = button.Parent

--
local closed = true
local debounce = false

--
button.MouseButton1Click:Connect(function()
	if debounce then return end
	
	debounce = true
	
	if closed then
		local tween = TweenService:Create(frame, SLIDE_FRAME, { Position = UDim2.fromScale(0.013, 0.239) })
		local tweenButton = TweenService:Create(frame.Button, SLIDE_FRAME, { Position = UDim2.fromScale(0.004, -0.104) })
		
		tween:Play()
		tweenButton:Play()
		
		frame.Button.Text = "< Party"
		
		closed = false
	else
		local tween = TweenService:Create(frame, SLIDE_FRAME, { Position = UDim2.fromScale(-0.4, 0.239) })
		local tweenButton = TweenService:Create(frame.Button, SLIDE_FRAME, { Position = UDim2.fromScale(1.595, -0.104) })
		
		tween:Play()
		tweenButton:Play()
		
		frame.Button.Text = "> Party"
		
		closed = true
	end
	
	wait(.1)
	debounce = false
end)