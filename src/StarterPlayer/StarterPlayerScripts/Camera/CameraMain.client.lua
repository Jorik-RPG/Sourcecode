-- --@@ Author Axis, Dyl, Trix

-- -- Going to rewrite this soon, very ugly --

-- -- Services
-- local ContextActionService = game:GetService("ContextActionService")
-- local UserInputService     = game:GetService("UserInputService")
-- local RunService           = game:GetService("RunService")
-- local Players              = game:GetService("Players")

-- -- Object references
-- local camera       = workspace.CurrentCamera
-- local cameraOffset = Vector3.new() -- subject to change
-- local player       = Players.LocalPlayer

-- -- this is just all useless allocaton dyl
-- -- why not just index all on one line sheesh
-- -- nah yall got like 60 inch wide monitors so its fine
-- -- your guy's casings were trash, just name your variables directly so you still have context, with your casing patterns it reflect inconsistency in code nerd
-- -- its inconsistent if your creating like 26 interchanging patterns in casing
-- -- Just have someone change my casing after I finish my code lol

-- -- bro I swear, i suck at front end
-- -- The backend is where it is at
-- -- player.CharacterAdded:Connect(function(character)
-- --     local humanoid = character:WaitForChild("Humanoid")
-- --     local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
-- --     humanoid.AutoRotate = false

-- --     local cameraAngleX, cameraAngleY = 0, 0
-- --     ContextActionService:BindAction("PlayerInput", function(actionName, inputState, inputObject)
-- --         -- swear the stupid LSP
-- --         if inputState == Enum.UserInputState.Change then
-- --             cameraAngleX = cameraAngleX - inputObject.Delta.X
-- --             cameraAngleY = math.clamp(cameraAngleY - inputObject.Delta.Y * .4, -75, 75)

-- --             humanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-inputObject.Delta.X), 0)
-- --         end
-- --     end, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

-- --     RunService.RenderStepped:Connect(function() -- idk this is just for testing
-- --         if camera.CameraType ~= Enum.CameraType.Scriptable then
-- --             camera.CameraType = Enum.CameraType.Scriptable
-- --         end

-- --         local startCFrame = CFrame.new( (rootPart.CFrame.Position) ) * CFrame.Angles(0, math.rad(cameraAngleX), 0) * CFrame.Angles(math.rad(cameraAngleY), 0, 0)
-- -- 		local cameraCFrame = startCFrame:ToWorldSpace( CFrame.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z) )
-- -- 		local cameraFocus = startCFrame:ToWorldSpace( CFrame.new(cameraOffset.X, cameraOffset.Y, -10000) )
-- -- 		camera.CFrame = CFrame.new(cameraCFrame.Position, cameraFocus.Position)
-- --     end)
-- -- end)

-- -- local function focusControl(actionName, inputState, inputObject)
-- -- 	-- Lock and hide mouse icon on input began
-- -- 	if inputState == Enum.UserInputState.Begin then
-- -- 		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
-- -- 		UserInputService.MouseIconEnabled = false
-- -- 		ContextActionService:UnbindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)
-- -- 	end
-- -- end
-- -- ContextActionService:BindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)

-- local Players              = game:GetService("Players")
-- local ContextActionService = game:GetService("ContextActionService")
-- local UserInputService     = game:GetService("UserInputService")
-- local RunService           = game:GetService("RunService")

-- local camera               = workspace.CurrentCamera
-- local cameraOffset         = Vector3.new(2, 2, 8)
-- local player               = Players.LocalPlayer

-- player.CharacterAdded:Connect(function(character)

-- 	local humanoid = character:WaitForChild("Humanoid")
-- 	local rootPart = character:WaitForChild("HumanoidRootPart")
-- 	humanoid.AutoRotate = false

-- 	local cameraAngleX = 0
-- 	local cameraAngleY = 0

-- 	local function playerInput(actionName, inputState, inputObject)
-- 		-- Calculate camera/player rotation on input change
-- 		if inputState == Enum.UserInputState.Change then
-- 			cameraAngleX = cameraAngleX - inputObject.Delta.X
-- 			-- Reduce vertical mouse/touch sensitivity and clamp vertical axis
-- 			cameraAngleY = math.clamp(cameraAngleY-inputObject.Delta.Y*0.4, -75, 75)
-- 			-- Rotate root part CFrame by X delta
-- 			rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(-inputObject.Delta.X), 0)
-- 		end
-- 	end
-- 	ContextActionService:BindAction("PlayerInput", playerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

-- 	RunService.RenderStepped:Connect(function()
-- 		if camera.CameraType ~= Enum.CameraType.Scriptable then
-- 			camera.CameraType = Enum.CameraType.Scriptable
-- 		end
-- 		local startCFrame = CFrame.new((rootPart.CFrame.Position)) * CFrame.Angles(0, math.rad(cameraAngleX), 0) * CFrame.Angles(math.rad(cameraAngleY), 0, 0)
-- 		local cameraCFrame = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z))
-- 		local cameraFocus = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, -10000))
-- 		camera.CFrame = CFrame.new(cameraCFrame.Position, cameraFocus.Position)
-- 	end)
-- end)

-- local function focusControl(actionName, inputState, inputObject)
-- 	-- Lock and hide mouse icon on input began
-- 	if inputState == Enum.UserInputState.Begin then
-- 		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
-- 		UserInputService.MouseIconEnabled = false
-- 		ContextActionService:UnbindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)
-- 	end
-- end
-- ContextActionService:BindAction("FocusControl", focusControl, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)