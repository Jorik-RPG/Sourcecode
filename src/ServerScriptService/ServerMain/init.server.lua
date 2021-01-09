--@@ Author .Trix

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local FabricLib = require(ReplicatedStorage.Packages:WaitForChild("Fabric"))

---init fabric
local fabric = FabricLib.Fabric.new("example")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)

print(fabric)
fabric:registerUnitsIn(script.Units)