--@@ Author 4thAxis
--/1/14/2021

--[[
    Camera Framework Directory

    Usage:

    Example:
]]

local CameraFramework = {}
local CombatCamera = script.CombatCamera


function CameraFramework.CameraEffects()
    return require( script.CameraEffects )
end


function CameraFramework.BattleCamera()
    return require( CombatCamera.BattleCamera )
end


function CameraFramework.FinisherCamera()
    return require( CombatCamera.FinisherCameraScenes )
end


function CameraFramework.MagicCamera()
    return ( CombatCamera.MagicCameraScenes )
end


return CameraFramework