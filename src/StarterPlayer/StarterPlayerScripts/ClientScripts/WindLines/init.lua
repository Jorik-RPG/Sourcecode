function Run()
	local Camera = workspace.CurrentCamera
	local RunService = game:GetService("RunService")

	local WIND_DIRECTION = Vector3.new(math.random(-1, 1),0,0.3)
	local WIND_SPEED = 10
	local WIND_POWER = 1


	local WindLines = require(script.WindLines)
	local WindShake = require(script.WindShake)

	WindLines:Init({
		Direction = WIND_DIRECTION;
		Speed = WIND_SPEED;
		Lifetime = 1.5;
		SpawnRate = 5;
	})

	WindShake:Init()
	WindShake:SetDefaultSettings({
		Speed = WIND_SPEED;
		Direction = WIND_DIRECTION;
		Power = WIND_POWER;
	})

	----// Services
	--local Workspace = game:GetService("Workspace")

	----// Objects
	--local Trees = Workspace.Place:WaitForChild("Tree")

	----// Functions
	----// Add an object to shake
	--local function AddObject(Object)
	--	if Object.Name == "Leaf" then
	--		WindShake:AddObjectShake(Object)
	--	end
	--end

	----// Loop through the specified parent to find shakeable objects
	--local function LoopThrough(Parent)
	--	print(Parent.Name)
	--	for _, Object in ipairs(Parent:GetDescendants()) do
	--		AddObject(Object)
	--	end
	--end

	----// Detect newly added objects to shake
	--local function OnDescendantAdded(Object)
	--	AddObject(Object)
	--end

	--LoopThrough(Trees)

	--Trees.DescendantAdded:Connect(OnDescendantAdded)
end

coroutine.wrap(Run)()

return true