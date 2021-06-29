local AssetLibrary = {
	Name = "AssetLibrary";	
} do
	AssetLibrary._IsLoaded = false

	function AssetLibrary.GetAsset(path)
		path = string.split(path, ".")

		if not path then return nil end

		local asset = nil

		repeat wait() until AssetLibrary._IsLoaded == true

		for _, pathString in ipairs(path) do
			if asset then
				asset = asset:WaitForChild(pathString)
			else
				asset = script:WaitForChild(pathString)
			end
		end

		return asset
	end

	function AssetLibrary.Load()
		if #script:GetChildren() > 0 then AssetLibrary._IsLoaded = true return end
		if not game:GetService("RunService"):IsServer() then repeat wait() until script:FindFirstChildWhichIsA("Folder") end
		if #script:GetChildren() > 0 then AssetLibrary._IsLoaded = true return end

		pcall(function()
			game.InsertService:LoadAsset(6778267459).AssetLibrary.Parent = script
		end)

		for _, child in ipairs(script:FindFirstChildWhichIsA("Folder"):GetChildren()) do
			if not child:IsA("Folder") then continue end

			child.Parent = script
		end

		script:FindFirstChildWhichIsA("Folder"):Destroy()

		AssetLibrary._IsLoaded = true
	end
end

AssetLibrary.Load()

return AssetLibrary