--@@ Author Axis

--[[
    All Metaobjects passed to the class constructor should have the following attributes:

        Weight          = 0,    -- The weight of the item, decreases walkspeed.
        Damage          = 0,    -- The damage dealt by the sword.
        SwingAnimations = {},   -- Swing Animations.

        ItemInstance    = ""    -- The instance of the item.
]]


local SwordClass = {
    EquipAnimations = {}
}
SwordClass.__index = SwordClass


function SwordClass.new(Metaobject) -- .new( Metaobject: table )
    Metaobject = type(Metaobject) == "table" and Metaobject or error("SwordClass.new: Failed to correctly send the Metaobject argument.")

    return setmetatable(Metaobject, SwordClass)
end


function SwordClass:PlayEquippedAnimation()
    --[[
        Plays a random equip animation either specifically from the sword object or from the class.
    ]]

    local EquipAnimation = self.EquipAnimation or math.random(1, #SwordClass.EquipAnimations)
end


function SwordClass:Swing()

end
return SwordClass
