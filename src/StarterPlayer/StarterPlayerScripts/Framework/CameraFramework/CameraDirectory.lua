--@@ Author 4thAxis

local Directory = {}

function Directory.Fetch(Module)
    return script[Module]
end

return Directory