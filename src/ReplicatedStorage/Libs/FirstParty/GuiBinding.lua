--@@ Author Trix

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

--
local hoverSound = Instance.new("Sound")
hoverSound.SoundId = "rbxassetid://3728445645"

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://3728446188"

--
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

--
local effectGui = Instance.new("ScreenGui")
effectGui.Name = "Effects"
effectGui.ResetOnSpawn = false
effectGui.IgnoreGuiInset = true
effectGui.DisplayOrder = 999999999
effectGui.Parent = playerGui

local hoverTextContainer = Instance.new("ScreenGui")
hoverTextContainer.Name = "HoverTextContainer"
hoverTextContainer.DisplayOrder = 1000
hoverTextContainer.IgnoreGuiInset = true
hoverTextContainer.Parent = playerGui

local clickCircle = Instance.new("Frame")
clickCircle.BackgroundTransparency = .5
clickCircle.BackgroundColor3 = Color3.new(1, 1, 1)
clickCircle.Size = UDim2.new(0, 1, 0, 1)
clickCircle.Parent = playerGui

--
local hoverDebounce = false

--
local function lerp(a, b, t)
	return a + (b - a) * t
end

--
local bindings = {
	HoverSound = function(guiObject)
		return guiObject.MouseEnter:Connect(function()
			if not hoverDebounce then
				hoverDebounce = true
				
				--
				hoverSound.Volume = 0.5
				SoundService:PlayLocalSound(hoverSound)
				
				--
				delay(hoverSound.TimeLength + 0.25, function()
					hoverDebounce = false
				end)
			end
		end)
	end,

	ClickSound = function(guiObject)
		assert(guiObject:IsA("GuiButton"), "Invalid type for the 'guiObject' argument; a GuiButton instance is expected")
		
		return guiObject.MouseButton1Down:Connect(function()
			clickSound.Volume = 0.5
			
			SoundService:PlayLocalSound(clickSound)
		end)
	end,

	ClickParticles = function(guiObject)
		assert(guiObject:IsA("GuiButton"), "Invalid type for the 'guiObject' argument; a GuiButton instance is expected")
		
		return guiObject.MouseButton1Down:Connect(function() -- todo: refactor
			local frames = 10
			
			for _i = 1, frames do
				local frame = Instance.new("Frame")
				frame.ZIndex = 10
				frame.Rotation = math.random(-45,45)
				frame.BorderSizePixel = 0
				frame.Size = UDim2.new(0,5,0,5)
				frame.BackgroundColor3 = Color3.new(math.random(50, 100) / 100, math.random(20, 60) / 100, 0)
				frame.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
				frame.Parent = effectGui
				
				local vel
				repeat
					vel = Vector2.new(math.random(-30, 30) / 10, -math.random(-20, 100) / 25)
				until vel.X > 1 or vel.X < -1
				
				coroutine.wrap(function()
					for _i = 1, 40 do 
						RunService.RenderStepped:wait()

						vel = vel + Vector2.new(vel.X > 0 and -0.01 or 0.01, 0.2)
						frame.Position = frame.Position + UDim2.new(0, vel.X, 0, vel.Y)
						frame.BackgroundTransparency = frame.BackgroundTransparency + 0.02

					end
					
					frame:Destroy()
				end)()
			end
		end)
	end,
	
	ClickEffect = function(guiObject)
		assert(guiObject:IsA("GuiButton"), "Invalid type for the 'guiObject' argument; a GuiButton instance is expected")
		
		guiObject.ClipsDescendants = true
		
		return guiObject.MouseButton1Down:Connect(function(x, y)		
			local newClickImage = clickCircle:Clone()
			newClickImage.Parent = guiObject
			newClickImage.Name = "Newclick"
			newClickImage.Position = UDim2.new(0, 0, 0, 0)
			newClickImage.Size = UDim2.fromScale(0, 1)			
			newClickImage.ZIndex = 10
			
			local tweenInfo = TweenInfo.new(.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local tween = TweenService:Create(newClickImage, tweenInfo, { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
			tween:Play()
			tween.Completed:Wait()
			
			newClickImage:Destroy()
		end)
	end,
	
	HoverText = function(guiObject, text)
		if not guiObject.Parent then
			return
		end

		local OFFSET = Vector2.new(0, -6)

		local label = Instance.new("TextLabel")
		label.Name = guiObject.Name .. "'s Hover Text"
		label.Font = Enum.Font.GothamBold
		label.TextSize = 30
		label.TextColor3 = Color3.fromRGB(227, 192, 85)
		label.TextStrokeColor3 = Color3.fromRGB(84, 70, 58)
		label.TextStrokeTransparency = 0
		label.TextYAlignment = Enum.TextYAlignment.Bottom
		label.Size = UDim2.new(0, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.ZIndex = 100
		label.Parent = hoverTextContainer

		label.Visible = false

		local currentElement = guiObject

		local connections = {}

		while currentElement do
			if currentElement:IsA("GuiObject") then
				connections["ParentGuiVisible "..currentElement.Name] = currentElement:GetPropertyChangedSignal("Visible"):Connect(function()
					label.Visible = false
				end)
			end

			if currentElement.Parent:IsA("GuiObject") or currentElement.Parent:IsA("Folder") then
				currentElement = currentElement.Parent
			else
				currentElement = nil
			end
		end

		guiObject.MouseEnter:Connect(function()
			label.Visible = true
		end)
		
		guiObject.MouseMoved:Connect(function()
			local mouseLocation = UserInputService:GetMouseLocation()
			local screenSize = workspace.CurrentCamera.ViewportSize
			
			if mouseLocation.X > screenSize.X * 0.5 then
				label.TextXAlignment = Enum.TextXAlignment.Right
			else
				label.TextXAlignment = Enum.TextXAlignment.Left
			end
			
			label.Position = UDim2.new(0, mouseLocation.X + OFFSET.X, 0, mouseLocation.Y + OFFSET.Y)
		end)
		
		guiObject.MouseLeave:Connect(function()
			label.Visible = false
		end)
	end,
}


local GuiBinding = {} do
	function GuiBinding.Bind(guiObject, name, ...)
		assert(typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject"), "Invalid type for the 'guiObject' argument; a GuiObject instance is expected")
		assert(type(name) == "string", "Invalid type for the 'name' argument; a string is expected")
		
		local bindFunction = assert(bindings[name], "Could not find GuiBinding named '" .. name .. "' ")
		
		return bindFunction(guiObject, ...)
	end
end


return GuiBinding