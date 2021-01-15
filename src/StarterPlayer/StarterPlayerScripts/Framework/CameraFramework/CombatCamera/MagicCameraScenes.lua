--@@ Author 4thAxis
--/1/14/2021

local FinisherCam = {}
FinisherCam.__index = FinisherCam

function FinisherCam.new(Camera)
    Camera = Camera or error("");

    return setmetatable({
        Camera = Camera

    }, FinisherCam)
end



return FinisherCam
