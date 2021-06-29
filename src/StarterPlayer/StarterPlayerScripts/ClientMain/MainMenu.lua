--@@ Author Trix

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--
local Knit = require(ReplicatedStorage:WaitForChild("Libs").Knit)

Knit.OnStart():await()

--
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")

local currentCamera = workspace.CurrentCamera

local cameraPart = workspace:WaitForChild("MenuCamera")

--
return function()
	currentCamera.CFrame = cameraPart.CFrame

	shared.Menu = true

	wait(.4)

	local TravelModule = Knit.GetService("TravelService")
	local DataController = Knit.GetController("DataController")
	
	require(playerModule):GetControls():Disable()

	RunService.RenderStepped:Connect(function()
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default

		local viewPort = workspace.CurrentCamera.ViewportSize
		local X = math.clamp((mouse.X - (viewPort.X / 2)) / viewPort.X, -.5, .5)
		local Y = math.clamp((mouse.Y - (viewPort.Y / 2)) / viewPort.Y, -.5, .5)

		currentCamera.CFrame = cameraPart.CFrame * CFrame.Angles(math.rad(-Y * 4), math.rad(-X * 4), math.rad(0))		
	end)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.Parent = ScreenGui

	local TextButton = Instance.new("TextButton")
	TextButton.Size = UDim2.new(0.3019446, 0, 0.1056181, 0)
	TextButton.BackgroundTransparency = 0.35
	TextButton.Position = UDim2.new(0.3489583, 0, 0.8490115, 0)
	TextButton.BackgroundColor3 = Color3.fromRGB(255, 184, 162)
	TextButton.FontSize = Enum.FontSize.Size14
	TextButton.TextSize = 14
	TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.Text = "TEST"
	TextButton.TextWrap = true
	TextButton.Font = Enum.Font.SourceSansBold
	TextButton.TextWrapped = true
	TextButton.TextScaled = true
	TextButton.Parent = Frame

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 25)
	UICorner.Parent = TextButton

	ScreenGui.Parent = player:WaitForChild("PlayerGui")

	local conn
	conn = TextButton.MouseButton1Click:Connect(function()
		TextButton.Text = "Teleporting to test..."
		
		local lastPlace = DataController:GetValue({ "SlotData", "LastWorld" })
		
		lastPlace = (lastPlace == "Game_Menu") and "Vesk_Forest" or lastPlace
		
		print(TravelModule)
		
		TravelModule.RequestTravel(player, lastPlace)
	end)
end