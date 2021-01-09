local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FabricLib = require(ReplicatedStorage.Packages.Fabric)

local fabric = FabricLib.Fabric.new("CLIENT")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)
FabricLib.useBatching(fabric)

fabric.DEBUG = RunService:IsStudio()

fabric:registerUnitsIn(ReplicatedStorage.Packages.Units)