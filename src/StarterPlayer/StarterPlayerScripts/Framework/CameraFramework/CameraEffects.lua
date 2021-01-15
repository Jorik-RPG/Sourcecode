--@@ Author 4thAxis
--/1/14/2021

local BattleCam = {}
BattleCam.__index = BattleCam

function BattleCam.new(Camera)
    Camera = Camera or error("");

    return setmetatable({
        Camera = Camera

    }, BattleCam)
end

function BattleCam:LockToPlayer()
    
end


function BattleCam:SwirlAround()

end


return BattleCam
