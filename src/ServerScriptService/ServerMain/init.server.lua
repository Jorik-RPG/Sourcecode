--@@ Author .Trix, DylWithlt

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local FabricLib = require(ReplicatedStorage.Packages:WaitForChild("fabric"))

---init fabric
local fabric = FabricLib.Fabric.new("SERVER")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)
fabric.DEBUG = RunService:IsStudio()

fabric:registerUnitsIn(script.Units)