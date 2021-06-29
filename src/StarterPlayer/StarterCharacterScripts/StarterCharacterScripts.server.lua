script.Parent:WaitForChild("Humanoid").Died:Connect(function()
	local Effect
	
	for i,v in ipairs(script.Parent:GetChildren()) do
		if v:IsA("BasePart") then
			v.BrickColor = BrickColor.new("Medium red")
			v.Transparency = 0.8
			v.Anchored = true
		end
	end
	
	for i,v in ipairs(script.Parent:GetChildren()) do
		if v:IsA("Shirt") or v:IsA("Pants") then
			v:Destroy()
		end
	end
	
	for i,v in ipairs(script.Parent:GetChildren()) do
		if v:IsA("Accessory") then
			v:Destroy()
		end
	end
	
	for i,v in ipairs(script.Parent.Head:GetChildren()) do
		if v:IsA("Decal") then
			v:Destroy()
		end
	end
	
	for i,v in ipairs(script.Parent:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			
			Effect = script.Particles:Clone()
			Effect.Parent = v
			
			v.BrickColor = BrickColor.new("Medium red")
			v.Transparency = 1 
			
			wait(0.01)
		end
	end
	
	Effect.Enabled = true
	
	wait(0.5)
	
	Effect.Enabled = false
end)