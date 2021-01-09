local DOOR_OPEN_ANGLE = 90
local RunService = game:GetService("RunService")
local Debounce = false

return {
	name = "Door";
	tag = "Door";

	units = {
		Replicated = {};
	};

	onInitialize = function(self)
		self.cd = Instance.new("ClickDetector")
		self.cd.Parent = self.ref

		self.cd.MouseClick:Connect(function()
			if self.running then return end
			self.running = true

			local door = self.ref

			local hinge = door.CFrame * CFrame.new(-door.Size.X/2, 0, 0)

			for i = 1, DOOR_OPEN_ANGLE do
				hinge = hinge * CFrame.Angles(0,math.rad(self.open and 1 or -1),0)
				local newCF = hinge * CFrame.new(door.Size.X/2, 0, 0)

				self:getUnit("Transmitter"):sendWithPredictiveLayer({
					CFrame = newCF
				}, "setCFrame", newCF)
				
				RunService.RenderStepped:Wait()
			end

			self.open = not self.open
			self.running = false
		end)

	end;

	batch = function(on)
		return {
			-- on.spreadInterval(5, function()
			-- 	local color = BrickColor.random()
			-- 	return function(unit)
			-- 		unit:addLayer("e", {
			-- 			color = color
			-- 		})
			-- 	end
			-- end),
		}
	end,

	onUpdated = function(self)

	end,

	effects = {
		-- Each effect only runs if the key it accesses with :get actually changes
		function(self)
			self.ref.CFrame = self:get("CFrame") or self.ref.CFrame
		end
	}
}