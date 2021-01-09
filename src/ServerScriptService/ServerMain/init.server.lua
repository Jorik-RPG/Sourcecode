--@@ Author .Trix

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local FabricLib = require(ReplicatedStorage.Packages:WaitForChild("fabric"))

---init fabric
local fabric = FabricLib.Fabric.new("example")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)

print(fabric)
fabric:registerComponentsIn(script.Components)