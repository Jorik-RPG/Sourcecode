local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FabricLib = require(ReplicatedStorage.Packages.Fabric)
local Roact = require(ReplicatedStorage.Modules.Roact)

local fabric = FabricLib.Fabric.new("example")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)
FabricLib.useBatching(fabric)
FabricLib.useRoact(fabric, Roact)

fabric.DEBUG = RunService:IsStudio()

fabric:registerUnitsIn(ReplicatedStorage.Packages.Units)