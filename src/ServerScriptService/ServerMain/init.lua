--@@ Author .Trix

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local fabricLibrary = require(replicatedStorage:WaitForChild("Fabric"))

---init fabric
local fabric = fabricLibrary.Fabric.new("SERVER")
fabricLibrary.useReplication(fabric)
fabricLibrary.useTags(fabric)

fabric:registerUnitsIn(script.Units)