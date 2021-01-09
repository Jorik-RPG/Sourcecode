local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FabricLib = require(ReplicatedStorage.Packages.fabric)

local fabric = FabricLib.Fabric.new("CLIENT")
FabricLib.useReplication(fabric)
FabricLib.useTags(fabric)
FabricLib.useBatching(fabric)

fabric.DEBUG = false

fabric:registerUnitsIn(ReplicatedStorage.Packages.Components)