--@@ Author 4thAxis

-- Services --

local RunService             = game:GetService('RunService')
local UserInputService       = game:GetService('UserInputService')
local PlayersService         = game:GetService('Players')
local StarterPlayer          = game:GetService('StarterPlayer')

-- Modules --

local RootCamera             = script:WaitForChild('RootCamera')

local AttachCamera           = require( RootCamera:WaitForChild('AttachCamera') ) ()
local FixedCamera            = require( RootCamera:WaitForChild('FixedCamera') ) ()
local ScriptableCamera       = require( RootCamera:WaitForChild('ScriptableCamera' )) ()
local TrackCamera            = require( RootCamera:WaitForChild('TrackCamera') ) ()
local WatchCamera            = require( RootCamera:WaitForChild('WatchCamera') ) ()

local ClassicCamera          = require( RootCamera:WaitForChild('ClassicCamera') ) ()
local FollowCamera           = require( RootCamera:WaitForChild('FollowCamera') ) ()
local PopperCam              = require( script:WaitForChild('PopperCam') )
local Invisicam              = require( script:WaitForChild('Invisicam') )
local ClickToMove            = require( script:WaitForChild('ClickToMove') ) ()
local TransparencyController = require( script:WaitForChild('TransparencyController') ) ()


Instance.new("BoolValue", script).Name = "Default" -- Haha im using the parent argument

local GameSettings = UserSettings().GameSettings
local AllCamerasInLua = false

local success, msg = pcall(function() AllCamerasInLua = UserSettings():IsUserFeatureEnabled("UserAllCamerasInLua") end)
local _ = not success and print("Couldn't get feature UserAllCamerasInLua because:" , msg) 

local CameraTypeEnumMap = {
	[Enum.CameraType.Attach]     = AttachCamera;
	[Enum.CameraType.Fixed]      = FixedCamera;
	[Enum.CameraType.Scriptable] = ScriptableCamera;
	[Enum.CameraType.Track]      = TrackCamera;
	[Enum.CameraType.Watch]      = WatchCamera;
	[Enum.CameraType.Follow]     = FollowCamera;
}

local EnabledCamera     = nil
local EnabledOcclusion  = nil

local currentCameraConn = nil
local renderSteppedConn = nil

local lastInputType     = nil
local hasLastInput      = false

local function IsTouch()
	return UserInputService.TouchEnabled
end

local function shouldUsePlayerScriptsCamera()
	local player = PlayersService.LocalPlayer
	local currentCamera = workspace.CurrentCamera

	return ( 
			( AllCamerasInLua and true ) or ( player and not currentCamera or ( currentCamera and currentCamera.CameraType == Enum.CameraType.Custom ) and true )
			
			or nil -- return false/nil if all conditions were disregarded
		)
end

local function isClickToMoveOn()
	local usePlayerScripts = shouldUsePlayerScriptsCamera()
	local player = PlayersService.LocalPlayer

	if usePlayerScripts and player then
		-- Touch
		if hasLastInput and lastInputType == Enum.UserInputType.Touch or UserInputService.TouchEnabled then
			return true
		-- Computer
		elseif player.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or player.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice and GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
			return true
		end
	end

	return nil
end

local function getCurrentCameraMode()
	local usePlayerScripts = shouldUsePlayerScriptsCamera()
	local player = PlayersService.LocalPlayer

	if usePlayerScripts and player then
		if isClickToMoveOn() then
			return Enum.DevComputerMovementMode.ClickToMove.Name

		elseif player.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice then
			local computerMovementMode = GameSettings.ComputerCameraMovementMode

			return ( computerMovementMode == Enum.ComputerCameraMovementMode.Default and Enum.ComputerCameraMovementMode.Classic.Name ) or computerMovementMode.Name

		else
			return player.DevComputerCameraMode.Name
		end
	end
end

local function getCameraOcclusionMode()
	local usePlayerScripts = shouldUsePlayerScriptsCamera()
	local player = PlayersService.LocalPlayer

	return ( usePlayerScripts and player and player.DevCameraOcclusionMode ) --or nil
end

local function Update()
	local _  = EnabledCamera and EnabledCamera:Update() and EnabledCamera:ApplyVRTransform()
	local _ = EnabledOcclusion and EnabledOcclusion:Update()
	local _ = shouldUsePlayerScriptsCamera and TransparencyController:Update()

end

local function SetEnabledCamera(newCamera)
	if EnabledCamera ~= newCamera then
		local _ = EnabledCamera and EnabledCamera:SetEnabled(false)
		EnabledCamera = newCamera

		local _ = EnabledCamera and EnabledCamera:SetEnabled(true)
	end
end

local function OnCameraMovementModeChange(newCameraMode)
	if newCameraMode == Enum.DevComputerMovementMode.ClickToMove.Name then
		ClickToMove:Start()
		SetEnabledCamera(nil)
		TransparencyController:SetEnabled(true)
	else
		local currentCameraType = workspace.CurrentCamera and workspace.CurrentCamera.CameraType
		
		if (currentCameraType == Enum.CameraType.Custom or not AllCamerasInLua) and newCameraMode == Enum.ComputerCameraMovementMode.Classic.Name then
			SetEnabledCamera(ClassicCamera)
			TransparencyController:SetEnabled(true)
		elseif (currentCameraType == Enum.CameraType.Custom or not AllCamerasInLua) and newCameraMode == Enum.ComputerCameraMovementMode.Follow.Name then
			SetEnabledCamera(FollowCamera)
			TransparencyController:SetEnabled(true)

		elseif AllCamerasInLua and CameraTypeEnumMap[currentCameraType] then
			SetEnabledCamera(CameraTypeEnumMap[currentCameraType])
			TransparencyController:SetEnabled(false)

		else -- Our camera movement code was disabled by the developer
			SetEnabledCamera(nil)
			TransparencyController:SetEnabled(false)
		end
		ClickToMove:Stop()
	end

	local newOcclusionMode = getCameraOcclusionMode()

	if EnabledOcclusion == Invisicam and newOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
		Invisicam:Cleanup()
	end

	if newOcclusionMode == Enum.DevCameraOcclusionMode.Zoom then
		EnabledOcclusion = PopperCam
	elseif newOcclusionMode == Enum.DevCameraOcclusionMode.Invisicam then
		EnabledOcclusion = Invisicam
	else
		EnabledOcclusion = false
	end
end

local function OnCameraTypeChanged(newCameraType)
	if newCameraType == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end


local function OnCameraSubjectChanged(newSubject)
	TransparencyController:SetSubject(newSubject)
end

local function OnNewCamera()
	OnCameraMovementModeChange(getCurrentCameraMode())

	local currentCamera = workspace.CurrentCamera
	if currentCamera then
		if currentCameraConn then
			currentCameraConn:disconnect()
		end
		currentCameraConn = currentCamera.Changed:connect(function(prop)
			if prop == 'CameraType' then
				OnCameraMovementModeChange(getCurrentCameraMode())
				OnCameraTypeChanged(currentCamera.CameraType)
			elseif prop == 'CameraSubject' then
				OnCameraSubjectChanged(currentCamera.CameraSubject)
			end
		end)

		OnCameraSubjectChanged(currentCamera.CameraSubject)
		OnCameraTypeChanged(currentCamera.CameraType)
	end
end


local function OnPlayerAdded(player)
	workspace.Changed:connect(function(prop)
		if prop == 'CurrentCamera' then
			OnNewCamera()
		end
	end)

	player.Changed:connect(function(prop)
		OnCameraMovementModeChange(getCurrentCameraMode())
	end)

	GameSettings.Changed:connect(function(prop)
		OnCameraMovementModeChange(getCurrentCameraMode())
	end)

	RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, Update)

	OnNewCamera()
	OnCameraMovementModeChange(getCurrentCameraMode())
end

do
	while PlayersService.LocalPlayer == nil do wait() end
	hasLastInput = pcall(function()
		lastInputType = UserInputService:GetLastInputType()
		UserInputService.LastInputTypeChanged:connect(function(newLastInputType) 
			lastInputType = newLastInputType
		end)
	end)
	OnPlayerAdded(PlayersService.LocalPlayer)
end

local mousedefault = script.Default

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.M then --Enum.KeyCode.[Key you want]
		if mousedefault.Value == false then
			mousedefault.Value = true
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		else
			mousedefault.Value = false
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end
		
	end
end)


